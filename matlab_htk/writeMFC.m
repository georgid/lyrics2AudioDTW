function MFCCs = writeMFC(args)

URI_testFile_noExt = args.filename
hasDeltas = 1
MFCCs = readMFCC_extractedWithHTK(URI_testFile_noExt, hasDeltas);

mfcURITxt = [URI_testFile_noExt '.mfc_txt'];
dlmwrite(mfcURITxt, MFCCs);


end