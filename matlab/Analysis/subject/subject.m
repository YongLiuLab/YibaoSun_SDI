all_sub = sum(n_sub,2);
all_sub(:,2:4) = n_sub;

for center = 1:7
    index = (sub_info(:,2) == center);
    [p_age(center)] = anova1(sub_info(index,4), sub_info(index,1) ,'off');
    
    [p_mmse(center)] = anova1(sub_info(index,5), sub_info(index,1) ,'off');
    for group = 1:3
        
        index = (sub_info(:,1) == group) & (sub_info(:,2) == center);
        Age_mean(center,group) = mean(sub_info(index,4));
        Age_SD(center,group) = std(sub_info(index,4));
        
        male(center,group) = length(sub_info(index & (sub_info(:,3) == 1) ,3));
        female(center,group) = length(sub_info(index & (sub_info(:,3) == 2) ,3));
        mmse_mean(center,group) = mean(sub_info(index,5));
        mmse_SD(center,group) = std(sub_info(index,5));
        a = strcat(num2str(male(center,group)),'/',num2str(female(center,group)));
        sex_str{center,group} = strcat(num2str(male(center,group)),'/',num2str(female(center,group)));
        age_str{center,group} = strcat(num2str(Age_mean(center,group),'%.1f'),'+',num2str(Age_SD(center,group),'%.1f'));
        mmse_str{center,group} = strcat(num2str(mmse_mean(center,group),'%.1f'),'+',num2str(mmse_SD(center,group),'%.1f'));
        
        
    end
    a = [male(center,:);female(center,:)];
    [p_sex(center)] = chi2test_local(a);
    
end