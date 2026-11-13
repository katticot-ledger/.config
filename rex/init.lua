-- Rex key bindings migrated from tmux, Herdr and Ghostty.
-- Sources: ~/.tmux.conf, ~/.config/tmux/tmux.conf (sourced by it),
-- ~/.config/herdr/config.toml, ~/.config/ghostty/config.

-- tmux prefix is ctrl+b; it starts every sequence below, so programs that
-- use ctrl+b themselves still receive it via this passthrough.
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })

-- tmux: session switching (~/.config/tmux/tmux.conf:89-92)
rex.bind("ctrl+b>b", "session.switch")
rex.bind("ctrl+b>o", "session.switch")
rex.bind("ctrl+b>p", "session.switch")
rex.bind("ctrl+b>f", "session.switch")

-- tmux: config reload (~/.config/tmux/tmux.conf:95)
rex.bind("ctrl+b>shift+r", "client.config.reload")

-- tmux: window and pane management (~/.config/tmux/tmux.conf:98-99)
rex.bind("ctrl+b>shift+7", "client.tab.close")
rex.bind("ctrl+b>x", "pane.close")

-- tmux: vim-style pane navigation (~/.config/tmux/tmux.conf:105-108)
rex.bind("ctrl+b>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+b>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+b>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+b>l", "pane.focus", { direction = "right" })

-- tmux: arrow-key pane navigation
rex.bind("ctrl+b>left", "pane.focus", { direction = "left" })
rex.bind("ctrl+b>down", "pane.focus", { direction = "down" })
rex.bind("ctrl+b>up", "pane.focus", { direction = "up" })
rex.bind("ctrl+b>right", "pane.focus", { direction = "right" })

-- Close keys: cmd+w closes the focused pane (safe, granular);
-- shift+cmd+w closes the whole tab. Window close stays in the palette.
rex.bind("cmd+w", "pane.close")
rex.bind("shift+cmd+w", "client.tab.close")

-- Copy block ID to clipboard
rex.bind("ctrl+b>i", "pane.copy_id")
rex.bind("shift+cmd+c", "pane.copy_id")

-- Helper to create agent pane
local function agent_pane(cmd, label)
  return rex.layout.block({
    flavor = "com.superlogical.terminal.shell",
    label = label,
    options = {
      command = cmd,
      exit = { on_completion = false },
    }
  })
end

-- Layout: 3 agents (1 large left, 2 stacked right)
local function layout_3_agents()
  local right = rex.layout.vertical(0.5,
    agent_pane({ "codex" }, "codex"),
    agent_pane({ "pi" }, "pi")
  )
  return rex.layout.horizontal(0.5,
    agent_pane({ "claude" }, "claude"),
    right
  )
end

-- Layout: 4 agents (2x2 grid)
local function layout_4_agents()
  local top = rex.layout.horizontal(0.5,
    agent_pane({ "claude" }, "claude"),
    agent_pane({ "codex" }, "codex")
  )
  local bottom = rex.layout.horizontal(0.5,
    agent_pane({ "agy" }, "agy"),
    agent_pane({ "pi" }, "pi")
  )
  return rex.layout.vertical(0.5, top, bottom)
end

-- Fleet mode: exclusive so only 3, 4, or Escape do anything
rex.mode("fleet", { exclusive = true })

rex.action({
  name = "agents_3",
  title = "Open 3 Agents",
  run = function(ctx)
    return rex.session.new_window({
      session_id = ctx.session_id,
      window_label = "agents-3",
      layout = layout_3_agents(),
    })
  end
})

rex.action({
  name = "agents_4",
  title = "Open 4 Agents",
  run = function(ctx)
    return rex.session.new_window({
      session_id = ctx.session_id,
      window_label = "agents-4",
      layout = layout_4_agents(),
    })
  end
})

-- Ctrl+b 4 enters fleet mode for 1 keypress
rex.bind("ctrl+b>4", "client.mode.enter", { name = "fleet", once = true })

-- Choices inside fleet mode
rex.bind("fleet/3", "agents_3")
rex.bind("fleet/4", "agents_4")

-- ==========================================
-- OpenRig Picker (Prefix: Ctrl+b r)
-- ctrl+b r enters the exclusive "openrig" key
-- mode for ONE keypress (once = true). Rex's
-- mode popup auto-shows the options — no click,
-- no card, no state. 1/2/3 launch rig windows
-- natively; Escape closes.
-- ==========================================

rex.mode("openrig", { exclusive = true })

local function openrig_launch(window_label, command)
  return function(ctx)
    local w, err = rex.session.new_window({
      window_label = window_label,
      layout = {
        block = {
          flavor = "com.superlogical.terminal.shell",
          label = window_label,
          options = {
            command = command,
            exit = { on_completion = false }
          }
        }
      }
    })
    if err ~= nil then error(err, 0) end
    return { window_id = w.window_id }
  end
end

local picker_active = false

rex.action({
  name = "openrig_picker",
  title = "OpenRig Picker",
  run = function(ctx)
    -- once = true: the mode leaves after a single keypress, so it
    -- can never outlive the picker or hijack the keyboard.
    if ctx.origin == "key" or ctx.origin == "palette" then
      picker_active = true
      -- Bigger font while the picker is up; restored on every exit path.
      rex.client.queue("client.font.increase")
      rex.client.queue("client.font.increase")
      rex.client.queue("client.mode.enter", { name = "openrig", once = true })
    end
  end
})

-- Restore the font on every way out of the picker.
local function openrig_font_restore(ctx)
  if picker_active then
    picker_active = false
    if ctx.origin == "key" or ctx.origin == "palette" then
      rex.client.queue("client.font.decrease")
      rex.client.queue("client.font.decrease")
    end
  end
end

rex.action({
  name = "openrig_kernel",
  title = "⚙ Kernel",
  run = function(ctx)
    openrig_font_restore(ctx)
    return openrig_launch("rig-kernel", { "rig", "attach" })(ctx)
  end
})

rex.action({
  name = "openrig_review",
  title = "🔍 Review",
  run = function(ctx)
    openrig_font_restore(ctx)
    return openrig_launch("rig-review", { "rig", "up", "code-review", "--existing" })(ctx)
  end
})

rex.action({
  name = "openrig_dashboard",
  title = "⚡ Dashboard",
  run = function(ctx)
    openrig_font_restore(ctx)
    return openrig_launch("rig-tui", { "rig", "tui" })(ctx)
  end
})

-- ==========================================
-- Rig Cockpit (Control Window)
-- 4 panes:
-- Left (50%): rig tui
-- Right top (25%): rigops watch --notify
-- Right mid (30%): queue-watch.sh starter
-- Right bot (45%): shell in ~/Developer/experiments/sbx-rig
-- ==========================================

local function layout_rig_cockpit()
  local home = os.getenv("HOME")
  local top_right = rex.layout.vertical(0.45,
    rex.layout.block({
      flavor = "com.superlogical.terminal.shell",
      label = "rigops",
      options = {
        command = { "bun", home .. "/.local/bin/rigops", "watch", "--notify" },
        exit = { on_completion = false },
      }
    }),
    rex.layout.block({
      flavor = "com.superlogical.terminal.shell",
      label = "queue",
      options = {
        command = { home .. "/Developer/experiments/sbx-rig/queue-human.sh" },
        exit = { on_completion = false },
      }
    })
  )

  local right = rex.layout.vertical(0.55,
    top_right,
    rex.layout.block({
      flavor = "com.superlogical.terminal.shell",
      label = "agy",
      options = {
        cwd = home .. "/Developer/experiments/sbx-rig",
        command = { home .. "/.local/bin/agy" },
        exit = { on_completion = false },
      }
    })
  )

  return rex.layout.horizontal(0.5,
    rex.layout.block({
      flavor = "com.superlogical.terminal.shell",
      label = "dashboard",
      options = {
        command = { "rig", "tui" },
        exit = { on_completion = false },
      }
    }),
    right
  )
end

local function openrig_cockpit_run(ctx)
  local session_id = ctx.session_id
  if not session_id or session_id == "" then
    local sessions = rex.call("session.list")
    if sessions and sessions.sessions then
      for _, s in ipairs(sessions.sessions) do
        if s.label == "openrig-seats" or s.label == "rig-comms" then
          session_id = s.session_id
          break
        end
      end
    end
  end

  -- If control window already exists in session, focus it
  if session_id and session_id ~= "" then
    local view = rex.session.view({ session_id = session_id })
    if view and view.windows then
      for _, w in ipairs(view.windows) do
        if w.label == "control" then
          if ctx.client_id then
            rex.client.queue("session.select", { session_id = session_id, window_id = w.window_id })
          end
          return { window_id = w.window_id }
        end
      end
    end
  end

  return rex.session.new_window({
    session_id = session_id,
    window_label = "control",
    layout = layout_rig_cockpit(),
  })
end

rex.action({
  name = "rig_cockpit",
  title = "🕹 Cockpit",
  run = function(ctx)
    openrig_font_restore(ctx)
    return openrig_cockpit_run(ctx)
  end
})

rex.action({
  name = "human_inbox",
  title = "📥 Human Inbox",
  description = "Open interactive human inbox for keita@external",
  run = function(ctx)
    local home = os.getenv("HOME")
    openrig_font_restore(ctx)
    return rex.session.new_window({
      session_id = ctx.session_id,
      window_label = "inbox",
      layout = {
        block = {
          flavor = "com.superlogical.terminal.shell",
          label = "human-inbox",
          options = {
            command = { home .. "/Developer/experiments/sbx-rig/queue-human.sh" },
            exit = { on_completion = false },
          }
        }
      }
    })
  end
})

-- Escape closes the picker AND restores the font (needs a binding
-- so the reset runs; with once = true the mode still leaves).
rex.action({
  name = "openrig_cancel",
  title = "Close",
  run = function(ctx)
    openrig_font_restore(ctx)
  end
})

rex.bind("openrig/1", "openrig_kernel")
rex.bind("openrig/2", "openrig_review")
rex.bind("openrig/3", "openrig_dashboard")
rex.bind("openrig/4", "rig_cockpit")
rex.bind("openrig/5", "rig_cockpit")
rex.bind("openrig/c", "rig_cockpit")
rex.bind("openrig/q", "rig_cockpit")
rex.bind("openrig/escape", "openrig_cancel")

rex.bind("ctrl+b>r", "openrig_picker")
rex.bind("ctrl+b>c", "rig_cockpit")
rex.bind("ctrl+b>q", "rig_cockpit")

-- rex-agentd autostart: spawn the auto-resume daemon, DETACHED so Rex's
-- context-end reaper cannot kill it (verified: detach=true survives config
-- load, server restarts, and server shutdown). The watcher re-injects pinned
-- agents into restored empty panes, re-keys pins across restarts, reconnects
-- when the server restarts, and holds a lock so this re-spawn on every config
-- (re)load is a no-op while an instance is alive. If it is ever killed, any
-- config reload (ctrl+b shift+r) revives it; when it is alive, the reload
-- SIGHUPs it so it re-runs its resume pass immediately.
do
    local home = os.getenv("HOME")
    -- Signal a live daemon so a config reload re-runs resume_all; verify the
    -- pid still belongs to rex-agentd (never signal a recycled pid).
    local f = io.open(home .. "/.local/state/rex-agents/agentd.lock", "r")
    if f then
        local pid = f:read("*l")
        f:close()
        if pid and pid:match("^%s*%d+%s*$") then
            -- anchored match: the command must BE a shell running exactly the
            -- daemon script (a bare substring would also match an editor or a
            -- `tail -f` on the daemon file with the same recycled pid)
            pcall(rex.exec, {
                "/bin/sh", "-c",
                "ps -p " .. pid .. " -o command= 2>/dev/null | " ..
                "grep -qE '^(/bin/)?sh .*config/rex/bin/rex-agentd$' && kill -HUP " .. pid
            })
        end
    end
    local ok, handle = pcall(rex.exec.start,
        {home .. "/.config/rex/bin/rex-agentd"},
        {detach = true})
    rex_agentd_handle = ok and handle or nil
    if not ok then rex.log("rex-agents watcher spawn failed: " .. tostring(handle)) end
end

-- Rename windows via Jev (ctrl+b then shift+j), shown in a floating popup
rex.action({
  name = "rename_with_jev",
  title = "Rename windows with Jev",
  run = function(ctx)
    local script = "/Users/keita/.gemini/antigravity-cli/brain/ed297c29-7f04-4c08-a9d4-42fc9e2fb7ab/scratch/rename_with_jev.py"
    local cmd = 'echo "Renaming windows with Jev..."; echo; '
      .. 'if /opt/homebrew/bin/uv run --with typesafe-sdk "$0"; then echo; echo "Jev rename done"; '
      .. 'else echo; echo "Jev rename FAILED"; fi; sleep 4'
    return rex.call("session.new_layer", {
      session_id = ctx.session_id,
      bounds = { 0.15, 0.15, 0.7, 0.7 },
      focus = true,
      layout = rex.layout.block({
        flavor = "com.superlogical.terminal.shell",
        label = "jev-rename",
        options = { command = { "sh", "-c", cmd, script } },
      }),
    })
  end
})

rex.bind("ctrl+b>shift+j", "rename_with_jev")
