function [ listStartNonVocalSections listEndNonVocalSections] = getVocalNonVocalSections(URI_targetNoExt, featureVectors, numFramesPerSec)

% HARD-CODED for now. 

listStartNonVocalSections = [0, 61,  121, 216];
listEndNonVocalSections = [23.6, 84, 188, size(featureVectors, 2) / numFramesPerSec ];


end

