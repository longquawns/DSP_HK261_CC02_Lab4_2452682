
clc;
clear;

// Input signals
x = [1 2 -3 2 1];
h = [1 0 -1 -1 1];
N = length(x);
n = 0:N-1;

// Helper: stem plot with a circle marker at each tip
function stemdot(n, v, c)
    plot2d3(n, v, 1);
    plot2d(n, v, -9);
    e = gce();
    e.children(1).mark_foreground = c;
    e.children(1).mark_background = 0;
endfunction

// 1. Folding-and-shifting method
y_fold = zeros(1, N);
for m = 0:N-1
    for k = 0:N-1
        idx = pmodulo(m-k, N) + 1;
        y_fold(m+1) = y_fold(m+1) + h(k+1)*x(idx);
    end
end

// 2. Matrix method
Xcirc = zeros(N, N);
for m = 0:N-1
    for k = 0:N-1
        Xcirc(m+1, k+1) = x(pmodulo(m-k, N)+1);
    end
end
y_matrix = Xcirc * h';
y = y_fold;

// Display results
disp("Folding-and-shifting result:");
disp(y_fold);
disp("Circular convolution matrix:");
disp(Xcirc);
disp("Matrix method result:");
disp(y_matrix');

// 3. Plot x[n], y[n] and their sample-wise energy in one figure
scf(1);
clf();

subplot(2,2,1);
stemdot(n, x, 2);
xtitle("Input Signal x[n]", "n", "Amplitude");
xgrid(12);

subplot(2,2,2);
stemdot(n, y, 3);
xtitle("Circular Convolution y[n]", "n", "Amplitude");
xgrid(12);

subplot(2,2,3);
stemdot(n, x.^2, 2);
xtitle("Energy of x[n]", "n", "x^2[n]");
xgrid(12);

subplot(2,2,4);
stemdot(n, y.^2, 3);
xtitle("Energy of y[n]", "n", "y^2[n]");
xgrid(12);

// Total energy per period
Ex = sum(x.^2);
Eh = sum(h.^2);
Ey = sum(y.^2);
printf("E_x = %d\n", Ex);
printf("E_h = %d\n", Eh);
printf("E_y = %d\n", Ey);
