#!/bin/bash

BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

ARRAY_FILE=$1

QUEUE=$2

ARRAY_SIZE=`cat ${ARRAY_FILE} | wc -l`

BATCH_SIZE=100

LOG_PATH="${BASE_DIR}/logs/"

qsub -q ${QUEUE} -t 1-${ARRAY_SIZE} -tc ${BATCH_SIZE} -o ${LOG_PATH} -e ${LOG_PATH} ${BASE_DIR}/cplan_array.sh ${ARRAY_FILE}
