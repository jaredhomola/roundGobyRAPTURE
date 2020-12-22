#==================================================================================================
#   File: 1_rename.FastQC.sh
#   Date: Nov 24, 2020
#   Description: Rename raw libraries from Novogene and run FastQC on them
#--------------------------------------------------------------------------------------------------
#   Author: Jared Homola
#==================================================================================================

RUN_PATH=/mnt/home/homolaj1/gobies/lib18

cd $RUN_PATH/SHELL

echo '#!/bin/sh 
#SBATCH -N 1
#SBATCH -t 8:00:00
#SBATCH --mem 16G 
#SBATCH -J rename.FastQC
#SBATCH -o '$RUN_PATH'/QSTAT/rename.FastQC.o

module load FastQC/0.11.7-Java-1.8.0_162

cd '$RUN_PATH'/RAW/usftp21.novogene.com/raw_data/

mv ./RAD1/RAD1_CKDL200166734-1a-2_HF5FLBBXX_L2_1.fq.gz ../../RAD1_1.fq.gz
mv ./RAD1/RAD1_CKDL200166734-1a-2_HF5FLBBXX_L2_2.fq.gz ../../RAD1_2.fq.gz
mv ./RAD2/RAD2_CKDL200166734-1a-4_HF5FLBBXX_L2_1.fq.gz ../../RAD2_1.fq.gz
mv ./RAD2/RAD2_CKDL200166734-1a-4_HF5FLBBXX_L2_2.fq.gz ../../RAD2_2.fq.gz
mv ./RAD3/RAD3_CKDL200166734-1a-5_HF5FLBBXX_L2_1.fq.gz ../../RAD3_1.fq.gz
mv ./RAD3/RAD3_CKDL200166734-1a-5_HF5FLBBXX_L2_2.fq.gz ../../RAD3_2.fq.gz
mv ./RAD4/RAD4_CKDL200166734-1a-20_HF5FLBBXX_L2_1.fq.gz ../../RAD4_1.fq.gz
mv ./RAD4/RAD4_CKDL200166734-1a-20_HF5FLBBXX_L2_2.fq.gz ../../RAD4_2.fq.gz
mv ./RAD5/RAD5_CKDL200166734-1a-7_HF5FLBBXX_L2_1.fq.gz ../../RAD5_1.fq.gz
mv ./RAD5/RAD5_CKDL200166734-1a-7_HF5FLBBXX_L2_2.fq.gz ../../RAD5_2.fq.gz
mv ./RAD6/RAD6_CKDL200166734-1a-12_HF5FLBBXX_L2_1.fq.gz ../../RAD6_1.fq.gz
mv ./RAD6/RAD6_CKDL200166734-1a-12_HF5FLBBXX_L2_2.fq.gz ../../RAD6_2.fq.gz
mv ./RAD7/RAD7_CKDL200166734-1a-19_HF5FLBBXX_L2_1.fq.gz ../../RAD7_1.fq.gz
mv ./RAD7/RAD7_CKDL200166734-1a-19_HF5FLBBXX_L2_2.fq.gz ../../RAD7_2.fq.gz
mv ./RAD8/RAD8_CKDL200166734-1a-18_HF5FLBBXX_L2_1.fq.gz ../../RAD8_1.fq.gz
mv ./RAD8/RAD8_CKDL200166734-1a-18_HF5FLBBXX_L2_2.fq.gz ../../RAD8_2.fq.gz

for i in '$RUN_PATH'/RAW/*.fq.gz
do
        fastqc -o '$RUN_PATH'/OUT/fastqc/ $i
done

scontrol show job ${SLURM_JOB_ID} $' > Rename_Run_FastQC.sh

sbatch Rename_Run_FastQC.sh




