function [TRFDOut,TRFDAdjMat] = Neur182_ComputeEEGTimeFreq(InMat,epochtimelimits,Fs,varargin);
% Function accepts a 3D time domain matrix (Signal x Time x Event) and returns
% the following:
% 1.    InMat: A 4D matrix of temporally localized power
%       (Frequency x Time x Event x Signal)
% 2.    epochtimelimits: [beg end], the time limits of your epoch,
%       including baseline
% 3.    Fs in Hz, sampling rate of the data
% 4.    varargin, specified here with defaults (see newtimef):
%       Morlet_cycles = [1 0.5];
%       detrend 'off'
%       rmerp 'off'
%       maxfreq 45
%       freqlimits [4 45]
%       freqscale 'log'
%       wletmethod 'dftfilt3' (Morlet wavelets)
%       baseline [-200 0]
%       trialbase 'full' (How to do baseline correction)
%       alpha '0.005' (for bootstrap significance)
%       naccu 500 (number of bootstraps)
%       freqbins {[4 8],[8 13],[14 16],[16 20],[20 30],[30 45]}
%       timebins {[50 100],[100 150],[150 200],[200 250],[250 300],[300 350],[350 400],[400 450]}
%       max_xcov_lag 200 (milliseconds lag for xcov, for TFPow connectivity)
%       cov_cutoff 0.4 (minimum cross-covariance for establishing a putative connection
%       num_sds 1 (number of standard devs for thresholding Adjacency Matrix)
%       frac_trials 0.25 (the frac of trials that need to have a LINK in order to count as having a stable link)

%Check to see that the input matrix is 3D
sizeout = size(InMat);
if(length(sizeout) ~= 3)
    error('Input matrix must be 3D (Signal x Time x Event)');
elseif(sizeout(3) == 1)
    error('Input matrix must be 3D (Signal x Time x Event)');
end

if(isempty(epochtimelimits))
    error('Please specify the time limits of the epochs');
end
if(isempty(Fs))
    error('Please specify the sampling rate')
end

nsigs = size(InMat,1);
ntrials = size(InMat,3);

% Use an input parser function as specified in Matlab
persistent ipp
if isempty(ipp)
    ipp = inputParser;
    ipp.PartialMatching = 0;
    ipp.addParameter('Morlet_cycles',[8 0.5]);
    ipp.addParameter('detrend','off');
    ipp.addParameter('rmerp','off');
    ipp.addParameter('maxfreq',45);
    ipp.addParameter('freqlimits',[4 45]);
    ipp.addParameter('baseline',[0]);
    ipp.addParameter('trialbase','full');
    ipp.addParameter('wletmethod','dftfilt3');
    ipp.addParameter('alpha',0.005);
    ipp.addParameter('naccu',500);
    ipp.addParameter('freqbins',{[4 8],[8 13],[14 16],[16 20],[20 25]});
    ipp.addParameter('timebins',{[0 5000],[5000 10000],[10000 15000],[15000 20000],[20000 25000],[25000 30000],[30000 35000],[35000 40000],[40000 45000],[45000 50000],[50000 55000],[55000 60000]});
    ipp.addParameter('max_xcov_lag',200);
    ipp.addParameter('cov_cutoff',0.4);
    ipp.addParameter('num_sds',1);
    ipp.addParameter('frac_trials',0.25);
end

parse(ipp,varargin{:});

epoch_beg = round((epochtimelimits(1)/1000)*Fs);
epoch_end = round((epochtimelimits(2)/1000)*Fs);
frames = length(epoch_beg:epoch_end);

% To bin the Power results
timebins = ipp.Results.timebins;
freqbins = ipp.Results.freqbins;
ntimebins = length(timebins);
nfreqbins = length(freqbins);
AllTrialsTFPowerBins = zeros(nfreqbins,...
    ntimebins,...
    size(InMat,3));
for fbin_num = 1:nfreqbins
    fbin_central(fbin_num) = mean(freqbins{fbin_num});
end
for tbin_num = 1:ntimebins
    tbin_central(tbin_num) = mean(timebins{tbin_num});
end
max_xcov_lag = ipp.Results.max_xcov_lag; %milliseconds
max_xcov_lag_pts = round((max_xcov_lag/1000)*Fs);

progressbar(0,0);
progressbar('TD Signals...','Frequency Bins...');

for sig_num = 1:nsigs
   
    this_sig_mat = squeeze(InMat(sig_num,:,:));
    % Use EEGLAB newtimef with Morlet wavelets
    [ERSP,...
        ITC,...
        ERSP_Baseline,...
        timevec,...
        freqvec,...
        ERSPBootstrap,...
        ITCBootstrap,...
        AllTrialsTFComplex,...
        AllTrialsTFPower] = newtimef(this_sig_mat,...
        frames,...
        epochtimelimits,...
        Fs,...
        ipp.Results.Morlet_cycles,...
        'alpha',ipp.Results.alpha,...
        'baseline',ipp.Results.baseline,...
        'detrend',ipp.Results.detrend,...
        'freqs',ipp.Results.freqlimits,...
        'maxfreq',ipp.Results.maxfreq,...
        'wletmethod',ipp.Results.wletmethod,...
        'plotersp','off',...
        'plotitc','off');
        
    % Bin the Power Analyses for each trial
    for fbin = 1:nfreqbins
        
        this_freqbin = freqbins{fbin};
        freq_start = max(find(freqvec <= this_freqbin(1)));
        freq_end = max(find(freqvec <= this_freqbin(2)));
                
        for tbin = 1:ntimebins
            
            this_timebin = timebins{tbin};
            time_start = max(find(timevec <= this_timebin(1)));
            time_end = max(find(timevec <= this_timebin(2)));
            
            A1 = AllTrialsTFPower(freq_start:freq_end,...
                time_start:time_end,:);
            A2 = reshape(A1,size(A1,1)*size(A1,2),size(A1,3));
            AllTrialsTFPowerBins(fbin,tbin,:) = median(A2,1);
            
        end %end over tbin
        
        progressbar([],fbin/nfreqbins)
        pause(0);

    end %end over fbin            
            
    TFPowerMat(:,:,:,sig_num) = AllTrialsTFPower;
    
   %TRFDOut(sig_num).ERSP = ERSP;
   %TRFDOut(sig_num).ITC = ITC;
   %TRFDOut(sig_num).ERSP_Baseline = ERSP_Baseline;
   %TRFDOut(sig_num).timevec = timevec;
   %TRFDOut(sig_num).freqvec = freqvec;
   %TRFDOut(sig_num).ERSPBootstrap = ERSPBootstrap;
   %TRFDOut(sig_num).ITCBootstrap = ITCBootstrap;
   %TRFDOut(sig_num).AllTrialsTFComplex = AllTrialsTFComplex;
   %TRFDOut(sig_num).AllTrialsTFPower = AllTrialsTFPower;
   %TRFDOut(sig_num).freqbins = fbin_central;
   %TRFDOut(sig_num).timebins = tbin_central;
    TRFDOut(sig_num).AllTrialsTFPowerBins = AllTrialsTFPowerBins;
    
    progressbar(sig_num/nsigs,[]);
    
end % end over sig_num

% Connectivity from temporally localized power
% Use the cross-covariance and Spearman correlation
nfreqs = length(freqvec);
progressbar(0);
progressbar('Estimating FD Power Connectivity by Cross Covariance...');
ntrials = size(TFPowerMat,3);
for freq_num = 1:nfreqs
    
    for trial_num = 1:ntrials
        
        A1 = squeeze(TFPowerMat(freq_num,:,trial_num,:));
%         A2 = zeros(size(A1));
%         for sig_num = 1:size(A1,2)
%             A2(:,sig_num) = tiedrank(A1(:,sig_num));
%         end
        [c,clags] = xcov(A1,max_xcov_lag_pts,'coeff');
        
        % Adjaceny Matrix
        tempmat1 = reshape(max(c,[],1),nsigs,nsigs); %Take the maximal value across all lags
        tempmat1(tempmat1 > 0.99999999) = 0; %No self loops
        AdjMat(:,:,trial_num,freq_num) = tempmat1;
        
        % Link Matrix
        tempmat2 = tempmat1;
        tempmat2(tempmat2 == 0) = NaN;
        tempmat3 = ((tempmat2 >= (nanmean(tempmat2(:)) + (ipp.Results.num_sds * nanstd(tempmat2(:))))) & ...
            (tempmat2 >= ipp.Results.cov_cutoff));
        LinkMat(:,:,trial_num,freq_num) = tempmat3;
        
    end %end over trials
    
    % Average over trials
    A = squeeze(AdjMat(:,:,:,freq_num));
    B = atanh(A); % Fisher Z transform
    AvgAdjMat(:,:,freq_num) = tanh(median(B,3)); % Median, then back from Z to r
    MaxLinkMat(:,:,freq_num) = sum(LinkMat(:,:,:,freq_num),3) >= (ipp.Results.frac_trials*ntrials);
    
    progressbar(freq_num/nfreqs)
    pause(0);
end %end over freq_num

AcrossFreqAvgAdjMat = max(AvgAdjMat,[],3);
AcrossFreqMaxLinkMat = max(MaxLinkMat,[],3);

TRFDAdjMat.freqvec = freqvec;
TRFDAdjMat.AdjMat = AdjMat;
TRFDAdjMat.AvgAdjMat = AvgAdjMat;
TRFDAdjMat.AcrossFreqAvgAdjMat = AcrossFreqAvgAdjMat;
TRFDAdjMat.LinkMat = LinkMat;
TRFDAdjMat.MaxLinkMat = MaxLinkMat;
TRFDAdjMat.AcrossFreqMaxLinkMat = AcrossFreqMaxLinkMat;
