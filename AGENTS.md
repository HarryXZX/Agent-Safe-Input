# AGENTS.md

Instructions for an AI agent that has SSH access to a host through Agent-Safe-Input.

**Read this before you run anything that needs root.**

---

## 0. Skill package

The same contract also ships as an Agent Skill: [`skills/agent-safe-input/SKILL.md`](skills/agent-safe-input/SKILL.md).
Clients that support the [Agent Skills](https://agentskills.io/specification) format (Claude Code,
WorkBuddy, …) load it automatically when a task turns privileged — install with `./install-skill.sh`.

This file stays the tool-agnostic contract: Codex, Gemini CLI and Copilot read `AGENTS.md` directly.
If both are present they agree; the skill adds trigger keywords and a workflow checklist, not new rules.

## 1. What you have

| Capability | Status |
|---|---|
| SSH to the target host | ✅ key-based, passwordless |
| Read / write your home directory, build, pull code, run tests | ✅ |
| `sudo` | ❌ it will ask for a password, and **you do not have one** |
| `agent-safe-input queue` / `list` / `show` / `result` | ✅ |
| `agent-safe-input run` / `purge` | ❌ human-only (requires a TTY) |

You are not "broken" or under-privileged by accident. The asymmetry is the design: you can
do the work, you cannot move the foundations.

## 2. When you need root

Do **not** try `sudo`, `pkexec`, `su`, guessed passwords, or editing `/etc/sudoers`.
All of those waste turns and none of them can succeed.

Batch everything a task needs into **one** script and queue it:

```bash
agent-safe-input queue install-build-deps <<'EOS'
apt-get update
apt-get install -y --no-install-recommends build-essential cmake ninja-build
EOS
# stdout → 20261112-134107-install-build-deps
```

Then tell the human, in one short message:

> Queued `20261112-134107-install-build-deps`. Please run:
> `agent-safe-input run 20261112-134107-install-build-deps`

**Batch aggressively.** Ten small requests = ten interruptions. One request that covers the
whole task is the goal. If you must split, split by *decision* ("install deps" then
"configure service"), not by *command*.

## 3. Reading the outcome

Poll the result file — never guess from a log:

```bash
agent-safe-input result 20261112-134107-install-build-deps
```

```ini
status=success    # ran, exit 0        → read <id>.log for output
status=failed     # non-zero/SSH error → read <id>.log, fix, re-queue under a NEW name
status=cancelled  # the human said no  → nothing ran, the script is still queued
```

**Match on `status=` only.** Its value is always one of those three English words, whatever the
interface language. `message=` is written for the human and may be Chinese, Japanese, German… —
never parse it, never translate it back into a decision.

The same applies to your own prose: answer in the language the human writes to you, and never
drift into whatever locale the tool happened to print. Localised output is theirs to read, not a
cue for you to switch language.

Rules for `cancelled`:

- It means **the human declined**, not that something broke.
- Do **not** re-queue the same thing automatically.
- Do **not** ask "why did it fail?" — it did not fail.
- Ask once, plainly: "I see you cancelled `install-build-deps`. Want me to change
  something, or drop it?"

Exit codes mirror this: `0` success, `2` cancelled, anything else = failure.

## 4. Hard rules

1. **Never ask for, accept, or repeat the password.** If the human pastes it anyway, do not
   use it, do not echo it, and tell them to rotate it — it is already in the transcript.
2. **Never write `NOPASSWD`** to `sudoers`, and never suggest the human do it "just for this
   session". If a whitelist is genuinely the right call, say so explicitly with the exact
   binary and the revocation command, and let them decide.
3. **Never put secrets in a queued script.** The script is stored on the remote disk
   (`0600`) and printed to the human's terminal. No tokens, no private keys, no passwords.
   Fetch secrets at runtime, or let the human inject them.
4. **Never call `agent-safe-input run`.** It refuses without a TTY, and trying is noise. The human
   runs it.
5. **The script you queue must be readable.** Add a one-line comment at the top explaining
   the purpose; it is shown as the title in `agent-safe-input list` — that line is what the human
   reads before approving.

## 5. Good request shape

```bash
agent-safe-input queue add-32bit-toolchain <<'EOS'
# Purpose: enable i386 multiarch + gcc-multilib so `gcc -m32` works
dpkg --add-architecture i386
apt-get update
apt-get install -y --no-install-recommends gcc-multilib g++-multilib libc6-dev-i386
EOS
```

Why this is good: one purpose, states why, only the commands that need root, no unrelated
"while I'm here" changes, no secrets.

## 6. Known pitfalls

- **`ssh -n` and stdin**: anything that pipes a file into the remote shell must *not* use
  `-n` (it replaces stdin with `/dev/null`). Agent-Safe-Input handles this internally; if you write
  your own helper, remember it.
- **Non-interactive SSH does not load `~/.bashrc`**: if a command needs environment
  variables, run it through `bash -lc '...'`.
- **Long jobs**: run them inside `tmux`/`screen` on the host so an SSH hiccup does not kill
  the build, then read the log later.
- **The queue survives reboots** (it is just files). A cancelled or stale script stays until
  someone purges it — do not assume the queue is empty.
