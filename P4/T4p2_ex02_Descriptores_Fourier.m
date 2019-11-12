%% 	*Vision Artificial. GIEC.*
%% 	*Sistemas de Vision Artificial. GIC.*
% *Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos.* 
% 
% *Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 4.2: ejercicio 02  - Descriptores de Fourier
% El objetivo de la pr�ctica es calcular los descriptores de Fourier de todos 
% los objetos de una imagen y utilizar s�lo los m�s significativos de cada objeto 
% para reconstruirlos.
% 
% Step 1) Read Image

close all
clear all

imgOriginal = imread('google.jpg');
figure;
imshow(imgOriginal);
title('Original image');
%% 
% Step 2) Threshold the Image

if size(imgOriginal,3) == 3
    imgOriginal = rgb2gray(imgOriginal); 
end
imgBW = imbinarize(imgOriginal);
imgBW = imcomplement(imgBW);

figure;
imshow(imgBW);
title('binarized image');
%% 
% Step 4) Find the Boundaries

[B,L] = bwboundaries(imgBW,'noholes');
figure
imshow(label2rgb(L, @jet, [1.0 1.0 1.0]))
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'g', 'LineWidth', 4);
end  
hold off
%% 
% Step 5)  Fourier descriptors 

descriptor_percentage = 0.03;

imshow(label2rgb(L, @jet, [1.0 1.0 1.0]))
hold on
for k = 1:length(B)
   boundary = B{k};
   descriptor = fourier_descriptors(boundary);
   len_descriptor = size(descriptor)*descriptor_percentage;
   boundary_recovered = fourier_inv_descriptors(descriptor, len_descriptor);
   plot(boundary_recovered(:,2), boundary_recovered(:,1), 'g', 'LineWidth', 4);
end
hold off
%% 
% Se pide: 
%% 
% # Utilizando la funci�n |*fourier_descriptors()*| (paso 5), obtenga los descriptores 
% Fourier de cada uno de los objetos etiquetados.
% # Obtenga los contornos reconstruidos de los objetos etiquetados a partir 
% de descriptores inversos de Fourier utilizando la funci�n *fourier_inv_descriptors().* 
% Utilize el 10% de los descriptores para la reconstrucci�n y dibuje el contorno 
% recuperado.
% # Reduzca el n�mero de descriptores utilizados para la reconstrucci�n a 5% 
% y 2% y obtenga conclusiones.
%% 
%