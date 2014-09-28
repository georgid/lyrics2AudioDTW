% load model parameteres from text files
function [means, vars2, weights] = loadModels(pathToModels, modelName, whichState,  hasDeltas)


		
fid = fopen('/Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/interim_files/monophones1');
phonemeNames = textscan(fid, '%s');


% load all models
for i = 1:size(phonemeNames{1},1)
	phonemeName = phonemeNames{1}{i};

	if strcmp(phonemeName, modelName)
		
			
			modelMeansURI = [pathToModels  phonemeName int2str(whichState-1) '.means'];
			modelVarsURI = [pathToModels  phonemeName int2str(whichState-1) '.vars'];
			modelVarsWeights = [pathToModels phonemeName int2str(whichState-1) '.weights'];

			% 	
			% means = dlmread('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/htk2s3/compare/testmeans')
			% vars = dlmread('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/htk2s3/compare/testvars')
			% weights = dlmread('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/htk2s3/compare/testweights')

			 means = dlmread(modelMeansURI);
			 vars = dlmread(modelVarsURI);
			 weights = dlmread(modelVarsWeights);


			% k - num muxtures, 
			% d - feature dim
			% mu in format k x d
			% stdev in format: 1 x d x k 
			% p : mixture weights: 1 x k 

			% DEBUG: no Deltas
			if ~hasDeltas
				means = means(:,1:12);
				vars = vars(:,1:12);
			end
			% end DEBUG

			varsT = vars';

			vars2 = zeros(1, size(varsT,1), size(varsT,2));
			vars2(1,:,:) = varsT;
		

	end




end

fclose(fid);


end

