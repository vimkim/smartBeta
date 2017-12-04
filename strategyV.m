
function portfolio=strategyV(thisCrsp, marketSigma, vr)

    marketSigma = sqrt(252)*marketSigma; % annualize volatility


    % How to make port2: V (value firms)
    port2 = thisCrsp(thisCrsp.valueRank >= vr(1) & thisCrsp.valueRank <= vr(2), :);

%% Create table of investment weights
    %fill investment weights with zeros
    thisCrsp{:,'w'}=0;

    weight_2 = 1;
    port2{:,'w'}=weight_2;
    % Give equal weights to all firms within each sub-portfolio.
    port2.w=port2.w ./ height(port2);

    % Array of weights for port1 and port2. Used for logical indexing.
    wArr2 = zeros(height(thisCrsp), 1);
    wArr2(ismember(thisCrsp.PERMNO, port2.PERMNO)) = port2{:, 'w'};
    % Sum weights for port1 and port2 and generate weights for parent-portfolio.
    thisCrsp.w = wArr2;

    %Standardize investment weights to make sure that there's no short position.
    % Logically there must not be, but just in case. Evan added it. :)
    thisCrsp{thisCrsp.w<0,'w'}=0;

    %% Select columns for output
    portfolio=thisCrsp(:,{'PERMNO','w','RET'});

    % return portfolio with information about PERMNO, w, RET

end
