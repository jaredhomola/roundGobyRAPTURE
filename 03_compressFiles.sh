#==================================================================================================
#   File: 3_compressFiles.sh
#   Date: Nov 24, 2020
#   Description: Recompress files for input into stacks
#--------------------------------------------------------------------------------------------------
#   Author: Jared Homola
#==================================================================================================

RUN_PATH=/mnt/home/homolaj1/gobies/lib18
SCR=/mnt/gs18/scratch/users/homolaj1

cd $RUN_PATH/SHELL

ls $SCR/gobies/lib18/flipped | grep flipped | grep -v ".2.fq" | awk -F ".1.fq" '{print $1}' | uniq | sort | while read -r LINE
do
echo '#!/bin/sh 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -t 3:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH -J compress_'$LINE'
#SBATCH -o '$RUN_PATH'/QSTAT/compress.'$LINE'.o

module purge

cd '$SCR'/gobies/lib18/flipped

gzip '$LINE'.1.fq
gzip '$LINE'.2.fq

scontrol show job ${SLURM_JOB_ID}' > compressFiles.sh

sbatch compressFiles.sh
done