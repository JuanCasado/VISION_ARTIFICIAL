%% *Vision Artificial. GIEC.*
%% *	Sistemas de Vision Artificial. GIC.*
% *	Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos. *
% 
% *  Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 3: ejercicio 01-b
%% *Segmentaci�n supervisada no lineal, con modelos gaussianos*
% **
% 
% El mayor problema de la segmentaci�n anterior es el c�lculo de los umbrales. 
% Adem�s, los objetos se suelen distribuir en el histograma de forma gaussiana. 
% Se puede hacer una segmentaci�n mejor caracterizando los niveles de gris de 
% los objetos de la imagen y del fondo mediante modelos basados en funciones de 
% densidad de probabilidad gaussianas, como se muestra en la figura 1 y obteniendo, 
% luego, el umbral �ptimo o viendo el grado de pertenencia de un p�xel (con un 
% determinado nivel de gris) a uno u otro modelo (objeto, background...) y clasificando 
% despu�s el p�xel al modelo cuyo grado de pertenencia es mayor.
% 
%  
% 
% Fig. 1
% 
% Para la creaci�n de estos modelos gaussianos de los objetos �nicamente 
% se necesitan los par�metros _*media *m_ y _*varianza (desviaci�n t�pica) *_$\sigma$ 
% de los niveles de gris del objeto.
% 
% Cargue la imagen '|*rice.png|*' en el espacio de trabajo y muestrela.

I = imread('rice.png');
imshow(I)
dI = im2double(I);
%% 
% Seleccione con el raton, haciendo click con el bot�n izquierdo, al menos 
% 10 pixels de fondo y finalize pulsando enter.

figure(1);
title('Seleccione pixeles del fondo.');
imshow(dI);
val = impixel(dI);
background = val;
%% 
% Seleccione con el raton, haciendo click con el bot�n izquierdo, al menos 
% 5 pixels de objetos (granos) y finalize pulsando enter.

title('Selecciona pixeles de los objetos en primer plano');
val=impixel(dI);
foreground=val;
%close (1)
%% 
% A partir de los p�xeles seleccionados obtenga la _*media_* y _*varianza 
% (desvaci�n t�pica)_*  de la clase fondo y clase objeto:
%%
mean_b = mean(background(:,1));  %Media de la clase fondo
mean_f = mean(foreground(:,1)); %Media de la clase objeto 
std_b = std(background(:,1));   %Desviacion tipica de la clase fondo
std_f = std(foreground(:,1));  %Desviacion tipica de la clase objeto
%% 
% 
% 
% Segmente la imagen clasificando cada p�xel de la misma (en funci�n de su 
% nivel de gris) en el modelo para el cual la funci�n densidad de probabilidad 
% (fdp) sea mayor (grado de pertenencia mayor). 
% 
% NOTA: suponga las clases son equiprobables (P1=P2 en la Figura 1).
% 
%  

tic %para computar cuanto tarda este algoritmo desde este punto

S=zeros(size(dI,1),size(dI,2)); %Imagen a segmentar S inicializada ceros (fondo -> todo negro)

for i=1:1:size(dI,1)         %Para todas las filas de la imagen
    for j=1:1:size(dI,2)      %Para todas las columnas de la imagen
        
        x=dI(i,j); % Se toma cada pixel "x" de la imagen
        
        % se calcula el valor en la función densidad de probabilidad para
        % el valor "x" para cada clase.
        fdp_b = (1/(std_b*(sqrt(2*pi)))) * exp(-(x-mean_b)^(2)/(2*std_b^(2))); %fdp normal
        fdp_f = (1/(std_f*(sqrt(2*pi)))) * exp(-(x-mean_f)^(2)/(2*std_f^(2))); %fdp normal
        if fdp_f > fdp_b % Pixel en posicion (i,j) tiene  > pertenencia a la fdp normal clase grano
               S(i,j) = 1; % Pone a "1" (blanco) el pixel en posicion (i,j) pues pertenece a la clase grano
        end
        
        %ERROR SIMPLIFICADO
        %fdp_b = mean_b - x;
        %fdp_f = mean_f - x;
        %if (abs(fdp_b) - abs(fdp_f)) > 0
        %    S(i,j) = 1;
        %end
    end
end

toc %devuelve cuanto tardo el algoritmo desde el inicio del tic

S_RGB = label2rgb(S,'jet','y');
figure
imshowpair(I,S_RGB,'montage');   
title('Imagen segmentada (método supervisado no lineal)');
%% 
% Se pide:
% 
% # Represente el histograma y marque en el mismo el valor de las medias obtenidas 
% para el fondo y los objetos.

imhist(dI)
hold on
plot([mean_f], zeros(1,2),'ro', 'LineWidth',2);
plot([mean_b], zeros(1,2),'bo', 'LineWidth',2);
plot([mean_f+std_f,mean_f-std_f], zeros(1,2),'rx', 'LineWidth',1);
plot([mean_b+std_b,mean_b-std_b], zeros(1,2),'bx', 'LineWidth',1);
title('Colocación de los centroides de las clases tras entrenar');
hold off;

% # Vuelva a ejecutar el programa y compruebe la influencia de la selecci�n 
% de p�xeles seleccionados en la segmentaci�n.
%%
%GOOD VALUES
mean_b = 0.3464;
mean_f = 0.6941;
std_b = 0.0830;
std_f = 0.0793;
%%
%INVERSE VALUES
% Si al seleccional lo píxeles del fondo hacemos click en los granos y al
% seleccionar los granos en el fondo se nos invierte la selección
mean_b = 0.6879;
mean_f = 0.3523;
std_b = 0.0801;
std_f = 0.0825;
%%
%BAD VALUES
% Si elegimos valores alatorios la segementación también lo será
mean_b = 0.5136;
mean_f = 0.4993;
std_b = 0.2755;
std_f = 0.2895;
