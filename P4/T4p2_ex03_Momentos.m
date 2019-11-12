%% 	*Vision Artificial. GIEC.*
%% 	*Sistemas de Vision Artificial. GIC.*
% *Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos.* 
% 
% *Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 4.2: ejercicio 03  - Momentos
% 

general_m = [];
central_m = [];
hu_m = [];

% Step 1) Read Image

% Read original image.
IA = imread('A.jpg');
if size(IA,3) == 3
    IA = rgb2gray(IA); 
end
IA = imbinarize(IA);
IA = imcomplement(IA);

IAg = general_moments(IA, 4);
IAc = central_moments(IA, 4);
IAh = hu_moments(IA);
general_m = [general_m {reshape(IAg,1,[])}];
central_m = [central_m {reshape(IAc,1,[])}];
hu_m = [hu_m {reshape(IAh,1,[])}];

figure
imshow(IA);
title('Original image');
%% 
% Step 2) Translate, Resize and Rotate the Image
% 
% Translation
tx = 10; % x translation
ty = 5; % y translation
IA_t = imtranslate(IA,[tx, ty]); % Translated image

IA_tg = general_moments(IA_t, 4);
IA_tc = central_moments(IA_t, 4);
IA_th = hu_moments(IA_t);
general_m= [general_m {reshape(IA_tg,1,[])}];
central_m= [central_m {reshape(IA_tc,1,[])}];
hu_m= [hu_m {reshape(IA_th,1,[])}];

figure
imshow(IA_t)
title('Translated image');
%% 
% Scaled

scale = 0.7; % scale factor.
IA_s = imresize(IA, scale); % scaled image

IA_sg = general_moments(IA_s, 4);
IA_sc = central_moments(IA_s, 4);
IA_sh = hu_moments(IA_s);
general_m= [general_m {reshape(IA_sg,1,[])}];
central_m= [central_m {reshape(IA_sc,1,[])}];
hu_m= [hu_m {reshape(IA_sh,1,[])}];

figure
imshow(IA_s)
title('Scaled image');
%% 
% Rotation

theta = 30; % the angle, theta.
IA_r = imrotate(IA,theta); % rotated A image

IA_rg = general_moments(IA_r, 4);
IA_rc = central_moments(IA_r, 4);
IA_rh = hu_moments(IA_r);
general_m= [general_m {reshape(IA_rg,1,[])}];
central_m= [central_m {reshape(IA_rc,1,[])}];
hu_m= [hu_m {reshape(IA_rh,1,[])}];

figure
imshow(IA_r)
title('Rotated image');
%% 
% Translate, Resize and Rotate

IA_ts = imresize(IA_t, scale); % Translated and scaled A image
IA_tsr = imrotate(IA_ts,theta);% Translated, scaled and rotated A image

IA_tsrg = general_moments(IA_tsr, 4);
IA_tsrc = central_moments(IA_tsr, 4);
IA_tsrh = hu_moments(IA_tsr);
general_m= [general_m {reshape(IA_tsrg,1,[])}];
central_m= [central_m {reshape(IA_tsrc,1,[])}];
hu_m= [hu_m {reshape(IA_tsrh,1,[])}];

figure
imshow(IA_tsr)
title('Translated, scaled and rotated image');
%% 
% Se pide:
%% 
% # Calcule los momentos generales hasta el 1er orden (m00, m01, m10 y m11) 
% de la imagen original (|*IA*|) y la imagen transladada (|*IA_t*|). Utilice la 
% funci�n |*general_moments*| (paso 3). �Hay alg�n momento igual, se pueden considerar 
% estos momentos invariantes a la translaci�n? Calcule los centroides a partir 
% de los momentos y dibujelos en las im�genes.
%%
% # Calcule los momentos centrales hasta el primer orden de la imagen original 
% (|*IA*|), la imagen transladada (|*IA_t*|) y la imagen rotada (|*IA_r*|). Utilice 
% la funci�n |*central_moments*| (paso 4). �Son estos momentos invariantes a la 
% translaci�n y a la rotaci�n?
%%
% # Calcule los momentos de Hu de la imagen original (|*IA*|), la imagen transladada 
% (|*IA_t)*|, la imagen escalada (|*IA_s),*| la imagen rotada (|*IA_r*|) y la 
% imagen transladada, escalada y girada (|*IA_tsr*|). Utilize la funci�n |*hu_moments*| 
% (paso 5). �Son estos momentos invariantes a los cambios de escala, a la translaci�n 
% y a la rotaci�n?
%%
% # Carge la imagen |*'B.jpg'*| y comparar los valores de los momentos Hu con 
% los obtenidos para la imagen |*'A.jpg'*|, �son iguales o diferentes?
IB = imread('B.jpg');
if size(IB,3) == 3
    IB = rgb2gray(IB); 
end
IB = imbinarize(IB);
IB = imcomplement(IB);

IBg = general_moments(IB, 4);
IBc = central_moments(IB, 4);
IBh = hu_moments(IB);
general_m= [general_m {reshape(IB,1,[])}];
central_m= [central_m {reshape(IB,1,[])}];
hu_m= [hu_m {reshape(IB,1,[])}];

figure
imshow(IB);
title('Original image');

%%
general_error = [];
central_error = [];
hu_error = [];
for i = 1:length(general_m)
    error = 0;
    for j = 1:length(general_m{1})
        error = error + abs(general_m{1}(j) - general_m{i}(j));
    end
    general_error = [general_error (error < 0.1)];
end
for i = 1:length(central_m)
    error = 0;
    for j = 1:length(central_m{1})
        error = error + abs(central_m{1}(j) - central_m{i}(j));
    end
    central_error = [central_error (error < 0.1)];
end
for i = 1:length(hu_m)
    error = 0;
    for j = 1:length(hu_m{1})
        error = error + abs(hu_m{1}(j) - hu_m{i}(j));
    end
    hu_error = [hu_error (error < 0.1)];
end

% Momentos generales nos son invariantes a transformaciones
% Momentos centrales solo son invariantes a traslaciones
% Momentos de hu son invariantes a todas las transformaciones y detectatan
% objetos que son distintos


