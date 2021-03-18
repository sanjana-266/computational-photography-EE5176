%% Part 1 - reading data%%

image = imread('data/fish.png');
image = uint8(image);

noise = load('data/gaussNoise.mat');
n = noise.gaussNoise;

background_image = imread('data/background.png');
background_image = uint8(background_image);

redcar_image = imread('data/redcar.png');
redcar_image = uint8(redcar_image);

%% Q1 - Generation of blurred image

exp_length = 52;
code = ones(exp_length,1);
blurred_image = blur(image, exp_length, n, code);
blurred_image_noiseless = blur(image, exp_length, 0, code);

figure("Name", "Fish image blurred");
imshow(blurred_image);

%% Q1 - Blur matrix formation

N = size(image,2);
A = blur_matrix(code, N);
figure("Name", "Blur matrix");
imshow(A);

%% Q1 - Deblurring 

A = A/sum(code);
A_inv = A/(A'*A);
A = A*sum(code);

[M, N, ~] = size(image);
deblurred_image = zeros(M, N, 3);

for i=1:3
    deblurred_image(:,:,i) = cast(blurred_image(:, :, i), 'like', A_inv)*A_inv;
end

figure("Name", "Fish image deblurred using least squares");
imshow(uint8(deblurred_image));

%% Q1 - RMSE

rmse = sqrt(mean((uint8(deblurred_image)-image).^2, 'all'));

%% Q1 - Deblurring a noiseless image

[M, N, ~] = size(image);
deblurred_image = zeros(M, N, 3);

for i=1:3
    deblurred_image(:,:,i) = cast(blurred_image_noiseless(:, :, i), 'like', A_inv)*A_inv;
end

figure("Name", "Noiseless fish image deblurred using least squares");
imshow(uint8(deblurred_image));

%% Q2 - Flutter shutter

code = load('data/codeSeq.mat').codeSeq;
blurred_image_2 = blur(image, exp_length, n, code);
blurred_image_2_noiseless = blur(image, exp_length, 0, code);

figure("Name", "Fish image blurred (Flutter Shutter)");
imshow(uint8(blurred_image_2));

%% Q2 - Blur matrix formation 

N = size(image,2);
A_flutter = blur_matrix(code, N);
figure("Name", "Blur matrix (Flutter Shutter)");
imshow(A_flutter);

%% Q2 - Deblurring 

A_flutter = A_flutter/sum(code);
A_inv = A_flutter/(A_flutter'*A_flutter);
A_flutter = A_flutter*sum(code);
[M, N, ~] = size(image);
deblurred_image = zeros(M, N, 3);

for i=1:3
    deblurred_image(:,:,i) = uint8(cast(blurred_image_2(:, :, i), 'like', A_inv)*A_inv);
end

figure("Name", "Fish image deblurred (Flutter Shutter)");
imshow(uint8(deblurred_image));

%% Q2 - DFT
dft_trad = A(:, 1);
dft_flutter = A_flutter(:, 1);
y = fft(dft_trad);
y1 = fft(dft_flutter);
n = ceil(length(y)/2);
m = log(abs(y));
m1 = log(abs(y1));
figure("Name","Frequency responses");
plot(m(1:n));
hold on;
plot(m1(1:n));
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);

xlabel("Frequency");
ylabel("DFT coefficients in dB");
legend('conventional', 'flutter shutter');

%% Q2 - Noiseless deblurring

[M, N, ~] = size(image);
deblurred_image = zeros(M, N, 3);

for i=1:3
    deblurred_image(:,:,i) = cast(blurred_image_2_noiseless(:, :, i), 'like', A_inv)*A_inv;
end

figure("Name", "Noiseless fish image deblurred (Flutter Shutter)");
imshow(uint8(deblurred_image));

%% Q3 - Motion invariant photography - static camera, moving object

vel = 1;
st_cam_blurredimage = motion_invariant_1(redcar_image, background_image, vel, 52);

figure("Name", "Image blurred due to motion of the object");
imshow(st_cam_blurredimage);

%% Q3 - Motion invariant photography - parabolically moving camera, moving object

camera_motion = load('data/CameraT.mat').CameraT;
vel = [1, 2, 3];
mip_blurred_image1 = motion_invariant_2(redcar_image, background_image, vel(1), camera_motion);
mip_blurred_image2 = motion_invariant_2(redcar_image, background_image, vel(2), camera_motion);
mip_blurred_image3 = motion_invariant_2(redcar_image, background_image, vel(3), camera_motion);


figure("Name", "Image captured using Motion Invariant Photography (vel of car = 1pix/s)");
imshow(uint8(mip_blurred_image1));
figure("Name", "Image captured using Motion Invariant Photography (vel of car = 2pix/s)");
imshow(uint8(mip_blurred_image2));
figure("Name", "Image captured using Motion Invariant Photography (vel of car = 3pix/s)");
imshow(uint8(mip_blurred_image3));

%% Q3 - Blur matrix 

code = zeros(53,1);
code(1) = 0.1; code(2:53) = [1:52];
code = (13./code).^(0.5);

figure();
x = [1:53];
code = code/max(code);
stem(x,code);

A_motionblur = blur_matrix(transpose(code), 600);
figure("Name", "Blur matrix (Motion Invariant Photography)");
imshow(A_motionblur);

A_motionblur = A_motionblur/sum(code);
A_inv = A_motionblur/(A_motionblur'*A_motionblur);
A_motionblur = A_motionblur*sum(code);

%% Q3 - Deblurring 

[M, N, ~] = size(redcar_image);
deblurred_image = zeros(M, N, 3);

for i=1:3
    deblurred_image(:,:,i) = cast(mip_blurred_image1(:, :, i), 'like', A_inv)*A_inv;
end

figure("Name", "Deblurred image captured using Motion Invariant Photography");
imshow(uint8(deblurred_image));

