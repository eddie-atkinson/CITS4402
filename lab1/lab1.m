im = imread("images/lego1.png", "png");
im_size = size(im);
imshow(im)
grey_scale_im = rgb2gray(im);
imshow(grey_scale_im);
imhist(rgb2gray(im))
binary_image = grey_scale_im > 150;
imshow(binary_image)
[L, num] = bwlabel(grey_scale_im, 4);
