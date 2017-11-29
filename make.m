%% create MAT files.
% Make directory called 'matFolder'
mkdir('matFolder');

%% Prepare crsp.


%% Prepare ff3.
ff3=readtable('ff3.csv');
ff3.datenum=datenum(num2str(ff3.date),'yyyymmdd');
ff3{:,{'mrp','hml','smb'}}=ff3{:,{'mrp','hml','smb'}}/100;

startYear = 2010
endYear = 2014

writetable(ff3(startYear<=year(ff3.datenum)&year(ff3.datenum)<=endYear,:),'ff3_20102014.csv')

ff3=readtable('csvFolder/ff3_20102014.csv');
save('matFolder/ff3.mat', 'ff3');

%% Prepare marketIndex
