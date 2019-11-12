%% *Vision Artificial. GIEC.*
%% *	Sistemas de Vision Artificial. GIC.*
% *	Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos. *
% 
% *  Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 3: ejercicio 04 
%% *Segmentaci�n basada en bordes, an�lisis global (l�neas).*
% En este ejemplo se muestra c�mo detectar l�neas en una imagen mediante la 
% transformada de H|ough.|
% 
% La transformada de Hough est� dise�ada para detectar l�neas, utilizando 
% la representaci�n param�trica de la recta:
% 
% |rho = x*cos(theta) + y*sin(theta)|
% 
% La variable (rho) es la distancia desde el origen a la l�nea a lo largo 
% de un vector perpendicular y (theta) es el �ngulo entre el eje x y este vector, 
% tal y como se muestra en la figura 1. La funci�n genera una matriz de espacio 
% de par�metros cuyas filas y columnas corresponden a estos valores.
% 
% 
% 
% Figura 1.

close all;
clear all;
clc;
%% 
% Lee una imagen en el espacio de trabajo y la convierte a escala de gris, 
% si es necesario.

filename = 'gantrycrane.png'
%filename = 'circuit.png';
info = imfinfo(filename);
if strcmp(info.ColorType,'indexed')
    [X,map] = imread(filename);
    I = ind2gray(X,map);
elseif strcmp(info.ColorType,'truecolor')
    rgb=imread(filename);
    I=rgb2gray(rgb);
else
    I=imread(filename);
end

imshow(I)
title('Imagen original (BW)');
%% 
% Encuentra los bordes en la imagen usando la funci�n |*edge*|
%%
BW = edge(I,'canny');
imshow(BW);
title('Imagen de bordes');
%% 
% Calcula la transformada de Hough de la imagen binaria devuelta por |*edge|*.
%%
angles = [(-90:0.5:89)];
[H, theta, rho] = hough(BW,'Theta',angles);
%% 
% Muestra la transformaci�n, devuelta por la funci�n |*hough|*.
%%
figure
imshow(imadjust(rescale(H)),'XData',theta,'YData',rho,'InitialMagnification','fit');
title('Hough Transform array');
xlabel('\theta (degrees)'); 
ylabel('\rho (pixels)'); 
axis on, axis normal;
colormap(gca,hot)
colorbar
%% 
% Despu�s de calcular la transformaci�n Hough, puede utilizar la funci�n 
% |*houghpeaks|* para buscar valores m�ximos en el espacio de par�metros. Estos 
% picos representan l�neas potenciales en la imagen de entrada.
% 
% Encuenta los picos en la matriz de transformaci�n Hough.
%%
th = ceil(0.1*max(H(:))); % umbral de b�squeda
max_peaks = 10; % n�mero m�ximo de picos a encontrar

P = houghpeaks(H, max_peaks, 'threshold', th, 'Theta', angles)
%% 
% Marque en la imagen H de la transformada los picos P obtenidos.
%%
x = theta(P(:,2)); 
y = rho(P(:,1)); 
hold on;
plot(x,y,'*','color','blue');
hold off;
%% 
% Despu�s de identificar los picos de la transformada de Hough, puede utilizar 
% la funci�n |*houghlines* |para encontrar los puntos finales de los segmentos 
% de l�nea correspondientes a los picos de la transformada de Hough. Esta funci�n 
% rellena autom�ticamente peque�os huecos en los segmentos de l�nea.
% 
% Buscar l�neas en la imagen utilizando la funci�n houghlines
%%
lines = houghlines(BW, theta, rho, P, 'FillGap', 20, 'MinLength',5);
%% 
% Cree un trazado que muestre la imagen original con las l�neas superpuestas.
%%
figure, 
imshow(I), 
hold on 


for k = 1:length(lines)    
    xy = [lines(k).point1; lines(k).point2];    
    % dibuja las rectas
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');     
    % marca con una cruz el inicio y final de las rectas
    plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');    
    plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');     
end 
%% 
% Se pide:
% 
% # Calcule el n�mero de picos |*length(P)|* y el n�mero de l�neas |*length(lines)|* 
% obtenidas. �Son iguales o diferentes? �por qu�?

% En general si, pues a partir de cada punto de P se generá un línea con el
% rho y la theta por el punto indicadas. No obstante ya que en houghlines
% podemos indicar una longitud de línea mínima podemos forzar a que no sean
% iguales poniendo un valor excesivamente alto.

%%
% # �por qu� s�lo se representan rectas horizontales? Realice cambios para representar 
% rectas en otros �ngulos y dib�jelas. 

% Para cambiar el ángulo en el que queremos obtener las rectas debemos
% modigicar la variable angles que afecta a las funciones hough y
% houghpeaks. 
% angles expresa el rango válido de los ángulos que queremos obtener, si el
% ángulo va desde [-90, 90) tomaremos todos los ángulos, si este este toma
% solo ángulos próximos a 0 nos quedaremos solo con las líneas verticales,
% por el contrario si nos quedamos con los extremos del rango obtendremos
% las líneas horizontales.

%%
% # Cambie el c�digo para obtener s�lo la mejor recta (la que tenga una mayor 
% valor en la transformada de Hough) para el siguiente rango de �ngulos [40, 
% 50].
% 
% Para hacer esto debemos modificar la variable angles para dejarla tomando
% valores de ángulos en el rango de [40, 50).
% Tras hacer esto debemos cambiar la variable max_peacks  (y poneral a 1) para
% controlar la cantidad de puntos que se eligen del espacio de hough para
% que nos devuelva solo el mejor.
% Por último ajustaremos el parámetro FillGap para que la línea se rellene 
% hasta que solo nos sea devuelta una y no esa misma partida por la mitad.


