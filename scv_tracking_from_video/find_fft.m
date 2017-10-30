%% Setting up
temp_bottom = load('C:\Users\Loki\OneDrive\UCL\PhD{MRes}_thesis\Matlab\cases\Case_4\2017-03-07_132008-16351247_bottom.txt');
temp_top = load('C:\Users\Loki\OneDrive\UCL\PhD{MRes}_thesis\Matlab\cases\Case_4\2017-03-07_132008-16351247_top.txt');
temp_bottom2 = load('C:\Users\Loki\OneDrive\UCL\PhD{MRes}_thesis\Matlab\cases\Case_4\2017-03-07_132143-16351248_bottom.txt');
temp_top2 = load('C:\Users\Loki\OneDrive\UCL\PhD{MRes}_thesis\Matlab\cases\Case_4\2017-03-07_132143-16351248_top.txt');

Fs = 25;              % Sampling frequency
T = 1/Fs;             % Sampling period
L = length(temp_top); % Length of signal
L2 = length(temp_top2); % Length of signal
t = (0:L-1)*T;        % Time vector
t2 = (0:L2-1)*T;        % Time vector

x1 = temp_bottom(1:L, 2);
x2 = temp_top(1:L, 2);
x3 = temp_bottom2(1:L2, 2);
x4 = temp_top2(1:L2, 2);
x1 = x1 - mean(x1);
x2 = x2 - mean(x2);
x3 = x3 - mean(x3);
x4 = x4 - mean(x4);

%% PSD/FFT 
% figure (1)
% plot(t,x)
% axis('tight')
% grid('on')
% title('Time series')

nfft = 512; % next larger power of 2
y1 = fft(x1,nfft); % Fast Fourier Transform
y2 = fft(x2,nfft); % Fast Fourier Transform
y3 = fft(x3,nfft); % Fast Fourier Transform
y4 = fft(x4,nfft); % Fast Fourier Transform
y = (y1+y2+y3+y4)/4;
y = abs(y.^2); % raw power spectrum density
y = y(1:1+nfft/2); % half-spectrum
[v,k] = max(y); % find maximum
f_scale = (0:nfft/2)* Fs/nfft; % frequency scale

figure (2)
plot(f_scale(1:25), y(1:25),'-r+')
axis('tight')
grid('on')
title('Frequency analysis')
xlabel('Frequency (Hz)')

f_est = f_scale(k); % dominant frequency estimate
fprintf('Dominant freq.: estimated %f Hznn', f_est)
fprintf('\nFrequency step (resolution) = %f Hznn\n', f_scale(2))
