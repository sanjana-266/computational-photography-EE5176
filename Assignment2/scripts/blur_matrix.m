function A = blur_matrix(code, N)

    exp_length = length(code);
    A = zeros(N+exp_length-1, N);
    for i=1:N
        
         A(i:i+exp_length-1, i) = code;
   
    end
end