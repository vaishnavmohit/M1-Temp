clc
clear all
close all

x_a = [0 0 0 0 1 2 3 4 5 0 0 0 0 0 0 0 0 0 0];
x_b = [0 0 0 0 0 0 0 0 0 4 3 2 1 0 0 0 0 0 0];
y_a(1) = 0;
y_a(length(x_a)) = 0;
y_b(1) = 0;
y_b(length(x_a)) = 0;
for i=2:length(x_a)-1
    y_a(i) = 3*x_a(i-1) - 2*x_a(i) + x_a(i+1);
    y_b(i) = 3*x_b(i-1) - 2*x_b(i) + x_b(i+1);
end

%comparing Linearity of the system:
y_c = y_a + y_b;
y_c_3 = x_a + x_b;
y_c_2(1) = 0;
y_c_2(length(x_a)) = 0;
for i=2:length(x_a)-1
    y_c_2(i) = 3*(x_a(i-1) + x_b(i-1)) -2*(x_a(i) + x_b(i)) + (x_a(i+1) + x_b(i+1));
end


if(y_c == y_c_2)
    fprintf('System is linear');
else
    fprintf('System is not linear');
end

%because the system has the same values it is linear