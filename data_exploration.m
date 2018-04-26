
%% Make nicely formatted data 
%% 
pat_list = []

for pat = 1:32 % For each participants
    bin_list = []
    filename = sprintf('TRFDWHATEVER TODO')
    load(filename,'data')
    chan_list = []
    for chan = 1:32 % For each channel
        bins = data.AllTrialsTFPowerBins; %TODO: change according to the structure
        freq_list = [];
        for f = 1:5
            freq_list = [freq_list average(bins(f,:,:),3)];
        end
        
        chan_list = [chan_list freq_list];
    end
    pat_list = [pat_list chan_list];
end


%% Do plottng work with pat _list
