function genfeatures( interval, t_skip, t_length, feature_function, output_file )
% Generates csv files, format:
%
% BIRDID,YYYY,MM,DD,HH,MM,SHIFTED,{FEATURES}  
%
% e.g. genfeatures(60*6,0,24*60*60,@(x) mean(abs(x)),'data_6_avg.csv')
%
SEC_IN_DAY = 24*60*60;

samplerate = 8000;

% match BIRDID_YYYYMMDD_recstartHHMM
file_pattern = '.([a-zA-Z0-9])+_(\d{4})(\d{2})(\d{2})_recstart(\d{2})(\d{2}).*';

fp_csv = fopen(output_file, 'w');

files = dir('*.wav');
for file = files'
    
    %  Assume not shifted if filename contains NO_SHIFT
    %  and shifted otherwise
    shifted = isempty(strfind(file.name, 'NO_SHIFT'));

    file_name = regexp(file.name, file_pattern, 'tokens', 'once');
    
    display(file_name);

    fprintf(fp_csv, '%s', strjoin(file_name, ','));
    fprintf(fp_csv, ',%d,', shifted);
    
    % Compute features
    num_intervals = ceil(t_length / interval);
    F = zeros(1, num_intervals)/0; % default NaN
    t_start = t_skip + str2num(file_name{5})*60*60 + str2num(file_name{6})*60;
    display(t_start);
    
    fp_wav = fopen(file.name, 'r');
    
    % Advance file pointer to the data section
	while 1
	    x = fread(fp_wav, 1, 'uint32', 0, 'b');
	    if x == hex2dec('64617461') % data section
	        break
	    end
	end

	% The first 4 bytes indicate the amount of bytes of data that follows (not needed).
	fread(fp_wav, 1, 'uint32', 0, 'l');
    
    % Skip to the t_skip
	if t_skip > 0
		fread(fp_wav, t_skip * samplerate, 'uint8', 'l');
    end
    
	for i=1:num_intervals
        should_stop = 0;
        data = (fread(fp_wav, interval * samplerate, 'uint8', 'l') - 128) ./ 128;
        
        if feof(fp_wav)
            data = data(data~=Inf);
            data = data(data~=NaN);
            should_stop = 1;
        end
        
        
        % map t -> feature_index
        feature_index = 1 + mod(floor(t_start / interval) * interval, SEC_IN_DAY)/interval;
        F(feature_index) = feature_function(data);
        
        if should_stop
            break;
        end
        
        t_start = t_start + interval;        
        
    end
    
    
    for j=1:num_intervals-1
        fprintf(fp_csv, '%.5f,', F(j)); 
    end
    fprintf(fp_csv, '%.8f', F(end));
    
    
    fclose(fp_wav);
    
    fprintf(fp_csv, '\r\n');  

end

fclose(fp_csv);


end
