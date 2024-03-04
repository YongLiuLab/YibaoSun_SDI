%PlotBrainGraph()

labelPath = 'F:\Code\coupling\matlab\z_source\gradient\label\mesh.gii';
 t= gifti(labelPath);
    %脑区数
    Atlas_roi = unique(t.cdata);
    Atlas_roi = Atlas_roi(2:end);
    label=t.cdata;


siteNum=7;

for mode = 1:3
    for center = 1:7
        [ar_gaSDI(mode,center),ap_gaSDI(mode,center)] = corr(meanGrad{center,1}, squeeze(mean(SDI_cov_sub{mode}{center,1},2)));
    end
end

for siteNO=1:siteNum
    grad_avg_center(siteNO,:) = squeeze(mean(grad{siteNO,1},2));
end
grad_avg = squeeze(mean(grad_avg_center,1));
index = (sub_info(:,1) ==1 );
sdi_avg = squeeze(mean(SDI_list(:,index,:),2)) ;
%[ar,ap] = corr(grad_avg_center(1,:)', sdi_avg(1,:)')
[ar1,ap1] = corr(grad_avg', sdi_avg(1,:)')


for center =1:7
    for group = 1:3
        n_sub_grad(center,group) = length(Gp{center,group}.gradients);
    end
end

a = sum(sum(n_sub_grad));
b = sum(sum(n_sub));
n_sub_grad
n_sub

for mode = 1:3
    count =1;
    for center =1:7
        for group = 1:3
            if 1
                size1 = size(SDI_cov_sub{mode}{center,group});
                for sub = 1: size1(2)
                    [r(mode,count), p(mode,count)] = corr(SDI_cov_sub{mode}{center,group}(1:210,sub),grad{center,group}(1:210,sub));
                    logp(mode,count) = -log10(p(mode,count));
                    
                    count = count+1;
                end
            end
        end
    end
end

for mode = 1:3
    a(mode) = sum(logp(mode,:)>1.3);
end