results = {NaN};
for i = 2:17
    resultName = strcat('results/strategy', num2str(i), 'Performance')
    results(i,1) = {resultName};
    loaded = load(resultName);
    results(i,2) = {loaded.thisPerformance};
end
for i = 2:17
    results(i,3) = {results{i,2}.averageHoldingPeriod};
    results(i,4) = {results{i,2}.sharpeRatio};
    results(i,5) = {results{i,2}.informationRatio};
    results(i,6) = {results{i,2}.alphaCAPM};
    results(i,7) = {results{i,2}.alphaFF3};
end
