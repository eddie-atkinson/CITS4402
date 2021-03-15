% Author: Edward Atkinson
% Student number: 22487668
% email: 22487668@student.uwa.edu.au
% March 2021; Last revision: 09-March-2021

% Read in the image
originalImage = imread("lego1.png");
% Visualise the image with an appropriate title
figure("name", "Original Image")
imshow(originalImage);

% Transform the image to greyscale and visualise it
greyScaleImage = rgb2gray(originalImage);
figure("name", "Greyscale Transformation of Image")
imshow(greyScaleImage);

% Create a histogram of the greyscale image and visualise it
figure("name", "Histogram of Greyscale Values")
imhist(greyScaleImage);


% Create a binary image using a threshold value and visualise it
threshold = 150;
binaryImage = greyScaleImage > threshold;
figure("name", sprintf("Binary Image with Threshold Value of %d", threshold))
imshow(binaryImage);

% Apply the morphological erosion operation and visualise result
% Use an 8 neighbour, square structuring element
structuringElement = strel("square", 4);
erodedImage = imerode(binaryImage, structuringElement);
figure("name", "Image After Applying Erosion Operation")
imshow(erodedImage);

% Apply the morphological dilation operation and visualise result
dilatedImage = imdilate(binaryImage, structuringElement);
figure("name", "Image After Applying Dilation Operation");
imshow(dilatedImage);

 
% Count and print the number of objects in the image
closeStrel = strel("disk", 4);
erosionStrel = strel("disk", 2);
% Close the image to reduce the holes in the lego
closedCountImage = imclose(binaryImage, closeStrel);
% Erode the image to more clearly define the edges of the objects, whilst
% reducing holes further
erodedCountImage = imerode(closedCountImage, erosionStrel);
[L, num] = bwlabel(erodedCountImage);

fprintf('Object count is: %i\n', num);

