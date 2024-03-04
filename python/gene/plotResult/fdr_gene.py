import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.pyplot import MultipleLocator
from PIL import Image



re = pd.read_csv(r'F:\Code\coupling\python\file\gene\enrich_result\Project_wg_result1680578320\enrichment_results_wg_result1680578320.txt',delimiter='\t')

fdrP = re['FDR'].values

a = -np.log10(fdrP)
a[0] = 4
re.insert(loc=0,column='log10P',value=a)

print(re["description"])


def get_color():
    a=1


img = Image.open(r'D:\User\Desktop\meatspace_NC-AD-FA-246\colormap.png')
#a = img[25,25,:]
out = img.convert("RGB")
out1 = np.array(out)
print(out1.shape)
color = []
colorNum = np.zeros([20,3])

out2 = plt.imread(r'D:\User\Desktop\meatspace_NC-AD-FA-246\colormap.png')

for i in range(20):

    a = out1[int((0.5+i)/20 *1200),25,:]
    str1 = '#' + hex(a[0])[2:] +hex(a[1])[2:] + hex(a[2])[2:]
    color.append(str1)
    colorNum[19-i,:] = out2[int((0.5+i)/20 *1232),25,0:3]


color
colorNum
