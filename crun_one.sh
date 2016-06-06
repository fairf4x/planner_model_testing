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

echo "run_one.sh:"
echo "WORKDIR=$WORKDIR"
echo "RESULT_DIR=$RESULT_DIR"
echo "PICAT=$PICAT"
echo "TIMEOUT=$TIMEOUT"

# directory to store generated picat scripts
EXEC_DIR="$DOMAIN_DIR/execution"

[ -d $EXEC_DIR ] || mkdir $EXEC_DIR

# source code for problem instances
TASK_DIR="$DOMAIN_DIR/problems"

# source code for domain definitions
CODE_DIR="$DOMAIN_DIR/models"

function prepare_prog {
# soubor s programem
PROG=$1
PRNAME=${PROG%%.*}
STRING=${PRNAME#*_}
# jmeno benchmarku
BENCH=$2
# pouzity planovac
PLANNER=$3
# adresar pro ulozeni vysledneho programu
EXEC_DIR=$4
# jmeno vysledneho souboru
RESULT="${STRING}_${PLANNER}_${BENCH}.pi"
cat ${CODE_DIR}/${PROG} ${TASK_DIR}/${BENCH} | sed "s/###PLANNER###/${PLANNER}/" > ${EXEC_DIR}/${RESULT} 
# vypis jmeno vysledneho programu
echo $RESULT
}

echo  "executing: ${CODE_DIR}/${MODEL}.pi ${TASK} // using ${PLANNER}"

# prepare program to execute
# echo "prepare_prog ${MODEL}.pi $TASK $PLANNER $EXEC_DIR"

PROGRAM=`prepare_prog ${MODEL}.pi $TASK $PLANNER $EXEC_DIR`

# echo "$PROGRAM"

LOGMODEL=${PROGRAM}_log

# execute program
$TIMEOUT -t $TIME_LIMIT -m $MEM_LIMIT "$PICAT ${EXEC_DIR}/${PROGRAM} ${TASK} >> ${RESULT_DIR}/${MODEL}-${TASK}-${PLANNER} 2>&1" 2> $RESULT_DIR/$LOGMODEL
# $PICAT ${EXEC_DIR}/${PROGRAM} ${TASK} >> ${RESULT_DIR}/${MODEL}_${TASK}_${PLANNER} 2>&1

# rm -f ${EXEC_DIR}/${PROGRAM}
