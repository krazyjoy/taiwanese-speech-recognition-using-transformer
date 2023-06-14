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