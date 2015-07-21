function costMatrixSanity = cutOffDists( costMatrixSanity, cuttOffindex )
%CUTOFFDISTS Summary of this function goes here
%   Detailed explanation goes here

for j = 1:size(costMatrixSanity,2)
	[n,xout] = hist(costMatrixSanity(:,j));
	% cut after first 3 peaks
	cutOffDist = xout(cuttOffindex);
	for l=1:size(costMatrixSanity,1) 
		if costMatrixSanity(l,j) > cutOffDist
			costMatrixSanity(l,j) = 200;
		end
	end
end

end

