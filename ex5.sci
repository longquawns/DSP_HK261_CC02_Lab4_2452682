clc;
clear;

cd("C:\Users\Dell\Documents\HCMUT\261\DSP\Lab\Lab4");

// --------------------------------------------------
// 1. Load image and convert to grayscale
// --------------------------------------------------
RGB = imread("test_image.jpg");
Gray = rgb2gray(RGB);
GrayD = double(Gray);

// --------------------------------------------------
// 2. Grayscale histogram
// --------------------------------------------------
H = matrix(imhist(Gray), 256, 1);

// --------------------------------------------------
// 3. Histogram equalization
// --------------------------------------------------
CDF = cumsum(H) / (size(GrayD, 1) * size(GrayD, 2));
LUT = round(255 * CDF);
Equalized = uint8(LUT(floor(GrayD) + 1));

// --------------------------------------------------
// 4. Image blurring using a 15x15 averaging filter
// --------------------------------------------------
KernelSize = 15;
Kernel = ones(KernelSize, KernelSize) / (KernelSize^2);

Blurred = conv2(GrayD, Kernel, "same");
Blurred = uint8(min(255, max(0, round(Blurred))));

// --------------------------------------------------
// 5. Logo watermark
// --------------------------------------------------
Logo = imread("logo.png");

rows = size(RGB, 1);
cols = size(RGB, 2);

// Resize logo to 25% of the image width.
newC = round(0.25 * cols);
newR = round(size(Logo, 1) * newC / size(Logo, 2));

ri = round(linspace(1, size(Logo, 1), newR));
ci = round(linspace(1, size(Logo, 2), newC));

Logo = Logo(ri, ci, :);

// Blend into bottom-right corner.
r = (rows-newR+1):rows;
c = (cols-newC+1):cols;

Watermarked = RGB;
Watermarked(r, c, :) = uint8( ...
    0.7 * double(RGB(r, c, :)) + ...
    0.3 * double(Logo) );

// --------------------------------------------------
// 6. Save results
// --------------------------------------------------
imwrite(Equalized, "equalized.png");
imwrite(Blurred, "blurred.png");
imwrite(Watermarked, "watermarked.png");
// --------------------------------------------------
// Display results
// --------------------------------------------------
scf(1);
plot(0:255, H);
xtitle("Grayscale Histogram", "Intensity", "Pixel Count");
xgrid();

// Histogram after equalization, to show the effect
scf(2);
plot(0:255, matrix(imhist(Equalized), 256, 1));
xtitle("Histogram After Equalization", "Intensity", "Pixel Count");
xgrid();

scf(3); imshow(Gray);        xtitle("Original (Gray)");
scf(4); imshow(Equalized);   xtitle("Histogram Equalization");
scf(5); imshow(Blurred);     xtitle("Blur 15x15");
scf(6); imshow(Watermarked); xtitle("Watermarked");
