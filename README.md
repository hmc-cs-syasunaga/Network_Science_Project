# Network_Science_Project
Repository for Network Science Class Project on Brain Computer Interface.\

# Reqirement
- The code was developed on Matlab 2016b. No gurantee for other versions.
- numpy
- sklearn
- scipy
- TODO: Neur182_ComputeEEGTimeFreq has shit ton of dependency...

# Dataset
You need to ask for the access to the data. 
http://www.eecs.qmul.ac.uk/mmv/datasets/deap/download.html

# How to use the code
- **Preprocessing**
- chose_trials
>   extract the data we care from the original EEG structure from DEAP dataset. We can choose trials based on the index (from 1 to 1280). 

- loop_eeg_struct
>Take output from chose_trials (chose_trials saves .mat file) and calculate wavelet of specified parameters. 
- Neur182_ComputeEEGTimeFreq


- data_exploration.m 
>extract data from the output of loop_eeg_struct and plot different graphs. Currently, I'm plotting the difference between participants, channels, frequency, trials, but it could be a lot more different. 

- **Classifier**
    * util
    >> Method to obtain the dataset
    * mat2python 
    >> Method to read the matlab file to numpy array


# References
