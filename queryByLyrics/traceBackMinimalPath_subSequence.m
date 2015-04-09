% Traces the path with minimal total distance. Iterates until Makes sure path begins at
% first frame of query

% @param totalDistMatrix - matrix with distances
% @param backPtrMatrix - pointer to previous cell

% @return Path - matrix of zeros, 1s on the best path 

% @return totalDistMatrix is returned since once finding min-Path, we can
% exclude this and continue to search for next min path. This is needed if
% we need more than one min path. Currently not used

function [Path, pathXs, pathYs, dist, firstTargetFrameIndex, lastTargetFrameIndex, totalDistMatrix ] = traceBackMinimalPath_subSequence (totalDistMatrix, backPtrMatrix)	

LengthQuery = size(totalDistMatrix, 1);
LengthTarget = size(totalDistMatrix, 2);


% find the best path in the matrix
	restart = 1;
		
	while (restart == 1)
		
		%init path
		Path=zeros( LengthQuery, LengthTarget);
		pathYs = [];
		pathXs = [];
		
		% minimal cost from last row
		[dist, lastTargetFrameIndex] = min( totalDistMatrix(LengthQuery,:));
		if dist == Inf
			disp('no path with required minimal duration found');
			return;
		end

		% inital vals
		col = lastTargetFrameIndex;
		row = LengthQuery;
		
		% add to path
		Path(row, col) = 1;
		pathYs = [row];
		pathXs = [col];
		
		[restart, Path, pathXs, pathYs] = traceBackMinPath(row, col, backPtrMatrix, Path, pathXs, pathYs);
		lenPath = length(pathXs) ;
		
% 		if lenPath ~= LengthQuery
% 			restart = 1;
% 		end
		
		% blacklist this path
		if restart == 1
 				totalDistMatrix(LengthQuery, lastTargetFrameIndex )  = inf;
		end
		

	
	end %% outer while

	firstTargetFrameIndex = pathXs(1);
	

end