clc
close all

N = 1e5;
%Random Number generation:
s = randn(1,N);
s = s - mean(s);
%plotting the signal
figure()
plot(s)
figure()
hist(s)

%obtaining the PDF:
[h, xh] = hist(s,50);
h=h/N;
figure()
plot(xh, h,'-*')

%fft
fs = 10000;
dft = fft(s);
f = fftshift(dft);
df = fs/N;
figure()
plot(-fs/2:df:fs/2-df,abs(f))

%Sub Sampling
sb = s(1:2:end);
Nb = length(sb);
[h1, xh1] = hist(sb,50);
h1 = h1/Nb;
    %for PDF
figure()
plot(xh1,h1,'*-');
    %For FFT
fs = 10000;
dft = fft(s);
    %For FFT Shift
f = fftshift(dft);
df = fs/N;
figure()
plot(-fs/2:df:fs/2-df,abs(f))


%1.5 using sin function:
sc = sin(s);
[h2, xh2] = hist(sc,50);
Nc = length(sc);
h2 = h2/Nc;
    %for PDF
figure()
plot(xh2,h2,'*-');
title('Sin Graph PDF')
    %For FFT
fs = 10000;
dft = fft(sc);
    %For FFT Shift
f = fftshift(dft);
df = fs/N;
figure()
plot(-fs/2:df:fs/2-df,abs(f))
title('Sin Graph FFT Shift')

%1.6 Creating a random signal using convolution:
c = [.5 .5;1 1];
sd = conv2(c, s);
K = max(s)/max(max(sd));
[h3, xh3] = hist(sd,50);
Nd = length(sd);
h3 = h3/Nd;
    %for PDF
figure()
plot(xh3,h3,'*-');
title('Convolution Graph PDF')
    %For FFT
fs = 10000;
dft = fft(sd);
    %For FFT Shift
f = fftshift(dft);
df = fs/Nd;
figure()
plot(-fs/2:df:fs/2-df,abs(f))
title('Convolution Graph FFT Shift')

