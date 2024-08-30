clear;
clc;

% D = datosAnD;
load DatosAND
X = Data(:,1:end-1);
Y = Data(:, end);

% Agregar una columna de unos a X (sesgo)
X = [X, -ones(size(X, 1), 1)];

% Pesos W de forma analítica
W = inv(X' * X) * X' * Y;

% Salida del modelo
Output = X * W;

% Discretizar las salidas (0 o 1) -> (-1 o 1)
Label = (Output >= 0.5)*2 - 1;

% Error Cuadrático Medio (ECM). Divido entre el n patrones
ECM = (norm(Y - Output, 2)^2) / size(X, 1);

% Accuracy (porcentaje de patrones correctamente clasificados)
Acc = sum(Y == Label) / size(X, 1);

disp('Pesos W:');
disp(W);
disp(['Error Cuadrático Medio (ECM): ', num2str(ECM)]);
disp(['Accuracy: ', num2str(Acc)]);


% ######  NOTAS DE CLASE  #########
% D = datosAnD
% X = D(:, 1:end-1)
% Y= D(:, end)
% X = [X - ones(Size(D,1),1]
% W = inv(X' * X) * X'Y
% Output = X* w, ---> Rn

% Aqui trabajamos con codificación 0,1 => Y € {0,1}
% Disctetizamos (etiqueta de clase label)
% Label = (X*w >=0,5); --> {0,1}n -- esto en matlab si vale mayor que 0,5 te pone 1 y si es mejor te pone 0
% ECN = (norm(Y - Output, 2))²/size(D, 1) -- norma 2 del vector diferencia ||Y - Xw|| y dividimos entre el numero de patrones. La función norma te hace ka raiz cuadeada. 
% Calculamos el porcentaje de patrones buen clasificados
% Acc = sum(Y== label)/size(X, 1) -- genera un vector donde vale 1 si coinciden y 0 si no coinciden y dividimos entre el numerk de patrones 

% .* Es multiplicación punto a punto luego requiere tamaños de matriz igual

% sum(X.w) genera un vector de dim X y suma los elementos. Se puede gacer Xt w ó w Xt
