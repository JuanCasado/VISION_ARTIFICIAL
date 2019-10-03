%% Sistemas de Visión Artificial
%% *Práctica 2. Técnicas Básicas de Procesamiento de Imágenes*
% 
%%
% 
% *Nombres:* Juan Casado Ballesteros
% 
% *Fecha:* 1 de Octubre de 2019
% 
%%
% 
% El objetivo principal de esta práctica es familiarizarse con las técnicas 
% básicas de procesamiento de imágenes mediante la Image Processing Toolbox de 
% Matlab. Para ello se proponen ejercicios sobre operaciones geométricas, ecualización 
% del histograma, diseño e implementación de filtros y filtrado de imágenes en 
% el dominio del espacio, mediante máscaras de convolución. La mayoría de las 
% técnicas de mejora se aplican a imágenes de intensidad (escala de grises). Para 
% mejorar una imagen RGB, trabajaremos, normalmente, con las matrices de las componentes 
% rojo, verde y azul separadamente.
% 
% *La memoria de la práctica se completará por parejas en este mismo fichero 
% .mlx*, añadiendo el código en cada apartado, además de los comentarios pertinentes, 
% la explicación del código y conclusiones sobre cada resultado obtenido. Las 
% distintas partes serán secciones independientes (deberá insertar "section break"), 
% y se visualizarán los resultados conjuntamente con subplot cuando sea conveniente.
% 
% Se valorará positivamente la ampliación con las explicaciones que considere 
% oportunas, pruebas adicionales (modificando parámetros, utilizando otras imágenes 
% que resalten algún efecto del procesamiento, etc.), descripción de problemas 
% surgidos en la ejecución de la práctica y solución proporcionada, etc. La entrega 
% se realizará renombrando este fichero para incluir los nombres de los autores, 
% y enviándolo por email a sira.palazuelos@uah.es (p. ej.: Estudiante1Apellido1_Estudiante2Apellido2.mlx)
% 
% 
%% 
% Implemente el siguiente código:
% 
% 1.	Cargue la imagen en color (?flowers.tif?, 'trees.tif',?) e indique el 
% formato de la misma (RGB, mapa de colores indexado, etc.).
%--------------------------------------------------------------------------
clear
% Obtenemos la información de cada imagen
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
flowers = imfinfo(strcat(ruta,'flowers.tif'));
peppers = imfinfo(strcat(ruta,'peppers.png'));
trees = imfinfo(strcat(ruta,'trees.tif'));

% Las dos primeras imágenes son un mapa de color cada una.
display(strcat('La imagen flowers es de tipo: ',flowers.ColorType))
display(strcat('La imagen peppers es de tipo: ', peppers.ColorType))

% La imagen trees se correspoinde con una animación formada por 5 imágenes
% cada una de las imágenes de la animación es una imagen indexada.
len_trees = size(trees);
for image = 1:len_trees(1)
    display(strcat('La imagen trees [', int2str(image),'] es de tipo: ', trees(image).ColorType))
end
%--------------------------------------------------------------------------
%%
% 2.	Visualice la imagen que acaba de leer.
%--------------------------------------------------------------------------
clear
% Cargamos las imágenes
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
flowers = imread(strcat(ruta,'flowers.tif'));
peppers = imread(strcat(ruta,'peppers.png'));
% Debido a que trees es indexada al leerla debemos recoger la imagen y el
% mapa de color
[trees, map_trees] = imread(strcat(ruta,'trees.tif'));

% Mostramos las imágenes todas a la vez en una sola ventana
figure('Name', 'Imágenes EJ2')
subplot(1,3,1);imshow(flowers);title('Flowers')
subplot(1,3,2);imshow(peppers);title('Peppers')
% Debido a que la imagen trees es indexada demebos proporcionar la imagen
% y el mapa de color
subplot(1,3,3);imshow(trees,map_trees);title('Trees')
%--------------------------------------------------------------------------
%%
% 3.	Convierta la imagen anterior a una imagen en escala de grises (conteniendo 
% solo la información de la luminancia) y almacenela en un array llamado i. Indique 
% el rango de valores en los que se cuantifica la luminancia (nivel mínimo y nivel 
% máximo) de la imagen resultante.
%--------------------------------------------------------------------------
clear
% Cargamos la imágen flowers
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
flowers = imread(strcat(ruta,'flowers.tif'));
% Convertimos a gis
i = rgb2gray(flowers);

figure('Name', 'EJ3')
subplot(1,2,1);imshow(flowers); title('Imagen original')
subplot(1,2,2);imshow(i); title('Imagen en gris')
iluminance_max = max(i,[], 'all');
iluminance_min = min(i,[], 'all');

display(strcat('La iluminación máxima es: ', int2str(iluminance_max)))
display(strcat('La iluminación mínima es: ', int2str(iluminance_min)))
%--------------------------------------------------------------------------
%%
% 4.	Averigüe las dimensiones de nuestra imagen i (filas x columnas).
%--------------------------------------------------------------------------
clear
%Cargamos la imágen flowers
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
flowers = imread(strcat(ruta,'flowers.tif'));
% Convertimos a gis
gray_flowers = rgb2gray(flowers);
% Obtenemos el tamaño
gray_flowers_lenght = size(gray_flowers);

display(strcat('La imagen tiene: ', int2str(gray_flowers_lenght(1)), ' filas'))
display(strcat('La imagen tiene: ', int2str(gray_flowers_lenght(2)), ' columnas'))
%--------------------------------------------------------------------------
%%
% 5.	Muestre el histograma de la imagen en escala de grises.
%--------------------------------------------------------------------------
clear
% Cargamos la imágen flowers
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
flowers = imread(strcat(ruta,'flowers.tif'));
% Convertimos a gis
gray_flowers = rgb2gray(flowers);

% Mostramos la imagen y los histogramas
figure
subplot(3,3,4);imshow(gray_flowers); title('Imagen en gris')
subplot(3,3,2:3);imhist(gray_flowers); title('Histograma completo')
subplot(3,3,8:9);imhist(gray_flowers, 100); title('Histograma agrupado con n=100')
%--------------------------------------------------------------------------
%%
% 6.	Modifique el brillo (sumando una constante) y el contraste (multiplicando 
% por una constante) de la imagen en escala de grises y visualice las imágenes 
% resultantes y sus histogramas.
%--------------------------------------------------------------------------
clear
% Cargamos la imágen flowers
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
flowers = imread(strcat(ruta,'flowers.tif'));
% Convertimos a gis
gray_flowers = rgb2gray(flowers);
gray_flowers = im2double(gray_flowers); % Dejamos los valores de la imagen entre 0 y 1

brillo_a_sumar = 0.4;
contraste_a_multiplicar = 0.2;

%Para cambiar el brillo debemos desplazar el histograma contra uno de los
%lados
if brillo_a_sumar > 0
    % Para aumentar el brillo debemos lograr desplazar el histograma de la
    % imagen hacia la derecha.
    brillo_sumado = imadjust(gray_flowers,...
        [0 1-brillo_a_sumar],[brillo_a_sumar 1]);
else
    % Para aumentar el brillo debemos lograr desplazar el histograma de la
    % imagen hacia la izquierda.
    brillo_sumado = imadjust(gray_flowers,...
        [abs(brillo_a_sumar) 1],[0 1-abs(brillo_a_sumar)]);
end

% Para aumentar el contraste debemos hacer que el histograma se desplace
% hacia ambos lados siendo mayor cuanto más se aleje del centro.
if contraste_a_multiplicar > 0
    c2 = (max(gray_flowers, [], "all")-min(gray_flowers, [], "all"))*(1-contraste_a_multiplicar);
    contraste_multiplicado = imadjust(gray_flowers,...
        [max([0 contraste_a_multiplicar]), min([1 c2])],[0,1]);
else
    c2 = (max(gray_flowers, [], "all")-min(gray_flowers, [], "all"))*(1-abs(contraste_a_multiplicar));
    contraste_multiplicado = imadjust(gray_flowers,...
        [0,1],[max([0 abs(contraste_a_multiplicar)]), min([0 c2])]);
end

% Mostramos los resultados
figure
subplot(2,3,1);imshow(gray_flowers); title('Imagen en gris')
subplot(2,3,4);imhist(gray_flowers); title('Histograma de la imagen en gris')
subplot(2,3,2);imshow(brillo_sumado); title('Imagen con brillo sumado')
subplot(2,3,5);imhist(brillo_sumado); title('Histograma con brillo sumado')
subplot(2,3,3);imshow(contraste_multiplicado); title('Imagen con contraste multiplicado')
subplot(2,3,6);imhist(contraste_multiplicado); title('Histograma con contraste multiplicado')
%--------------------------------------------------------------------------
%% 
% 7.	Realice una binarización de la imagen i con un umbral cuyo valor sea 
% aproximadamente la mitad de su rango de grises y visualice el resultado.
%--------------------------------------------------------------------------
clear
% Cargamos la imágen flowers
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
flowers = imread(strcat(ruta,'flowers.tif'));
% Convertimos a gis
gray_flowers = rgb2gray(flowers);
gray_flowers = im2double(gray_flowers); % Dejamos los valores de la imagen entre 0 y 1

mitad_de_rango = imadjust(gray_flowers, [0,1], [0.25, 0.75]);

% Mostramos los resultados
figure
subplot(2,2,1);imshow(gray_flowers); title('Imagen en gris')
subplot(2,2,3);imhist(gray_flowers); title('Histograma de la imagen en gris')
subplot(2,2,2);imshow(mitad_de_rango); title('Imagen con mitad de rango')
subplot(2,2,4);imhist(mitad_de_rango); title('Histograma con mitad de rango')
%--------------------------------------------------------------------------
%%
% 8.	Obtenga el negativo de la imagen en escala de grises obtenida en el 
% punto anterior.
%--------------------------------------------------------------------------
clear
% Cargamos la imágen flowers
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
flowers = imread(strcat(ruta,'flowers.tif'));
% Convertimos a gis
gray_flowers = rgb2gray(flowers);
gray_flowers = im2double(gray_flowers); % Dejamos los valores de la imagen entre 0 y 1

mitad_de_rango = imadjust(gray_flowers, [0,1], [0.25, 0.75]);

invertida = imadjust(mitad_de_rango, [0, 1], [1, 0]);

% Mostramos los resultados
figure
subplot(2,2,1);imshow(mitad_de_rango); title('Imagen en gris')
subplot(2,2,3);imhist(mitad_de_rango); title('Histograma de la imagen en gris')
subplot(2,2,2);imshow(invertida); title('Imagen con mitad de rango')
subplot(2,2,4);imhist(invertida); title('Histograma con mitad de rango')
%--------------------------------------------------------------------------
%% 
% 9.	Obtenga tres versiones ruidosas de la imagen i:
%--------------------------------------------------------------------------
clear
% Cargamos la imágen flowers
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
flowers = imread(strcat(ruta,'flowers.tif'));
% Convertimos a gis
gray_flowers = rgb2gray(flowers);
gray_flowers = im2double(gray_flowers); % Dejamos los valores de la imagen entre 0 y 1
%--------------------------------------------------------------------------
%     (a) con ruido de distribución uniforme speckle. 
%--------------------------------------------------------------------------
gray_flowers_speckle = imnoise(gray_flowers,'speckle');
%--------------------------------------------------------------------------
%     (b) con ruido de tipo sal y pimienta de densidad de ruido 5%.
%--------------------------------------------------------------------------
gray_flowers_salt_and_pepper = imnoise(gray_flowers,'salt & pepper',0.05);
%--------------------------------------------------------------------------
%     (c) con ruido de tipo gaussiano de media cero y varianza 0.01.
%--------------------------------------------------------------------------
gray_flowers_gaussian = imnoise(gray_flowers,'gaussian',0,0.01);
%--------------------------------------------------------------------------
%Mostramos los resultados
figure;
subplot(2,2,1);imshow(gray_flowers);title('Original');
subplot(2,2,2);imshow(gray_flowers_speckle);title('Speckle');
subplot(2,2,3);imshow(gray_flowers_salt_and_pepper);title('Salt & pepper');
subplot(2,2,4);imshow(gray_flowers_gaussian);title('Gaussian');
%--------------------------------------------------------------------------
%% 
% 10.	Partiendo de la imagen contaminada con ruido gaussiano anterior, fíltrela 
% utilizando la media del entorno de vecindad, primero con un entorno de vecindad 
% de 3x3 y luego con uno de 5x5, comparando los resultados obtenidos.
%--------------------------------------------------------------------------
clear
% Cargamos la imágen flowers
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
flowers = imread(strcat(ruta,'flowers.tif'));
% Convertimos a gis
gray_flowers = rgb2gray(flowers);
gray_flowers = im2double(gray_flowers);
%Aplicamos los distintops tipos de ruido
gray_flowers_speckle = imnoise(gray_flowers,'speckle');
gray_flowers_salt_and_pepper = imnoise(gray_flowers,'salt & pepper',0.05);
gray_flowers_gaussian = imnoise(gray_flowers,'gaussian',0,0.01);

%Aplicamos el filtro de media de tamaño 3
gray_flowers_3=filter2(fspecial('average',3),gray_flowers);
gray_flowers_speckle_3=filter2(fspecial('average',3),gray_flowers_speckle);
gray_flowers_salt_and_pepper_3=filter2(fspecial('average',3),gray_flowers_salt_and_pepper);
gray_flowers_gaussian_3=filter2(fspecial('average',3),gray_flowers_gaussian);

%Aplicamos el filtro de media de tamaño 5
gray_flowers_5=filter2(fspecial('average',5),gray_flowers);
gray_flowers_speckle_5=filter2(fspecial('average',5),gray_flowers_speckle);
gray_flowers_salt_and_pepper_5=filter2(fspecial('average',5),gray_flowers_salt_and_pepper);
gray_flowers_gaussian_5=filter2(fspecial('average',5),gray_flowers_gaussian);

%Mostramos los resultados
figure('Name','Imágenes y ruidos originales');
subplot(2,2,1);imshow(gray_flowers);title('Original');
subplot(2,2,2);imshow(gray_flowers_speckle);title('Speckle');
subplot(2,2,3);imshow(gray_flowers_salt_and_pepper);title('Salt & pepper');
subplot(2,2,4);imshow(gray_flowers_gaussian);title('Gaussian');
figure('Name','Filtro de media 3x3');
subplot(2,2,1);imshow(gray_flowers_3);title('Original');
subplot(2,2,2);imshow(gray_flowers_speckle_3);title('Speckle');
subplot(2,2,3);imshow(gray_flowers_salt_and_pepper_3);title('Salt & pepper');
subplot(2,2,4);imshow(gray_flowers_gaussian_3);title('Gaussian');
figure('Name','Filtro de media 5x5');
subplot(2,2,1);imshow(gray_flowers_5);title('Original');
subplot(2,2,2);imshow(gray_flowers_speckle_5);title('Speckle');
subplot(2,2,3);imshow(gray_flowers_salt_and_pepper_5);title('Salt & pepper');
subplot(2,2,4);imshow(gray_flowers_gaussian_5);title('Gaussian');
%--------------------------------------------------------------------------
%% 
% 11.	Lea la imagen venas.tif y rótela un ángulo de 50 grados (por ejemplo), 
% utilizando los métodos de interpolación nearest y bicubic (parámetros de la 
% función imrotate). Aumente las imágenes lo suficiente para ver las diferencias 
% entre ambos resultados.
%--------------------------------------------------------------------------
clear
% Cargamos la imágen venas
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
venas = imread(strcat(ruta,'venas.tif'));

% Rotación mediante vecino más cercano
venas_nearest_rotated=imrotate(venas,50,'nearest');
% Rotación mediante vecino bicubic
venas_bicubic_rotated=imrotate(venas,50,'bicubic');

figure,
subplot(1,3,1);imshow(venas);title('original')
subplot(1,3,2);imshow(venas_nearest_rotated);title('rotada con nearest')
subplot(1,3,3);imshow(venas_bicubic_rotated);title('rotada con bicubic')
%--------------------------------------------------------------------------
%%
% 12.	A partir de la imagen original blood1.tif, obtenga 16 imágenes en diferentes 
% ensayos con ruido gaussiano de media cero y varianza 0.05. Guárdelas en ficheros 
% con sus respectivos nombres (ruidosa1.bmp a ruidosa16.bmp).
%--------------------------------------------------------------------------
clear
% Cargamos la imágen blood
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
blood = imread(strcat(ruta,'blood1.tif'));

%Aplicar ruido
for i = 1:16
    noise = imnoise(blood,'gaussian',0,0.05);
    imwrite(noise, strcat(ruta,'blood_gaussian',i,'.bmp'));
end
%--------------------------------------------------------------------------
%%
% 13.	Realice pruebas de filtrado de ruido usando la técnica de promediado 
% de imágenes sobre las imágenes creadas en el punto anterior. Para ello, promedie 
% en primer lugar con 4 imágenes ruidosas, luego con 8 y, finalmente, con las 
% 16. Compare visualmente los resultados.
%--------------------------------------------------------------------------
clear
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
blood = imread(strcat(ruta,'blood1.tif'));
len = size(blood);
blood_filtered_4 = uint8(zeros(len(1), len(2)));
for i = 1:4
    blood_filtered_4 = blood_filtered_4 + imread(strcat(ruta,'blood_gaussian',i,'.bmp'))*1/4;
end
blood_filtered_8 = uint8(zeros(len(1), len(2)));
for i = 1:8
    blood_filtered_8 = blood_filtered_8 + imread(strcat(ruta,'blood_gaussian',i,'.bmp'))*1/8;
end
blood_filtered_16 = uint8(zeros(len(1), len(2)));
for i = 1:16
    blood_filtered_16 =blood_filtered_16 + imread(strcat(ruta,'blood_gaussian',i,'.bmp'))*1/16;
end

figure,
subplot(2,2,1);imshow(blood);title('original')
subplot(2,2,2);imshow(blood_filtered_4);title('filtrada con 4 imágenes')
subplot(2,2,3);imshow(blood_filtered_8);title('filtrada con 8 imágenes')
subplot(2,2,4);imshow(blood_filtered_16);title('filtrada con 16 imágenes')
%--------------------------------------------------------------------------
%%
% 14.	Utilizando la imagen P2gris.jpg, compuesta únicamente por un fondo 
% grisáceo de luminancia intermedia, complete los siguientes pasos:
% 
% * cargue la imagen, conviértala a escala de grises y muestre su histograma,
% * contamine con ruido speckle la imagen de grises y almacene el resultado 
% en otro fichero de imagen,
% * observe el histograma de la imagen ruidosa y confirme que el ruido tiene 
% una distribución uniforme,
% * consulte la ayuda del comando imnoise, para ver cómo se puede cambiar la 
% varianza del ruido, contamine la imagen original con ruido speckle con diferentes 
% varianzas, y observe qué ocurre con los histogramas de las distintas imágenes 
% ruidosas generadas.
%--------------------------------------------------------------------------
clear
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
P2gris = im2double(rgb2gray(imread(strcat(ruta,'P2gris.jpg'))));

%help imnoise

P2gris_speckle_004 = imnoise(P2gris,'speckle');
desviacion_de_la_media = mean(mean(P2gris))-mean(mean(P2gris_speckle_004));
display(strcat('La media ha cambiado en: ',num2str(desviacion_de_la_media),' al añadir el ruido, V=0.04'))

P2gris_speckle_0001 = imnoise(P2gris,'speckle', 0.001);
desviacion_de_la_media = mean(mean(P2gris))-mean(mean(P2gris_speckle_0001));
display(strcat('La media ha cambiado en: ',num2str(desviacion_de_la_media),' al añadir el ruido, V=0.001'))

P2gris_speckle_04 = imnoise(P2gris,'speckle',0.4);
desviacion_de_la_media = mean(mean(P2gris))-mean(mean(P2gris_speckle_04));
display(strcat('La media ha cambiado en: ',num2str(desviacion_de_la_media),' al añadir el ruido, V=0.4'))

figure
subplot(4,2,1);imshow(P2gris);title('original')
subplot(4,2,2);imhist(P2gris);title('histograma original')
subplot(4,2,3);imshow(P2gris_speckle_004);title('imagen con ruido')
subplot(4,2,4);imhist(P2gris_speckle_004);title('histograma con ruido')
subplot(4,2,5);imshow(P2gris_speckle_0001);title('imagen con ruido')
subplot(4,2,6);imhist(P2gris_speckle_0001);title('histograma con ruido')
subplot(4,2,7);imshow(P2gris_speckle_04);title('imagen con ruido')
subplot(4,2,8);imhist(P2gris_speckle_04);title('histograma con ruido')
%--------------------------------------------------------------------------
%%
% 15.	Busque una imagen oscura y poco contrastada, o créela a partir de una 
% fotografía (multiplicando por 0.1 o 0.2 sus niveles de gris). A continuación, 
% visualice dicha imagen y su histograma. Finalmente, obtenga el logaritmo de 
% dicha imagen, calculando previamente el valor óptimo de K, para asegurar que 
% el nivel máximo de gris a la salida sea el máximo posible. Visualice la imagen 
% resultante y observe la mejora obtenida. Pruebe utilizando valores de K diferentes 
% al calculado.
%--------------------------------------------------------------------------
clear
% Cargamos la imágen flowers
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
dark_flowers = im2double(rgb2gray(imread(strcat(ruta,'flowers.tif'))))*0.15;
 
%Calculamos un k tal que el histograma se desplace hasta cubrir el mayor
%rango posible
k=1/log10(1+max(dark_flowers,[],'all'));

%Valores por encima de k producirán un desplazamiento excesivo al brillante
%y por debajo de k dejarán la imagen todavía muy oscura, k aumenta el
%brillo al máximo posible sin saturar
bright_flowers=k*log10(1+dark_flowers);
still_dark_flowers=(k-10)*log10(1+dark_flowers);
to_bright_flowers=(k+10)*log10(1+dark_flowers);

figure
subplot(4,2,1);imshow(dark_flowers);title('original (oscura)')
subplot(4,2,2);imhist(dark_flowers);title('histograma original (oscura)')
subplot(4,2,3);imshow(bright_flowers);title('imagen corregida')
subplot(4,2,4);imhist(bright_flowers);title('histograma corregida')
subplot(4,2,5);imshow(still_dark_flowers);title('imagen k < mejor_k')
subplot(4,2,6);imhist(still_dark_flowers);title('histograma k < mejor_k')
subplot(4,2,7);imshow(to_bright_flowers);title('imagen k > mejor_k')
subplot(4,2,8);imhist(to_bright_flowers);title('histograma k > mejor_k')
%--------------------------------------------------------------------------
%%
% 16.	Cargue la imagen bazo.bmp y muestre su histograma. Compruebe que se 
% trata de una imagen poco contrastada. Convierta a escala de grises la imagen 
% y luego ecualice su histograma uniformemente. Visualice la imagen resultante 
% y su histograma, contrastando las diferencias con la imagen original.
%--------------------------------------------------------------------------
clear
% Cargamos la imágen bazo
ruta = '/Users/mrblissfulgrin/Documents/UAH_2019_2020/VISION_ARTIFICIAL/imagenes_clase/';
[image,map]=imread(strcat(ruta,'bazo.bmp'));
bazo = im2double(ind2gray(image,map));

contrast = max(bazo,[],'all')-min(bazo,[],'all');
display(strcat('El contraste de la imagen es: ', num2str(contrast),' (contraste máximo = 1)'))

%Cuanto menos niveles se creen para el histograma de salida la equalización
%aumenterá más el contraste
bazo_eq=histeq(bazo,20);
contrast_eq = max(bazo_eq,[],'all')-min(bazo_eq,[],'all');
display(strcat('El contraste de la imagen equalizada es: ', num2str(contrast_eq),' (contraste máximo = 1)'))

figure
subplot(2,2,1);imshow(bazo);title('original')
subplot(2,2,2);imhist(bazo);title('histograma original')
subplot(2,2,3);imshow(bazo_eq);title('imagen equalizada')
subplot(2,2,4);imhist(bazo_eq);title('histograma equalizada')
%--------------------------------------------------------------------------
%%
% 17.	Disminuya el brillo de la imagen bazo.bmp hasta que el nivel de gris 
% más bajo sea 0 y sobre esa imagen realice una ecualización gamma. Pruebe con 
% distintos valores de gamma y analice el efecto de cada uno sobre la imagen de 
% salida.



%%
% 18.	Efect�e las siguientes operaciones, relacionadas con la mejora de im�genes: 
% 
%         18.1.	Cargue y visualice la imagen ?pout.tif?.
% 
%         18.2.	Compruebe los principales par�metros de la imagen con el 
% comando imfinfo.
% 
%         18.3.	Obtenga el histograma de la misma.
% 
%         18.4.	Ecualice el histograma y muestre la imagen ecualizada. 
% 
%         18.5.	Almacene la imagen ecualizada en un fichero jpeg utilizando 
% el comando imwrite.
% 
%         18.6.	Sobre la imagen original: Optimice el contraste al m�ximo, 
% y muestre el histograma de la imagen de salida y su FFT.
% 
%         18.7.	A�ada ruido gaussiano, muestre el histograma de la imagen 
% con ruido y obtenga su FFT.
% 
%         18.8.	Aplique los siguientes filtros a la imagen con ruido y compare 
% las im�genes de salida:
% 
% *    un filtro Wiener en el dominio del espacio,
% *    un filtro paso bajo en el dominio del espacio,
% *    un filtro paso bajo en el dominio de la frecuencia, y
% *    un filtro gaussiano. Gen�relo con fspecial y pruebe con diferentes valores 
% de los par�metros.