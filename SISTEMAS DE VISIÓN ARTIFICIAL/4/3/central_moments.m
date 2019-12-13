function [mom] = central_moments(inimage, maxorder)

[xpos, ypos, val] = find(im2double(inimage));

mom(1,1) = sum(val);

if (mom(1,1) == 0)
   mom = zeros(maxorder+1);
   return;
end

x0 = sum(xpos.*val)/mom(1,1);
y0 = sum(ypos.*val)/mom(1,1);

for xpow = 0:maxorder
   for ypow = 0:maxorder
     mom(xpow+1, ypow+1) = sum( ( (xpos - x0).^xpow ).*( (ypos - y0).^ypow).*val );
   end
end 
