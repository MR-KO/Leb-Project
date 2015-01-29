spectro = function makeSpectro(audio, Fs)
    spectro = spectrogram(audio,128,120,128,8000,'yaxis');
    speccy = surf(abs(spectro));
    set(speccy, 'linestyle', 'none');
    title('Spectogram of bird chirp');
    xlabel('sample number (rate: 8k/sec)');
    ylabel('frequency (Hz)');
    zlabel('power');
end