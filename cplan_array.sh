#!/bin/bash
#$ -wd /lnet/spec/work/people/vodrazka/planner_model_testing
#$ -l mem_free=4G
#$ -l h_vmem=4G
#$ -l h_rt=0:15:00

# variables provided by array index file:

ARRAY_FILE=$1

# get variables from ARRAY_FILE

read DOMAIN PLANNER MODEL TASK CONFIG < <(sed -n ${SGE_TASK_ID}p ${ARRAY_FILE})

# set up directories
WORKDIR=`pwd`
DOMAIN_DIR="$WORKDIR/domains/$DOMAIN"
PLANNER_DIR="$WORKDIR/planners"
RESULT_DIR="$WORKDIR/results/$DOMAIN"

# read config file
COMMAND_TEMPLATE_PATH="${PLANNER_DIR}/${PLANNER}/${CONFIG}"
CONF_ID=${CONFIG%.*}

mkdir -p $RESULT_DIR

echo "cplan_array.sh:"
echo "DOMAIN_DIR=${DOMAIN_DIR}"
echo "RESULT_DIR=${RESULT_DIR}"
echo "CONFIG=${CONFIG}"

[ -d $RESULT_DIR ] || mkdir $RESULT_DIR

# directory with model source codes
MODEL_DIR="${DOMAIN_DIR}/models"

# directory with problem instances
TASK_DIR="${DOMAIN_DIR}/problems/${MODEL}"

LOGFILE="${PLANNER}-${MODEL}-${TASK}-${CONF_ID}_log"

# determine model file and problem file
MODEL_FILE="${MODEL_DIR}/${MODEL}"
TASK_FILE="${TASK_DIR}/${TASK}"
RESULT_FILE="${RESULT_DIR}/${PLANNER}-${MODEL%.*}-${TASK}-${CONF_ID}"

function initializeTemplate() {
TEMPLATE=$1
MODEL=$2
TASK=$3
RESULT=$4
cat ${TEMPLATE} | sed "s#MODEL#${MODEL}#" | sed "s#TASK#${TASK}#" | sed "s#RESULT#${RESULT}#"
}

# fill-in the template
COMMAND=`initializeTemplate ${COMMAND_TEMPLATE_PATH} ${MODEL_FILE} ${TASK_FILE} ${RESULT_FILE}`

# command can contain output redirection ">" which has to be handled as a special case
COMM=${COMMAND%%>*}
REDIR=${COMMAND##*>}

echo "Running planner"
echo "command: ${COMMAND}"
if [ "${COMM}" == "${REDIR}" ];
then
#  no redirection
${COMMAND}
else
#  redirection
${COMM} > ${REDIR}
fi

echo "Done"
