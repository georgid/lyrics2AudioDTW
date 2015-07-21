
function [isSilence, loadedGmm, modelNames, gmms, means, weights] = checkModelAndLoadGmm(fullModelName, modelNames, gmms, pathToModels, hasDeltas)

% TODO: check as well sil
isSilence = 0;
if strcmp(fullModelName,'sp_0')
	isSilence = 1;
end

[isMemb, idx] = ismember(fullModelName, modelNames);
		% already loaded
		if isMemb
			loadedGmm = gmms{idx};
		
		else % else create
			
			[currModelName, whichState] = parseModelName(fullModelName );
			[means, vars2, weights] = loadModels(pathToModels, currModelName, whichState,  hasDeltas );
			loadedGmm = gmdistribution(means,vars2,weights);
			
		% store created gmm and name
			sizeNames = size(modelNames,1);
			modelNames{sizeNames + 1} = fullModelName;
			
			sizeGmm = size(gmms,1);
			gmms{sizeGmm + 1} = loadedGmm;
			
		end
		
end