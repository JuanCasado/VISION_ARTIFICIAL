% calculates Fourier inverse descriptors
function s = fourier_inv_descriptors(z, nd)
   
% S=fourier_inv_descriptors(Z,ND) calculates the Fourier inverse 
% descriptors of Z, which is a sequence of descriptors obtained by the 
% fourier_descriptors function.
% 
% ND is the number of descriptors used to calculate the inverse. It must be
% an odd integer less than length(Z). If omitted, it is assigned length(Z). 
% 
% The output, S, is an ND x 2 array containing the coordinates of a closed 
% edge.

      np = length(z);
      if nargin == 1 | nd > np
        nd = np;
      end
      x = 0:(np - 1);
      m = ((-1) .^ x)';
      d = round((np - nd)/2);
      z(1:d) = 0;
      z(np - d + 1:np) = 0;
      zz = ifft(z); % Inverse fast Fourier transform
      s(:, 1) = real(zz);
      s(:, 2) = imag(zz);
      s(:, 1) = m.*s(:, 1);
      s(:, 2) = m.*s(:, 2);
