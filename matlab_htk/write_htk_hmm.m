function write_htk_hmm(filename, hmms, gopt, tied_states)
    % [hmm, gopt, tied_states] = write_htk_hmm(filename, hmms, gopt, tied_states)
    %
    % mblaauw 2014
    % - global options support
    % - tied states support
    % - input is container.Map()s
    
    if nargin < 3
        gopt = [];
    end
    
    if nargin < 4 || isempty(tied_states)
        tied_states = containers.Map();
    end
    
    fid = fopen(filename, 'wt');
    
    % global options ~o:
    writeGlobalOptions(fid, gopt);
    
    % tied states ~s:
    tied_stateslist = keys(tied_states);
    for i=1:length(tied_stateslist)
        name = tied_stateslist{i};
        fprintf(fid, '~s "%s"\n', escapeQuotedString(name));
        writeState(fid, tied_states(name));
    end
    
    % logical hmm ~h:
    modellist = keys(hmms);
    for i=1:length(modellist)
        name = modellist{i};
        writeHmm(fid, hmms(name));
    end
    
    fclose(fid);
end

% -------------------------------------------------------------------------

% gopt.paramkind
% gopt.durkind
% gopt.covkind
% gopt.vecsize
% gopt.nstreams
% gopt.streamsizes
function writeGlobalOptions(fid, gopt)
    if isempty(gopt)
        return;
    end
    
    fprintf(fid, '~o\n');
    
    if gopt.nstreams > 1
        fprintf(fid, '<STREAMINFO> %d ', gopt.nstreams);
        for i=1:gopt.nstreams
            if i == gopt.nstreams
                fprintf(fid, '%d\n', gopt.streamsizes(i));
            else
                fprintf(fid, '%d ', gopt.streamsizes(i));
            end
        end
    end
    
    fprintf(fid, '<VECSIZE> %d', gopt.vecsize);
    fprintf(fid, '<%s>', gopt.durkind);
    fprintf(fid, '<%s>', gopt.paramkind);
    fprintf(fid, '<%s>', gopt.covkind);
    fprintf(fid, '\n');
end

% -------------------------------------------------------------------------

% hmm.name
% hmm.nstates
% hmm.gmms
% hmm.start_prob
% hmm.transmat
% hmm.end_prob
function writeHmm(fid, hmm)
    fprintf(fid, '~h "%s"\n', escapeQuotedString(hmm.name));

    % begin tag
    fprintf(fid, '<BEGINHMM>\n');
    
    % states
    nstates = hmm.nstates + 2;
    fprintf(fid, '<NUMSTATES> %d\n', nstates);

    for i=2:nstates-1
        fprintf(fid, '<STATE> %d\n', i);
        
        writeState(fid, hmm.gmms(i-1));
    end
    
    % transition matrix
    transmat = zeros(nstates, nstates);
    transmat(1, (2:1+hmm.nstates)) = exp(hmm.start_prob);
    transmat((2:1+hmm.nstates), (2:1+hmm.nstates)) = exp(hmm.transmat);
    transmat((2:1+hmm.nstates), end) = exp(hmm.end_prob);
    
    fprintf(fid, '<TRANSP> %d\n', nstates);
    for i=1:nstates
        for j=1:nstates
            fprintf(fid, ' %.6e', transmat(i, j));
        end
        fprintf(fid, '\n');
    end    
    
    % end tag
    fprintf(fid, '<ENDHMM>\n');
end

% -------------------------------------------------------------------------

% state.tie_name	name of tied state (empty string if state isn't tied)
% state.nmix		1 for Gaussian, > 1 for GMM
% state.priors		1-x-nmix log priors (mixture weights)
% state.means		nfeat-x-nmix means
% state.covars		nfeat-x-nmix diagonal covariances
% state.gconst      log likelihood constant
function writeState(fid, state)
    if ~strcmp(state.tie_name, '')
        fprintf(fid, '~s "%s"\n', escapeQuotedString(state.tie_name));
    else
        % nmix
        if state.nmix > 1
            fprintf(fid, '<NUMMIXES> %d\n', state.nmix);
        end
        
        % mixture components
        for i=1:state.nmix        
            % mixture
            if state.nmix > 1
                fprintf(fid, '<MIXTURE> %d %.6e\n', i, exp(state.priors(i)));
            end

            % means
            means = state.means(:, i);
            nmeans = size(means, 1);
            
            fprintf(fid, '<MEAN> %d\n', nmeans);
            for j=1:nmeans
                fprintf(fid, ' %.6e', means(j));                
            end
            fprintf(fid, '\n');

            % variances
            variances = state.covars(:, i);
            nvariances = size(variances, 1);

            fprintf(fid, '<VARIANCE> %d\n', nvariances);
            for j=1:nvariances
                fprintf(fid, ' %.6e', variances(j));                
            end
            fprintf(fid, '\n');
            
            % gconst
            if ~isempty(state.gconst)
                fprintf(fid, '<GCONST> %.6e\n', state.gconst(i));
            end
        end
    end
end

