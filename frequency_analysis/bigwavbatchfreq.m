function frs = bigwavbatchfreq(file, chunksize, sampsize)

siz = wavread(file, 'size')
wholechunks = round(siz(1) / chunksize)
remchunks = rem(siz(1), chunksize)

frs = [];
start = 1;

% do batch frequency calculation for all whole chunks
for i = 1:wholechunks
    [x,fs] = wavread(file, [start, start + (chunksize - 1)]);
    cells = audiosplit(x,fs,sampsize);
    frs = [frs, batch_fft(cells, fs, sampsize)];
    start = start + chunksize;
end

if remchunks ~= 0
    % add the frequency for the remainder of the chunks
    [x,fs] = wavread(file, [start, start + remchunks - 1]);
    cells = audiosplit(x,fs,sampsize);
    frs = [frs, batch_fft(cells, fs, sampsize)];
end

    