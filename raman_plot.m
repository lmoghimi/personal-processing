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
%all_files = ["100nm_01.txt";"100nm_02.txt";"100nm_03.txt";"100nm_04.txt"];

%% Load files
RawData = struct();
for m = 1:length(all_files) 
    filename = all_files(m,1);
    full_path = fullfile(folder_path, filename);
    fid = fopen(full_path,'rt');
    %fprintf(["Loading ",filename,"..."])
    
    T = readtable(full_path,'ReadRowNames',false);
    x = T{:,1};
    y = T{:,2};
    y_max = max(y); y_norm = y/y_max; %normalize
    RawData(m).x = x;
    RawData(m).y = y;
    RawData(m).ynorm = y_norm;

    fid = fclose(fid);
    fprintf('done!\n')
end

%% Substrate division
PlottingVars = struct();
substrate = RawData(2).y;
for m = 1:length(all_files) 
    PlottingVars(m).substrate_div = RawData(m).y ./ substrate;
    y_max = max(PlottingVars(m).substrate_div);
    PlottingVars(m).ynorm = PlottingVars(m).substrate_div / y_max;
end

%% Plot
figure
f = gcf; f.Position = [45 321 760.8000 444];
hold on
xlabel('Raman Shift (cm^{-1})','FontSize',16)
ylabel('Normalized Counts (a.u.)','FontSize',16)
title('5 um Fe3O4','FontSize',16) %%
prompt = "What type of plot do you want? 1=normalized overlay; 2=normalized waterfall \n ";
response = input(prompt);
if response == 1
    for m = 1:length(all_files)
        plot(RawData(m).x,PlottingVars(m).ynorm,LineWidth=2)
    end
    axis([min(RawData(m).x) max(RawData(m).x) 0 1])
    hold off
elseif response == 2
    for m = 1:length(all_files)
        plot(RawData(m).x,PlottingVars(m).ynorm * m,LineWidth=2); %scale vertically to create waterfall plot 
        %TF = islocalmax(y);
        %plot(x,y,x(TF),y(TF),'r*',LineWidth=2)
    end
    axis([min(RawData(m).x) max(RawData(m).x) 0 max(PlottingVars(m).ynorm) * m])
    hold off
end
%legend(all_files,'Location','bestoutside') %%
legend(["5um_01 divided by 5um_02";"5um_02 divided by 5um_02";"5um_03 divided by 5um_02"],'Location','bestoutside');
