close all 
clc
%defining the signal:
x = [1 -2 3 -4 3 2 1];

%Defining the impulse response:
h = [3 2 1 -2 1 0 -4 0 3];

%Finding the convolution of signal:
y = conv(x,h);

%Plotting the output
n =0:length(y)-1;
subplot(2,1,1)
stem(n,y)
xlabel('Time index n: ');
ylabel('Output obtained by convolution: ')

%Plotting the output using filter:
x1 = [x zeros(1,8)];
y1 = filter(h,1,x1);
subplot(2,1,2);
stem(n,y1)
xlabel('Time index n: ');
ylabel('Output by convolution: ')
%Both the output comes out to be same!!!!!!!!!!!!!!!

figure()

%defining the signal:
x1 = [1 -2 3 -4 3 2 1 1 -2 3 -4 3 2 1 2];

%Defining the impulse response:
h1 = [3 2 1 -2 1 0 -4 0 3 1];

%Finding the convolution of signal:
y1 = conv(x1,h1);

%Plotting the output
n =0:length(y1)-1;
subplot(2,1,1)
stem(n,y1)
xlabel('Time index n: ');
ylabel('Output by convolution: ')

%Plotting the output using filter:
x11 = [x1 zeros(1,9)];
y11 = filter(h,1,x11);
subplot(2,1,2);
stem(n,y11)
xlabel('Time index n: ');
ylabel('Output by convolution: ')

%both the result comes out to be same: