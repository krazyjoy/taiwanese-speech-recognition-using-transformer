[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/5cu7ZNPo)
# 台語語音辨認任務
- https://www.kaggle.com/competitions/deep-learningnycu-2023-wav2vec
- 期間: 4/15/2023 - 5/7/2023
- 資料集: 單人女生聲音，台語語音音檔 (https://suisiann-dataset.ithuan.tw/)
    - 資料格式:  `.wav`檔
    - 採樣率: 32 bits
    - 聲道: mono
    - 頻率: 22kHz
- 輸出: 轉文字台羅拼音

## Models Using ESPnet Toolkit
- what is ESPnet? An end-to-end speech processing toolkit.
    - Tasks covered by ESPnet: end-to-end speech recognition, text-to-speech, speech translation,...
    - Deep Learning Engine: Pytorch
    - Data Processing Style & Feature Extraction: Kaldi
- How to use ESPnet: use recipes to complete setup for speech processing experiments 


# AutomaticSpeechRecognition ESPNET-AISHELL


## 前處理
1. 濾掉transcript.txt的非utf-8符號
```
# checked files
# lm_train.txt
# "/home/dl0812509/espnet/egs2/aishell_hw/asr1/exp/asr_train_asr_conformer_test_raw_char/decode_asr_transformer_asr_model_valid.acc.ave/org/dev/logdir/keys.1.scp"
# "/home/dl0812509/espnet/egs2/aishell_hw/asr1/dump_orig/raw/train/text"



i = 0
f = open('tokens2.txt','rb')
while True:
    i += 1
    #print(i)
    line = f.readline()
    if not line:
        break
    else:
        try:
            print('correct')
            line.decode('utf-8')
        except:
            print(i)
            print('cannot not decode',str(line))
            
```
2. 將音檔sampling rate改為16K、16bit 
RAW資料夾: 未經處裡的data
```
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
RAWFolder=RAW
trainFolder=${prefix}/data_aishell/wav/train/-global
devFolder=data_aishell/wav/dev/-global
testFolder=data_aishell/wav/test/-global
 


cd $prefix


cd $RAWFolder
cd processed

echo now: $PWD
files=(*.wav)
total=${#files[@]}
i=0
for f in "${files[@]}"; do
    i=$(( i + 1 ))
    echo index $i
    echo total $total
    echo $f
    sox $f -r 16000 -e signed-integer -b 16  ori_output/$f
    sox --i ori_output/$f
done
```
## 檔案放置架構圖

將處理過的wav檔案從`processed` 資料夾，全部複製到train/global裡面，dev/global 資料夾放置2400~3199的音檔，test/global
```
[我的資料夾名稱(aishell_hw1)]
    asr1
        conf
        downloads (自建資料夾)
            data_aishell
                wav
                    train
                        [你的speaker名稱1]
                            *.wav
                        [你的speaker名稱1]
                            *.wav
                            ...
                    dev
                        [你的speaker名稱1]
                            *.wav
                        [你的speaker名稱1]
                            *.wav
                            ...
                    test
                        [你的speaker名稱1]
                            *.wav
                        [你的speaker名稱1]
                            *.wav
                            ...
                transcript
                    filtered_alpha.txt (已經過sox處理)
            resource_aishell
                lexicon.txt (你的字典)
                speaker.info(你所有的speakers)
    其他
```

## speaker only one
```
[我的資料夾名稱(aishell_hw1)]
    asr1
        conf
        downloads (自建資料夾)
            data_aishell
                wav
                    train
                        [global]
                            *.wav
                        
                    dev
                        [global]
                            *.wav
                    test
                        [global]
                            *.wav
                            ...
                transcript
                    filtered_alpha.txt (已經過sox處理)
            resource_aishell
                lexicon.txt (你的字典)
                speaker.info(你所有的speakers)
    其他
```

speaker.info程式:
    `global F`


--------------------------

## 更改local/data.sh

`C:\Users\User\desktop\DL_HW\HW1\aishell_hw1\aishell_hw1\asr1\local\data.sh`

1. 取消下載資料集`
```
# echo local/download_and_untar.sh ${download_opt} "${AISHELL}" "${data_url}" data_aishell
# local/download_and_untar.sh ${download_opt} "${AISHELL}" "${data_url}" data_aishell
# echo local/download_and_untar.sh ${download_opt} "${AISHELL}" "${data_url}" resource_aishell
# local/download_and_untar.sh ${download_opt} "${AISHELL}" "${data_url}" resource_aishell
```
2. 更改訓練音檔與翻譯文字檔位置與檔名

`${AISHELL}`定義在 `db.sh`，這裡其實就是`downloads`
```
aishell_audio_dir=${AISHELL}/data_aishell/wav
aishell_text=${AISHELL}/data_aishell/transcript/filtered_alpha.txt
```
3. 搜尋音檔by路徑

```
grep -i "wav/train/-global" $tmp_dir/wav.flist > $train_dir/wav.flist || exit 1;
grep -i "wav/dev/-global" $tmp_dir/wav.flist > $dev_dir/wav.flist || exit 1;
grep -i "wav/test/-global" $tmp_dir/wav.flist > $test_dir/wav.flist || exit 1;
```
4. 保留空格
```
# remove space in text
for x in train dev test; do
  cp data/${x}/text data/${x}/text.org
  #paste -d " " <(cut -f 1 -d" " data/${x}/text.org) <(cut -f 2- -d" " data/${x}/text.org | tr -d " ") \
  #    > data/${x}/text
  paste data/${x}/text
  rm data/${x}/text.org
done
```
## 將filter_transcript.txt的test label更改
原本:
test1 a e i o u 
改成:
1 a e i o u
記得音檔與transcript id相對應

```
#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

cd ./downloads/data_aishell/wav/test/-global
for f in *.wav;do
  mv -- "$f" "test_${f}"
done
```

## Convert 2 16K HZ 16 bit Audio files

`C:\Users\User\desktop\espnet-taiwanese-asr1\convert2sixteenHZ`
```
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
prefix=/home/0812509/anaconda3/espnet/egs2/AISHELL_TEST/asr1/downloads
RAWFolder=RAW
trainFolder=${prefix}/data_aishell/wav/train/-global
devFolder=data_aishell/wav/dev/-global
testFolder=data_aishell/wav/test/-global
 


cd $prefix


cd $RAWFolder
cd train
echo now: $PWD
files=(*.wav)
total=${#files[@]}
i=0
for f in "${files[@]}"; do
    i=$(( i + 1 ))
    echo index $i
    echo total $total
    echo $f
    sox $f -r 16000 -e signed-integer -b 16  ori_output/$f
    sox --i ori_output/$f
done
```

## Conformer Config
```
#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

train_set=train
valid_set=dev
test_sets="dev test"

asr_config=conf/train_asr_streaming_conformer.yaml # conf/train_asr_branchformer.yaml
inference_config=conf/decode_asr_branchformer.yaml

lm_config=conf/train_lm_transformer.yaml
use_lm=false
use_wordlm=false
export CUDA_VISIBLE_DEVICES=0

# speed perturbation related
# (train_set will be "${train_set}_sp" if speed_perturb_factors is specified)
speed_perturb_factors="0.9 1.0 1.1"
CUDA_VISIBLE_DEVICES=0
./asr.sh \
    --use_streaming true \
    --nj 32 \
    --inference_nj 32 \
    --ngpu 1 \
    --lang zh \
    --audio_format "flac.ark" \
    --feats_type raw \
    --token_type char \
    --use_lm ${use_lm}                                 \
    --use_word_lm ${use_wordlm}                        \
    --lm_config "${lm_config}"                         \
    --asr_config "${asr_config}"                       \
    --inference_config "${inference_config}"           \
    --train_set "${train_set}"                         \
    --valid_set "${valid_set}"                         \
    --test_sets "${test_sets}"                         \
    --speed_perturb_factors "${speed_perturb_factors}" \
    --asr_speech_fold_length 512 \
    --asr_text_fold_length 150 \
    --lm_fold_length 150 \
    --lm_train_text "data/${train_set}/text" "$@"
```
## Git Push Upload PTH large file:
* 1st commit
```
git init
git lfs track "*.pth"
git add ./HW1/aishell_hw1/aishell_hw1/asr1/exp/asr_train_asr_streaming_conformer_raw_zh_char_sp/33epoch.pth
git commit "33 epoch"
git branch -M main
git remote add origin https://github.com/krazyjoy/transformers_ASR.git
git push -u origin main
```
* afterwards
```
git add ./HW1/aishell_hw1/aishell_hw1/asr1/exp/asr_train_asr_streaming_conformer_raw_zh_char_sp/34epoch.pth
git commit -m "34 epoch"
git push origin main 
```

## ZIP, CP, MV 指令
ZIP all folders in a directory

`zip -r <folder_zip_name.zip> <folder name>`

move all files from one directory to another
`mv ./downloads/RAW/*wav ./downloads/RAW/train`
copy all files from one directory to another
`cp ./downloads/RAW/train/output/* ./downloads/data_aishell/wav/train/-global`

## Sort Test Result.txt
```
import pandas as pd
import string
import os
result_path  = "predictions\\round5"
output_path = result_path

new_context = []
with open(os.path.join(result_path,'unsorted_test.txt'), "r", encoding='utf-8') as f:
        for line in f.readlines():
            line1 = line.split(' ', 1) # split first space
            #label = line1[0].split('_') # split _ from test_#
            #text = line1[1];
            print(line1)
            #newline = [label[0],int(label[1]),text]
            newline = [int(line1[0]),line1[1]]
            new_context.append(newline)

def Sort(sub_li):
      sub_li.sort(key = lambda x: x[0])
      return sub_li
new_context = Sort(new_context)


with open(os.path.join(output_path, "sorted_test.csv"),'w') as f:
    for line in new_context:
        print(line)
        newline = [str(line[0]),line[1]]
        #newline = [str(line[1]),line[2]]
        # label = 
        # text = ' '.join(newline[2:])
        # adddash = [label,text]
        adddash = ','.join(newline)
        f.write(adddash)

# 跑完上面 -> 註解
# 加上頂端的column name

# df1 = pd.read_csv(os.path.join(output_path, "sorted_test.txt"), delimiter=',')
# df1.to_csv(os.path.join(output_path, "sorted_test.csv"), index=False)
```


## 學習內容
1. 透過模仿asr.sh下載檔案之後，資料夾擺放的配置，準備自己的資料
2. 通過自行撰寫如 `convert2sixteenHZ.sh`, `filter_error_code.py`，對多個音檔/翻譯檔做前處理
```
# checked files
# lm_train.txt
# "/home/dl0812509/espnet/egs2/aishell_hw/asr1/exp/asr_train_asr_conformer_test_raw_char/decode_asr_transformer_asr_model_valid.acc.ave/org/dev/logdir/keys.1.scp"
# "/home/dl0812509/espnet/egs2/aishell_hw/asr1/dump_orig/raw/train/text"



i = 0
f = open('tokens2.txt','rb')
while True:
    i += 1
    #print(i)
    line = f.readline()
    if not line:
        break
    else:
        try:
            print('correct')
            line.decode('utf-8')
        except:
            print(i)
            print('cannot not decode',str(line))
            
```
3. 練習使用shell指令，如zip,ls,cp,mv快速地移動或變更資料
4. 嘗試多種可能改善模型表現的參數

