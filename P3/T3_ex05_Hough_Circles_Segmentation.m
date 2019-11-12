%% *Vision Artificial. GIEC.*
%% *	Sistemas de Vision Artificial. GIC.*
% *	Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos. *
% 
% *  Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Topic 3: exercise 05 
%% *Segmentaci�n basada en bordes, an�lisis global (c�rculos).*
% Lea la imagen en el espacio de trabajo y m�estrela.

I = imread('circlesBrightDark.png'); 
imshow(I)
%% 
% Defina el rango de radios.

Rmin = 30; 
Rmax = 65;
%% 
% Encuentre todos los c�rculos claros en la imagen dentro del rango de radio 
% usando la funci�n |*imfindcircles|* .

[centersBright, radiiBright] = imfindcircles(I,[Rmin Rmax],'ObjectPolarity','bright');
[centersDark, radiiDark] = imfindcircles(I,[Rmin Rmax],'ObjectPolarity','dark');
%% 
% Dibuja l�neas azules alrededor de los bordes de los c�rculos claros.

viscircles(centersBright, radiiBright,'Color','b');
viscircles(centersDark, radiiDark,'Color','r');
%% 
% 
% 
% Se pide:
% 
% # Encuentre todos los c�rculos oscuros en la imagen y dib�jelos.
% # Cargue la imagen |*'tape.png'|* y estime el radio del rollo de cinta que 
% se ve en la imagen .

RGB = imread('tape.png');
imshow(RGB);
Rmin = 50;Rmax = 85;
[centersExt, rExt] = imfindcircles(RGB,[Rmin Rmax],'ObjectPolarity','bright');
viscircles(centersExt, rExt,'Color','b');
Rmin = 30;Rmax = 75;
[centerMed, rMed] = imfindcircles(RGB,[Rmin Rmax],'ObjectPolarity','bright');
viscircles(centerMed, rMed,'Color','b');
Rmin = 20;Rmax = 45;
[centerInt, rInt] = imfindcircles(RGB,[Rmin Rmax],'ObjectPolarity','dark');
viscircles(centerInt, rInt,'Color','r');

display(strcat("Circulo exterior: ", num2str(rExt)))
display(strcat("Circulo medio: ", num2str(rMed)))
display(strcat("Circulo interior: ", num2str(rInt)))