#==================================================================================================
#   File: 5_removeClones.sh
#   Date: Nov 25, 2020
#   Description: Filter clonal reads from data
#--------------------------------------------------------------------------------------------------
#	Authors: Jared Homola, Seth Smith
#==================================================================================================

#Define alias for project root directory
RUN_PATH=/mnt/home/homolaj1/gobies/lib18
SCR=/mnt/gs18/scratch/users/homolaj1

cd $RUN_PATH/SHELL
ls $SCR/gobies/lib18/demult/ | grep "fq" | grep -v ".2.fq.gz" | grep -v "rem" | sed 's/\.1\.fq\.gz//g' | sort | uniq | while read -r LINE
do

echo '#!/bin/sh 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -t 30:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=32G
#SBATCH -J cloneFilter.'$LINE'
#SBATCH -o '$RUN_PATH'/QSTAT/cloneFilter.'$LINE'.o

module purge
module load GCC/9.3.0  OpenMPI/4.0.3 Stacks/2.54

cd '$SCR'/gobies/lib18/demult
clone_filter -1 ./'$LINE'.1.fq.gz -2 ./'$LINE'.2.fq.gz -i gzfastq -o '$SCR'/gobies/lib18/cloneFilter/

scontrol show job ${SLURM_JOB_ID}' > ./cloneFilter."$LINE".sh

sbatch ./cloneFilter."$LINE".sh

done