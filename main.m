function [] = main(strategyNo, crsp, thisCrsps)

    fprintf("\n");
    disp("Program begins!")
    disp(datestr(now, 'HH:MM:SS')); % displays time

    % Clear variables, but Use previous data if possible.
    clearvars -except crsp ff3 dateList marketIndex thisCrsps strategyNo

    %% User Input
    %strategyNo = 17;
    transactionCost = 0.002;
    fprintf("strategyNo : %d\n", strategyNo);
    fprintf("transactionCost : %d\n", transactionCost);

    %% Load missing data

    if ~exist('ff3', 'var')
        fprintf("ff3 not exist. Loading...\n");
        ff3Mat = load('matFolder/ff3.mat');
        ff3 = ff3Mat.ff3;
    end
    if ~exist('crsp', 'var')
        fprintf("crsp not exist. Loading...\n");
        crspMat = load('matFolder/crsp.mat');
        crsp = crspMat.crsp;
    end
    if ~exist('dateList', 'var')
        fprintf("dateList not exist. Loading...\n");
        dateListMat = load('matFolder/dateList.mat');
        dateList = dateListMat.dateList;
    end
    if ~exist('marketIndex', 'var')
        fprintf("marketIndex not exist. Loading...\n");
        marketIndexMat = load('matFolder/marketIndex.mat');
        marketIndex = marketIndexMat.marketIndex;
    end
    if ~exist('thisCrsps', 'var')
        fprintf("thisCrsps not exist. Loading...\n");
        thisCrspsMat = load('matFolder/thisCrsps.mat');
        thisCrsps = thisCrspsMat.thisCrsps;
    end
    clear ff3Mat crspMat marketIndexMat dateListMat thisCrspsMat

    % this section is just formatting the data. Evan is showing us his work.
    % Evan is great!

    %crsp=readtable('crspTest.csv');

    % %Create testData.csv
    % crsp=readtable('csvFolder/crspCompustatMerged_2010_2014_dailyReturns.csv');
    % permnoList=unique(crsp.PERMNO);
    % permnoList=randsample(permnoList,100);
    % crsp=crsp(ismember(crsp.PERMNO,permnoList),:);
    % writetable(crsp,'crspTest.csv');

    %% Prepare ff3

    % ff3=readtable('ff3.csv');
    % ff3.datenum=datenum(num2str(ff3.date),'yyyymmdd');
    % ff3{:,{'mrp','hml','smb'}}=ff3{:,{'mrp','hml','smb'}}/100;
    % writetable(ff3(2010<=year(ff3.datenum)&year(ff3.datenum)<=2014,:),'ff3_20102014.csv')

    % Load ff3 data
    %ff3=readtable('csvFolder/ff3_20102014.csv');
    %save('matFolder/ff3.mat', 'ff3');
    %ff3Mat = load('matFolder/ff3.mat');
    %ff3 = ff3Mat.ff3;
    %fprintf("ff3 loaded\n");

    %% Prepare CRSP
    % crsp=readtable('crspTest.csv');
    %crsp=readtable('csvFolder/crspCompustatMerged_2010_2014_dailyReturns.csv');
    % 
    % crsp.datenum=datenum(num2str(crsp.DATE),'yyyymmdd');
    % 
    % disp("datenum added");
    % %% Calculate momentum size and value
    % 
    % crsp=addLags({'ME','BE'},2,crsp);
    % 
    % % this means market size, not height/width.
    % crsp.size=crsp.lag2ME;
    % crsp.value=crsp.lag2BE./crsp.lag2ME;
    % disp("lag added");
    % 
    % %Calculate momentum
    % crsp=addLags({'adjustedPrice'},21,crsp); %this means a month
    % crsp=addLags({'adjustedPrice'},252,crsp);
    % crsp.momentum=crsp.lag21adjustedPrice./crsp.lag252adjustedPrice;load train; sound(y,Fs)
    % 
    % crsp=addRank({'size','value','momentum'},crsp);
    % disp("rank added");
    % crsp = addLags({'RET'}, 2, crsp); % add lag2RET column
    % crsp = addEWMA('lag2RET', 42, crsp);
    % crsp = addEWMA('lag2RET', 252, crsp);
    % % %add volatility
    % crsp.RET2=(crsp.RET-crsp.ewma252lag2RET).^2;
    % crsp=addEWMA({'RET2'},42,crsp);%variance=Average (r-mu)^2, span of 2 months = 42 days
    % crsp.sigma=sqrt(crsp.ewma42RET2);
    % save('matFolder/crsp.mat');
    % crspMat = load('matFolder/crsp.mat');
    % crsp = crspMat.crsp;
    % fprintf("crsp loaded.\n");


    % dateList=unique(crsp.datenum);
    %dateListMat = load('matFolder/dateList.mat');
    %dateList = dateListMat.dateList;


    %% Calculate market sigma
    % 
    % marketIndex = table(dateList, 'VariableNames', {'datenum'});
    % marketIndex{:, 'RET'} = NaN;
    % 
    % l = height(marketIndex);
    % 
    % for i = 1:l
    %     fprintf("i = %d\n", i);
    %     isInvestible = crsp.datenum == marketIndex.datenum(i) & ~isnan(crsp.RET);
    %     investibles = crsp(isInvestible, :);
    %     investibles.valueW = valueWeight(investibles.ME);
    %     marketIndex.RET(i) = sum(investibles.valueW .* investibles.RET);
    % end
    % 
    % clear l
    % 
    % marketIndex{:,'PERMNO'}=99999999;
    % 
    % marketIndex=addLags({'RET'},2,marketIndex);
    % 
    % marketIndex=addEWMA({'lag2RET'},252,marketIndex);%Average return, span of 1 year = 252 days
    % marketIndex.RET2=(marketIndex.RET-marketIndex.ewma252lag2RET).^2;
    % marketIndex=addEWMA({'RET2'},42,marketIndex);%variance=Average (r-mu)^2, span of 2 months = 42 days
    % marketIndex.sigma=sqrt(marketIndex.ewma42RET2);
    % 
    % save('matFolder/marketIndex', 'marketIndex');
    % 
    % marketIndexMat = load('matFolder/marketIndex');
    % marketIndex = marketIndexMat.marketIndex;

    %% thisCrsps is a table, which consists of two columns: datenum and 'thisCrsp'.
    % thisCrsps = create_thisCrsps(crsp);
    % save('matFolder/thisCrsps.mat', 'thisCrsps');

    %% Track strategy positions
    % create table with variable name being datenum for first column.
    thisStrategy=table(dateList,'VariableNames',{'datenum'});

    %Create empty column of cells for investment weight tables
    thisStrategy{:,'portfolio'}={NaN};


    %Create empty column of NaNs for ret
    thisStrategy{:,'ret'}=NaN;
    thisStrategy{:,'turnover'}=NaN;
    thisStrategy{:,'ret_net'}=NaN;


    %Run first iteration separately since there's no turnover to calculate
    % i = 1;
    % 
    % thisDate=thisStrategy.datenum(i);

    % if strategyNo == 0 % baseline
    %     thisPortfolio=tradeLongMomentum(thisDate,crsp);
    % elseif strategyNo == 1
    % %% strat 1
    %     thisPortfolio = tradeValueMomentum(thisDate, crsp, topPercent);
    % elseif strategyNo == 2
    %     thisPortfolio = strategy2(thisCrsps.thisCrsp{i}, marketIndex.sigma(i));
    % elseif strategyNo == 3
    %     thisPortfolio = strategy3(thisCrsps.thisCrsp{i}, marketIndex.sigma(i));
    %     %thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.75 1], [0 0.25], [0.75 1]);
    % elseif strategyNo == 4
    %     %thisPortfolio = strategy4(thisCrsps.thisCrsp{i}, marketIndex.sigma(i));
    %     thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.1 1], [0.1 1], [0.75 1]);
    % elseif strategyNo == 6
    %     thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0.4 0.6], [0.75 1]);
    % elseif strategyNo == 7
    %     thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0.75 1], [0.9 1]);
    % end
    % 
    % thisStrategy.portfolio(i)={thisPortfolio}; %Bubble wrap the table of investment weights and store in thisStrategy

    %if (sum(~isnan(thisPortfolio.w))>0)
        %Calculate returns if there's at least one valid position
        %thisStrategy.ret(i)=nansum(thisPortfolio.RET.*thisPortfolio.w);


        %changePortfolio=outerjoin(thisPortfolio(:,{'PERMNO','w'}),lastPortfolio(:,{'PERMNO','w'}),'Keys','PERMNO');
        %Fill missing positions with zeros
        %changePortfolio=fillmissing( changePortfolio,'constant',0);
        %thisStrategy.turnover(i)=nansum(abs(changePortfolio.w_left-changePortfolio.w_right))/2;

    %end

    fprintf("start iteration..\n");
    %for i = 253:size(thisStrategy,1) % starts from 253 because momentum is available from this date.
    n = 0;
    len = size(thisStrategy,1);
    starti = 295;% starts from 295 because sigma is available from this date.
    for i = starti:len 
        % shows progress of forloop
        % code obtained from https://stackoverflow.com/questions/8825796/how-to-clear-the-last-line-in-the-command-window
        msg = sprintf('Processed: %d/%d', i, len);
        fprintf(repmat('\b', 1, n));
        fprintf(msg);
        n=numel(msg);

        thisDate=thisStrategy.datenum(i);
        if i ~= starti 
            lastPortfolio=thisPortfolio;
        end

    %     if strategyNo == 0 % baseline
    %         thisPortfolio=tradeLongMomentum(thisDate,crsp);
    %     elseif strategyNo == 1
    %     % strat 1
    %         thisPortfolio = tradeValueMomentum(thisDate, crsp, topPercent);
    %     elseif strategyNo == 2
    %         thisPortfolio = strategy2(thisCrsps.thisCrsp{i}, marketIndex.sigma(i));
    %     elseif strategyNo == 3
    %         thisPortfolio = strategy3(thisCrsps.thisCrsp{i}, marketIndex.sigma(i));
    %         thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.75 1], [0 0.25], [0.75 1]);
    %     elseif strategyNo == 4
    %         thisPortfolio = strategy4(thisCrsps.thisCrsp{i}, marketIndex.sigma(i));
    %         thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.1 1], [0.1 1], [0.75 1]);
    %     elseif strategyNo == 6
    %         thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0.4 0.6], [0.75 1]);
    %     elseif strategyNo == 7
    %         thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0.75 1], [0.9 1]);
    %     end

        switch strategyNo
            case 0
                thisPortfolio = tradeLongMomentum();
            case 1
                return
            case 2
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0 0.1], [0.9 1]);
            case 3
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [.75 1],[0 .25],[.75 1]);
            case 4
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.1 1], [0.1 1], [0.75 1]);
            case 5
                return
            case 6
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0.4 0.6], [0.75 1]);
            case 7
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0.75 1], [0.9 1]);
            case 8
                thisPortfolio = strategySM_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0.75 1], [0.9 1]);
            case 9
                thisPortfolio = strategySM_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0.75 1], [0.9 1]);
            case 10
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0 0.25], [0.9 1]);
            case 11
                return
                thisPortfolio = reverse_strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [.75 1],[0 .25],[.75 1]);
            case 12
                return
            case 13
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.95 1], [0 0.05], [0.95 1]);
            case 14
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.6 1], [0 0.4], [0.6 1]);
            case 15
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.75 1], [0 0.1], [0.9 1]);
            case 16
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.5 1], [0 0.1], [0.9 1]);
            case 17
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.1 1], [0 0.1], [0.9 1]);
            otherwise
                disp("wrong strategy number!");
        end

        thisStrategy.portfolio(i)={thisPortfolio}; %Bubble wrap the table of investment weights and store in thisStrategy

        if(i ~= starti)
            if (sum(~isnan(thisPortfolio.w))>0)
                %Calculate returns if there's at least one valid position
                thisStrategy.ret(i)=nansum(thisPortfolio.RET.*thisPortfolio.w);

                changePortfolio=outerjoin(thisPortfolio(:,{'PERMNO','w'}),lastPortfolio(:,{'PERMNO','w'}),'Keys','PERMNO');
                %Fill missing positions with zeros
                changePortfolio=fillmissing( changePortfolio,'constant',0);
                thisStrategy.turnover(i)=nansum(abs(changePortfolio.w_left-changePortfolio.w_right))/2;
                % substract transaction cost
                thisStrategy.ret(i) = thisStrategy.ret(i) - transactionCost * thisStrategy.turnover(i);
            end
        end
    end
    fprintf("\nmaking 'thisStrategy' Done! Now evaluating...\n");
    disp(datestr(now, 'HH:MM:SS'));

    thisPerformance = evaluateStrategy(thisStrategy,ff3);
    fprintf("Evaluation Done! Now saving the results ...\n");
    disp(datestr(now, 'HH:MM:SS'));

    clear thisPortfolio thisDate ans i lastPortfolio len

    resultName = strcat('strategy',num2str(strategyNo),'Performance');
    thisPerformance.strategyName = resultName;
    save(strcat("results/",resultName), 'thisPerformance');

    clear resultName

    %Plot cumulative returns with dateticks
    %plot(thisPerformance.thisStrategy.datenum,thisPerformance.thisStrategy.cumLogRet);
    %datetick('x','yyyy-mm', 'keepticks', 'keeplimits')

    disp("Program ends!")
    disp(datestr(now, 'HH:MM:SS')); % displays time

end
