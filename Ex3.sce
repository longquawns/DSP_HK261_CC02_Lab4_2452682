z = poly(0, 'z');
X1_z = z / (z - 0.5);
X2_z = -z / (z - 0.9);
X_z = X1_z + X2_z;
disp("The Z-transform X(z) is:");
disp(X_z);
