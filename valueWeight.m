function w = valueWeight(marketCapVector)
    mcSum = sum(marketCapVector); % Total market capitalization
    w = marketCapVector./mcSum; % vector of relative market capitalization compared with others
end
