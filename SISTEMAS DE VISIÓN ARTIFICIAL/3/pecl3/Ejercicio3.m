%Pedimos el nombre del fichero por linea de comandos
imagen.nombre=input('introduce nombre de fichero entre comillas, p. ej.: ''rice.tif''\n');

%Leemos la imagen del fichero pedido
I = imread(imagen.nombre);
figure,subplot(1,2,1), imshow(I), title('Imagen original');

%Calculamos el umbral para la binarizacion
level = graythresh(I); 

%Binarizamos con el umbral calculado
BW = im2bw(I,level); 

%Mostramos la imagen resultante por pantalla
subplot(1,2,2), imshow(BW), title('Imagen binarizada');
