# fr — Français / French
# 加载方式与其它语言包相同。注意：本文件用双引号包裹字符串，因为法语里有大量撇号。
# 缺 key 时回落内置英文。

M_NO_TARGET="Aucune cible SSH configurée. Définissez AGENT_SAFE_INPUT_SSH_TARGET=user@host, ou ajoutez une ligne SSH_TARGET= dans %s (voir examples/config)."
M_CONFIRM="Continuer ? "
M_EMPTY_INPUT="^ Aucune saisie. Tapez y ou n."
M_INVALID_INPUT="^ Seuls y / yes / n / no sont acceptés. « %s » a été ignoré, réessayez."
M_NEED_TTY="Cette commande doit tourner dans un terminal interactif (stdin n'est pas un TTY) : sinon il n'y a nulle part où saisir le mot de passe sudo."
M_NO_DEV_TTY="Impossible d'ouvrir /dev/tty : l'invite de mot de passe n'a pas de destination."
M_USAGE_QUEUE="Usage : agent-safe-input queue <nom> [--] \"commande\"   ou   agent-safe-input queue <nom> <<EOS … EOS"
M_MKTEMP="échec de mktemp"
M_EMPTY_BODY="Le corps du script est vide : passez des commandes après le nom, ou lisez-les sur stdin."
M_HDR_PURPOSE="# Objet : %s"
M_HDR_QUEUED="# Mis en file par agent-safe-input %s le %s"
M_HDR_HOW="# Pour exécuter : agent-safe-input run %s — un humain relit ce script et saisit son propre mot de passe sudo"
M_QUEUE_FAIL="Échec de la mise en file : vérifiez la connexion SSH et que %s est accessible en écriture."
M_QUEUED="%s mis en file (non exécuté). Demandez à l'humain de lancer : agent-safe-input run %s"
M_EMPTY_QUEUE="La file est vide : rien n'attend root."
M_PENDING_HDR="Scripts root en attente d'approbation :"
M_NO_TITLE="(sans description)"
M_BYTES="%s octets"
M_LIST_HINT="Voir : agent-safe-input show <id>\nExécuter : agent-safe-input run <id>"
M_USAGE_SHOW="Usage : agent-safe-input show <id>"
M_NOT_IN_QUEUE="Aucun script de ce nom dans la file : %s"
M_SHOW_END="fin"
M_USAGE_RESULT="Usage : agent-safe-input result <id>"
M_PURGE_EMPTY="La file était déjà vide : rien à purger."
M_PURGE_CONFIRM="[agent-safe-input] Ceci supprime %s script(s) en file et leur sortie. y pour confirmer, n pour annuler : "
M_PURGE_CANCEL_MSG="L'humain a annulé ; la file n'a pas été purgée"
M_PURGE_CANCEL="x Annulé par l'humain : la file n'a pas été purgée."
M_PURGE_DONE="File purgée."
M_RUN_EMPTY="La file est vide : rien à exécuter."
M_PICK_PROMPT="[agent-safe-input] Entrez un numéro (1-%s) pour exécuter, ou n pour annuler : "
M_PICK_CANCEL_MSG="L'humain a annulé sans choisir de tâche"
M_PICK_CANCEL="x Annulé par l'humain : aucune tâche choisie."
M_PICK_INVALID="^ Entrez un numéro entre 1 et %s, ou n pour annuler (saisie ignorée)."
M_PICK_RANGE="^ Hors plage (seulement 1-%s). Réessayez."
M_PICK_MISS="^ Impossible de lire l'entrée %s. Réessayez."
M_RUN_MISSING="Aucun script de ce nom dans la file : %s (voir agent-safe-input list)"
M_RUN_HDR="-------- le script ci-dessous va s'exécuter en root --------"
M_RUN_FTR="--------------------------------------------------"
M_RUN_NOTE="Tapez y pour l'exécuter ; tapez n si vous préférez ne pas le faire."
M_RUN_CONFIRM="[agent-safe-input] y (yes) pour exécuter, n (no) pour annuler : "
M_RUN_CANCEL_MSG="L'humain a annulé ; le script n'a pas été exécuté et reste en file"
M_RUN_CANCEL="x Annulé par l'humain : %s n'a pas été exécuté et reste en file."
M_SUDO_1="> Vous allez voir  [sudo] password for <vous>:  : tapez le mot de passe, rien ne s'affiche."
M_SUDO_2="> Un mot de passe erroné peut être retenté (sudo autorise 3 essais)."
M_OK_MSG="Exécuté avec succès ; sortie dans %s"
M_OK="OK Succès. Sortie enregistrée dans %s"
M_SSH_MSG="Échec de la connexion SSH (exit 255) ; rien n'a été exécuté"
M_SSH_FAIL="x Échec de la connexion SSH (exit 255) : l'hôte est peut-être éteint ou injoignable."
M_FAIL_MSG="Échec (exit %s) ; sortie dans %s"
M_FAIL="x Échec (exit %s). Causes fréquentes : mot de passe erroné, ou une commande du script a échoué."
M_LOG_AT="  Sortie : %s"
M_ARCHIVED="Script archivé dans %s (faites mv pour le remettre en file)"
M_STILL_QUEUED="Le script reste en file : corrigez-le et relancez."
M_ST_TARGET="Cible SSH"
M_ST_ARGS="Arguments SSH"
M_ST_REMOTE="File distante"
M_ST_CONFIG="Fichier de config"
M_UNSET="(non défini)"
M_NONE="(aucun)"
M_MISSING=" (absent)"
M_ST_PENDING="En attente"
M_UNKNOWN_CMD="Sous-commande inconnue : %s (voir agent-safe-input help)"
M_LANG_LINE="Langue"
M_LANG_SRC="Chargée depuis"
M_LANG_BUILTIN="anglais intégré"
M_LANG_HOWTO="À remplacer avec AGENT_SAFE_INPUT_LANG=<tag>, par ex. AGENT_SAFE_INPUT_LANG=fr"
M_LANG_AVAIL="Disponibles"

help_text() {
    cat <<'HELPEOF'
agent-safe-input — laisser un agent IA utiliser sudo, sans risque

  L'agent prépare les commandes root ; vous les approuvez et saisissez votre mot de passe.
  Le mot de passe ne passe jamais par le chat, un script ou un journal.

Usage :
  agent-safe-input queue <nom> [--] 'commande'  mettre en file un travail root (sans l'exécuter)
  agent-safe-input queue <nom> <<'EOS'          ...ou lire tout le script sur stdin
  ...commandes...
  EOS

  agent-safe-input list                       lister la file
  agent-safe-input show <id>                  afficher un script en entier
  agent-safe-input run [id]                   [HUMAIN SEULEMENT] relire, confirmer, exécuter via sudo
  agent-safe-input result <id>                lire le résultat (success/failed/cancelled)
  agent-safe-input purge                      vider la file et supprimer les sorties
  agent-safe-input status                     afficher la config et la taille de la file
  agent-safe-input lang                       afficher la langue active
  agent-safe-input help | version

Configuration (l'environnement l'emporte) :
  AGENT_SAFE_INPUT_SSH_TARGET   cible ssh, par ex. user@host ou un alias de ~/.ssh/config
  AGENT_SAFE_INPUT_SSH_ARGS     arguments ssh supplémentaires, par ex. "-F ./ssh_config -p 2222"
  AGENT_SAFE_INPUT_REMOTE_DIR   dossier de file distant, défaut ~/.agent-safe-input/queue
  AGENT_SAFE_INPUT_LANG         langue de l'interface, par ex. en, fr (défaut : suivre le système)

Exemple :
  export AGENT_SAFE_INPUT_SSH_TARGET=user@192.168.1.10
  agent-safe-input queue install-deps <<'EOS'
  apt-get update
  apt-get install -y --no-install-recommends build-essential
  EOS
  agent-safe-input run            # vous relisez le script, tapez y, puis le mot de passe

Codes de sortie :
  0 succès   2 annulé par l'humain   1 erreur d'argument/connexion/exécution
HELPEOF
}
