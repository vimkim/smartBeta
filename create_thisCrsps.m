function thisCrsps = create_thisCrsps(crsp)

    dateList = unique(crsp.datenum);

    thisCrsps = table(dateList, 'VariableNames', {'datenum'});
    thisCrsps{:,'thisCrsp'} = {NaN};

    for i = 1:length(dateList)
        thisDate = dateList(i);
        fprintf("i = %d\n", i);
        isInvestible= crsp.datenum==thisDate;

        %Require that stock is currently still trading (has valid return)
        isInvestible= isInvestible & ~isnan(crsp.RET);

        %Extrade relevant data from crsp.
        thisCrsp=crsp(isInvestible,:);

        thisCrsps.thisCrsp(i) = {thisCrsp};


    end
end
