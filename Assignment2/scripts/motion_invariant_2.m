function blurred_image = motion_invariant_2(image_fg, image_bg, vel, camera_motion)
    
    [M, N, ~] = size(image_fg);
    exposure_time = length(camera_motion);
    foreground = zeros(M, N+max(camera_motion), 3);
    foreground(:,1:N,:) = image_fg;
    channel = foreground(:, :, 1);
    [x_coords, y_coords] = find(channel>0);
    blurred_image = zeros(size(foreground));
    object = cast(channel(x_coords, y_coords), 'like', blurred_image);
    h = waitbar(0, "Performing motion blur...");
    for i = 1:exposure_time
        blurred_fg = zeros(size(channel));
        shift = (i-1)*vel - round(camera_motion(i));
        blurred_fg(x_coords, y_coords-shift) = object;
        background_tr = bilinear_interpolation(zero_pad(image_bg), camera_motion(i));
        merged_image = cast(merge(blurred_fg, background_tr), 'like', blurred_image);
        blurred_image = blurred_image+merged_image;
        waitbar((i)/exposure_time);
    end
    blurred_image = uint8(blurred_image/exposure_time);
    close(h);

end