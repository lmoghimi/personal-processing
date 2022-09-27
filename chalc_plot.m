%Lauren Moghimi
%Plotting Chalc Data (updated code): Raman or FTIR
%5/17/22
%% general code for looking at various sets of data in the same figure
clc
close all

%% Number of files that I want to plot from
nf = 2;  %%

%% Opening the data files and plotting in the same figure
%folder_path = uigetdir('C:\Users\Lauren\Downloads')
folder_path = 'C:\Users\Lauren\Documents\Chalcogenide Research\Data\select data for gomd\raman data';
%files = dir(folder_path)

figure
hold on
for m = 1:nf 
    filename = uigetfile({'*.xlsx'},'File Selector',folder_path)
    full_path = fullfile(folder_path, filename);
    fid = fopen(full_path,'rt');
    
    T = readtable(full_path,'ReadRowNames',false);
    x = T{:,1};
    y = T{:,2};
    m
    maxy = max(y) %%want to keep track of which data set has the maximum y so that the overall plot can be scaled appropriately (below)
    fid = fclose(fid);
    plot(x,y)
end
%% Adjusting Figure Layout
%xlabel('Wavelength (\mum)')
%ylabel('Transmittance (%)')
%axis([min(x) max(x) 0 0.8])
xlabel('Raman Shift (cm^(-1))')
ylabel('Intensity')
axis([min(x) max(x) 0 72089]) %%
hold off