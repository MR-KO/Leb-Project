function dominant = do_fft(x,fs)

% Derived from Mathworks documentation on Fast Fourier Transforms

m = length(x);      % Window length
n = pow2(nextpow2(m));  % Transform length
y = fft(x,n);       % DFT of signal
f = (0:n-1)*(fs/n);  % Frequency range
p = y.*conj(y)/n;       % Power of the DFT

[mx, i] = max(p(1:floor(n/2)));
dominant = f(i);
