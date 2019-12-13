%% Apartado a
I = imread('rice.tif'); %Información sobre la imagen
figure;imhist(I);xlabel('nivel de gris');ylabel('No de píxeles');

Um=(I >= 105);
figure, imshow(Um), title('Imagen umbralizada');


%% Apartado b
I = imread('rice.tif'); %Información sobre la imagen
figure,imshow(I);
figure;imhist(I);xlabel('nivel de gris');ylabel('No de píxeles');

umbral = input('Introduce valor del umbral global a la vista de la figura del histograma ');

Um=(I >= umbral); 
figure, imshow(Um), title('Imagen umbralizada');


%% Apartado c

%Pedimos la imagen al usuario
imagen.nombre=input('introduce nombre de fichero entre comillas, p. ej.: ''rice.tif''\n'); 
info_imagen=imfinfo(imagen.nombre); %estructura con campos con inform. de la imagen

%Codigo para convertir la imagen (indexed, truecolor, grayscale) a niveles de gris (grayscale) 
if strcmp(info_imagen.ColorType,'indexed')
    [X,map]=imread(imagen.nombre); 
    figure,imshow(X,map);
    I=ind2gray(X,map);
elseif strcmp(info_imagen.ColorType,'truecolor') 
    rgb=imread(imagen.nombre);
    figure,imshow(rgb);
    I=rgb2gray(rgb); 
else
    I=imread(imagen.nombre); 
end

%Mostramos la imagen por pantalla
figure,imshow(I);
%Mostramos el histograma por pantalla
figure;imhist(I);xlabel('nivel de gris');ylabel('No de píxeles');
%Pedimos el umbral al usuario
umbral = input('Introduce valor del umbral global a la vista de la figura del histograma ');
%Binarizamos la imagen utilizando el umbral pedido
Um=(I >= umbral); 
figure, imshow(Um), title('Imagen umbralizada');
