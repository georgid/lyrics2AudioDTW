
path_testFile = '/Users/joro/Documents/Phd/UPF/adaptation_data_soloVoice/ISTANBUL/'
pathToModels = '/Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/interim_files/'
pathToScores = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/'


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % TODO: put errors for all pieces into an array and take stats form all



% goekhan - kimseye

URI_score = [pathToScores 'nihavent--sarki--curcuna--kimseye_etmem--kemani_sarkis_efendi'];


URI_testFile_noExt  = [path_testFile  'goekhan/02_Kimseye_3_zemin'];

URI_testFile_noExt  = [path_testFile  '/goekhan/02_Kimseye_5_nakarat'];

URI_testFile_noExt  = [path_testFile  'goekhan/02_Kimseye_6_nakarat'];

URI_testFile_noExt  = [path_testFile  'goekhan/02_Kimseye_7_meyan'];
URI_testFile_noExt  = [path_testFile  'goekhan/02_Kimseye_8_meyan'];

URI_testFile_noExt  = [path_testFile  '/goekhan/02_Kimseye_9_nakarat'];

% goekhan - gel 
URI_score = [pathToScores 'nihavent--sarki--aksak--gel_guzelim--faiz_kapanci/'];

URI_testFile_noExt  = [path_testFile  'goekhan/02_Gel_3_zemin'];
URI_testFile_noExt  = [path_testFile  'goekhan/02_Gel_5_nakarat'];
URI_testFile_noExt  = [path_testFile  'goekhan/02_Gel_6_nakarat2'];


URI_testFile_noExt  = [path_testFile  'goekhan/02_Gel_7_meyan'];
URI_testFile_noExt  = [path_testFile  'goekhan/02_Gel_8_meyan2'];


URI_testFile_noExt  = [path_testFile  'goekhan/02_Gel_9_nakarat'];


% barbaros - gel guezelim
URI_score = [pathToScores 'nihavent--sarki--aksak--gel_guzelim--faiz_kapanci/'];

URI_testFile_noExt  = [path_testFile  'barbaros/02_Gel_3_zemin'];
URI_testFile_noExt  = [path_testFile  'barbaros/02_Gel_5_nakarat'];

URI_testFile_noExt  = [path_testFile  'barbaros/02_Gel_7_meyan'];

URI_testFile_noExt  = [path_testFile  'barbaros/02_Gel_10_nakarat2beforeGazel'];


URI_testFile_noExt  = [path_testFile  'barbaros/02_Gel_10_nakarat2'];


% barbaros - koklasam

URI_score = [pathToScores 'nihavent--sarki--aksak--koklasam_saclarini--artaki_candan/'];

URI_testFile_noExt  = [path_testFile  'barbaros/02_Koklasam_4_zemin'];

URI_testFile_noExt  = [path_testFile  'barbaros/02_Koklasam_7_meyan'];

URI_testFile_noExt  = [path_testFile  'barbaros/02_Koklasam_9_nakarat'];



% safiye - aksam

URI_score = [pathToScores 'ussak--sarki--duyek--aksam_oldu_huzunlendim--semahat_ozdenses'];

URI_testFile_noExt = [path_testFile '/safiye/01_Aksam_1_zemin'];
URI_testFile_noExt = [path_testFile '/safiye/01_Aksam_3_nakarat'];
URI_testFile_noExt = [path_testFile '/safiye/01_Aksam_4_nakarat2']; 
URI_testFile_noExt = [path_testFile '/safiye/01_Aksam_5_meyan']; 
URI_testFile_noExt = [path_testFile '/safiye/01_Aksam_6_meyan2']; 
URI_testFile_noExt = [path_testFile '/safiye/01_Aksam_7_nakarat']; 
URI_testFile_noExt = [path_testFile '/safiye/01_Aksam_8_nakarat3']; 

% safiye = bakmiyor

URI_score = [pathToScores 'nihavent--sarki--aksak--bakmiyor_cesm-i--haci_arif_bey'];

URI_testFile_noExt = [path_testFile '/safiye/01_Bakmiyor_1_zemin'];
URI_testFile_noExt = [path_testFile '/safiye/01_Bakmiyor_2_zemin'];
URI_testFile_noExt = [path_testFile '/safiye/01_Bakmiyor_3_nakarat']; 
URI_testFile_noExt = [path_testFile '/safiye/01_Bakmiyor_4_nakarat2']; 
URI_testFile_noExt = [path_testFile '/safiye/01_Bakmiyor_5_meyan']; 
URI_testFile_noExt = [path_testFile '/safiye/01_Bakmiyor_6_nakarat3']; 
URI_testFile_noExt = [path_testFile '/safiye/01_Bakmiyor_7_nakarat2']; 


list = {[path_testFile '/safiye/01_Bakmiyor_1_zemin'];
[path_testFile '/safiye/01_Bakmiyor_2_zemin']
[path_testFile '/safiye/01_Bakmiyor_3_nakarat'],
[path_testFile '/safiye/01_Bakmiyor_4_nakarat2'], 
[path_testFile '/safiye/01_Bakmiyor_5_meyan'], 
[path_testFile '/safiye/01_Bakmiyor_6_nakarat3'], 
[path_testFile '/safiye/01_Bakmiyor_7_nakarat2'] } 




% guelen- aksam

URI_score = [pathToScores 'ussak--sarki--duyek--aksam_oldu_huzunlendim--semahat_ozdenses'];

URI_testFile_noExt = [path_testFile '/guelen/01_Aksam_1_zemin'];
URI_testFile_noExt = [path_testFile '/guelen/01_Aksam_3_nakarat'];
URI_testFile_noExt = [path_testFile '/guelen/01_Aksam_4_nakarat2']; 
URI_testFile_noExt = [path_testFile '/guelen/01_Aksam_5_meyan']; 
URI_testFile_noExt = [path_testFile '/guelen/01_Aksam_6_meyan2']; 
URI_testFile_noExt = [path_testFile '/guelen/01_Aksam_7_nakarat']; 
URI_testFile_noExt = [path_testFile '/guelen/01_Aksam_8_nakarat3']; 




% guelen - olmaz
URI_score = [pathToScores 'segah--sarki--curcuna--olmaz_ilac--haci_arif_bey'];

URI_testFile_noExt = [path_testFile  '/guelen/01_Olmaz_3_zemin'];


URI_testFile_noExt = [path_testFile  '/guelen/01_Olmaz_4_zemin2'];

URI_testFile_noExt = [path_testFile  'guelen/01_Olmaz_5_nakarat'];

URI_testFile_noExt = [path_testFile  'guelen/01_Olmaz_6_nakarat2'];


URI_testFile_noExt = [path_testFile  'guelen/01_Olmaz_7_meyan'];


URI_testFile_noExt = [path_testFile  'guelen/01_Olmaz_8_meyan2'];

URI_testFile_noExt = [path_testFile  'guelen/01_Olmaz_14_zemin2'];

URI_testFile_noExt = [path_testFile  'guelen/01_Olmaz_15_nakarat'];

URI_testFile_noExt = [path_testFile  'guelen/01_Olmaz_16_nakarat2'];

URI_testFile_noExt = [path_testFile  'guelen/01_Olmaz_17_meyan'];






% guelcin - bu aksam - not used.  sections tsv should be done
URI_testFile_noExt = [path_testFile  'guelcin/bu_aksam_part1_zemin'];

URI_score = '/Users/joro/Documents/Phd/UPF/adaptation_data_soloVoice/ISTANBUL/guelcin/ussak--sarki--aksak--bu_aksam_gun--tatyos_efendi.txt';
