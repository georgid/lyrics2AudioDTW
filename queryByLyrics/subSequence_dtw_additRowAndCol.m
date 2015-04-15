
%%%%%%
% @param: similarityMatrix on horizontal is target,
% on vertical is query
% 
%%%%%
function [totalDistMatrix, backPtrMatrix] = subSequence_dtw(costMatrix, penalty)





    LengthTarget=size(costMatrix,2) + 1;
    LengthQuery=size(costMatrix,1) +1;
    totalDistMatrix=zeros( LengthQuery, LengthTarget);
	
	% DEBUG. backpointer matrix
	backPtrMatrix= zeros( LengthQuery, LengthTarget);
	

   
	%initialize
		
% 		totalDistMatrix(:,1) = inf;
	
		% 1. first column: increasing costs down on inserted column. To penalize paths
		% starting farther from start cell
		avrgCost = 100;
		totalDistMatrix(:,1) = ([0:LengthQuery-1] * avrgCost )';
		totalDistMatrix(:,1) = inf;
		totalDistMatrix(1,1) = 0;
		
		% 2. end space free alignment

		totalDistMatrix(1,:)=( [0:LengthTarget-1] * 0)';
		totalDistMatrix(1,:) = 0;

		


    for tIndex=2:LengthTarget
% 		disp( tIndex);
		for qIndex=2:LengthQuery

			% next state
			mNext=totalDistMatrix(qIndex-1, tIndex-1) + penalty;
			
			% same State	
			mSame=totalDistMatrix(qIndex, tIndex-1);
        			
						
% 			% jump to next after next. skip one state
			if qIndex == 2
				mSkip = inf;	
			else
				mSkip = totalDistMatrix(qIndex-2, tIndex-1);
			end	
			
			% take min. no skip
			[minPathCost, backPtrOperation ] = min( [mSame ; mNext]);
			
			% take min
% 			[minPathCost, backPtrOperation ] = min( [mSame ; mNext; mSkip]);
			
			
			% cost matrix does not have added 0th row and 0th column
			totalDistMatrix(qIndex,tIndex) = minPathCost + costMatrix(qIndex-1,tIndex-1);
			backPtrMatrix(qIndex, tIndex) = backPtrOperation;
			
		end % end inner loop
	end
	
		% strip off final rows and columns
	totalDistMatrix = totalDistMatrix(2:LengthQuery,2:LengthTarget);
	
	backPtrMatrix = backPtrMatrix(2:LengthQuery,2:LengthTarget);
	
    
end