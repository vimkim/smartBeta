function crsp = addVarianceEWMA( crsp )
    N = 42;
    % This function lets you know the variance for a specific date. Inputs are
    % - crsp
    % - sampleMean: used in the formula below
    % - N: number of observations, we tried to use this as a variable, it
    % did not work and we will manually adjust to fit the EWMA column as
    % necessary. 

    % Formula:
    % result = sum ( X - sampleMean )^2 / (N - 1) 
    % where X is the Nx1 vector of returns.

    crsp=sortrows(crsp,{'PERMNO','datenum'});
    columnName = 'variances';
    crsp{:,columnName}=NaN;

    permnoList=unique(crsp.PERMNO);

    for thisPermno = permnoList'
        
        thisCrsp = crsp(crsp.PERMNO == thisPermno, :);
        
        variances = NaN( height(thisCrsp), 1 );
        
        for i = N : length(variances)
       
            variances(i) = sum( (thisCrsp.lag2RET(i-N+1:i) - thisCrsp.ewma42lag2RET(i)).^2 ) / (N-1);
        end
        
        thisCrsp.variances = variances;
        
        crsp{crsp.PERMNO == thisPermno, :} = table2array(thisCrsp);

    end
    
    crsp{:,'std'} = sqrt(crsp.variances);
    crsp{:,'std_annualized'} = sqrt(252) .* crsp.std;


end

