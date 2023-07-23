% The purpose of this code is to manually fit the XRD traces to Voigt
% potentials for different XRD traces at 300C and 350C
% 
% modified from Leora' ManualVoigtFit_XRD.m that can be found in 
% G:\.shortcut-targets-by-id\1Ub1KldDI6l3sWEWG-Z3QGCtU-hICQ_SY\Decarbonizing steelmaking\APS_XRD_20220802
% all I want to do is load singular files, not a trace of files

% define paths
path = [pwd,'\'];
folders = dir([path,'APS*']);
path = [path,folders(3).name];

% load files
files = dir([path,'\n*.dat']);
for fNum=1:length(files)
    data(fNum).file = files(fNum).name;
    data(fNum).filename = [path,'\',files(fNum).name];
    data(fNum).RawData = importdata(data(fNum).filename);
    data(fNum).RawD = data(fNum).RawData.data(:,1);
%    data(fNum).RawD = 2*pi./data(fNum).RawData.data(:,1);
    data(fNum).RawI = data(fNum).RawData.data(:,2);
    
    % save the scan tags
    indexes = strfind(files(fNum).name,'_');
    SCANID(fNum) = str2num(files(fNum).name(indexes(3)+1:indexes(4)-1));
end

% now sort the different traces
[~,ORDER] = sort(SCANID);
for m=1:length(data)
    index = ORDER(m);
    Data(m).file = data(index).file;
    Data(m).RawD= data(index).RawD;
    Data(m).RawI = data(index).RawI;
end

