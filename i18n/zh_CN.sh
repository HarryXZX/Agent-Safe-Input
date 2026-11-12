# zh_CN — 简体中文 / Simplified Chinese
# 由 agent-safe-input 自动加载；缺 key 会回落内置英文。

M_NO_TARGET='没有配置 SSH 目标。设环境变量 AGENT_SAFE_INPUT_SSH_TARGET=user@host，或写进 %s 的 SSH_TARGET= 一行（见 examples/config）。'
M_CONFIRM='继续？ '
M_EMPTY_INPUT='^ 没有输入内容。请输入 y 或 n。'
M_INVALID_INPUT='^ 只接受 y / yes / n / no，刚才的「%s」已忽略，请重新输入。'
M_NEED_TTY='需要在交互式终端里运行（stdin 不是终端）——否则没法输入 sudo 口令。'
M_NO_DEV_TTY='拿不到 /dev/tty，无法在这里提示口令。'
M_USAGE_QUEUE='用法: agent-safe-input queue <名字> [--] "命令"   或   agent-safe-input queue <名字> <<EOS … EOS'
M_MKTEMP='mktemp 失败'
M_EMPTY_BODY='脚本体是空的——要么跟在名字后面给命令，要么用 stdin 喂进来。'
M_HDR_PURPOSE='# 用途：%s'
M_HDR_QUEUED='# 由 agent-safe-input %s 入队于 %s'
M_HDR_HOW='# 执行方式：agent-safe-input run %s —— 由人确认脚本内容并输入自己的 sudo 口令'
M_QUEUE_FAIL='入队失败：检查 SSH 连接与 %s 是否可写。'
M_QUEUED='已入队 %s（未执行）。请人运行：agent-safe-input run %s'
M_EMPTY_QUEUE='队列为空——没有等待提权的任务。'
M_PENDING_HDR='待执行的 root 脚本：'
M_NO_TITLE='（无说明）'
M_BYTES='%s 字节'
M_LIST_HINT='看内容：agent-safe-input show <id>\n执行：  agent-safe-input run <id>'
M_USAGE_SHOW='用法: agent-safe-input show <id>'
M_NOT_IN_QUEUE='队列里没有 %s'
M_SHOW_END='结束'
M_USAGE_RESULT='用法: agent-safe-input result <id>'
M_PURGE_EMPTY='队列本来就是空的，无需清理。'
M_PURGE_CONFIRM='[agent-safe-input] 将删除队列里 %s 个脚本及其输出，输 y 确认、n 取消： '
M_PURGE_CANCEL_MSG='用户取消了操作，队列未清空'
M_PURGE_CANCEL='x 用户取消了操作，队列未清空。'
M_PURGE_DONE='已清空队列。'
M_RUN_EMPTY='队列为空，没有要执行的脚本。'
M_PICK_PROMPT='[agent-safe-input] 输入编号（1-%s）执行，输 n 取消： '
M_PICK_CANCEL_MSG='用户取消了操作，没有选择任何任务'
M_PICK_CANCEL='x 用户取消了操作：没有选择任何任务。'
M_PICK_INVALID='^ 请输入 1-%s 之间的编号，或输 n 取消（刚才的输入已忽略）。'
M_PICK_RANGE='^ 编号超出范围（只有 1-%s），请重新输入。'
M_PICK_MISS='^ 取不到第 %s 条，重来。'
M_RUN_MISSING='队列里没有 %s（agent-safe-input list 看现有 id）'
M_RUN_HDR='──────── 下面这个脚本将以 root 执行 ────────'
M_RUN_FTR='────────────────────────────────────────────'
M_RUN_NOTE='确认无误就输入 y 继续；不想跑就输入 n。'
M_RUN_CONFIRM='[agent-safe-input] 执行请输 y（yes），取消请输 n（no）： '
M_RUN_CANCEL_MSG='用户取消了操作，脚本未执行，仍在队列里'
M_RUN_CANCEL='x 用户取消了操作：%s 未执行，仍留在队列里。'
M_SUDO_1='> 马上会出现  [sudo] password for <你>:  —— 直接输口令，屏幕上不会显示字符。'
M_SUDO_2='> 输错可以重试（sudo 给 3 次机会）。'
M_OK_MSG='执行成功，输出见 %s'
M_OK='OK 执行成功。输出已存 %s'
M_SSH_MSG='SSH 连接失败（exit 255），未执行'
M_SSH_FAIL='x SSH 连接失败（exit 255）：目标机可能已关机或网络不通。'
M_FAIL_MSG='执行失败（exit %s），输出见 %s'
M_FAIL='x 执行失败（exit %s）。常见原因：口令输错、脚本里的命令本身报错。'
M_LOG_AT='  输出见 %s'
M_ARCHIVED='脚本已归档到 %s（要复跑就 mv 回来）'
M_STILL_QUEUED='脚本仍在队列里，可修好后重跑。'
M_ST_TARGET='SSH 目标'
M_ST_ARGS='SSH 参数'
M_ST_REMOTE='远端队列'
M_ST_CONFIG='配置文件'
M_UNSET='（未配置）'
M_NONE='（无）'
M_MISSING=' （不存在）'
M_ST_PENDING='待执行'
M_UNKNOWN_CMD='未知子命令：%s（agent-safe-input help 看用法）'
M_LANG_LINE='界面语言'
M_LANG_SRC='语言包来源'
M_LANG_BUILTIN='内置英文'
M_LANG_HOWTO='可用 AGENT_SAFE_INPUT_LANG=<标签> 覆盖，例如 AGENT_SAFE_INPUT_LANG=ja'
M_LANG_AVAIL='可用语言'

help_text() {
    cat <<'HELPEOF'
agent-safe-input —— 让 AI 安全地用 sudo

  AI 准备 root 命令，你批准并亲自输口令。口令不进对话、不进脚本、不进日志。

用法:
  agent-safe-input queue <名字> [--] '命令'    把要 root 执行的事排进队列（不执行）
  agent-safe-input queue <名字> <<'EOS'        ……或从 stdin 读整段脚本
  ...多行命令...
  EOS

  agent-safe-input list                       列出队列
  agent-safe-input show <id>                  查看某条脚本全文
  agent-safe-input run [id]                   【由人运行】确认后执行，sudo 当场提示口令
  agent-safe-input result <id>                查看执行结果（success/failed/cancelled）
  agent-safe-input purge                      清空队列与历史输出
  agent-safe-input status                     显示配置与队列概况
  agent-safe-input lang                       显示当前界面语言
  agent-safe-input help | version

配置（环境变量优先）:
  AGENT_SAFE_INPUT_SSH_TARGET   ssh 目标，如 user@host 或 ~/.ssh/config 里的别名
  AGENT_SAFE_INPUT_SSH_ARGS     额外 ssh 参数，如 "-F ./ssh_config -p 2222"
  AGENT_SAFE_INPUT_REMOTE_DIR   远端队列目录，默认 ~/.agent-safe-input/queue
  AGENT_SAFE_INPUT_LANG         界面语言标签，如 en / zh_CN / ja（默认跟随系统）

示例:
  export AGENT_SAFE_INPUT_SSH_TARGET=user@192.168.1.10
  agent-safe-input queue install-deps <<'EOS'
  apt-get update
  apt-get install -y --no-install-recommends build-essential
  EOS
  agent-safe-input run            # 你来看脚本、输 y、输口令

退出码:
  0 成功   2 用户取消   1 参数/连接/执行失败
HELPEOF
}
