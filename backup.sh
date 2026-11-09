#!/bin/bash

set -Eeuo pipefail

# Vérifier qu'un dossier a été fourni
if [ $# -lt 1 ]; then
    echo "Erreur : veuillez indiquer un dossier à sauvegarder." >&2
    exit 1
fi

DOSSIER="$1"
BACKUP_DIR="backups"

# Vérifier que le dossier existe
if [ ! -d "$DOSSIER" ]; then
    echo "Erreur : le dossier '$DOSSIER' n'existe pas." >&2
    exit 1
fi

# Créer le répertoire des sauvegardes
mkdir -p "$BACKUP_DIR"

# Générer la date et l'heure
DATE=$(date +%Y-%m-%d_%H-%M-%S)

# Créer l'archive
ARCHIVE="$BACKUP_DIR/backup_$DATE.tar.gz"

tar -czf "$ARCHIVE" "$DOSSIER"

echo "Sauvegarde créée : $ARCHIVE"

# Supprimer les sauvegardes de plus de 7 jours
for fichier in "$BACKUP_DIR"/backup_*.tar.gz; do
    if [ -f "$fichier" ]; then
        find "$fichier" -maxdepth 0 -type f -mtime +7 -print -delete
    fi
done

echo "Nettoyage des anciennes sauvegardes terminé."

exit 0

