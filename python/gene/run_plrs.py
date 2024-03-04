import pandas as pd
import plsr
z_df=pd.read_csv('Z.csv',index_col=None)
print(z_df)
result=plsr.plsr(z_df)
print(result.varexp)
print(result.permres.pvals)