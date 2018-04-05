#!/bin/bash
#$ -wd /lnet/troja/work/people/vodrazka/picat_model_testing
#$ -q ms-all.q@tauri*
#$ -l mem_free=1G
#$ -l h_vmem=1G
#$ -l h_rt=0:30:00

# variables provided through qsub's -v option:

# planner
PLANNER=${planner}
# planner specific configuration file
CONFIG=${config}
# domain model used
MODEL=${model}
# problem instance
TASK=${task}
# domain
DOMAIN=${domain}

# set up directories
WORKDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOMAIN_DIR="$WORKDIR/domains/$DOMAIN"
PLANNER_DIR="$WORKDIR/planners/"
RESULT_DIR="$WORKDIR/results/$DOMAIN"

# read config file
COMMAND_TEMPLATE=`cat ${PLANNER_DIR}/${PLANNER}/${CONFIG}`
CONF_ID=${CONFIG%.*}

mkdir -p $RESULT_DIR

echo "cplan_one.sh:"
echo "DOMAIN_DIR=${DOMAIN_DIR}"
echo "RESULT_DIR=${RESULT_DIR}"
echo "CONFIG=${CONFIG}"

[ -d $RESULT_DIR ] || mkdir $RESULT_DIR

# directory with model source codes
MODEL_DIR="models"

# directory with problem instances
TASK_DIR="problems/${MODEL}"

echo  "planning: ${PLANNER} ${MODEL} ${TASK}"
echo  "configuration: ${CONF_ID}"

LOGFILE="${PLANNER}-${MODEL}-${TASK}-${CONF_ID}_log"

# determine model file and problem file
MODEL_FILE="${MODEL_DIR}/${MODEL}"
TASK_FILE="${TASK_DIR}/${TASK}"
RESULT_FILE="${RESULT_DIR}/${PLANNER}-${MODEL}-${TASK}-${CONF_ID}"

function initializeTemplate() {
TEMPLATE=$1
MODEL=$2
TASK=$3
RESULT=$4
echo ${TEMPLATE} | sed "s/MODEL/${MODEL}/" | sed "s/TASK/${TASK}/" | sed "s/RESULT/${RESULT}/" 
}

# fill-in the template
COMMAND=`initializeTemplate ${COMMAND_TEMPLATE} ${MODEL_FILE} ${TASK_FILE} ${RESULT_FILE}`
echo "Running planner"
echo "command: ${COMMAND}"
#cd ${DOMAIN_DIR}
#${COMMAND} >> ${RESULT}
echo "Done"
