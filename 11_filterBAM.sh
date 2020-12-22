#==================================================================================================
#   File: filterBAM.sh
#   Date: Nov 25, 2020
#   Description: Filter BAM files
#--------------------------------------------------------------------------------------------------
#	Authors: Jared Homola, Seth Smith
#==================================================================================================

#Define alias for project root directory
RUN_PATH=/mnt/home/homolaj1/gobies/lib18
SCR=/mnt/gs18/scratch/users/homolaj1

cd $RUN_PATH/SHELL
ls $SCR/gobies/lib18/mapped/sorted | grep bam | awk -F "." '{print $1}' | sort | uniq | while read -r LINE
do
echo '#!/bin/sh 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -t 1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH -J filterBAM_'$LINE'
#SBATCH -o '$RUN_PATH'/QSTAT/filterBAM.'$LINE'.o

module purge
module load GCC/6.4.0-2.28 OpenMPI/2.1.1 SAMtools/1.9

cd '$SCR'/gobies/lib18/mapped/sorted
samtools view -q 20 -h -f2 -F2308  '$LINE'.pe.sorted.bam | samtools view -Sb > ../filtered/'$LINE'.pe.sorted.filtered.bam

scontrol show job ${SLURM_JOB_ID}' > ./sortBAM."$LINE".sh

sbatch ./sortBAM."$LINE".sh

done