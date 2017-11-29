function portfolio=strategyMS_V(thisCrsp, marketSigma, mr, sr, vr)
% Function: strategyMS_V
% Author: Deon, Pegah, Jaskrit
% Last Modified: 2017-11-29
% Course: Applied Quantitative Finance Fall 2017 Section 1
% Project: Smart Beta (Assignment 3)
% Team name: Dexter
% Purpose: performs MS_V strategy for a specific date.
% Inputs:
    % thisCrsp : investible firms in a specific date.
    % marketSigma : 42-day lagged EWMA daily sigma for market index.
    % Specific roles of these inputs are specified in the below description.
% outputs: return strategy portfolio with information about PERMNO, w, RET

% This function performs a trade based on a specific strategy, which we named MS_V.
%
% What is MS_V and how does it perform:
% M stands for momentum, S stands for size and V stands for value.
% We create two sub portfolios called MS and V.
    % MS is a portfolio of size firms within momentum firms. This is named 'port1' in this function.
    % V is a portfolio of value firms. This is named 'port2' in this function.
% mr, sr, vr are 2x1 vectors, containing the rank range condition of firms being selected in our strategy.
% e.g. For Top ten percent momentum firms, mr = [0.9 1] is used.
% e.g.2 For 40% - 70% size firms, sr = [0.4 0.7] is used.

% The weights of 'port1' and 'port2' are determined by our custom linear function
    %                weight_1 = 0.907 - 1.07 * marketSigma;
    %                weight_2 = 1 - weight_1

    marketSigma = sqrt(252)*marketSigma; % annualize volatility

    % How to make port1: MS (size firms within momentum)
    % First, extract momentum firms.
    port1 = thisCrsp(thisCrsp.momentumRank >= mr(1) & thisCrsp.momentumRank <= mr(2), :);
    % Second, create new sizeRank column with extracted firms.
    port1.sizeRank(:) = NaN;
    port1 = addRank('size', port1);
    % Third, extract size firms.
    port1 = port1(port1.sizeRank >= sr(1) & port1.sizeRank <= sr(2), :);

    % How to make port2: V (value firms)
    port2 = thisCrsp(thisCrsp.valueRank >= vr(1) & thisCrsp.valueRank <= vr(2), :);

%% Create table of investment weights
    %fill investment weights with zeros
    thisCrsp{:,'w'}=0;

    % This is our custom weighting mechanism we have intuitively created to perform dynamic adjustment.
    % Here, weight is a linear function of marketSigma, which decreases if the market volatility increases.
    % By doing this, we reduce weights on port1 when market volatility is high.
    weight_1 = 0.907 - 1.07 *marketSigma; % weight for port1
    % We avoid relying on one specific sub-portfolio too much. We keep a minimum threshold of 20% on each portfolio.
    % The if-statement below sets the weight to be either 80% or 20% if it goes too extreme.
    if weight_1 > 0.8
        weight_1 = 0.8;
    elseif weight_1 < 0.2
        weight_1 = 0.2;
    end
    weight_2 = 1-weight_1;

    port1{:,'w'}=weight_1;
    port2{:,'w'}=weight_2;
    % Give equal weights to all firms within each sub-portfolio.
    port1{:,'w'}=port1.w ./ height(port1);
    port2.w=port2.w ./ height(port2);

    % Array of weights for port1 and port2. Used for logical indexing.
    wArr1 = zeros(height(thisCrsp), 1);
    wArr1(ismember(thisCrsp.PERMNO, port1.PERMNO)) = port1{:, 'w'};
    wArr2 = zeros(height(thisCrsp), 1);
    wArr2(ismember(thisCrsp.PERMNO, port2.PERMNO)) = port2{:, 'w'};
    % Sum weights for port1 and port2 and generate weights for parent-portfolio.
    thisCrsp.w = wArr1 + wArr2;

    %Standardize investment weights to make sure that there's no short position.
    % Logically there must not be, but just in case. Evan added it. :)
    thisCrsp{thisCrsp.w<0,'w'}=0;

    %% Select columns for output
    portfolio=thisCrsp(:,{'PERMNO','w','RET'});

    % return portfolio with information about PERMNO, w, RET

end
