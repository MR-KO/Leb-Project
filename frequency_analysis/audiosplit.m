% This function splits and audio file into equal parts sized 'samp_size'.
%
% samp_size = size of resulting smales in seconds
% fs = sample rate of audio source
% x = audio waveform

function splitted = audiosplit(x, fs, samp_size)

samples = round(samp_size * fs);

nwhole = floor(length(x) / samples);
extrasamples = rem(length(x), samples);

if extrasamples == 0
    splitted = mat2cell(x,[repmat(samples,1,nwhole)],[1]);
else
    splitted = mat2cell(x,[repmat(samples,1,nwhole) extrasamples],[1]);
end
end