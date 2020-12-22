#==================================================================================================
#   File: 10_sortBAM.sh
#   Date: 11/28/20
#   Description: Sort BAM files
#--------------------------------------------------------------------------------------------------
#	Authors: Jared Homola, Seth Smith
#==================================================================================================

#Define alias for project root directory
RUN_PATH=/mnt/home/homolaj1/gobies/lib18
SCR=/mnt/gs18/scratch/users/homolaj1

mkdir $RUN_PATH/QSTAT/sortBAM
mkdir $RUN_PATH/SHELL/sortBAM_jobs
mkdir $RUN_PATH/OUT/discLib/trimmedFiltered/mapped/sorted

cd $RUN_PATH/SHELL

ls $SCR/gobies/lib18/mapped | grep bam | awk -F "." '{print $1}' | sort | uniq | while read -r LINE
do

echo '#!/bin/sh 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -t 1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH -J sortBAM_'$LINE'
#SBATCH -o '$RUN_PATH'/QSTAT/sortBAM.'$LINE'.o

module purge
module load GCC/6.4.0-2.28 OpenMPI/2.1.1 SAMtools/1.9

cd '$SCR'/gobies/lib18/mapped

samtools sort '$LINE'.pe.bam -o ./sorted/'$LINE'.pe.sorted.bam

scontrol show job ${SLURM_JOB_ID}' > ./sortBAM."$LINE".sh

sbatch ./sortBAM."$LINE".sh

done