function thisCrsps = create_thisCrsps(crsp)
% Function: create_thisCrsps
% Author: Deon, Pegah, Jaskrit
% Last Modified: 2017-11-29
% Course: Applied Quantitative Finance Fall 2017 Section 1
% Project: Smart Beta (Assignment 3)
% Team name: Dexter
% Purpose: create thisCrsps variable and save it to mat-file.
% Inputs: crsp - CRSP dataset used. Created by 'make.m' script.
% outputs: thisCrsps - explained in README.md

    % create unique dateList
    dateList = unique(crsp.datenum);

    thisCrsps = table(dateList, 'VariableNames', {'datenum'});

    % thisCrsps has a column called 'thisCrsp' which contains NaN wrappers.
    thisCrsps{:,'thisCrsp'} = {NaN};

    % Iterate through all the dates in crsp.
    for i = 1:length(dateList)
        thisDate = dateList(i);
        fprintf("i = %d\n", i);

        % should be investible at a certain date
        isInvestible= crsp.datenum==thisDate;

        % Require that stock is currently still trading (has valid return)
        isInvestible= isInvestible & ~isnan(crsp.RET);

        % Extract relevant data from crsp.
        thisCrsp=crsp(isInvestible,:);

        % Save thisCrsp to thisCrsps for future use.
        thisCrsps.thisCrsp(i) = {thisCrsp};


    end
end
