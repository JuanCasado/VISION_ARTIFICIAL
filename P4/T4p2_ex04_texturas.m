%% *Vision Artificial. GIEC.*
%% 	*Sistemas de Vision Artificial. GIC.*
% *Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos.* 
% 
% *Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 4.2: ejercicio 04  - Texturas
% 
% 
% Step 1) Read Image

clear all
close all

imagenames = {'texture-stone.png','texture-sand.png','texture-linseeds.png', ...
              'texture-canvas.png','texture-pattern1.png','texture-pattern2.png'};

textureImg=[];
for n=1:length(imagenames)
    textureImg{n} = imread(imagenames{n});
end

%% 
% Step 3) co-ocurrence matrix

len = 5;
% [row_offset, col_offset]
offsets = [0 len];

%co-ocurrence matrix

%% 
% Step 4) Displays the image of the first GLCM with scaled colors

% imagesc(glcm)
% colormap jet
% colorbar
%% 
% Se pide:
%% 
% # Calcule la entrop�a de todas las im�genes de patrones, usando la funci�n 
% |*entropy*|, de la lista de im�genes y ord�nelas, usando la funci�n |*sort*|, 
% en orden creciente de entrop�a, de la m�s baja a la m�s alta (paso 2). �Qu� 

entropy = [];
for n=1:length(imagenames)
    histogram_with0 = imhist(textureImg{n});
    histogram = [];
    added = 1;
    for i=1:length(histogram_with0)
        if histogram_with0(i) > 0
            histogram(added) = histogram_with0(i);
            added = added+1;
        end
    end
    entropy(n) = -sum(histogram.*log2(histogram));
end

[entropy, indexes] = sort(entropy);
figure
for n=1:length(imagenames)
    subplot(1,length(imagenames),n);imshow(textureImg{indexes(n)});title(entropy(n))
end

%%
% imagen tiene la menor entrop�a y por qu�? Obtenga conclusiones.

% La imagen con menor entropía es la que es más uniforme, la que tiene más
% entropía es la más aleatoria

%%
% # Lea la ayuda de la funci�n |*graycomatrix*| para entender todos sus par�metros 
% (<https://es.mathworks.com/help/images/ref/graycomatrix.html https://es.mathworks.com/help/images/ref/graycomatrix.html>) 
% Defina _*offsets*_ de direcci�n variable ( 0�, 45�, 90�, 135�) y longitud (len=5) 
% y util�celos para crear un conjunto de matrices de co-ocurrencias (GLCMs), usando 
% la funci�n de |*graycomatrix*|, para las texturas: '|*texture-linseeds.png'*| 
% y |*'texture-pattern2.png'*|. Muestra la imagen del primer GLCM con colores 
% escalados, para ello descomente el c�digo del paso 4 y ad�ptelo.

D = 5;
offsets = [0 D;-D D;-D 0;-D -D];
figure
for n=1:length(imagenames)
    for i = 1:4
        subplot(4,4*length(imagenames),n*i);
        imshow(graycomatrix(textureImg{indexes(n)}, 'offset', offsets(i,:), 'Symmetric', false));
        title(entropy(n))
    end
end

