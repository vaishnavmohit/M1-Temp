%%
clc
clear all
close all
%Practical No 6-7
%Filter Design:
%1. Filtering
fc = 0.3;
fs = pi;

figure()
[b,a] = butter(3,fc,'low');
[H,w]= freqz(b,a);
subplot(2,2,1)
plot(w/pi,abs(H))
title('Low Pass')

[b,a] = butter(3,fc,'high');
[H,w]= freqz(b,a);
subplot(2,2,2)
plot(w/pi,abs(H))
title('High Pass')

[b,a] = butter(3,[.3 .6]);
[H,w]= freqz(b,a);
subplot(2,2,3)
plot(w/pi,abs(H))
title('Band Pass [.3 .6]')

[b,a] = butter(3,[.3 .6],'stop');
[H,w]= freqz(b,a);
subplot(2,2,4)
plot(w/pi,abs(H))
title('Band Stop [.3 .6]')

%%
%For Chebychev Filter:

figure()
[b,a] = cheby1(3,0.8,fc);
subplot(2,2,1)
[H,w]= freqz(b,a);
subplot(2,2,1)
plot(w/pi,abs(H))
title('Low Pass')

[b,a] = cheby1(3,.8,fc,'high');
[H,w]= freqz(b,a);
subplot(2,2,2)
plot(w/pi,abs(H))
title('High Pass')

[b,a] = cheby1(3,.8,[.3 .6]);
[H,w]= freqz(b,a);
subplot(2,2,3)
plot(w/pi,abs(H))
title('Band Pass [.3 .6]')

[b,a] = cheby1(3,.8,[.3 .6],'stop');
[H,w]= freqz(b,a);
subplot(2,2,4)
plot(w/pi,abs(H))
title('Band Stop [.3 .6]')

%%
%Increasing the order of the filter looking at the response of Bandpass
%filter:

figure()
[b,a] = butter(3,fc,'low');
[H,w]= freqz(b,a);
subplot(2,2,1)
plot(w/pi,abs(H))
title('Low Pass order 3')

[b,a] = butter(5,fc,'low');
subplot(2,2,2)
[H,w]= freqz(b,a);
plot(w/pi,abs(H))
title('Low Pass order 5')

[b,a] = butter(10,fc,'low');
subplot(2,2,3)
[H,w]= freqz(b,a);
plot(w/pi,abs(H))
title('Low Pass order 10')

[b,a] = butter(20,fc,'low');
[H,w]= freqz(b,a);
subplot(2,2,4)
plot(w/pi,abs(H))
title('Low Pass order 20')

%with increasing order the slope of the graph keeps on decreasing.
%%
%Design filter to remove the noise;
f = 500;
Fs = 50000;
samp_t=1/50000;
n=0:samp_t:5*(1/f);
s = sin(2*pi*f*n);
figure()
subplot(4,1,1)
plot(s);
title('Input Sine Signal')

% Adding white gaussian noise to the signal:
y = awgn(s,0);
%plotting the signal
subplot(4,1,2)
plot(y)
title('Input signal when added with White Gaussian noise')

[b, a] = butter(7,.05,'low');
out = filter(b,a,y);
subplot(4,1,3)
plot(out)
title('output signal Low Pass (.05)')

[b, a] = butter(2,[.01,.04]);
out = filter(b,a,y);
subplot(4,1,4)
plot(out)
title('output signal Band Pass (.01-.04)')

n = 2^(nextpow2(length(y)));
%FFT to get the frequency domain of the signal:
z = abs(fft(y,n));
freqaz = (0:1/(n/2):1-(1/n/2));
figure()
plot(freqaz,z(1:n/2))
title('To find the cutoff frequency')

