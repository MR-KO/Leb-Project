function frs = batch_fft(cell_arr, fs, samp_size)

frs = zeros(1,length(cell_arr));

for i = 1:length(cell_arr)
    frs(i) = do_fft(cell_arr{i}, fs);
end