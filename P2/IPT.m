%% Ejemplos de la *Image Processing Toolbox* 
% La *Image Processing Toolbox* permite realizar rotaciones, homotecia (zoom) 
% y selecci�n, as� como operaciones m�s especializadas. 
% 
% Estas funciones soportan cualquier tipo de imagen, aunque se debe procesar 
% cada una de las componentes de una imagen RGB por separado.
%% Tipos de interpolaci�n 
% Permite realizar tres m�todos de *interpolaci�n*:
%% 
% * Vecino m�s cercano
% * Interpolaci�n bilineal
% * Interpolaci�n bic�bica
%% 
% Los comandos que se muestran a continuaci�n crean una figura de dos picos 
% que ilustra estas diferencias:

close all
clear all

[x,y,z]=peaks(5);       % Figura inicial de valores x,y,z
[xi,yi]=meshgrid(-3:.25:3);  % Inserta puntos intermedios: valores a interpolar
zlin=interp2(x,y,z,xi,yi,'linear');   % Interpolacion lineal
zcub=interp2(x,y,z,xi,yi,'cubic');   % Interpolacion cubica
figure, % abre una nueva ventana para visualizar las graficas
colormap(jet);    % asigna un mapa de color
subplot(1,3,1)  % divide la figura en 3 partes y activa la 1
surf(x,y,z);   % visualiza como superficie
title('Figura inicial con pocos puntos');
subplot(1,3,2)
surf(xi,yi,zlin);
axis ([-3.5 3.5 -3.5 3.5 -8 8]); title('Figura tras interpolacion lineal');
subplot(1,3,3), surf(xi,yi,zcub);
axis([-3.5 3.5 -3.5 3.5 -8 8]); title('Figura tras interpolacion cubica');
%% 
% *Ejecute este c�digo y realice pruebas modificando el n�mero de puntos intermedios.*
%% *Rotaci�n de im�genes*
% El comando _imrotate_ rota una imagen usando un m�todo de interpolaci�n especificado 
% y un �ngulo de rotaci�n. Si no se especifica un m�todo de interpolaci�n, la 
% funci�n determina el tipo de imagen y autom�ticamente elige el mejor m�todo. 
% Cuando no se especifica el m�todo de interpolaci�n a _imrotate_, la funci�n 
% elige el mejor m�todo para la imagen. 
% 
% Para rotar la imagen �trees� 35 � (�trees� es una imagen indexada, por lo 
% que imrotate usa la *interpolaci�n por vecino m�s cercano)*:

load  trees     % carga la imagen indexada en X,map (X es la matriz de indices y map el mapa de color)
Y=imrotate(X,35);
figure, imshow(Y,map)   % para visualizar una imagen indexada es necesario indicarle el mapa de color
%% 
% *Ejecute este c�digo y pruebe diferentes �ngulos.*
%% Selecci�n dentro de una imagen
% La funci�n _imcrop_ extrae una porci�n rectangular de una imagen. _imcrop_ 
% permite definir el rect�ngulo de corte con el rat�n o a trav�s de una lista 
% de argumentos. Por ejemplo, para extraer un rect�ngulo de 92x95 de la imagen 
% �trees� comenzando en la coordenada (71,107), se utiliza:

load trees
figure, subplot(1,2,1), imshow(X, map);
X2=imcrop(X,[71, 107, 92, 95]);
subplot(1,2,2), imshow(X2,map);
%% 
% Para definir el rect�ngulo de corte con el rat�n, se usa  imcrop sin argumentos 
% de entrada. La actual figura debe contener una imagen en la cual  _imcrop_ pueda 
% operar. Tras llamar a _imcrop_, presionar el bot�n izquierdo del rat�n mientras 
% se arrastra por la imagen visualizada. Soltar el bot�n del rat�n cuando se haya 
% definido el �rea deseada y al hacer doble click se copiar� la parte seleccionada 
% en otra figura.
% 
% *Ejecute el c�digo anterior y realice una prueba modificando la posici�n y 
% dimensiones del rect�ngulo y utilizando _imcrop_ si argumentos de entrada.*
%% Cambio de tama�o de im�genes
% La funci�n _imresize_ cambia el tama�o o la relaci�n de muestreo de una imagen, 
% usando un m�todo de interpolaci�n especificado. Si no se especifica un m�todo, 
% la funci�n determina el tipo de imagen y autom�ticamente elige el mejor. _imresize_ 
% puede recalibrar una imagen por un factor, o a un tama�o de fila-columna especificado. 
% Si se reduce el tama�o de la imagen, _imresize_ aplica un filtro paso bajo a 
% la imagen antes de la interpolaci�n. Esto reduce el efecto de las muestras de 
% Moir�, rizados que resultan del aliasing durante el muestreo. Se puede aplicar 
% la funci�n _truesize_ para recalibrar im�genes. Esta funci�n visualiza una imagen 
% con un pixel de pantalla por cada pixel de la imagen, as� podemos ver el tama�o 
% rea (si no, veremos todas aparentemente iguales, por el escalado que realiza 
% Matlab para visualizar).
% 
% Por ejemplo, para recalibrar X a cuatro veces su actual tama�o usaremos,

load trees
X2=ind2rgb(X,map);
Y1=imresize(X2,4);  % Si dejamos X como indexada: [Y,newmap]=imresize(X,map,2);
%% 
% Para obtener una imagen de tama�o 100x150 usaremos,�

Y2=imresize(X2,[100 150]);
% Si X es indexada: [Y, newmap]=imresize(X,map,[100 150]);
%% 
% Se puede comprobar el (nuevo) tama�o con el comando: 	

size(Y1)
size(Y2)
%% 
% Se puede visualizar el resultado con:

figure;  imshow(Y1); truesize; % Si es indexada: imshow (Y, newmap); 
figure;  imshow(Y2); truesize; 
%% 
% *Ejecute el c�digo anterior y realice diferentes pruebas cambiando tama�os 
% y tipos de im�genes (indexada...).*
%% Zoom de una imagen
% En Matlab, una vez visualizada una imagen en una figura de Matlab se puede 
% dentro del men� _Figure --> Tools --> zoom in_ ampliar la imagen para ver mejor 
% los detalles. 
% 
%