function [mom] = general_moments(inimage, maxorder)

[xpos, ypos, val] = find(im2double(inimage));

for xpow = 0 : maxorder
   for ypow = 0 : maxorder
     mom(xpow+1, ypow+1) = sum( ( xpos.^xpow ) .* ( ypos.^ypow) .* val );
   end
end 
