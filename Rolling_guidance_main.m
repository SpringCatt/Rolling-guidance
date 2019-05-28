%% main

close all;
clc;

image = double(imread('150.png'));

figure(1);
imshow(uint8(image));
title('Original Image', 'fontsize', 14);

image = image/255;

window_width = 5;
sigma_s = 4;
sigma_r = 0.1;
iteration = 4;

image = rolling_guidance(image, window_width, sigma_s, sigma_r, iteration);

figure(2);
imshow(image);
title('Rolling Guidance Filtering Result', 'fontsize', 14);






        
