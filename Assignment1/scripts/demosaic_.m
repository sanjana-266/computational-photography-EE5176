function demosaiced_image = demosaic_(image, bayer, method)
    
    h = waitbar(0,'Applying interpolation...');

    image = double(image);
    [y, x] = size(image(:,:,1));
    intY = 1:y;
    intX = 1:x;
    [X, Y] = meshgrid(intX, intY);
    
    interZ_red = griddata(X(bayer==1), Y(bayer==1), image(bayer==1), X, Y, method);
    
    waitbar(1/3);
    
    interZ_green = griddata(X(bayer==2), Y(bayer==2), image(bayer==2), X, Y, method);

    waitbar(2/3);
    
    interZ_blue = griddata(X(bayer==3), Y(bayer==3), image(bayer==3), X, Y, method);
    
    waitbar(3/3);
    
    demosaiced_image = zeros(y,x,3);
    demosaiced_image(:,:,1) = interZ_red;
    demosaiced_image(:,:,2) = interZ_green;
    demosaiced_image(:,:,3) = interZ_blue;
    
    close(h);
end
