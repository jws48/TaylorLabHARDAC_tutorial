#!/bin/bash
#
##SBATCH -p common				# Partition to submit to (comma separated)
#SBATCH -J splitRef				# Job name
#SBATCH -n 1					# Number of cores
#SBATCH -N 1					# Ensure that all cores are on one machine
#SBATCH -t 24-00:00				# Runtime in D-HH:MM (or use minutes)
#SBATCH --mem 10000				# Memory in MB
#SBATCH -o log/pySplit_%A_%a.out 		# File for STDOUT (with jobid = %j) 
#SBATCH -e errorLog/pySplit_%A_%a.err		# File for STDERR (with jobid = %j)   
#SBATCH --array=1-18%6				# Array tasks

module load python/3.7.4-gcb01
module load cutadapt/2.3-gcb01 

echo "$SLURM_ARRAY_TASK_ID"
pair1=$(ls /data/taylorlab/${USER}/TaylorLabHARDAC_tutorial/data/reads/amplicon/1/*.fastq.gz |sort| sed -n ${SLURM_ARRAY_TASK_ID}p)
pair2=$(ls /data/taylorlab/${USER}/TaylorLabHARDAC_tutorial/data/reads/amplicon/2/*.fastq.gz |sort| sed -n ${SLURM_ARRAY_TASK_ID}p)

refdir="/data/taylorlab/${USER}/TaylorLabHARDAC_tutorial/data/refs"
out="/data/taylorlab/${USER}/splitReadsResults"
maxIndel=100

.././splitSyncMultiRefArray.py -numTargets 5 \
-refSeqs $refdir/pfcrt/pfcrt.fasta,$refdir/K13/K13.fasta,$refdir/pfmdr1/pfmdr1.fasta,$refdir/dhfr/dhfr.fasta,$refdir/dhps/dhps.fasta \
-r1 $pair1 \
-r2 $pair2 \
-fPrimers /data/taylorlab/embatalk/adapters/forwardPrimers.fasta \
-rPrimers /data/taylorlab/embatalk/adapters/reversePrimers.fasta \
-maxIndel $maxIndel \
-o $out
