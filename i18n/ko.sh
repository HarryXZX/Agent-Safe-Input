# ko — 한국어 / Korean
# agent-safe-input 이 자동으로 불러옵니다. 빠진 키는 내장 영어로 대체됩니다.

M_NO_TARGET='SSH 대상이 설정되지 않았습니다. 환경 변수 AGENT_SAFE_INPUT_SSH_TARGET=user@host 를 설정하거나 %s 에 SSH_TARGET= 줄을 추가하세요(examples/config 참고).'
M_CONFIRM='계속할까요? '
M_EMPTY_INPUT='^ 입력이 없습니다. y 또는 n 을 입력하세요.'
M_INVALID_INPUT='^ y / yes / n / no 만 허용됩니다. 방금 입력한 "%s" 은(는) 무시했습니다. 다시 입력하세요.'
M_NEED_TTY='대화형 터미널에서 실행해야 합니다(stdin 이 터미널이 아님). sudo 비밀번호를 입력할 수 없습니다.'
M_NO_DEV_TTY='/dev/tty 를 열 수 없어 비밀번호 프롬프트를 띄울 수 없습니다.'
M_USAGE_QUEUE='사용법: agent-safe-input queue <이름> [--] "명령"   또는   agent-safe-input queue <이름> <<EOS … EOS'
M_MKTEMP='mktemp 실패'
M_EMPTY_BODY='스크립트 본문이 비어 있습니다. 이름 뒤에 명령을 붙이거나 stdin 으로 넘겨주세요.'
M_HDR_PURPOSE='# 용도: %s'
M_HDR_QUEUED='# agent-safe-input %s 이(가) %s 에 등록'
M_HDR_HOW='# 실행 방법: agent-safe-input run %s — 사람이 스크립트를 확인하고 자신의 sudo 비밀번호를 입력합니다'
M_QUEUE_FAIL='등록 실패: SSH 연결과 %s 쓰기 권한을 확인하세요.'
M_QUEUED='%s 을(를) 등록했습니다(실행 안 됨). 사람에게 실행을 요청하세요: agent-safe-input run %s'
M_EMPTY_QUEUE='대기열이 비어 있습니다 — root 를 기다리는 작업이 없습니다.'
M_PENDING_HDR='승인 대기 중인 root 스크립트:'
M_NO_TITLE='(설명 없음)'
M_BYTES='%s 바이트'
M_LIST_HINT='내용 보기: agent-safe-input show <id>\n실행하기:  agent-safe-input run <id>'
M_USAGE_SHOW='사용법: agent-safe-input show <id>'
M_NOT_IN_QUEUE='대기열에 %s 이(가) 없습니다'
M_SHOW_END='끝'
M_USAGE_RESULT='사용법: agent-safe-input result <id>'
M_PURGE_EMPTY='대기열이 이미 비어 있습니다. 정리할 것이 없습니다.'
M_PURGE_CONFIRM='[agent-safe-input] 대기열의 스크립트 %s 개와 출력을 삭제합니다. y 로 확인, n 으로 취소: '
M_PURGE_CANCEL_MSG='사용자가 취소했습니다. 대기열은 비워지지 않았습니다'
M_PURGE_CANCEL='x 사용자가 취소했습니다 — 대기열은 비워지지 않았습니다.'
M_PURGE_DONE='대기열을 비웠습니다.'
M_RUN_EMPTY='대기열이 비어 있습니다. 실행할 스크립트가 없습니다.'
M_PICK_PROMPT='[agent-safe-input] 번호(1-%s)를 입력해 실행, n 으로 취소: '
M_PICK_CANCEL_MSG='사용자가 작업을 선택하지 않고 취소했습니다'
M_PICK_CANCEL='x 사용자가 취소했습니다 — 선택한 작업이 없습니다.'
M_PICK_INVALID='^ 1-%s 사이의 번호를 입력하거나 n 으로 취소하세요(입력은 무시됨).'
M_PICK_RANGE='^ 범위를 벗어났습니다(1-%s 만 가능). 다시 입력하세요.'
M_PICK_MISS='^ %s 번째 항목을 가져올 수 없습니다. 다시 시도하세요.'
M_RUN_MISSING='대기열에 %s 이(가) 없습니다(agent-safe-input list 참고)'
M_RUN_HDR='──────── 아래 스크립트를 root 로 실행합니다 ────────'
M_RUN_FTR='────────────────────────────────────────────'
M_RUN_NOTE='문제가 없으면 y 를 입력해 계속하고, 실행하지 않으려면 n 을 입력하세요.'
M_RUN_CONFIRM='[agent-safe-input] 실행은 y(yes), 취소는 n(no): '
M_RUN_CANCEL_MSG='사용자가 취소했습니다. 스크립트는 실행되지 않고 대기열에 남아 있습니다'
M_RUN_CANCEL='x 사용자가 취소했습니다 — %s 은(는) 실행되지 않았고 대기열에 남아 있습니다.'
M_SUDO_1='> 곧  [sudo] password for <사용자>:  가 표시됩니다 — 그대로 입력하세요. 화면에는 아무것도 보이지 않습니다.'
M_SUDO_2='> 틀려도 다시 시도할 수 있습니다(sudo 는 3회 허용).'
M_OK_MSG='실행 성공. 출력: %s'
M_OK='OK 성공했습니다. 출력은 %s 에 저장되었습니다'
M_SSH_MSG='SSH 연결 실패(exit 255). 아무것도 실행되지 않았습니다'
M_SSH_FAIL='x SSH 연결 실패(exit 255): 호스트가 꺼져 있거나 연결할 수 없습니다.'
M_FAIL_MSG='실패(exit %s). 출력: %s'
M_FAIL='x 실패(exit %s). 흔한 원인: 비밀번호 오류 또는 스크립트 내 명령 실패.'
M_LOG_AT='  출력: %s'
M_ARCHIVED='스크립트를 %s 로 옮겼습니다(다시 실행하려면 mv 로 되돌리세요)'
M_STILL_QUEUED='스크립트가 대기열에 남아 있습니다. 고친 뒤 다시 실행하세요.'
M_ST_TARGET='SSH 대상'
M_ST_ARGS='SSH 인수'
M_ST_REMOTE='원격 대기열'
M_ST_CONFIG='설정 파일'
M_UNSET='(설정 안 됨)'
M_NONE='(없음)'
M_MISSING=' (없음)'
M_ST_PENDING='대기 중'
M_UNKNOWN_CMD='알 수 없는 하위 명령: %s (agent-safe-input help 참고)'
M_LANG_LINE='표시 언어'
M_LANG_SRC='언어 팩'
M_LANG_BUILTIN='내장 영어'
M_LANG_HOWTO='AGENT_SAFE_INPUT_LANG=<태그> 로 덮어쓸 수 있습니다(예: AGENT_SAFE_INPUT_LANG=ko)'
M_LANG_AVAIL='사용 가능'

help_text() {
    cat <<'HELPEOF'
agent-safe-input — AI 가 sudo 를 안전하게 쓰도록

  AI 가 root 명령을 준비하고, 당신이 승인한 뒤 직접 비밀번호를 입력합니다.
  비밀번호는 대화에도, 스크립트에도, 로그에도 남지 않습니다.

사용법:
  agent-safe-input queue <이름> [--] '명령'    root 가 필요한 작업을 대기열에 넣기(실행 안 함)
  agent-safe-input queue <이름> <<'EOS'        …또는 stdin 에서 스크립트 전체 읽기
  ...여러 줄 명령...
  EOS

  agent-safe-input list                       대기열 목록
  agent-safe-input show <id>                  스크립트 전문 보기
  agent-safe-input run [id]                   【사람이 실행】확인 후 sudo 로 실행
  agent-safe-input result <id>                결과 확인(success/failed/cancelled)
  agent-safe-input purge                      대기열과 출력 삭제
  agent-safe-input status                     설정과 대기열 상태 표시
  agent-safe-input lang                       현재 표시 언어 표시
  agent-safe-input help | version

설정(환경 변수 우선):
  AGENT_SAFE_INPUT_SSH_TARGET   ssh 대상(user@host 또는 ~/.ssh/config 의 별칭)
  AGENT_SAFE_INPUT_SSH_ARGS     추가 ssh 인수(예 "-F ./ssh_config -p 2222")
  AGENT_SAFE_INPUT_REMOTE_DIR   원격 대기열 디렉터리(기본 ~/.agent-safe-input/queue)
  AGENT_SAFE_INPUT_LANG         표시 언어 태그(예 en / ko). 기본은 시스템 따름

예시:
  export AGENT_SAFE_INPUT_SSH_TARGET=user@192.168.1.10
  agent-safe-input queue install-deps <<'EOS'
  apt-get update
  apt-get install -y --no-install-recommends build-essential
  EOS
  agent-safe-input run            # 스크립트를 보고 y 입력 후 비밀번호 입력

종료 코드:
  0 성공   2 사용자 취소   1 인수/연결/실행 실패
HELPEOF
}
