%% *Vision Artificial. GIEC.*
%% 	*Sistemas de Vision Artificial. GIC.*
% *Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos.* 
% 
% *Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 5: ejercicio 03 - Kmeans
% 
% 
% La base de datos |*fisheriris*| consiste en mediciones de (1) la longitud 
% del s�palo, (2) la anchura del s�palo, (3) la longitud del p�talo y (4) la anchura 
% del p�talo para 150 espec�menes de iris (el iris es un conjunto de especies 
% de plantas con flores llamativas). Hay 50 espec�menes de cada una de las tres 
% especies {|*setosa, versicolor y virginica*|}.
% 
% 
% 
% Step 1) Carga datos

clear all;
close all;

load fisheriris
data_iris = meas(:,1:2);
label_iris = categorical(species);
names_iris = categories(label_iris);
%% 
% 
% 
% Step 2) Visualiza datos.

plot(data_iris(:,1),data_iris(:,2),'b+','MarkerSize',5);
xlabel('Sepal length');
ylabel('Sepal width');
%% 
% 
% 
% Step 3) Kmeans

k = 3;
[idx,C] = kmeans(data_iris,k);
%% 
% Step 4) Plot clustering.

figure;
subplot(1,2,1)
gscatter(data_iris(:,1),data_iris(:,2), label_iris,'rgb','ooo',8,'on')
xlabel('Sepal length');
ylabel('Sepal width');
grid on;
legend('setosa','versicolor', 'virginica' ,'Location','NW')
title ('Fisher''s Iris dataset')

subplot(1,2,2)
hold on
plot(data_iris(idx==1,1),data_iris(idx==1,2),'r.','MarkerSize',12)
plot(data_iris(idx==2,1),data_iris(idx==2,2),'g.','MarkerSize',12)
plot(data_iris(idx==3,1),data_iris(idx==3,2),'b.','MarkerSize',12)
plot(C(1,1),C(1,2),'rx','MarkerSize',15,'LineWidth',3) 
plot(C(2,1),C(2,2),'gx','MarkerSize',15,'LineWidth',3) 
plot(C(3,1),C(3,2),'bx','MarkerSize',15,'LineWidth',3) 
xlabel('Sepal length');
ylabel('Sepal width');
grid on;
legend('Cluster 1','Cluster 2','Cluster 3','Centroid 1','Centroid 2','Centroid 3','Location','NW')
title ('Cluster Assignments and Centroids')
hold off


%% 
% Se pide:
%% 
% # Calcule la matriz de confusi�n del algoritmo K-means usando la funci�n |*confusionmat*|. 
% Tenga en cuenta que este no es un algoritmo supervisado por lo que las etiquetas 
% pueden estar cambiadas �c�mo influye esto en la matriz de confusi�n?

names = categorical();
for i = 1:size(idx, 1)
    names = [names; names_iris{idx(i)}];
end

ConfMat = confusionmat(names, label_iris);
figure;
confusionchart(ConfMat);

%%
% # Calcular la precisi�n (*acc=hits/total*) del algoritmo K-means.

total = sum(ConfMat,"all");
hits = 0;
for i = 1:size(ConfMat, 1)
    hits = hits + ConfMat(i,i);
end
acc=hits/total

%acc = 0.8133; La clasificación es peor

%%
% # Repita las secciones anteriores pero usando pétalos en lugar de sépalos 
% (|*data_iris = meas(:,3:4);*|). En qué caso se obtienen mejores resultados?
close all
clear all

load fisheriris
data_iris = meas(:,3:4);
label_iris = categorical(species);
names_iris = categories(label_iris);
plot(data_iris(:,1),data_iris(:,2),'b+','MarkerSize',5);
xlabel('Petal length');
ylabel('Petal width');
k = 3;
[idx,C] = kmeans(data_iris,k);
figure;
subplot(1,2,1)
gscatter(data_iris(:,1),data_iris(:,2), label_iris,'rgb','ooo',8,'on')
xlabel('Sepal length');
ylabel('Sepal width');
grid on;
legend('setosa','versicolor', 'virginica' ,'Location','NW')
title ('Fisher''s Iris dataset')

subplot(1,2,2)
hold on
plot(data_iris(idx==1,1),data_iris(idx==1,2),'r.','MarkerSize',12)
plot(data_iris(idx==2,1),data_iris(idx==2,2),'g.','MarkerSize',12)
plot(data_iris(idx==3,1),data_iris(idx==3,2),'b.','MarkerSize',12)
plot(C(1,1),C(1,2),'rx','MarkerSize',15,'LineWidth',3) 
plot(C(2,1),C(2,2),'gx','MarkerSize',15,'LineWidth',3) 
plot(C(3,1),C(3,2),'bx','MarkerSize',15,'LineWidth',3) 
xlabel('Sepal length');
ylabel('Sepal width');
grid on;
legend('Cluster 1','Cluster 2','Cluster 3','Centroid 1','Centroid 2','Centroid 3','Location','NW')
title ('Cluster Assignments and Centroids')
hold off

names = categorical();
for i = 1:size(idx, 1)
    names = [names; names_iris{idx(i)}];
end

ConfMat = confusionmat(names, label_iris);
figure;
confusionchart(ConfMat);

total = sum(ConfMat,"all");
hits = 0;
for i = 1:size(ConfMat, 1)
    hits = hits + ConfMat(i,i);
end
acc=hits/total

%acc = 0.9467; La clasificación es mejor


