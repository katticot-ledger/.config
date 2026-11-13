-- rex-say.lua — deliver text to another Rex block in one call.
-- Run it through the rex-say shim, which turns flags into KEY=VALUE args.
-- Exit: 0 sent, 3 queued (agent busy), 4 typed not submitted, 1 failed.

local a = rex.args or {}

local function truthy(v) return v == true or v == "true" end
local function fail(msg) print("failed: " .. msg); rex.stop(1) end
local function trim(s) return (s or ""):gsub("^%s+", ""):gsub("%s+$", "") end
local function clip(s, n)
  s = (s or ""):gsub("%s+", " ")
  n = n or 40
  if #s > n then s = s:sub(1, n - 1) .. "…" end
  return s
end

-- Prose is for a person; the caller branches on the exit code.
local function finish(line, code, warn, extra)
  print(line)
  if warn and warn ~= "" then print("warning: " .. warn) end
  if extra then print(extra) end
  rex.stop(code)
end

-- ---------- target ----------
local spec = a.block or a.target
if not spec or spec == "" then fail("no target: rex-say BLOCK ...") end

local okr, resolved = pcall(rex.call, "target.resolve", { kinds = { "block" }, queries = { spec } })
if not okr then fail("resolve: " .. tostring(resolved)) end
local r = resolved and resolved.results and resolved.results[1]
if not r then fail("resolve returned nothing") end

if r.status == "ambiguous" then
  local names = {}
  for _, c in ipairs(r.candidates or {}) do
    names[#names + 1] = (c.label ~= "" and c.label or "?") .. "@" .. ((c.block_id or ""):sub(-6))
  end
  fail(string.format("%q matches %d blocks (%s) — use the short id",
    spec, #(r.candidates or {}), table.concat(names, ", ")))
end
if r.status ~= "resolved" then fail(string.format("%q not found", spec)) end

local bid = r.target.block_id
local sid = r.target.session_id
local short = bid:sub(-6)

if bid == (os.getenv("REX_BLOCK") or "") and not truthy(a.self) then
  fail("that is my own block, where I am running (self=true to override)")
end

-- A script only reaches the session it hears. Attach to the target's when it differs.
if sid ~= (rex.session_id or "") then
  pcall(rex.session.attach, { session_id = sid })
  rex.sleep(0.2)
end

-- ---------- probe ----------
local function bcall(method, args)
  local ok, res = pcall(rex.call, "block.method",
    { session_id = sid, block_id = bid, method = method, args = args or {} })
  if not ok then return nil end
  return res
end

local AGENT = { claude = 1, pi = 1, codex = 1, agy = 1, opencode = 1, gemini = 1, crush = 1, droid = 1 }
local SHELL = { fish = 1, zsh = 1, bash = 1, sh = 1, dash = 1, ksh = 1, nu = 1, login = 1, tcsh = 1 }

local proc = bcall("process")
local prog = "unknown"
if proc and proc.foreground then
  for _, c in ipairs({ proc.foreground.argv0, proc.foreground.name, proc.foreground.path }) do
    if c and c ~= "" then
      local n = c:gsub("^.*/", ""):gsub("^%-+", "")
      if n ~= "" then prog = n; break end
    end
  end
end
local kind = AGENT[prog] and "agent" or (SHELL[prog] and "shell") or nil

local st, why = "idle", nil
local ps = bcall("program_status")
if ps and ps.records then
  for i = #ps.records, 1, -1 do
    local rec = ps.records[i]
    if rec.state and rec.state ~= "" then
      st = rec.state
      why = rec.kind
      break
    end
  end
end

-- ---------- guards ----------
if why == "auth" then fail("the program is asking for a password (state=blocked)") end
if (why == "permission" or why == "question") and not truthy(a.yes) then
  fail(string.format("the program is blocked on %s (yes=true to send anyway)", why))
end
if not kind and not truthy(a.force) then
  fail(string.format("unknown program %q (force=true to send anyway)", prog))
end

-- ---------- text ----------
local text = a.text
if a.file and a.file ~= "" then
  local fh = io.open(a.file, "r")
  if not fh then fail("no such file: " .. a.file) end
  fh:close()
  text = "Read " .. a.file
elseif not text or text == "" then
  fail("no text: pass TEXT, text=..., or --file PATH")
end

-- ---------- screen ----------
local function screen_lines(content)
  local lines = {}
  for line in ((content or "") .. "\n"):gmatch("([^\n]*)\n") do lines[#lines + 1] = line end
  while #lines > 0 and trim(lines[#lines]) == "" do table.remove(lines) end
  return lines
end

-- An empty input line is still drawn as something: pi pads it with a no-break
-- space, which a plain %s trim leaves in place and reads as typed text.
local BLANK_GLYPH = "[\194\160\226\128\139\239\187\191]" -- NBSP, zero-width space, BOM
local function prompt_trim(s)
  return trim((s or ""):gsub(BLANK_GLYPH, " "))
end

-- A program may draw its own empty box with example text rather than a blank
-- line. That text is not typed input, so it must not block a send.
local PLACEHOLDER = {
  codex = { "ask codex to do anything" },
  opencode = { "^ask anything%.%.%." }, -- 'Ask anything... "Fix broken tests"'

}
local HEAVY_BORDER = "\226\148\131" -- ┃, opencode's input border

-- Some inputs sit inside a drawn box: "┃  Ask anything…". Drop the border.
local function strip_border(t)
  local s = t
  while s:sub(1, 3) == HEAVY_BORDER do s = s:sub(4) end
  return (s:gsub("^%s+", ""))
end

local function prompt_text(s)
  local t = prompt_trim(s)
  local low = t:lower()
  for _, pat in ipairs(PLACEHOLDER[prog] or {}) do
    if low:find(pat) then return "" end
  end
  return t
end

-- A horizontal rule, optionally carrying a short embedded label ("── ✓ Working ──",
-- "──── NORMAL"). pi's editor has no prompt glyph, so its rule pair is the only cue.
local RULE_GLYPH = { ["─"] = true, ["━"] = true, ["═"] = true, ["╌"] = true,
  ["╍"] = true, ["┄"] = true, ["┅"] = true }

local function is_border(line)
  local t = trim(line or "")
  if t == "" then return false end
  local nrule, nchar = 0, 0
  for ch in t:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
    nchar = nchar + 1
    if RULE_GLYPH[ch] then nrule = nrule + 1 end
  end
  return nrule >= 10 and nrule / nchar >= 0.6
end

-- The input box of an agent that draws no marker: the lines between the rule
-- above it and the rule below it. Only trusted near the bottom of the screen,
-- where the editor always sits, and never taller than an editor grows.
local function boxed_prompt(lines)
  local lo = math.max(1, #lines - 11)
  local bottom
  for i = #lines, math.max(lo, #lines - 8), -1 do
    if is_border(lines[i]) then bottom = i; break end
  end
  if not bottom then return nil end
  local top
  for i = bottom - 1, lo, -1 do
    if is_border(lines[i]) then top = i; break end
  end
  if not top or bottom - top > 9 then return nil end
  local parts = {}
  for i = top + 1, bottom - 1 do
    local t = prompt_trim(lines[i])
    if t ~= "" then parts[#parts + 1] = t end
  end
  return prompt_trim(table.concat(parts, " "))
end

local function prompt_from(lines)
  if not lines or #lines == 0 then return nil end
  if kind == "shell" then
    -- A shell prompt ends in a marker; the input follows it on the last line.
    local last = lines[#lines]
    local pos = nil
    for i = 1, #last do
      local ch = last:sub(i, i)
      if ch == ">" or ch == "$" or ch == "%" or ch == "#" or ch == "❯" or ch == "»" then pos = i end
    end
    if pos then return trim(last:sub(pos + 1)) end
    return nil -- no prompt marker on the last line: not sitting at a prompt
  end
  -- An agent draws its input box near the bottom; the marker starts the line.
  -- Only the bottom rows count: a menu cursor (codex's "› 1. Update now") shares
  -- the glyph, and the real prompt is always the last thing above the footer.
  local lo = math.max(1, #lines - 11)
  for i = #lines, math.max(lo, #lines - 3), -1 do
    local t = trim(lines[i])
    for _, m in ipairs({ "❯", "›", ">", "│ >" }) do
      if t:sub(1, #m) == m then return prompt_text(t:sub(#m + 1)) end
    end
  end
  -- A bordered box (opencode): the run of ┃ lines holds the input at its top,
  -- and the box's own footer (model, hints) below it is not input.
  local run_lo, run_hi
  for i = #lines, lo, -1 do
    if trim(lines[i]):sub(1, 3) == HEAVY_BORDER then
      run_hi = run_hi or i
      run_lo = i
    elseif run_hi then
      break
    end
  end
  if run_hi then
    -- The first line that holds anything is the input, even when it turns out to
    -- be only a placeholder; the lines after it are the box's own footer.
    for i = run_lo, run_hi do
      local raw = strip_border(trim(lines[i]))
      if raw ~= "" then return prompt_text(raw) end
    end
    return "" -- the box is drawn and holds nothing
  end
  return boxed_prompt(lines)
end

local fmt = bcall("format", { format = "text", trim = true })
local content = (fmt and fmt.content) or ""
local lines = screen_lines(content)

for i = math.max(1, #lines - 3), #lines do
  if lines[i] and (lines[i]:find("[Pp]assword:%s*$") or lines[i]:find("%[sudo%]")) then
    fail("the pane shows a password prompt")
  end
end

local stray = prompt_from(lines)
if not kind then
  -- A forced unknown program: its prompt has no shape we know, so read nothing as input.
  stray = ""
elseif stray == nil and not truthy(a.force) then
  if kind == "shell" then
    fail("no shell prompt on screen (a command may be running; force=true to send anyway)")
  end
  fail("cannot find the input line (force=true to send anyway)")
end
stray = stray or ""

-- ---------- paste safety ----------
local modes = bcall("modes")
local bracketed = false
if modes and modes.modes then
  for _, m in ipairs(modes.modes) do
    if m.name == "bracketed_paste" and m.set then bracketed = true end
  end
end

local warn
if text:find("\n") then
  if not (kind == "agent" and bracketed) then
    text = text:gsub("%s*\n%s*", " ")
    warn = "multiline folded to one line for this program"
  end
end

if truthy(a.dry) then
  finish(string.format("%s  %s  %s  dry-run%s", short, prog, st,
    stray ~= "" and ("  [prompt has " .. clip(stray) .. "]") or ""), 0, warn)
end

-- ---------- send ----------
local function write(data) return bcall("write", { data = data }) end
local function paste(t)
  return pcall(rex.call, "block.event",
    { session_id = sid, block_id = bid, event = { type = "paste", payload = { text = t } } })
end
local function reread()
  local f = bcall("format", { format = "text", trim = true })
  return prompt_from(screen_lines((f and f.content) or ""))
end

-- Clear with keys each program actually binds. ctrl+a/ctrl+k are readline-only and
-- get inserted literally by some shells, which corrupts the line.
local function clear_prompt()
  if kind == "shell" then
    write("\3") -- ctrl+c at a prompt: abandon the whole line buffer
    rex.sleep(0.3)
    return
  end
  write("\21") -- ctrl+u: kill to start of line
  rex.sleep(0.25)
  local after = reread()
  if after and after ~= "" then
    write(string.rep("\127", #after + 4)) -- backspace the remainder
    rex.sleep(0.25)
  end
end

if stray ~= "" then
  if truthy(a.replace) then
    clear_prompt()
    local after = reread()
    if after and after ~= "" then fail("could not clear the prompt: " .. clip(after)) end
  elseif truthy(a.append) then
    if kind == "shell" then
      -- A shell draws its history suggestion into the same line, so what is on
      -- screen cannot be told apart from typed text. Clearing is the safe move.
      fail("in a shell the line may be typed text or a history suggestion; use replace=true")
    end
    write("\5") -- ctrl+e: end of line, so nothing lands mid-text
    rex.sleep(0.15)
    warn = "appended after existing " .. clip(stray)
  else
    fail(string.format("the prompt already holds %q, or a history suggestion (replace=true)", clip(stray)))
  end
elseif kind == "agent" then
  write("\5") -- ctrl+e is bound in agent input boxes; harmless when already at the end
  rex.sleep(0.1)
end

local paste_ok = paste(text)
if not paste_ok then fail("paste was refused by the server") end

local busy_before = (st == "working" or st == "blocked")
local do_enter = (kind == "agent")
if a.enter ~= nil and a.enter ~= "" then do_enter = truthy(a.enter) end
local head = clip(text, 14)
local function in_prompt(p)
  return p and p ~= "" and head ~= "" and p:find(head:sub(1, math.min(10, #head)), 1, true) ~= nil
end
if do_enter then
  rex.sleep(0.3)
  write("\r")
  rex.sleep(0.6)
  -- An Enter that lands inside a paste's escape sequence gets swallowed; retry once.
  if in_prompt(reread()) then
    write("\r")
    rex.sleep(0.6)
  end
end

-- ---------- verify ----------
rex.sleep(tonumber(a.wait or "") or (do_enter and 0.7 or 0.4))

local ps2 = bcall("program_status")
local st2 = st
if ps2 and ps2.records then
  for i = #ps2.records, 1, -1 do
    if ps2.records[i].state and ps2.records[i].state ~= "" then st2 = ps2.records[i].state; break end
  end
end
local now = reread()

local verdict, code
if not do_enter then
  verdict, code = "typed, not submitted", 4
elseif kind == "agent" and busy_before then
  verdict, code = "queued (agent busy)", 3
elseif in_prompt(now) then
  verdict, code = "text is still in the prompt", 1
else
  verdict, code = "sent", 0
end

local extra
if truthy(a.verbose) then
  local tail = {}
  for i = math.max(1, #lines - 7), #lines do tail[#tail + 1] = lines[i] end
  extra = "--- screen tail ---\n" .. table.concat(tail, "\n")
end

finish(string.format("%s  %s  %s  %s", short, prog, st2, verdict), code, warn, extra)
