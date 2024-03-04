labelPath = 'F:\Code\coupling\matlab\z_source\gradient\label\mesh.gii';
savePath = 'F:\Code\coupling\matlab\utils\Analysis\gradient\plot';
grad = cla_gradient1(labelPath,FC_raw,n_sub,246,savePath);

%% 获取梯度（对齐方案：分站点 分类型）
% labelPath	画图用的label的文件路径
% dirPath	BOLD数据路径
% numROI	脑区数：设为210即可
% savePath  保存画的图和生成的数据的位置
function [grad] = cla_gradient1(labelPath, FC_raw, numSub,numROI, savePath)   

    
    siteNum = 7;
    subTypeNum = 3;
   
    %% 2、FC Matrix->Similatiry Matrix->Gradient
    %生成梯度模型 采用Procrustes梯度对齐法 因为joint对齐运算量大
    Gp_model=GradientMaps('kernel','na','approach','dm','alignment','pa');    %kernal：Normalized Angle    Dimension Reduction：Diffusion Embedding
    Gp=cell(siteNum,subTypeNum);   
    grad=cell(siteNum,subTypeNum);    %每个被试的梯度
    meanGrad=cell(siteNum,subTypeNum);    %不同站点不同类型分为7*3组，组内求平均梯度
    gradNO=1;   %仅研究了第一梯度
    a=0
    for siteNO=1:siteNum
        for subType=1:subTypeNum 
            a= a+1
            
            grad{siteNO,subType}=zeros(numROI,numSub(siteNO,subType));
            data_FC1 = {};
            for subNO=1:numSub(siteNO,subType) 
                data_FC1{subNO} = FC_raw{siteNO,subType}(:,:,subNO);
            end
            %运行模型，fit将处理cell元组的每个元素（即每个被试）路径中包含spm12会报错，可能是某些函数重名
            Gp{siteNO,subType}=Gp_model.fit(data_FC1);
            for subNO=1:numSub(siteNO,subType) 
                
                grad{siteNO,subType}(:,subNO)=Gp{siteNO,subType}.aligned{subNO}(:,gradNO);
            end
            meanGrad{siteNO,subType}=mean(grad{siteNO,subType},2);   %按行求平均
        end
    end

    %分站点分类型对齐后分别计算平均梯度，将这7*3个平均梯度再次统一对齐，以比较差异
    alignGrad=procrustes_alignment(meanGrad);   %列优先，返回1*21cell 前7个为NC
    save([savePath '\Grad1.mat'],'grad','meanGrad','alignGrad','-v7.3')
    %save([savePath '\gradient.mat'],'Gp','-v7.3')
    %% 3、梯度可视化
    %加载conte69大脑标准空间
%     [surf_lh, surf_rh] = load_conte69();

    surf_lh = read_surface('F:\Code\coupling\matlab\z_source\gradient\S900.L.very_inflated_MSMAll.32k_fs_LR.surf');
    surf_rh = read_surface('F:\Code\coupling\matlab\z_source\gradient\S900.R.very_inflated_MSMAll.32k_fs_LR.surf');
    %加载32k+32k个点对应的脑区编号
    t= gifti(labelPath);
    %脑区数
    Atlas_roi = unique(t.cdata);
    Atlas_roi = Atlas_roi(2:end);
    label=t.cdata;    %脑区编号为1-256中除去20 227 228 247 252 254 255
    label(label>numROI)=0;  %只用210个脑区
    s=unique(label);
    %绘制210parcel梯度图并命名
    h=cell(1,siteNum);
    for siteNO=1:siteNum
        h{siteNO}=plot_hemispheres([alignGrad{siteNO+siteNum*0} ...
            alignGrad{siteNO+siteNum*1} alignGrad{siteNO+siteNum*2}], ...
           {surf_lh,surf_rh},'parcellation',label, ...
            'labeltext', {'NC' 'MCI' 'AD'});
        %h{siteNO}.figure.Name=['Site' num2str(siteNO) ' 210parcel' ];
        %saveas(h{siteNO}.figure,[savePath '\plot_210parcel_grad\' h{siteNO}.figure.Name '.png']);
    end
end
