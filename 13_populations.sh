#==================================================================================================
#   File: populations.sh
#   Date: 11/28/20
#   Description: Run Stacks' 'Populations' to generate vcf file
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
#SBATCH -t 1-0:00:00
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=4G
#SBATCH -J populations
#SBATCH -o '$RUN_PATH'/QSTAT/populations.o

module purge
module load GCC/9.3.0  OpenMPI/4.0.3 Stacks/2.54

populations -P '$RUN_PATH'/OUT/genotyped -t 16 -M '$RUN_PATH'/SHELL/dependencies/popMapAll.map --vcf --fasta-loci --ordered-export

scontrol show job ${SLURM_JOB_ID} $' > populations.sh

sbatch populations.sh

