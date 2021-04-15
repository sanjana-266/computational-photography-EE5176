%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          Programming assignment 3           %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%               CRF estimation                %%

addpath('scripts'); % helper functions folder

random_pixels = zeros(1000,2); % performing CRF estimation using random 1000 pixels
random_pixels(:,1) = randperm(4000, 1000);
random_pixels(:,2) = randperm(6000, 1000);

Z_r = zeros(1000, 16);
Z_g = zeros(1000, 16);
Z_b = zeros(1000, 16);

B = zeros(1,16);

for i=1:16
    B(i) = i-12;
end

for i=1:16
    image = imread(strcat(strcat('data/exposure',string(i)),'.jpg'));
    for j=1:1000
        Z_r(j, i) = image(random_pixels(j,1), random_pixels(j, 2), 1);
        Z_g(j, i) = image(random_pixels(j,1), random_pixels(j, 2), 2);
        Z_b(j, i) = image(random_pixels(j,1), random_pixels(j, 2), 3);
    end    
end

% CRF estimation
l = 1;
[g_r, ~] = gsolve(Z_r, B, l);
[g_g, ~] = gsolve(Z_g, B, l);
[g_b, ~] = gsolve(Z_b, B, l);

%% CRF plotting

x = [1:256];

figure();
stem(x, g_r);
title("g function for the red channel");
xlabel("z");
ylabel("g(z)");

figure();
stem(x, g_g);
title("g function for the green channel");
xlabel("z");
ylabel("g(z)");

figure();
stem(x, g_b);
title("g function for the blue channel");
xlabel("z");
ylabel("g(z)");

%% Loading the images 

image1 = imread('data/exposure1.jpg');
image2 = imread('data/exposure2.jpg');
image3 = imread('data/exposure3.jpg');
image4 = imread('data/exposure4.jpg');
image5 = imread('data/exposure5.jpg');
image6 = imread('data/exposure6.jpg');
image7 = imread('data/exposure7.jpg');
image8 = imread('data/exposure8.jpg');
image9 = imread('data/exposure9.jpg');
image10 = imread('data/exposure10.jpg');
image11 = imread('data/exposure11.jpg');
image12 = imread('data/exposure12.jpg');
image13 = imread('data/exposure13.jpg');
image14 = imread('data/exposure14.jpg');
image15 = imread('data/exposure15.jpg');
image16 = imread('data/exposure16.jpg');

%% Constructing the HDR Radiance Map

sum1_r = zeros(4000, 6000);
sum2_r = sum1_r;sum1_g = sum1_r;sum2_g = sum1_r;sum1_b = sum1_r;sum2_b = sum1_r;

for j=1:16
    eval(['image' '=image' num2str(j) ';']);
    sum1_r(:, :) = sum1_r(:, :) + double(weight(image(:, :, 1)));
    sum2_r(:, :) = sum2_r(:, :) + double(weight(image(:, :, 1))).*(g_r(image(:, :, 1)+1)-B(1, j));
    sum1_g(:, :) = sum1_g(:, :) + double(weight(image(:, :, 2)));
    sum2_g(:, :) = sum2_g(:, :) + double(weight(image(:, :, 2))).*(g_g(image(:, :, 2)+1)-B(1, j));
    sum1_b(:, :) = sum1_b(:, :) + double(weight(image(:, :, 3)));
    sum2_b(:, :) = sum2_b(:, :) + double(weight(image(:, :, 3))).*(g_b(image(:, :, 3)+1)-B(1, j));
end
hdr_image(:, :, 1) = 2.^(sum2_r./sum1_r);
hdr_image(:, :, 2) = 2.^(sum2_g./sum1_g);
hdr_image(:, :, 3) = 2.^(sum2_b./sum1_b);

%% Saving the HDR Radiance Map

% hdrwrite(hdr_image, 'figures/hdrmap.hdr');
% exrwrite(hdr_image, 'hdrimage.exr');

%% Photographic tonemapping

N = 4000*6000;
e = 0.001;
K = 0.5;
B = 0.85;
I_infty = 0; % setting this value to 1 makes I_white = infinity
I_tm = tone_map(hdr_image, e, K, B, N, I_infty);

% figure();
% imshow(I_tm);

% imwrite(I_tm, strcat('figures/hdr-tonemapped-', num2str(K),'.png'));
% imwrite(I_tm, strcat('figures/hdr-tonemapped-', num2str(K),'-', num2str(B),'.png'));