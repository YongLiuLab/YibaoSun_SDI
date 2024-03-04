mmse_p = [p_log_05{1}(1,:);p_log_05{2}(1,:);p_log_05{3}(1,:)]';
mmse_r = [th_05_fdf{1}(1,:);th_05_fdf{2}(1,:);th_05_fdf{3}(1,:)]';
index = Zth_SDI~=0;
mmse_p_SDI =zeros(246,3);
mmse_r_SDI =zeros(246,3);
mmse_p_SDI(index) = mmse_p(index);
mmse_r_SDI(index) = mmse_r(index);


index_mmse = mmse_p_SDI~=0;

for i = 1:3
    count_mmse(i) = length(find(mmse_p_SDI(:,i)~=0));
    count_SDI(i) = length(find(Zth_SDI(:,i)~=0));
end

logP_SDI = -log10(p_SDI);
a = p_SDI(246,3);

P_SDI_1 = squeeze(p_SDI_3(:,1,:));
z_all_wei = 10;
a1 = normcdf(z_all_wei);
a= 2*(1-normcdf(z_all_wei));
a3 = P_SDI_1(3,246)