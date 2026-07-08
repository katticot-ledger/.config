import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import * as git from "./git";

// ─── Conventional-commit JSON schema prompt ───────────────────────────────────
const SYSTEM_PROMPT = `You are an expert at writing git commit messages following the Conventional Commits specification.
Your response MUST be ONLY a valid JSON object — no markdown, no explanation, no preamble.

Schema:
{
  "type": "feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert",
  "scope": "optional short noun describing the section of codebase",
  "description": "short imperative summary, max 72 chars, no period at end",
  "body": "optional — explain what and why, not how",
  "footer": "optional — BREAKING CHANGE: ... or Fixes #123"
}`;

function buildUserPrompt(diff: string, staged: string[]): string {
  return `Generate a conventional commit message for these changes.

Staged files:
${staged.map((f) => `- ${f}`).join("
")}

Git diff:
```diff
${diff}
````;
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
async function isCliAvailable(pi: ExtensionAPI, cli: string): Promise<boolean> {
  const { code } = await pi.exec("which", [cli], {});
  return code === 0;
}

function assembleMessage(parsed: {
  type: string;
  scope?: string;
  description: string;
  body?: string;
  footer?: string;
}): string {
  let msg = parsed.type;
  if (parsed.scope) msg += `(${parsed.scope})`;
  msg += `: ${parsed.description}`;
  if (parsed.body) msg += `

${parsed.body}`;
  if (parsed.footer) msg += `

${parsed.footer}`;
  return msg;
}

function heuristicMessage(staged: string[]): string {
  const count = staged.length;
  let type = "chore";
  if (staged.some((f) => /test/i.test(f))) type = "test";
  else if (staged.some((f) => /doc|readme/i.test(f))) type = "docs";
  else if (staged.some((f) => /fix|bug/i.test(f))) type = "fix";
  else if (count > 0) type = "feat";
  const scope =
    count === 1
      ? staged[0].split("/").pop()?.replace(/\.[^.]+$/, "") ?? "app"
      : "app";
  return `${type}(${scope}): update ${count} file${count > 1 ? "s" : ""}

${staged.map((f) => `- ${f}`).join("
")}`;
}

async function callLlm(
  pi: ExtensionAPI,
  cwd: string,
  diff: string,
  staged: string[]
): Promise<string | null> {
  if (!(await isCliAvailable(pi, "pi"))) return null;

  const fullPrompt = SYSTEM_PROMPT + "

" + buildUserPrompt(diff, staged);
  const { code, stdout } = await pi.exec("pi", ["-p", fullPrompt], {
    cwd,
  });
  if (code !== 0 || !stdout.trim()) return null;

  // Extract JSON object even if the LLM wraps it in backticks
  const match = stdout.match(/\{[\s\S]*\}/);
  if (!match) return null;

  try {
    const parsed = JSON.parse(match[0]);
    if (!parsed.type || !parsed.description) return null;
    return assembleMessage(parsed);
  } catch {
    return null;
  }
}

// ─── Public API ───────────────────────────────────────────────────────────────

/** Mode 1: generate message from a pre-computed diff + staged file list */
export async function generateCommitMessage(
  pi: ExtensionAPI,
  cwd: string,
  diff: string,
  staged: string[]
): Promise<string> {
  const llmResult = await callLlm(pi, cwd, diff, staged);
  return llmResult ?? heuristicMessage(staged);
}

/** Mode 2 (auto): gather ALL changed files, stage them, generate message */
export async function generateCommitMessageFromAllChanges(
  pi: ExtensionAPI,
  cwd: string
): Promise<{ message: string; allFiles: string[] }> {
  const status = await git.getStatus(pi, cwd);
  const allFiles = [
    ...status.staged,
    ...status.unstaged,
    ...status.untracked,
  ];

  if (allFiles.length === 0) {
    return { message: "chore: no changes", allFiles: [] };
  }

  // Stage all files first so getDiff captures everything
  await git.stageFiles(pi, cwd, allFiles);
  const diff = await git.getDiff(pi, cwd);

  const llmResult = await callLlm(pi, cwd, diff, allFiles);
  return { message: llmResult ?? heuristicMessage(allFiles), allFiles };
}
