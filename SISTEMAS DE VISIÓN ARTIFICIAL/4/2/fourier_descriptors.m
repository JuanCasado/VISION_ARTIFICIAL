% calculates Fourier descriptors
function z = fourier_descriptors(s)

%   Z = fourier_descriptors(S) calculates the Fourier descriptors of
%   S, which is a sequence of coordinates of a contour of size np x 2  
%   that describes the edge of an object.
%
%   Due to the symmetry cosiderations imposed when working with 
%   Fourier inverse descriptors, the number of S points when calculating 
%   the descriptors must be odd.     
      
      [np, nc] = size(s);
      if nc ~= 2
        error('S must be of size np-by-2.');
      end
      
%   If the number of S points is even, the function doubles the end 
%   point and adds it to the end of the sequence.
      if np/2 ~= round(np/2)
        s(end + 1, :) = s(end, :);
        np = np + 1;
      end
      
      x = 0 : (np - 1);
      m = ((-1) .^ x)';
      s(:, 1) = m .* s(:, 1);
      s(:, 2) = m .* s(:, 2);
      s = s(:, 1) + 1i*s(:, 2);
      z = fft(s); % fast Fourier transform