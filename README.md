# Agent-Safe-Input

> **让 Agent 安全地输入口令。**
> Agent 写命令，你过一眼，你在自己的终端里输 `sudo` 口令——口令只经过你的键盘。
>
> **Let an AI agent do privileged work — safely.**
> The agent writes the command. You approve it. You type the password, and it never leaves
> your keyboard.

**语言 / Language:** [中文](#中文) · [English](#english)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20WSL%20%7C%20Git%20Bash-lightgrey)

---

# 中文

## 要解决的问题

你让 AI Agent 在远程机器上编译、测试、部署。它需要 `apt-get`、`systemctl`、一次
`mount`、一个 `/opt` 下的 `chown`。现在只有三种做法，全都不好：

| 做法 | 后果 |
|---|---|
| 给 Agent `NOPASSWD: ALL` | 一次提示词注入、一次幻觉出来的 `rm -rf`，整台机器就归它了：改 `sshd`、加公钥、把数据传走 |
| 把口令贴进对话 | 口令进了会话记录文件、备份、服务商日志——永久留下。只能靠改口令补救 |
| 每条 `sudo` 都你亲手敲 | 长任务被打断成碎片，Agent 每三条命令就卡住等你 |

Agent-Safe-Input 把这件事从中间切开：

- **Agent** 能干一切不需要 root 的活；真需要 root 时，它只能**描述**：把要做的事写成
  脚本，放进远端的一个队列里。
- **你** 看这个脚本，用**你自己的**口令在自己的终端上认证。口令不进 Agent 的上下文、
  不进 shell 历史、不进日志、不进仓库。

## 工作方式

```
┌─────────────┐  ① agent-safe-input queue install-deps <<EOS      ┌─────────────────────┐
│   Agent     │ ──────────────────────────────────────────▶ │  远端主机           │
│  （无 root）│      返回：20261112-134107-install-deps     │  ~/.agent-safe-input/queue │
└─────────────┘                                             │   <id>.sh   (0600)  │
                                                            └──────────┬──────────┘
                                                                       │
┌─────────────┐  ② agent-safe-input run <id>                                 │
│   人        │ ◀──────────────────────────────────────────────────────┘
│             │  ③ 看到**完整脚本** → 输 y → 输 sudo 口令
└─────────────┘
       │        ④ 结果落在脚本旁边：
       └──────▶    <id>.log（输出）   <id>.result（status=success|failed|cancelled）
```

Agent 轮询 `agent-safe-input result <id>` 就能继续干活：它只知道**成没成**，永远不知道
**怎么认证**。

## 安装

```bash
git clone https://github.com/HarryXZX/Agent-Safe-Input.git
mkdir -p ~/.local/bin && cp Agent-Safe-Input/bin/agent-safe-input ~/.local/bin/
# 确认 ~/.local/bin 在 PATH 里

# 可选：名字有点长，加个别名
echo "alias asi=agent-safe-input" >> ~/.bashrc
```

依赖：

- 跑 `agent-safe-input` 的机器上有 `bash` 和 `ssh`（Linux / macOS / WSL / Git Bash 均可）
- 到目标机的 **SSH 密钥登录**（Agent 用密钥，不用口令）
- 目标机的 `sudo` **需要口令**（也就是没有 `NOPASSWD`）

## 配置

`~/.config/agent-safe-input/config`（三项都可省）：

```ini
SSH_TARGET=user@192.168.1.10
SSH_ARGS=-F ~/.ssh/config-vm
REMOTE_DIR=~/.agent-safe-input/queue
```

环境变量优先于配置文件：`AGENT_SAFE_INPUT_SSH_TARGET`、`AGENT_SAFE_INPUT_SSH_ARGS`、
`AGENT_SAFE_INPUT_REMOTE_DIR`、`AGENT_SAFE_INPUT_CONFIG_FILE`。

`SSH_TARGET` 可以是 `user@host`，也可以是 `~/.ssh/config` 里的 `Host` 别名。

## 快速上手

```bash
# ── Agent 这半边 ────────────────────────────────────────────────
export AGENT_SAFE_INPUT_SSH_TARGET=user@192.168.1.10

agent-safe-input queue install-build-deps <<'EOS'
apt-get update
apt-get install -y --no-install-recommends build-essential cmake ninja-build
EOS
# 标准输出：20261112-134107-install-build-deps

# ── 人这半边，在你自己的终端里 ──────────────────────────────────
agent-safe-input list                       # 看有什么在等
agent-safe-input show 20261112-134107-install-build-deps
agent-safe-input run  20261112-134107-install-build-deps
#   → 再打一遍完整脚本
#   → "执行请输 y（yes），取消请输 n（no）："  输 y
#   → "[sudo] password for you:"               输口令（不回显）
```

## 命令

| 命令 | 谁用 | 作用 |
|---|---|---|
| `agent-safe-input queue <名字> [--] '命令'` | Agent | 把脚本排进队列（也可用 heredoc 从 stdin 读）。打印 `<id>`，**不执行** |
| `agent-safe-input list` | 都行 | 列出待执行脚本、用途、大小 |
| `agent-safe-input show <id>` | 都行 | 打印某条脚本全文 |
| `agent-safe-input run [id]` | **人** | 显示 → 确认 → 用 `sudo` 执行，口令提示由 `sudo` 自己发 |
| `agent-safe-input result <id>` | Agent | 读结果文件（`status=…`） |
| `agent-safe-input purge` | 人 | 清空队列和历史输出 |
| `agent-safe-input status` | 都行 | 显示配置与待执行条数 |

交互确认只认四个词、**不分大小写**：`y` / `yes` 执行，`n` / `no` 取消。其它任何输入
（包括空回车、手滑打错）都**忽略并重问**，所以打错字不会把流程弄崩。不带 id 运行且队列
只有一条时，直接跳过选号。

### 退出码

| 码 | 含义 |
|---|---|
| `0` | 成功 |
| `2` | **人取消了操作** —— 什么都没执行，脚本仍在队列里 |
| 其它 | 失败（SSH 错误、口令错、或脚本本身报错） |

## 结果契约

每次执行都会在脚本旁写 `<id>.result`：

```ini
id=20261112-134107-install-build-deps
status=cancelled
at=2026-11-12T13:41:13+0800
message=用户取消了操作，脚本未执行，仍在队列里
```

`status` 三种：

- `success` —— 执行完、退出码 0（输出在 `<id>.log`）
- `failed` —— 非 0 退出、SSH 失败、或口令错（输出在 `<id>.log`）
- `cancelled` —— **人拒绝了**。什么都没跑。这不是错误。

这个文件是整个设计的关键：Agent 无法从一份空的日志里分辨「人拒绝了」和「跑失败了」，
而被拒绝的任务**绝不该**被悄悄重试。

## 安全模型

保证这些：

- **Agent 永远看不到口令**。`sudo` 从远端 TTY 读它——不作为参数传递、不存储、不回显、
  不入日志。
- **不留口令缓存**。执行前后各一次 `sudo -k`，那 15 分钟的时间戳窗口无法被同一账户的
  其它会话复用。
- **脚本 `0600`**，放在远端 `0700` 目录下。
- **拒绝非交互调用**。`agent-safe-input run` 要求真 TTY，自动化（或 Agent）没法无头触发。
- **人看到的就是将要执行的字节**，在确认提示之前完整打印。

不保证这些：

- 不做沙箱。你批准了 `apt-get install`，那就是 root 权限。
- 不替你做代码审查。**要读屏幕上打出来的脚本**。一个被提示词注入的 Agent 完全可以写
  一个恶意脚本——这道闸门是你的眼睛，不是 linter。
- 不能保护「无脑全按 y」的人。它的安全价值，恰好等于你在 y/n 提示前付出的注意力。

一句话威胁模型：**防的是「有 SSH 密钥的 Agent」**，不是「已经不看内容的人」。

## 给 AI Agent 的说明

仓库里带 [`AGENTS.md`](AGENTS.md)，Agent 动特权命令前应当先读。要点：

> 你只有密钥、没有口令。把需要 root 的活**攒成一个脚本**用 `agent-safe-input queue` 排队，
> 然后请人执行 `agent-safe-input run <id>`。永远不要索要口令、不要碰 `sudoers`；
> `status=cancelled` 表示「人拒绝了」，不是「失败了要重试」。

## Windows 启动器

`windows/agent-safe-input-window.bat` —— 双击弹出一个终端跑 `agent-safe-input run`，跑完不自动关窗。
需要 Git for Windows（提供 `bash` 和 `mintty`）。适用于 Agent 本身是无头进程、没法自己
弹窗的场景。

## 常见问题

**为什么不给几个二进制开 `NOPASSWD` 白名单？**
`apt-get`/`systemctl` 的白名单等价于 root：`apt-get` 会执行任意维护脚本，`systemctl edit`
能往 `/etc` 里丢文件。临时白名单可以是你对某个可信批量任务的主动选择，但应当是「按任务
开、用完撤」，而不是长期配置。

**为什么不让 Agent 用 `sudo -S` 把口令喂给 stdin？**
那口令就进了 Agent 的上下文、shell 历史、以及一切捕获 stdin 的日志。这正是本工具要堵的
泄漏。

**目标机 `sudo` 本来就免密（容器、CI）怎么办？**
照样可用——它退化成一个纯审查闸门：脚本仍然必须由人批准才会执行。结果契约和审计链路不变。

**多个 Agent 能共用一个队列吗？**
队列是按远端用户放的（`~/.agent-safe-input/queue`）。给不同的 `REMOTE_DIR` 就是不同的队列。

---

# English

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

---

## License / 许可

MIT — see [LICENSE](LICENSE) / 见 [LICENSE](LICENSE)。
