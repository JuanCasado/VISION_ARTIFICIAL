%% *Vision Artificial. GIEC.*
%% 	*Sistemas de Vision Artificial. GIC.*
% *Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos.* 
% 
% *Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 4.1: ejercicio 01 

close all
clear all
%% 
% 1) Lee la Imagen

imgOriginal = imread('autumn.tif');

imgBW = imgOriginal;

figure;
imshow(imgOriginal);
title('Image Origianl');

%% 
% 2) Crea un elemento estructurante. 

 
se = strel('disk', 5);

%% 
% 3) Realiza operaciones morfol�gicas en la imagen.

erodeBW = imerode(imgBW,se);
figure;
imshow(erodeBW);
title('Erosi�n');

dilateBW = imdilate(imgBW,se);
figure;
imshow(dilateBW);
title('Dilataci�n');
%% 
% Se pide: 
%% 
% # Ejecute el programa cargando la imagen en color |*'autumn.tif'*|, la imagen 
% en escala de grises |*'rice.png'*| y  la imagen binaria |*'circles.png'*|. �Qu� 
% diferencias ve en el comportamiento de los operadores morfol�gicos para las 
% distintas im�genes
imgOriginalAutum = imread('autumn.tif');
imgOriginalRice = imread('rice.png');
imgOriginalCircles = imread('circles.png');

figure;
subplot(1,3,1);imshow(imgOriginalAutum);title('Autum');
subplot(1,3,2);imshow(imgOriginalRice);title('Rice');
subplot(1,3,3);imshow(imgOriginalCircles);title('Circles');

imgBWAutum = imgOriginalAutum;
imgBWRice = imgOriginalRice;
imgBWCircles = imgOriginalCircles;

se = strel('disk', 5);

erodeBWAutum = imerode(imgBWAutum,se);
erodeBWRice = imerode(imgBWRice,se);
erodeBWCircles = imerode(imgBWCircles,se);
figure;
subplot(1,3,1);imshow(erodeBWAutum);title('Erode Autum');
subplot(1,3,2);imshow(erodeBWRice);title('Erode Rice');
subplot(1,3,3);imshow(erodeBWCircles);title('Erode Circles');

dilateBWAutum = imdilate(imgBWAutum,se);
dilateBWRice = imdilate(imgBWRice,se);
dilateBWCircles = imdilate(imgBWCircles,se);
figure;
subplot(1,3,1);imshow(dilateBWAutum);title('Dilate Autum');
subplot(1,3,2);imshow(dilateBWRice);title('Dilate Rice');
subplot(1,3,3);imshow(dilateBWCircles);title('Dilate Circles');
%%
% # Elementos estructurales. Observe el efecto de las operaciones morfol�gicas 
% utilizadas en (3) con diferentes elementos estructurales (ver ayuda: <https://es.mathworks.com/help/images/ref/strel.html?s_tid=doc_ta). 
% https://es.mathworks.com/help/images/ref/strel.html?s_tid=doc_ta).>


imgOriginalAutum = imread('autumn.tif');
imgOriginalRice = imread('rice.png');
imgOriginalCircles = imread('circles.png');

figure;
subplot(1,3,1);imshow(imgOriginalAutum);title('Autum');
subplot(1,3,2);imshow(imgOriginalRice);title('Rice');
subplot(1,3,3);imshow(imgOriginalCircles);title('Circles');

imgBWAutum = imgOriginalAutum;
imgBWRice = imgOriginalRice;
imgBWCircles = imgOriginalCircles;

%se = strel(5);
%se = strel('arbitrary',30);
%se = strel('diamond',5);
%se = strel('octagon',5);
%se = strel('line',20,0);
%se = strel('rectangle',[7 3]);
%se = strel('square',5);
%se = strel('cube',5);
se = strel('cuboid',[2 3 3]);
%se = strel('sphere',5);
%se = strel('disk', 5);

erodeBWAutum = imerode(imgBWAutum,se);
erodeBWRice = imerode(imgBWRice,se);
erodeBWCircles = imerode(imgBWCircles,se);
figure;
subplot(1,3,1);imshow(erodeBWAutum);title('Erode Autum');
subplot(1,3,2);imshow(erodeBWRice);title('Erode Rice');
subplot(1,3,3);imshow(erodeBWCircles);title('Erode Circles');

dilateBWAutum = imdilate(imgBWAutum,se);
dilateBWRice = imdilate(imgBWRice,se);
dilateBWCircles = imdilate(imgBWCircles,se);
figure;
subplot(1,3,1);imshow(dilateBWAutum);title('Dilate Autum');
subplot(1,3,2);imshow(dilateBWRice);title('Dilate Rice');
subplot(1,3,3);imshow(dilateBWCircles);title('Dilate Circles');

%%
% # Operadores morfol�gicos. Cargue la imagen en escala de grises |*'rice.png'*| 
% y realice una operaci�n de umbralizado con la funci�n |*imbinarize*|, que por 
% defecto utiliza el m�todo de Otsu. Utilice las funciones |*imclose*| o |*imopen*| 
% para eliminar los peque�os p�xeles aislados que puedan estar en el fondo de 
% la imagen. Tenga en cuenta que el tipo y tama�o del elemento estructural debe 
% ser ajustado.

imgOriginalRice = imread('rice.png');
imgBWRice = imbinarize(imgOriginalRice);

%se = strel(5);
%se = strel('arbitrary',30);
%se = strel('diamond',5);
%se = strel('octagon',5);
%se = strel('line',20,0);
%se = strel('rectangle',[7 3]);
%se = strel('square',5);
%se = strel('cube',5);
%se = strel('cuboid',[2 3 3]);
%se = strel('sphere',5);
se = strel('disk', 3);

imgRiceclosed = imclose(imgBWRice, se);
imgRiceOpened = imopen(imgBWRice, se);

figure;
subplot(1,3,1);imshow(imgBWRice);title('Original');
subplot(1,3,2);imshow(imgRiceclosed);title('Close');
subplot(1,3,3);imshow(imgRiceOpened);title('Open');


%%
% # Repita la pregunta anterior pero utilizando la imagen original complementada 
% (utilice la funci�n |*imcomplement*|).

imgOriginalRice = imread('rice.png');
imgBWRice = imcomplement(imgOriginalRice);

%se = strel(5);
%se = strel('arbitrary',30);
%se = strel('diamond',5);
%se = strel('octagon',5);
%se = strel('line',20,0);
%se = strel('rectangle',[7 3]);
%se = strel('square',5);
%se = strel('cube',5);
%se = strel('cuboid',[2 3 3]);
%se = strel('sphere',5);
se = strel('disk', 3);

imgRiceclosed = imclose(imgBWRice, se);
imgRiceOpened = imopen(imgBWRice, se);

figure;
subplot(1,3,1);imshow(imgBWRice);title('Original');
subplot(1,3,2);imshow(imgRiceclosed);title('Close');
subplot(1,3,3);imshow(imgRiceOpened);title('Open');

%% 
% Step 1) Reading the Image

original = imread('/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/galaxy.png');
figure;
imshow(original);
title('Original image');
%% 
% Step 2) Creating a structuring element.

se = strel('disk',50);
%% 
% Step 3) Top or Bottom Hat.

tophat = imtophat(original,se);
figure;
imshow(tophat);
title('Top Hat');
%% 
% Se pide: 
%% 
% # Supongamos que s�lo nos interesan las peque�as manchas en la imagen y queremos 
% eliminar la galaxia. La operaci�n (white) top-hat puede eliminar objetos brillantes 
% m�s grandes y retener peque�as manchas seleccionando correctamente el tama�o 
% del elemento estructurante. Elija un elemento estructurante en forma de disco 
% (2) y encuentre el radio que le permita mantener las estrellas peque�as, un 
% radio alrededor de 2 a 6 p�xeles, y eliminar la galaxia, m�s de 50 p�xeles.

original = imread('/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/galaxy.png');

se = strel('disk',10, 8);

tophat = imtophat(original,se);
figure;
subplot(1,2,1);imshow(original);title('Original image');
subplot(1,2,2);imshow(tophat);title('Top Hat');

%%
% # Cuando el fondo es blanco y el primer plano es oscuro, debemos cambiar el 
% enfoque. Obtenga la imagen complementada con la funci�n |*imcomplement*| (1) 
% y compruebe que La operaci�n (white) top-hat no funciona correctamente. Explique 
% por qu� y obtenga una soluci�n.

original = imread('/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/galaxy.png');
complement = imcomplement(original);

se = strel('disk',10, 8);

tophat = imtophat(complement,se);
bothat = imbothat(complement,se);
figure;
subplot(1,3,1);imshow(complement);title('Original image');
subplot(1,3,2);imshow(tophat);title('Top Hat');
subplot(1,3,3);imshow(bothat);title('Bot Hat');