function F = prim(f)

F(1) = 1;
for i=2:length(f)
    F(i) = F(i-1) + f(i);
end
end