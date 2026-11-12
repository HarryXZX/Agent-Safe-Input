# de — Deutsch / German
# Wird von agent-safe-input automatisch geladen; fehlende Schlüssel fallen auf Englisch zurück.

M_NO_TARGET='Kein SSH-Ziel konfiguriert. Setze AGENT_SAFE_INPUT_SSH_TARGET=user@host oder füge eine Zeile SSH_TARGET= in %s hinzu (siehe examples/config).'
M_CONFIRM='Weiter? '
M_EMPTY_INPUT='^ Keine Eingabe. Bitte y oder n eingeben.'
M_INVALID_INPUT='^ Nur y / yes / n / no werden akzeptiert. "%s" wurde ignoriert - bitte erneut eingeben.'
M_NEED_TTY='Dies muss in einem interaktiven Terminal laufen (stdin ist kein TTY) - sonst gibt es keine Stelle für das sudo-Passwort.'
M_NO_DEV_TTY='/dev/tty lässt sich nicht öffnen - die Passwortabfrage hat kein Ziel.'
M_USAGE_QUEUE='Aufruf: agent-safe-input queue <Name> [--] "Befehl"   oder   agent-safe-input queue <Name> <<EOS … EOS'
M_MKTEMP='mktemp fehlgeschlagen'
M_EMPTY_BODY='Der Skriptrumpf ist leer - Befehle nach dem Namen angeben oder über stdin einlesen.'
M_HDR_PURPOSE='# Zweck: %s'
M_HDR_QUEUED='# Von agent-safe-input %s am %s eingereiht'
M_HDR_HOW='# Ausführen mit: agent-safe-input run %s - ein Mensch prüft dieses Skript und tippt sein eigenes sudo-Passwort'
M_QUEUE_FAIL='Einreihen fehlgeschlagen: SSH-Verbindung und Schreibrechte auf %s prüfen.'
M_QUEUED='%s eingereiht (nicht ausgeführt). Bitte den Menschen bitten: agent-safe-input run %s'
M_EMPTY_QUEUE='Die Warteschlange ist leer - nichts wartet auf root.'
M_PENDING_HDR='Root-Skripte, die auf Freigabe warten:'
M_NO_TITLE='(keine Beschreibung)'
M_BYTES='%s Bytes'
M_LIST_HINT='Ansehen: agent-safe-input show <id>\nAusführen: agent-safe-input run <id>'
M_USAGE_SHOW='Aufruf: agent-safe-input show <id>'
M_NOT_IN_QUEUE='Kein solches Skript in der Warteschlange: %s'
M_SHOW_END='Ende'
M_USAGE_RESULT='Aufruf: agent-safe-input result <id>'
M_PURGE_EMPTY='Die Warteschlange war schon leer - nichts zu löschen.'
M_PURGE_CONFIRM='[agent-safe-input] Löscht %s eingereihte Skripte samt Ausgabe. y zum Bestätigen, n zum Abbrechen: '
M_PURGE_CANCEL_MSG='Der Mensch hat abgebrochen; die Warteschlange wurde nicht geleert'
M_PURGE_CANCEL='x Vom Menschen abgebrochen - die Warteschlange wurde nicht geleert.'
M_PURGE_DONE='Warteschlange geleert.'
M_RUN_EMPTY='Die Warteschlange ist leer - nichts auszuführen.'
M_PICK_PROMPT='[agent-safe-input] Nummer (1-%s) zum Ausführen, n zum Abbrechen: '
M_PICK_CANCEL_MSG='Der Mensch hat abgebrochen, ohne eine Aufgabe zu wählen'
M_PICK_CANCEL='x Vom Menschen abgebrochen - keine Aufgabe gewählt.'
M_PICK_INVALID='^ Bitte eine Nummer zwischen 1 und %s eingeben oder n zum Abbrechen (Eingabe ignoriert).'
M_PICK_RANGE='^ Außerhalb des Bereichs (nur 1-%s). Bitte erneut eingeben.'
M_PICK_MISS='^ Eintrag %s konnte nicht gelesen werden. Bitte erneut versuchen.'
M_RUN_MISSING='Kein solches Skript in der Warteschlange: %s (siehe agent-safe-input list)'
M_RUN_HDR='──────── das folgende Skript läuft als root ────────'
M_RUN_FTR='────────────────────────────────────────────'
M_RUN_NOTE='y eingeben, um es auszuführen; n, wenn Sie es lieber nicht ausführen möchten.'
M_RUN_CONFIRM='[agent-safe-input] y (yes) zum Ausführen, n (no) zum Abbrechen: '
M_RUN_CANCEL_MSG='Der Mensch hat abgebrochen; das Skript wurde nicht ausgeführt und bleibt in der Warteschlange'
M_RUN_CANCEL='x Vom Menschen abgebrochen - %s wurde nicht ausgeführt und bleibt in der Warteschlange.'
M_SUDO_1='> Gleich erscheint  [sudo] password for <Sie>:  - Passwort tippen, es wird nichts angezeigt.'
M_SUDO_2='> Ein falsches Passwort kann wiederholt werden (sudo erlaubt 3 Versuche).'
M_OK_MSG='Erfolgreich ausgeführt; Ausgabe in %s'
M_OK='OK Erfolg. Ausgabe gespeichert in %s'
M_SSH_MSG='SSH-Verbindung fehlgeschlagen (exit 255); nichts wurde ausgeführt'
M_SSH_FAIL='x SSH-Verbindung fehlgeschlagen (exit 255): Host ist evtl. aus oder nicht erreichbar.'
M_FAIL_MSG='Fehlgeschlagen (exit %s); Ausgabe in %s'
M_FAIL='x Fehlgeschlagen (exit %s). Häufige Ursachen: falsches Passwort oder ein Befehl im Skript ist gescheitert.'
M_LOG_AT='  Ausgabe: %s'
M_ARCHIVED='Skript nach %s archiviert (zum erneuten Ausführen zurückbewegen)'
M_STILL_QUEUED='Das Skript ist weiterhin eingereiht - korrigieren und erneut ausführen.'
M_ST_TARGET='SSH-Ziel'
M_ST_ARGS='SSH-Argumente'
M_ST_REMOTE='Entfernte Warteschlange'
M_ST_CONFIG='Konfigurationsdatei'
M_UNSET='(nicht gesetzt)'
M_NONE='(keine)'
M_MISSING=' (fehlt)'
M_ST_PENDING='Wartend'
M_UNKNOWN_CMD='Unbekannter Unterbefehl: %s (siehe agent-safe-input help)'
M_LANG_LINE='Sprache'
M_LANG_SRC='Geladen aus'
M_LANG_BUILTIN='eingebautes Englisch'
M_LANG_HOWTO='Mit AGENT_SAFE_INPUT_LANG=<Tag> überschreiben, z. B. AGENT_SAFE_INPUT_LANG=de'
M_LANG_AVAIL='Verfügbar'

help_text() {
    cat <<'HELPEOF'
agent-safe-input - einem KI-Agenten sudo sicher erlauben

  Der Agent bereitet die root-Befehle vor, Sie genehmigen sie und tippen das Passwort.
  Das Passwort landet nie im Chat, in einem Skript oder in einem Log.

Aufruf:
  agent-safe-input queue <Name> [--] 'Befehl'  root-Arbeit einreihen (nicht ausführen)
  agent-safe-input queue <Name> <<'EOS'        ...oder das ganze Skript über stdin lesen
  ...Befehle...
  EOS

  agent-safe-input list                       Warteschlange auflisten
  agent-safe-input show <id>                  ein Skript vollständig anzeigen
  agent-safe-input run [id]                   [NUR MENSCH] prüfen, bestätigen, per sudo ausführen
  agent-safe-input result <id>                Ergebnis lesen (success/failed/cancelled)
  agent-safe-input purge                      Warteschlange und Ausgaben löschen
  agent-safe-input status                     Konfiguration und Größe der Warteschlange
  agent-safe-input lang                       aktive Sprache anzeigen
  agent-safe-input help | version

Konfiguration (Umgebung gewinnt):
  AGENT_SAFE_INPUT_SSH_TARGET   ssh-Ziel, z. B. user@host oder ein Alias aus ~/.ssh/config
  AGENT_SAFE_INPUT_SSH_ARGS     zusätzliche ssh-Argumente, z. B. "-F ./ssh_config -p 2222"
  AGENT_SAFE_INPUT_REMOTE_DIR   entferntes Warteschlangenverzeichnis, Standard ~/.agent-safe-input/queue
  AGENT_SAFE_INPUT_LANG         Sprach-Tag, z. B. en, de (Standard: Systemeinstellung)

Beispiel:
  export AGENT_SAFE_INPUT_SSH_TARGET=user@192.168.1.10
  agent-safe-input queue install-deps <<'EOS'
  apt-get update
  apt-get install -y --no-install-recommends build-essential
  EOS
  agent-safe-input run            # Skript prüfen, y tippen, dann das Passwort

Exit-Codes:
  0 Erfolg   2 vom Menschen abgebrochen   1 Argument-/Verbindungs-/Ausführungsfehler
HELPEOF
}
