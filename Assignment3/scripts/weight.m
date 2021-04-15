function w = weight(z)

    if z<=127
        w = z;
    else 
        w = 255 - z;
    end

end