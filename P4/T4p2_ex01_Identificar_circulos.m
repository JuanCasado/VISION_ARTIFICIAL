%% *Vision Artificial. GIEC.*
%% 	*Sistemas de Vision Artificial. GIC.*
% *Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos.* 
% 
% *Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 4.2: ejercicio 01  - Identificaci�n de objetos circulares
% 
% 
% 1) Lee la imagen

RGB = imread('pillsetc.png');
imshow(RGB);
%% 
% 2) Umbraliza la imagen

I = rgb2gray(RGB);
bw = imbinarize(I);
imshow(bw)
%% 
% 3) Elimina el ruido
% 
% Usando operaciones morfol�gicas se eliminan los p�xeles que no pertenecen 
% a los objetos de inter�s.

% remove all object containing fewer than 30 pixels
bw = bwareaopen(bw,30);

% fill a gap in the pen's cap
se = strel('disk',2);
bw = imclose(bw,se);

% fill any holes, so that regionprops can be used to estimate
% the area enclosed by each of the boundaries
bw = imfill(bw,'holes');

imshow(bw)
%% 
% 4) Encuentra los contornos
% 
% Nos centramos s�lo en los l�mites exteriores. La opci�n |'noholes'| acelerar� 
% el proceso al evitar que la funci�n |*bwboundaries*| busque contornos internos. 

[B,L] = bwboundaries(bw,'noholes');

% Display the label matrix and draw each boundary
figure;
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
  boundary = B{k};
  plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end
hold off
%% 
% Se pide:
%% 
% # Calcule el �rea y el per�metro de cada objeto utilizando la funci�n |*regionprops*|. 
% Utilice estos resultados para calcular la siguiente m�trica |*F=4*pi*�rea/per�metro^2*| 
% que indica la circularidad de un objeto. Esta m�trica es igual a 1 s�lo para 
% un c�rculo y es menor para cualquier otra forma. El proceso de discriminaci�n 
% puede controlarse estableciendo un umbral adecuado. Note que la matriz de etiquetas 
% devuelta por |*bwboundaries*| puede ser reutilizada por regionprops.

characteristics = regionprops ('table', L, 'Area', 'Perimeter');
lenB = size(B);
F = zeros (1, lenB(1));
for i = 1:lenB(1)
    F(i) = 4*pi*characteristics.Area(i)/characteristics.Perimeter(i)^2;
end

figure;
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
    if abs(F(k) - 1) < 0.1
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
    end
end
hold off
%%
% # Cargue la imagen |*'google.jpg'*| y determine, utilizando alg�n par�metro 
% calculado con la funci�n |*regionprops*|, si los objetos son c�ncavos o convexos. 
% Nota: En esta pregunta hay que tener en cuenta que el primer plano es oscuro 
% y el fondo claro, por lo que hay que modificar los pasos 2 y 3 para obtener 
% un etiquetado correcto.

RGB = imread('google.jpg');
imshow(RGB);
%%
I = rgb2gray(RGB);
bw = imbinarize(I);
bw = imcomplement(bw);
bw = imfill(bw,'holes');
imshow(bw)
%%
[B,L] = bwboundaries(bw, 'noholes');
figure;
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
  boundary = B{k};
  plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end
hold off
%%
characteristics = regionprops ('table', L, 'ConvexHull', 'Area', 'ConvexArea');
figure;
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(characteristics.ConvexHull)
  if abs(characteristics.ConvexArea(k) - characteristics.Area(k)) < 100
    boundary = characteristics.ConvexHull{k};
    plot(boundary(:,1), boundary(:,2), 'w', 'LineWidth', 2)
  end
end
hold off

