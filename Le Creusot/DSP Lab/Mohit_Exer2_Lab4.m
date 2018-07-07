%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Exercise 2:
close all
clear all
f = 5;
fs = 50;
t = 0:1/fs:1-(1/fs);
xn = sin(2*pi*f*t);
N = length(xn);
freq = (-N/2:N/2-1)*fs/N;
xf = fftshift(fft(xn));

figure()
title('For Sin wave')
subplot(221);
plot(t,xn);
title('Signal Sin wave');
xlabel('Time(sec)')
ylabel('Amplitude')

subplot(222);
plot(freq,abs(xf));
title('Magnitude');
xlabel('frequency')
ylabel('|X(f)|')

subplot(223);
plot(t,real(xf));
title('Real');
xlabel('frequency')
ylabel('Re|X(f)|')

subplot(224);
plot(t,imag(xf));
title('Imaginary');
xlabel('frequency')
ylabel('Im|X(f)|')

%Exercise 2.2 using cosine wave:
f = 5;
fs = 50;
t = 0:1/fs:1-(1/fs);
xn = cos(2*pi*f*t);
N = length(xn);
freq = (-N/2:N/2-1)*fs/N;
xf = fftshift(fft(xn));

figure()
title('For Cos wave')
subplot(221);
plot(t,xn);
title('Signal Cosine wave');
xlabel('Time(sec)')
ylabel('Amplitude')

subplot(222);
plot(freq,abs(xf));
title('Magnitude');
xlabel('frequency')
ylabel('|X(f)|')

subplot(223);
plot(t,real(xf));
title('Real');
xlabel('frequency')
ylabel('Re|X(f)|')

subplot(224);
plot(t,imag(xf));
title('Imaginary');
xlabel('frequency')
ylabel('Im|X(f)|')

%Exercise 2.2 using square wave:

f = 5;
fs = 50;
t = 0:1/fs:1-(1/fs);
xn = square(2*pi*f*t);
N = length(xn);
freq = (-N/2:N/2-1)*fs/N;
xf = fftshift(fft(xn));

figure()
title('For square wave')
subplot(221);
plot(t,xn);
title('Signal square wave');
xlabel('Time(sec)')
ylabel('Amplitude')

subplot(222);
plot(freq,abs(xf));
title('Magnitude');
xlabel('frequency')
ylabel('|X(f)|')

subplot(223);
plot(t,real(xf));
title('Real');
xlabel('frequency')
ylabel('Re|X(f)|')

subplot(224);
plot(t,imag(xf));
title('Imaginary');
xlabel('frequency')
ylabel('Im|X(f)|')

%all the signals have the certain range of frequency which can be removed
%via some filters if they are in the noise form. 