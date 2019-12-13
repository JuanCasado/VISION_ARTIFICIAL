%% *Vision Artificial. GIEC.*
%% 	*Sistemas de Vision Artificial. GIC.*
% *Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos.* 
% 
% *Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 5: ejercicio 01 - Calibraci�n de una c�mara
% *Nota*: el tama�o del cuadrado del tablero de ajedrez es de *21 mil�metros*.
% 
% Step 1) Load data set.

close all;
clear all;

%% 
% Se pide:
%% 
% # Usa la aplicaci�n <https://es.mathworks.com/help/vision/ref/cameracalibrator-app.html 
% *Camera Calibrator*> para estimar los par�metros intr�nsecos, extr�nsecos y 
% de distorsi�n de la c�mara. Escriba |*cameraCalibrator*| en la l�nea de comandos 
% de Matlab o selecci�nelo en la pesta�a de Aplicaciones (APPS) de Matlab.

% Siga las instrucciones de este enlace para realizar la calibraci�n: <https://es.mathworks.com/help/vision/ug/single-camera-calibrator-app.html 
% https://es.mathworks.com/help/vision/ug/single-camera-calibrator-app.html>  
file = 'checkerboard_pattern';
square_size = 21;
cameraCalibrator(file, square_size);
%%
% *NOTA*: utilice una webcam y el patr�n del tablero de ajedrez o directamente 
% las im�genes de la carpeta "|*/chessboard_pattern*|". 
% # Una vez que se ha realizado una calibraci�n correcta, exporte los par�metros 
% de calibraci�n al espacio de trabajo (Workspace) con el nombre |*cameraParams*|.
sesion = 'calibrationSession.mat';
cameraCalibrator(sesion);
%%
% # Obtenga la matriz de par�metros intr�nsecos e identifique los distintos 
% par�metros. 
cameraParams.IntrinsicMatrix
%%
%Cargue una de las im�genes utilizadas para la calibraci�n y obtebga 
% los par�metros extr�nsecos de esta imagen. �si cargase otra imagen diferente 
% cambiar�a alguno de los par�metros intr�nsecos o extr�nsecos? justifique la 
% respuesta.
image_num = 1;
cameraParams.RotationMatrices(:,:,image_num)
cameraParams.TranslationVectors(image_num,:)
%%
% # Cargue una de las im�genes utilizadas para la calibraci�n y obtenga la imagen 
% no distorsionada con la funci�n |*undistorsionImage.*| 
close all;
image_num = 3;
image_name = sprintf('checkerboard_pattern/image%d.png',image_num);
image = imread(image_name);
imageUndistorted = undistortImage(image,cameraParams);
imshowpair(image,imageUndistorted,'montage')
%%
%Proyecte los puntos de 
% un cubo 3D en esta imagen no distorsionada usando la funci�n |*worldToImage*|. 
% Nota: uno de los v�rtices del cubo debe estar situado en el punto de las coordenadas 
% del mundo (X=0,Y=0,Z=0) y el tama�o del borde del cubo debe ser igual a dos 
% cuadrados del patr�n del tablero de ajedrez.
image_num = 7;
imagePoints = worldToImage(cameraParams,...
    cameraParams.RotationMatrices(:,:,image_num),...
    cameraParams.TranslationVectors(image_num,:),...
    [0 0 0;
     1 0 0;
     1 1 0;
     0 1 0;
     0 0 -1;
     1 0 -1;
     1 1 -1;
     0 1 -1]*42);
 image_name = sprintf('checkerboard_pattern/image%d.png',image_num);
 image = imread(image_name);
 figure;
 imshow(image)
 hold on;
 %Cuadrado superior
 plot([imagePoints(1, 1),imagePoints(2, 1)],[imagePoints(1, 2),imagePoints(2, 2)] , 'g*-', 'LineWidth', 3);
 plot([imagePoints(2, 1),imagePoints(3, 1)],[imagePoints(2, 2),imagePoints(3, 2)] , 'g*-', 'LineWidth', 3);
 plot([imagePoints(3, 1),imagePoints(4, 1)],[imagePoints(3, 2),imagePoints(4, 2)] , 'g*-', 'LineWidth', 3);
 plot([imagePoints(4, 1),imagePoints(1, 1)],[imagePoints(4, 2),imagePoints(1, 2)] , 'g*-', 'LineWidth', 3);
 
 plot([imagePoints(5, 1),imagePoints(6, 1)],[imagePoints(5, 2),imagePoints(6, 2)] , 'g*-', 'LineWidth', 3);
 plot([imagePoints(6, 1),imagePoints(7, 1)],[imagePoints(6, 2),imagePoints(7, 2)] , 'g*-', 'LineWidth', 3);
 plot([imagePoints(7, 1),imagePoints(8, 1)],[imagePoints(7, 2),imagePoints(8, 2)] , 'g*-', 'LineWidth', 3);
 plot([imagePoints(8, 1),imagePoints(5, 1)],[imagePoints(8, 2),imagePoints(5, 2)] , 'g*-', 'LineWidth', 3);
 
 plot([imagePoints(1, 1),imagePoints(5, 1)],[imagePoints(1, 2),imagePoints(5, 2)] , 'g*-', 'LineWidth', 3);
 plot([imagePoints(2, 1),imagePoints(6, 1)],[imagePoints(2, 2),imagePoints(6, 2)] , 'g*-', 'LineWidth', 3);
 plot([imagePoints(3, 1),imagePoints(7, 1)],[imagePoints(3, 2),imagePoints(7, 2)] , 'g*-', 'LineWidth', 3);
 plot([imagePoints(4, 1),imagePoints(8, 1)],[imagePoints(4, 2),imagePoints(8, 2)] , 'g*-', 'LineWidth', 3);
 hold off;
 

