clear;
clc;

if ~atomsIsLoaded("IPCV") then
    atomsLoad("IPCV");
end

RGB = imread("graphics/test_image.jpg");
Gray = rgb2gray(RGB);
GrayD = double(Gray);

H = matrix(imhist(Gray), 256, 1);

CDF = cumsum(H) / (size(GrayD, 1) * size(GrayD, 2));
LUT = round(255 * CDF);
Equalized = uint8(LUT(floor(GrayD) + 1));

KernelSize = 15;
Kernel = ones(KernelSize, KernelSize) / (KernelSize^2);

Blurred = conv2(GrayD, Kernel, "same");
Blurred = uint8(min(255, max(0, round(Blurred))));

Logo = imread("graphics/hcmut.png");
if size(Logo, 3) >= 4 then
    LogoAlpha = double(Logo(:, :, 4)) / 255;
    Logo = Logo(:, :, 1:3);
else
    LogoAlpha = ones(size(Logo, 1), size(Logo, 2));
end

rows = size(RGB, 1);
cols = size(RGB, 2);

newC = round(0.25 * cols);
newR = round(size(Logo, 1) * newC / size(Logo, 2));
if newR > rows then
    newR = rows;
    newC = round(size(Logo, 2) * newR / size(Logo, 1));
end

ri = round(linspace(1, size(Logo, 1), newR));
ci = round(linspace(1, size(Logo, 2), newC));

Logo = Logo(ri, ci, :);
LogoAlpha = LogoAlpha(ri, ci);

r = (rows-newR+1):rows;
c = (cols-newC+1):cols;

Watermarked = RGB;
blend = 0.3 * LogoAlpha;
for channel = 1:3
    Watermarked(r, c, channel) = uint8(round( ...
        (1-blend).*double(RGB(r, c, channel)) + ...
        blend.*double(Logo(:, :, channel)) ));
end

imwrite(Equalized, "graphics/ex5_equalized.png");
imwrite(Blurred, "graphics/ex5_blurred.png");
imwrite(Watermarked, "graphics/ex5_watermarked_revised.png");

scf(1);
plot(0:255, H);
xtitle("Grayscale Histogram", "Intensity", "Pixel Count");
xgrid();

scf(2);
plot(0:255, matrix(imhist(Equalized), 256, 1));
xtitle("Histogram After Equalization", "Intensity", "Pixel Count");
xgrid();

scf(3); imshow(Gray);        xtitle("Original (Gray)");
scf(4); imshow(Equalized);   xtitle("Histogram Equalization");
scf(5); imshow(Blurred);     xtitle("Blur 15x15");
scf(6); imshow(Watermarked); xtitle("Watermarked");
xs2png(1, "graphics/ex5_histogram.png");
xs2png(2, "graphics/ex5_histogram_eq.png");
