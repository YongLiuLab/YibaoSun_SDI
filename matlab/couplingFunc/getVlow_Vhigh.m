
[Vlow,Vhigh] = LaplacianDecoupling_only(AVG_sub{1,1}{1},TS_raw{1,1});

function [Vlow,Vhigh] = LaplacianDecoupling_only(sc_avg,fc_ts)

W=sc_avg;
X_RS=fc_ts;

%% zscore fMRI timecourses
zX_RS=zscore(X_RS,0,2);

%%
% Number of regions
n_ROI = size(W,1);
% number of subjects
nsubjs_RS=size(zX_RS,3);

%% Symmetric Normalization of adjacency matrix
D=diag(sum(W,2)); %degree
for i = 1:n_ROI
    if D(i,i) == 0
        D(i,i)= 1;
    end
end
D_1 = D^(-1/2);
Wsymm=D^(-1/2)*W*D^(-1/2);
Wnew=Wsymm;

%% compute normalized Laplacian
L=eye(n_ROI)-Wnew;

%% Laplacian Decomposition
[U,LambdaL] = eig(L);
[LambdaL, IndL]=sort(diag(LambdaL));
U=U(:,IndL);

%% Compute weighted zero crossings for Laplacian eigenvectors (Supplementary Figure S1)
ROI = 246;
for u=1:ROI %for each eigenvector
    UU=U(:,u);%-mean(U(:,u));
    summ=0;
    for i=1:ROI -1 %for each connection
        for j=i+1:ROI
            if (UU(i)*UU(j))<0 %if signals are of opposite signs
                summ=summ+(W(i,j)>1);%W(i,j);
            end
            wZC(u)=summ;
        end
    end
end

% figure;plot(wZC);title ('Supplementary Fig. S1');xlabel('Connectome harmonics');ylabel('Weighted zero crossings')

%% Average energy spectral density of resting-state functional data projected on the structural harmonics
clear X_hat_L
for s=1:nsubjs_RS
    X_hat_L(:,:,s)=U'*zX_RS(:,:,s);
end
pow=abs(X_hat_L).^2;
PSD=squeeze(mean(pow,2));

avg=mean(PSD')';
stdPSD=std(PSD')';
upper1=avg+stdPSD;
lower1=avg-stdPSD;
idx = max(PSD')>0 & min(PSD')>0 & mean(PSD')>0;                       

% figure;
% patch([LambdaL(idx)', fliplr(LambdaL(idx)')], [lower1(idx)'  fliplr(upper1(idx)')], [0.8 0.8 0.8]);hold on;plot(LambdaL,avg);xlim([0.05 2]);ylim([0.02 50]);title('Supplementary Fig. S2');xlabel('Harmonic Frequency');ylabel('Energy')
% set(gca, 'XScale', 'log', 'YScale','log')

%% compute cut-off frequency
mPSD=mean(PSD,2);
AUCTOT=trapz(mPSD(1:ROI)); %total area under the curve
i=0;
AUC=0;
while AUC<AUCTOT/2
    AUC=trapz(mPSD(1:i));
    i=i+1;
end
NN=i-1; %CUTOFF FREQUENCY C : number of low frequency eigenvalues to consider in order to have the same energy as the high freq ones
NNL=ROI-NN; 

%% split structural harmonics in high/low frequency
M=fliplr(U); %Laplacian eigenvectors flipped in order (high frequencies first)
Vlow=zeros(size(M));
Vhigh=zeros(size(M));
Vhigh(:,1:NNL)=M(:,1:NNL);%high frequencies= decoupled 
Vlow(:,end-NN+1:end)=M(:,end-NN+1:end);%low frequencies = coupled 

end

