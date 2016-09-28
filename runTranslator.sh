#!/bin/bash

PICAT=`which picat`
TRANSLATOR='pddlPiTranslator.pi'
DOMAIN_DIR='domains'

function translate_domain () {
  # single parameter to specify domain
  DOMAIN=$1

  # set input file
  INPUT="${DOMAIN_DIR}/${DOMAIN}/pddl/domain.pddl"

  if [ ! -f ${INPUT} ]; then
      echo "warning: File ${INPUT} not found!"
      echo "Domain file not specified."
      return
  fi


  # set output file
  OUTPUT="${DOMAIN_DIR}/${DOMAIN}/models/${DOMAIN}.pi"

  if [ -f ${OUTPUT} ]; then
      echo "Removing file ${OUTPUT}"
      rm ${OUTPUT}
  fi

  # call the translator
  echo "${PICAT} ${TRANSLATOR} ${INPUT} ${OUTPUT}"
  ${PICAT} ${TRANSLATOR} ${INPUT} ${OUTPUT}
}

function translate_problems () {
  DOMAIN=$1

  INPUT_DIR="${DOMAIN_DIR}/${DOMAIN}/pddl"
  OUTPUT_DIR="${DOMAIN_DIR}/${DOMAIN}/problems"

  echo "Cleaning output dir:"
  echo "rm -f ${OUTPUT_DIR}/*"
  rm ${OUTPUT_DIR}/*

  for PROB in `ls ${INPUT_DIR} | grep -v "domain.pddl"`; do
    INPUT=${INPUT_DIR}/$PROB
    RES=${PROB%.pddl}
    OUTPUT=${OUTPUT_DIR}/${RES}
    echo "${PICAT} ${TRANSLATOR} ${INPUT} ${OUTPUT}"
    ${PICAT} ${TRANSLATOR} ${INPUT} ${OUTPUT}
  done

  echo "Cleaning temporary files:"
  echo "rm ${OUTPUT_DIR}/*_formatted.pddl"
  rm ${OUTPUT_DIR}/*_formatted.pddl

  echo "Renaming resulting problems:"
  for FILE in `ls ${OUTPUT_DIR}`; do
    echo "${FILE} -> ${FILE%.pi}"
    mv ${OUTPUT_DIR}/${FILE} ${OUTPUT_DIR}/${FILE%.pi}
  done
}

# function to perform postprocessing tasks
function finalize_domain () {
  DOMAIN=$1
  # generate new problem list
  ls ${DOMAIN_DIR}/${DOMAIN}/problems/ | tr "\t" "\n" > ${DOMAIN_DIR}/${DOMAIN}/${DOMAIN}_problems

  # remove temporary files from 'models' directory
  rm ${DOMAIN_DIR}/${DOMAIN}/models/*_formatted.pddl

  # find and replace all planner calls in domain model with ###PLANNER###
  sed -i "s/best_plan_bb/###PLANNER###/g" ${DOMAIN_DIR}/${DOMAIN}/models/${DOMAIN}.pi
  sed -i "s/best_plan/###PLANNER###/g" ${DOMAIN_DIR}/${DOMAIN}/models/${DOMAIN}.pi
}

# translate either selected domains or all domains in the DOMAIN_DIR directory

if [ $# -gt 0 ]; then
  echo "Translating specified domains:"
  for D in $@;
  do
    echo "==== Translating $D ====";
    translate_domain $D
    translate_problems $D
    finalize_domain $D
  done
else
  echo "No parameter specified - processing all domains."
  for D in `ls $DOMAIN_DIR`;
  do
    echo "==== Translating $D ====";
    translate_domain $D
    translate_problems $D
    finalize_domain $D
  done
fi
