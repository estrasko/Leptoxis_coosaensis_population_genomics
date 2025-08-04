#This pipeline is for the processing of zipped illumina single end 75 bp files for AlfI 2b-RAD data.
#This pipeline was put together by Matt Galaska with the currently available skynet programs in mind. It has been modified by N. Whelan in Sept 
#2019 with some different scripts

###IT IS YOUR RESPONSIBILITY TO MAKE SURE SCRIPTS ARE IN YOUR PATH OR WORKING DIRECTORY
###This script requires BioPerl.
###This script requires GNU Parallel

#First, I suggest that you move all zipped files into a directory called /raw or other appropriate designation.
#This pipeline will unzip all files, truncate the files down to the AlfI contig size (minus a bp on either side where N's are more abundant).
#It will then discard any poor quality sequences and finally pull out only sequences containing the AlfI restriction site.
#Intermediate files are cleaned throughout the pipeline to keep directory size down as these are large files.

############################
##USES 10 cores by Default##
CORES=16  ##Can be changed##
############################

mkdir raw_backup
cp *.gz raw_backup/
rm Undetermined*.gz ##Removes file with reads that were not demultuiplexed correctly
for FILENAME in *.gz
        do
        gunzip $FILENAME
done

for FILENAME in *.fq
        do
        perl /home/eks0112/Scripts/TruncateFastq.pl -i $FILENAME -s 1 -e 40 -o $FILENAME.truncat
done

mkdir Truncated_Data
cp *.truncat Truncated_Data
rm -rf *.fq
rename .fq.truncat .fq *.fq.truncat

ls *.fq |parallel -j $CORES 'perl /home/eks0112/Scripts/QualFilterFastq.pl -i {} -m 20 -x 5 -o {}.qual' ##Fix directory if necessary
rm -rf *.fq
rename .fq.qual .fastq *.fq.qual

ls *.fastq | parallel -j $CORES '/home/eks0112/Scripts/fastq_to_fasta.txt {} > {}.fasta' #SHRiMP_2_2_3
rm -rf *.fastq
rename .fastq.fasta .fasta *.fastq.fasta


ls *.fasta | parallel -j $CORES '/home/eks0112/Scripts/AlfIExtract.pl {} {}.alf.fasta'
rename .fasta.alf.fasta .fasta *.fasta.alf.fasta
