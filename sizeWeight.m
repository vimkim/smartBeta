function w = sizeWeight(marketCapVector)
% Function: sizeWeight
% Author: Deon, Pegah, Jaskrit
% Last Modified: 2017-11-29
% Course: Applied Quantitative Finance Fall 2017 Section 1
% Project: Smart Beta (Assignment 3)
% Team name: Dexter
% Purpose: Obtain relative market caps vector used for marketcap-relative weighting purpose. Used for creating our custom crsp market Index (something like S&P500 with crsp).
% Inputs: vector of market capitalizations of different firms.
% outputs: relative market caps of each firm which their sum is equal to 1.
% Actually, this code is what we wrote in Assignment 1. We are reusing the code. :)

    mcSum = sum(marketCapVector); % Total market capitalization
    w = marketCapVector./mcSum; % vector of relative market capitalization compared with others
end
