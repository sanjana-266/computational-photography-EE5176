function image = bilinear_interpolation(image_, shift)

    [M, N, K] = size(image_);
    N = N-2;
    image = zeros(M, N+52, K);
    shift_round = round(shift);
    a = shift - shift_round;
    for j=1:N+shift_round
        if j>shift_round
            image(:,j,:) = (1-a)*image_(:,j-shift_round,:) + a*image_(:,j-shift_round+1,:);
        end     
    end
end