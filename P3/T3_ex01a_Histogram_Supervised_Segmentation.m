%% *Vision Artificial. GIEC.*
%% Tema 3: ejercicio 01-a 
%% *Segmentaci�n supervisada lineal, mediante umbral(es) global(es)*
%  
% 
% El objetivo de este ejercicio es segmentar de forma supervisada los distintos 
% objetos de una imagen. Observando el histograma se localizar�n de forma supervisada 
% los umbrales para quedarse �nicamente con los objetos de inter�s. 
% 
% Ejecute el siguiente ejemplo:
% 
% *  Cree una  imagen (toda a nivel negro)

BW = zeros(256,256);
%% 
% * Cree tres objetos rectangulares dentro de la imagen

BW(30:80,40:240) = 1; %Crea rectangulo blanco dentro de BW
BW(100:240,30:120) = 0.7; %Crea rectangulo gris claro dentro de BW
BW(150:250,150:250) = 0.3; %Crea cuadrado gris oscuro dentro de BW

figure;
subplot(2,1,1);imshow(BW);
title('Imagen Original');
subplot(2,1,2);imhist(BW);
%% 
% * A�ada ruido gausiano de media *m=0* y varianza *var_gauss=0,005*

m = 0; % media
var_gauss = 0.0005; % varianza
BW_N=imnoise(BW,'gaussian', m, var_gauss);

figure;
subplot(2,1,1);imshow(BW_N); 
title('Imagen Original con ruido Gaussiano');
subplot(2,1,2);imhist(BW_N);
%% 
% * Aplique un filtrado a la imagen con ruido


BW_K=wiener2(BW_N,[5 5]); %Filtra la imagen

figure;
subplot(2,1,1);
imshow(BW_K); 
title('Imagen filtrada');
subplot(2,1,2);imhist(BW_K);
%% 
% * Calcule y muestre el histograma de la imagen con ruido y filtrada


nBin = 256;
imhist(BW_K,nBin);
ylim([0 2000])
xlabel('niveles de gris');
ylabel('Nº de píxeles');
%% 
% Utilizando un único umbral NO se pueden segmentar todos los objetos.

thresh = [0.15, 0.5, 0.85]; % vector de umbrales
BW_seg = imquantize(BW,thresh); % Segmenta la imagen utilizando los umbrales indicados en thresh
RGB_seg = label2rgb(BW_seg); % Convierte la imagen segmentada en una imagen en color usando: label2rgb   
imshowpair(BW,RGB_seg,'montage')   
title('Imagen segmentada (método supervisado lineal)');
%% 
% Se pide:
% 
% # Cuantos umbrales son necesarios para segmentar *todos* los objetos de la 
% imagen?
%--------------------------------------------------------------------------
% Se necesitan 3 umbrales --> generan 4 zonas
%--------------------------------------
% # Estime los niveles de umbral (|*thresh|*) necesarios para segmentar todos 
% los objetos de la imagen y representelos con distintos colores.
%--------------------------------------------------------------------------
% 1: 0.15
% 2: 0.5
% 3: 0.85
%--------------------------------------
% # Cambie el valor de la varianza del ruido (|*var_gauss|*) y comente el resultado 
% de la segmentación para distintos valores de la varianza con y sin filtrado 
% (|*wiener2|*).
%--------------------------------------------------------------------------
% Cuanto mayor el la varianza más juntas están las campanas de gauss creads
% El filtro hace que la separación entre ellas aumente
%--------------------------------------
% # Utilice el siguiente código para cargar una nueva imagen (que comprueba 
% el formato y lo cambia si es necesario), realice la segmentación supervisada 
% lineal y comente el resultado.
%%
filename = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/barco.jpg'; %'flowers.tif'; %'gantrycrane.png';
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
% Mostrar la imagen y su histogramas
figure('Name', 'HIST');
subplot(2,1,1);imshow(I);
subplot(2,1,2);imhist(I);

% Segmentación
thresh = [80,180];
I_seg = imquantize(I,thresh);
RGB_seg = label2rgb(I_seg);
figure('Name', 'SEG');
imshowpair(I,RGB_seg,'montage')   
title('Imagen segmentada (método supervisado lineal)');

% La segmentación produce muy malos resultados pues los colores de los
% objetos que deseamos segmentar se confunden con los del fondo, comparten
% niveles de gris por lo que solo con ellos no los podemos diferenciar.
