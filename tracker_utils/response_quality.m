function [quality,maxpostion] = response_quality(response_input)
%according UPDT to compute the quality of response
    sz =size(response_input);
    ky = circshift(-floor((sz(1) - 1)/2) : ceil((sz(1) - 1)/2), [1, -floor((sz(1) - 1)/2)]);
    kx = circshift(-floor((sz(2) - 1)/2) : ceil((sz(2) - 1)/2), [1, -floor((sz(2) - 1)/2)])';
    [rs, cs] = ndgrid(ky,kx);
    d_r=1-exp(-0.5/sz(1)*(rs.^2 + cs.^2));%%∆(τ ) =1 − e..Unveiling the Power of Deep Tracking ---equation (2)
    [mc,mcid]= max(response_input(:));
    [mc_id1,mc_id2] = ind2sub(size(response_input),mcid);
    r_rc = (mc - response_input)./circshift(mc*d_r,[mc_id1-1,mc_id2-1]);
    quality = min(r_rc(:));
    maxpostion =[];
   % figure; mesh(r_rc);title('quality-cfnet-response');
end