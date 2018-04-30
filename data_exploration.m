
clear

%% Make nicely formatted data 
pat_list = []; %(pat,chan, time, freq)

% data_folder = '/Users/macbookpro/Documents/Network_Science_Data/data_preprocessed_matlab';
% cd(data_folder)


for pat = 32 % For each participants %TODO: fix pat with more data
    filename = sprintf('TRFDOut_AllPowerBins_ppt%02d.mat',pat);
    field = sprintf('TRFDOut_AllPowerBins_ppt%02d',pat);
    data  = load(filename);
    data = data.(field);
    chan_list = []; % (chan, time, freq)
    for chan = 1:32 % For each channel
        bins = cell2mat(data(chan));
        disp(size(bins))
        freq_list = []; % (time, freq);
        for f = 1:5
            freq_list(:,f) =  mean(bins(f,2:end,:),2);
            disp(size(freq_list))
        end
        chan_list(chan,:,:) = freq_list;
    end
    pat_list(1,:,:,:) = chan_list; %TODO: fix here wth more data... pat_list(pat,:,:,:) = chan_list;
end


%% Plot participant variance
% --> Do we need to normalize??
% 
figure(1)
plot(mean(mean(mean(pat_list,2),3),4))
title('participants')

%% Plot channel Variance
% 
figure(2)
values = mean(mean(mean(pat_list,1),3),4);
values = reshape(values,[1,size(values,2)]);
plot(values)
title('channels')

%% Plot Frequency Variance
figure(3)
values = mean(mean(mean(pat_list,1),2),3);
values = reshape(values,[1,size(values,4)]);
plot(values)
title('frequencies')
%% Plot trials variance
figure(4)
values = mean(mean(mean(pat_list,1),2),4);
values = reshape(values,[1,size(values,3)]);
plot(values)
title('Times')