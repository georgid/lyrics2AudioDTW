function [ data, paramKind, sampPeriod ] = htkread( filename, nativeReadOrder )
% [ data, paramKind, sampPeriod ] = htkread( filename, nativeReadOrder )
%
% Read data from possibly compressed HTK format file.
%
% filename (string) - Name of the file to read from
% data (nSamp x NUMCOFS) - Output data array
% paramKind - paramKind describing file contents
% sampPeriod - sample period in 100ns units
%
% Compression is handled using the algorithm in 5.10 of the HTKBook.
% CRC is not implemented.
%
% Mark Hasegawa-Johnson
% July 3, 2002
% Based on function mfcc_read written by Alexis Bernard
%
% Merlijn Blaauw
% March, 2014
% - added option to use native read order
% - added sampPeriod output
% - renamed some variables for clarity and consistency
% - changed paramKind to unsigned 16 bit integer (else _T didn't work)

if nargin < 2
	nativeReadOrder = 0;
end

byteOrderFlag = 'b';
if nativeReadOrder
	byteOrderFlag = 'n';
end
fid=fopen(filename,'r',byteOrderFlag);
if fid<0,
    error(sprintf('Unable to read from file %s',filename));
end

% Read number of frames
nSamples = fread(fid,1,'int32');

% Read sampPeriod
sampPeriod = fread(fid,1,'int32');

% Read sampSize
sampSize = fread(fid,1,'int16');

% Read paramKind
paramKind = fread(fid,1,'uint16');

%%%%%%%%%%%%%%%%%
% Read the data
if bitget(paramKind, 11),
    DIM=sampSize/2;
    nSamples = nSamples-4;
    %disp(sprintf('htkread: Reading %d frames, dim %d, compressed, from %s',nSamples,DIM,filename)); 

    % Read the compression parameters
    A = fread(fid,[1 DIM],'float');
    B = fread(fid,[1 DIM],'float');
    
    % Read and uncompress the data
    data = fread(fid, [DIM nSamples], 'int16')';
    data = (repmat(B, [nSamples 1]) + data) ./ repmat(A, [nSamples 1]);

    
else
    DIM=sampSize/4;
    %disp(sprintf('htkread: Reading %d frames, dim %d, uncompressed, from %s',nSamples,DIM,filename)); 

    % If not compressed: Read floating point data
    data = fread(fid, [DIM nSamples], 'float')';
end

fclose(fid);
