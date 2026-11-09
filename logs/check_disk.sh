
#!/bin/bash

SEUIL=${1:-80}

UTILISATION=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

echo "Espace disque utilisé : $UTILISATION%"
echo "Seuil défini : $SEUIL%"

if [ "$UTILISATION" -ge "$SEUIL" ]; then
    echo "ALERTE : Le seuil d'utilisation du disque est dépassé !"
    exit 1
else
    echo "OK : L'utilisation du disque est normale."
    exit 0
fi

