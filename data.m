
path_testFile = '/Users/joro/Documents/Phd/UPF/ISTANBUL/'

path_testFile = [path_testFile 'guelcin']

path_testFile = '/Users/joro/Documents/Phd/UPF/arias/';


pathToModels = '/Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/interim_files/'
pathToScores = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/'

wavFiles = dir(fullfile(path_testFile, '*.wav'))

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % TODO: put errors for all pieces into an array and take stats form all


%%%%%%%%%% extract features
addpath('matlab_htk')

list = {}
% wavFiles = dir(fullfile(path_testFile, '*_from_*.wav'))
wavFiles = dir(fullfile(path_testFile, '*.wav'))

for ind = 1: length(wavFiles)
	[a,nameNoExt,c] = fileparts(wavFiles(ind).name)
	list{end + 1} = fullfile(path_testFile, nameNoExt);	
end

list = list';

for i= 1:size(list)
args.filename = list{i};
writeMFC(args);
end
%%%%%%%%%%%%%%%%%%%%%




%##########%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% DEFINE file manually: 

% idil - kimseye

URI_score = [pathToScores 'nihavent--sarki--curcuna--kimseye_etmem--kemani_sarkis_efendi'];
URI_wholeAudio_noExt = '/Users/joro/Documents/Phd/UPF//ISTANBUL//idil/Melihat_Gulses';

%%%%goekhan - kimseye

URI_score = [pathToScores 'nihavent--sarki--curcuna--kimseye_etmem--kemani_sarkis_efendi'];
URI_wholeAudio_noExt = '/Users/joro/Documents/Phd/UPF//ISTANBUL//goekhan/';


list  = { [path_testFile  'goekhan/02_Kimseye_3_zemin'],

[path_testFile  '/goekhan/02_Kimseye_5_nakarat'],

[path_testFile  'goekhan/02_Kimseye_6_nakarat'],

[path_testFile  'goekhan/02_Kimseye_7_meyan'],
[path_testFile  'goekhan/02_Kimseye_8_meyan'],
[path_testFile  '/goekhan/02_Kimseye_9_nakarat']
}


% goekhan - gel 

URI_score = [pathToScores 'nihavent--sarki--aksak--gel_guzelim--faiz_kapanci/'];

list = {
[path_testFile  'goekhan/02_Gel_3_zemin'],
[path_testFile  'goekhan/02_Gel_5_nakarat'],
[path_testFile  'goekhan/02_Gel_6_nakarat2'],

[path_testFile  'goekhan/02_Gel_7_meyan'],
[path_testFile  'goekhan/02_Gel_8_meyan2'],

[path_testFile  'goekhan/02_Gel_9_nakarat']
}

% barbaros - gel guezelim
URI_score = [pathToScores 'nihavent--sarki--aksak--gel_guzelim--faiz_kapanci/'];

list = { [path_testFile  'barbaros/02_Gel_3_zemin'],
[path_testFile  'barbaros/02_Gel_5_nakarat'],

[path_testFile  'barbaros/02_Gel_7_meyan'],

[path_testFile  'barbaros/02_Gel_10_nakarat2beforeGazel'],

[path_testFile  'barbaros/02_Gel_10_nakarat2']
}


% barbaros - koklasam

URI_score = [pathToScores 'nihavent--sarki--aksak--koklasam_saclarini--artaki_candan/'];

list  = {[path_testFile  'barbaros/02_Koklasam_4_zemin'],

[path_testFile  'barbaros/02_Koklasam_7_meyan'],

[path_testFile  'barbaros/02_Koklasam_9_nakarat']
}



% safiye - aksam

URI_score = [pathToScores 'ussak--sarki--duyek--aksam_oldu_huzunlendim--semahat_ozdenses'];

list = { [path_testFile '/safiye/01_Aksam_1_zemin'],
[path_testFile '/safiye/01_Aksam_3_nakarat'],
[path_testFile '/safiye/01_Aksam_4_nakarat2'], 
[path_testFile '/safiye/01_Aksam_5_meyan'], 
[path_testFile '/safiye/01_Aksam_6_meyan2'], 
[path_testFile '/safiye/01_Aksam_7_nakarat'], 
[path_testFile '/safiye/01_Aksam_8_nakarat3']
}


% safiye = bakmiyor

URI_score = [pathToScores 'nihavent--sarki--aksak--bakmiyor_cesm-i--haci_arif_bey'];

list = { [path_testFile '/safiye/01_Bakmiyor_1_zemin'],
[path_testFile '/safiye/01_Bakmiyor_2_zemin'],
[path_testFile '/safiye/01_Bakmiyor_3_nakarat'], 
[path_testFile '/safiye/01_Bakmiyor_4_nakarat2'], 
[path_testFile '/safiye/01_Bakmiyor_5_meyan'],
[path_testFile '/safiye/01_Bakmiyor_6_nakarat3'], 
[path_testFile '/safiye/01_Bakmiyor_7_nakarat2']
}





% guelen- aksam

URI_score = [pathToScores 'ussak--sarki--duyek--aksam_oldu_huzunlendim--semahat_ozdenses'];

list= { [path_testFile '/guelen/01_Aksam_1_zemin'],
 [path_testFile '/guelen/01_Aksam_3_nakarat'],
[path_testFile '/guelen/01_Aksam_4_nakarat2'], 
[path_testFile '/guelen/01_Aksam_5_meyan'],
[path_testFile '/guelen/01_Aksam_6_meyan2'], 
[path_testFile '/guelen/01_Aksam_7_nakarat'], 
[path_testFile '/guelen/01_Aksam_8_nakarat3']
}




% guelen - olmaz
URI_score = [pathToScores 'segah--sarki--curcuna--olmaz_ilac--haci_arif_bey'];

list = { [path_testFile  '/guelen/01_Olmaz_3_zemin'],


[path_testFile  '/guelen/01_Olmaz_4_zemin2'],

[path_testFile  'guelen/01_Olmaz_5_nakarat'],

[path_testFile  'guelen/01_Olmaz_6_nakarat2'],


[path_testFile  'guelen/01_Olmaz_7_meyan'],


[path_testFile  'guelen/01_Olmaz_8_meyan2'],

[path_testFile  'guelen/01_Olmaz_14_zemin2'],

[path_testFile  'guelen/01_Olmaz_15_nakarat'],

[path_testFile  'guelen/01_Olmaz_16_nakarat2'],

[path_testFile  'guelen/01_Olmaz_17_meyan']
}






% guelcin - bu aksam - not used.  sections tsv should be done
URI_testFile_noExt = [path_testFile  'guelcin/bu_aksam_part1_zemin'];

URI_score = '/Users/joro/Documents/Phd/UPF/adaptation_data_soloVoice/ISTANBUL/guelcin/ussak--sarki--aksak--bu_aksam_gun--tatyos_efendi.txt';
