%% *Vision Artificial. GIEC.*
%% *Vision Artificial. GIEC.*
%% 	*Sistemas de Vision Artificial. GIC.*
% *Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos.* 
% 
% *Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 4.2: ejercicio 05  - Local Features
% El objetivo de esta pr�ctica es mostrar el potencial de los demonimados "Local 
% Feature", para ello se va a buscar un objeto dentro de una escena utilizando 
% los detectores y descriptores de caracteristicas locales.

clear all
close all
%% 
% Step 1) Leer la imagen de referencia que contiene el objeto de inter�s.

%Object1Image = imread('elephant.jpg');
Object1Image = imread('stapleRemover.jpg');
%Object1Image = rgb2gray(imread('robot1.jpeg'));
%Object1Image = rgb2gray(imread('robot2.png'));
%Object1Image = rgb2gray(imread('croped.jpg'));
 
figure;
imshow(Object1Image);
title('Image of an Object1');
%% 
% Se lee la escena que contiene al objeto de inter�s

sceneImage = imread('clutteredDesk.jpg');
%sceneImage = rgb2gray(imread('various_robots1.jpg'));
%sceneImage = rgb2gray(imread('various_robots2.png'));
%sceneImage = rgb2gray(imread('various_robots3.jpg'));

figure; 
imshow(sceneImage);
title('Image of a Cluttered Scene');
%% 
% Step 2) Se detectan las caracter�sticas locales del objeto y de la escena

% Detect feature points in both images.

Object1Points = detectBRISKFeatures(Object1Image);scenePoints = detectBRISKFeatures(sceneImage);
%Object1Points = detectFASTFeatures(Object1Image);scenePoints = detectFASTFeatures(sceneImage);
%Object1Points = detectHarrisFeatures(Object1Image);scenePoints = detectHarrisFeatures(sceneImage);
%Object1Points = detectMinEigenFeatures(Object1Image);scenePoints = detectMinEigenFeatures(sceneImage);
%Object1Points = detectMSERFeatures(Object1Image);scenePoints = detectMSERFeatures(sceneImage);
%Object1Points = detectORBFeatures(Object1Image);scenePoints = detectORBFeatures(sceneImage);
%Object1Points = detectSURFFeatures(Object1Image);scenePoints = detectSURFFeatures(sceneImage);
%Object1Points = detectKAZEFeatures(Object1Image);scenePoints = detectKAZEFeatures(sceneImage);


%% 
% se visualizan los puntos m�s fuertes que se encuentran en la imagen del objeto 
% de referencia

figure; 
imshow(Object1Image);
title('100 Strongest Feature Points from Object1 Image');
hold on;
plot(selectStrongest(Object1Points, 100));
%% 
% se visualizan los puntos m�s fuertes que se encuentran en la imagen de la 
% escena

figure; 
imshow(sceneImage);
title('300 Strongest Feature Points from Scene Image');
hold on;
plot(selectStrongest(scenePoints, 300));
%% 
% Step 3) Se extraen los descriptores de caracter�sitcas de ambas im�genes

[Object1Features, Object1Points] = extractFeatures(Object1Image, Object1Points);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);
%% 
% Step 4) Se encuentran las coincidencias (Matches) y se visualizan

Object1Pairs = matchFeatures(Object1Features, sceneFeatures, 'MatchThreshold', 80, 'MaxRatio', 0.6);
%Object1Pairs = matchFeatures(Object1Features, sceneFeatures, 'MaxRatio', 1);
%Object1Pairs = matchFeatures(Object1Features, sceneFeatures, 'Method', 'Exhaustive');

matchedObject1Points = Object1Points(Object1Pairs(:, 1), :);
matchedScenePoints = scenePoints(Object1Pairs(:, 2), :);
figure;
showMatchedFeatures(Object1Image, sceneImage, matchedObject1Points, ...
    matchedScenePoints, 'montage');
title('Putatively Matched Points (Including Outliers)');
%% 
% Step 5) Se localiza el objeto en la escena usando las coincidencias. 
% 
% |*estimateGeometricTransform*| calcula la transformaci�n relacionando los 
% puntos coincidentes, a la vez que elimina los valores outliers. Esta transformaci�n 
% nos permite localizar el objeto en la escena.

[tform, inlierObject1Points, inlierScenePoints] = estimateGeometricTransform(matchedObject1Points, matchedScenePoints, 'affine', 'Confidence', 99, 'MaxDistance', 2);

figure;
showMatchedFeatures(Object1Image, sceneImage, inlierObject1Points, inlierScenePoints, 'montage');
title('Matched Points (Inliers Only)');
%% 
% Se obtiene el pol�gono delimitador de la imagen de referencia.

Object1Polygon = [1, 1;...                           % top-left
        size(Object1Image, 2), 1;...                 % top-right
        size(Object1Image, 2), size(Object1Image, 1);... % bottom-right
        1, size(Object1Image, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon 
%% 
% Se transforma el pol�gono en el sistema de coordenadas de la imagen de destino. 
% El pol�gono transformado indica la ubicaci�n del objeto1 en la escena.

newObject1Polygon = transformPointsForward(tform, Object1Polygon);    

figure;
imshow(sceneImage);
hold on;
line(newObject1Polygon(:, 1), newObject1Polygon(:, 2), 'Color', 'y');
title('Detected Object1');
%% 
% Se pide:
%% 
% # Repita el proceso anterior pero buscando otro objeto de la escena, en este 
% caso la caja, cuya imagen es |*'stapleRemover.jpg'*|. Adem�s utilice el detector 
% y descriptor BRISK (<https://es.mathworks.com/help/vision/ref/detectbriskfeatures.html 
% |detectBRISKFeatures|>).