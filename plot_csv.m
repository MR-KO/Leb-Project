% Plots the csv generated by genfeatures.m


dataset = csvread('data_6_avg.csv');

shifted = dataset(dataset(:,7) == 1, :);
not_shifted = dataset(dataset(:,7) == 0, :);

n = size(not_shifted,1);
for i=1:n
subplot(n, 1, i);
plot(not_shifted(i,8:end));

end
