function visualizeDistMatrix(totalDistMatrix, fromTs, toTs, weightDiag, cuttOffIndex)
numFrPerSecond = 100;
fromFrame = fromTs * numFrPerSecond;
toFrame = toTs * numFrPerSecond;

if fromFrame==0 && toFrame  == 0
	fromFrame = 1;
	toFrame = size(totalDistMatrix,2) ;
end


figure; imagesc(totalDistMatrix(:,fromFrame:toFrame) ); 
s = sprintf('weightDiag: %f cuttOff: %f',weightDiag, cuttOffIndex);
title(s); 	figure(gcf);

end
