#!/usr/bin/env bash

# trimmomatic version 0.39
# trimmomatic manual : http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/TrimmomaticManual_V0.32.pdf

WORKING_DIRECTORY=/scratch_vol0/fungi/BIOREMHALO/01_raw_data/Original_reads
OUTPUT=/scratch_vol0/fungi/BIOREMHALO/03_cleaned_data

# Make the directory (mkdir) only if not existe already(-p)
mkdir -p $OUTPUT

ADAPTERFILE=/scratch_vol0/fungi/BIOREMHALO/99_softwares/adapters_sequences.fasta

# Arguments :
# ILLUMINACLIP:"$ADAPTERFILE":2:30:10 LEADING:30 TRAILING:30 SLIDINGWINDOW:26:30 MINLEN:150

eval "$(conda shell.bash hook)"
conda activate trimmomatic

cd $WORKING_DIRECTORY

####################################################
# Cleaning step
####################################################

for R1 in *_1.fastq.gz
do
   # Get the base name without the _1.fastq.gz
   BASENAME=${R1%_1.fastq.gz}
   R2=${BASENAME}_2.fastq.gz

   R1paired=${BASENAME}_1_paired.fastq.gz
   R1unpaired=${BASENAME}_1_unpaired.fastq.gz
   R2paired=${BASENAME}_2_paired.fastq.gz
   R2unpaired=${BASENAME}_2_unpaired.fastq.gz

   echo "Processing $BASENAME..."

   trimmomatic PE -Xmx60G -threads 8 -phred33 \
   $R1 $R2 \
   $OUTPUT/$R1paired $OUTPUT/$R1unpaired \
   $OUTPUT/$R2paired $OUTPUT/$R2unpaired \
   ILLUMINACLIP:"$ADAPTERFILE":2:30:10 \
   LEADING:30 TRAILING:30 SLIDINGWINDOW:26:30 MINLEN:150

done
