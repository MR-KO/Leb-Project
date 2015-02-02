% Function that returns a spectrogram of a given audio sample vector.
% Fs is the samplerate, for our converted data it is simply 8000.
% Outputs a 3D plot showing the spectrogram.
function spectro = makeSpectro(audio, Fs)
	spectro = spectrogram(audio,128,120,128,8000,'yaxis');
	speccy = surf(abs(spectro));
	set(speccy, 'linestyle', 'none');
	title('Spectogram of bird chirp');
	xlabel('sample number (rate: 8k/sec)');
	ylabel('frequency (Hz)');
	zlabel('power');
end
