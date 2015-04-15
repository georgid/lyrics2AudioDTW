%%%
% allCosts a bag of all possible arrays for paths 
%%%
function [bagOfAllCosts, allCosts] = calcCostForPaths(costMatrix, currMinimalPath, bagOfAllCosts, allCosts )
	
	pathCostMatrix = costMatrix .* currMinimalPath;
	
	% convert matrix into array. NOTE that info about x and y of path are lost
	costs = pathCostMatrix(pathCostMatrix~=0);

	% 	store
	bagOfAllCosts = [bagOfAllCosts; costs ]; 
	currSize = size(allCosts,2);
	allCosts{currSize + 1} = costs;
	

end