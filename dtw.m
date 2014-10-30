
%%%%%%
% @param: similarityMatrix on horizontal is target,
% on vertical is query
% 
%%%%%
function [totalDistMatrix, backPtrMatrix, costMatrix] = dtw(similarityMatrix)

% take log 
costMatrix  = -log(similarityMatrix);



    LengthTarget=size(costMatrix,2) + 1;
    LengthQuery=size(costMatrix,1) +1;
    totalDistMatrix=zeros( LengthQuery, LengthTarget);
	
	% DEBUG. backpointer matrix
	backPtrMatrix= zeros( LengthQuery, LengthTarget);
	

   
	%initialize
% 		% end space free alignment
% 		totalDistMatrix(1,:)=( [0:LengthTarget-1] * 0)';
% 		% costInsert on first row
% 		totalDistMatrix(:,1) = inf;
% 		
		totalDistMatrix(1,:)= NaN;
		% increasing costs down on inserted column. To penalize paths
		% starting farther from start cell
		avrgCost = 80;
		totalDistMatrix(:,1) = ([0:LengthQuery-1] * avrgCost )';
		totalDistMatrix(1,1) = 0;

    for tIndex=2:LengthTarget
        for qIndex=2:LengthQuery
			
			
		
            
			% same state
			m1=totalDistMatrix(qIndex-1, tIndex-1);
			
			% nextState	
			m2=totalDistMatrix(qIndex, tIndex-1);
        			
			
            % switched off for now. replaced by this one line: 
			
% 			% jump to next after next. skip one state
% 			if qIndex ==2
% 				m3 = inf;	
% 			else
% 				m3 = totalDistMatrix(qIndex-2, tIndex-1);
% 			end	
			
			% take min
			[minPathCost, backPtrOperation ] = min( [m1 ; m2]);
			
			% cost matrix does not have added 0th row and 0th column
			totalDistMatrix(qIndex,tIndex) = minPathCost + costMatrix(qIndex-1,tIndex-1);
			backPtrMatrix(qIndex, tIndex) = backPtrOperation;
			
		end % end inner loop
	end
	
	% strip off final rows and columns
	totalDistMatrix = totalDistMatrix(2:LengthQuery,2:LengthTarget);
	
	backPtrMatrix = backPtrMatrix(2:LengthQuery,2:LengthTarget);
    
end