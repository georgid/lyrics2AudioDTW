function visualizeDistMatrix(totalDistMatrix, fromTs, toTs)
numFrPerSecond = 100;
fromFrame = fromTs * numFrPerSecond;
toFrame = toTs * numFrPerSecond;

figure; imagesc(totalDistMatrix(:,fromFrame:toFrame) ); figure(gcf);

end