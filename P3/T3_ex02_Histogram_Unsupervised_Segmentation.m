%% *Vision Artificial. GIEC.*
%% *	Sistemas de Vision Artificial. GIC.*
% *	Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos. *
% 
% *  Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 3: ejercicio 02
%% *Segmentaci�n no supervisada lineal, kmeans*
%  
% 
% El objetivo de este ejercicio es segmentar de forma no supervisada los 
% distintos objetos de una imagen. Las t�cnicas de segmentaci�n no supervisada 
% funcionan de forma autom�tica, es decir, sin requerir la intervenci�n por parte 
% del usuario. 
% 
% El siguiente ejemplo inicializa los centroides (medias de nivel de gris) 
% de los dos tipos de objetos de la imagen '|*coins.png|*' aleatoriamente y tras 
% un proceso de entrenamiento se ajustan los valores de los centroides hacia un 
% valor que tender� a ser la media de los niveles de gris de las clases prototipo 
% presentes en la imagen. El proceso de entrenamiento, b�sicamente, va testeando 
% p�xeles de la imagen y actualizando los centroides en funci�n de su distancia 
% al p�xel testeado. Este proceso se repite a lo largo de una serie de iteraciones 
% hasta que la posici�n de los centroides no cambia, pr�cticamente, de una iteraci�n 
% a la siguiente.
% 
% Posteriormente, se clasifica cada p�xel de la imagen en funci�n de su nivel 
% de gris por distancia a los centroides obtenidos tras el proceso de entrenamiento:  
% *segmentaci�n lineal.*
% 
%       Recuerde que la distancia Eucl�dea _*d_* entre dos puntos (definidos 
% en un espacio M-dimensional) *x*= [x1, x2... xM] e *y* = [y1, y2... yM], que 
% determina la longitud de la l�nea recta que unir�a ambos puntos, se define como:
% 
% $$d=\sqrt{{\left(x_1 -y_1 \right)}^2 +{\left(x_2 -y_2 \right)}^2 +\cdots 
% +{\left(x_M -y_M \right)}^2 }$$      
% 
%             En nuestro caso, trabajamos en el espacio de los niveles de 
% gris (espacio de una dimensi�n) hallando la distancia entre un nivel de gris 
% y otro.

clear all;
close all;
clc;

filename = 'circlesBrightDark.png'; 
I_orig = imread(filename);
info = imfinfo(filename);
I_levels = 256;
I = I_orig;
imshow(I)
%% 
% Clustering

% Histograma
[H, bins] = imhist(I); 

% numero de clusters o centroides (k >= 2) (igual al numero de clases)
k = 3;
% posicion inicial de los centroides de las clases (neuronas)
CC = rand(1,k) * I_levels;

% Visualizacion de la posicion inicial de los centroides
figure,
imhist(I),
hold on,
plot(CC, zeros(1,k),'mo','LineWidth',3); 
title('posici�n inicial de los centroides de las clases sin entrenar');
hold off; 	
%% 
% bucle de entrenamiento para obtener los valores de los centroides que 
% tiendan a ser las medias de los niveles de gris de las clases

CCpre = CC; % posicion inicial de los centroides de las clases
t = 0; % Variable temporal del bucle 
T_max = 10; % n� m�ximo de iteraciones
error = 1; % Error medio
error_max = 0.001; % Error maximo permitido
vI=(I(:));

while ((error > error_max) && (t < T_max))   %Entrenamiento de los centroides
    t=t+1;
    % Se calcula la distancia de los bins a los centroides de las clases
    d = dist(bins, CC); 
    % En "ind" se tiene la etiqueta i=1,2...,k de la clase en funcion de la distancia 
    % al centroide de la clase 1,2...,k
    [dmin, ind] = min(d,[],2);
    % Se actualizan los centroides 
    for i=1:k
        idx = find(ind==i);
        CC(i) = sum(H(idx).*bins(idx))/sum(H(idx));
    end
    error = sum (abs(CC - CCpre));
    CCpre = CC;	
end

if (error <= error_max)
    display(strcat("Resultado válido, error: ", num2str(error)))
elseif(t >= T_max)
    display(strcat("Resultado NO válido, error: ", num2str(error)))
end
    
%% 
% Fin del bucle de entrenamiento con nuevos centroides en CC. Visualizacion 
% de la nueva posicion de los centroides

imhist(I)
hold on
plot(CC, zeros(1,k),'rx', 'LineWidth',3); 
title('Colocación de los centroides de las clases tras entrenar');
hold off; 
%% 
% Se pide.
% 
% # �Qu� significa que el bucle de entrenamiento se termine cuando |*t < T_max|*, 
% y cuando |*error < error_max|*?

% Si salimos por (error < error_max) es que nuestros centroides están
% suficientemente bien ajustados como para que la solución nos valga
% El error mide cuanto se han desplazado los centroides respecto de su
% posición en la iteración anterior. Cuando el error sea muy pequeño es que
% apenas habrán cambiado de posición de modo que podremos finalizar pues ya
% no lo van a hacer más.
% Si salimos por (t < T_max) es que llevamos demasiadas iteraciones
% intentando ajustar los centroides sin lograrlo lo cual indica que las
% posiciones aleatorias iniciales de los centoides no nos han sido
% favorables para encontrar una solución o bien que no hay una con el error
% lo sufuicentemente bajo. La solución será errónea.

% # Obtenga la imagen segmentada correspondiente a los centroides obtenidos 
% en el apartado anterior.
% # Cargue la imagen |'circlesBrightDark.png'|, cambie el n�mero de clases k=3 
% y muestre cada clase segmentada con un color diferente con la funci�n |*label2rgb|*.

CC = sort(CC);
hist = imhist(I);
previous = CC(1);
len = size(CC);
img_labels = ones(size(I));
for x = 2:len(2)
    current = CC(x);
    mean = previous + (current - previous)/2;
    img_chunk = [];
    img_len = size(I);
    for i = 1:img_len(1)
        for j = 1:img_len(2)
            if I(i,j) >= mean
                img_labels(i,j) = x;
            end
        end
    end
    previous = current;
end
imshow(label2rgb(img_labels))

