#==================================================================================================
#   File: Flip_reads.sh
#   Date: 11/24/20
#   Description: Flip the orientation of the Best RAD reads
#--------------------------------------------------------------------------------------------------
#	Authors: Jared Homola
#==================================================================================================

#Define alias for project root directory
RUN_PATH=/mnt/home/homolaj1/gobies/lib18
SCR=/mnt/gs18/scratch/users/homolaj1

cd $RUN_PATH/SHELL

echo '#!/bin/sh 
#SBATCH --nodes=1-12
#SBATCH --ntasks=1
#SBATCH -t 2-0:00:00
#SBATCH --cpus-per-task=12
#SBATCH --mem-per-cpu=16G
#SBATCH -J flipReads
#SBATCH -o '$RUN_PATH'/QSTAT/flipReads.o

mkdir '$SCR'/gobies/lib18/unzipped
mkdir '$SCR'/gobies/lib18/flipped

## Unzip
for f in '$RUN_PATH'/RAW/*.gz; do
  STEM=$(basename "${f}" .gz)
  gunzip -c "${f}" > '$SCR'/gobies/lib18/unzipped/"${STEM}"
done

cd '$RUN_PATH'
## Flip
perl ./SHELL/dependencies/bRAD_flip_trim.pl ./SHELL/dependencies/barcodes.txt '$SCR'/gobies/lib18/unzipped/RAD1_1.fq '$SCR'/gobies/lib18/unzipped/RAD1_2.fq '$SCR'/gobies/lib18/flipped/RAD1_flipped.1.fq '$SCR'/gobies/lib18/flipped/RAD1_flipped.2.fq
perl ./SHELL/dependencies/bRAD_flip_trim.pl ./SHELL/dependencies/barcodes.txt '$SCR'/gobies/lib18/unzipped/RAD2_1.fq '$SCR'/gobies/lib18/unzipped/RAD2_2.fq '$SCR'/gobies/lib18/flipped/RAD2_flipped.1.fq '$SCR'/gobies/lib18/flipped/RAD2_flipped.2.fq
perl ./SHELL/dependencies/bRAD_flip_trim.pl ./SHELL/dependencies/barcodes.txt '$SCR'/gobies/lib18/unzipped/RAD3_1.fq '$SCR'/gobies/lib18/unzipped/RAD3_2.fq '$SCR'/gobies/lib18/flipped/RAD3_flipped.1.fq '$SCR'/gobies/lib18/flipped/RAD3_flipped.2.fq
perl ./SHELL/dependencies/bRAD_flip_trim.pl ./SHELL/dependencies/barcodes.txt '$SCR'/gobies/lib18/unzipped/RAD4_1.fq '$SCR'/gobies/lib18/unzipped/RAD4_2.fq '$SCR'/gobies/lib18/flipped/RAD4_flipped.1.fq '$SCR'/gobies/lib18/flipped/RAD4_flipped.2.fq
perl ./SHELL/dependencies/bRAD_flip_trim.pl ./SHELL/dependencies/barcodes.txt '$SCR'/gobies/lib18/unzipped/RAD5_1.fq '$SCR'/gobies/lib18/unzipped/RAD5_2.fq '$SCR'/gobies/lib18/flipped/RAD5_flipped.1.fq '$SCR'/gobies/lib18/flipped/RAD5_flipped.2.fq
perl ./SHELL/dependencies/bRAD_flip_trim.pl ./SHELL/dependencies/barcodes.txt '$SCR'/gobies/lib18/unzipped/RAD6_1.fq '$SCR'/gobies/lib18/unzipped/RAD6_2.fq '$SCR'/gobies/lib18/flipped/RAD6_flipped.1.fq '$SCR'/gobies/lib18/flipped/RAD6_flipped.2.fq
perl ./SHELL/dependencies/bRAD_flip_trim.pl ./SHELL/dependencies/barcodes.txt '$SCR'/gobies/lib18/unzipped/RAD7_1.fq '$SCR'/gobies/lib18/unzipped/RAD7_2.fq '$SCR'/gobies/lib18/flipped/RAD7_flipped.1.fq '$SCR'/gobies/lib18/flipped/RAD7_flipped.2.fq
perl ./SHELL/dependencies/bRAD_flip_trim.pl ./SHELL/dependencies/barcodes.txt '$SCR'/gobies/lib18/unzipped/RAD8_1.fq '$SCR'/gobies/lib18/unzipped/RAD8_2.fq '$SCR'/gobies/lib18/flipped/RAD8_flipped.1.fq '$SCR'/gobies/lib18/flipped/RAD8_flipped.2.fq

scontrol show job ${SLURM_JOB_ID} $' > Flip_reads.sh

sbatch Flip_reads.sh


