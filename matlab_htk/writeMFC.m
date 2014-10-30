function a = writeMFC(args)

URI_testFile_noExt = args.filename

mfcURI = [URI_testFile_noExt '.mfc'];

if ~exist(mfcURI)
	command =	['/usr/local/bin/HCopy' ' -A' ' -D' ' -T' ' 1' ' -C' [' /Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/input_files/' 'wav_config_singing '] [URI_testFile_noExt '.wav ']  mfcURI ];
	a = system(command);
end

addpath('matlab_htk')
[MFCCsAll, paramKind ]  = htkread( mfcURI  ); 	

mfcURITxt = [URI_testFile_noExt '.mfc'];
dlmwrite(mfcURITxt,MFCCsAll)

a  = 'file written'

end