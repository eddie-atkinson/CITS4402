% Author: Edward Atkinson
% Student number: 22487668
% email: 22487668@student.uwa.edu.au
% March 2021; Last revision: 15-March-2021

% Load and examine the original images and derive their size
barrackImage = imread("obama.jpg");
johnImage = imread("mccain.jpg");

figure("name", "Comparison of the original images");
subplot(1,2,1), imshow(barrackImage);
title("Original image of Obama")
axis on;
subplot(1,2,2), imshow(johnImage);
title("Original image of McCain")
axis on;

% Convert the images to greyscale and derive their size
bwBarrack = rgb2gray(barrackImage);
bwJohn = rgb2gray(johnImage);

[nrows, ncols] = size(bwBarrack);
fprintf("N rows in image: %d\nN columns in image: %d\n", nrows, ncols);

figure("name", "Comparison of the greyscale transformed images");
subplot(1,2,1), imshow(bwBarrack);
title("Greyscale image of Obama")
axis on;
subplot(1,2,2), imshow( bwJohn);
title("Greyscale image of McCain")
axis on;

% Convert the images into the frequency domain and apply low and high pass filters

freqBarrack = fft2(bwBarrack);
freqJohn = fft2(bwJohn);

lowPassCutOff = 0.03;
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


barrackFreqShifted = fftshift(freqBarrack);
johnFreqShifted = fftshift(freqJohn);

lowPassFilter = lowpassfilter([nrows, ncols], lowPassCutOff, n);
highPassFilter = highpassfilter([nrows, ncols], highPassCutOff, n);

smoothedBarrackFreq = lowPassFilter .* freqBarrack;
sharpenedJohnFreq = highPassFilter .* freqJohn;


% Use the inverse fourier transform to return the images to the spatial domain and visualise them

smoothedBarrack = ifft2(smoothedBarrackFreq);
sharpenedJohn = ifft2(sharpenedJohnFreq);

figure("name", "Comparison of the filtered images");
subplot(1,2,1), imagesc(smoothedBarrack);
title("Low pass filtered image of Obama")
axis equal;
subplot(1,2,2), imagesc(sharpenedJohn);
title("High pass filtered image of McCain")
axis equal;

% Looks pretty good, the images are now represented as doubles, however.
% Lets scale them back to the range of a greyscale image [0, 255] and visualise them

smoothedBarrackBw = uint8(smoothedBarrack);
sharpenedJohnBw = uint8(sharpenedJohn);

figure("name", "Comparison of the greyscale filtered images");
subplot(1,2,1), imshow(smoothedBarrackBw);
title("Greyscale low pass filtered image of Obama")
axis on;
subplot(1,2,2), imshow(sharpenedJohnBw);
title("Greyscale high pass filtered image of McCain =")
axis on;

% Looks good, compose the two images by adding them in the frequency domain
% converting them back to the spatial domain, and comparing their double
% and integer representations

combinedImgFreq = smoothedBarrackFreq + sharpenedJohnFreq;

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
