function blurred_image = blur(image, exp_length, noise, code)

    M = size(image,1);
    N = size(image,2);
    blurred_image = zeros(M, N+exp_length-1, 3);
    
    for i=1:exp_length
        if code(i)==1
        blurred_image(:,i:N+i-1,:) = cast(image, "like", blurred_image)+blurred_image(:,i:N+i-1,:);
        end
    end
    length = sum(code);
    blurred_image = cast(blurred_image/length,"like",noise)+noise;
    blurred_image = uint8(blurred_image);
end