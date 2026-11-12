# ja — 日本語 / Japanese
# agent-safe-input が自動読み込み。欠けたキーは組み込み英語にフォールバック。

M_NO_TARGET='SSH 接続先が設定されていません。環境変数 AGENT_SAFE_INPUT_SSH_TARGET=user@host を設定するか、%s に SSH_TARGET= の行を追加してください（examples/config 参照）。'
M_CONFIRM='続行しますか？ '
M_EMPTY_INPUT='^ 入力がありません。y か n を入力してください。'
M_INVALID_INPUT='^ y / yes / n / no のみ受け付けます。「%s」は無視しました。もう一度入力してください。'
M_NEED_TTY='対話式ターミナルで実行する必要があります（stdin がターミナルではありません）。sudo パスワードを入力できません。'
M_NO_DEV_TTY='/dev/tty を開けません。パスワードのプロンプトを出せません。'
M_USAGE_QUEUE='使い方: agent-safe-input queue <名前> [--] "コマンド"   または   agent-safe-input queue <名前> <<EOS … EOS'
M_MKTEMP='mktemp に失敗しました'
M_EMPTY_BODY='スクリプト本体が空です。名前の後ろにコマンドを渡すか、stdin から流し込んでください。'
M_HDR_PURPOSE='# 用途: %s'
M_HDR_QUEUED='# agent-safe-input %s により %s に登録'
M_HDR_HOW='# 実行方法: agent-safe-input run %s — 人がスクリプトを確認し、自分の sudo パスワードを入力します'
M_QUEUE_FAIL='登録に失敗しました: SSH 接続と %s の書き込み権限を確認してください。'
M_QUEUED='%s を登録しました（未実行）。人に実行を依頼してください: agent-safe-input run %s'
M_EMPTY_QUEUE='キューは空です — root を待っている作業はありません。'
M_PENDING_HDR='承認待ちの root スクリプト:'
M_NO_TITLE='（説明なし）'
M_BYTES='%s バイト'
M_LIST_HINT='内容を見る: agent-safe-input show <id>\n実行する:  agent-safe-input run <id>'
M_USAGE_SHOW='使い方: agent-safe-input show <id>'
M_NOT_IN_QUEUE='キューに %s はありません'
M_SHOW_END='終わり'
M_USAGE_RESULT='使い方: agent-safe-input result <id>'
M_PURGE_EMPTY='キューはもともと空です。削除するものはありません。'
M_PURGE_CONFIRM='[agent-safe-input] キュー内の %s 件のスクリプトと出力を削除します。y で確認、n で中止: '
M_PURGE_CANCEL_MSG='人が中止しました。キューは削除されていません'
M_PURGE_CANCEL='x 人が中止しました — キューは削除されていません。'
M_PURGE_DONE='キューを空にしました。'
M_RUN_EMPTY='キューは空です。実行するスクリプトがありません。'
M_PICK_PROMPT='[agent-safe-input] 番号（1-%s）を入力して実行、n で中止: '
M_PICK_CANCEL_MSG='人が中止しました。作業は選択されていません'
M_PICK_CANCEL='x 人が中止しました — 作業は選択されていません。'
M_PICK_INVALID='^ 1〜%s の番号を入力するか、n で中止してください（入力は無視されました）。'
M_PICK_RANGE='^ 範囲外です（1〜%s のみ）。もう一度入力してください。'
M_PICK_MISS='^ %s 番目を取得できません。やり直してください。'
M_RUN_MISSING='キューに %s はありません（agent-safe-input list で確認）'
M_RUN_HDR='──────── 以下のスクリプトを root として実行します ────────'
M_RUN_FTR='────────────────────────────────────────────'
M_RUN_NOTE='問題なければ y を入力して続行、実行しない場合は n を入力してください。'
M_RUN_CONFIRM='[agent-safe-input] 実行は y（yes）、中止は n（no）: '
M_RUN_CANCEL_MSG='人が中止しました。スクリプトは実行されず、キューに残っています'
M_RUN_CANCEL='x 人が中止しました — %s は実行されず、キューに残っています。'
M_SUDO_1='> まもなく  [sudo] password for <あなた>:  と表示されます — そのまま入力してください。文字は表示されません。'
M_SUDO_2='> 間違えても再入力できます（sudo は 3 回まで）。'
M_OK_MSG='実行に成功しました。出力: %s'
M_OK='OK 成功しました。出力は %s に保存されました'
M_SSH_MSG='SSH 接続に失敗しました（exit 255）。何も実行されていません'
M_SSH_FAIL='x SSH 接続に失敗しました（exit 255）: ホストが停止しているか、到達できません。'
M_FAIL_MSG='失敗しました（exit %s）。出力: %s'
M_FAIL='x 失敗しました（exit %s）。よくある原因: パスワード誤り、またはスクリプト内のコマンドの失敗。'
M_LOG_AT='  出力: %s'
M_ARCHIVED='スクリプトを %s に移動しました（再実行するには mv で戻してください）'
M_STILL_QUEUED='スクリプトはキューのままです。修正して再実行してください。'
M_ST_TARGET='SSH 接続先'
M_ST_ARGS='SSH 引数'
M_ST_REMOTE='リモートキュー'
M_ST_CONFIG='設定ファイル'
M_UNSET='（未設定）'
M_NONE='（なし）'
M_MISSING=' （存在しません）'
M_ST_PENDING='承認待ち'
M_UNKNOWN_CMD='不明なサブコマンド: %s（agent-safe-input help を参照）'
M_LANG_LINE='表示言語'
M_LANG_SRC='言語パック'
M_LANG_BUILTIN='組み込み英語'
M_LANG_HOWTO='AGENT_SAFE_INPUT_LANG=<タグ> で上書きできます（例: AGENT_SAFE_INPUT_LANG=ja）'
M_LANG_AVAIL='利用可能'

help_text() {
    cat <<'HELPEOF'
agent-safe-input — AI に sudo を安全に使わせる

  AI が root コマンドを用意し、あなたが承認して自分のパスワードを入力します。
  パスワードは会話にも、スクリプトにも、ログにも残りません。

使い方:
  agent-safe-input queue <名前> [--] 'コマンド'  root が必要な作業をキューに入れる（実行はしない）
  agent-safe-input queue <名前> <<'EOS'         …または stdin からスクリプト全体を読む
  ...複数行のコマンド...
  EOS

  agent-safe-input list                       キューを一覧
  agent-safe-input show <id>                  スクリプト全文を表示
  agent-safe-input run [id]                   【人が実行】確認してから sudo で実行
  agent-safe-input result <id>                結果を確認（success/failed/cancelled）
  agent-safe-input purge                      キューと出力を削除
  agent-safe-input status                     設定とキューの状態を表示
  agent-safe-input lang                       現在の表示言語を表示
  agent-safe-input help | version

設定（環境変数が優先）:
  AGENT_SAFE_INPUT_SSH_TARGET   ssh 接続先（user@host または ~/.ssh/config の別名）
  AGENT_SAFE_INPUT_SSH_ARGS     追加の ssh 引数（例 "-F ./ssh_config -p 2222"）
  AGENT_SAFE_INPUT_REMOTE_DIR   リモートのキューディレクトリ（既定 ~/.agent-safe-input/queue）
  AGENT_SAFE_INPUT_LANG         表示言語タグ（例 en / ja）。既定はシステムに追従

例:
  export AGENT_SAFE_INPUT_SSH_TARGET=user@192.168.1.10
  agent-safe-input queue install-deps <<'EOS'
  apt-get update
  apt-get install -y --no-install-recommends build-essential
  EOS
  agent-safe-input run            # スクリプトを確認し、y を入力し、パスワードを入力

終了コード:
  0 成功   2 人が中止   1 引数/接続/実行の失敗
HELPEOF
}
