%% *Vision Artificial. GIEC.*
%% *	Sistemas de Vision Artificial. GIC.*
% *	Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos. *
% 
% *  Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 3: ejercicio 03 
%% *Segmentaci�n basada en bordes, an�lisis local.* 

close all;
clear all;
clc;
%% 
% Lee una imagen en el espacio de trabajo y la convierte a escala de gris, 
% si es necesario.

filename = 'coins.png';
I=imread(filename);
imshow(I)
title('Imagen original');
%% 
% Detectamos bordes con la funcion edge utilizando alguna de las t�cnicas 
% estudiadas (t�picamente pasar un filtro de Canny o de Sobel).

BWs = edge(I, 'sobel', 0.14);
BWc = edge(I, 'canny', [0.31 0.8], 0.5);
figure
subplot(1,2,1);imshow(BWs);title('Imagen de bordes sobel');
subplot(1,2,2);imshow(BWc);title('Imagen de bordes canny');
%% 
%  
% 
% A continuaci�n, con alguna t�cnica local (analizando un entorno pr�ximo 
% alrededor de cada p�xel) se intentan cerrar contornos (uniendo p�xeles de los 
% bordes que se hayan podido separar en los procesos previos, en el proceso de 
% digitalizaci�n de la imagen, a causa del ruido etc.). 
% 
% *Nota:* los operadores morfol�gicos como la |*dilataci�n|* y otros ser�n 
% vistos en detalle en el pr�ximo tema. Ahora s�lo nos interesa experimentar su 
% utilidad.
% 
%  

% Dilatamos para unir bordes y cerrar contornos
se =strel([0 1 0; 1 1 1; 0 1 0]); % Elemento estructurante usado para dilatar
BWsdil = imdilate(BWs, se);
BWcdil = imdilate(BWc, se);
figure;
subplot(1,2,1);imshow(BWsdil);title('Imagen dilatada sobel');
subplot(1,2,2);imshow(BWcdil);title('Imagen dilatada canny');
%% 
%  Se rellenana los contornos y se segmenta a partir de los mismos 

% Segmentaci�n por llenado de contornos 
% (se rellenan los contornos porque no se desea, en este caso, 
% segmentar otros objetos que haya dentro de un contorno ya cerrado)
BWsrellenada = imfill(BWsdil,'holes');
BWcrellenada = imfill(BWcdil,'holes');
figure;
subplot(1,2,1);imshow(BWsrellenada);title('Imagen rellenada sobel');
subplot(1,2,2);imshow(BWcrellenada);title('Imagen rellenada canny');

%% 
%  

% Segmentaci�n directa a partir de bordes.
Ls = bwlabel(BWsrellenada); % Imagen etiquetada.
Lc = bwlabel(BWcrellenada); % Imagen etiquetada.
numero_objetoss = max(max(Ls)); % n�mero de objetos igual a etiqueta mayor
numero_objetosc = max(max(Lc)); % n�mero de objetos igual a etiqueta mayor
L_RGBs = label2rgb(Ls);
L_RGBc = label2rgb(Lc);
figure
subplot(1,2,1);imshow(L_RGBs);title(sprintf('%d objetos segmentados en colores sobel',numero_objetoss));
subplot(1,2,2);imshow(L_RGBc);title(sprintf('%d objetos segmentados en colores canny',numero_objetosc));

%% 
% Se pide:
% 
% # Cambie el operador de bordes de |*'sobel'|* a |*'canny'|* y comente los 
% resultados.

% Con el operador canny podemos realizar una detección de bordes mucho más
% precisa y selectiva. Pues el un algoritmo que tiene en cuneta más
% parámetros para lograr determinar los bordes realmente representativos.
% Resulta más sencillo ajustar el algoritmos de sobel pues solo tine un
% umbral que el algorimo de canny que tiene tres parámetros por los que
% puede ser ajustado.

% No obstante para este caso concreto que solo nos
% interesa el un contorno aproximado para luego rellenarlo podemos observar 
% que aunque los bordes de canny hayan sido mejores el resultado final es 
% el mismo.


%%
% # Comente el c�digo del operador morfol�gicos |*imdilate|* y comente los resultados.
% 
% imdilate permite "copiar" los pixeles de una imagen en posiciones
% próximas a ellos. Una dilatación el forma de línea vertical dará la
% impresión de que la cámara se estaba moviendo de arriba a abajo al hacer
% la foto.
% Con el kernell en forma de cruz que hemos utilizado lo que logramos es
% que cada pixel del borde se copie a su derecha y a su izquierda logrnado
% que este acaba siendo más grueso de modo que se cierren los contornos.

%%
% # Cree una m�scara solapada con la imagen original utilizando la funci�n |*labeloverlay|* 
% labeloverlay Toma como entrada dos matrices. La primera representará una
% imagen y la segunda una máscara. Sobre la imagen dibuja de un color
% distinto cada valor presente en la máscara.

os = labeloverlay(I,Ls);
oc = labeloverlay(I,Lc);
figure
subplot(1,2,1);imshow(os);title('overlay sobel');
subplot(1,2,2);imshow(oc);title('overlay canny');

