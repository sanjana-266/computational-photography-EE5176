%% Demosaicing %%

image1 = load('data/RawImage1.mat');
m1 = image1.RawImage1;

image2 = load('data/RawImage2.mat');
m2 = image2.RawImage2;

image3 = load('data/RawImage3.mat');
m3 = image3.RawImage3;

imagek = load('data/kodim19.mat');
mk = imagek.raw;

%% Linear interpolation %

bayer_file = load('data/bayer1.mat');
bayer_1 = bayer_file.bayer1;
bayer_file = load('data/bayer2.mat');
bayer_2 = bayer_file.bayer2;
bayer_file = load('data/bayer3.mat');
bayer_3 = bayer_file.bayer3;
bayer_file = load('data/kodim_cfa.mat');
bayer_mk = bayer_file.cfa;

demosaiced_image_1 = demosaic_(m1, bayer_1, 'linear');
demosaiced_image_2 = demosaic_(m2, bayer_2, 'linear');
demosaiced_image_3 = demosaic_(m3, bayer_3, 'linear');

%%
figure("Name", "BiLinear Interpolation on Image1");
imshow(uint8(demosaiced_image_1));
%saveas(gcf,'Figures/fig1.png');
figure("Name", "BiLinear Interpolation on Image2");
imshow(uint8(demosaiced_image_2));
figure("Name", "BiLinear Interpolation on Image3");
imshow(uint8(demosaiced_image_3));

%% Cubic interpolation

demosaiced_image_1 = demosaic_(m1, bayer_1, 'cubic');
demosaiced_image_2 = demosaic_(m2, bayer_2, 'cubic');
demosaiced_image_3 = demosaic_(m3, bayer_3, 'cubic');

%%
figure("Name", "BiCubic Interpolation on Image1");
imshow(uint8(demosaiced_image_1));
%saveas(gcf,'Figures/fig2.png');
figure("Name", "BiCubic Interpolation on Image2");
imshow(uint8(demosaiced_image_2));
figure("Name", "BiCubic Interpolation on Image3");
imshow(uint8(demosaiced_image_3));

%% Demosaicing using inbuilt MATLAB function

image_demosaiced1 = demosaic(m1,'rggb'); 
image_demosaiced2 = demosaic(m2,'grbg');
image_demosaiced3 = demosaic(m3,'rggb');

figure("Name", "Demosaiced Image1");
imshow(image_demosaiced1);
%saveas(gcf,'Figures/fig3.png');
figure("Name", "Demosaiced Image2");
imshow(image_demosaiced2);
figure("Name", "Demosaiced Image3");
imshow(image_demosaiced3);

%% Comparison of demosaiced and actual Kodak image

image_demosaicedkodak_1 = demosaic_(mk, bayer_mk, 'linear');
image_demosaicedkodak_2 = demosaic_(mk, bayer_mk, 'cubic');
image_demosaicedkodak_3 = demosaic(uint8(mk), 'rggb');

figure("Name", "Demosaiced Kodak Image");
imshow(uint8(image_demosaicedkodak_1));
%saveas(gcf,'Figures/fig4-1.png');
figure("Name", "Demosaiced Kodak Image");
imshow(uint8(image_demosaicedkodak_2));
%saveas(gcf,'Figures/fig4-2.png');
figure("Name", "Demosaiced Kodak Image");
imshow(uint8(image_demosaicedkodak_3));
%saveas(gcf,'Figures/fig4-3.png');
figure("Name", "Actual Kodak Image");
%saveas(gcf,'Figures/fig5.png');
imshow('data/kodim19.png');

%% White mapping - Part (a) %%

avg_color = zeros(3,3);
rgb_sum = zeros(3);

white_balanced_image1 = uint8(demosaiced_image_1);
white_balanced_image2 = uint8(demosaiced_image_2);
white_balanced_image3 = uint8(demosaiced_image_3);

for i=1:3
avg_color(1,i) = mean(white_balanced_image1(:,:,i), 'all');
avg_color(2,i) = mean(white_balanced_image2(:,:,i), 'all');
avg_color(3,i) = mean(white_balanced_image3(:,:,i), 'all');
rgb_sum(1) = rgb_sum(1) + avg_color(1,i);
rgb_sum(2) = rgb_sum(2) + avg_color(2,i);
rgb_sum(3) = rgb_sum(3) + avg_color(3,i);
end

for i=1:3
white_balanced_image1(:,:,i) = (rgb_sum(1)/3/avg_color(1,i)).*white_balanced_image1(:,:,i);
white_balanced_image2(:,:,i) = (rgb_sum(2)/3/avg_color(2,i)).*white_balanced_image2(:,:,i);
white_balanced_image3(:,:,i) = (rgb_sum(3)/3/avg_color(3,i)).*white_balanced_image3(:,:,i);
end

%%

figure("Name", "White-balanced Image1");
imshow(uint8(white_balanced_image1));
%saveas(gcf,'Figures/fig6.png');
figure("Name", "White-balanced Image2");
imshow(uint8(white_balanced_image2));
%saveas(gcf,'Figures/fig7.png');
figure("Name", "White-balanced Image3");
imshow(uint8(white_balanced_image3));
%saveas(gcf,'Figures/fig8.png');

%% Part (b) %%

spectral_color = zeros(3,3);
rgb_sum = zeros(3);
white_balanced_image1_b = uint8(demosaiced_image_1);
white_balanced_image2_b = uint8(demosaiced_image_2);
white_balanced_image3_b = uint8(demosaiced_image_3);

for i=1:3
spectral_color(1,i) = demosaiced_image_1(814, 830, i);
spectral_color(2,i) = demosaiced_image_2(280, 1165, i);
spectral_color(3,i) = demosaiced_image_3(675, 175, i);
rgb_sum(1) = rgb_sum(1) + spectral_color(1,i);
rgb_sum(2) = rgb_sum(2) + spectral_color(2,i);
rgb_sum(3) = rgb_sum(3) + spectral_color(3,i);
end

for i=1:3
white_balanced_image1_b(:,:,i) = (rgb_sum(1)/3/spectral_color(1,i)).*demosaiced_image_1(:,:,i);
white_balanced_image2_b(:,:,i) = (rgb_sum(2)/3/spectral_color(2,i)).*demosaiced_image_2(:,:,i);
white_balanced_image3_b(:,:,i) = (rgb_sum(3)/3/spectral_color(3,i)).*demosaiced_image_3(:,:,i);
end

%%

figure("Name", "White-balanced Image1");
imshow(uint8(white_balanced_image1_b));
%saveas(gcf,'Figures/fig9.png');
figure("Name", "White-balanced Image2");
imshow(uint8(white_balanced_image2_b));
%saveas(gcf,'Figures/fig10.png');
figure("Name", "White-balanced Image3");
imshow(uint8(white_balanced_image3_b));
%saveas(gcf,'Figures/fig11.png');

%% Part (c) %%

spectral_color = zeros(3,3);
rgb_sum = zeros(3);
white_balanced_image1_c = uint8(demosaiced_image_1);
white_balanced_image2_c = uint8(demosaiced_image_2);
white_balanced_image3_c = uint8(demosaiced_image_3);

for i=1:3
spectral_color(1,i) = demosaiced_image_1(435, 2000, i);
spectral_color(2,i) = demosaiced_image_2(715, 445, i);
spectral_color(3,i) = demosaiced_image_3(565, 1550, i);
rgb_sum(1) = rgb_sum(1) + spectral_color(1,i);
rgb_sum(2) = rgb_sum(2) + spectral_color(2,i);
rgb_sum(3) = rgb_sum(3) + spectral_color(3,i);
end

for i=1:3
white_balanced_image1_c(:,:,i) = (rgb_sum(1)/3/spectral_color(1,i))*demosaiced_image_1(:,:,i);
white_balanced_image2_c(:,:,i) = (rgb_sum(2)/3/spectral_color(2,i)).*demosaiced_image_2(:,:,i);
white_balanced_image3_c(:,:,i) = (rgb_sum(3)/3/spectral_color(3,i)).*demosaiced_image_3(:,:,i);
end

%%

figure("Name", "White-balanced Image1");
imshow(uint8(white_balanced_image1_c));
%saveas(gcf,'Figures/fig12.png');
figure("Name", "White-balanced Image2");
imshow(uint8(white_balanced_image2_c));
%saveas(gcf,'Figures/fig13.png');
figure("Name", "White-balanced Image3");
imshow(uint8(white_balanced_image3_c));
%saveas(gcf,'Figures/fig14.png');

%% Histogram equalization %%

hist_eq_image1 = hist_eq(white_balanced_image1_b);
hist_eq_image2 = hist_eq(white_balanced_image2_b);
hist_eq_image3 = hist_eq(white_balanced_image3_b);

%%

figure("Name", "Tone mapping using HistEq Image1");
imshow(hist_eq_image1);
%saveas(gcf,'Figures/fig15.png');
figure("Name", "Tone mapping using HistEq Image2");
imshow(hist_eq_image2);
%saveas(gcf,'Figures/fig16.png');
figure("Name", "Tone mapping using HistEq Image3");
imshow(hist_eq_image3);
%saveas(gcf,'Figures/fig17.png');

%% Tone mapping - Gamma correction gamma = 0.5 %%

gamma = 0.5;
tone_mapped_image1 = gamma_eq(white_balanced_image1_b, gamma);
tone_mapped_image2 = gamma_eq(white_balanced_image2_b, gamma);
tone_mapped_image3 = gamma_eq(white_balanced_image3_b, gamma);

%%
figure("Name", "Tone mapping using gamma correction Image1");
imshow(tone_mapped_image1);
%saveas(gcf,'Figures/fig18.png');
figure("Name", "Tone mapping using gamma correction Image2");
imshow(tone_mapped_image2);
%saveas(gcf,'Figures/fig19.png');
figure("Name", "Tone mapping using gamma correction Image3");
imshow(tone_mapped_image3);
%saveas(gcf,'Figures/fig20.png');

%% Tone mapping - Gamma correction gamma = 0.7 %%

gamma = 0.7;
tone_mapped_image1 = gamma_eq(white_balanced_image1_b, gamma);
tone_mapped_image2 = gamma_eq(white_balanced_image2_b, gamma);
tone_mapped_image3 = gamma_eq(white_balanced_image3_b, gamma);

%%
figure("Name", "Tone mapping using gamma correction Image1");
imshow(tone_mapped_image1);
%saveas(gcf,'Figures/fig21.png');
figure("Name", "Tone mapping using gamma correction Image2");
imshow(tone_mapped_image2);
%saveas(gcf,'Figures/fig22.png');
figure("Name", "Tone mapping using gamma correction Image3");
imshow(tone_mapped_image3);
%saveas(gcf,'Figures/fig23.png');

%% Tone mapping - Gamma correction gamma = 0.9 %%

gamma = 0.9;
tone_mapped_image1 = gamma_eq(white_balanced_image1_b, gamma);
tone_mapped_image2 = gamma_eq(white_balanced_image2_b, gamma);
tone_mapped_image3 = gamma_eq(white_balanced_image3_b, gamma);

%%
figure("Name", "Tone mapping using gamma correction Image1");
imshow(tone_mapped_image1);
%saveas(gcf,'Figures/fig24.png');
figure("Name", "Tone mapping using gamma correction Image2");
imshow(tone_mapped_image2);
%saveas(gcf,'Figures/fig25.png');
figure("Name", "Tone mapping using gamma correction Image3");
imshow(tone_mapped_image3);
%saveas(gcf,'Figures/fig26.png');

%% Denoising 

denoised_image1 = denoise(hist_eq_image1, 1078, 1128, 1, 50);
denoised_image2 = denoise(hist_eq_image2, 924, 984, 705, 765);
denoised_image3 = denoise(hist_eq_image3, 1, 50, 1, 50);

%%

figure("Name", "Denoised Image1");
imshow((denoised_image1));
%saveas(gcf,'Figures/fig27.png');
figure("Name", "Denoised Image2");
imshow((denoised_image2));
%saveas(gcf,'Figures/fig28.png');
figure("Name", "Denoised Image3");
imshow((denoised_image3));
%saveas(gcf,'Figures/fig29.png');
