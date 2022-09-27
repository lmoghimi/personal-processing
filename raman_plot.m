%Lauren Moghimi
%Plotting Raman Data (updated code)
%5/17/22
% plotting figures
clc
close all
%% Opening the data files and plotting in the same figure
folder_path = 'G:\My Drive\Lab - science work and meetings\Data Measurements\Raman\22-9-26 mFe3O4';

figure
%%input all files that you want plotted below
%all_files = ["3-11-21 Te-EDA on Silica 0-200 60 s 10 p.xlsx";"bulk GeAsTe .5 p 105 s - from 3-23-21 Raman Summary.xlsx"]; %%
all_files = ["100nm_01.txt";"100nm_02.txt";"100nm_03.txt";"100nm_04.txt"];
hold on
for m = 1:length(all_files) 
    filename = all_files(m,1)
    full_path = fullfile(folder_path, filename);
    fid = fopen(full_path,'rt');
    
    T = readtable(full_path,'ReadRowNames',false);
    x = T{:,1};
    y = T{:,2};
    y = m*y; %scale vertically to create waterfall plot
    fid = fclose(fid);
    %TF = islocalmax(y);
    %plot(x,y,x(TF),y(TF),'r*',LineWidth=2)
    plot(x,y,LineWidth=2)
end
%% Adjusting Figure Layout
xlabel('Raman Shift (cm^{-1})','FontSize',16)
%xticks(50:25:200) %%
ylabel('a.u.','FontSize',16)
axis([min(x) max(x) 0 max(y)]) %%
%%label the series in the order that they were inputted above
legend(all_files)
hold off
title('100 nm Fe3O4','FontSize',16) %%


