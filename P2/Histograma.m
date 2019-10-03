%% Ejemplos de procesamiento de la imagen basada en el histograma en Matlab
%% *Histograma*
% El histograma de una imagen es una funci�n discreta que representa el n�mero 
% de p�xeles en una imagen por cada nivel de intensidad. La funci�n que nos proporciona 
% el histograma es _imhist,_ que lo crea realizando n niveles de intensidad igualmente 
% espaciados cada uno representando un rango de valores de intensidad o valores 
% de color. 

load clown % Imagen indexada de matlab guardada en variables X y map
I=ind2gray(X,map);  % I es una imagen de intensidad double entre 0 y 1
figure
subplot(1,2,1), imshow(I)
subplot(1,2,2), imhist(I,128) % agrupa los niveles de intensidad en n=128
%% 
subplot(1,2,1), imshow(I)
subplot(1,2,2), imhist(I,5)
%% *Ajuste de la intensidad *
% La funci�n _imadjust_ mapea los valores de intensidad de una imagen a un nuevo 
% rango seg�n los valores de los par�metros de entrada: puede ampliar y reducir 
% y soporta distintas funciones de transferencia. Puede realizar tres tipos de 
% ajuste de imagen: 
% 
% * rangos expl�citos de intensidades (input and output cropping), 
% * correcci�n gamma, y
% * ecualizaci�n de la imagen. 
% 
% _imadjust_ no se usa �nicamente con im�genes con niveles grises, tambi�n 
% se utiliza con im�genes de color operando sobre las componentes rojo, verde 
% y azul independientemente. 
% 
% La funci�n _imadjust_ trabaja con los valores low, high, bot y top entre 
% 0 y 1 (double), por ello conviene que la imagen de entrada tenga tambi�n este 
% tipo de formato, como se hace en el siguiente ejemplo: 
% 
% J=imadjust(I, [low  high], [bot   top], gamma);  % con low, high, bot y 
% top entre 0 y 1
% 
% *Introduzca el siguiente c�digo: *

I=imread('/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/rice.tif'); %Imagen de intensidad de tipo uint8
I=im2double(I); %Imagen de intensidad de tipo double  (rango entre 0 y 1)
J=imadjust(I,[0.15 0.9], [0 1]);  %gamma, por defecto, vale uno: conversion lineal
figure
subplot(2,2,1), imshow(I); title('Imagen original ');
subplot(2,2,2), imhist(I,64);
subplot(2,2,3), imshow(J); title('Imagen final: con más contraste ');
subplot(2,2,4), imhist(J,64);
%%
low = min(min(I));
high = max(max(I));
J=imadjust(I,[low high], [0 1]);  %gamma, por defecto, vale uno: conversion lineal
figure
subplot(2,2,1), imshow(I); title('Imagen original ');
subplot(2,2,2), imhist(I,64);
subplot(2,2,3), imshow(J); title('Imagen final: con m�s contraste ');
subplot(2,2,4), imhist(J,64);
%% 
% Como se puede observar aumenta el contraste (diferencia entre el nivel 
% de gris m�nimo y m�ximo) de la imagen. 
% 
% Se puede, sean cual sean los valores m�ximo y m�nimo de la imagen de entrada 
% (double entre 0 y 1) ajustarlo a los m�ximos de 0 y 1 (en la imagen de salida) 
% haciendo: 

J=imadjust(I,[min(min(I)) max(max(I))], [0 1]); %Ajuste del contraste al maximo 
%% 
% *Ejecute las l�neas anteriores y modifique los m�rgenes de entrada y salida.*
% 
% De forma similar se puede disminuir el *contraste* haciendo:
%%
JJ=imadjust(J,[0 1], [0.3 0.8]); %Valores entre 0 y 1 se ajustan entre 0.3 y 0.8: baja contraste
figure, subplot(2,2,1), imshow(J); title('Imagen con mas contraste ');
subplot(2,2,2), imhist(J,64);
subplot(2,2,3), imshow(JJ); title('Imagen final: con menos contraste ');
subplot(2,2,4), imhist(JJ,64);
%% 
% *Ejecute las l�neas anteriores y modifique los m�rgenes de entrada y salida.*
% 
% Tambi�n se puede variar el *brillo* de la imagen provocando desplazamientos 
% de intensidad de los valores de los p�xeles en el histograma. 
%%
I=imread('/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/rice.tif');  %Imagen de intensidad de tipo uint8
I=im2double(I);  %Imagen de intensidad de tipo double (rango entre 0 y 1)
J=imadjust(I,[0 0.8], [0.2 1]);  %Aumenta brillo (suma 0.2 a niveles de gris de partida)
figure, subplot(1,2,1), imshow(I); 
title('Imagen original');
subplot(1,2,2), imshow(J); title('Imagen final m�s brillante: m�s blanca ');
%% 
% *Ejecute las l�neas anteriores y modifique los m�rgenes de entrada y salida.*
%% *Correcci�n gamma*
% La correcci�n gamma es una operaci�n de asociaci�n de intensidades. Se hace 
% corresponder un valor de intensidad de la imagen a otro valor, en este caso 
% usando una funci�n exponencial. Si x es una intensidad de entrada, la intensidad 
% de salida es y, tal que y=x ^ gamma. _imadjust _realiza la correcci�n gamma 
% utilizando el formato: 
% 
% J= imadjust (I, [ ], [ ], gamma); 
% 
% donde I es la imagen, gamma es el valor de exponente deseado, y las matrices 
% vac�as impiden el recorte de intensidades. Se muestra un ejemplo de la correcci�n 
% gamma para la imagen forest:
%%
[X,map]=imread('forest.tif');
I=ind2gray(X,map);
J=imadjust(I,[],[],0.2);
figure
subplot(2,2,1), imshow(I); title('Imagen original');
subplot(2,2,2), imshow(J); title('Imagen tras correccion gamma');
subplot(2,2,3), imhist(I); title('Imagen original hist');
subplot(2,2,4), imhist(J); title('Imagen tras correccion gamma hist');
%% 
% *Ejecute las l�neas anteriores y verifique el efecto de distintos valores 
% de gamma.*
%% *Ecualizaci�n del histograma*
% La ecualizaci�n del histograma redistribuye los valores de intensidad de manera 
% que el histograma acumulativo de la imagen sea aproximadamente lineal. La funci�n 
% _histeq_ implementa la ecualizaci�n del histograma. 
% 
% Cuantos menos niveles de intensidad de salida se utilicen, m�s plano es 
% el histograma. 
% 
% Los comandos que se muestran a continuaci�n crean dos im�genes ecualizadas. 
% Una con 32 niveles de salida, J, y otra con 4, K. Comparando las dos figuras, 
% se observa que el histograma asociado con la imagen ecualizada con los cuatro 
% niveles de salida es m�s plano: 
%%
load clown          % imagen indexada de matlab definida a traves de X y map 
I=ind2gray(X,map);  % imagen de intensidad double entre 0 y 1 
J=histeq(I,32); 
K=histeq(I,4); 
figure 
subplot(2,2,1), imhist(J,32) 
subplot(2,2,2), imshow(J) 
subplot(2,2,3), imhist(K,32) 
subplot(2,2,4), imshow(K) 
%% 
% Tambi�n se puede obtener la gr�fica de transferencia entre los valores 
% de entrada-salida:

[K,T]=histeq(I,4); 
%Los 256 niveles de gris de entrada entre 0 y 1 se transforman en los niveles T
figure, plot((0:255)/255,T); title('Ley de transformacion');
xlabel('Niveles de gris de entrada'); ylabel('Niveles de gris de salida');
%% 
% *Ejecute las l�neas anteriores y verifique el efecto del n�mero de valores 
% en el histograma ecualizado y en la gr�fica de transferencia.*
% 
% *Logaritmo de una imagen. *
% 
% En este ejemplo se trabajar� sobre una imagen muy oscura (bazo.bmp desplazando 
% su nivel de gris m�nimo al negro) y se aumentar� su contraste realizando el 
% logaritmo de la imagen. Previamente se habr� calculado el valor de k adecuado.
%%
[JOrig,map]=(imread('/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/bazo.bmp'));
J=im2double(ind2gray(JOrig,map));
figure, 
subplot(3,2,1), imhist(J,128);
subplot(3,2,2), imshow(J); title('Original');
vmin=min(min(J)); vmax=max(max(J));
J1=imadjust(J, [vmin vmax], [0 vmax-vmin]);
subplot(3,2,3), imhist(J1,128);
subplot(3,2,4), imshow(J1); title('Oscurecida');
Z=max(max(J1)); k=1/log10(1+Z); X=k*log10(1+J1);
subplot(3,2,5), imhist(X,128);
subplot(3,2,6), imshow(X);title('Logaritmo');
%% 
% *Ejecute las l�neas anteriores y pruebe distintos valores de k.*
% 
% *Otros comandos de Matlab*
% 
% Con el comando _imfinfo _puede obtener informaci�n sobre una imagen guardada 
% en un fichero. 
% 
% Asimismo puede testear las variables usadas (o cargadas con el comando 
% _load_) viendo el workspace o con el comando _who _o _whos _en Matlab.
[JOrig,map]=(imread('/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/bazo.bmp'));
J=im2double(ind2gray(JOrig,map));
figure, 
subplot(3,2,1), imhist(J,128);
subplot(3,2,2), imshow(J); title('Original');
vmin=min(min(J)); vmax=max(max(J));
J1=imadjust(J, [vmin vmax], [0 vmax-vmin]);
subplot(3,2,3), imhist(J1,128);
subplot(3,2,4), imshow(J1); title('Oscurecida');
Z=max(max(J1)); k=1/log10(1+Z);
display(k)
X=20*log10(1+J1);
subplot(3,2,5), imhist(X,128);
subplot(3,2,6), imshow(X);title('Logaritmo');
%%
syms f(a)
f(a)=1/log10(1+a);
fplot(f)
%%
info = imfinfo('/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/barco.jpg')
max(imread('/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/barco.jpg'),[],'all')
