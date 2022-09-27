%Lauren Moghimi
%Plotting FTIR Data
%5/17/22
%% plotting figures specifically for gomd talk
clc
close all
%% Opening the data files and plotting in the same figure
folder_path = 'C:\Users\Lauren\Documents\Chalcogenide Research\Data\select data for gomd\ftir data';

figure
%%input all files that you want plotted below
all_files = ["6-11-21 UHP GeAsTe-EDA ZnSe from 5-19-21_ref is air.3.xlsx";"Bulk UHP Ge10As15Te75.xlsx";"ZnSe Substrate.xlsx"]; %%
hold on
for m = 1:length(all_files) 
    filename = all_files(m,1)
    full_path = fullfile(folder_path, filename);
    fid = fopen(full_path,'rt');
    
    T = readtable(full_path,'ReadRowNames',false);
    wn = T{:,1};
    int = T{:,2};
    
    fid = fclose(fid);
    plot(wn,100*int,LineWidth=2)
end
%% Adjusting Figure Layout
xlabel('Wavelength (\mum)','FontSize',16)
xticks([2 4 6 8 10 12 14 16 18 20 22 24 26]) %%
xticklabels({'2','','6','','10','','14','','18','','22','','26'}) %%
ylabel('Transmittance (%)','FontSize',16)
axis([min(wn) 25 0 80]) %%
%%label the series in the order that they were inputted above
legend('Solution-Processed Film','Bulk','ZnSe Substrate') %%
hold off