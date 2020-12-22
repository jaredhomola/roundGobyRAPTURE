#==================================================================================================
#   File: bwaIndex.sh
#   Date: Nov 25, 2020
#   Description: Perform BWA indexing
#--------------------------------------------------------------------------------------------------
#	Authors: Jared Homola, Seth Smith
#==================================================================================================

#Define alias for project root directory
RUN_PATH=/mnt/home/homolaj1/gobies/lib18
SCR=/mnt/gs18/scratch/users/homolaj1

cd $RUN_PATH/SHELL

echo '#!/bin/sh 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -t 3:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=72G 
#SBATCH -J bwaIndex
#SBATCH -o '$RUN_PATH'/QSTAT/bwaIndex.o

module load GCC/6.4.0-2.28 OpenMPI/2.1.1 BWA/0.7.17

bwa index /mnt/home/homolaj1/gobies/genome/RoundGoby.contigs.fasta' > bwaIndex.sh

sbatch bwaIndex.sh
