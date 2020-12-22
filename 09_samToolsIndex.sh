#==================================================================================================
#   File: samtoolsIndex.sh
#   Date: 11/28/20
#   Description: Perform faidx indexing in SamTools
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
#SBATCH --mem-per-cpu=54G 
#SBATCH -J samtoolsIndex
#SBATCH -o '$RUN_PATH'/QSTAT/samtoolsIndex.o

module load GCC/6.4.0-2.28 OpenMPI/2.1.1 SAMtools/1.9

samtools faidx /mnt/home/homolaj1/gobies/genome/RoundGoby.contigs.fasta' > samtoolsIndex.sh

sbatch samtoolsIndex.sh
