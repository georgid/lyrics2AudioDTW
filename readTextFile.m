
function phonemesList = readTextFile(phonemes_URI)
	fid = fopen(phonemes_URI,'r');
	phonemesList = textscan(fid, '%s', 'Delimiter', '/n');
	phonemesList = phonemesList{1,1}';
	fclose(fid);
	
end