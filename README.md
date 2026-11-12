# Agent-Safe-Input

**Let an AI agent do privileged work — safely.**
The agent writes the command. You approve it. You type the password, and it never leaves
your keyboard.

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20WSL%20%7C%20Git%20Bash-lightgrey)

---

## The problem

You want an AI agent to build, test and deploy on a remote box. It needs `apt-get`,
`systemctl`, a mount, a `chown` on `/opt`. Today there are only three options, and all of
them are bad:

| Option | What goes wrong |
|---|---|
| Give the agent `NOPASSWD: ALL` | One prompt injection, one hallucinated `rm -rf`, and the agent owns the machine. It can rewrite `sshd`, add keys, exfiltrate everything. |
| Paste your password into the chat | It is now in the transcript file, in backups, in the provider's logs. Forever. Rotating it is the only fix. |
| Do every `sudo` yourself, by hand | Breaks long autonomous runs: the agent stalls at every third command, waiting for you. |

Agent-Safe-Input splits the job where it naturally splits:

- **The agent** can do everything that does not need root — and when it does need root,
  it can only *describe* it: write a script into a queue on the remote host.
- **You** review that script and authenticate it with your own password, on your own
  terminal. The password never enters the agent's context, the shell history, a log file,
  or the repository.

## How it works

```
┌─────────────┐  1. agent-safe-input queue install-deps <<EOS      ┌─────────────────────┐
│   Agent     │ ──────────────────────────────────────────▶ │  remote host        │
│  (no root)  │      gets back: 20261112-134107-install-…   │  ~/.agent-safe-input/queue │
└─────────────┘                                             │   <id>.sh   (0600)  │
                                                            └──────────┬──────────┘
                                                                       │
┌─────────────┐  2. agent-safe-input run <id>                                 │
│   Human     │ ◀──────────────────────────────────────────────────────┘
│             │  3. sees the FULL script, types y, then types the sudo password
└─────────────┘
       │        4. results land next to the script:
       └──────▶    <id>.log  (output)   <id>.result  (status=success|failed|cancelled)
```

The agent polls `agent-safe-input result <id>` and continues — it learns *that* it succeeded,
never *how* to authenticate.

## Install

```bash
git clone https://github.com/HarryXZX/Agent-Safe-Input.git
mkdir -p ~/.local/bin && cp Agent-Safe-Input/bin/agent-safe-input ~/.local/bin/
# make sure ~/.local/bin is on PATH

# optional: a short alias, because the full name is a mouthful
echo "alias asi=agent-safe-input" >> ~/.bashrc
```

Requirements:

- `bash` and `ssh` on the machine that runs `agent-safe-input` (Linux, macOS, WSL, Git Bash)
- key-based SSH to the target host (**the agent uses a key, not a password**)
- `sudo` on the target that asks for a password (i.e. **no** `NOPASSWD`)

## Configure

`~/.config/agent-safe-input/config` (all keys optional):

```ini
SSH_TARGET=user@192.168.1.10
SSH_ARGS=-F ~/.ssh/config-vm
REMOTE_DIR=~/.agent-safe-input/queue
```

Environment variables win over the file: `AGENT_SAFE_INPUT_SSH_TARGET`, `AGENT_SAFE_INPUT_SSH_ARGS`,
`AGENT_SAFE_INPUT_REMOTE_DIR`, `AGENT_SAFE_INPUT_CONFIG_FILE`.

`SSH_TARGET` can be any `user@host` **or** a `Host` alias from your `~/.ssh/config`.

## Quickstart

```bash
# ── the agent does this ─────────────────────────────────────────────
export AGENT_SAFE_INPUT_SSH_TARGET=user@192.168.1.10

agent-safe-input queue install-build-deps <<'EOS'
apt-get update
apt-get install -y --no-install-recommends build-essential cmake ninja-build
EOS
# stdout: 20261112-134107-install-build-deps

# ── you do this, in your own terminal ───────────────────────────────
agent-safe-input list                       # what is waiting
agent-safe-input show 20261112-134107-install-build-deps
agent-safe-input run  20261112-134107-install-build-deps
#   → prints the whole script again
#   → "执行请输 y（yes），取消请输 n（no）:"   type y
#   → "[sudo] password for you:"              type your password (not echoed)
```

## Commands

| Command | Who runs it | What it does |
|---|---|---|
| `agent-safe-input queue <name> [--] 'cmd'` | agent | Queue a script (also accepts a heredoc on stdin). Prints the new `<id>`. **Never executes.** |
| `agent-safe-input list` | either | List pending scripts with their purpose and size |
| `agent-safe-input show <id>` | either | Print one script in full |
| `agent-safe-input run [id]` | **human** | Show, confirm, then run with `sudo` — the password prompt comes from `sudo` itself |
| `agent-safe-input result <id>` | agent | Print the result file (`status=…`) |
| `agent-safe-input purge` | human | Empty the queue and remove outputs |
| `agent-safe-input status` | either | Show config and how many scripts are pending |

Interaction accepts exactly four words, **case-insensitive**: `y` / `yes` = run,
`n` / `no` = cancel. Anything else (empty line included) is ignored and re-asked, so a
typo never kills the run. Running with no id and exactly one queued script skips the
picker entirely.

### Exit codes

| Code | Meaning |
|---|---|
| `0` | Success |
| `2` | **Cancelled by the human** — nothing was executed, the script stays queued |
| other | Failure (SSH error, wrong password, or the script itself failed) |

## Result contract

Every run writes `<id>.result` next to the script:

```ini
id=20261112-134107-install-build-deps
status=cancelled
at=2026-11-12T13:41:13+0800
message=用户取消了操作，脚本未执行，仍在队列里
```

`status` is one of:

- `success` — ran and exited 0 (output in `<id>.log`)
- `failed` — non-zero exit, SSH failure, or wrong password (output in `<id>.log`)
- `cancelled` — **the human said no**. Nothing ran. This is not an error.

This is the whole point of the result file: an agent cannot tell "cancelled" from
"failed" by looking at an empty log, and a cancelled job must not be silently retried.

## Security model

What Agent-Safe-Input guarantees:

- **The password is never seen by the agent.** `sudo` reads it from the remote TTY. It is
  not passed as an argument, not stored, not echoed, not logged.
- **No password cache is left behind.** `sudo -k` runs before *and* after every execution,
  so the 15-minute timestamp window cannot be reused by another session of the same user.
- **Scripts are stored `0600`** in a `0700` directory on the remote host.
- **Non-interactive invocation is refused.** `agent-safe-input run` requires a real TTY, so an
  automation (or an agent) cannot trigger it headlessly.
- **The human sees the exact bytes that will run**, printed before the confirmation prompt.

What it does **not** do:

- It does not sandbox the script. If you approve `apt-get install`, that is root.
- It does not review the script *for* you. Read what is printed. A malicious or
  prompt-injected agent can write a malicious script — the gate is your eyes, not a linter.
- It does not protect you from approving everything on autopilot. The security value is
  exactly the attention you pay at the `y/n` prompt.

Threat model in one line: **protects against an agent that has SSH access and a key** —
not against a human who stopped reading.

## For AI agents

This repository ships [`AGENTS.md`](AGENTS.md) — a contract an agent can read before
touching a privileged command. The short version:

> You have a key, not a password. Batch privileged work into one script with
> `agent-safe-input queue`, then ask the human to run `agent-safe-input run <id>`. Never ask for the
> password, never write to `sudoers`, and treat `status=cancelled` as "the human said no" —
> not as a failure to retry.

## Windows launcher

`windows/agent-safe-input-window.bat` — double-click to open a terminal that runs
`agent-safe-input run` and stays open afterwards. Requires Git for Windows (provides `bash` and
`mintty`). Useful when the agent runs headless and cannot pop a window itself.

## FAQ

**Why not just `NOPASSWD` for a few binaries?**
A whitelist of `apt-get`/`systemctl` is still root: `apt-get` runs arbitrary maintainer
scripts, `systemctl edit` drops files in `/etc`. A temporary whitelist can be a deliberate
choice for a trusted batch job — but it should be a decision you make per task and revoke,
not a permanent configuration.

**Why not have the agent run `sudo -S` with the password on stdin?**
Then the password is in the agent's context, in the shell history, and in whatever log
captures stdin. That is exactly the leak this tool exists to prevent.

**Does it work if `sudo` is passwordless (containers, CI)?**
Yes — the tool then degrades into a pure review gate: the script still has to be approved
by a human before it runs. The result contract and audit trail are unchanged.

**Can two people/agents share a queue?**
The queue is per-remote-user (`~/.agent-safe-input/queue`). Different `REMOTE_DIR` values give
you separate queues.

## License

MIT — see [LICENSE](LICENSE).

中文说明见 [README.zh-CN.md](README.zh-CN.md)。
