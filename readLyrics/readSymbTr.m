function [noteSymbols, durations, lyrics, offset, other] = readSymbTr(...
    path, interval, version, encoding, theoryName, ignoreRests)
%READSYMBTR read a symbTr text file. 
% original code from https://github.com/sertansenturk/fragmentLinker. Edits are marked by %%%% EDIT
%
% INPUTS
% path: path of the symbTr file
% note_format: format of the note, possible values: 'Nota53' for 53 tone
%   equal temperament and 'NotaAEU' for Arel-Ezgi-Uzdilek theory
% verbose: parameter to display the read file
%
% OUTPUT
% notes: cell of strings holding the note names
% durations: double array holding the duration of each note (unit: ms)
% other: struct holding the other parameters for each note
% NoteNames: cell of strings holding the unique note names in the "notes"
%   output

%% check the input parameters

%%%% EDIT
% make sure matlab can handle UTF-8
feature('DefaultCharacterSet', 'UTF8');


theoryList = {'53-TET', 'AEU'}; % 53-TET and Arel-Ezgi(-Uzdilek) theory
mappingStr = {'Nota53', 'NotaAE'}; % how the 53-TET or AEU theory columns
% indicated in the symbTr scores

if ~exist('version', 'var') || isempty(version)
    version = 'symbTr_v2_txt';
end

if ~exist('encoding', 'var') || isempty(encoding)
    switch version
        case {'symbTr_v1','symbTr_v1_bolum','symbTr_v1_mus2beta'}
%%%% EDIT
			%             encoding = 'ISO-8859-9';
			encoding = 'UTF-8';
        case {'symbTr_v2', 'symbTr_v2_txt'}
            encoding = 'UTF-8';
        case {'symbTr_v2_xml', 'symbTr_xml'}
            error('TODO')
        case 'generic'
            % pass, read with MATLAB default
        otherwise
            error('readSymbTr:version', 'Unknown symbTr version')
    end
end

if ~exist('theoryName', 'var')
    theoryName = '53-TET';
elseif ~any(strcmpi(theoryName, theoryList))
    error('readSymbTr:wrongNoteType', ...
        'the note type should be either "53-TET" or "AEU"')
end

if ~exist('ignoreRests', 'var')
    ignoreRests = false;
end

if ~exist('interval', 'var')
    interval = [];
end

theory_ind = strcmpi(theoryName, theoryList);
theoryName = mappingStr{theory_ind};

%% read symbTr file
switch version
    case 'symbTr_v1' % symbTr_v1
        [vals, fields] = readSymbTr_v1(path, encoding);
    case {'symbTr_v2', 'symbTr_v2_txt'} % SymbTr_v2
        [vals, fields] = readSymbTr_v2(path, encoding);
    case 'generic'
        [vals, fields] = readSymbTr_generic(path);
    case {'symbTr_v2_xml', 'symbTr_xml'}
        error('TODO')
    otherwise
        error('readSymbTr:version', 'Unknown symbTr version')
end

% get the values in the interval
if ~isempty(interval)
    vals = cellfun(@(x) x(interval(1):interval(2)), vals, 'unif', false);
end

%% noteSymbols
noteSymbols = vals{strcmp(fields, theoryName)};

%%%% EDIT. instead of class
REST_NAME = {'Rest', 'rest', 'Es', 'es'};

% handle rests
restBool = ismember(noteSymbols, REST_NAME );
[noteSymbols{restBool}] = deal(REST_NAME);
if ignoreRests
    restInd = find(restBool);
    restInd = restInd(restInd > 1); % let any rest in the start stay as is
    
    for ii = 1:numel(restInd)
        % if it is after an indicator row, e.g. phrase start do not change
        % the value
        if ismember(noteSymbols{restInd(ii)-1}, {'', '    '})
            % rests are shown as -1 in SymbTr, make them -1
            vals{5}(restInd(ii)) = nan; % Koma fields
            vals{6}(restInd(ii)) = nan;
        else
            noteSymbols{restInd(ii)} = noteSymbols{restInd(ii)-1}; %symbols
            vals{3}(restInd(ii)) = vals{4}(restInd(ii)-1); % Nota fields
            vals{3}(restInd(ii)) = vals{4}(restInd(ii)-1);
            vals{5}(restInd(ii)) = vals{5}(restInd(ii)-1); % Koma fields
            vals{6}(restInd(ii)) = vals{6}(restInd(ii)-1);
        end
    end
else % rests are shown as -1 in SymbTr, make them -1
    vals{5}(restBool) = nan; % Koma fields
    vals{6}(restBool) = nan;
end


%% durations

%%%% EDIT
% instead in time, duration in num of 16-th notes
% durations = struct('Value',vals{strcmp(fields,'Ms')}*0.001,'Unit','sec');

smallestUnitDuration = 16.0; 

durations = struct('Value',double(vals{strcmp(fields,'Pay') }) ./ double(vals{strcmp(fields,'Payda') }) * smallestUnitDuration,'Unit','sec');


%% lyrics
lyrics = vals{strcmp(fields, 'Soz1')};

%% offset
offset = vals{strcmp(fields, 'Offset')};

%% other fields
if nargout > 4
    for k = 1:length(fields)
        if ~strcmp(fields{k}, {'Ms', 'Soz', 'Offset'})
            other.(fields{k}) = vals{k};
        end
    end
end
end

%% %%%%%%%%%%%%%%%%%%%% read SymbTr v1 text file %%%%%%%%%%%%%%%%%%%%%%%%%%
%%% - the SymbTr_v1 in the CompMusic site http://compmusic.upf.edu/node/140
%%%     has 'S?z-1' for the lyrics
%%% - Mus2 beta version has 'Soz1'
%%% - It can read the customized version with the section column prepared
%%%     for (Senturk et al., 2014)
function [vals, fields_clean] = readSymbTr_v1(path, encoding)
fields = {['S' char(305) 'ra'], 'Kod', 'Nota53', 'NotaAE', 'Koma53', 'KomaAE', 'Pay',...
    'Payda', 'Ms', 'LNS', 'VelOn', ['S' char(246) 'z-1']};

%%%% EDIT

% fields = {'Sira', 'Kod', 'Nota53', 'NotaAE', 'Koma53', 'KomaAE', 'Pay',...
%     'Payda', 'Ms', 'LNS', 'VelOn', 'Soz-1'};

% this will be the output
fields_clean = {'Sira', 'Kod', 'Nota53', 'NotaAE', 'Koma53', 'KomaAE', ...
    'Pay', 'Payda', 'Ms', 'LNS', 'VelOn', 'Soz1', 'Offset'};

% read the file
[fid, reason ]= fopen(path, 'r', 'native', encoding);
headers = strread(fgetl(fid), '%s', 'delimiter', '\t'); % read the header
vals = textscan(fid,'%d %d %s %s %f %f %d %d %f %d %d %s','Delimiter','\t');
[~] = fclose(fid);

% check the number of columns
if numel(headers) ~= numel(fields)
    error('readSymbTr_v1:numFields', ['Wrong number of columns in the '...
        'SymbTr_v1 txt file'])
end

% check the header names
unmatched = ~strcmpi(headers', fields);
if any(unmatched)
    if any(find(unmatched) ~= 12) % 12 = S?z-1 column
        error(['Unknown SymbTr_v1 column(s): ' ...
            strjoin(headers(unmatched), ', ')])
    elseif ~strcmp(headers{12}, 'Soz1') % symbTr_v1_mus2_beta
        error(['Unknown SymbTr_v1 lyrics column: ' headers{12}])
    end
end

% the number of elements are not same
if range(cellfun(@length, vals)) ~= 0
    error('Missing elements in the SymbTr_v1 txt file.')
end

% add the missing offset column; which is all nans (missing info)
vals{end+1} = nan(size(vals{end}));
end

%% %%%%%%%%%%%%%%%%%%%% read SymbTr v2 text file %%%%%%%%%%%%%%%%%%%%%%%%%%
function [vals, fields] = readSymbTr_v2(path, encoding)
fields = {'Sira', 'Kod', 'Nota53', 'NotaAE', 'Koma53', 'KomaAE', 'Pay',...
    'Payda', 'Ms', 'LNS', 'Bas', 'Soz1', 'Offset'}; % v2 does not have
% Turkish characters

% read the file
fid = fopen(path, 'r', 'native', encoding);
headers = strsplit(fgetl(fid), '\t'); % read the header
vals = textscan(fid,'%d %d %s %s %f %f %d %d %f %d %d %s %f', ...
    'Delimiter', '\t');
[~] = fclose(fid);

% check the number of columns
if numel(headers) ~= numel(fields)
    error('readSymbTr_v2:numFields', ['Wrong number of columns in the '...
        'SymbTr_v2 txt file'])
end

% check the header names, ignore case
unmatched = ~strcmpi(headers, fields);
if any(unmatched)
    error(['Unknown SymbTr_v2 column(s): ' strjoin(headers(unmatched),...
        ', ')])
end

% make sure the number of elements at each column are the same
if range(cellfun(@length, vals)) ~= 0
    error('Missing elements in the SymbTr_v2 txt file.')
end
end

%% %%%%%%%%%%%%%%%%%%%% read generic SymbTr file %%%%%%%%%%%%%%%%%%%%%%%%%%
function [vals, fields] = readSymbTr_generic(path)

% read the file
vals = tdfread(path, '\t');
fields = fieldnames(vals);
vals = struct2cell(vals);

% convert char fields to cell of string
charBool = cellfun(@ischar, vals);
vals(charBool) = cellfun(@cellstr, vals(charBool), 'unif', false);

% Check the fields
fields{ismember(fields,{'Sira',['S' char(305) 'ra'],['S' '0xFD' 'ra']})}...
    ='Sira';
fields{strcmpi(fields, 'Ms')} = 'Ms';
fields{ismember(lower(fields),lower({'S' char(246) 'z-1', 'Soz1',...
    ['S' '0xF6' 'z' '0x2D' '1']}))} = 'Soz1';
offsetBool = strcmpi(fields, 'Offset');
if any(offsetBool)
    fields{offsetBool} = 'Offset';
else
    vals{end+1} = nan(size(vals{end}));
    fields{end+1} = 'Offset';
end

% make sure the number of elements at each column are the same
if range(cellfun(@length, vals)) ~= 0
    error('readSymbTr:shape', 'Missing elements in the SymbTr txt file.')
end
end