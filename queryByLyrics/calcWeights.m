function indexesTop = calcWeights(bagOfAllCosts, allCosts)
		% local cut-off dist
	% figure; a = hist(totalCosts, 30);
	[n,xout] = hist(bagOfAllCosts, 30);
	[maxCnt, idxMax] = max(n);
	cutOffDist = xout(idxMax);

	% second loop to calc weights

	allWeightsPaths = [];
	% weight
	for j = 1:size(allCosts,2)
		currWeights = allCosts{j} < cutOffDist;
		allWeightsPaths  = [ allWeightsPaths; sum(currWeights)];

	end

	%%%%%%%%%%%%%%%%%%%%%
	% Sort by weights
	[	weightPathsSorted, indexes] = sort(allWeightsPaths, 'descend');

	indexesTop = indexes(1:10);

end