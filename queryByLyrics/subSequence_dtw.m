
%%%%%%
% @param: similarityMatrix on horizontal is target,
% on vertical is query
% 
%%%%%
function [totalDistMatrix, backPtrMatrix] = subSequence_dtw(costMatrix)





    LengthTarget=size(costMatrix,2) + 1;
    LengthQuery=size(costMatrix,1) +1;
    totalDistMatrix=zeros( LengthQuery, LengthTarget);
	
	% DEBUG. backpointer matrix
	backPtrMatrix= zeros( LengthQuery, LengthTarget);
	

   
	%initialize
		% end space free alignment
		totalDistMatrix(1,:)=( [0:LengthTarget-1] * 0)';
		% costInsert on first col
		totalDistMatrix(:,1) = inf;
		
		% increasing costs down on inserted column. To penalize paths
		% starting farther from start cell
% 		avrgCost = 80;
% 		totalDistMatrix(:,1) = ([0:LengthQuery-1] * avrgCost )';
% 		totalDistMatrix(1,1) = 0;

    for tIndex=2:LengthTarget
        for qIndex=2:LengthQuery
			
			
		
            
			% next state
			mNext=totalDistMatrix(qIndex-1, tIndex-1);
			
			% same State	
			mSame=totalDistMatrix(qIndex, tIndex-1);
        			
			
            % switched off for now. replaced by this one line: 
			
% 			% jump to next after next. skip one state
% 			if qIndex ==2
% 				m3 = inf;	
% 			else
% 				m3 = totalDistMatrix(qIndex-2, tIndex-1);
% 			end	
			
			% take min
			[minPathCost, backPtrOperation ] = min( [mSame ; mNext]);
			
			% cost matrix does not have added 0th row and 0th column
			totalDistMatrix(qIndex,tIndex) = minPathCost + costMatrix(qIndex-1,tIndex-1);
			backPtrMatrix(qIndex, tIndex) = backPtrOperation;
			
		end % end inner loop
	end
	
	
    
end