results = {NaN};
for i = 2:17
    resultName = strcat('results/strategy', num2str(i), 'Performance')
    results(i,1) = {resultName};
    loaded = load(resultName);
    results(i,2) = {loaded.thisPerformance};
end