%Lauren Moghimi
%Processing Raw WAXS Data To Normalized Intensity vs. Time
clc
close all
%% Opening the data files
folder_path = uigetdir('G:\.shortcut-targets-by-id\1Ub1KldDI6l3sWEWG-Z3QGCtU-hICQ_SY\Decarbonizing steelmaking')
%                        folder_path = uigetdir('C:\Users\Lauren\Downloads')
%%original_files = dir(folder_path)
filename = uigetfile({'*.dat'},'File Selector', folder_path)
%                        filename = uigetfile({'*.txt'},'File Selector', folder_path)
full_path = fullfile(folder_path, filename);
fid = fopen(full_path,'rt')

opts = detectImportOptions(full_path);
opts.SelectedVariableNames = {'Dspacing_A'}; %%%%%%%%%%%%%only has 5 sigfigs, missing 3
col1 = readtable(full_path, opts);
opts.SelectedVariableNames = {'Intensity'};  %%%%%%%%%%%%%only has 5 sigfigs, missing 3
col2 = readtable(full_path, opts); %%%%%%%%%tables do not always store variables as text. 
% can be different data types. can thus not extract the data from the table
%using {} unless the data is from .txt file
d = col1{:,1};
int = col2{:,1};
%table2array(inPutsT)

%formatSpec = '%f %*f %*f'; %to first column 1
%C1 = textscan(fid,formatSpec)
%[A,count] = fscanf(fileID,'%f')
fid = fclose(fid);

plot(log(d),int)
xlabel('log(d-spacing) (A)')
ylabel('Detector Intensity')
axis([min(log(d)) max(log(d)) 0 1.125*max(int)])
%% Peak Identification
   
%fitobject = fit(d,int,fitType)
%%fitobject = fit(x,y,fitType,fitOptions)



