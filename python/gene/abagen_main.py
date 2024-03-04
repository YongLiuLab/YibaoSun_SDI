import abagen
import pandas as pd
# files = abagen.fetch_microarray(donors='all', data_dir = r'F:\Data Brain\abagen-data')
# print(files.keys())

#atlas = abagen.fetch_desikan_killiany(r'D:\User\Desktop\coupling\matlab\file\raw\BN_Atlas_246_1mm.nii')
# print('atlas')
# print(atlas)
expression = abagen.get_expression_data(r'D:\User\Desktop\coupling\matlab\file\raw\BN_Atlas_210_mm.nii',data_dir = r'F:\Data Brain\abagen-data')
print(expression)

expression.to_csv(r'D:\User\Desktop\coupling\python\file\abagen\expression_210.csv',index= False)