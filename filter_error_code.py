# checked files
# lm_train.txt
# "/home/dl0812509/espnet/egs2/aishell_hw/asr1/exp/asr_train_asr_conformer_test_raw_char/decode_asr_transformer_asr_model_valid.acc.ave/org/dev/logdir/keys.1.scp"
# "/home/dl0812509/espnet/egs2/aishell_hw/asr1/dump_orig/raw/train/text"



i = 0
f = open('filtered_transcript.txt','rb')
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
            