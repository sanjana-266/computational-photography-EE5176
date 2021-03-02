function denoised_image = denoise(image, x1, x2, y1, y2)

denoised_image = image;
sigma_n = zeros(3);
sigma_r = zeros(3);
w = 5.5;
sigma_s = 2.5;

for i=1:3
    sigma_n(i) = std2(image(x1:x2,y1:y2,i));
    sigma_r(i) = 1.95*sigma_n(i);
    sigma = [sigma_s sigma_r(i)];
    denoised_image(:,:,i) = bfilter2(image(:,:,i),w,sigma);
end

end