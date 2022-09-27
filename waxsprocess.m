% Leora Dresselhaus-Marais
% Feb 4, 2022
%
% The purpose of this code is to load and fit all peaks from the many XRD
% traces collected at APS by Fan at 300oC.

clear all
close all

% define relevant paths
dataPath = 'G:\.shortcut-targets-by-id\1Ub1KldDI6l3sWEWG-Z3QGCtU-hICQ_SY\Decarbonizing steelmaking\APS_SAXS_nano_300C_q\';
%dataPath = uigetdir('G:\.shortcut-targets-by-id\1Ub1KldDI6l3sWEWG-Z3QGCtU-hICQ_SY\Decarbonizing steelmaking')
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
    
end
[S,IND] = sort(SEQ);

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
    Data.Sequ(iNum) = str2num(filename(ind(3)+1:ind(4)-1));
    
    % now read the file
	a = readtable([dataPath,filename]);
%    plot(a{:,1},a{:,2}+iNum/10); hold on
    
    % save these traces into an image
    UQImage(:,iNum) = a{:,3}; % save the uncertainty values
    Intensity(:,iNum) = a{:,2}; % save the intensity values
    if iNum==1
        Data.d = a{:,1};
    end
    
    % note we need to increase from 107 to add 488 minutes to t
    if iNum > 106
        Data.t(iNum) = Data.t(iNum) + 488;
    end
    
%    imagesc(Intensity)
    fprintf('DONE!\n')
end

%% now let's create the image of our interesting plot features
%
figure
uimagesc(flipud(Data.d),Data.t',log(fliplr(transpose(Intensity))))
title('Hopefully Correct Image')
xlabel('d-spacing(A)')
ylabel('time (min)')
set(gca,'FontSize',20,'YDir','normal')
colorbar
%}
%% for this dataset, let's start by looking at how many maxima we have
d = flipud(Data.d);
figure('Position',[1 41 1280 607.3333])
for fNum=1:length(Data.T)
    % let's start with an example
    I = Intensity(:,fNum);
    I = I-min(I);

    tiledlayout(3,1,'TileSpacing','none')
    nexttile([2,1])
    findpeaks(I,d,'MinPeakProminence',0.002,'Annotate','extents','WidthReference','halfheight')
    [pks,locs,w,p] = findpeaks(I,d,'MinPeakProminence',0.002,'Annotate','extents','WidthReference','halfheight');
    xlim([min(d),max(d)])
    ylim([-0.01,0.5])

    Fit(fNum).Pks = pks;
    Fit(fNum).Locations = locs;
    Fit(fNum).Widths = w;
    Fit(fNum).Prominence = p;
    grid on
    
    nexttile
    for m=1:length(Fit(fNum).Pks)
        line([locs(m),locs(m)],[-w(m)/2,w(m)/2],'LineWidth',2); hold on
    end
    xlim([min(d),max(d)])
    grid on
    hold off
    box on
    sgtitle(['Fit for Scan ',num2str(fNum)])
    
    pause(0.1)

end

%% Now let's plot some of these values
PKS = [1.04,1.16,1.25,1.36,1.38,1.41,1.63,1.7,1.8,1.9,2.01,2.24,2.31,2.38,2.5,2.7,2.9,2.94,3.1,3.15,3.23,3.49,3.61,3.39,4.01,4.05]; % what are the bounds for the peak of interest?
maxOFFSET = 0.02; % how far offset are you willing to tolerate in defining this peak?

% first lett's find this peak for each scan:
legend_text ={};
for pNum=1:length(PKS) % scan over all specified peaks
    for fNum=1:length(Fit)
        [~,Index(fNum)] = min(abs(Fit(fNum).Locations-PKS(pNum)));
        if abs(Fit(fNum).Locations-PKS(pNum)) > maxOFFSET
            Index(fNum) = NaN;
            PkPos(fNum) = NaN;
            PkWid(fNum) = NaN;
            PkHei(fNum) = NaN;
        else
            PkPos(fNum) = Fit(fNum).Locations(Index(fNum));
            PkWid(fNum) = Fit(fNum).Widths(Index(fNum));
            PkHei(fNum) = Fit(fNum).Pks(Index(fNum));
        end
    end
    
    % now plot these values
    subplot(1,3,1)
    plot(Data.t,PkPos); hold on
    title('Peak Position')
    xlabel('time (min)')

    subplot(1,3,2)
    plot(Data.t,PkWid); hold on
    title('Peak Width')
    xlabel('time (min)')

    subplot(1,3,3)
    plot(Data.t,PkHei); hold on
    title('Peak Height')
    xlabel('time (min)')
    
    legend_text{pNum} = ['$',num2str(mean(PkPos,'omitnan')),'\AA$'];

end

legend(legend_text,'interpreter','latex')