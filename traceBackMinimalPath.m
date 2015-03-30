% Traces the path with minimal total distance. Makes sure path begins at
% first frame of query

% @param totalDistMatrix - matrix with distances
% @param backPtrMatrix - pointer to previous cell

% @return Path - matrix of zeros, 1s on the best path 

% @return totalDistMatrix is returned since once finding min-Path, we can
% exclude this and continue to search for next min path. This is needed if
% we need more than one min path. Currently not used

function [Path, pathXs, pathYs, dist, firstTargetFrameIndex, lastTargetFrameIndex, totalDistMatrix ] = traceBackMinimalPath (totalDistMatrix, backPtrMatrix)	

LengthQuery = size(totalDistMatrix, 1);
LengthTarget = size(totalDistMatrix, 2);

% DEBUG: PATH INDICES. 
pathYs = [];
pathXs = [];
% DEBUG: PATH INDICES. END 

% find the best path in the matrix
	restart = 1;
	lastTargetFrameIndex = LengthTarget;
		
	while (restart == 1)
		
		Path=zeros( LengthQuery, LengthTarget);
		
		% result is the minimal cost on last row
		[dist, lastTargetFrameIndex] = min( totalDistMatrix(LengthQuery,:));

% 		dist = totalDistMatrix(LengthQuery,lastTargetFrameIndex);

		% init
		col = lastTargetFrameIndex;
		row = LengthQuery;

		Path(row, col) = 1;
		% DEBUG: PATH INDICES. 
		pathYs = [row];
		pathXs = [col];
		
		% DEBUG: PATH INDICES. END
		
		
		backOperation = backPtrMatrix(row, col);


		while (row > 1)

			% inseert
			if (backOperation == 1)
				col = col - 1;
				row = row - 1;

				%REPLACE
			elseif (backOperation == 2)
				col = col - 1;

				%DELETE
			else
				disp('no path in backtracking');
				break;
% 				col = col - 1;
% 				row = row - 2 ; 

			end

			% BREAK CONDITION: check if path makes sence. e.g. if first frame of query (row ) is at first
			% frame of target (col)
			if(col < 1)
				% blacklist this path
				totalDistMatrix(lastTargetFrameIndex, LengthQuery)  = inf;
				
				lastTargetFrameIndex  = lastTargetFrameIndex - 1;
				
				restart = 1;
				disp('not full path for whole length of query');
				break;
			end

			Path( row , col ) = 1;
			% DEBUG: PATH INDICES. 
			pathYs = [row, pathYs];
			pathXs = [col, pathXs];	
			% DEBUG: PATH INDICES. END 
			
			backOperation = backPtrMatrix(row, col);

		end % inner while
		
	% solution found
	restart = 0;
	
	end %% outer while

	firstTargetFrameIndex = col;
	

end