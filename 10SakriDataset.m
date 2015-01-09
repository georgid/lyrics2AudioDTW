% extract features for 10-sarki dataset with synthesis:

path_URI = '/Users/joro/Documents/Phd/UPF/test_data_synthesis/'

% male: 
path_testFile = [path_URI  'nihavent--sarki--curcuna--kimseye_etmem--kemani_sarkis_efendi/03_Bekir_Unluataer_-_Kimseye_Etmem_Sikayet_Aglarim_Ben_Halime/']

path_testFile = [path_URI  'nihavent--sarki--aksak--koklasam_saclarini--artaki_candan/20_Koklasam_Saclarini/']

path_testFile = [path_URI  'nihavent--sarki--aksak--koklasam_saclarini--artaki_candan/2-15_Nihavend_Aksak_Sarki/']

path_testFile = [path_URI  'segah--sarki--curcuna--olmaz_ilac--haci_arif_bey/21_Recep_Birgit_-_Olmaz_Ilac_Sine-i_Sad_Pareme/']

path_testFile = [path_URI  'nihavent--sarki--aksak--gel_guzelim--faiz_kapanci/18_Munir_Nurettin_Selcuk_-_Gel_Guzelim_Camlicaya/']



% female: 

path_testFile = [path_URI  'huzzam--sarki--curcuna--kusade_taliim--sevki_bey/06_Kusade_Talihim/']

path_testFile = [path_URI  'muhayyerkurdi--sarki--duyek--ruzgar_soyluyor--sekip_ayhan_ozisik/1-05_Ruzgar_Soyluyor_Simdi_O_Yerlerde/']

path_testFile = [path_URI  'nihavent--sarki--aksak--bakmiyor_cesm-i--haci_arif_bey/04_Hamiyet_Yuceses_-_Bakmiyor_Cesm-i_Siyah_Feryade/']

path_testFile = [path_URI  'nihavent--sarki--turkaksagi--nerelerde_kaldin--ismail_hakki_efendi/3-12_Nerelerde_Kaldin/']

path_testFile = [path_URI  'ussak--sarki--duyek--aksam_oldu_huzunlendim--semahat_ozdenses/06_Semahat_Ozdenses_-_Aksam_Oldu_Huzunlendim/']





% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % TODO: put errors for all pieces into an array and take stats form all


%%%%%%%%%% extract features
addpath('matlab_htk')

list = {}
wavFiles = dir(fullfile(path_testFile, '*_from_*.wav'))

for ind = 1: length(wavFiles)
	[a,nameNoExt,c] = fileparts(wavFiles(ind).name)
	list{end + 1} = fullfile(path_testFile, nameNoExt);	
end

list = list';

for i= 1:size(list)
args.filename = list{i};
writeMFC(args);
end
