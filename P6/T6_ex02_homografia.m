%% *Vision Artificial. GIEC.*
%% *Sistemas de Vision Artificial. GIC.*
% *Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos.* 
% 
% *Departamento de Electr�nica. Universidad de Alcal�. SPAIN.*
% 
% 
%% Topic 6: exercise 02 - Correcci�n de la Perspectiva con Homograf�a
% Para corregir la perspectiva de un objeto es necesario estimar la transformaci�n 
% de la perspectiva. Cuatro pares de puntos correspondientes son suficientes para 
% recuperar una transformaci�n de perspectiva entre dos im�genes. El objetivo 
% de esta pr�ctica es correjir la perspectiva de la carta de la imagen "|*card.jpg*|",
% 
% Step 1) Load image.

clear all;
close all;

%%
% Read original image.
I = imread('card.jpg');
figure;imshow(I);
%% 
% 
% 
% Step 2) Click on the four corners.

% NOTE: impixel 
% Use normal button clicks to select pixels. 
% Press Backspace or Delete to remove the previously selected pixel. 
% To add a final pixel and finish pixel selection in one step, press shift-click, or right-click or double-click. 
% To finish selecting pixels without adding a final pixel, press Return.
[x, y , P] = impixel(I);
srcPoints = [x y];
%% 
% 
% 
% Step 3) Projected four points

scale = 2;
card_w = 67*scale;
card_h = 100*scale;
hPoints = [0      0;
           0      card_w
           card_h card_w
           card_h 0];
vPoints = [0      0;
           card_h 0;
           card_h card_w
           0      card_w];
%% 
% 
% 
% Step 4) Estimate the perspective transformation (Homography)    

htransform = estimateGeometricTransform(srcPoints, hPoints, 'similarity');
vtransform = estimateGeometricTransform(srcPoints, vPoints, 'similarity');

%% 
% 
% 
% Step 5) Apply the perspective transformation

htransformedI = imwarp (I, htransform);
figure;imshow(htransformedI);
vtransformedI = imwarp (I, vtransform);
figure;imshow(vtransformedI);

%% 
% Se pide: 
%% 
% # Cargue la imagen "|*card.jpg*|". Haga clic en las cuatro esquinas de la 
% tarjeta para obtener los primeros cuatro puntos utilizando la funci�n |*impixel*|. 
% Nota: utilice el siguiente orden para obtener los cuatro puntos: 1) Esquina 
% superior izquierda, 2) Esquina superior derecha, 3) Esquina inferior derecha, 
% 4) Esquina inferior izquierda.

% # Calcule los cuatro puntos de la carta de p�quer sin distorsi�n de perspectiva, 
% teniendo en cuenta que una carta de p�quer tiene un tama�o de |67 mm| por |100 
% mm| aproximadamente.
% # Estime la transformaci�n de la perspectiva utilizando la funci�n |*estimateGeometricTransform*|.
% # Aplicar la transformaci�n de perspectiva utilizando la funci�n |*imwarp*|.
%% 
% 
% 
% 
% 
%