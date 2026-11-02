

clear;
clc;

x = [1 2 -3 2 1];
h = [1 0 -1 -1 1];
N = length(x);
M = length(h);
n = 0:N-1;

y_fold = zeros(1, N);

for m = 0:N-1
    for k = 0:M-1
        x_index = pmodulo(m-k, N) + 1;
        y_fold(m+1) = y_fold(m+1) + h(k+1)*x(x_index);
    end
end

Xcirc = zeros(N, M);

for m = 0:N-1
    for k = 0:M-1
        Xcirc(m+1, k+1) = x(pmodulo(m-k, N)+1);
    end
end

y_matrix = (Xcirc*h')';

expected = [4 -4 -3 0 3];

if max(abs(y_fold-y_matrix)) > 1d-12 then
    error("The folding-and-shifting and matrix methods disagree.");
end

if max(abs(y_fold-expected)) > 1d-12 then
    error("Circular convolution does not match the hand result.");
end

energy_x = abs(x).^2;
energy_y = abs(y_fold).^2;
E_x = sum(energy_x);
E_y = sum(energy_y);

disp(y_fold, "Folding-and-shifting result y[n]:");
disp(Xcirc, "Circular convolution matrix Xcirc:");
disp(y_matrix, "Matrix-method result y[n]:");
disp(energy_x, "Sample-wise energy |x[n]|^2:");
disp(energy_y, "Sample-wise energy |y[n]|^2:");
mprintf("Energy per period: E_x = %.0f; E_y = %.0f\n", E_x, E_y);

scf(7);
clf();

subplot(2,2,1);
plot2d3(n, x, 2);
plot(n, x, "bo");
gca().data_bounds = [-1 min(x)-1; N max(x)+1];
xtitle("Input signal x[n] over one period", "n", "Amplitude");
xgrid(1);

subplot(2,2,2);
plot2d3(n, y_fold, 5);
plot(n, y_fold, "ro");
gca().data_bounds = [-1 min(y_fold)-1; N max(y_fold)+1];
xtitle("Circular convolution y[n]", "n", "Amplitude");
xgrid(1);

subplot(2,2,3);
plot2d3(n, energy_x, 3);
plot(n, energy_x, "go");
gca().data_bounds = [-1 -1; N max(energy_x)+2];
xtitle("Sample energy |x[n]|^2; total = 19", "n", "Energy");
xgrid(1);

subplot(2,2,4);
plot2d3(n, energy_y, 6);
plot(n, energy_y, "mo");
gca().data_bounds = [-1 -1; N max(energy_y)+2];
xtitle("Sample energy |y[n]|^2; total = 50", "n", "Energy");
xgrid(1);
