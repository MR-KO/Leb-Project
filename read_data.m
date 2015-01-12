% Reads in the data from the given filename/filepath, and returns the wave data.
% The interval is the amount of seconds to use when calculating the mean.
% t_skip is the time in seconds to skip, and t_length is the time in seconds
% to use after t_skip, so we can skip some of the start and end of the file.
function wave_data = read_data(filename, interval, t_skip, t_length)
	% The sample rate for our files is 8000
	samplerate = 8000;

	% Interval in seconds (or SAMPLES/SCALE), aka the amount of samples we read

	fp = fopen(filename, 'r');

	% Advance file pointer to the data section
	while 1
	    x = fread(fp, 1, 'uint32', 0, 'b');
	    if x == hex2dec('64617461') % data section
	        break
	    end
	end

	% The first 4 bytes indicate the amount of bytes of data that follows (not needed).
	fread(fp, 1, 'uint32', 0, 'l');

	% Skip to the t_skip
	if t_skip > 0
		fread(fp, t_skip * samplerate, 'uint8', 'l');
	end

	% Read in the wave data
	num_intervals = round(t_length / interval);

	if t_length / interval - num_intervals >= 0.5
		num_intervals = num_intervals + 1;
	end

	wave_data = zeros(1, num_intervals);
	should_stop = 0;

	for i=1:num_intervals
	    data = (fread(fp, interval * samplerate, 'uint8', 'l') - 128) ./ (128);

	    % Test for end of file, ignore Inf and NaN values.
	    if feof(fp) == 1
	    	data = data(data ~= Inf);
	    	data = data(data ~= NaN);
	    	should_stop = 1;
	    end

	    % Get our features
	    wave_data(1, i) = mean(abs(data));

	    if should_stop == 1
	    	break;
	    end
	end

	fclose(fp);
end