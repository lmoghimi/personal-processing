%Lauren Moghimi
%Plotting Raman Data (updated code)
%5/17/22
% This code is used to plot figures
% remember to change the following:
% - folder_path
% - all_files (remember to include the file type)
% - axis
% - legend
% - title
clc
close all
%% Opening the data files and plotting in the same figure
folder_path = 'G:\My Drive\Lab - science work and meetings\Data Measurements\Raman\22-9-26 mFe3O4';

%%input all files that you want plotted below
all_files = ["5um_01.txt";"5um_02.txt";"5um_03.txt"]; %%
%load files
PlottingVars = struct();
for m = 1:length(all_files) 
    filename = all_files(m,1);
    full_path = fullfile(folder_path, filename);
    fid = fopen(full_path,'rt');
    %fprintf(["Loading ",filename,"..."])
    
    T = readtable(full_path,'ReadRowNames',false);
    x = T{:,1};
    y = T{:,2};
    y_max = max(y); y_norm = y/y_max; %normalize
    PlottingVars(m).x = x;
    PlottingVars(m).y = y;
    PlottingVars(m).ynorm = y_norm;
    fid = fclose(fid);
    fprintf('done!\n')
end
%% Plot
figure
hold on
xlabel('Raman Shift (cm^{-1})','FontSize',16)
ylabel('Normalized Counts (a.u.)','FontSize',16)
title('5 um Fe3O4','FontSize',16) %%
for m = 1:length(all_files)
    %y = m*y; %scale vertically to create waterfall plot
    plot(PlottingVars(m).x,PlottingVars(m).ynorm,LineWidth=2)
    %TF = islocalmax(y);
    %plot(x,y,x(TF),y(TF),'r*',LineWidth=2)
end
axis([min(PlottingVars(m).x) max(PlottingVars(m).x) 0 1]) %%
%%label the series in the order that they were inputted above
legend(all_files) %%
hold off



