function listPhonemesWithStates = cleanUplistPhonemesWithStates(listPhonemesWithStates)

	% rename repeating names to []. for visualization purposes
	prev = '';
	for i=1:size(listPhonemesWithStates,2)
		if ~strcmp(listPhonemesWithStates{i},prev)
			prev = listPhonemesWithStates{i}; 
		else
			listPhonemesWithStates{i} = '';
		end
	end

end