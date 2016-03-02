% Mission Planner Log Attitude Analysis
% Rev 2.0
close all; clc; clear; format compact

% pathname = uigetfile('C:\Users\Jordan Kirby\Dropbox\Vehicle Logs\', 'MATLAB Log File');

[filename, pathname, filterindex] = uigetfile( ...
    {  '*.mat','MAT-files (*.mat)'}, ...
    'Pick File(s)', ...
    'MultiSelect', 'on');
if iscell(filename)
    for i = 1:length(filename)
        Files(i) = dir([pathname filename{i} ]);
    end
else
    Files = dir([pathname filename ]);
end

%% Converting Cell Data to Structures
for j = 1:length(Files)
    datename = Files(j).date(1:11);
    filename = Files(j).name;
    load([pathname,'\' Files(j).name])
    if exist([pathname '\' datename ]) ~= 7
        mkdir([pathname '\' datename])
    end
    if exist([pathname '\Cell_Logs_Old' ]) ~= 7
        mkdir([pathname '\Cell_Logs_Old'])
    end
    LogVars = whos;
    countH = 1;
    countD = 1;
    for i = 1:length(LogVars)
        if strcmp(LogVars(i).class,'cell')
            header{countH} = LogVars(i).name;
            countH = countH+1;
        elseif strcmp(LogVars(i).class,'double')
            data_label{countD} = [LogVars(i).name,'_label'];
            data{countD} = eval([LogVars(i).name]);
            countD = countD+1;
        end
    end
    for i = 1:length(header)
        Ind{i} = find(strcmp(data_label,header{i}) == 1);
        if isempty(Ind{i})
            Ind{i} = 0;
        end
    end
    foundHeader = header(find(cell2mat(Ind) ~=0));
    
    for i = 1:length(foundHeader)
        tempCell = mat2cell(data{i},size(data{i},1),ones(1,size(data{i},2)));
        eval([foundHeader{i}(1:end-6),' = cell2struct(tempCell,eval(foundHeader{i}),2);']);
    end
    if ~isempty(who('PARM'))
        if ~isempty(PARM)
            vehicleParameters = cell2struct(PARM(:,2),PARM(:,1),1);
        end
    end
    
    LogVars = whos;
    for i = 1:length(LogVars)
        if ~strcmp(LogVars(i).class,'struct')...
                && ~strcmp(LogVars(i).class,'char') ...
                && ~strcmp(LogVars(i).name,'j')...
                && ~strcmp(LogVars(i).name,'pathname')
            eval(['clear ',LogVars(i).name]);
        end
    end
    clear i LogVars
    
    save([pathname '\' datename '\' filename(1:end-4) '_Processed.mat'])
    movefile([pathname Files(j).name],[pathname 'Cell_Logs_Old'])
    
    LogVars = whos;
    for i = 1:length(LogVars)
        if ~strcmp(LogVars(i).name,'Files') ...
                && ~strcmp(LogVars(i).name,'j') ...
                && ~strcmp(LogVars(i).name,'pathname')
            eval(['clear ',LogVars(i).name]);
        end
    end
end

