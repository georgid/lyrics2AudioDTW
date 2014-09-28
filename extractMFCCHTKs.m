

%%%%% extract  mfcc from audio file: 
%%%%%%%%%%%%%%%%%%%%%%%%%

    % Clean-up MATLAB's environment

	function MFCCs = extractMFCCHTKs(audioFile_URI_noExt)
	
	% code from Merlijn Blaauw
    addpath('mfcc/');
	
    % Define variables
    Tw = 25;                % analysis frame duration (ms)
    Ts = 10;                % analysis frame shift (ms)
    alpha = 0.97;           % preemphasis coefficient
    M = 26;                 % number of filterbank channels 
    C = 12;                 % number of cepstral coefficients
    L = 22;                 % cepstral sine lifter parameter
    LF = 0;               % lower frequency limit (Hz)
    HF = 8000;              % upper frequency limit (Hz)
    wav_file = [audioFile_URI_noExt '.wav'];  % input audio filename


    % Read speech samples, sampling rate and precision from file
    [ audio, fs, nbits ] = wavread( wav_file );


    % Feature extraction (feature vectors as columns)
    [ MFCCs, FBEs, frames ] = ...
                    mfcc( audio(:,1), fs, Tw, Ts, alpha, @hamming, [LF HF], M, C+1, L );
	
% 	MFCCs = MFCCs(2:13, :);			
			
% TODO: write to file