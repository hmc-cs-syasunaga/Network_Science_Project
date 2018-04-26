numfiles = 32;

for k = 1:9
  myfilename = sprintf('s0%d.mat', k);
  data = load(myfilename, 'data');
  data=data.data(:,1:32,:);
  data2=permute(data,[2,3,1]);
  myfilename2 = sprintf('eeg0%d.mat', k);
  save(myfilename2,'data2')
end
for k = 10:32
  myfilename = sprintf('s%d.mat', k);
  data = load(myfilename, 'data');
  data=data.data(:,1:32,:);
  data2=permute(data,[2,3,1]);
  myfilename2 = sprintf('eeg0%d.mat', k);
  save(myfilename2,'data2')
end
