%% loop_eeg_struct
% To loop through the eeg mat files
% 
clear
%% Main
% pat <- particip
file_path = '/Users/macbookpro/Documents/Network_Science_Data/data_preprocessed_matlab';

function_path = '/Users/macbookpro/Dropbox/College/6th Semester/Network Science/Project/Network_Science_Project';
addpath(function_path)
cd(file_path)
for pat = 1:32
    filename = sprintf('eeg%02d.mat',pat);
    data = load(filename);
    [trfOut,trfAdj] =...
        Neur182_ComputeEEGTimeFreq(data.data2,[1 60000],128);
    out_filename = sprintf('TRFDOut_Sel_ppt%02d',pat);
    adj_filename = sprintf('TRFDAdjMat_Sel_ppt%02d',pat);
    save(out_filename,'trfOut')
    save(adj_filename,'trfAdj')
end