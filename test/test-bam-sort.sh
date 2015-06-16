#!/bin/bash -eu
set -o pipefail

samtools="./samtools"
sort_opts="-ni"
bams=( $@ ) 

# colors
RED="\033[0;31m"
GREEN="\033[0;32m"
NORMAL="\033[0m"

$samtools sort $sort_opts -O bam -T . -o ${bams[0]%.bam}_0.bam ${bams[0]} 
$samtools sort $sort_opts -O bam -T . -o ${bams[1]%.bam}_1.bam ${bams[1]}
md5sum ${bams[0]%.bam}_0.bam ${bams[1]%.bam}_1.bam \
| paste - - \
| awk '{printf "Tested BAM files"}$1==$3{print " --> '$GREEN'OK'$NORMAL'"}$1!=$3{print " --> '$RED'KO'$NORMAL'"}' \
&& rm ${bams[0]%.bam}_0.bam ${bams[1]%.bam}_1.bam 
