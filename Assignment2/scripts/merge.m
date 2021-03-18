function merged_image = merge(fg_image, bg_image)

    r = bg_image(:,:,1);
    g = bg_image(:,:,2);
    b = bg_image(:,:,3);
    r(fg_image>0) = 0;
    g(fg_image>0) = 0;
    b(fg_image>0) = 0;
    merged_image = cat(3, r, g, b);
    merged_image(fg_image>0) = fg_image(fg_image>0);

end