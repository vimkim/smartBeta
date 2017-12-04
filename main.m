%% Do not forget to read README.md!
%% Do not forget to read README.md!
%% Do not forget to read README.md!
%% Do not forget to read README.md!
%% Do not forget to read README.md!

% Script: main
% Author: Deon, Pegah, Jaskrit
% Last Modified: 2017-11-29
% Course: Applied Quantitative Finance Fall 2017 Section 1
% Project: Smart Beta (Assignment 3)
% Team name: Dexter
% Purpose:
        % This main file is necessary in order to automate between strategies. The original example files Evan provided us is only capable of performing a single strategy at a time.
        % This is a wrapper script for 'runStrategy.m', which iterates through
        % different arguments and performs 'runStrategy' function multiple times with
        % different inputs.

        % How to run: just simply type 'main' in the matlab command window.
        % >> main

% Inputs: N/A (script, not a function)
% outputs: N/A (script, not a function)
% File dependency
% main --- runStrategy.m ---------- evaluateStrategy.m
%      \               \
%      \               \-- strategySM_V.m
%      \               \-- strategyM_VS.m
%      \               \-- strategyMS_V.m
%      \               \-- reverse_strategyMS_V.m
%      \               \-- matFolder/ff3.mat
%      \               \-- matFolder/dateList.mat
%      \               \-- matFolder/marketIndex.mat
%      \
%      \-- matFolder/crsp.mat
%      \-- matFolder/thisCrsps.mat

% What are the two if statements below?
% It looks up the matlab Workspace, checks if 'crsp' and 'thisCrsps'
% variables exist in there, and if not, it loads them to Workspace.

% Why is this in main function?
% This is to improve performance speed of the runStrategy function.
% Since it takes too much time to read and load 'crsp.mat' and 'thisCrsps.mat'
% which contains 'crsp' and 'thisCrsps' variables, by passing these
% variables as a function argument instead of reloading everytime, we can
% significantly improve the performance speed.


% This if statement checks whether 'crsp' exists in the workspace. If it does not exist then it
% loads 'crsp' from 'crsp.mat', contained in the 'matFolder'.
if ~exist('crsp', 'var')
    fprintf("crsp not exist. Loading...\n");
    crspMat = load('matFolder/crsp.mat');
    crsp = crspMat.crsp;
end

% This if statement checks whether 'thisCrsps' exists in the workspace. If it does not exist then it
% loads 'thisCrsps' from 'thisCrsps.mat', contained in the 'matFolder'.
if ~exist('thisCrsps', 'var')
    fprintf("thisCrsps not exist. Loading...\n");
    thisCrspsMat = load('matFolder/thisCrsps.mat');
    thisCrsps = thisCrspsMat.thisCrsps;
end
% Clear unnecessary, dirty variables to make matlab workspace cleaner.
clear ff3Mat crspMat marketIndexMat dateListMat thisCrspsMat


% number of strategies to be tested. Do not confuse with StrategyNo.
% This exists to specify the number of iterations in the next for loop.
numStrategies = 17;
% This for loop performs runStrategy function multiple times with different input i.
% Here, i is the StrategyNo (strategy number) dedicated to call a specific strategy.
% Instead of typing every single strategies one by one, we specify how many strategies there are, and matlab analyzes them all at once.
% This specifies the transaction Cost percentage for each trade. (0.002 = .2% of the total trade value)
transactionCost = 0.002;

% For Evan, we chose strategy 2 as our final strategy. The two lines below make sure that Evan run the code for strategy 2 only. You can always change these to 1 and 17 each to test other strategies.

starti = 56;
numStrategies = 56;

for i = starti:numStrategies
    runStrategy(i, crsp, thisCrsps, transactionCost);
end

%stratNum = 19;
%runStrategy(stratNum, crsp, thisCrsps, transactionCost);

% After running this file, all the results are saved in 'results' folder. You can load and see the results by running 'loadResults.m'.

% Summary of the workflow:
%
% How: (just type in Matlab Command Window)
% >> make
% >> main
% >> loadResults

%% Do not forget to read README.md!
%% Do not forget to read README.md!
%% Do not forget to read README.md!
%% Do not forget to read README.md!
%% Do not forget to read README.md!
