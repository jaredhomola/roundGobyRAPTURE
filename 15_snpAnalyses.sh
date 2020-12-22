#==================================================================================================
#   File: 15_snpAnalyses.sh
#   Date: 12/9/20
#   Description: Analyze retained SNPs
#--------------------------------------------------------------------------------------------------
#	Authors: Jared Homola
#==================================================================================================

# Make directory and load modules
#mkdir /mnt/home/homolaj1/gobies/discLib/baitDesign
RUN_PATH=/mnt/home/homolaj1/gobies/lib18
SCR=/mnt/gs18/scratch/users/homolaj1
cd /mnt/home/homolaj1/gobies/lib18/OUT/genotyped
module load GCC/6.4.0-2.28 OpenMPI/2.1.2 VCFtools/0.1.15-Perl-5.26.1

### Retained SNPs
vcftools --vcf filteredSNPs-loc.vcf --missing-indv --out ./summaries/missingIndv
vcftools --vcf filteredSNPs-loc.vcf --site-depth --out ./summaries/siteDepth
vcftools --vcf filteredSNPs-loc.vcf --site-mean-depth --out ./summaries/siteDepthMean
vcftools --vcf filteredSNPs-loc.vcf --depth --out ./summaries/indDepthMean


### On target loci
##### Number of reads on target
module load GCC/5.4.0-2.26 OpenMPI/1.10.3 BEDTools/2.27.1
bedtools coverage -a $RUN_PATH/OUT/genotyped/targetedLoci.bed \
    -b $SCR/gobies/lib18/mapped/sorted/*pe.sorted.bam >> $RUN_PATH/OUT/genotyped/onTarget.out

##### Number of mapped reads overall
module load GCC/6.4.0-2.28 OpenMPI/2.1.1 SAMtools/1.9
cd $SCRATCH/gobies/lib18/mapped/sorted/
ls $SCRATCH/gobies/lib18/mapped/sorted | while read -r LINE
do
samtools idxstats $LINE | awk '{s+=$3} END {print s}' >> /mnt/home/homolaj1/gobies/lib18/OUT/genotyped/totalReads.txt
done

### Proportion of SNPs at baited loci in final filtered vcf
module load GCC/6.4.0-2.28 OpenMPI/2.1.2 VCFtools/0.1.15-Perl-5.26.1
vcftools --vcf indFiltered.vcf --bed targetedLoci.bed --recode --recode-INFO-all --stdout > targeted.snps.vcf
egrep -v "^#" indFiltered.vcf | wc -l 
egrep -v "^#" targeted.snps.vcf | wc -l 


### Number of SNPs per locus
module load GCC/5.4.0-2.26 OpenMPI/1.10.3 BEDTools/2.27.1
bedtools intersect -a targetedLoci.bed -b indFiltered.vcf -c > $RUN_PATH/OUT/genotyped/onTarget.snps.out


#### Average individual depth at baited loci before locus filtering #####
module load GCC/6.4.0-2.28 OpenMPI/2.1.2 VCFtools/0.1.15-Perl-5.26.1
vcftools --vcf filteredSNPs-gt.vcf --bed targetedLoci.bed --site-mean-depth --out ./summaries/siteDepthMeanBaitedLoci 