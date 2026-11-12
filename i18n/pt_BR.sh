# pt_BR — Português (Brasil) / Brazilian Portuguese
# Carregado automaticamente pelo agent-safe-input; chaves ausentes caem no inglês embutido.

M_NO_TARGET='Nenhum destino SSH configurado. Defina AGENT_SAFE_INPUT_SSH_TARGET=user@host, ou adicione uma linha SSH_TARGET= em %s (veja examples/config).'
M_CONFIRM='Continuar? '
M_EMPTY_INPUT='^ Nada foi digitado. Digite y ou n.'
M_INVALID_INPUT='^ Apenas y / yes / n / no são aceitos. "%s" foi ignorado, tente novamente.'
M_NEED_TTY='Isto precisa rodar em um terminal interativo (stdin não é um TTY); senão não há onde digitar a senha do sudo.'
M_NO_DEV_TTY='Não foi possível abrir /dev/tty, então o prompt de senha não tem destino.'
M_USAGE_QUEUE='Uso: agent-safe-input queue <nome> [--] "comando"   ou   agent-safe-input queue <nome> <<EOS … EOS'
M_MKTEMP='mktemp falhou'
M_EMPTY_BODY='O corpo do script está vazio: passe comandos depois do nome, ou envie por stdin.'
M_HDR_PURPOSE='# Objetivo: %s'
M_HDR_QUEUED='# Enfileirado por agent-safe-input %s em %s'
M_HDR_HOW='# Para executar: agent-safe-input run %s — uma pessoa revisa este script e digita a própria senha do sudo'
M_QUEUE_FAIL='Falha ao enfileirar: verifique a conexão SSH e se %s é gravável.'
M_QUEUED='%s enfileirado (não executado). Peça à pessoa para rodar: agent-safe-input run %s'
M_EMPTY_QUEUE='A fila está vazia: nada esperando por root.'
M_PENDING_HDR='Scripts root aguardando aprovação:'
M_NO_TITLE='(sem descrição)'
M_BYTES='%s bytes'
M_LIST_HINT='Ver: agent-safe-input show <id>\nExecutar: agent-safe-input run <id>'
M_USAGE_SHOW='Uso: agent-safe-input show <id>'
M_NOT_IN_QUEUE='Nenhum script com esse nome na fila: %s'
M_SHOW_END='fim'
M_USAGE_RESULT='Uso: agent-safe-input result <id>'
M_PURGE_EMPTY='A fila já estava vazia: nada para limpar.'
M_PURGE_CONFIRM='[agent-safe-input] Isto apaga %s script(s) da fila e a saída deles. y para confirmar, n para cancelar: '
M_PURGE_CANCEL_MSG='A pessoa cancelou; a fila não foi limpa'
M_PURGE_CANCEL='x Cancelado pela pessoa: a fila não foi limpa.'
M_PURGE_DONE='Fila limpa.'
M_RUN_EMPTY='A fila está vazia: nada para executar.'
M_PICK_PROMPT='[agent-safe-input] Digite um número (1-%s) para executar, ou n para cancelar: '
M_PICK_CANCEL_MSG='A pessoa cancelou sem escolher uma tarefa'
M_PICK_CANCEL='x Cancelado pela pessoa: nenhuma tarefa escolhida.'
M_PICK_INVALID='^ Digite um número entre 1 e %s, ou n para cancelar (entrada ignorada).'
M_PICK_RANGE='^ Fora do intervalo (apenas 1-%s). Tente novamente.'
M_PICK_MISS='^ Não foi possível ler a entrada %s. Tente novamente.'
M_RUN_MISSING='Nenhum script com esse nome na fila: %s (veja agent-safe-input list)'
M_RUN_HDR='──────── o script abaixo será executado como root ────────'
M_RUN_FTR='────────────────────────────────────────────'
M_RUN_NOTE='Digite y para executar; digite n se preferir não executar.'
M_RUN_CONFIRM='[agent-safe-input] y (yes) para executar, n (no) para cancelar: '
M_RUN_CANCEL_MSG='A pessoa cancelou; o script não foi executado e continua na fila'
M_RUN_CANCEL='x Cancelado pela pessoa: %s não foi executado e continua na fila.'
M_SUDO_1='> Agora vai aparecer  [sudo] password for <você>:  — digite a senha, nada é exibido.'
M_SUDO_2='> Se errar, pode tentar de novo (o sudo permite 3 tentativas).'
M_OK_MSG='Executado com sucesso; saída em %s'
M_OK='OK Sucesso. Saída salva em %s'
M_SSH_MSG='Falha na conexão SSH (exit 255); nada foi executado'
M_SSH_FAIL='x Falha na conexão SSH (exit 255): o host pode estar desligado ou inacessível.'
M_FAIL_MSG='Falhou (exit %s); saída em %s'
M_FAIL='x Falhou (exit %s). Causas comuns: senha incorreta ou um comando do script falhou.'
M_LOG_AT='  Saída: %s'
M_ARCHIVED='Script arquivado em %s (faça mv para devolver)'
M_STILL_QUEUED='O script continua na fila: corrija e rode de novo.'
M_ST_TARGET='Destino SSH'
M_ST_ARGS='Argumentos SSH'
M_ST_REMOTE='Fila remota'
M_ST_CONFIG='Arquivo de config'
M_UNSET='(não definido)'
M_NONE='(nenhum)'
M_MISSING=' (não existe)'
M_ST_PENDING='Pendentes'
M_UNKNOWN_CMD='Subcomando desconhecido: %s (veja agent-safe-input help)'
M_LANG_LINE='Idioma'
M_LANG_SRC='Carregado de'
M_LANG_BUILTIN='inglês embutido'
M_LANG_HOWTO='Substitua com AGENT_SAFE_INPUT_LANG=<tag>, por ex. AGENT_SAFE_INPUT_LANG=pt_BR'
M_LANG_AVAIL='Disponíveis'

help_text() {
    cat <<'HELPEOF'
agent-safe-input — deixar um agente de IA usar sudo com segurança

  O agente prepara os comandos root; você aprova e digita sua própria senha.
  A senha nunca passa pelo chat, por um script ou por um log.

Uso:
  agent-safe-input queue <nome> [--] 'comando'  enfileirar trabalho que precisa de root (sem executar)
  agent-safe-input queue <nome> <<'EOS'         ...ou ler o script inteiro pelo stdin
  ...comandos...
  EOS

  agent-safe-input list                       listar a fila
  agent-safe-input show <id>                  mostrar um script por inteiro
  agent-safe-input run [id]                   [SÓ PESSOA] revisar, confirmar e executar via sudo
  agent-safe-input result <id>                ler o resultado (success/failed/cancelled)
  agent-safe-input purge                      esvaziar a fila e apagar as saídas
  agent-safe-input status                     mostrar config e tamanho da fila
  agent-safe-input lang                       mostrar o idioma ativo
  agent-safe-input help | version

Configuração (o ambiente vence):
  AGENT_SAFE_INPUT_SSH_TARGET   destino ssh, ex. user@host ou um alias de ~/.ssh/config
  AGENT_SAFE_INPUT_SSH_ARGS     argumentos ssh extras, ex. "-F ./ssh_config -p 2222"
  AGENT_SAFE_INPUT_REMOTE_DIR   pasta da fila remota, padrão ~/.agent-safe-input/queue
  AGENT_SAFE_INPUT_LANG         idioma da interface, ex. en, pt_BR (padrão: seguir o sistema)

Exemplo:
  export AGENT_SAFE_INPUT_SSH_TARGET=user@192.168.1.10
  agent-safe-input queue install-deps <<'EOS'
  apt-get update
  apt-get install -y --no-install-recommends build-essential
  EOS
  agent-safe-input run            # você revisa o script, digita y, depois a senha

Códigos de saída:
  0 sucesso   2 cancelado pela pessoa   1 erro de argumento/conexão/execução
HELPEOF
}
