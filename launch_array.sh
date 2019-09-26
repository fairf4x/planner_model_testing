#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

ARRAY_FILE=$1

ARRAY_SIZE=`cat ${ARRAY_FILE} | wc -l`

LOG_PATH="${BASE_DIR}/logs/"

qsub -t 1-${ARRAY_SIZE} -tc 100 -o ${LOG_PATH} -e ${LOG_PATH} ${BASE_DIR}/cplan_array.sh ${ARRAY_FILE}
