#!/bin/bash

set -Eeuo pipefail

# Vérifier qu'une URL de dépôt a été fournie
if [ -z "${1:-}" ]; then
    echo "Erreur : veuillez fournir l'URL du dépôt Git." >&2
    exit 1
fi

REPO_URL="$1"
REPO_DIR="ci_project"
LOG_FILE="ci.log"

# Fonction de journalisation
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Récupérer ou mettre à jour le dépôt
if [ -d "$REPO_DIR/.git" ]; then
    log "Mise à jour du dépôt..."
    if ! git -C "$REPO_DIR" pull; then
        log "ERREUR : échec de la mise à jour."
        exit 1
    fi
else
    log "Clonage du dépôt..."
    if ! git clone "$REPO_URL" "$REPO_DIR"; then
        log "ERREUR : échec du clonage."
        exit 1
    fi
fi

log "Dépôt récupéré avec succès."

# Fonction simulant l'exécution des tests
run_tests() {
    log "Début des tests..."

    if git -C "$REPO_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        log "TEST OK : dépôt Git valide."
        return 0
    else
        log "TEST ECHEC : dépôt Git invalide."
        return 1
    fi
}

# Exécuter les tests
if run_tests; then
    log "PIPELINE REUSSI."
    exit 0
else
    log "PIPELINE ECHOUE."
    exit 1
fi

