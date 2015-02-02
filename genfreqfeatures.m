% Generates csv files, format:
%
% BIRDID,YYYY,MM,DD,HH,MM,SHIFTED,{FEATURES}
%
% Input variables are in seconds. The interval is the length in seconds to
% consider when generating frequency features. The t_skip variable is the amount of
% seconds to skip from each recordingfile. The t_length variable is the amount of
% seconds to use from each recordingfile. Finally, output_file is a string
% where the results will be written to.
% e.g. genfreqfeatures(1, 0, 24*3600, 'freq_1.csv')
%
% This function only generates a csv file with the pairs:
% Frequency, Intensity
% so that they can be used to find clusters.
function genfreqfeatures(interval, t_skip, t_length, output_file)
	SEC_IN_DAY = 24 * 60 * 60;
	samplerate = 8000;

	previous_dir = pwd;

	% match BIRDID_YYYYMMDD_recstartHHMM
	file_pattern = '.([a-zA-Z0-9])+_(\d{4})(\d{2})(\d{2})_recstart(\d{2})(\d{2}).*';
	fp_csv = fopen(output_file, 'w');

	cd('/media/kevin/DATA/vogel_audio/Recordings_fixed/');
	files = dir('*.wav');
	index = 1;
	files_length = length(files);

	for file = files'
		% Show progress...
		disp(['progress = ', num2str(index), '/', num2str(files_length)]);
		index = index + 1;

		%  Assume not shifted if filename contains NO_SHIFT
		%  and shifted otherwise
		shifted = isempty(strfind(file.name, 'NO_SHIFT'));
		file_name = regexp(file.name, file_pattern, 'tokens', 'once');

		% Compute features
		num_intervals = ceil(t_length / interval);

		% default NaN
		F = zeros(num_intervals, 2);
		t_start = t_skip + str2num(file_name{5}) * 60 * 60 + str2num(file_name{6}) * 60;

		fp_wav = fopen(file.name, 'r');

		% Advance file pointer to the data section
		while 1
			x = fread(fp_wav, 1, 'uint32', 0, 'b');
			if x == hex2dec('64617461') % data section
				break;
			end
		end

		% The first 4 bytes indicate the amount of bytes of data that follows (not needed).
		fread(fp_wav, 1, 'uint32', 0, 'l');

		% Skip to the t_skip
		if t_skip > 0
			fread(fp_wav, t_skip * samplerate, 'uint8', 'l');
		end

		should_stop = 0;

		for i=1:num_intervals
			data = (fread(fp_wav, interval * samplerate, 'uint8', 'l') - 128) ./ 128;

			if feof(fp_wav)
				data = data(data~=Inf);
				data = data(data~=NaN);
				should_stop = 1;
			end

			spectro = abs(spectrogram(data, 128, 120, 128, samplerate, 'yaxis'));

			% Select freq with highest intensity in this interval...
			[max_columnvalues, freq_colindexes] = max(spectro);
			[max_intensity, freq_col] = max(max_columnvalues);
			freq_row = freq_colindexes(freq_col);

			F(i, 1) = freq_row * (4000/65.0);
			F(i, 2) = max_intensity;
			fprintf(fp_csv, '%.5f, ', F(i, 1));
			fprintf(fp_csv, '%.5f\r\n', F(i, 2));

			if should_stop
				break;
			end

			t_start = t_start + interval;
		end

		fclose(fp_wav);
	end

	fclose(fp_csv);
	cd(previous_dir);

end
