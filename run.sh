#!/bin/bash

# walk through all domain directories in DOMAIN_DIR

DOMAIN_DIR='domains'
RESULT_DIR='results'
CPU_CNT=3

BASE_DIR=`pwd`

function genexp () {
while read planner;
do
	while read experiment;
	do
                while read problem;
                do
                        echo "${experiment};${planner};${problem}"
                done < prob_list
	done < mod_list
done < pla_list
}

function process_domain () {
DOMAIN_PATH=${BASE_DIR}/${DOMAIN_DIR}/$1
RESULT_PATH=${BASE_DIR}/${RESULT_DIR}/$1

echo $DOMAIN_PATH
cd $DOMAIN_PATH

echo "cleaning previous experiments: "
[[ -f "experiments" ]] && rm -f "experiments"
[[ -d "execution" ]] && rm -rf "execution"
[[ -d "$RESULT_PATH" ]] && rm -rf "$RESULT_PATH"

echo "generating list of experiments:"
[[ -f "pla_list" ]] || { echo "ERROR: missing pla_list file"; exit; }
[[ -f "mod_list" ]] || { echo "ERROR: missing mod_list file"; exit; }
[[ -f "prob_list" ]] || { echo "ERROR: missing prob_list file"; exit; }
genexp > experiments

echo "creating result directory:"
[[ -d "$RESULT_PATH" ]] || mkdir -p $RESULT_PATH

echo "executing experiments in parallel:"
cat experiments | parallel -j $CPU_CNT --workdir `pwd` $BASE_DIR/run_one.sh {}

cd $BASE_DIR
}


# if no parameters are given the script will process all domains in $DOMAIN_DIR
# otherwise each parameter should name domain selected for processing

if [ $# -gt 0 ]; then
  echo "Processing specified domains:"
  for D in $@;
  do
	  echo "==== Processing $D ====";
  	process_domain $D
  done
else
  echo "No parameter specified - processing all domains."
  for D in `ls $DOMAIN_DIR | grep -v README.md`;
  do
    echo "==== Processing $D ====";
    process_domain $D
  done
fi
