ima=imread("D:\UAH\4º\SISTEMAS DE VISIÓN ARTIFICIAL\3\flowers.tif");
imshow(ima);
X=kmeans(ima,3);
https://es.mathworks.com/help/stats/kmeans.html
%SEGMENTACIÓN NO SUPERVISADA BASADA EN TÉCNICAS DE 
%CLUSTERING (AGRUPAMIENTO)