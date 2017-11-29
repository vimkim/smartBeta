%% Do not forget to read README.md!
%% Do not forget to read README.md!
%% Do not forget to read README.md!
%% Do not forget to read README.md!
%% Do not forget to read README.md!

% Script: make
% Author: Deon, Pegah, Jaskrit
% Last Modified: 2017-11-29
% Course: Applied Quantitative Finance Fall 2017 Section 1
% Project: Smart Beta (Assignment 3)
% Team name: Dexter
% Purpose: To prepare mat-files required to run main.m script. This creates:
    % - crsp.mat
    % - ff3.mat
    % - dateList.mat
    % - marketIndex.mat
    % - thisCrsps.mat
% Inputs: N/A (script, not a function)
% outputs: N/A (script, not a function)
% Files used:
% File dependency
% make --- create_thisCrsps.m
%      \
%      \-- addLags.m
%      \-- addEWMA.m
%      \-- sizeWeight.m
%      \-- csvFolder/crsp.csv
%      \-- csvFolder/ff3.csv
%
% * create_thisCrsps.m : used to create thisCrsps variable. Please refer to README.md for detailed information about this variable.
    % (!) These csv-files must be inside 'csvFolder' directory.

%% As stated in README.md, place all your csv files inside 'csvFolder' directory.
% If you do not have one yet, I'll create it for you.
if ~exist('csvFolder', 'file')
    fprintf("csvFolder does not exist. Creating one.")
    mkdir('csvFolder');
end
% This code will not work until you place all the csv-files inside this folder.

% create MAT files.
% create directory called 'matFolder' where all the mat-files will be saved.
if ~exist('matFolder', 'file')
    fprintf("csvFolder does not exist. Creating one.")
    mkdir('matFolder');
end

%% Prepare crsp.
fprintf("Preparing crsp.mat...")
% Most codes are provided by kind and generous Evan. Thank you Evan!

crsp=readtable('csvFolder/crspCompustatMerged_2010_2014_dailyReturns.csv');
crsp.datenum=datenum(num2str(crsp.DATE),'yyyymmdd');
disp("datenum added");
% Calculate momentum size and value
fprintf("add Lags ME, BE")
crsp=addLags({'ME','BE'},2,crsp);
% this means market size, not height/width.
crsp.size=crsp.lag2ME;
crsp.value=crsp.lag2BE./crsp.lag2ME;
disp("lag added");
%Calculate momentum
fprintf("Calculating momentum...")
crsp=addLags({'adjustedPrice'},21,crsp); %this means a month
crsp=addLags({'adjustedPrice'},252,crsp);
crsp.momentum=crsp.lag21adjustedPrice./crsp.lag252adjustedPrice;
fprintf("Adding ranks...")
crsp=addRank({'size','value','momentum'},crsp);
crsp = addLags({'RET'}, 2, crsp); % add lag2RET column
crsp = addEWMA('lag2RET', 42, crsp);
crsp = addEWMA('lag2RET', 252, crsp);
% add volatility
crsp.RET2=(crsp.RET-crsp.ewma252lag2RET).^2;
crsp=addEWMA({'RET2'},42,crsp); %variance=Average (r-mu)^2, span of 2 months = 42 days
crsp.sigma=sqrt(crsp.ewma42RET2);
save('matFolder/crsp.mat', 'crsp');
disp("crsp.mat saved.")

%% Prepare dateList.
fprintf("Preparing dateList.mat");
dateList = unique(crsp.datenum);
save('matFolder/dateList', 'dateList')

%% Prepare ff3.
fprintf("Preparing ff3.mat...");
% If you only have ff3.csv and does not have ff3_20102014.csv, run the commented code below.
    %ff3=readtable('ff3.csv');
    %ff3.datenum=datenum(num2str(ff3.date),'yyyymmdd');
    %ff3{:,{'mrp','hml','smb'}}=ff3{:,{'mrp','hml','smb'}}/100; % divide all values by 100
    %% For data from 2010 to 2014. User should change this value if crsp datenum changes
    %startYear = 2010
    %endYear = 2014
    %writetable(ff3(startYear<=year(ff3.datenum)&year(ff3.datenum)<=endYear,:),'ff3_20102014.csv')
ff3=readtable('csvFolder/ff3_20102014.csv');
save('matFolder/ff3.mat', 'ff3');

%% Prepare marketIndex
fprintf("Preparing marketIndex.mat...")
marketIndex = table(dateList, 'VariableNames', {'datenum'});
marketIndex{:, 'RET'} = NaN;

l = height(marketIndex);

for i = 1:l
     fprintf("i = %d\n", i);
     isInvestible = crsp.datenum == marketIndex.datenum(i) & ~isnan(crsp.RET);
     % extract all investible firms
     investibles = crsp(isInvestible, :);

     % give each firms weight relative to its market capitalization
     % This is basically equal to market index.
     investibles.valueW = sizeWeight(investibles.ME);

     % calculate the market return based on relative market cap weights.
     marketIndex.RET(i) = sum(investibles.valueW .* investibles.RET);
end

% Has no meaning. Just required to run addLags, addEWMA functions, etc. for compatibility.
marketIndex{:,'PERMNO'}=99999999;

% Calculated 42 days EWMA volatility with 252 days mean.
marketIndex=addLags({'RET'},2,marketIndex);
marketIndex=addEWMA({'lag2RET'},252,marketIndex);%Average return, span of 1 year = 252 days
marketIndex.RET2=(marketIndex.RET-marketIndex.ewma252lag2RET).^2;
marketIndex=addEWMA({'RET2'},42,marketIndex);%variance=Average (r-mu)^2, span of 2 months = 42 days
marketIndex.sigma=sqrt(marketIndex.ewma42RET2);
marketIndex{:,'cumLogRet'}=NaN;
marketIndex.cumLogRet(~isnan(marketIndex.RET))=cumsum(log(1+marketIndex.RET(~isnan(marketIndex.RET))));
save('matFolder/marketIndex', 'marketIndex');

%% Prepare thisCrsps
fprintf("Preparing thisCrsps.mat...")
% thisCrsps is a table, which consists of two columns: datenum and 'thisCrsp'.
thisCrsps = create_thisCrsps(crsp);
save('matFolder/thisCrsps.mat', 'thisCrsps');

fprintf("make.m script Done! Now you can run 'main.m'");
