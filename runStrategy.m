%% Do not forget to read README.md!
%% Do not forget to read README.md!
%% Do not forget to read README.md!
%% Do not forget to read README.md!
%% Do not forget to read README.md!

function [] = runStrategy(strategyNo, crsp, thisCrsps, transactionCost)
% Function: runStrategy
% Author: Deon, Pegah, Jaskrit
% Last Modified: 2017-11-29
% Course: Applied Quantitative Finance Fall 2017 Section 1
% Project: Smart Beta (Assignment 3)
% Team name: Dexter
% Function description:
    % This is a simple modification of runSampleStrategy.m file that Evan provided us.
    % Things that are modified:
        % - runSampleStrategy.m was a Script file, but now it is transformed into a function file, which allows us to use this in 'main.m' for automation.
        % - Some disp, fprintf function lines to specify the progress of this function, because it takes some time to run (so the user may not be bored).
% Purpose:
    % To perform a specific strategy specified in the input argument with 'strategyNo' variable to all the dates of dataset, saves the transaction log in 'thisStrategy' variable and evaluate the performance, save the evaluation in 'thisPerformance' variable.

% Inputs:
    % - strategyNo : what strategy we are running. Used in switch-case statement below.
    % - crsp : the data file we are using. This is a large file and it takes time to load. Instead of loading a new crsp data everytime when running this function, we can import crsp file only for once in 'main.m' and pass this to 'runStrategy.m' as an argument.
    % - thisCrsps: this is a special table we created in order to significantly increase the performance of this code. By adding this variable we can improve the running time of this code from 3 minutes to 30 seconds. This table contains every single 'thisCrsp' generated by 'isInvestible' (from tradeLongMomentum.m) conditional statement for each datenum. Before using this table, the strategy functions (e.g. strategyMS_V, strategySM_V) should have calculated thisCrsp for all for-loop iterations, which took a significant amount of running time. Now we skip the process by providing every 'thisCrsp's as a function argument to the strategy functions.
        % - In case you are wondering 'what is thisCrsp?', check the tradeLongMomentum.m Evan provided us as an example. This is simply a crsp table with firms investible at a specific datenum.
% Outputs:

    fprintf("\n");
    disp("Program begins!")
    disp(datestr(now, 'HH:MM:SS')); % displays time when running this function.

    % clean up unnecessary variables, just for debugging purpose.
    clearvars -except crsp ff3 dateList marketIndex thisCrsps strategyNo transactionCost

    %% Input (function argument)
    % prints the values of 'strategyNo' and 'transactionCost', just for debugging purposes.
    fprintf("strategyNo : %d\n", strategyNo);
    fprintf("transactionCost : %d\n", transactionCost);

    % This is very similar to those if-statements explained in main.m. See 'main.m' for comparison.
    % These loads 'ff3', 'dateList' and 'marketIndex' variable from mat-files.
    % These are not included in 'main.m', because there is a trade-off in the design of the code.
    % If we include these 3 if-statements in 'main.m', the 'runStrategy.m' function will not recognize it so we should pass it as an argument. We only need to load it one time in that case, so we might expect some improvment on running time (i.e. getting read of loading time). However, this would lead us to a messy, long 'runStrategy' function with too many redundant arguments.
    % It turns out, however, the improvement on running time with 'ff3', 'dateList' and 'marketIndex' is insignificant and unrecognizable, unlike 'crsp' and 'thisCrsps'.
    % Therefore, in order to make the function cleaner, we included these 3 if-statements here, while including 'crsp' and 'thisCrsps' in 'main.m'.
    % It is true that all these messy considerations can be avoided if we use 'global variables', but this is based on our coding philosophy to maintain our code functional (i.e. the output of the code is always the same if the input is the same). We consider having states, especially while running data analysis, can be potentially very harmful and difficult to detect mistakes.
    %
    % checks if 'ff3' is in the workspace, and if not, load it to the workspace.
    if ~exist('ff3', 'var')
        fprintf("ff3 not exist. Loading...\n");
        ff3Mat = load('matFolder/ff3.mat');
        ff3 = ff3Mat.ff3;
    end
    % checks if 'dateList' is in the workspace, and if not, load it to the workspace.
    if ~exist('dateList', 'var')
        fprintf("dateList not exist. Loading...\n");
        dateListMat = load('matFolder/dateList.mat');
        dateList = dateListMat.dateList;
    end
    % checks if 'marketIndex' is in the workspace, and if not, load it to the workspace.
    if ~exist('marketIndex', 'var')
        fprintf("marketIndex not exist. Loading...\n");
        marketIndexMat = load('matFolder/marketIndex.mat');
        marketIndex = marketIndexMat.marketIndex;
    end
    % What is 'marketIndex'? Simply put, it is a value-weighted market index with all the firms in CRSP-pool.
    % It is like S&P 500, but for CRSP, with 4785 firms instead of just 500.
    % We created it using what we achieved in Assignment 1.
    % This is useful because it provides us the market volatility which is used in most of our strategies in weighting different partial portfolios. Refer to our strategy function files (e.g. strategyMS_V.m) for detailed information.

    %crsp=readtable('crspTest.csv');

    % %Create testData.csv
    % crsp=readtable('csvFolder/crspCompustatMerged_2010_2014_dailyReturns.csv');
    % permnoList=unique(crsp.PERMNO);
    % permnoList=randsample(permnoList,100);
    % crsp=crsp(ismember(crsp.PERMNO,permnoList),:);
    % writetable(crsp,'crspTest.csv');
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
    % crsp.momentum=crsp.lag21adjustedPrice./crsp.lag252adjustedPrice;
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
    % clean up unnecessary variables, just for debugging purpose.
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
    % marketIndex{:,'cumLogRet'}=NaN;
    % marketIndex.cumLogRet(~isnan(marketIndex.RET))=cumsum(log(1+marketIndex.RET(~isnan(marketIndex.RET))));
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

    fprintf("start iteration..\n");
    n = 0;
    len = size(thisStrategy,1);

    starti = 295;% starts from 295 because sigma is available from this date.

    % This forloop iterates through each date (unique datenum column), and performs the trade based on the selected strategy (determined by 'strategyNo' input in the switch-case statement below).
    for i = starti:len
        % shows a nice progress of forloop, not to bore the user.
        % code obtained from https://stackoverflow.com/questions/8825796/how-to-clear-the-last-line-in-the-command-window
        msg = sprintf('Processed: %d/%d', i, len);
        fprintf(repmat('\b', 1, n));
        fprintf(msg);
        n=numel(msg);
        % ends the progress bar code.

        thisDate=thisStrategy.datenum(i);
        if i ~= starti
            lastPortfolio=thisPortfolio;
        end

        % What is this 'switch-case' statement, in case you are wondering?
        % based on the value of strategyNo, the code chooses the case and runs the lines contained in the specific case.
        % See matlab's guide to switch-case statement for further information.
        % For explanation of each strategy, see the individual strategy function file (e.g. strategyMS_V.m, strategySM_V.m).
        switch strategyNo
            case 0 % This is from Evan's code. We are not going to run it.
                thisPortfolio = tradeLongMomentum();
            case 1
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.8 1], [0 0.2], [0.8 1]);
            case 2
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0 0.1], [0.9 1]);
            case 3
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [.75 1],[0 .25],[.75 1]);
            case 4
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.1 1], [0.1 1], [0.75 1]);
            case 5
                thisPortfolio = strategyM_VS(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0 .1], [.7 1]);
            case 6
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0.4 0.6], [0.75 1]);
            case 7
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0.75 1], [0.9 1]);
            case 8
                thisPortfolio = strategySM_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0.75 1], [0.9 1]);
            case 9
                thisPortfolio = strategySM_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0 0.25], [0.9 1]);
            case 10
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [0 0.25], [0.9 1]);
            case 11
                thisPortfolio = reverse_strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [.75 1],[0 .25],[.75 1]);
            case 12
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0.9 1], [.75 1], [0.75 1]);
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
            case 18
                thisPortfolio = strategyMS_V(thisCrsps.thisCrsp{i}, marketIndex.sigma(i), [0 1], [0 0.1], [0.9 1]);
            otherwise
                disp("wrong strategy number!");
        end

        thisStrategy.portfolio(i)={thisPortfolio}; %Bubble wrap the table of investment weights and store in thisStrategy

        if(i ~= starti) % This part will run from the second iteration.
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

    % Now that we have thisStrategy, we are going to evaluate it using evaluateStrategy.m function.
    thisPerformance = evaluateStrategy(thisStrategy,ff3);
    fprintf("Evaluation Done! Now saving the results ...\n");
    disp(datestr(now, 'HH:MM:SS'));



    % Naming the performance results of this strategy.
    resultName = strcat('strategy',num2str(strategyNo),'Performance');
    thisPerformance.strategyName = resultName; % Include the name information in the results table for future use. i.e. Labelling.
    % Saving the results for future use in 'results' folder. This mat file will be used in 'loadResults.m' script.
    save(strcat("results/",resultName), 'thisPerformance');

    %Plot cumulative returns, market cumulative returns, and market annualized volatility with dateticks
    marketCumLogRet295 = marketIndex.cumLogRet - marketIndex.cumLogRet(295);

    plot(dateList(295:end), thisPerformance.thisStrategy.cumLogRet(295:end), dateList(295:end), marketIndex.sigma(295:end)*sqrt(252), ...
        dateList(295:end), marketCumLogRet295(295:end));
    datetick('x','yyyy-mm', 'keepticks', 'keeplimits')
    lgd = legend('QuantShare strategy cumulative return', 'Annualized market volatility', 'Market cumulative return')
    %lgd.FontSize = 18;
    %set(gca, 'FontSize', 18)
    saveas(gcf, strcat('plots/strategy',num2str(strategyNo),'Plot.png'));


    disp("Program ends!")
    disp(datestr(now, 'HH:MM:SS')); % displays time

end

% function ends here.
