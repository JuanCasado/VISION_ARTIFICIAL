%% OPERACIONES �TILES CON LA TOOLBOX DE IM�GENES 
%% Perfil de intensidad. 
% El comando _improfile_ calcula y traza las intensidades a lo largo de una 
% l�nea o path en una imagen. Se pueden facilitar las coordenadas de una l�nea 
% o l�neas como argumentos de entrada, o se puede definir el path deseado con 
% el rat�n. En cualquier caso, improfile utiliza la interpolaci�n para determinar 
% los valores de los puntos igualmente espaciados a lo largo del path.
% 
% Para una l�nea simple, improfile traza los valores de la intensidad en dos 
% dimensiones. Para un path m�ltiple, improfile traza los valores de la intensidad 
% en tres dimensiones. 
% 
% Si se llama a improfile sin argumentos, el cursor cambia a una cruz cuando 
% se encuentra sobre la imagen. Se puede entonces definir segmentos de l�nea como 
% se muestra a continuaci�n: 
%% 
% * -Para ratones de un bot�n seleccione los extremos de la l�nea presionando 
% el bot�n. Para finalizar presionar Shift y bot�n a la vez, o pulsar Return. 
% * Para ratones de dos o tres botones, seleccione los extremos de la l�nea 
% presionando el bot�n izquierdo. Para finalizar presionar bot�n derecho o pulsar 
% Return. 
%% 
% La funci�n improfile puede devolver las coordenadas de distintos puntos por 
% los que pasan las l�neas (x,y), las intensidades de los mismos (c), y las coordenadas 
% de los extremos de los segmentos definidos (xi,yi). Para visualizar los resultados 
% se puede utilizar plot3(x,y,c). El siguiente ejemplo visualiza la imagen spine 
% y una muestra del trazado de intensidad a lo largo de una l�nea de dicha imagen 
% con el comando improfile._improfile_.

load spine % Imagen indexada de matlab guardada en variables X y map
I=ind2gray(X,map);   % I es una imagen de intensidad double entre 0 y 1
figure, subplot(1,2,1), imshow(I);
%Sobre dibujo imagen anterior pinto cruz en puntos (x1,y1)=(7,8) y (x2,y2)=(156,179)
hold on, plot([7 156],[8 179],'r+');
%Pinta los niveles de gris (intensidad) de la linea entre (x1,y1)=(7,8) y (x2,y2)=(156,179)
subplot(1,2,2), improfile(I,[7  156],[8 179])

%% 
% En la �ltima l�nea de c�digo anterior, el primer corchete contiene las coordenas 
% x de los sucesivos puntos que determinan las l�neas, y el segundo corchete contiene 
% las coordenadas y, en un sistema coordenado de p�xel (eje x hacia la derecha 
% y eje y hacia abajo). 
%% 
% En una imagen RGB el perfil de intensidad de los niveles R,G,B se visualizar�a 
% de igual forma, con el comando improfile:

figure;
imshow(I);
improfile; %Seleccione con el raton puntos extremos de linea a ver perfil de intensidad
%% Selecci�n de p�xeles. 
% El comando impixel obtiene el valor del color del p�xel seleccionado o de 
% un conjunto de p�xeles. Sin par�metros de entrada, impixel permite usar el rat�n 
% para seleccionar puntos con el bot�n izquierdo. Cuando se pulsa Return o el 
% bot�n derecho, se a�ade el �ltimo punto y se devuelve el valor del color de 
% estos en una matriz mx3. Con las coordenadas de los p�xeles como entrada, impixel 
% retorna una lista de valores de color para los puntos dados. Por ejemplo: 

load clown
vals=impixel(X,map,[231 35],[122 50]) %impixel(X,map,[x1 x2 ...],[y1 y2 ...])
% En vals devuelve los valores R,G,B de los pixeles seleccionados
%   vals =             0.1250             0                0
%                         0.8672         0.4141            0
%% Barra de color.
% El comando _colorbar_ a�ade una barra de color a cualquier eje. Las barras 
% de color relacionan los colores en una imagen con valores f�sicos, tal como 
% la temperatura. Aqu� se muestra un uso t�pico de colorbar. 

load trees
I=ind2gray(X,map);
F=fftshift(fft2(I));
figure, imagesc(log(abs(F)));colorbar,colormap(jet)
%% 
% La funci�n colorbar funciona para cualquier tipo de trazado, y puede situar 
% la barra de color tanto horizontal como verticalmente. Sin argumentos, colorbar 
% actualiza una barra de color existente.
% 
% %% 
%