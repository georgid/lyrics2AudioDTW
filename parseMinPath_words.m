
% Turn minPath result into a list of detected @return listWords and
% @return startTimeStamps
% 
% @param listPhonemesWithStates - take from it 'phoneme name' only at indices where
% phoneme starts
%
function [startTimeStamps, listWords ] = parseMinPath_words(minimalPath, listPhonemesWithStates, wordsSequence, hasDurations)

%%%%%%%%% phonemes are not empty entries in listphonemes 
beginIndicesPhonemes = not(cellfun(@isempty, listPhonemesWithStates))';

% indicesMatrixWords = beginIndicesPhonemes2BeginIndicesWords(beginIndicesPhonemes, wordsSequence, 0)


indicesMatrixWords = zeros(size(beginIndicesPhonemes)); 

% Indices. LOAD FROM PYTHON
fid = fopen('/tmp/test.indices','r');
indices = textscan(fid, '%f');
indices = indices{1,1}
fclose(fid);


for i = 1:length(indices)
	
	
	% put one at begin of word
	ind = indices(i);
	indicesMatrixWords(ind,1) = 1;
end	

	
indicesMatrixWords = logical(indicesMatrixWords);



% word identities
 listWords = listPhonemesWithStates(indicesMatrixWords)';



indicesMatrix2 = vertcat(indicesMatrixWords, zeros( size(minimalPath,1)- size(indicesMatrixWords,1) ,1) );


repIndicesMatrix = repmat(indicesMatrix2, 1, size(minimalPath,2) ); 

%%%%%%%%%%%%  FIND TIMESTAMPS
% Intersect. first occurences of 1-s on each row in minmal path
 [Xs,Ys] = find(repIndicesMatrix .* minimalPath );
 [a,indices] =  unique(Xs, 'first');
	
  % start at time 0, not at index 1
 startTimeStamps = Ys(indices) -1 ;


 
end