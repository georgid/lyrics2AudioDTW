%%% @return durations (in terms of frames)
%	@return phonemesSil - phonemes with padded sil at ends
%	 @param: startNoteNum  - consecutive number of first note of first
%	 syllable for audio segment of interest
%	@param: lyrics - in form of syllables
%

function [phonemesSil, phonemeDurations, wordsSequence] = calcPhonemeDurations(noteDurations, lyrics, startNoteNum, endNoteNum)

%%%% read syllables: 
addpath('readLyrics');


syllables = {};
syllableDurations = [];

i = startNoteNum; 
while i < endNoteNum

	currSyllable =	lyrics{i};
	currTotalDuration = noteDurations.Value(i);
	
	i = i + 1; 
	while ( i < size(lyrics,1) && strcmp(lyrics{i}, '') )
		currTotalDuration = currTotalDuration + noteDurations.Value(i);
		i = i + 1; 
	end
	
	% end of syllable
	syllables{end + 1} = currSyllable;
	syllableDurations = [ syllableDurations currTotalDuration];

end

% load map table
fid = fopen('grapheme2METUphoneme','r');
graphemesAndPhonemes = textscan(fid, '%s %s', 'Delimiter', '\t');
fclose(fid);

% syllables to phonemes
[phonemesSequence, wordsSequence]  = syllables2phonemes(syllables, graphemesAndPhonemes);

% assign durations 
[ phonemes, phonemeDurations] = syllable2phonemeDurations(phonemesSequence, syllableDurations, graphemesAndPhonemes);


% add silence  padding  to transcript


phonemesSil = cell (1, size(phonemes,2) + 2);
phonemesSil{1} = 'sil';

for k=1:size(phonemes,2)
	phonemesSil{k+1} = phonemes{k};
end

phonemesSil{end} = 'sil';

phonemeDurations = [1 phonemeDurations  1];

end