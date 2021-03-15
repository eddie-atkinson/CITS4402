% Author: Edward Atkinson
% Student number: 22487668
% email: 22487668@student.uwa.edu.au
% March 2021; Last revision: 15-March-2021


% Load and examine the original images and derive their size
manImage = imread("man.png");
womanImage = imread("woman.png");

figure("name", "Comparison of the original images");
subplot(1,2,1), imshow(manImage);
title("Original image of a man")
axis on;
subplot(1,2,2), imshow(womanImage);
title("Original image of a woman")
axis on;

% Convert the images to greyscale and derive their size
bwMan = rgb2gray(manImage);
bwWoman = rgb2gray(womanImage);

[nrows, ncols] = size(bwMan);
fprintf("N rows in image: %d\nN columns in image: %d\n", nrows, ncols);

figure("name", "Comparison of the greyscale transformed images");
subplot(1,2,1), imshow(bwMan);
title("Greyscale image of a man")
axis on;
subplot(1,2,2), imshow(bwWoman);
title("Greyscale image of a woman")
axis on;

% Convert the images into the frequency domain and apply low and high pass filters

freqMan = fft2(bwMan);
freqWoman = fft2(bwWoman);

lowPassCutOff = 0.04;
highPassCutOff = 0.1;
n = 1;

freqRange = linspace(-0.5, 0.5);

% Double check that the overlap in the frequency range between the two filters is not too large
oneDLowPassFilter = (1 + (freqRange / lowPassCutOff).^(2*n)).^-1;
oneDHighPassFilter = 1 - oneDLowPassFilter;
figure("name", "Comparison of the profiles of the low and high pass filters");
plot(freqRange, oneDLowPassFilter, "r");
hold on;
plot(freqRange, oneDHighPassFilter, "b");
legend("Low pass filter", "High pass filter")


manFreqShifted = fftshift(freqMan);
womanFreqShifted = fftshift(freqWoman);

lowPassFilter = lowpassfilter([nrows, ncols], lowPassCutOff, n);
highPassFilter = highpassfilter([nrows, ncols], highPassCutOff, n);

smoothedManFreq = lowPassFilter .* freqMan;
sharpenedWomanFreq = highPassFilter .* freqWoman;


% Use the inverse fourier transform to return the images to the spatial domain and visualise them

smoothedMan = ifft2(smoothedManFreq);
sharpenedWoman = ifft2(sharpenedWomanFreq);

figure("name", "Comparison of the filtered images");
subplot(1,2,1), imagesc(smoothedMan);
title("Low pass filtered image of a man")
axis equal;
subplot(1,2,2), imagesc(sharpenedWoman);
title("High pass filtered image of a woman")
axis equal;

% Looks pretty good, the images are     now represented as doubles, however.
% Lets scale them back to the range of a greyscale image [0, 255] and visualise them

smoothedManBw = uint8(smoothedMan);
sharpenedWomanBw = uint8(sharpenedWoman);

figure("name", "Comparison of the greyscale filtered images");
subplot(1,2,1), imshow(smoothedManBw);
title("Greyscale low pass filtered image of a man")
axis on;
subplot(1,2,2), imshow(sharpenedWomanBw);
title("Greyscale high pass filtered image of a woman")
axis on;

% Looks good, compose the two images by adding them in the frequency domain
% converting them back to the spatial domain, and comparing their double
% and integer representations

combinedImgFreq = smoothedManFreq + sharpenedWomanFreq;

combinedImg = ifft2(combinedImgFreq);

figure("name", "Composed hybrid image");
imagesc(combinedImg);
axis on;

combinedImgBw = uint8(combinedImg);
figure("name", "Composed greyscale hybrid image");
imshow(combinedImgBw);
axis on;

% I don't really want to stand up, so let's resize the image to simulate moving further backwards

scalingRatios = [1.0 0.5 0.25 0.125];
% pre-assign cell array memory to save computation
resizedImages = {
    cell(nrows, ncols)
    cell(nrows, ncols)
    cell(nrows, ncols)
    cell(nrows, ncols)
 };
for n = 1:4
    resizedImages{n}  = imresize(combinedImgBw, scalingRatios(n));
end

figure("name", "Hybrid image scaled down to simulate distance");
for i = 1:4
    subplot(2, 2, i), imshow(resizedImages{i});
    title(sprintf("Hybrid image resized to %0.3f of the original size", scalingRatios(i)));
    axis on;
end
