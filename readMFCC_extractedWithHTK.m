function MFCCs = readMFCC_extractedWithHTK(URI_testFile_noExt, hasDeltas, startFrame, endFrame)
%%%%%%% load htk-extraced mfcc files: 
addpath('matlab_htk'); % for htkread.m
addpath('../matlab_htk'); % for htkread.m

mfcURI = [URI_testFile_noExt '.mfc'];

if ~exist(mfcURI)
	command =	['/usr/local/bin/HCopy' ' -A' ' -D' ' -T' ' 1' ' -C' [' /Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/input_files/' 'wav_config_singing '] [URI_testFile_noExt '.wav ']  mfcURI ];
	a = system(command);
end


[MFCCsAll, paramKind ]  = htkread( mfcURI  );
fprintf('param kind: %s', paramKind);

if startFrame ~= 0 && endFrame ~= 0
	MFCCsAll = MFCCsAll(startFrame:endFrame,:);
end

% 13 is energy
MFCCs = MFCCsAll( :, 1:12);

% DEBUG: deltas
if hasDeltas
	MFCCsDeltas = MFCCsAll( :, 14:26);
	MFCCs = horzcat(MFCCs, MFCCsDeltas )	;
end
 % END DEBUG	
