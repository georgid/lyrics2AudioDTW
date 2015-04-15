function [restart, Path, pathXs, pathYs] = traceBackMinPath_additRowAndCol(row, col, backPtrMatrix, Path, pathXs, pathYs)

	while (row > 1)	% loop until beginning of query
			backOperation = backPtrMatrix(row, col);
			
			% prev. state
			if (backOperation == 3 )
				col = col - 1;
				if row==2
				disp(fprintf('at column col %d at row 2 backptr says skipped ', col));	
				row = row - 1;
				else
				
				row = row - 2;
				end
			% prev. state
			elseif (backOperation == 2)
				col = col - 1;
				row = row - 1;

			% same state
			elseif (backOperation == 1)
				col = col - 1;

				%sanity check: not possible backptr. value
			else
				disp('ERROR: backpointer');
				return;
			end

			% BREAK CONDITION: reached first frame of target before first
			% frame of query
			if(col == 0)
				% blacklist this path
% 				totalDistMatrix(LengthQuery, lastTargetFrameIndex )  = inf;
				
	
				restart = 1;
				disp('not full path for whole length of query');
				return;
			end
			
			% add to path
			Path( row , col ) = 1;
			% DEBUG: PATH INDICES. 
			pathYs = [row, pathYs];
			pathXs = [col, pathXs];	
			% DEBUG: PATH INDICES. END 
			
			

		end %  while
	
	% reached first column => solution found
	restart = 0;

end