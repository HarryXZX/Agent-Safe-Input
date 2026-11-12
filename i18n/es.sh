# es — Español / Spanish
# agent-safe-input lo carga automáticamente; las claves ausentes caen al inglés integrado.

M_NO_TARGET='No hay destino SSH configurado. Define AGENT_SAFE_INPUT_SSH_TARGET=user@host, o añade una línea SSH_TARGET= en %s (ver examples/config).'
M_CONFIRM='¿Continuar? '
M_EMPTY_INPUT='^ No se ha introducido nada. Escribe y o n.'
M_INVALID_INPUT='^ Solo se aceptan y / yes / n / no. Se ignoró "%s", inténtalo de nuevo.'
M_NEED_TTY='Esto debe ejecutarse en una terminal interactiva (stdin no es un TTY); si no, no hay dónde escribir la contraseña de sudo.'
M_NO_DEV_TTY='No se puede abrir /dev/tty, así que el aviso de contraseña no tiene destino.'
M_USAGE_QUEUE='Uso: agent-safe-input queue <nombre> [--] "comando"   o   agent-safe-input queue <nombre> <<EOS … EOS'
M_MKTEMP='mktemp falló'
M_EMPTY_BODY='El cuerpo del script está vacío: pasa comandos después del nombre, o envíalos por stdin.'
M_HDR_PURPOSE='# Propósito: %s'
M_HDR_QUEUED='# Encolado por agent-safe-input %s el %s'
M_HDR_HOW='# Para ejecutar: agent-safe-input run %s — una persona revisa este script y escribe su propia contraseña de sudo'
M_QUEUE_FAIL='No se pudo encolar: comprueba la conexión SSH y que %s se pueda escribir.'
M_QUEUED='%s encolado (sin ejecutar). Pide a la persona que ejecute: agent-safe-input run %s'
M_EMPTY_QUEUE='La cola está vacía: no hay nada esperando root.'
M_PENDING_HDR='Scripts root pendientes de aprobación:'
M_NO_TITLE='(sin descripción)'
M_BYTES='%s bytes'
M_LIST_HINT='Ver: agent-safe-input show <id>\nEjecutar: agent-safe-input run <id>'
M_USAGE_SHOW='Uso: agent-safe-input show <id>'
M_NOT_IN_QUEUE='No hay ningún script con ese nombre en la cola: %s'
M_SHOW_END='fin'
M_USAGE_RESULT='Uso: agent-safe-input result <id>'
M_PURGE_EMPTY='La cola ya estaba vacía: nada que purgar.'
M_PURGE_CONFIRM='[agent-safe-input] Esto borra %s script(s) de la cola y su salida. y para confirmar, n para cancelar: '
M_PURGE_CANCEL_MSG='La persona canceló; la cola no se purgó'
M_PURGE_CANCEL='x Cancelado por la persona: la cola no se purgó.'
M_PURGE_DONE='Cola purgada.'
M_RUN_EMPTY='La cola está vacía: no hay nada que ejecutar.'
M_PICK_PROMPT='[agent-safe-input] Escribe un número (1-%s) para ejecutar, o n para cancelar: '
M_PICK_CANCEL_MSG='La persona canceló sin elegir ninguna tarea'
M_PICK_CANCEL='x Cancelado por la persona: no se eligió ninguna tarea.'
M_PICK_INVALID='^ Escribe un número entre 1 y %s, o n para cancelar (entrada ignorada).'
M_PICK_RANGE='^ Fuera de rango (solo 1-%s). Inténtalo de nuevo.'
M_PICK_MISS='^ No se pudo leer la entrada %s. Inténtalo de nuevo.'
M_RUN_MISSING='No hay ningún script con ese nombre en la cola: %s (ver agent-safe-input list)'
M_RUN_HDR='──────── el script de abajo se ejecutará como root ────────'
M_RUN_FTR='────────────────────────────────────────────'
M_RUN_NOTE='Escribe y para ejecutarlo; escribe n si prefieres no hacerlo.'
M_RUN_CONFIRM='[agent-safe-input] y (yes) para ejecutar, n (no) para cancelar: '
M_RUN_CANCEL_MSG='La persona canceló; el script no se ejecutó y sigue en la cola'
M_RUN_CANCEL='x Cancelado por la persona: %s no se ejecutó y sigue en la cola.'
M_SUDO_1='> Ahora verás  [sudo] password for <tú>:  — escribe la contraseña, no se muestra nada.'
M_SUDO_2='> Si te equivocas puedes reintentar (sudo permite 3 intentos).'
M_OK_MSG='Ejecutado correctamente; salida en %s'
M_OK='OK Éxito. Salida guardada en %s'
M_SSH_MSG='Falló la conexión SSH (exit 255); no se ejecutó nada'
M_SSH_FAIL='x Falló la conexión SSH (exit 255): el host puede estar apagado o inaccesible.'
M_FAIL_MSG='Falló (exit %s); salida en %s'
M_FAIL='x Falló (exit %s). Causas habituales: contraseña incorrecta o un comando del script falló.'
M_LOG_AT='  Salida: %s'
M_ARCHIVED='Script archivado en %s (haz mv para devolverlo)'
M_STILL_QUEUED='El script sigue en la cola: corrígelo y vuelve a ejecutar.'
M_ST_TARGET='Destino SSH'
M_ST_ARGS='Argumentos SSH'
M_ST_REMOTE='Cola remota'
M_ST_CONFIG='Archivo de config'
M_UNSET='(sin definir)'
M_NONE='(ninguno)'
M_MISSING=' (no existe)'
M_ST_PENDING='Pendientes'
M_UNKNOWN_CMD='Subcomando desconocido: %s (ver agent-safe-input help)'
M_LANG_LINE='Idioma'
M_LANG_SRC='Cargado desde'
M_LANG_BUILTIN='inglés integrado'
M_LANG_HOWTO='Puedes sobrescribirlo con AGENT_SAFE_INPUT_LANG=<etiqueta>, p. ej. AGENT_SAFE_INPUT_LANG=es'
M_LANG_AVAIL='Disponibles'

help_text() {
    cat <<'HELPEOF'
agent-safe-input — permitir que un agente de IA use sudo, sin riesgo

  El agente prepara los comandos root; tú los apruebas y escribes tu contraseña.
  La contraseña nunca pasa por el chat, un script ni un registro.

Uso:
  agent-safe-input queue <nombre> [--] 'comando'  encolar trabajo que necesita root (sin ejecutar)
  agent-safe-input queue <nombre> <<'EOS'         ...o leer el script completo por stdin
  ...comandos...
  EOS

  agent-safe-input list                       listar la cola
  agent-safe-input show <id>                  mostrar un script completo
  agent-safe-input run [id]                   [SOLO PERSONA] revisar, confirmar y ejecutar con sudo
  agent-safe-input result <id>                leer el resultado (success/failed/cancelled)
  agent-safe-input purge                      vaciar la cola y borrar las salidas
  agent-safe-input status                     mostrar la config y el tamaño de la cola
  agent-safe-input lang                       mostrar el idioma activo
  agent-safe-input help | version

Configuración (el entorno manda):
  AGENT_SAFE_INPUT_SSH_TARGET   destino ssh, p. ej. user@host o un alias de ~/.ssh/config
  AGENT_SAFE_INPUT_SSH_ARGS     argumentos ssh extra, p. ej. "-F ./ssh_config -p 2222"
  AGENT_SAFE_INPUT_REMOTE_DIR   carpeta de cola remota, por defecto ~/.agent-safe-input/queue
  AGENT_SAFE_INPUT_LANG         idioma de la interfaz, p. ej. en, es (por defecto: seguir el sistema)

Ejemplo:
  export AGENT_SAFE_INPUT_SSH_TARGET=user@192.168.1.10
  agent-safe-input queue install-deps <<'EOS'
  apt-get update
  apt-get install -y --no-install-recommends build-essential
  EOS
  agent-safe-input run            # revisas el script, escribes y, luego la contraseña

Códigos de salida:
  0 éxito   2 cancelado por la persona   1 error de argumento/conexión/ejecución
HELPEOF
}
