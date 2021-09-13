#!/bin/bash

ALLY_IDS=${1}
OUT_FILE=${2}


PLAYERS=$(awk -F',' "\$3 ~ /^(${ALLY_IDS})$/{ print \$1; }" player.txt | tr '\n' '|')

awk -F',' "\$5 ~ /^(${PLAYERS%?})$/{ print \$3, \$4; }" village.txt > ${OUT_FILE}

