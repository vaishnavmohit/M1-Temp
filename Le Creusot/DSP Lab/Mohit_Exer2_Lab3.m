clc
close all;

%reading the image:
img = imread('lena-grey.bmp');
img = rgb2gray(img);
img1 = im2double(img);
k = 1/256*[1 4 6 4 1; 4 16 24 16 4; 6 24 36 24 6; 4 16 24 16 4; 1 4 6 4 1];
img2= conv2(img1,k);
figure()
imshow(img1)
title('Original Image')

figure()
imshow(img2)
title('Convolution image')

k_sobel = [1 2 1; 0 0 0; -1 -2 -1];
img2= conv2(img1,k_sobel);
figure()
imshow(img2)
title('Image after Sobel Filter')

%Edges are found using the sobel filter

k_sobel_T = [1 2 1; 0 0 0; -1 -2 -1]';
img2_T= conv2(img1,k_sobel_T);
figure()
imshow(img2_T)
title('Image after Sobel Filter Transpose')

%Using transpose of the operator we find the horizontal and vertical edges
%of the image

%Horizontal edges using Normal sobel filter and Vertical edges using the
%transpose 
