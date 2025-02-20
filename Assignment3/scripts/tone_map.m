function I_tm = tone_map(hdr_image, e, K, B, N, I_infty)

I_mHDR_r = exp(sum(log(hdr_image(:,:,1)+e),'all')/N);
I_mHDR_g = exp(sum(log(hdr_image(:,:,2)+e),'all')/N);
I_mHDR_b = exp(sum(log(hdr_image(:,:,3)+e),'all')/N);

I_barHDR_r = K*hdr_image(:,:,1)/I_mHDR_r;
I_barHDR_g = K*hdr_image(:,:,2)/I_mHDR_g;
I_barHDR_b = K*hdr_image(:,:,3)/I_mHDR_b;

I_w_r = B*max(I_barHDR_r, [], 'all');
I_w_g = B*max(I_barHDR_g, [], 'all');
I_w_b = B*max(I_barHDR_b, [], 'all');

if I_infty==1
    I_w_r = inf;
    I_w_g = inf;
    I_w_b = inf;
end
I_tm(:,:,1) = (I_barHDR_r.*(1+I_barHDR_r./(I_w_r^2)))./(1+I_barHDR_r);
I_tm(:,:,2) = (I_barHDR_g.*(1+I_barHDR_g./(I_w_g^2)))./(1+I_barHDR_g);
I_tm(:,:,3) = (I_barHDR_b.*(1+I_barHDR_b./(I_w_b^2)))./(1+I_barHDR_b);

end