box_new(SDI_yeo17)

function [] = box_new(SDI_yeo7)
load carsmall;

title('Miles per Gallon by Vehiclen')
xlabel('Country of Origin')
ylabel('Miles per Gallon (MPG)')

a = squeeze(SDI_yeo7(1,:,:));
boxplot(a)
end