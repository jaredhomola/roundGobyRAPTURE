#==================================================================================================
#   File: 4_demultiplex.sh
#   Date: Nov 25, 2020
#   Description: Demultiplex libraries using process_radtags
#--------------------------------------------------------------------------------------------------
#   Author: Jared Homola
#==================================================================================================

RUN_PATH=/mnt/home/homolaj1/gobies/lib18
SCR=/mnt/gs18/scratch/users/homolaj1

cd $RUN_PATH/SHELL

ls $SCR/gobies/lib18/flipped | grep flipped | grep -v ".2.fq" | awk -F ".1.fq" '{print $1}' | uniq | sort | while read -r LINE
do
echo '#!/bin/sh 
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH -t 12:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH -J demultiplex_'$LINE'
#SBATCH -o '$RUN_PATH'/QSTAT/demultiplex_'$LINE'.o

module purge
module load GCC/9.3.0  OpenMPI/4.0.3 Stacks/2.54

process_radtags \
    -1 '$SCR'/gobies/lib18/flipped/'$LINE'.1.fq.gz \
    -2 '$SCR'/gobies/lib18/flipped/'$LINE'.2.fq.gz \
    -i gzfastq \
    -y gzfastq \
    -o '$SCR'/gobies/lib18/demult/ \
    -b '$RUN_PATH'/SHELL/dependencies/'$LINE'_barcodes.txt \
    --inline_null \
    -e pstI \
    --barcode_dist_1 1 \
    --retain_header

scontrol show job ${SLURM_JOB_ID}' > demultiplex.sh

sbatch demultiplex.sh
done
