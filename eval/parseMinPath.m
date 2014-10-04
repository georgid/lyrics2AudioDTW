
% Turn minPath result into a list of detected @return listWords and
% @return startTimeStamps
% 
% @param listPhonemesWithStates - take from it 'phoneme name' only at indices where
% phoneme starts
%
function [startTimeStamps, listPhonemes ] = parseMinPath(minimalPath, listPhonemesWithStates)

%%%%%%%%% phonemes are not empty entries in listphonemes 
beginIndicesPhonemes = not(cellfun(@isempty, listPhonemesWithStates))';


% word identities
 listPhonemes = listPhonemesWithStates(beginIndicesPhonemes)';


indicesMatrix2 = vertcat(beginIndicesPhonemes, zeros( size(minimalPath,1)- size(beginIndicesPhonemes,1) ,1) );


repIndicesMatrix = repmat(indicesMatrix2, 1, size(minimalPath,2) ); 

%%%%%%%%%%%% IMPORTANT. Find  TIMESTAMPS
% INtersect. first occurences of 1-s on each row in minmal path
 [Xs,Ys] = find(repIndicesMatrix .* minimalPath );
 [a,indices] =  unique(Xs, 'first');
	
  % start at time 0, not at index 1
 startTimeStamps = Ys(indices) -1 ;


 
end