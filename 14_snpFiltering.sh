#==================================================================================================
#   File: 14_snpFiltering.sh
#   Date: 11/29/20
#   Description: Filter vcf
#--------------------------------------------------------------------------------------------------
#	Authors: Jared Homola
#==================================================================================================

# Make directory and load modules
#mkdir /mnt/home/homolaj1/gobies/discLib/baitDesign
cd /mnt/home/homolaj1/gobies/lib18/OUT/genotyped
module load GCC/6.4.0-2.28 OpenMPI/2.1.2 VCFtools/0.1.15-Perl-5.26.1

### Initial number of SNPs: 3,602,047
egrep -v "^#" populations.snps.vcf | wc -l

### Just grab SNPs that are within 500 bp of targeted loci. Resulting number of SNPs: 188,610
#vcftools --vcf populations.snps.vcf --bed targets.bed --recode --recode-INFO-all --stdout > targeted.vcf
#egrep -v "^#" targeted.vcf | wc -l 

### Filter at genotype level. Resulting number of SNPs: 3,602,047
#### Could cut minDP to estimate what doubling the number of reads would give
vcftools --vcf populations.snps.vcf --minGQ 20 --minDP 5 --recode --recode-INFO-all --stdout > filteredSNPs-gt.vcf
egrep -v "^#" filteredSNPs-gt.vcf | wc -l  

### Filter out loci first since we're priotizing retaining individuals (test values for missingness)
### Be sure we have the sex ID candidates by prioritizing those to determine max missingness
### max-missing of 0.25 (filteredSNPs2-loc.vcf): 48,245 SNPs
### max-missing of 0.5 (filteredSNPs-loc.vcf): 35,401 SNPs ***
### max-missing of 0.75 (filteredSNPs-loc3.vcf): 16,922 SNPs
vcftools --vcf filteredSNPs-gt.vcf --mac 3 --max-missing 0.5 --recode --recode-INFO-all --stdout > filteredSNPs-loc.vcf
egrep -v "^#" filteredSNPs-loc.vcf | wc -l 

##### Filtering individuals
### Calculate missingness for individuals and retain those with XXX% missing data
### filteredSNPs2-loc (max-missing 0.25; 48,245 SNPs): 0.25: 370 ind;  0.5: 567 ind; 0.75: 627 ind
### filteredSNPs-loc (max-missing 0.5; 35,401 SNPs): 0.25: 507 ind;  0.5: 600 ind; 0.75: 635 ind
### filteredSNPs3-loc (max-missing 0.75; 16,922 SNPs): 0.25: 596 ind;  0.5: 628 ind; 0.75: 657 ind
vcftools --vcf filteredSNPs-loc.vcf --missing-indv --out missingIndv
cat missingIndv.imiss | awk '$5 < 0.75' | awk '{print $1}' > good_individuals.list
less -S good_individuals.list | wc -l

vcftools --vcf filteredSNPs-loc.vcf --keep good_individuals.list --recode --recode-INFO-all --stdout > indFiltered.vcf
egrep -v "^#" indFiltered.vcf | wc -l

###### How many clonal reads are removed?
grep '% clone reads' cloneFilter*.o >> /mnt/home/homolaj1/gobies/lib18/OUT/cloneFilterRes.txt

###### How many reads were trimmed and filtered? ######
grep 'Surviving' trimQualityFilter*.o >> /mnt/home/homolaj1/gobies/lib18/OUT/trimQualityFilterRes.txt

###### Thin sites #######
vcftools --vcf indFiltered.vcf --thin 1000 --recode --recode-INFO-all --stdout > indFiltered.thinned.vcf
egrep -v "^#" indFiltered.thinned.vcf | wc -l
