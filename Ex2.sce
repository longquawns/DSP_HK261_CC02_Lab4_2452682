

clear;
clc;

Nmax = 80;
n = 0:Nmax;
x = 0.5.^n + 0.4.^n;

z_check = [0.8 1.2];
for j = 1:length(z_check)
    z = z_check(j);
    X_sum = sum(x .* (z.^(-n)));
    X_formula = 1/(1 - 0.5/z) + 1/(1 - 0.4/z);
    mprintf("z = %.2f: partial sum = %.8f, formula = %.8f, error = %.3e\n", ..
            z, X_sum, X_formula, abs(X_sum - X_formula));
end

z_out = 0.45;
last_term = (0.5/z_out)^Nmax + (0.4/z_out)^Nmax;
mprintf("At z = %.2f, magnitude of term n=%d is %.4e (outside ROC).\n", ..
        z_out, Nmax, abs(last_term));

scf(2);
clf();
subplot(2,1,1);
plot2d3(0:20, x(1:21));
plot(0:20, x(1:21), "bo");
gca().data_bounds = [-1 -0.2; 21 2.3];
xtitle("Exercise 2: x(n) = 0.5^n + 0.4^n, n >= 0", "n", "x(n)");
xgrid(1);

subplot(2,1,2);
partial = zeros(1, Nmax+1);
z = z_check(1);
for k = 1:Nmax+1
    partial(k) = sum(x(1:k) .* z.^(-n(1:k)));
end
plot(n, partial);
xtitle("Partial Z-transform sums at z = 0.8 (inside ROC)", ..
       "Upper summation index", "Partial sum");
xgrid(1);
