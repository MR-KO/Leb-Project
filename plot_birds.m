function plot_birds(filename)
    data = csvread(filename);
    n = size(data(:,8:end),2);
    
	U = unique(data(:, 1));
    
    for i=1:size(U,1)
       bird_data = data(data(:,1) == U(i,1), :);
       
       % add time
       X = [];
       t = datenum([2000, 1, 1, 0, 0, 0]);
       interval = (24 * 60 * 60) / n

        for j=1:n
            X(j) = t;
            t = addtodate(t, interval, 'second');
        end
        
        figure;
        
        for j=1:size(bird_data, 1)
           subplot(size(bird_data, 1), 1, j);
           plot(X, bird_data(j, 8:end));
           legend(strcat(num2str(bird_data(j, 7)), '.', num2str(bird_data(j, 1)), '...', num2str(bird_data(j, 4))));
           datetick('x', 'HH');
           ylim([0, 0.03]);
        end        
        
    end

end