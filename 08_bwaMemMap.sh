#==================================================================================================
#   File: bwaMemMap.sh
#   Date: 11/28/20
#   Description: Map reads to reference genome using bwa-mem
#--------------------------------------------------------------------------------------------------
#	Authors: Jared Homola, Seth Smith
#==================================================================================================

#Define alias for project root directory
RUN_PATH=/mnt/home/homolaj1/gobies/lib18
SCR=/mnt/gs18/scratch/users/homolaj1

cd $RUN_PATH/SHELL
ls $SCR/gobies/lib18/trimmed | grep ".1.fq.gz" | awk -F "_paired" '{print $1}' | sort | uniq | while read -r LINE
do
echo '#!/bin/sh 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -t 3:59:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=32G
#SBATCH -J '$LINE'.bwaMemMap
#SBATCH -o '$RUN_PATH'/QSTAT/bwaMemMap.'$LINE'.o

module purge
module load GCC/6.4.0-2.28 OpenMPI/2.1.1 BWA/0.7.17 SAMtools/1.9

cd '$SCR'/gobies/lib18/trimmed

bwa mem -R "@RG\tID:'$LINE'\tSM:'$LINE'\tPL:ILLUMINA\tLB:LB1" /mnt/home/homolaj1/gobies/genome/RoundGoby.contigs.fasta ./'$LINE'_paired.1.fq.gz ./'$LINE'_paired.2.fq.gz | samtools view -Sb - > ../mapped/'$LINE'.pe.bam 

scontrol show job ${SLURM_JOB_ID}' > ./bwaMemMap."$LINE".sh

sbatch ./bwaMemMap."$LINE".sh

done


### Log results of mapping

#Define alias for project root directory
RUN_PATH=/mnt/home/homolaj1/gobies/lib18

cd $RUN_PATH/SHELL

echo '#!/bin/sh 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -t 1:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=12G 
#SBATCH -J bwaFlagstats
#SBATCH -o '$RUN_PATH'/bwaFlagstats.o

module purge
module load GCC/8.3.0 SAMtools/1.10

cd '$SCR'/gobies/lib18/mapped

ls | grep ".pe.bam" | sort | uniq | while read -r LINE
do
   echo "$LINE" >> '$RUN_PATH'/OUT/mappingResults.txt
   samtools flagstat "$LINE" >> '$RUN_PATH'/OUT/mappingResults.txt
done' > bwaFlagstats.sh

sbatch bwaFlagstats.sh