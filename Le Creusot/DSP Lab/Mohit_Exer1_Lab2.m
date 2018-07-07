%Writing the Program to define discrete signal with values as defined
%below
close all
N=10;
%Defining step functions
t = 0:1:N;
x=[zeros(1,4),ones(1,7)];
plot(t,x);
figure();
xlabel(['Time(t)']);
ylabel(['Amplitude']);
title('Step signal X');

%Defining the equation:
for i=1:N-1
    y(i)= (x(i) + x(i+1))/2;
end
plot(y)
xlabel(['Time(t)']);
ylabel(['y']);
title('y(i) = (x(i) + x(i+1))/2');

%This  system is casual because it depends upon the future value of x(i+1)
%If we want to make the system casual then the input signal has to be
%shifted one step backwards. Then it will depend upon the one previous
%signal and the current signal.

for i=2:N
    y_N(i-1)= (x(i-1) + x(i))/2; %y_N is starting from i-1 so as to start the signal from 1 index.
end
figure
plot(y_N)
xlabel(['Time(t)']);
ylabel(['y_N']);