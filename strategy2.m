function portfolio=strategy2(thisDate,crsp , optionalArgument)

    k = 0.2;
    marketSigma = 0.4;
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

    %% Create table of investment weights

    %fill investment weights with zeros
    thisCrsp{:,'w'}=0;

    weight = 0.907 - 1.07 *marketSigma;
    if weight > 0.8
        weight = 0.8;
    elseif weight < 0.2
        weight = 0.2;
    end

    mom10size010{:,'w'}=weight;
    value10{:, 'w'}=1-weight;
    % standardizes
    mom10size010{:,'w'}=mom10size010.w./nansum(mom10size010.w);
    value10.w=value10.w./nansum(value10.w);

    % merge both portfolio
    commonPermno = intersect(mom10size010.PERMNO,value10.PERMNO);
    mergedPermno = union(mom10size010.PERMNO, value10.PERMNO);
    mergedPortfolio = table(mergedPermno, 'VariableNames', {'PERMNO'});
    mergedPortfolio{:,'w'} = 0;

    l = length(mergedPortfolio.PERMNO);
    for i = 1:l
        thisPermno = mergedPortfolio.PERMNO(i);
        %if ~isempty(mom10size010{mom10size010.PERMNO == thisPermno,'w'})
        if ~isempty(mom10size010.w(find(mom10size010.PERMNO == thisPermno, 1)))
            mergedPortfolio{mergedPortfolio.PERMNO == thisPermno, 'w'} = mergedPortfolio{mergedPortfolio.PERMNO == thisPermno, 'w'} + mom10size010{mom10size010.PERMNO == thisPermno, 'w'};
        end
        if ~isempty(value10{value10.PERMNO == thisPermno,'w'})
            mergedPortfolio{mergedPortfolio.PERMNO == thisPermno, 'w'} = mergedPortfolio{mergedPortfolio.PERMNO == thisPermno, 'w'} + value10{value10.PERMNO == thisPermno, 'w'};
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
