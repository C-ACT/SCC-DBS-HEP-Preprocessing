% Author: S. N. Pitts
% Date: 07-14-2022
% Load and save R peak pipeline for one phase (experiment session) for a given subject (using one matlab file)
% preprocess data
% find R peaks
%dataset: SCC DBS HEP (EKG)

%% LEFFT TO DO: Configure Figures with Condition Lines, Save figures and WS, ...
% Add peaks and remove peaks, Test (1/2 day) - Reference SCC DBS stimep
% 500 sample/ms threshold??
% Add in the stats - from txt files(another day)

%% Load Subject
%Find file: matlab file with one phase from a subject
[file, path] = uigetfile;
cd(path)
all_data = load(file)

%% EDIT: Processing Parameters
% Default
% k = 5; %moving average for processing
% MinPeakDistance = .150; MinPeakHeight = 1; MinPeakProminence = 500;

k = 5; 
mph = 1;
mpd = .150; %(max peak distance -- 2.5 Hz) 
mpp = 500;
Sample_rate = all_data.PNSSamplingRate; %Should be 1000

%% EDIT: Phase condition (SEE X)
%condition labels within a single phase/experiment

comments = cell2table(all_data.evt_User_Markup); %columns consist of condition names, as table

[isCondition,~] = findConditions(comments);
isCondition = find(isCondition); %condition index (should be the number of conditions present)

% %name of mat files for a single phase/experiment - i.e. if there are many
% %epochs/matrices, you will have more than one file to concatenate into one
% %text file. For SCC DBS there should only be one file per phase
% filename = ['[Peak]_',file]
% datname = [file(1:length(file)-4),'mffECG'] %from workspace
% % all_data_ecg = {loaded.datname};   

%% Create Directories for saving
% %organize filesystem
prompt = "Enter PatientID";
Subject_No = input(prompt);
disp(Subject_No);

% %organize filesystem
% prompt = "Enter Phase";
% Phase = input(prompt);
% disp(Phase);

% %make subject phase folder ************************************
% mkdir(filename)
% path = [path,'/',filename ,'/'];
% cd(path)

    filename = ['[Peak]_',file]
    datname = [file(1:length(file)-4),'mffECG'] %from workspace

    %make subject phase folder ************************************
    mkdir(filename)
    path = [path,'/',filename ,'/'];
    cd(path)


%% Run Analysis
%%%%%REPEAT DEPENDING ON NUMBER OF EPOCHS/MAT FILES
ECG = [];
% filename = [];
% datname = [];
% for mat_num = 1:length(all_data_ecg)

    %process r peaks, save table, save fig
    ECG = all_data.(datname); % this is the ECG data
    NetstationRPeaks(ECG, isCondition, comments, mph, mpd, mpp,Sample_rate, Subject_No)
%   
% end

%%
function [isCondition, condition] = findConditions(comments)
%find the condition from the User MarkUp matrix; as Table comments
%(includes sample which condition starts)

%Initiate return vectors
num_comments = width(comments);
isCondition = zeros(1, num_comments); %1 hot encoded comments vector for condition (1 if is a condition)
condition = cell(num_comments,1);

    counter = 0;
    for col = 1:num_comments %number of comments
    
        %parse through each comment
        condition_name = comments{1,col}{1};
    
        %Search the first row (strings) for Identifiers
        Id1 = '+'; %Identifier 1 (condition contains this or other Identifier)
        Id2 = '-'; %Identifier 2
    
        cond1 = contains(condition_name,Id1); %check if contained
        cond2 = contains(condition_name,Id2); %check if contained
    
        %To 1 if contained 
        if cond1 || cond2
            isCondition(col) = 1;
            counter = counter + 1;
            condition{col} = condition_name;
        end
    
    end

%Check how many conditions were detected
fprintf("Condition Number %d",counter);

end


