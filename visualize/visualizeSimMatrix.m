
%%%%%%%%%%% helper graphic: histogram of likelihoods
a = similarityMatrix(:)

[histogr, xout] = hist(a, 100);

figure;
bar(xout, histogr, 'DisplayName','histogr'); figure(gcf)


%%% find threshold. empirical values
% no deltas
if ~hasDeltas
	IndexGrThan = similarityMatrix > 0.8e-16

% deltas
else 
	IndexGrThan = similarityMatrix > 0.5e-20
end


similarityMatrix = similarityMatrix - IndexGrThan.*similarityMatrix

