function hist_eq_image = hist_eq(image)

    hsv = rgb2hsv(image);
    v1 = histeq(hsv(:,:,3));
    h = hsv(:,:,1);
    s = hsv(:,:,2);
    v = v1;
    hsv_f = cat(3,h,s,v);
    hist_eq_image = hsv2rgb(hsv_f);
    
end