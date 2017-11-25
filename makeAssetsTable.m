function assetTable = makeAssetsTable( thisDate, days, crsp )
%MAKEFIRMS Summary of this function goes here
%   Detailed explanation goes here


    assetTable = [];
    assetRows = crsp.datenum == thisDate;
    dateList = unique(crsp.datenum);
    dateIndex = find(dateList == thisDate );
    if dateIndex >= days
        thisDates = dateList(dateIndex-days+1 : dateIndex);
    else
        return
    end

    % explanation needed
    longData = crsp(crsp.datenum >= thisDates(1) & crsp.datenum <= thisDates(end), :);
    permnoList = unique(longData.PERMNO);
    assetTable = NaN(length(thisDates), length(permnoList));

    for i = 1:length(permnoList)
        a = longData.RET(longData.PERMNO == permnoList(i));
        if length(a) == 42
            assetTable( :, i ) = longData.RET(longData.PERMNO == permnoList(i));
        end
    end

end

