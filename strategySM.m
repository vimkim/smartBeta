function portfolio=strategySM(thisCrsp, marketSigma, mr, sr)
    marketSigma = sqrt(252)*marketSigma; % annualize volatility

    port1 = thisCrsp(thisCrsp.sizeRank >= sr(1) & thisCrsp.sizeRank <= sr(2), :);
    port1.momentumRank(:) = NaN;
    port1 = addRank('momentum', port1);
    port1 = port1(port1.momentumRank >= mr(1) & port1.momentumRank <= mr(2), :);


%% Create table of investment weights
    %fill investment weights with zeros
    thisCrsp{:,'w'}=0;

    % This is our custom weighting mechanism we have intuitively created to perform dynamic adjustment.
    % Here, weight is a linear function of marketSigma, which decreases if the market volatility increases.
    % By doing this, we reduce weights on port1 when market volatility is high.
    weight_1 = 1;
    % We avoid relying on one specific sub-portfolio too much. We keep a minimum threshold of 20% on each portfolio.
    % The if-statement below sets the weight to be either 80% or 20% if it goes too extreme.

    port1{:,'w'}=weight_1;
    % Give equal weights to all firms within each sub-portfolio.
    port1{:,'w'}=port1.w ./ height(port1);

    % Array of weights for port1 and port2. Used for logical indexing.
    wArr1 = zeros(height(thisCrsp), 1);
    wArr1(ismember(thisCrsp.PERMNO, port1.PERMNO)) = port1{:, 'w'};
    % Sum weights for port1 and port2 and generate weights for parent-portfolio.
    thisCrsp.w = wArr1;

    %Standardize investment weights to make sure that there's no short position.
    % Logically there must not be, but just in case. Evan added it. :)
    thisCrsp{thisCrsp.w<0,'w'}=0;

    %% Select columns for output
    portfolio=thisCrsp(:,{'PERMNO','w','RET'});

    % return portfolio with information about PERMNO, w, RET

end
