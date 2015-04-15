function [currModelName, whichState]  = parseModelName(modelNameFull)

		a = textscan(modelNameFull,'%s', 'Delimiter', '_');
		tokens = a{1,1};
		currModelName = cell2mat(tokens(1));
		whichState = str2num(cell2mat(tokens(2)));


end