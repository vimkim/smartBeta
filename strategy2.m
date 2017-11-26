function portfolio=strategy2(thisDate,crsp, marketSigma, optionalArgument)

    
    marketSigma = sqrt(252)*marketSigma % annualized volatility
    
    % this must be something marketVol function.

    %% Get date from investible universe
    %Match by date
    isInvestible= crsp.datenum==thisDate;

    %Require that stock is currently still trading (has valid return)
    isInvestible= isInvestible & ~isnan(crsp.RET);

    %Extrade relevant data from crsp.
    thisCrsp=crsp(isInvestible,:);

    % strategy 2 : 10% M then below 10% small + 10% value

    %% extract top 10% momentum firms
    mom10 = thisCrsp(thisCrsp.momentumRank >= 0.9,:);
    %% among thisCrsp, extract below 10% size firms
    mom10 = addRank('size', mom10);
    mom10size010 = mom10(mom10.sizeRank <= 0.1,:);

    %% extract top 10% value firms
    value10 = thisCrsp(thisCrsp.valueRank >= 0.9,:);

    %% specify partial porfolios
    port1 = mom10size010;
    port2 = value10;

    %% Create table of investment weights

    %fill investment weights with zeros
    thisCrsp{:,'w'}=0;

    weight = 0.907 - 1.07 *marketSigma;
    if weight > 0.8
        weight = 0.8;
    elseif weight < 0.2
        weight = 0.2;
    end
   
    weight

    port1{:,'w'}=weight;
    port2{:,'w'}=1-weight;
    % standardizes
    port1{:,'w'}=port1.w ./ height(port1);
    port2.w=port2.w ./ height(port2);
    
    if height(port1) > 0 & height(port2) > 0
        port1.w(1)
        port2.w(2)
    end

    % merge both portfolio
    % commonPermno = intersect(port1.PERMNO,port2.PERMNO);
    mergedPermno = union(port1.PERMNO, port2.PERMNO);
    mergedPortfolio = table(mergedPermno, 'VariableNames', {'PERMNO'});
    mergedPortfolio{:,'w'} = 0;

    l = length(mergedPortfolio.PERMNO);
    for i = 1:l
        thisPermno = mergedPortfolio.PERMNO(i);
        %if ~isempty(port1{port1.PERMNO == thisPermno,'w'})
        port1w = port1.w(find(port1.PERMNO == thisPermno, 1));
        if ~isempty(port1w)
            mergedPortfolio.w(i) = mergedPortfolio.w(i) + port1w;
        end
        port2w = port2.w(find(port2.PERMNO == thisPermno, 1));
        if ~isempty(port2w)
            mergedPortfolio.w(i) = mergedPortfolio.w(i) + port2w;
        end
        
    end

    %Standardize investment weights to make sure that 1) There's no short position
    %thisCrsp{thisCrsp.w<0,'w'}=0;

    % plug it back
    for i = 1:l % This l is equal to length(mergedPortfolio.PERMNO).
        thisPermno = mergedPortfolio.PERMNO(i);
        %thisCrsp{thisCrsp.PERMNO == thisPermno, 'w'} = mergedPortfolio.w(mergedPortfolio.PERMNO == thisPermno);
        thisCrsp.w(find(thisCrsp.PERMNO == thisPermno, 1)) = mergedPortfolio.w(i);
    end

    %% Select columns for output
    portfolio=thisCrsp(:,{'PERMNO','w','RET'});

end
