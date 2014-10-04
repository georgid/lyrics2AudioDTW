function writeDetectedToFile(startTs, listTokens, fileName, forWords) 

 %%%%%%%%%%%% prepare indices for output
if (forWords) 
	NUMTOKENS_PER_LINE = 5;
else
	% phonemeLevel
	NUMTOKENS_PER_LINE = 3;
end

 startTs = startTs .* 100000;
 
 % endTs coincide with startTs for next token
 endTs = startTs(2:end);

 %  FIXME: for final duration. made up val of 0.1 sec
 endTs(end + 1)  = endTs(end) + 1* 100000;

 
% ignore last one. it is sil. just used as slave to get final time stamp of prev.
% word
if (forWords) 
	nrows = size(startTs,1) -1; 
else
		nrows = size(startTs,1); 

end


c = cell (nrows, NUMTOKENS_PER_LINE);

 for row = 1:nrows
	c{row,1} = startTs(row);
	c{row,2} = endTs(row);
	
	if (forWords) 
		c{row,3} = 'blah';
		c{row,4} = 'blah';
		c{row,5} = listTokens{row};
	 
	else 
		c{row,3} = listTokens{row};
	end
 
 end
 
 %  write to file 
 fid = fopen(fileName,'w');
	
	if (forWords)
		formatSpec = '%d %d %s %s %s\n';
	else
	 	formatSpec = '%d %d %s\n';

	end

	% appenf blah lines to satisfy mlf format
 fprintf(fid,  'blah\n');
 fprintf(fid,  'blah\n');
 
 for row = 1:nrows
	fprintf(fid, formatSpec, c{row,:} );
 end

 fprintf(fid,  'blah');

 fclose(fid);
 
 disp(['written file ' fileName  ]);
 
 