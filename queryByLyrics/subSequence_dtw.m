
%%%%%%
% @param: similarityMatrix on horizontal is target,
% on vertical is query
% 
%%%%%
function [totalDistMatrix, backPtrMatrix] = subSequence_dtw(costMatrix, weightDiag)

% weight diagonal and horiz. step
% weightDiag = 2;
weightHorz = 1;
weightSkip = 1;

    LengthTarget=size(costMatrix,2);
    LengthQuery=size(costMatrix,1);
    totalDistMatrix = inf( LengthQuery, LengthTarget);
	
	% DEBUG. backpointer matrix
	backPtrMatrix= zeros( LengthQuery, LengthTarget);

   
	%initialize
		
		
		% 1. first column: increasing costs down
% 		sumCosts = 0;
% 		for i = 1:LengthQuery
% % 			sumCosts = sumCosts + (2 * weightDiag) * costMatrix(i,1);
% 			sumCosts = sumCosts +  costMatrix(i,1);
% 
% 			totalDistMatrix(i,1) = sumCosts;
% 		end
		
		totalDistMatrix(:,1) = inf;
% 		totalDistMatrix(:,1) = costMatrix(:,1);

		
		% 2. first row: end space free alignment

		totalDistMatrix(1,:) = weightHorz * costMatrix(1,:);
		
		totalDistMatrix(1,1)  =  costMatrix(1,1);
		
	for tIndex=2:LengthTarget
		disp( tIndex);
		for qIndex=2:LengthQuery
			
			if tIndex - qIndex < 0 || tIndex - qIndex > LengthTarget - LengthQuery
				continue;
			end
			% next state
			mDiag=totalDistMatrix(qIndex-1, tIndex-1) + weightDiag * costMatrix(qIndex,tIndex);
			
			% same State	
			mHorz=totalDistMatrix(qIndex, tIndex-1) +  weightHorz * costMatrix(qIndex,tIndex);
        			
						
% 			% jump to next after next. skip one state
			if qIndex == 2
				mSkip = inf;	
			else
				mSkip = totalDistMatrix(qIndex-2, tIndex-1);
			end	
			
			% take min. no skip
			[minCost, backPtrOperation ] = min( [mHorz ; mDiag]);
			
			% take min
% 			[minPathCost, backPtrOperation ] = min( [mHorz ; mDiag; mSkip]);
			
			
			% cost matrix 
			totalDistMatrix(qIndex,tIndex) = minCost;
			backPtrMatrix(qIndex, tIndex) = backPtrOperation;
		end % end inner loop
	end
	

	
    
end