close all;clearvars;clc;
ImgDir = 'Yo.jpg';
Img = uint8(imread(ImgDir));

global Mp Np CompressionFactor;

[Mp, Np, ~] = size(Img);
Mp = Mp - mod(Mp, 8);
Np = Np - mod(Np, 8);
Img = imresize(Img, [Mp Np]);

CompressionFactor=50;

EncodedVectors  =  Encode(Img);
DecodedImg = Decode(EncodedVectors);
figure
subplot(2, 1, 1)
imshow(Img)
title("Original Image")
subplot(2, 1, 2)
imshow(DecodedImg)
title("Compressed Image")