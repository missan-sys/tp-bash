# REPONSES.md

## Exercice 2.1 — Navigation, recherche et permissions

**Question : Que donne `chmod 644` sur un fichier ? Est-il exécutable par son propriétaire ?**

La commande `chmod 644 fichier` attribue les permissions suivantes :

- Propriétaire : lecture et écriture (`rw-`).
- Groupe : lecture seule (`r--`).
- Autres utilisateurs : lecture seule (`r--`).

Le propriétaire ne peut donc pas exécuter le fichier, car le droit d'exécution (`x`) n'est pas présent. Pour rendre un script exécutable uniquement par son propriétaire, on peut utiliser `chmod 700 script.sh`.

## Exercice 2.2 — Vérification de l'espace disque

**Question : Pourquoi utilise-t-on des guillemets autour de `"$UTILISATION"` dans le test `if` ?**

Les guillemets empêchent le shell de découper la valeur de la variable en plusieurs mots et d'effectuer une expansion des caractères spéciaux. Ils évitent notamment des erreurs si la variable est vide ou contient des espaces. C'est une bonne pratique pour rendre les scripts Bash plus fiables.

## Exercice 2.3 — Sauvegarde et gestion des erreurs

**Question : Que se passe-t-il si on enlève `set -Eeuo pipefail` et que `tar` échoue ? Le script continue-t-il à tort ?**

Sans cette configuration, Bash ne s'arrête pas automatiquement lorsqu'une commande échoue. Si `tar` échoue, les instructions suivantes peuvent donc être exécutées comme si la sauvegarde avait réussi, par exemple le nettoyage des anciennes archives et l'affichage d'un message de succès.

`set -Eeuo pipefail` renforce la détection des erreurs : `-e` arrête le script dans de nombreux cas d'échec non gérés, `-u` signale l'utilisation de variables non définies et `pipefail` permet de détecter l'échec d'une commande dans un pipeline. Il faut toutefois traiter explicitement les erreurs attendues lorsque le script doit poursuivre ou afficher un message précis.

## Exercice 2.4 — Planification avec cron

**Question : Pourquoi cron nécessite-t-il des chemins absolus alors qu'un script fonctionne depuis le terminal avec des chemins relatifs ?**

Dans un terminal, les chemins relatifs sont interprétés à partir du répertoire courant de l'utilisateur. Avec cron, le répertoire courant et l'environnement ne sont pas nécessairement les mêmes que dans une session interactive.

Cron utilise également un environnement minimal, avec notamment un `PATH` qui peut être différent. Les chemins absolus permettent donc d'indiquer sans ambiguïté où se trouvent le script, les dossiers et les fichiers de logs, et rendent la tâche planifiée plus fiable.

## Exercice 2.5 — Mini-projet d'intégration (préfiguration CI/CD)

**Question : Quelles étapes ajouter pour transformer ce script en un vrai pipeline CI ? Quels seraient les points de défaillance à gérer avec des codes de retour ?**

Pour obtenir un pipeline CI plus complet, on pourrait ajouter les étapes suivantes :

1. Installer ou vérifier les dépendances nécessaires au projet.
2. Vérifier la syntaxe et la qualité du code (analyse statique et formatage).
3. Compiler ou construire le projet.
4. Exécuter les tests unitaires et les tests d'intégration.
5. Générer un rapport de tests et conserver les artefacts produits.
6. Publier les résultats et, si nécessaire, préparer une étape de déploiement séparée.

Chaque étape doit vérifier le résultat de la précédente et renvoyer un code de sortie explicite : `0` en cas de réussite et une valeur différente de `0` en cas d'échec.

Les principaux points de défaillance à gérer sont : échec du clonage ou de la mise à jour Git (réseau, authentification, dépôt inaccessible ou conflit), dépendance manquante ou installation impossible, erreur de compilation, tests échoués, rapport ou artefact impossible à générer, et échec éventuel du déploiement. Le pipeline doit journaliser ces erreurs, arrêter les étapes qui dépendent d'une étape échouée et retourner un code d'échec.

---

*Fin des réponses aux questions de réflexion du TP N° 2.*
