close all
clear all

%Defining the step signal:
N=10;
t = 0:1:N;
x=[zeros(1,4),ones(1,7)];
plot(t,x);
xlabel(['Time(t)']);
ylabel(['Amplitude']);
title('Step signal X');
f=x;
F = prim(f);
plot(f,'b*-')
title('Input and accumulated signal F')
hold on

plot(F,'r*-')
xlabel('Time(t)');
ylabel('Amplitude');
%title('Accumulator signal F1')
hold off

%Because the input is bounded and the out put is not bounded the system is
%not stable

%Impulse response of the system:
s = zeros(1,N);
s(4) =1;
S = prim(s);
figure
plot(1:N, s,'b*-', 1:N, S, 'r*-')

F1(1) = 0;
for i=2:length(s)
    F1(i) = 2*F1(i-1) + s(i);
end
figure
plot(1:N, s,'b*-', 1:N, F1,'r*-')
xlabel('Time(t)');
ylabel('Amplitude');
title('F1(i) = 2*F1(i-1) + f(i);');
%the system was not stable and is unbounded.


F2(1) = 0;
for i=2:length(s)
    F2(i) = .33*F2(i-1) + s(i);
end
figure
plot(1:N, s,'b*-', 1:N,F2, 'r*-')
xlabel('Time(t)');
ylabel('Amplitude');
title('F2(i) = .33*F2(i-1) + f(i)');
%stable and bounded where the values of input is as bounded as input. 
