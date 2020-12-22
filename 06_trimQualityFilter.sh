#==================================================================================================
#   File: 6_trimQualityFilter.sh
#   Date: Nov 25, 2020
#   Description: Use Trimmomatic to trim reads and quality filter
#--------------------------------------------------------------------------------------------------
#	Authors: Jared Homola
#==================================================================================================

RUN_PATH=/mnt/home/homolaj1/gobies/lib18
SCR=/mnt/gs18/scratch/users/homolaj1

mkdir $SCR/gobies/lib18/trimmed
mkdir $RUN_PATH/OUT/Trim_quality_filter_logs

cd $RUN_PATH/SHELL

ls $SCR/gobies/lib18/cloneFilter | grep "fq" | grep -v ".2.2.fq.gz" | grep -v "rem" | sed 's/\.1\.1\.fq\.gz//g' | grep -v "paired" | grep -v "unpaired" | sort | uniq | while read -r LINE
do
echo '#!/bin/sh 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -t 2:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=16G
#SBATCH -J '$LINE'.trimQualityFilter
#SBATCH -o '$RUN_PATH'/QSTAT/trimQualityFilter.'$LINE'.o

module purge
module load Trimmomatic/0.38-Java-1.8.0_162 Java/1.8.0_162

cd '$SCR'/gobies/lib18/cloneFilter
java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.38.jar PE -threads 4 -phred33 '$LINE'.1.1.fq.gz '$LINE'.2.2.fq.gz '$LINE'_paired.1.fq.gz '$LINE'_unpaired.1.fq.gz '$LINE'_paired.2.fq.gz '$LINE'_unpaired.2.fq.gz ILLUMINACLIP:/mnt/home/homolaj1/gobies/lib18/SHELL/dependencies/adapters.fa:2:30:10 SLIDINGWINDOW:4:15 MINLEN:50 

scontrol show job ${SLURM_JOB_ID}' > ./trimQualityFilter."$LINE".sh

sbatch ./trimQualityFilter."$LINE".sh

done