



for siteNO=1:1
    h{siteNO}=plot_hemispheres([alignGrad{siteNO+siteNum*0} ...
        alignGrad{siteNO+siteNum*1} alignGrad{siteNO+siteNum*2}], ...
       {surf_lh,surf_rh},'parcellation',label, ...
        'labeltext', {'NC' 'MCI' 'AD'});
    h{siteNO}.colorlimits = ()
    
    
    %h{siteNO}.figure.Name=['Site' num2str(siteNO) ' 210parcel' ];
    %saveas(h{siteNO}.figure,[savePath '\plot_210parcel_grad\' h{siteNO}.figure.Name '.png']);
end