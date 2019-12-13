%% *Vision Artificial. GIEC.*
%% 	*Sistemas de Vision Artificial. GIC.*
% *Miguel Angel Garcia, Juan Manuel Miguel, Sira Palazuelos.* 
% 
% *Departamento de Electr�nica. Universidad de Alcal�.*
% 
% 
%% Tema 5: ejercicio 01  - Perceptr�n
% 
% 
% Step 1) Input and target vectors

clear all
close all
% Each of the four column vectors in X defines a 2-element input vectors
P = [2 1 -2 -1; 2 -2 2 1];
% The row vector T defines the vector's target categories. 
T = [0 1 0 1];
% Plot input/target vectors
plotpv(P,T);
grid on;
% PERCEPTRON crea una nueva red neuronal con una sola neurona
net = perceptron;
% CONFIGURE configura la red con los datos P y T (Normalmente el paso de configuraci�n puede ser omitido ya que se hace autom�ticamente con ADAPT o TRAIN)
net = configure(net,P,T);
Weight(1,:) = net.IW{1};
Bias(1,:) = net.b{1};
Y = []; % valores de salida de la red
E = []; % errores de la red
plotpv(P,T);
grid on;
for i=1:2
    for n=1:length(P)

        [net,Y(n),E(n)] = adapt(net,P(:,n),T(:,n));
        Weight(n+1,:) = net.IW{1};
        Bias(n+1,:) = net.b{1};
        
        figure
        hold on
        plotpv(P,T);
        grid on
        linehandle = plotpc(net.IW{1},net.b{1});
        set(linehandle, 'Color', 'g', 'LineWidth', 1);
        title('Decision boundary');
        hold off
    end
end

% Final plotting decision boundary
figure;
hold on
plotpv(P,T);
grid on;
linehandle = plotpc(net.IW{1},net.b{1});
set(linehandle, 'Color', 'r', 'LineWidth', 2);
title('Decision boundary');
hold off
%% 
% Step 4) Simulation
% 
% 
%% 
% Se pide
%% 
% # Ejecute el comando |*view(net)*| para ver un diagrama gr�fico de la red 
% neuronal. Identifique entradas, salidas, capas...

view(net)


%%
% # La funci�n |*adapt*| (paso 3) actualiza la red para cada ciclo de entrenamiento 
% y devuelve una nueva red que deber�a clasificar mejor. Compruebe la evoluci�n 
% de la matriz de pesos (|*IW{1}*|), y del vector de bias (|*net.b{1}*|) �por 
% qu� cambian los pesos y el bias?  

%Los pesos y las bias cambian debido a los errores de clasificación
%modificándose por descenso del graciente hasta que el error sea mínimo.
clear all
close all
P = [2 1 -2 -1; 2 -2 2 1];
T = [0 1 0 1];
net2 = perceptron;
net2 = train(net2,P,T);
plotpv(P,T);
hold on
grid on
linehandle = plotpc(net2.IW{1},net2.b{1});
set(linehandle, 'Color', 'g', 'LineWidth', 1);
title('Decision boundary');
hold off


%%
% # Despu�s de ejecutar el punto anterior. �Es correcta la frontera de decisi�n 
% final? �Por qu�?

% La frontera de decisión es correcta pues todos los puntos están bien
% clasificados, no obstante no es idónea pues podría ser mejor, una
% clasificación con SVM hubiera producido otra recta.

%%
% # Utilice el c�digo 1 (CODE 1) para realizar un entrenamiento que llame a 
% la funci�n |*adapt*| hasta que la suma del error cuadr�tico (funci�n |*sse*|) 
% sea nula o el n�mero de interaciones |*n*| llegue a 100. �se obtiene una fontera 

clear all
close all
P = [2 1 -2 -1; 2 -2 2 1];
T = [0 1 0 1];
net3 = perceptron;
net3 = configure(net3,P,T);
mean_error = 1000;
Weight(1,:) = net3.IW{1};
Bias(1,:) = net3.b{1};
Y = []; % valores de salida de la red
E = []; % errores de la red
plotpv(P,T);
grid on;
count = 0;
while mean_error > 0.00001 && count < 200
    for n=1:length(P)
        [net3,Y(n),E(n)] = adapt(net3,P(:,n),T(:,n));
        Weight(n+1,:) = net3.IW{1};
        Bias(n+1,:) = net3.b{1};
    end
    mean_error = sse(E)
    count = count + 1;
    figure
    hold on
    plotpv(P,T);
    grid on
    linehandle = plotpc(net3.IW{1},net3.b{1});
    set(linehandle, 'Color', 'g', 'LineWidth', 1);
    title('Decision boundary');
    hold off
end

% Final plotting decision boundary
figure;
hold on
plotpv(P,T);
grid on;
linehandle = plotpc(net3.IW{1},net3.b{1});
set(linehandle, 'Color', 'r', 'LineWidth', 2);
title('Decision boundary');
hold off

%%
% # Utilice el c�digo 2 para obtener nuevos valores de entrada aleatorios (|*P_sim*|). 
% Realice la simulaci�n, con la funci�n |*sim*|, de estos nuevos puntos y compruebe 
% que el perceptr�n clasifica correctamente (paso 4).

N = 2;
offset = 5; % offset para la segunda clase
P_sim = [randn(2,N) randn(2,N)+offset]; % entradas

out = sim(net3,P_sim);

% Final plotting decision boundary
plotpv(P_sim, out);
hold on
grid on;
linehandle = plotpc(net3.IW{1},net3.b{1});
set(linehandle, 'Color', 'r', 'LineWidth', 2);
title('Decision boundary');
hold off

%%
% # Cambie los vectores de entrada (P) y de target (T) por estos valores: |*P 
% =[-0.5 -0.5 +0.3 -0.1 -40; -0.5 +0.5 -0.5 +1.0 50]; T =[1 1 0 0 1];*|, que tienen 
% una entrada at�pica (outlier). Entrene una nueva red y compruebe cu�ntas iteraciones 
% (�pocas) son necesarias antes de obtener una frontera de decisi�n correcta.

clear all
close all
N = 20;
offset = 5; % offset para la segunda clase
P = [-0.5 -0.5 +0.3 -0.1 -40; -0.5 +0.5 -0.5 +1.0 50];
T = [1 1 0 0 1];
net3 = perceptron;
net3 = configure(net3,P,T);
mean_error = 1000;
Weight(1,:) = net3.IW{1};
Bias(1,:) = net3.b{1};
Y = []; % valores de salida de la red
E = []; % errores de la red
plotpv(P,T);
grid on;
count = 0;
while mean_error > 0.00001 && count < 200
    for n=1:length(P)
        [net3,Y(n),E(n)] = adapt(net3,P(:,n),T(:,n));
        Weight(n+1,:) = net3.IW{1};
        Bias(n+1,:) = net3.b{1};
    end
    figure
    hold on
    plotpv(P,T);
    grid on
    linehandle = plotpc(net3.IW{1},net3.b{1});
    set(linehandle, 'Color', 'g', 'LineWidth', 1);
    title('Decision boundary');
    hold off
    mean_error = sse(E)
    count = count + 1;
end

% Final plotting decision boundary
figure;
hold on
plotpv(P,T);
grid on;
linehandle = plotpc(net3.IW{1},net3.b{1});
set(linehandle, 'Color', 'r', 'LineWidth', 2);
title('Decision boundary');
hold off


%%
% # Para reducir el n�mero de iteraciones cuando hay entradas de valores at�picos, 
% la soluci�n es normalizar. La regla de percepci�n normalizada se implementa 
% con la funci�n |*learnpn*|. Cambie |*net=perceptron*| por |*net=perceptron('hardlim','learnpn');*| 
% y comprobe si el n�mero de iteraciones ahora es menor.

clear all
close all
P = [-0.5 -0.5 +0.3 -0.1 -40; -0.5 +0.5 -0.5 +1.0 50];
T = [1 1 0 0 1];
net3 = perceptron('hardlim','learnpn');
net3 = configure(net3,P,T);
mean_error = 1000;
Weight(1,:) = net3.IW{1};
Bias(1,:) = net3.b{1};
Y = []; % valores de salida de la red
E = []; % errores de la red
plotpv(P,T);
grid on;
count = 0;
while mean_error > 0.00001 && count < 200
    for n=1:length(P)
        [net3,Y(n),E(n)] = adapt(net3,P(:,n),T(:,n));
        Weight(n+1,:) = net3.IW{1};
        Bias(n+1,:) = net3.b{1};
    end
    figure
    hold on
    plotpv(P,T);
    grid on
    linehandle = plotpc(net3.IW{1},net3.b{1});
    set(linehandle, 'Color', 'g', 'LineWidth', 1);
    title('Decision boundary');
    hold off
    mean_error = sse(E)
    count = count + 1;
end

% Final plotting decision boundary
figure;
hold on
plotpv(P,T);
grid on;
linehandle = plotpc(net3.IW{1},net3.b{1});
set(linehandle, 'Color', 'r', 'LineWidth', 2);
title('Decision boundary');
hold off

%%
% # Finalmente, cambie los vectores de entrada (P) y de target (T) por estos 
% valores: |*P =[ -0.5 -0.5 +0.3 -0.1 -0.8; -0.5 +0.5 -0.5 +1.0 +0.0 ]; T =[1 
% 1 0 0 0];*|. Entrene una nueva red y compruebe que no se obtiene una frontera 
% de decisi�n correcta. �Por qu� la red alcanza el n�mero m�ximo de iteraciones 
% con un error distinto de cero?

clear all
close all
P =[ -0.5 -0.5 +0.3 -0.1 -0.8; -0.5 +0.5 -0.5 +1.0 +0.0 ]; 
T =[1 1 0 0 0];
net3 = perceptron('hardlim','learnpn');
net3 = configure(net3,P,T);
mean_error = 1000;
Weight(1,:) = net3.IW{1};
Bias(1,:) = net3.b{1};
Y = []; % valores de salida de la red
E = []; % errores de la red
plotpv(P,T);
grid on;
count = 0;
while mean_error > 0.00001 && count < 200
    for n=1:length(P)
        [net3,Y(n),E(n)] = adapt(net3,P(:,n),T(:,n));
        Weight(n+1,:) = net3.IW{1};
        Bias(n+1,:) = net3.b{1};
    end
    if mod(count,50)==1
        figure
        hold on
        plotpv(P,T);
        grid on
        linehandle = plotpc(net3.IW{1},net3.b{1});
        set(linehandle, 'Color', 'g', 'LineWidth', 1);
        title('Decision boundary');
        hold off
    end
    mean_error = sse(E)
    count = count + 1;
end

% Final plotting decision boundary
figure;
hold on
plotpv(P,T);
grid on;
linehandle = plotpc(net3.IW{1},net3.b{1});
set(linehandle, 'Color', 'r', 'LineWidth', 2);
title('Decision boundary');
hold off

%% 
% 

% % CODE (1)
% 
% E = 1; % errores de la red
% n=0;
% while (sse(E) > 0 & n < 200)    
%    n = n+1;
%    [net, Y, E] = adapt(net,P,T);
% end
%% 
% 

% % CODE (2)
%
% n�mero de muestras de cada clase
% N = 20;
% % definir las entradas
% offset = 5; % offset para la segunda clase
% P_sim = [randn(2,N) randn(2,N)+offset]; % entradas