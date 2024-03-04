# %%
# PLSR
from scipy import stats
import pandas as pd
import numpy as np
from pyls import pls_regression
import os
from sklearn.cross_decomposition import PLSRegression
import pathlib
import os
import pickle

def plsr(roi_df, count ,n_components=10,
     n_perm=5000, n_boot=5000,n_proc = 20,
     gene_path='gene_expression.csv',
     out_csvpath1='expression_plsr',
     out_csvpath2='expression_xscore',
     out_modelpath='plsr.pkl',
     out_dir = r'/home/syb/Code/coupling/python/file/gene/SDI_dif/NC_AD/'
     ):
    
    path = pathlib.Path(out_dir)

    if not path.exists():
        path.mkdir()
    
    out_csvpath1 = path / (out_csvpath1 + '_'+str(count) + '.csv')
    out_csvpath2 = path / (out_csvpath2 + '_' + str(count) + '.csv')
    out_modelpath = path / (out_modelpath + '_' + str(count) + '.pkl')
    out_pvalpath = path / ('pval' + '_' + str(count) + '.csv')


    # gene_df = pd.read_csv(gene_path, index_col=None).dropna().reset_index(drop=True)
    
    # es_filtered = roi_df
    # gene_filtered = gene_df[gene_df.index.isin(es_filtered.index)]
    # es_filtered = es_filtered.sort_index()
    # gene_filtered = gene_filtered.sort_index()


    gene_df = pd.read_csv(gene_path, index_col=None).dropna()
    es_filtered = roi_df[roi_df.index.isin(gene_df.index)]
    gene_filtered = gene_df[gene_df.index.isin(es_filtered.index)]
    es_filtered = es_filtered.sort_index()
    gene_filtered = gene_filtered.sort_index()
    roi_name = list(es_filtered.index)
    #print(gene_filtered)
    print(es_filtered.index.shape)
    print(roi_name)
    x = gene_filtered.values
    print(x.shape)
    y = np.expand_dims(es_filtered.values,axis=1)
    print(y.shape)
    plsr = pls_regression(x, y, n_components=n_components, n_perm=n_perm,n_boot=n_boot, n_proc = n_proc)
    # n_proc = 20
    print(plsr.varexp)
    print(plsr.permres.pvals)
    pvals = pd.DataFrame({'varexp': plsr.varexp, 'pvals': plsr.permres.pvals})
    pvals.to_csv(out_pvalpath,index=False)
    with open(out_modelpath, 'wb') as ff:
        pickle.dump(plsr, ff)

    pls1 = plsr.x_weights.T[0]
    pls2 = plsr.x_weights.T[1]
    gene_name = list(gene_filtered.columns)
    d = {'gene_name':gene_name, 'pls1':pls1, 'pls2':pls2}
    df = pd.DataFrame(d)
    df.set_index('gene_name')
    df.to_csv(out_csvpath1)

    xscore1 = plsr.x_scores.T[0]
    xscore2 = plsr.x_scores.T[1]
    roi_name=list(es_filtered.index)

    d1 = {'roi_name': roi_name, 'x-score1': xscore1, 'x-score2': xscore2}
    df1 = pd.DataFrame.from_dict(d1, orient='index')
    #df1 = pd.DataFrame(d1)
    #df1.set_index('roi_name')
    df1.to_csv(out_csvpath2)
    return plsr

if __name__ == '__main__':
    #os.environ['WORKON_HOME']="home/syb/Code/coupling/"
    #os.getenv('path')

    z_data = pd.read_csv(r'F:\Code\coupling\matlab\file\MLR_34\dif_nc_ad.csv',header=None)
    print(z_data)
    result = plsr(roi_df = z_data,count='',n_proc = 10,
                              gene_path = r'F:\Code\coupling\python\file\abagen\expression_246.csv',
                              out_dir= r'F:\Code\coupling\matlab\file\MLR_34\gene')
    

    
    # z_NC_AD = pd.read_csv(r'/home/syb/Code/coupling/matlab/file/sub/surface/SDI_dif/SDI_dif_NC_AD.csv', index_col=None,header=None)
    # z_NC_MC = pd.read_csv(r'/home/syb/Code/coupling/matlab/file/sub/surface/SDI_dif/SDI_dif_NC_MC.csv', index_col=None,header=None)
    # z_MC_AD = pd.read_csv(r'/home/syb/Code/coupling/matlab/file/sub/surface/SDI_dif/SDI_dif_MC_AD.csv', index_col=None,header=None)


    # z_dif = pd.concat([z_NC_AD,z_NC_MC,z_MC_AD])
    # print(z_dif)

    # out_path = '/home/syb/Code/coupling/python/file/gene/210_ROI/5000/SDI_dif/'
    # out_dir = ['NC_AD_','NC_MC_', 'MC_AD_']
    # mode_str = ['FA', 'MD', 'NUM']  
    # proc = [10, 20, 50, 100]
    # for mode in range(3):
        
    #     for t_count in [1,2]:
    #         z_data = z_dif.iloc[mode + t_count*3,0:210]
    #         print(z_data)


    #         for n_p in range(len(proc)):
    #             out_path_all = out_path +out_dir[t_count]+ str(proc[n_p])
    #             result = plsr(roi_df = z_data,count=mode_str[mode],n_proc = proc[n_p],
    #                           gene_path = r'/home/syb/Code/coupling/python/file/abagen/expression_210.csv',
    #                           out_dir= out_path_all)
    #             # print(result.varexp)
    #             # print(result.permres.pvals)

