#!/bin/bash
#
# this script will create and run ELM in the example folder
#
# Yingzi Ying 
# yingzi.ying@me.com

echo "`date`"
echo "----------------------------------------"
DIM=2D
EXE=ELM$DIM
EXAMPLE_FOLDER='./EXAMPLE'
echo "Running $EXE example in example folder $EXAMPLE_FOLDER"

echo "----------------------------------------"
echo
echo "Step 1: create executive."
SRC_FOLDER='./SRC'
EXE_SRC=$EXE.c
cp $EXAMPLE_FOLDER/PARAMETERS.h $SRC_FOLDER

rm -f $EXAMPLE_FOLDER/$EXE
mpiCC $SRC_FOLDER/$EXE_SRC -o $EXAMPLE_FOLDER/$EXE

echo "----------------------------------------"
echo
NPROC=4
echo "Step 2: run $EXE. Number of processes: $NPROC."
cd $EXAMPLE_FOLDER
mpiexec -np $NPROC $EXE
