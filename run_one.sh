#!/bin/bash

PICAT=`which picat`

# constrain is a script which ensure that the proces is terminated if it breaks time or memory limits
TIMEOUT=`which constrain`

# limit computation to 30 min
TIME_LIMIT=1800

# limit computation to 1G of RAM
MEM_LIMIT=1000000

# adresar pro ukladani vysledku
RESULT_DIR=`echo $PWD | sed 's/domains/results/'`

mkdir -p $RESULT_DIR

echo "run_one.sh:"
echo "RESULT_DIR=$RESULT_DIR"
echo "PICAT=$PICAT"
echo "TIMEOUT=$TIMEOUT"

# adresar pro docasne kody spoustenych programu
EXEC_DIR="execution"

[ -d $RESULT_DIR ] || mkdir $RESULT_DIR
[ -d $EXEC_DIR ] || mkdir $EXEC_DIR

# adresar s kody problemovych instanci
TASK_DIR="problems"

# adresar s cistymi zakladnimi kody
CODE_DIR="models"

ARGS=$1

FILE=${ARGS%%;*}
REST=${ARGS#*;}
PLANNER=${REST%%;*}
TASK=${REST#*;}

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

echo  "executing: ${CODE_DIR}/${FILE}.pi ${TASK} // using ${PLANNER}"

# prepare program to execute

#echo "prepare_prog ${FILE}.pi $TASK $PLANNER $EXEC_DIR"

PROGRAM=`prepare_prog ${FILE}.pi $TASK $PLANNER $EXEC_DIR`

#echo "$PROGRAM"

LOGFILE=${PROGRAM}_log

# execute program
$TIMEOUT -t $TIME_LIMIT -m $MEM_LIMIT "$PICAT ${EXEC_DIR}/${PROGRAM} ${TASK} >> ${RESULT_DIR}/${FILE}-${TASK}-${PLANNER} 2>&1" 2> $RESULT_DIR/$LOGFILE
#$PICAT ${EXEC_DIR}/${PROGRAM} ${TASK} >> ${RESULT_DIR}/${FILE}_${TASK}_${PLANNER} 2>&1

#rm -f ${EXEC_DIR}/${PROGRAM}
