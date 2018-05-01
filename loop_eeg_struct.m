%% loop_eeg_struct
% To loop through the eeg mat files
% To produce bin files and adjacency matrix. 

clear
%% Main
% pat <- particip
% file_path path to the folder where you have the data
file_path = '/Users/macbookpro/Documents/Network_Science_Data/data_preprocessed_matlab';

%% Path that this file is, or, where you put Neur182_ComputeEEGTimeFreq
function_path = '/Users/macbookpro/Dropbox/College/6th Semester/Network Science/Project/Network_Science_Project/Preprocessing';
addpath(function_path)

cd(file_path) % cding to the data path

%% Main Loop
% It is saving the data to the same folder as data
% If you want to, you can change the out_filename and adj_filename
% to store it in a different folder, but it doesn't worth, I guess. 
for pat = 17:32
    filename = sprintf('eeg%02d.mat',pat);
    data = load(filename);
    [trfOut,trfAdj] =...
        Neur182_ComputeEEGTimeFreq(data.data2,[1 60000],128); % You can change the parameters 
    out_filename = sprintf('TRFDOut_Sel_ppt%02d',pat);
    adj_filename = sprintf('TRFDAdjMat_Sel_ppt%02d',pat);
    save(out_filename,'trfOut')
    save(adj_filename,'trfAdj')
end