#!/usr/bin/env bash

# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}
prefix=/home/0812509/espnet/egs2/aishell_hw1/asr1/downloads
RAWFolder=RAW  # 未經sox處理的all音檔
trainFolder=${prefix}/data_aishell/wav/train/-global # 目標處理後檔案位置
devFolder=data_aishell/wav/dev/-global
testFolder=data_aishell/wav/test/-global
 


cd $prefix


cd $RAWFolder
cd train   # 需要改成"dev", "test"更改目的位置
echo now: $PWD
files=(*.wav) # 對所有wav
total=${#files[@]}
i=0
for f in "${files[@]}"; do
    i=$(( i + 1 ))
    echo index $i
    echo total $total
    echo $f
    sox $f -r 16000 -e signed-integer -b 16  ori_output/$f  # sox 轉換sample rate from 25.2K hz to 16k hz 指令
    sox --i ori_output/$f
done
