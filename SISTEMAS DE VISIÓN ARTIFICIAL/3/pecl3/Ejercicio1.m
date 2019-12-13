%Creamos una imagen en negro
BW1=zeros(256,256); 

%Creamos los objetos en diferentes niveles de gris
BW1(30:60,30:90)=1; 
BW1(120:220,30:70)=0.7; 
BW1(150:250,150:250)=0.3; 

%Introduce ruido gaussiano en BW1 
J=imnoise(BW1,'gaussian',0,0.005); 

%Filtra la imagen
K=wiener2(J,[5 5]); 

%Mostramos la imagen y el histograma
imshow(BW1); title('Imagen BW1 ');
figure; imshow(K); title('Imagen K '); figure;imhist(K);xlabel('nivel de gris');ylabel('No de píxeles');

%Mostramos los objetos por separado

Um=(K >= 0.92); %+ (K <= 0.4);
figure; 
subplot(1,3,1), imshow(Um), title('Objeto 1');

Um=(K >= 0.6)-(K >= 0.8); %+ (K <= 0.4);
subplot(1,3,2), imshow(Um), title('Objeto 2');

Um=(K >= 0.2)-(K >= 0.37); %+ (K <= 0.4);
subplot(1,3,3), imshow(Um), title('Objeto 3');

