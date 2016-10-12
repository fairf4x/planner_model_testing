#!/bin/bash
#$ -wd /lnet/troja/work/people/vodrazka/picat_model_testing
#$ -N picatPlanner
#$ -q troja-all.q@*
#$ -o /lnet/troja/work/people/vodrazka/log
#$ -e /lnet/troja/work/people/vodrazka/log

# variables provided through qsub's -v option:
PLANNER=${planner}
MODEL=${model}
TASK=${task}
DOMAIN=${domain}

# set up drectories
WORKDIR=`pwd`
DOMAIN_DIR="$WORKDIR/domains/$DOMAIN"
RESULT_DIR="$WORKDIR/results/$DOMAIN"

# check on external programs
PICAT=`which picat`

# constrain is a script which ensure that the proces is terminated if it breaks time or memory limits
TIMEOUT=`which constrain`

# limit computation to 30 min
TIME_LIMIT=1800

# limit computation to 1G of RAM
MEM_LIMIT=1000000

mkdir -p $RESULT_DIR

echo "cplan_one.sh:"
echo "DOMAIN_DIR=${DOMAIN_DIR}"
echo "RESULT_DIR=${RESULT_DIR}"
echo "PICAT=$PICAT"
echo "TIMEOUT=$TIMEOUT"

[ -d $RESULT_DIR ] || mkdir $RESULT_DIR

# directory with model source codes
MODEL_DIR="models"

# directory with problem instances
TASK_DIR="problems"

echo  "planning: ${MODEL} ${TASK} ${PLANNER}"

LOGFILE="${MODEL}-${TASK}-${PLANNER}_log"

# execute program
COMMAND="$PICAT ${MODEL_DIR}/${MODEL}.pi ${TASK_DIR}/${TASK} ${PLANNER}"
RESULT="${RESULT_DIR}/${MODEL}-${TASK}-${PLANNER}"
echo ${COMMAND}
cd ${DOMAIN_DIR}
$TIMEOUT -t $TIME_LIMIT -m $MEM_LIMIT "${COMMAND} >> ${RESULT} 2>&1" 2> ${RESULT_DIR}/${LOGFILE}
