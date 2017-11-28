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

for i = 1:17
    runStrategy(i, crsp, thisCrsps);
end
