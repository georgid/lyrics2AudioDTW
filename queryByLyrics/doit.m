URI_targetFile_noExt = '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma'
URI_phonemes = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/ussak--sarki--aksak--bu_aksam_gun--tatyos_efendi/tmp.phn'
URI_durations = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/ussak--sarki--aksak--bu_aksam_gun--tatyos_efendi/tmp.dur'

[simMatrix, listPhonemesWithStates] = calcSimMatrix(URI_targetFile_noExt, URI_phonemes, URI_durations );

fromFrameTs = 23.6 * 100;
toFrameTs = 61 * 100;
[costMatrix, pathXs, pathYs] = searchDTW(URI_targetFile_noExt, simMatrix, listPhonemesWithStates, fromFrameTs, toFrameTs);
 
visLAST(costMatrix, URI_targetFile_noExt, listPhonemesWithStates, pathXs, pathYs)
 
 