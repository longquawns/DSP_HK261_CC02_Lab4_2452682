z = poly(0, 'z');
n = -2:2;
x = [2, -1, 2, -3, 4];
X_z = 0;
for i = 1:length(n)
    X_z = X_z + x(i) * z^(-n(i));
end
disp("The Z-transform X(z) is:");
disp(X_z);
