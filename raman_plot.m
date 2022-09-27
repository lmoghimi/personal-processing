%Lauren Moghimi
%Plotting Raman Data (updated code)
%5/17/22
%% plotting figures specifically for gomd talk
clc
close all
%% Opening the data files and plotting in the same figure
folder_path = 'C:\Users\Lauren\Documents\Chalcogenide Research\Data\select data for gomd\raman data';

figure
%%input all files that you want plotted below
all_files = ["3-11-21 Te-EDA on Silica 0-200 60 s 10 p.xlsx";"bulk GeAsTe .5 p 105 s - from 3-23-21 Raman Summary.xlsx"]; %%
hold on
for m = 1:length(all_files) 
    filename = all_files(m,1)
    full_path = fullfile(folder_path, filename);
    fid = fopen(full_path,'rt');
    
    T = readtable(full_path,'ReadRowNames',false);
    x = T{:,1};
    y = T{:,2};
    if m == 2 %%
        y = 2*y;
    end
    fid = fclose(fid);
    %TF = islocalmax(y);
    %plot(x,y,x(TF),y(TF),'r*',LineWidth=2)
    plot(x,y,LineWidth=2)
end
%% Adjusting Figure Layout
xlabel('Raman Shift (cm^{-1})','FontSize',16)
xticks(50:25:200) %%
ylabel('Normalizaed Counts (a.u.)','FontSize',16)
axis([50 200 0 35000]) %%
%%label the series in the order that they were inputted above
legend('Solution-Processed Sample','Bulk')
hold off
title('Laser-Crystallized Measurement','FontSize',16) %%


