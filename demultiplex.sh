#!/bin/bash

### script for demultiplexing MiSeq RAW data direct from the machines
### copy the name of the output directory in the variable "RUN"

### ToDo ###
### 1. rsync  --> busy
### 2. store run name in a file within the project directories --> done
### 3. list run in a seperate file for track & trace and fair data policy and also for overall metrics 

mkdir -p "MiSeq_runs_total";


# TEMP variables
RUN='220929_M02893_202220059_000000000-KMDG8';

#### ie RUN='200313_M02893_20182053_000000000-CPJGT';#RUN directory

ulimit -n 4000;
# VARIABLES

# data structure variables
DEMULTIPLEX=/mnt/lely_archive/PROJECTS/SBSUSERS/DEMULTIPLEXED/; # new location, data can be stored as archive at this location
MISEQ=$(echo "$RUN" | cut -f2 -d'_');
MISEQname=HWI-"$MISEQ"; # original MiSeq name
#DATAdir=./DEMULTIPLEXED/; # MiSeq directory containing the RUNfolders of every run

DATAdir=/media/"$MISEQname"/Illumina/MiSeqAnalysis/; # MiSeq directory containing the RUNfolders of every run

OUTPUTdir="$DEMULTIPLEX"/"$RUN"/;
#REMOTEarchive=/mnt/lely_archive/harde004/MiSeqBackup/"$RUN"; #due to the new server and location this is obsolete from 11-07-2022
#REMOTEwork=/mnt/lely_scratch/harde004/"$RUN"; #due to the new server and location this is obsolete from 11-07-2022

RUNdir="$DATAdir"/"$RUN";# path to runfolder directory
INPUTdir="$DATAdir/$RUN"/Data/Intensities/BaseCalls/;#path to input directory
SAMPLESHEET="$DATAdir"/"$RUN"/SampleSheet.csv;# current SampleSheet.csv for processing

# storage variables
SAMPLESHEETout=./RUNS/SampleSheets/"$RUN".csv;
METRICS=./RUNS/metrics.txt;



# demultiplex variables
R=4;
W=0;
P=8;
BM=0;
AS=0.9;
MSAR=22;
MTRL=35;
MLL='ERROR';

MEM='--loading-threads "$R" --processing-threads "$p" --writing-threads "$W"';
LOG='--min-log-level "$MLL"';
OPTIONAL1='--adapter-stringency "$AS" --create-fastq-for-index-reads --barcode-mismatches "$BM"';
OPTIONAL2='--mask-short-adapter-reads "$MSAR" --minimum-trimmed-read-length "$MTRL"';

### SCRIPT ###

bcl2fastq -i "$INPUTdir" -o "$OUTPUTdir" --sample-sheet "$SAMPLESHEET" -R "$RUNdir" --barcode-mismatches "$BM" --no-lane-splitting --ignore-missing-positions --ignore-missing-bcls --loading-threads 48 ;

#bcl2fastq -i "$INPUTdir" -o "$OUTPUTdir" --sample-sheet "$SAMPLESHEET" -R "$RUNdir" --adapter-stringency "$AS" --barcode-mismatches "$BM" --ignore-missing-positions --ignore-missing-bcls --no-lane-splitting --loading-threads 16;






echo -e "$RUN" > "$OUTPUTdir"/"$RUN".file;

echo -e "\n\n\ndemultiplexing is klaar\n\n\n\n";


#rsync stuff
#rsync -rvah --progress sbsuser@HWI-M00374:/d/Illumina/MiSeqAnalysis/181211_M00374_20181039_000000000-C5W39/ /home/harde004/

### archive all rawdata based upon the run name
#rsync -rvah $OUTPUTdir harde004@lelycompute-01:$REMOTEarchive;

### copy all rawdata based upon the run name
#rsync -rvah $OUTPUTdir harde004@lelycompute-01:$REMOTEwork;


exit 1
