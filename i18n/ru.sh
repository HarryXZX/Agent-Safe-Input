# ru — Русский / Russian
# Загружается agent-safe-input автоматически; отсутствующие ключи берутся из встроенного английского.

M_NO_TARGET='Не задан SSH-хост. Установите AGENT_SAFE_INPUT_SSH_TARGET=user@host или добавьте строку SSH_TARGET= в %s (см. examples/config).'
M_CONFIRM='Продолжить? '
M_EMPTY_INPUT='^ Ввод пуст. Введите y или n.'
M_INVALID_INPUT='^ Принимаются только y / yes / n / no. «%s» проигнорировано, введите заново.'
M_NEED_TTY='Нужен интерактивный терминал (stdin не TTY) — иначе негде ввести пароль sudo.'
M_NO_DEV_TTY='Не удаётся открыть /dev/tty — запрос пароля некуда вывести.'
M_USAGE_QUEUE='Использование: agent-safe-input queue <имя> [--] "команда"   или   agent-safe-input queue <имя> <<EOS … EOS'
M_MKTEMP='mktemp завершился ошибкой'
M_EMPTY_BODY='Тело скрипта пустое — передайте команды после имени или через stdin.'
M_HDR_PURPOSE='# Назначение: %s'
M_HDR_QUEUED='# Поставлено в очередь agent-safe-input %s, %s'
M_HDR_HOW='# Запуск: agent-safe-input run %s — человек проверяет скрипт и вводит свой пароль sudo'
M_QUEUE_FAIL='Не удалось поставить в очередь: проверьте SSH-соединение и право записи в %s.'
M_QUEUED='%s поставлено в очередь (не выполнено). Попросите человека запустить: agent-safe-input run %s'
M_EMPTY_QUEUE='Очередь пуста — ничего не ждёт root.'
M_PENDING_HDR='Скрипты root, ожидающие подтверждения:'
M_NO_TITLE='(без описания)'
M_BYTES='%s байт'
M_LIST_HINT='Посмотреть: agent-safe-input show <id>\nВыполнить:  agent-safe-input run <id>'
M_USAGE_SHOW='Использование: agent-safe-input show <id>'
M_NOT_IN_QUEUE='В очереди нет %s'
M_SHOW_END='конец'
M_USAGE_RESULT='Использование: agent-safe-input result <id>'
M_PURGE_EMPTY='Очередь и так пуста — очищать нечего.'
M_PURGE_CONFIRM='[agent-safe-input] Будет удалено скриптов: %s, вместе с выводом. y — подтвердить, n — отменить: '
M_PURGE_CANCEL_MSG='Человек отменил; очередь не очищена'
M_PURGE_CANCEL='x Отменено человеком — очередь не очищена.'
M_PURGE_DONE='Очередь очищена.'
M_RUN_EMPTY='Очередь пуста — нечего выполнять.'
M_PICK_PROMPT='[agent-safe-input] Введите номер (1-%s) для запуска или n для отмены: '
M_PICK_CANCEL_MSG='Человек отменил, не выбрав задачу'
M_PICK_CANCEL='x Отменено человеком — задача не выбрана.'
M_PICK_INVALID='^ Введите номер от 1 до %s или n для отмены (ввод проигнорирован).'
M_PICK_RANGE='^ Вне диапазона (только 1-%s). Повторите ввод.'
M_PICK_MISS='^ Не удалось прочитать запись %s. Повторите.'
M_RUN_MISSING='В очереди нет %s (см. agent-safe-input list)'
M_RUN_HDR='──────── скрипт ниже будет выполнен от root ────────'
M_RUN_FTR='────────────────────────────────────────────'
M_RUN_NOTE='Введите y, чтобы выполнить; n — если не хотите запускать.'
M_RUN_CONFIRM='[agent-safe-input] y (yes) — выполнить, n (no) — отменить: '
M_RUN_CANCEL_MSG='Человек отменил; скрипт не выполнялся и остался в очереди'
M_RUN_CANCEL='x Отменено человеком — %s не выполнен и остался в очереди.'
M_SUDO_1='> Сейчас появится  [sudo] password for <вы>:  — введите пароль, символы не отображаются.'
M_SUDO_2='> При ошибке можно повторить (sudo даёт 3 попытки).'
M_OK_MSG='Выполнено успешно; вывод в %s'
M_OK='OK Успех. Вывод сохранён в %s'
M_SSH_MSG='SSH-соединение не установлено (exit 255); ничего не выполнялось'
M_SSH_FAIL='x SSH-соединение не установлено (exit 255): хост выключен или недоступен.'
M_FAIL_MSG='Ошибка (exit %s); вывод в %s'
M_FAIL='x Ошибка (exit %s). Частые причины: неверный пароль или сбой команды в скрипте.'
M_LOG_AT='  Вывод: %s'
M_ARCHIVED='Скрипт перемещён в %s (верните через mv, чтобы запустить снова)'
M_STILL_QUEUED='Скрипт остался в очереди — исправьте и запустите снова.'
M_ST_TARGET='SSH-хост'
M_ST_ARGS='Аргументы SSH'
M_ST_REMOTE='Удалённая очередь'
M_ST_CONFIG='Файл настроек'
M_UNSET='(не задано)'
M_NONE='(нет)'
M_MISSING=' (отсутствует)'
M_ST_PENDING='В очереди'
M_UNKNOWN_CMD='Неизвестная подкоманда: %s (см. agent-safe-input help)'
M_LANG_LINE='Язык'
M_LANG_SRC='Загружен из'
M_LANG_BUILTIN='встроенный английский'
M_LANG_HOWTO='Переопределить: AGENT_SAFE_INPUT_LANG=<тег>, например AGENT_SAFE_INPUT_LANG=ru'
M_LANG_AVAIL='Доступны'

help_text() {
    cat <<'HELPEOF'
agent-safe-input — безопасно разрешить ИИ-агенту использовать sudo

  Агент готовит root-команды, вы их одобряете и вводите свой пароль.
  Пароль не попадает ни в чат, ни в скрипт, ни в журнал.

Использование:
  agent-safe-input queue <имя> [--] 'команда'  поставить в очередь работу, требующую root (без запуска)
  agent-safe-input queue <имя> <<'EOS'         ...или прочитать весь скрипт из stdin
  ...команды...
  EOS

  agent-safe-input list                       список очереди
  agent-safe-input show <id>                  показать скрипт целиком
  agent-safe-input run [id]                   [ТОЛЬКО ЧЕЛОВЕК] проверить, подтвердить, выполнить через sudo
  agent-safe-input result <id>                прочитать результат (success/failed/cancelled)
  agent-safe-input purge                      очистить очередь и удалить вывод
  agent-safe-input status                     показать настройки и размер очереди
  agent-safe-input lang                       показать текущий язык
  agent-safe-input help | version

Настройки (переменные окружения важнее):
  AGENT_SAFE_INPUT_SSH_TARGET   ssh-хост, напр. user@host или псевдоним из ~/.ssh/config
  AGENT_SAFE_INPUT_SSH_ARGS     доп. аргументы ssh, напр. "-F ./ssh_config -p 2222"
  AGENT_SAFE_INPUT_REMOTE_DIR   каталог очереди на хосте, по умолчанию ~/.agent-safe-input/queue
  AGENT_SAFE_INPUT_LANG         язык интерфейса, напр. en, ru (по умолчанию — как в системе)

Пример:
  export AGENT_SAFE_INPUT_SSH_TARGET=user@192.168.1.10
  agent-safe-input queue install-deps <<'EOS'
  apt-get update
  apt-get install -y --no-install-recommends build-essential
  EOS
  agent-safe-input run            # вы проверяете скрипт, вводите y, затем пароль

Коды выхода:
  0 успех   2 отменено человеком   1 ошибка аргументов/соединения/выполнения
HELPEOF
}
