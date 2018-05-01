%% Features
% 

clear

% file_path path to the folder where you have the data
file_path = '/Users/macbookpro/Documents/Network_Science_Data/data_preprocessed_matlab';
cd(file_path)

full_list=[]; % (chan,time,freq,trials)
i_counter = 0; % index counter
for pat = 1:32 % For each participants %TODO: fix pat with more data
    filename = sprintf('TRFDOut_Sel_ppt%02d.mat',pat);
    field = sprintf('trfOut');
    data  = load(filename);
    data = data.(field);
    chan_list = []; % (chan, time, freq, trials)
    
    for chan = 1:32 % For each channel
        bins = data(chan).AllTrialsTFPowerBins;
        chan_list(chan,:,:,:) = bins(:,2:end,:);
    end
    if isempty(full_list)
        full_list = chan_list;
    else
        full_list= cat(4,full_list, chan_list); 
    end
end

% size(permute(full_list, [4,2,3,1])) % Sanity Check

full_list  = permute(full_list, [4,2,3,1]);

save('X_high','full_list'); % TODO: Change here according to what you want to call the data

