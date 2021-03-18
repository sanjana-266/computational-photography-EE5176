function zero_padded_image = zero_pad(image)

    [M, N, K] = size(image);
    zero_padded_image = zeros(M, N+2, K);
    zero_padded_image(:,2:N+1,:) = image;
end