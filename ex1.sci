// Define z as a polynomial variable (variable name 'z')
z = poly(0, 'z');

// Signal definition
n = -2:2;
x = [2, -1, 2, -3, 4];

// Calculate Z-transform using powers of z
X_z = 0;
for i = 1:length(n)
    X_z = X_z + x(i) * z^(-n(i));
end

disp("The Z-transform X(z) is:");
disp(X_z);
