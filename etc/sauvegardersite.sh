#!/bin/bash
# Le script sert a sauvegarder les fichiers importants du serveur

# Chemin des dossier a sauvegarder
DOSSIERS="/srv/www/presence"

# Date du jour
MAINTENANT=$(date +"%F")

# Emplacement des sauvegardes du serveur
SAUVEGARDE="/var/sauvegarde/$MAINTENANT"

# Nom de la sauvegarde = note d'hote.temps.tar.gz
FICHIERBASE="$(hostname).$(date +'%T').tar.gz"
FICHIERMYSQL="$(hostname).$(date +'%T').mysql.sql.gz"

# Informations connexion MySQL
UTILISATEURMYSQL="root"
MDPMYSQL="sudoroot"

# Chemin de fichiers binaires
TAR="/bin/tar"
DUMPMYSQL="/usr/bin/mysqldump"
GZIP="/bin/gzip"
LOGGER="/usr/bin/logger"

# Verification que l'emplacement de sauvegarde existe
[ ! -d $SAUVEGARDE ] && mkdir -p ${SAUVEGARDE}

# Message pour dire que la sauvegarde a commencee
$LOGGER "$0: *** La sauvegarde du serveur commence @ $(date) ***"

# Sauvegarde des fichiers serveur de base
$TAR -czvf ${SAUVEGARDE}/${FICHIERBASE} ${DOSSIERS}

# Sauvegarde MySQL
$DUMPMYSQL -u ${UTILISATEURMYSQL} -h localhost -p${MDPMYSQL} --all-databases | $GZIP -9 > ${SAUVEGARDE}/${FICHIERMYSQL}

# Message de fin de sauvegarde du serveur
$LOGGER "$0: *** Sauvegarde du serveur terminee @ $(date) ***"
