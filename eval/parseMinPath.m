
%
% @param listPhonemesWithStates - 'phoneme name' only at indices where
% phoneme starts
% 
%
function parseMinPath(minimalPath, listPhonemesWithStates, fileName)
	
indicesMatrix = not(cellfun(@isempty,listPhonemesWithStates))';

indicesMatrix2 = vertcat(indicesMatrix, zeros( size(minimalPath,1)- size(indicesMatrix,1) ,1) );

repIndicesMatrix = repmat(indicesMatrix2, 1, size(minimalPath,2) ); 

% find first occurences of 1-s on each row in minmal path
 [Xs,Ys] = find(repIndicesMatrix .* minimalPath );
 [a,indices] =  unique(Xs, 'first');
	
 % start at time 0, not at index 1
 startTs = Ys(indices) -1 ;

 startTs = startTs .* 100000;
 
 endTs = startTs(2:end)
 %  hack. made up val of 0.1 sec
 endTs(end + 1)  = endTs(end) + 1* 100000;

 
listPhonemes = listPhonemesWithStates(indicesMatrix)';
nrows = size(startTs,1); 
c = cell (size(startTs,1), 3);
 for row = 1:nrows
	c{row,1} = startTs(row);
	c{row,2} = endTs(row);
	c{row,3} = listPhonemes{row};
 
 end
 
 %  write to file 
 fid = fopen(fileName,'w');
	formatSpec = '%d %d %s\n';
	
 fprintf(fid,  'blah\n');
 fprintf(fid,  'blah\n');
 
 for row = 1:nrows
fprintf(fid, formatSpec, c{row,:} );
 end

 fprintf(fid,  'blah');

end