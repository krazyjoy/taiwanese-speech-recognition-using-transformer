#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

train_set=train
valid_set=dev
test_sets="dev test"

# 最好的結果: asr_config=conf/train_asr_streaming_conformer.yaml
asr_config=conf/train_asr_streaming_conformer.yaml # conf/train_asr_branchformer.yaml
inference_config=conf/decode_asr_branchformer.yaml

lm_config=conf/train_lm_transformer.yaml
use_lm=false
use_wordlm=false
export CUDA_VISIBLE_DEVICES=0

# speed perturbation related
# (train_set will be "${train_set}_sp" if speed_perturb_factors is specified)


################
# 多加的 #
export CUDA_VISIBLE_DEVICES=0
CUDA_VISIBLE_DEVICES=0
--ngpu 1 \
--use_streaming true \

##################
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
