#!/bin/bash
#$ -wd /lnet/troja/work/people/vodrazka/picat_model_testing
#$ -q ms-all.q@tauri*
#$ -l mem_free=1G
#$ -l h_vmem=1G
#$ -l h_rt=0:30:00

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

mkdir -p $RESULT_DIR

echo "cplan_one.sh:"
echo "DOMAIN_DIR=${DOMAIN_DIR}"
echo "RESULT_DIR=${RESULT_DIR}"
echo "PICAT=$PICAT"

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
echo "Running picat"
cd ${DOMAIN_DIR}
${COMMAND} >> ${RESULT}
echo "Done"
