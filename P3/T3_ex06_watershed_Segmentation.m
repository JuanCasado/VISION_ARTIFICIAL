%% *Vision Artificial. GIEC.*
%% 	*Sistemas de Vision Artificial. GIC.*
% *Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos.* 
% 
% *Department of Electronics. University of Alcal�. SPAIN.*
% 
% 
%% Topic 3: exercise 06 
%% Region-Based Segmentation
%% *1.* *Segmentaci�n basada en regiones, watershed*
% La Transformada Watershed aplica conceptos topol�gicos para segmentar una 
% imagen, viendo esta, en niveles de gris, como una superficie con embalses (catchment 
% basins), m�nimos de la imagen, que se van llenando de agua. La transformada 
% devuelve las presas o diques (watershed lines) que habr�a que poner para que 
% el agua no pasase de un embalse a otro.
% 
% Entender la Transformada Watershed requiere que se piense en una imagen como 
% una superficie. Por ejemplo, considere la imagen de abajo:
% 
% Figura 1. Imagen generada sint�ticamente de dos manchas oscuras y su interpretaci�n 
% por parte del algoritmo watershed.    
% 
% Si imaginas que las �reas brillantes son "altas" y las oscuras "bajas", entonces 
% podr�a parecerse a la superficie de la derecha. Con las superficies, es natural 
% pensar en t�rminos de embalses (catchment basins) y de diques (watershed lines). 
% La clave para utilizar la funci�n watershed para la segmentaci�n es �sta: Cambie 
% su imagen en otra imagen cuyas embalses (zonas oscuras) sean los objetos que 
% desea identificar.
% 
% Este algoritmo est� implementado en Matlab mediante la funci�n |*watershed*|, 
% que se aplicar�a a una imagen cuyos objetos a segmentar ser�an los valores m�nimos 
% de la imagen.

close all;
clear all;
clc;
%% 
% Se crea una imagen binaria que contenga dos objetos circulares superpuestos 
% y se muestran

center1 = -10;
center2 = -center1;
dist = sqrt(2*(2*center1)^2);
radius = dist/2 * 1.4;
lims = [floor(center1-1.2*radius) ceil(center2+1.2*radius)];
[x,y] = meshgrid(lims(1):lims(2));
bw1 = sqrt((x-center1).^2 + (y-center1).^2) <= radius;
bw2 = sqrt((x-center2).^2 + (y-center2).^2) <= radius;
bw = bw1 | bw2;
figure
imshow(bw,'InitialMagnification','fit'), 
title('Dos objetos circulares superpuestos')
%% 
% Se calcula la transformaci�n de distancia de la imagen binaria complementada.

nbw = ~bw;
D = bwdist(nbw);
figure
imshow(D,[],'InitialMagnification','fit')
title('Transformaci�n de distancia de la imagen binaria complementada')
%% 
% Se complementa la transformaci�n de distancia y se fuerzan los p�xeles que 
% no pertenezcan a los objetos a valor |*Inf*|

D = -D;
D(nbw) = -Inf;
imshow(D,[],'InitialMagnification','fit')
title('Transformaci�n de distancia complementada');
%% 
% Se calcula la transformaci�n de Watershed y se visualiza la matriz de etiquetas 
% resultante como una imagen RGB

L = watershed(D);
rgb = label2rgb(L,'jet',[.5 .5 .5]);
figure
imshow(rgb,'InitialMagnification','fit')
title(sprintf('Transformada Watershed. Objetos segmentados: %d',max(max(L,[],1),[],2)));

%% 
% # �qu� ocurrir�a si en lugar de utilizar la imagen binaria complementada (|*~bw*|) 
% se utilizase (|*bw*|)? realice el cambio y comente los resultados.

nbw = bw;
D = bwdist(nbw);
figure
imshow(D,[],'InitialMagnification','fit')
title('Transformaci�n de distancia de la imagen binaria complementada')

D = -D;
D(nbw) = -Inf;
figure
imshow(D,[],'InitialMagnification','fit')
title('Transformaci�n de distancia complementada');

L = watershed(D);
rgb = label2rgb(L,'jet',[.5 .5 .5]);
figure
imshow(rgb,'InitialMagnification','fit')
title(sprintf('Transformada Watershed. Objetos segmentados: %d',max(max(L,[],1),[],2)));

%%
% # Cargue la imagen |*'rice.png'*| umbral�zela y realize una segmentaci�n utilizando 
% la trasnformaci�n Watershed, tal y como se ha hecho en el ejemplo dado. �Existe 
% sobre-segmentaci�n, es decir, se han segmentados muchos m�s objetos de los que 
% hay en la imagen?

I = imread('rice.png');
figure
imshow(I)
T = graythresh(I);
BW = ~imbinarize(I,T);
figure
imshow(BW)

D = bwdist(BW);
figure
imshow(D)
D = -D;
D(BW) = -Inf;

L = watershed(D);
rgb = label2rgb(L,'jet',[.5 .5 .5]);
figure
imshow(rgb);
title(sprintf('Transformada Watershed. Objetos segmentados: %d',max(max(L,[],1),[],2)));

% Se produce sobresegmentación debido a que watershed solo funciona bien
% para segmentar formas circulares. Cuando las formas se alegan mucho de la
% circunferencia, en este caso por ser muy alargadas el cálculo de la
% distancia a los bordes produce que exista sobre segmentación.

%%
% # Si se ha producido sobre-segmentaci�n realice un rellenado de los objetos 
% segmentados en el apartado anterior con valor 0 (|*BWrellenada=bwfill(L==0,'holes')*|) 
% y vuelva a hacer el etiquetado a partir de la imagen |*BWrellenada*|. Finalmente 
% compruebe si el n�mero de objetos segmentados es menor. 

fL=bwfill(L==0,'holes');
labeled = bwlabel(fL);
rgb = label2rgb(labeled,'jet',[.5 .5 .5]);
figure
imshow(rgb)
title(sprintf('Transformada Watershed. Objetos segmentados: %d',max(max(labeled,[],1),[],2)));