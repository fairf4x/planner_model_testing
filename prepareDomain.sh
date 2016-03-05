#!/bin/bash

DOMAIN_DIR='domains'

DOMAIN_NAME=$1
PDDL_DIR=$2

echo "Initializing $DOMAIN_NAME"
echo "creating directories:"
echo "${DOMAIN_DIR}/${DOMAIN_NAME}/pddl"
mkdir -p ${DOMAIN_DIR}/${DOMAIN_NAME}/pddl

echo "${DOMAIN_DIR}/${DOMAIN_NAME}/problems"
mkdir ${DOMAIN_DIR}/${DOMAIN_NAME}/problems

echo "${DOMAIN_DIR}/${DOMAIN_NAME}/models"
mkdir ${DOMAIN_DIR}/${DOMAIN_NAME}/models

echo "creating files:"
echo "${DOMAIN_DIR}/${DOMAIN_NAME}/mod_list"
touch ${DOMAIN_DIR}/${DOMAIN_NAME}/mod_list

echo "${DOMAIN_DIR}/${DOMAIN_NAME}/pla_list"
touch ${DOMAIN_DIR}/${DOMAIN_NAME}/pla_list

echo "${DOMAIN_DIR}/${DOMAIN_NAME}/prob_list"
touch ${DOMAIN_DIR}/${DOMAIN_NAME}/prob_list

if [ -z "${PDDL_DIR}" ]; then
  echo "No pddl directory specified - leaving empty.";
else
  echo "Copying pddl files:"
  cp ${PDDL_DIR}/* ${DOMAIN_DIR}/${DOMAIN_NAME}/pddl
fi
