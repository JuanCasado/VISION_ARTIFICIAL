ima=imread("D:\UAH\4�\SISTEMAS DE VISI�N ARTIFICIAL\3\flowers.tif");
imshow(ima);
X=kmeans(ima,3);
https://es.mathworks.com/help/stats/kmeans.html
%SEGMENTACI�N NO SUPERVISADA BASADA EN T�CNICAS DE 
%CLUSTERING (AGRUPAMIENTO)