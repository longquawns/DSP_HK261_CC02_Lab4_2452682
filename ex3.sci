// Define z as a rational polynomial variable
z = poly(0, 'z');

// Signal 1: x1(n) = 0.5^n * u(n) -> Right-sided causal signal
// Z-transform: X1(z) = z / (z - 0.5), ROC: |z| > 0.5
X1_z = z / (z - 0.5);

// Signal 2: x2(n) = 0.9^n * u(-n - 1) -> Left-sided anti-causal signal
// Z-transform: X2(z) = -z / (z - 0.9), ROC: |z| < 0.9
X2_z = -z / (z - 0.9);

// Total Z-transform X(z) = X1(z) + X2(z)
X_z = X1_z + X2_z;

disp("The Z-transform X(z) is:");
disp(X_z);
