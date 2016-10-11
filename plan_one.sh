#!/bin/bash

PICAT=`which picat`

# constrain is a script which ensure that the proces is terminated if it breaks time or memory limits
TIMEOUT=`which constrain`

# limit computation to 30 min
TIME_LIMIT=1800

# limit computation to 1G of RAM
MEM_LIMIT=1000000

# directory to store outputs
RESULT_DIR=`echo $PWD | sed 's/domains/results/'`

mkdir -p $RESULT_DIR

echo "plan_one.sh:"
echo "WORKING_DIR=$PWD"
echo "RESULT_DIR=$RESULT_DIR"
echo "PICAT=$PICAT"
echo "TIMEOUT=$TIMEOUT"

[ -d $RESULT_DIR ] || mkdir $RESULT_DIR

# directory with model source codes
MODEL_DIR="models"

# directory with problem instances
TASK_DIR="problems"

ARGS=$1

echo "Arguments given: $ARGS"

FILE=${ARGS%%;*}
REST=${ARGS#*;}
PLANNER=${REST%%;*}
TASK=${REST#*;}

echo  "planning: ${FILE} ${TASK} ${PLANNER}"

LOGFILE="${FILE}-${TASK}-${PLANNER}_log"

# execute program
#COMMAND="$PICAT ${MODEL_DIR}/${FILE}.pi ${TASK_DIR}/${TASK} ${PLANNER} >> ${RESULT_DIR}/${FILE}-${TASK}-${PLANNER} 2>&1"
COMMAND="$PICAT ${MODEL_DIR}/${FILE}.pi ${TASK_DIR}/${TASK} ${PLANNER}"
RESULT="${RESULT_DIR}/${FILE}-${TASK}-${PLANNER}"
echo ${COMMAND}
$TIMEOUT -t $TIME_LIMIT -m $MEM_LIMIT "${COMMAND} >> ${RESULT} 2>&1" 2> ${RESULT_DIR}/${LOGFILE}
#$PICAT ${EXEC_DIR}/${PROGRAM} ${TASK} >> ${RESULT_DIR}/${FILE}_${TASK}_${PLANNER} 2>&1
