# zh_TW — 繁體中文 / Traditional Chinese
# 由 agent-safe-input 自動載入；缺 key 會回退內建英文。

M_NO_TARGET='沒有設定 SSH 目標。設環境變數 AGENT_SAFE_INPUT_SSH_TARGET=user@host，或寫進 %s 的 SSH_TARGET= 一行（見 examples/config）。'
M_CONFIRM='繼續？ '
M_EMPTY_INPUT='^ 沒有輸入內容。請輸入 y 或 n。'
M_INVALID_INPUT='^ 只接受 y / yes / n / no，剛才的「%s」已忽略，請重新輸入。'
M_NEED_TTY='需要在互動式終端機裡執行（stdin 不是終端機）——否則無法輸入 sudo 密碼。'
M_NO_DEV_TTY='拿不到 /dev/tty，無法在這裡提示密碼。'
M_USAGE_QUEUE='用法: agent-safe-input queue <名稱> [--] "指令"   或   agent-safe-input queue <名稱> <<EOS … EOS'
M_MKTEMP='mktemp 失敗'
M_EMPTY_BODY='腳本內容是空的——要嘛跟在名稱後面給指令，要嘛用 stdin 餵進來。'
M_HDR_PURPOSE='# 用途：%s'
M_HDR_QUEUED='# 由 agent-safe-input %s 排入佇列於 %s'
M_HDR_HOW='# 執行方式：agent-safe-input run %s —— 由人確認腳本內容並輸入自己的 sudo 密碼'
M_QUEUE_FAIL='排入佇列失敗：檢查 SSH 連線與 %s 是否可寫。'
M_QUEUED='已排入 %s（未執行）。請人執行：agent-safe-input run %s'
M_EMPTY_QUEUE='佇列為空——沒有等待提權的任務。'
M_PENDING_HDR='待執行的 root 腳本：'
M_NO_TITLE='（無說明）'
M_BYTES='%s 位元組'
M_LIST_HINT='看內容：agent-safe-input show <id>\n執行：  agent-safe-input run <id>'
M_USAGE_SHOW='用法: agent-safe-input show <id>'
M_NOT_IN_QUEUE='佇列裡沒有 %s'
M_SHOW_END='結束'
M_USAGE_RESULT='用法: agent-safe-input result <id>'
M_PURGE_EMPTY='佇列本來就是空的，無需清理。'
M_PURGE_CONFIRM='[agent-safe-input] 將刪除佇列裡 %s 個腳本及其輸出，輸入 y 確認、n 取消： '
M_PURGE_CANCEL_MSG='使用者取消了操作，佇列未清空'
M_PURGE_CANCEL='x 使用者取消了操作，佇列未清空。'
M_PURGE_DONE='已清空佇列。'
M_RUN_EMPTY='佇列為空，沒有要執行的腳本。'
M_PICK_PROMPT='[agent-safe-input] 輸入編號（1-%s）執行，輸入 n 取消： '
M_PICK_CANCEL_MSG='使用者取消了操作，沒有選擇任何任務'
M_PICK_CANCEL='x 使用者取消了操作：沒有選擇任何任務。'
M_PICK_INVALID='^ 請輸入 1-%s 之間的編號，或輸入 n 取消（剛才的輸入已忽略）。'
M_PICK_RANGE='^ 編號超出範圍（只有 1-%s），請重新輸入。'
M_PICK_MISS='^ 取不到第 %s 筆，重來。'
M_RUN_MISSING='佇列裡沒有 %s（agent-safe-input list 看現有 id）'
M_RUN_HDR='──────── 下面這個腳本將以 root 執行 ────────'
M_RUN_FTR='────────────────────────────────────────────'
M_RUN_NOTE='確認無誤就輸入 y 繼續；不想跑就輸入 n。'
M_RUN_CONFIRM='[agent-safe-input] 執行請輸入 y（yes），取消請輸入 n（no）： '
M_RUN_CANCEL_MSG='使用者取消了操作，腳本未執行，仍在佇列裡'
M_RUN_CANCEL='x 使用者取消了操作：%s 未執行，仍留在佇列裡。'
M_SUDO_1='> 馬上會出現  [sudo] password for <你>:  —— 直接輸入密碼，螢幕上不會顯示字元。'
M_SUDO_2='> 輸入錯誤可以重試（sudo 給 3 次機會）。'
M_OK_MSG='執行成功，輸出見 %s'
M_OK='OK 執行成功。輸出已存 %s'
M_SSH_MSG='SSH 連線失敗（exit 255），未執行'
M_SSH_FAIL='x SSH 連線失敗（exit 255）：目標機可能已關機或網路不通。'
M_FAIL_MSG='執行失敗（exit %s），輸出見 %s'
M_FAIL='x 執行失敗（exit %s）。常見原因：密碼輸入錯誤、腳本裡的指令本身報錯。'
M_LOG_AT='  輸出見 %s'
M_ARCHIVED='腳本已歸檔到 %s（要重跑就 mv 回來）'
M_STILL_QUEUED='腳本仍在佇列裡，可修好後重跑。'
M_ST_TARGET='SSH 目標'
M_ST_ARGS='SSH 參數'
M_ST_REMOTE='遠端佇列'
M_ST_CONFIG='設定檔'
M_UNSET='（未設定）'
M_NONE='（無）'
M_MISSING=' （不存在）'
M_ST_PENDING='待執行'
M_UNKNOWN_CMD='未知子命令：%s（agent-safe-input help 看用法）'
M_LANG_LINE='介面語言'
M_LANG_SRC='語言包來源'
M_LANG_BUILTIN='內建英文'
M_LANG_HOWTO='可用 AGENT_SAFE_INPUT_LANG=<標籤> 覆蓋，例如 AGENT_SAFE_INPUT_LANG=ja'
M_LANG_AVAIL='可用語言'

help_text() {
    cat <<'HELPEOF'
agent-safe-input —— 讓 AI 安全地用 sudo

  AI 準備 root 指令，你批准並親自輸入密碼。密碼不進對話、不進腳本、不進日誌。

用法:
  agent-safe-input queue <名稱> [--] '指令'    把要 root 執行的事排進佇列（不執行）
  agent-safe-input queue <名稱> <<'EOS'        ……或從 stdin 讀整段腳本
  ...多行指令...
  EOS

  agent-safe-input list                       列出佇列
  agent-safe-input show <id>                  查看某筆腳本全文
  agent-safe-input run [id]                   【由人執行】確認後執行，sudo 當場提示密碼
  agent-safe-input result <id>                查看執行結果（success/failed/cancelled）
  agent-safe-input purge                      清空佇列與歷史輸出
  agent-safe-input status                     顯示設定與佇列概況
  agent-safe-input lang                       顯示目前介面語言
  agent-safe-input help | version

設定（環境變數優先）:
  AGENT_SAFE_INPUT_SSH_TARGET   ssh 目標，如 user@host 或 ~/.ssh/config 裡的名稱
  AGENT_SAFE_INPUT_SSH_ARGS     額外 ssh 參數，如 "-F ./ssh_config -p 2222"
  AGENT_SAFE_INPUT_REMOTE_DIR   遠端佇列目錄，預設 ~/.agent-safe-input/queue
  AGENT_SAFE_INPUT_LANG         介面語言標籤，如 en / zh_TW / ja（預設跟隨系統）

範例:
  export AGENT_SAFE_INPUT_SSH_TARGET=user@192.168.1.10
  agent-safe-input queue install-deps <<'EOS'
  apt-get update
  apt-get install -y --no-install-recommends build-essential
  EOS
  agent-safe-input run            # 你來看腳本、輸入 y、輸入密碼

結束碼:
  0 成功   2 使用者取消   1 參數/連線/執行失敗
HELPEOF
}
