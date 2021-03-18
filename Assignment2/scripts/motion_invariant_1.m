function blurred_image = motion_invariant_1(foreground, background, vel, exposure_time)
    channel = foreground(:, :, 1);
    [x, y] = find(channel>0);
    blurred_image = zeros(size(foreground));
    object = cast(channel(x, y), 'like', blurred_image);
    h = waitbar(0, "Performing motion blur...");
    for i = 1:exposure_time
        blurred_fg = zeros(size(channel));
        blurred_fg(x, y+(i-1)*vel) = object;
        merged_image = cast(merge(blurred_fg, background), 'like', blurred_image);
        blurred_image = blurred_image+merged_image;
        waitbar((i)/exposure_time);
    end
    blurred_image = uint8(blurred_image/exposure_time);
    close(h);
end