function [hmms, gopt, tied_states] = read_htk_hmm(filename)
    % [hmms, gopt, tied_states] = read_htk_hmm(filename)
    %
    % Loosely based on code by Ron J. Weiss
    %
    % mblaauw, March-April 2014
    % - unified structure of mixture Gaussian (GMM) and Gaussian output probability density functions
    % - added code to read tied states (tied states are copied to all instances)
    % - added code to read header fields (global options)
    % - changed outputs to container.Map()s (for both hmms and tied_states)
    % - some minor cleanups of code

    [fid, message] = fopen(filename, 'rt');
    warning(message);
    file = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '', 'bufSize', 16000);
    fclose(fid);

    file = file{1};
    file = file(cellfun(@length, file) > 0); % remove empty lines
    
    hmms = containers.Map();
    tied_states = containers.Map();

    x = 1;
    while x <= length(file)
        % global options ~o
        if (length(file{x}) >= 2 && strcmp(file{x}(1:2), '~o'))
            [gopt, x] = readGlobalOptions(file, x);
            if ~strcmp(gopt.covkind, 'DIAGC')
                fprintf(1, 'only diagonal covariances are supported');
                return;
            end
        % tied state ~s
        elseif (length(file{x}) >= 2 && strcmp(file{x}(1:2), '~s'))
            c = strread(file{x}, '~s %q');
            tie_name = unescapeQuotedString(c{1});
            x = x + 1;
            
            [state, x] = readState(file, x, []);
            tied_states(tie_name) = state;
        % logical hmm ~h
        elseif (length(file{x}) >= 2 && strcmp(file{x}(1:2), '~h')) || ~isempty(findstr(upper(file{x}), '<BEGINHMM>'))
            [hmm, x] = readHmm(file, x, tied_states);
            hmms(hmm.name) = hmm;
        % not supported
        else
            fprintf(1, 'skipping line "%s"\n', file{x});
            x = x + 1;
        end
	end
end

% -------------------------------------------------------------------------

% gopt.paramkind
% gopt.durkind
% gopt.covkind
% gopt.vecsize
% gopt.nstreams
% gopt.streamsizes
function [gopt, x] = readGlobalOptions(file, linenum)
    % defaults
    gopt.paramkind = 'MFCC_0';
    gopt.durkind = 'NULLD';
    gopt.covkind = 'DIAGC';
    gopt.vecsize = 12;
    gopt.nstreams = 1;
    gopt.streamsizes = [gopt.vecsize];
    
    x = linenum;
    x = x+1; % skip ~o
    while x < length(file)
        if ~isempty(findstr(file{x}, '~'))
            break;
        end
        
        fields = textscan(upper(file{x}), '%s', 'Delimiter', '<>');
        fields = fields{1};
        fields(cellfun(@isempty, fields)) = []; % remove empty fields
        
        fidx = 1;
        while fidx <= length(fields)
            field = fields{fidx};
            
            % streaminfo
            if strcmp(field, 'STREAMINFO')
                field_data = textscan(fields{fidx+1}, '%d');
                field_data = field_data{1};
                
                gopt.nstreams = field_data(1);
                gopt.streamsizes = field_data(2:end);
                fidx = fidx + 2;
                continue;
            end
            
            % vecsize
            if strcmp(field, 'VECSIZE')
                field_data = textscan(fields{fidx+1}, '%d');
                field_data = field_data{1};

                gopt.vecsize = field_data(1);
                fidx = fidx + 2;
                continue;
            end  
           
            % durkind
            if strcmp(field, 'NULLD')       gopt.durkind = field; end
            if strcmp(field, 'POISSOND')    gopt.durkind = field; end
            if strcmp(field, 'GAMMAD')      gopt.durkind = field; end
            if strcmp(field, 'GEND')        gopt.durkind = field; end
            
            % paramkind
            if ~isempty(strfind(field, 'DISCRETE'))     gopt.paramkind = field; end
            if ~isempty(strfind(field, 'LPC'))          gopt.paramkind = field; end
            if ~isempty(strfind(field, 'LPCEPSTRA'))	gopt.paramkind = field; end
            if ~isempty(strfind(field, 'MFCC'))         gopt.paramkind = field; end
            if ~isempty(strfind(field, 'FBANK'))        gopt.paramkind = field; end
            if ~isempty(strfind(field, 'MELSPEC'))      gopt.paramkind = field; end
            if ~isempty(strfind(field, 'LPREFC'))       gopt.paramkind = field; end
            if ~isempty(strfind(field, 'LPDELCEP'))     gopt.paramkind = field; end
            if ~isempty(strfind(field, 'USER'))         gopt.paramkind = field; end

            % covkind
            if strcmp(field, 'DIAGC')       gopt.covkind = field; end
            if strcmp(field, 'INVDIAGC')    gopt.covkind = field; end
            if strcmp(field, 'FULLC')       gopt.covkind = field; end
            if strcmp(field, 'LLTC')        gopt.covkind = field; end
            if strcmp(field, 'XFORMC')      gopt.covkind = field; end
            
            fidx = fidx + 1;
        end
               
        x = x + 1;
    end
end

% -------------------------------------------------------------------------

% hmm.name
% hmm.nstates
% hmm.gmms
% hmm.start_prob
% hmm.transmat
% hmm.end_prob
function [hmm, x] = readHmm(file, linenum, tied_states)

    % ~h "name"
    x = linenum;
    if ~isempty(findstr(file{x}, '~h'))
        c = strread(file{x}, '~h %q');
        hmm.name = unescapeQuotedString(c{1});
        x = x + 1;
    else
        hmm.name = 'UNDEFINED';
    end
    
    % <BEGINHMM>
    x = x + 1;
    
    % <NUMSTATES> nstates
    hmm.nstates = strread(upper(file{x}), '<NUMSTATES> %d')-2;
    x = x + 1;

    % read all states (except first and last non-emitting states)
    for sidx=1:hmm.nstates
        if ~isempty(findstr(upper(file{x}), '<TRANSP>'))
            fprintf(1, 'unexpected end of state sequence\n');
            break;
        end
                
        % <STATE> sidx
        index = strread(upper(file{x}), '<STATE> %d') - 1; % skip first non-emitting state
        x = x + 1;

        [state, x] = readState(file, x, tied_states);
        
        if index ~= sidx
            fprintf(1, 'unexpected state index\n');
        end
        
        hmm.gmms(sidx) = state;
    end % end state loop 

    % <TRANSP> nstates
    nstates = strread(upper(file{x}), '<TRANSP> %d'); 
    x = x + 1;

    % read nstates x nstates transition matrix
    transmat = zeros(nstates);
    for n = 1:nstates
      transmat(n,:) = strread(file{x}, '%f', nstates);
      x = x + 1;
    end
    
    % store results
    w = warning('query', 'MATLAB:log:logOfZero');
    if strcmp(w.state, 'on')
      warning('off', 'MATLAB:log:logOfZero');
    end
    hmm.start_prob = log(transmat(1,2:end-1));
    hmm.transmat = log(transmat(2:end-1,2:end-1));
    hmm.end_prob = log(transmat(2:end-1,end));
    warning(w.state, w.identifier);

    % end tag
    if ~isempty(findstr(upper(file{x}), '<ENDHMM>'))
      x = x + 1;
    end
end


% -------------------------------------------------------------------------

% state.tie_name	name of tied state (empty string if state isn't tied)
% state.nmix		1 for Gaussian, > 1 for GMM
% state.priors		1-x-nmix log priors (mixture weights)
% state.means		nfeat-x-nmix means
% state.covars		nfeat-x-nmix diagonal covariances
% state.gconst      log likelihood constant
function [state, x] = readState(file, linenum, tied_states)
    x = linenum;
    
    % tied state
    if ~isempty(findstr(file{x}, '~s "'))
        c = strread(file{x}, '~s %q');
        tie_name = unescapeQuotedString(c{1});

        % look-up data in dictionary and make copy:
        state = tied_states(tie_name);

        x = x + 1;
    % normal (non-tied) state
    else
        state.tie_name = '';
        
        % GMM: <NUMMIXTURES> nmix
        if ~isempty(findstr(upper(file{x}), '<NUMMIXES>'))
            nmix = strread(upper(file{x}), '<NUMMIXES> %d');
            x = x + 1;
        % GAUSSIAN: (nothing)
        else
            nmix = 1;
        end 

        state.nmix = nmix;
        state.priors(1:nmix) = log(0); % defunct mixture component
        
        state.gconst(1:nmix) = 0;
        
        for n=1:nmix
            % GMM: <MIXTURE> midx prior
            if nmix > 1
                if isempty(findstr(upper(file{x}), '<MIXTURE>'))
                    % HTK doesn't write defunct mixture components
                    % (i.e. those whose prior is below some threshold)
                    % so we may have less than nmix <MIXTURE> tags
                    break;
                end

                [midx, prior] = strread(upper(file{x}), '<MIXTURE> %d %f');
                x = x + 1;
                
                state.priors(midx) = log(prior);
            else
                midx = 1;
                state.priors(midx) = log(1);
            end

            % <MEAN> nfeat
            nfeat = strread(upper(file{x}), '<MEAN> %d');
            x = x + 1;

            % (GMM: allocate matrices for means and variances before handing first mixture, but after knowing number of features)
            if n == 1 && nmix > 1
                state.means(1:nfeat, 1:nmix) = 0;
                state.covars(1:nfeat, 1:nmix) = 1;
            end

            % read nfeat means
            state.means(:, midx) = strread(file{x}, '%f', nfeat);
            x = x + 1;

            % <VARIANCE> nfeat
            nfeat = strread(upper(file{x}), '<VARIANCE> %d');
            x = x + 1;

            % read nfeat variances (diagonal)
            state.covars(:, midx) = strread(file{x}, '%f', nfeat);
            x = x + 1;

            % <GCONST> gconst [optional]
            if ~isempty(findstr(upper(file{x}), '<GCONST>'))
                gconst = strread(upper(file{x}), '<GCONST> %f');
                x = x + 1;
                
                state.gconst(midx) = gconst;
            end
        end % end mixture component loop
    end % end tied/normal state
end

