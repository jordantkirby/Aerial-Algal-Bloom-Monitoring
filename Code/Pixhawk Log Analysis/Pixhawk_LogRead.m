% Mission Planner Log Attitude Analysis
% Rev 2.0
close all; clc; clear; format compact

pathname = uigetdir('C:\Users\Jordan Kirby\Dropbox\Vehicle Logs\', 'MATLAB Log File');
Files = dir([pathname '\*.mat']);
%% Converting Cell Data to Structures
for j = 1:length(Files)
    datename = Files(j).name(1:10);
    filename = Files(j).name;
    load([pathname,'\' Files(j).name])
    if exist([pathname '\' datename ]) ~= 7
        mkdir([pathname '\' datename])
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
    LogVars = whos;
    for i = 1:length(LogVars)
        if ~strcmp(LogVars(i).name,'Files') ...
                && ~strcmp(LogVars(i).name,'j') ...
                && ~strcmp(LogVars(i).name,'pathname')
            eval(['clear ',LogVars(i).name]);
        end
    end
end

