

clear;
clc;

x = [1 2 -3 2 1];
h = [1 0 -1];
Nx = length(x);
Nh = length(h);
Ny = Nx + Nh - 1;
nx = 0:Nx-1;
ny = 0:Ny-1;

y_fold = zeros(1, Ny);
for output_index = 0:Ny-1
    for k = 0:Nh-1
        x_index = output_index - k;
        if x_index >= 0 & x_index < Nx then
            y_fold(output_index+1) = y_fold(output_index+1) + ..
                h(k+1)*x(x_index+1);
        end
    end
end

H = zeros(Ny, Nx);
for row = 0:Ny-1
    for col = 0:Nx-1
        h_index = row - col;
        if h_index >= 0 & h_index < Nh then
            H(row+1, col+1) = h(h_index+1);
        end
    end
end
y_matrix = (H*x')';

disp(y_fold, "Folding-and-shifting result y(n):");
disp(y_matrix, "Matrix result y(n):");
disp(H, "Convolution matrix H:");
if max(abs(y_fold-y_matrix)) > 1d-12 then
    error("The two convolution methods do not agree.");
end

expected = [1 2 -4 0 4 -2 -1];
if max(abs(y_fold-expected)) > 1d-12 then
    error("Convolution does not match the hand calculation.");
end

energy_x = abs(x).^2;
energy_y = abs(y_fold).^2;
mprintf("E_x = %.0f; E_y = %.0f\n", sum(energy_x), sum(energy_y));

scf(6);
clf();
subplot(2,2,1);
plot2d3(nx, x);
plot(nx, x, "bo");
gca().data_bounds = [-1 min(x)-1; Nx max(x)+1];
xtitle("Input x(n)", "n", "Amplitude");
xgrid(1);

subplot(2,2,2);
plot2d3(ny, y_fold);
plot(ny, y_fold, "bo");
gca().data_bounds = [-1 min(y_fold)-1; Ny max(y_fold)+1];
xtitle("Linear convolution y(n)", "n", "Amplitude");
xgrid(1);

subplot(2,2,3);
plot2d3(nx, energy_x);
plot(nx, energy_x, "bo");
gca().data_bounds = [-1 -1; Nx max(energy_x)+1];
xtitle("Sample energy |x(n)|^2; total = 19", "n", "Energy");
xgrid(1);

subplot(2,2,4);
plot2d3(ny, energy_y);
plot(ny, energy_y, "bo");
gca().data_bounds = [-1 -1; Ny max(energy_y)+1];
xtitle("Sample energy |y(n)|^2; total = 42", "n", "Energy");
xgrid(1);
