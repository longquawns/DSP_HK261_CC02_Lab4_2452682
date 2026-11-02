

clear;
clc;

fs = 8000;
f0 = 440;
duration = 1;
n = 0:(fs*duration-1);
t = n/fs;
x = 0.5*sin(2*%pi*f0*t);

wav_file = "lab4_ex4_440Hz.wav";
wavwrite(x, fs, wav_file);
[y, fs_read, bits] = wavread(wav_file);
y = matrix(y, 1, -1);

if fs_read <> fs then
    error("WAV sampling rate differs from the requested value.");
end
if length(y) <> length(x) then
    error("WAV sample count changed after reading.");
end

max_error = max(abs(x - y));
mprintf("WAV: %s\n", wav_file);
mprintf("Sampling rate: %d Hz; bit depth: %d; samples: %d\n", ..
        fs_read, bits, length(y));
mprintf("Maximum read/write quantization difference: %.5g\n", max_error);

Y = fft(y);
positive_bins = 1:(fs/2+1);
freq = (positive_bins-1)*fs/length(y);
amplitude = 2*abs(Y(positive_bins))/length(y);
amplitude(1) = amplitude(1)/2;
peak_bins = 1:(fs/2+1);
[peak_amplitude, peak_index] = max(amplitude(peak_bins));
peak_frequency = freq(peak_index);
mprintf("Peak frequency: %.1f Hz; peak amplitude: %.6f\n", ..
        peak_frequency, peak_amplitude);

scf(4);
clf();
subplot(2,1,1);
zoom_idx = 1:round(0.02*fs);
plot(t(zoom_idx), y(zoom_idx));
xtitle("Recovered 440 Hz tone (first 20 ms)", "Time (s)", "Amplitude");
xgrid(1);

subplot(2,1,2);
plot(freq, amplitude);
a = gca();
a.data_bounds = [0 0; 1000 max(amplitude)*1.1];
xtitle("Single-sided magnitude spectrum", "Frequency (Hz)", "Amplitude");
xgrid(1);
