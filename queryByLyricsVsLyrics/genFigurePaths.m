% put vertical lines for sakin Gec kalma in distance matrix. hard coded

URI_score = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/ussak--sarki--aksak--bu_aksam_gun--tatyos_efendi/' ;
URI_wholeAudio_noExt = '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma';
SECTION_NUM = 2
doitSDTWParams(URI_score, URI_wholeAudio_noExt, SECTION_NUM)

hold on;
numFramesPerSec = 100

startTs = 25.231985
endTs = 33.767787
vline(startTs*numFramesPerSec, 'r');
vline(endTs*numFramesPerSec, 'r');

startTs = 112.125237
endTs = 121.031249
vline(startTs*numFramesPerSec, 'r');
vline(endTs*numFramesPerSec, 'r');

% segments

startTs = 24.931985
endTs = 38.18
vline(startTs*numFramesPerSec, 'w');
vline(endTs*numFramesPerSec, 'w');


startTs = 43.84
endTs = 56.18
vline(startTs*numFramesPerSec, 'w');
vline(endTs*numFramesPerSec, 'w');


startTs = 84.88
endTs = 92.27
vline(startTs*numFramesPerSec, 'w');
vline(endTs*numFramesPerSec, 'w');

startTs = 100.9
endTs = 121.3
vline(startTs*numFramesPerSec, 'w');
vline(endTs*numFramesPerSec, 'w');

startTs = 110.0
endTs = 109.2
vline(startTs*numFramesPerSec, 'w');
vline(endTs*numFramesPerSec, 'w');