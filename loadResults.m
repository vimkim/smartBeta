%% Do not forget to read README.md
%% Do not forget to read README.md
%% Do not forget to read README.md
%% Do not forget to read README.md
%% Do not forget to read README.md

% Script: loadResults.m
% Author: Deon, Pegah, Jaskrit
% Last Modified: 2017-11-29
% Course: Applied Quantitative Finance Fall 2017 Section 1
% Project: Smart Beta (Assignment 3)
% Team name: Dexter
% Purpose: To load all the saved strategy performance results (given that you already successfully ran main.m at least for once) and format them for easy excel copy paste.
% Inputs: N/A (script, not a function)
% outputs: N/A (script, not a function)
% File dependency:
% loadResults.m --- results/strategy1Performance
% loadResults.m --- results/strategy2Performance
% loadResults.m --- results/strategy3Performance
% ... and so on ...
% loadResults.m --- results/strategy16Performance
% loadResults.m --- results/strategy17Performance

% How to use this file:
% Type `>>loadResults` at Matlab Command Window
% Double Click `results` variable to see the results.
% Make sure that you adjust the range of for loop using i = start:end

results = {NaN};
for i = 2:2 % 1:17 to see all the results. For Evan, set to 2
    resultName = strcat('results/strategy', num2str(i), 'Performance')
    results(i,1) = {resultName};
    loaded = load(resultName);
    results(i,2) = {loaded.thisPerformance};
end

% This is just for excel copy-paste. Not important. Ignore this part.
for i = 2:2 % 1:17 to see all the results. For Evan, set to 2
    results(i,3) = {results{i,2}.averageHoldingPeriod};
    results(i,4) = {results{i,2}.sharpeRatio};
    results(i,5) = {results{i,2}.informationRatio};
    results(i,6) = {results{i,2}.alphaCAPM};
    results(i,7) = {results{i,2}.alphaFF3};
end
