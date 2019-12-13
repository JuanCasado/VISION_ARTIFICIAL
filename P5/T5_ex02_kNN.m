%% *Vision Artificial. GIEC.*
%% 	*Sistemas de Vision Artificial. GIC.*
% *Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos.* 
% 
% *Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 5: ejercicio 02 - k-Nearest Neighbour (kNN)
% 
% 
% La base de datos |*hospital*| se ha dividido en dos grupos: 60% para entrenamiento 
% y 40% para test.
% 
% Step 1) Carga datos

clear all;
close all;

% base de datos 
load hospital;
% se utiuliza solo la presi�n sanguinea
data = [hospital.BloodPressure];

rng(1)
% se obtienen una distribuci�n aleatoria de los �ndices del tama�o de los
% datos
idx = randperm(length(data))';

% 60% para entrenamiento y 40% para test
distribution_train = 0.6;
idx_train = idx(1:length(data)*distribution_train);
idx_test = idx(length(data)*distribution_train+1:length(data));

% valores y etiquetas para entrenamiento
data_train = data(idx_train,:);
label_train = hospital.Smoker(idx_train); % 'Smoker' = 1, 'Non-Smoker' = 0

tabulate(label_train)

% valores y etiquetas para test
data_test = data(idx_test,:);
label_test = hospital.Smoker(idx_test); % 'Smoker' = 1, 'Non-Smoker' = 0

tabulate(label_test)
%% 
% Step 2) Visualiza los datos usando un gr�fico de dispersi�n

gscatter(data_train(:,1),data_train(:,2), label_train,'rb','o+',8,'on')
xlabel('Systolic BloodPressure');
ylabel('Diastolic BloodPressure');
legend('Non-Smoker','Smoker', 'Location','northwest')
%% 
% Step 3) Entrenamiento del modelo

k = 10;
%ClassifierModel = fitcknn(data_train,label_train,'NumNeighbors',k);
ClassifierModel = fitcnb(data_train,label_train);
%% 
% Step 4) Superficie de decisi�n

% grid
x1range = min(data_train(:,1)):.05:max(data_train(:,1));
x2range = min(data_train(:,2)):.05:max(data_train(:,2));
[xx1, xx2] = meshgrid(x1range,x2range);
XGrid = [xx1(:) xx2(:)];

% predicci�n
predictions_mesh = predict(ClassifierModel,XGrid);
% Superficie de decisi�n
figure
hold on;
gscatter(xx1(:), xx2(:), predictions_mesh,'yc');
title('K-Nearest Neighbor')


% se sobrescriben los datos de entrenamiento
gscatter(data_train(:,1),data_train(:,2), label_train,'rb','o+',8,'on')
xlabel('Systolic BloodPressure');
ylabel('Diastolic BloodPressure');
legend on, axis tight
legend('Non-Smoker','Smoker', 'Location','northwest')
hold off

%% 
% Se pide:
%% 
% # Obtenga la predicci�n del conjunto de datos de test usando la siguiente 
% funci�n: |*predict();*| y dibuje los resultados (predicci�n y ground truth).
% # Calcule la matriz de confusi�n del |*ClassifierModel*| utilizando la funci�n 
% |*confusionmat*|.

test_clasification = predict(ClassifierModel, data_test);

% Superficie de decisi�n
figure
hold on;
gscatter(xx1(:), xx2(:), predictions_mesh,'yc');
title('K-Nearest Neighbor')
% se sobrescriben los datos de entrenamiento
gscatter(data_test(:,1),data_test(:,2), test_clasification,'rb','o+',8,'on')
xlabel('Systolic BloodPressure');
ylabel('Diastolic BloodPressure');
legend on, axis tight
legend('Non-Smoker','Smoker', 'Location','northwest')
hold off


%%
% # Calcule la especificidad y sensibilidad como: |especificidad = TN/(TN+FP)| 
% y |sensibilidad = TP/(TP+FN)|, indicando qu� clase considera como positiva. 
% Nota: Estos par�metros s�lo se pueden calcular para clasificadores binarios.

TP = 0;
TN = 0;
FP = 0;
FN = 0;
for i = 1:size(label_test,1)
    if test_clasification(i) && label_test(i)      % Era 1 y da 1
        TP = TP + 1;
    elseif test_clasification(i) && ~label_test(i) % Era 0 y da 1
        FP = FP + 1;
    elseif ~test_clasification(i) && label_test(i) % Era 1 y da 0
        FN = FN + 1;
    else                                           % Era 0 y da 0
        TN = TN + 1;
    end
end
display("--------------")
especificidad = TN/(TN+FP);
sensibilidad = TP/(TP+FN);
display(TP)
display(TN)
display(FP)
display(FN)
display(especificidad)
display(sensibilidad)

%%
ConfMat = confusionmat(label_test, test_clasification);
figure;
confusionchart(ConfMat);

