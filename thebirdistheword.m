SAMPLES_SECOND = 8000;
SAMPLES_MINUTE = 60*SAMPLES_SECOND;
SAMPLES_HOUR = 60*SAMPLES_MINUTE;

SCALE = SAMPLES_SECOND;

source = 'B123_20140710_recstart1936_NO_SHIFT_small.wav';

amount = 24*60*60;
t_start = 1;
t_end = SAMPLES_SECOND;


fp = fopen(source, 'r');

while 1
    x = fread(fp, 1, 'uint32', 0, 'b');
    if x == hex2dec('64617461') % data section
        break
    end
end

fread(fp, 1, 'uint32', 0, 'l'); % skip 4 bytes


Y = zeros(1, amount);

for i=1:amount
    y = (fread(fp, SAMPLES_SECOND, 'uint8', 'l') - 128)./(128);

    Y(1,i) = sum(abs(y)) / amount;%resample(y, 1, SCALE);
end


fclose(fp);



