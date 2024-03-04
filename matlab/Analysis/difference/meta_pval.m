function [pval_Stouffer_wei, z_socre] = meta_pval(p, diff, sample_size)
format long
p=abs(p);
p = p/2;
%%%%%%%%%%%% Fisher's method
% chi_square = -2*(sum(log(p)));
% pval_Fisher = 1-chi2cdf(chi_square, 2*length(p));
% 
% %%%%%%%%%%%% Stouffer's Z-score method
% [z_socre] = norminv(1-p);
% z_all = sum(z_socre)/sqrt(length(p));
% pval_Stouffer = 1-normcdf(z_all);

%%%%%%%%%%%% weighted Stouffer's Z-score method
indx1 = find(p<1e-16);
p(indx1)=1e-16;
z_socre_wei = norminv(1-p).*sign(diff);
weigth = sqrt(sample_size);
z_all_wei = abs(sum(z_socre_wei.*weigth,2)./sqrt(sum(weigth.*weigth,2)));
pval_Stouffer_wei = 2*(normcdf(z_all_wei,'upper'));
z_socre = sum(z_socre_wei.*weigth,2)./sqrt(sum(weigth.*weigth,2));

end

