#==================================================================================================
#   File: genotype.sh
#   Date: 11/26/20
#   Description: Genotype using GStacks
#--------------------------------------------------------------------------------------------------
#	Authors: Jared Homola, Seth Smith
#==================================================================================================

### Need to rename files to include "_paired"

for file in * ; do
    mv ./"$file" "${file:0:8}_paired${file:8}"
done

#Define alias for project root directory
RUN_PATH=/mnt/home/homolaj1/gobies/lib18
SCR=/mnt/gs18/scratch/users/homolaj1

cd $RUN_PATH/SHELL

echo '#!/bin/sh 
#SBATCH --nodes=1-8
#SBATCH --ntasks=1
#SBATCH -t 2-0:00:00
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=4G
#SBATCH -J genotype
#SBATCH -o '$RUN_PATH'/QSTAT/genotype.o

module purge
module load GCC/9.3.0  OpenMPI/4.0.3 Stacks/2.54

gstacks -I '$SCR'/gobies/lib18/mapped/filtered -S .pe.sorted.filtered.bam --threads 24 -M '$RUN_PATH'/SHELL/dependencies/popMapAll.map -O '$RUN_PATH'/OUT/genotyped

scontrol show job ${SLURM_JOB_ID} $' > genotype.sh

sbatch genotype.sh

