% load model parameteres from text files
function [means, vars2, weights] = loadModels(pathToModels, queryModelName, whichState,  hasDeltas)


		
fid = fopen('/Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/interim_files/monophones1_full');
phonemeNames = textscan(fid, '%s');


% load all models
for i = 1:size(phonemeNames{1},1)
	phonemeName = phonemeNames{1}{i};

	if strcmp(phonemeName, queryModelName)
		
			
			modelMeansURI = [pathToModels  phonemeName int2str(whichState) '.means'];
			if ~exist(modelMeansURI, 'file')
				
				fprintf('file: %s does not exist', modelMeansURI);
			end
			
			modelVarsURI = [pathToModels  phonemeName int2str(whichState) '.vars'];
			modelVarsWeights = [pathToModels phonemeName int2str(whichState) '.weights'];

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


	if ~exist('means', 'var')
		fprintf('model : %s \n' , queryModelName)
		fprintf('state num : %d \n' , whichState)

	end


end

