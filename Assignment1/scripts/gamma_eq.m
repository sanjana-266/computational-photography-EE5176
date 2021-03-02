function gamma_eq_image = gamma_eq(image, gamma)

    hsv = rgb2hsv(image);
    v1 = histeq(hsv(:,:,3));
    h = hsv(:,:,1);
    s = hsv(:,:,2);
    v = power(double(v1),gamma);
    hsv_f = cat(3,h,s,v);
    gamma_eq_image = hsv2rgb(hsv_f);
    
end