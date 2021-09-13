#!/bin/bash
if [ "$#" -ne 2 ];
    then
        echo "Usage: <script> <dir_data> <file_with_allies>"
        exit 1
fi

DIRO=$(readlink -f ${1})
DATA=$(readlink -f ${2})
echo "Data from ${DIRO} and file ${DATA}"

BCK=${PWD}
TMP_DIR=$(mktemp -d)

MAP_FILE='map_test.gnuplot'
#SRC_DIR='/home/hankier/Plemsy/latest'
SRC_DIR='/root/git/TribalWarsMapGenerator'
VILL_SC="${SRC_DIR}/get_vills.sh"
#MAP_LOC='/home/hankier/Plemsy/Maps'
#MAP_LOC='/root/Maps/all'
MAP_LOC='/usr/share/nginx/html/Maps'
LATEST='/usr/share/nginx/html/latest.png'

cd ${TMP_DIR}
cp ${DIRO}/* .
cat "${SRC_DIR}/map_test.gnuplot.bck" > ${MAP_FILE}
gunzip -d *.gz


echo "Generate data"
cat ${DATA} | while read line; do
    IFS=', ' read -r -a array <<< "$line"
    bash ${VILL_SC} "${array[0]}" "data_${array[1]}"
done 

DATE=$( cat "./date_log")
MAPNAME=$( echo ${DATE} | tr '_' '_' | tr ' ' '_' | tr ':' '_')

sed "s/__DATEFILE__/${MAPNAME}/g" -i "${MAP_FILE}"
sed "s/__DATE__/${DATE}/g" -i "${MAP_FILE}"
echo "DATE: ${DATE}"
echo "MAPE: ${MAPNAME}"


x=215
cat ${DATA} | while read line;
do
    IFS=', ' read -r -a array <<< "$line"
    echo "X=${x}"
    echo "set label font \",30\" \"■ ${array[1]} | $(wc -l data_${array[1]} | awk '{print $1}' )\"  at 210, ${x}   front nopoint tc rgb '${array[2]}'" >> ${MAP_FILE}
    ((x+=12))
done

sleep 1

echo "Generating map"
echo ''  >> ${MAP_FILE}
echo 'plot \' >> ${MAP_FILE}
cat ${DATA}| while read line;
do
    IFS=', ' read -r -a array <<< "$line"
    echo "      'data_${array[1]}'       using 1:2 pt 5 ps 0.75 lc rgb \"${array[2]}\", \\" >> ${MAP_FILE}
done

gnuplot -c ${MAP_FILE}

cp  map_${MAPNAME}_zoom.png ${MAP_LOC}
rm -f ${LATEST}
ln -s ${MAP_LOC}/map_${MAPNAME}_zoom.png ${LATEST}
echo 'Done'
cd ${BCK}
