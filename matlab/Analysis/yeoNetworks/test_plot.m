SDI= SDI_cov_sub;

SDI_list = zeros(3,793,246);

for sc_mode=1:3
    num = 1
    for center=1:7
        for group=1:3
            size_1 = size(SDI{sc_mode}{center,group});
            b = SDI{sc_mode}{center,group}';
            SDI_list(sc_mode,num:num+size_1(2)-1,:) = SDI{sc_mode}{center,group}';
            num=num+size_1(2);  
        end
    end
end

load carsmall;
boxplot(MPG,Origin)
title('Miles per Gallon by Vehicle Origin')
xlabel('Country of Origin')
ylabel('Miles per Gallon (MPG)')

a = squeeze(SDI_yeo17(2,:,:));
boxplot(a)