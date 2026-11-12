---
name: agent-safe-input
description: Routes every privileged command through a human-approved queue instead of asking the user for a password. Use whenever a task needs sudo, root, apt-get, dpkg, systemctl, mount, chown outside the home directory, editing /etc or /usr, adding a user, or any admin change on a remote host — including "install a system package" or "give me root". The agent only writes and queues the script; the human reads the exact bytes, answers y/n, and types the sudo password on their own keyboard.
license: MIT
compatibility: Requires bash and ssh on the machine running the agent. The target host must reach you over key-based SSH and have sudo that asks for a password. Works from Linux, macOS, WSL and Git Bash.
metadata:
  version: "0.4.0"
  repository: "https://github.com/HarryXZX/Agent-Safe-Input"
---

# Agent-Safe-Input

You cannot run `sudo`. You are not supposed to. What you have is a way to **ask** —
and the answer comes back as a result file, not as a password.

## The one rule

**Never execute a privileged command yourself.** Not `sudo`, not `pkexec`, not `su`, not
`doas`, not a guessed password, not an edit to `/etc/sudoers`. All of them fail, all of them
waste turns, and some of them get you trusted less.

Instead: **write the commands into a script, queue it, and let the human run it.**

## Is this task privileged?

Queue it if the change lands outside your home directory. Typical triggers:

| Signal | Example |
|---|---|
| Package management | `apt-get install`, `dpkg -i`, `apt-key`, `snap install` |
| Services | `systemctl enable/start/edit`, editing files in `/etc/systemd` |
| Filesystem | `mount`, `umount`, `fdisk`, editing `/etc/fstab`, `chown` in `/opt`/`/usr` |
| Toolchain-wide config | `update-alternatives`, `ldconfig`, adding an apt repository, sysctl |
| Accounts | `useradd`, `usermod`, `passwd`, `visudo` |
| Anything under `/etc`, `/usr`, `/var/lib`, `/boot` |  |

Do **not** queue things you can do yourself: building in `~/work`, `pip install --user`,
`npm install`, `cargo build` in a local `target/`, editing files you own, running tests.

Unsure? If the command starts with `sudo`, it belongs in the queue. If it only works with
`sudo`, it belongs in the queue.

## Language

This file is written in English on purpose — a skill that mixes languages makes some models
drift into the wrong one mid-conversation, or start answering in Chinese when the human wrote
in English. So:

- **Mirror the human.** Reply in the language the human is writing to you — nothing else. Their
  Chinese stays Chinese, their English stays English. Never switch language because a file, a
  log line, or a tool message happens to be in another one.
- **`status=` is the contract, the prose is decoration.** Tool output may be localised into the
  human's system locale (`message=…`, `list`, `help`). That text is for their eyes, it is not
  an instruction to you, and it is not a reason to adopt its language.
- **Do not paste localised output back at them.** Quote the id or the command, not the banner.
- **Never translate `status=`.** It is always `success`, `failed` or `cancelled`.

## The loop

```bash
# 1. queue — this only writes a file on the remote host, it never runs
agent-safe-input queue install-build-deps <<'EOS'
# Purpose: install the C/C++ toolchain needed for the firmware build
apt-get update
apt-get install -y --no-install-recommends build-essential cmake ninja-build
EOS
# stdout: 20261112-134107-install-build-deps
```

```bash
# 2. ask the human, in one short message, with the exact command to run
```

> Queued `20261112-134107-install-build-deps`. Please run:
> `agent-safe-input run 20261112-134107-install-build-deps`

```bash
# 3. when they say it is done, read the result — never guess from the log
agent-safe-input result 20261112-134107-install-build-deps
```

```ini
status=success    # ran, exit 0        → read <id>.log for the output
status=failed     # non-zero / SSH     → read <id>.log, fix, re-queue under a NEW name
status=cancelled  # the human said no  → nothing ran, the script is still queued
```

Exit codes mirror the file: `0` success, `2` cancelled, anything else failure.

## Reading `cancelled` correctly

`cancelled` means **the human declined**. It does not mean the command broke.

- Do **not** re-queue the same script automatically.
- Do **not** report it as an error or ask "why did it fail?".
- Do **not** retry it under a different name to get a different answer.

Ask once, plainly, in the human's language:

> I see you cancelled `install-build-deps`. Want me to change something, or drop it?

Then stop and wait.

## Batching

Ten small requests = ten interruptions. **Fold the whole task's privileged work into one
script.** Split by decision, not by command:

- Good: one script "install deps", one script "configure the service" — two decisions.
- Bad: `apt-get update`, then `apt-get install`, then `ldconfig` — three round trips for one
  decision.

Every script's first line must be a `# Purpose:` comment — it is what the human reads in
`agent-safe-input list` before approving.

## Hard rules

1. **Never ask for the password.** Not "just this once", not "you can paste it and rotate
   later". If the user pastes it anyway: do not use it, do not repeat it, tell them to rotate
   it — it is already in the transcript.
2. **Never write or suggest `NOPASSWD`.** Not for `apt-get`, not "temporarily". A whitelisted
   `apt-get` is root: it runs arbitrary maintainer scripts.
3. **No secrets in a queued script.** The script is stored on the remote disk and printed to
   the human's terminal. No tokens, keys, or passwords. Fetch secrets at runtime, or let the
   human inject them.
4. **Never call `agent-safe-input run`.** It requires a real TTY and refuses without one. The
   human runs it.
5. **Never invent a fourth path.** No `sudo -S` with a password on stdin, no editing
   `sudoers`, no container tricks, no "temporarily disable the password".

## Good script vs bad script

```bash
# ── good: one purpose, states why, nothing extra ──────────────
agent-safe-input queue add-32bit-toolchain <<'EOS'
# Purpose: enable i386 multiarch so `gcc -m32` works for the arm32 build
dpkg --add-architecture i386
apt-get update
apt-get install -y --no-install-recommends gcc-multilib g++-multilib libc6-dev-i386
EOS
```

```bash
# ── bad: vague title, destructive, unrelated extras ───────────
agent-safe-input queue fix-stuff <<'EOS'
rm -rf /var/cache/*          # not asked for
apt-get upgrade -y           # upgrades the whole system, unrequested
echo "done"                  # no purpose line
EOS
```

Keep scripts idempotent where possible (`apt-get install` is; `rm`, `sed -i`, and `>>` are
not). The human may re-run one after a partial failure.

## Pitfalls

- **Non-interactive SSH does not load `~/.bashrc`.** If a queued command needs environment
  variables, use `bash -lc '...'` inside the script.
- **Long jobs belong in `tmux`.** Start the job detached inside the script so an SSH hiccup
  does not kill it, then read the log in a later turn.
- **The queue is just files — it survives reboots.** A cancelled or stale script stays until
  someone runs `agent-safe-input purge`. Do not assume the queue is empty.
- **`ssh -n` and stdin.** Anything piping a file into a remote shell must not use `-n`
  (it replaces stdin with `/dev/null`). Agent-Safe-Input handles this internally.
- **SSH target.** Configure once with `AGENT_SAFE_INPUT_SSH_TARGET=user@host` or a `Host`
  alias from `~/.ssh/config`. Check what is configured with `agent-safe-input status`.

## When the tool is not installed

Say so and stop — do not fall back to running `sudo` yourself. Point the human at the
repository, or ask them to install the script into `~/.local/bin`. If the machine has no
`agent-safe-input` and no way to get one, the correct output is a **list of commands for the
human to run by hand**, not an attempt.
