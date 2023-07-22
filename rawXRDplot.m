% Lauren Moghimi
% May 29, 2022
% last updated: Jan 23, 2023. restoration of code from May
%
% This code loads all scans from a single XRD experiment and compiles all
% the runs from one experiment into a single plot of intensity vs.
% d-spacing (raw data). The first section of this code was copied from XRD_Fitting 
% to load the scans.
%
% This code also can be used to plot a select number of scans in an experiment, if desired.
% It will plot the desired number of scans with a constant increment of the
% scan number (see below for further instructions).

clc
clear all
close all

% define relevant paths
folder_path = uigetdir('G:\.shortcut-targets-by-id\1Ub1KldDI6l3sWEWG-Z3QGCtU-hICQ_SY\Decarbonizing steelmaking\APS_XRD_20220802');
    dataPath = append(folder_path,'\')
codePath = pwd;

% find all relevant files
files = dir([dataPath,'n*.dat']);

% sort the traces by the scan number
for m=1:length(files)
    % find run number and time number
    filename = files(m).name;
    ind = strfind(filename,'_'); %returns the index of '_' within the file name
    %1st entry in the file name is the experiment name, 2nd is temperature, 3rd is time within the experiment. 4th is run number
    SEQ(m) = str2num(filename(ind(3)+1:ind(4)-1)); %get the scan number
    FileInfo.Experiment.m = filename(1:(ind(1)-1)); %experiment name associated with the scan
    FileInfo.Scan(m) = SEQ(m);
end
[S,IND] = sort(SEQ); %returns the scan number in ascending order and the corresponding m index
 
% now load the files IN ORDER
lf = length(files);
Data = struct('T',zeros(1,lf),'t',zeros(1,lf),'Sequ',zeros(1,lf));
for iNum=1:length(files)
    fNum = IND(iNum);
    fprintf(['Loading file ',num2str(iNum),' as number ',num2str(fNum),' of ',num2str(lf),'...'])
    
    % find run number and time number
    filename = files(fNum).name;
    ind = strfind(filename,'_');
    Data.T(iNum) = str2num(filename(ind(1)+1:ind(2)-2));
    Data.t(iNum) = str2num(filename(ind(2)+1:ind(3)-4));
    Data.Sequ(iNum) = str2num(filename(ind(3)+1:ind(4)-1)); %run number
    
    % now read the file
	a = readtable([dataPath,filename]);
%    plot(a{:,1},a{:,2}+iNum/10); hold on
    
    % save these traces into an image
    UQImage(:,iNum) = a{:,3}; % save the uncertainty values (column 3 in the file)
    Intensity(:,iNum) = a{:,2}; % save the intensity values (column 2 in the file)
    if iNum==1
        Data.d = a{:,1}; %save the d-spacing values (column 1 in the file). this only needs to be done once since this is the independent variable!
    end
    
    %%% only for APS_SAXS_nano_300C_q?
            % note we need to increase from 107 to add 488 minutes to t
            %if iNum > 106
            %    Data.t(iNum) = Data.t(iNum) + 488;
            %end

fprintf('DONE!\n')
end

%% Plot the series of data in one figure
%  Lines of code that one may want to modify are preceded by '%%%'

% For plotting 20 scans in one figure, a standard square figure size with 0.1 or 0.5 separation works
% well. Elongate the figure and reduce the separation for plotting larger numbers of data sets.
% Do not plot more than 20 scans within one figure unless a legend isn't
% desired. For >20 scans, a label would need to be specified for each object in the legend. 
% Otherwise, legend depicts only the first 20 objects in the graph.

figure
hold on
d = flipud(Data.d); %!!!!!!!!!!!!!
%% Files to plot

%%%
nPlot = 1; %desired number of scans to plot

%increment of files to plot. if you want to plot 20 or fewer scans in one figure and you don't want to skip files to plot, then you can set incr to 1
%%%
% incr = ceil(lf/nPlot);
incr = 0;
%%%
firstPlot = 1; %the first series that you want to plot. this will typically be 1


for gNum=1:nPlot
    fNum = firstPlot + (gNum*incr) - 1;
    if fNum > lf 
        fprintf('weird \n'); %make sure that fNum isn't greater than lf. otherwise, something is wrong
    else
        if gNum == 1
            fNum = firstPlot;
        else
            fNum = 1*fNum;
        end

        I = flipud(Intensity(:,fNum)); %!!!!!!!!!!!!!
        I = I-min(I);
        
        %determine verticle shift between each scan
%%%
        sep = 0.1; %desired vertical separation between plotted series 
        shift = gNum*sep; %vertical shift for a given series
        y = shift + I;
        x = d; %this will typically be d. but the 350C dat folder is in 2pi/d, so we need this to be 2*pi./d to put this back into d
        plot(x,y)

        legend_text{gNum} = [' ',num2str(Data.T(fNum)),'C, ',num2str(Data.t(fNum)),'{ min}'];
    end
end

%% Figure formatting

%%%
Title = ['300C',' fNum=',num2str(firstPlot),'-',num2str(fNum)];
title(Title,'interpreter','latex','FontWeight','bold','FontSize',14) 

axes_fontsize = 14;
xlabel('d-spacing ({\AA})','interpreter','latex','FontSize',axes_fontsize)
ylabel('Intensity (a.u.)','interpreter','latex','FontSize',axes_fontsize)
%%%
axis([min(x) max(x) 0 max(y)])

lgd = legend(legend_text,'interpreter','latex','Location','bestoutside','FontSize',12);

%%%
%set(gca,'FontWeight','bold')