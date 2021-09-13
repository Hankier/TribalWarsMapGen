#!/bin/bash

DIR_NAME=$(date +%Y%m%d_%H_%M)
DIR_LATE="latest"
DATE=$(date "+%Y-%m-%d %H:%M")
DATE_FILE="date_log"
#SC_LOC="$(dirname "$(realpath "$0")")"
SC_LOC="/root/Plemsy/pl169"
#TT_LOC="/root/Plemsy/total"
TT_LOC="/Plemsy_total"
CWD=$(pwd)

DST_LOC="${SC_LOC}/${DIR_NAME}"

echo "Creating destination=${DST_LOC}"
mkdir ${DST_LOC}

LOG_FILE="${DST_LOC}/log"
touch ${LOG_FILE}

echo "Entering destination=${DST_LOC}" &>> ${LOG_FILE}
cd ${DST_LOC} &>> ${LOG_FILE}

echo "Add date=${DATE} to file=${DATE_FILE}" &>> ${LOG_FILE}
echo -n "${DATE}" >> ${DATE_FILE}

echo 'Downloading stats' &>> ${LOG_FILE}
wget https://pl169.plemiona.pl/map/kill_att.txt.gz --no-check-certificate &>> ${LOG_FILE}
wget https://pl169.plemiona.pl/map/kill_all.txt.gz --no-check-certificate &>> ${LOG_FILE}
wget https://pl169.plemiona.pl/map/kill_def.txt.gz --no-check-certificate &>> ${LOG_FILE}
wget https://pl169.plemiona.pl/map/village.txt.gz --no-check-certificate &>> ${LOG_FILE}
wget https://pl169.plemiona.pl/map/conquer.txt.gz --no-check-certificate &>> ${LOG_FILE}
wget https://pl169.plemiona.pl/map/player.txt.gz --no-check-certificate &>> ${LOG_FILE}
wget https://pl169.plemiona.pl/map/ally.txt.gz --no-check-certificate &>> ${LOG_FILE}


wget https://pl169.plemiona.pl/map/kill_all_tribe.txt.gz --no-check-certificate &>> ${LOG_FILE}
wget https://pl169.plemiona.pl/map/kill_att_tribe.txt.gz --no-check-certificate &>> ${LOG_FILE}
wget https://pl169.plemiona.pl/map/kill_def_tribe.txt.gz --no-check-certificate &>> ${LOG_FILE}



echo 'Download ended' &>> ${LOG_FILE}
rm -rf $TT_LOC/*
cp ./* $TT_LOC/
cd $TT_LOC
gunzip -d ./*
chmod 777 ./*
echo "Going back to cwd=${CWD}" &>> ${LOG_FILE}
cd ${CWD} &>> ${LOG_FILE}
echo 'Done downloading' &>> ${LOG_FILE}

echo 'Done creating map' &>> ${LOG_FILE}
bash /root/git/TribalWarsMapGenerator/generator_mapy.sh  ${DST_LOC} /root/git/TribalWarsMapGenerator/generuj_latest
