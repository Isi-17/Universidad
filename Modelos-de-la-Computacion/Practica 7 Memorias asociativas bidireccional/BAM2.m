% Cargar las matrices de patrones y textos
barco = load('barco.mat');
coche = load('coche.mat');
textoBarco = load('textoBarco.mat');
textoCoche = load('textoCoche.mat');

% Reshape y almacenamiento de los patrones y textos en las matrices x e y
x(1,:) = reshape(barco.barco, 1, size(barco.barco,1)*size(barco.barco,2));
x(2,:) = reshape(coche.coche, 1, size(coche.coche,1)*size(coche.coche,2));
y(1,:) = reshape(textoBarco.textoBarco, 1, size(textoBarco.textoBarco,1)*size(textoBarco.textoBarco,2));
y(2,:) = reshape(textoCoche.textoCoche, 1, size(textoCoche.textoCoche,1)*size(textoCoche.textoCoche,2));

% Añadir ruido gaussiano al patrón del coche y convertir a valores bipolar
matrizBipolarGaussiano = imnoise(x(2,:), 'gaussian', 0, 0.5) * 2 - 1;

% Inicialización de la matriz de pesos utilizando la regla de Hebbian
w = x' * y;

% Número máximo de épocas para el entrenamiento
epocMax = 21;

% Inicialización de matrices para almacenar los estados de la red en cada época
s = zeros(size(x, 2), epocMax);
s2 = zeros(size(y, 2), epocMax);

% Estado inicial de la red en la dirección X->Y
sinit = matrizBipolarGaussiano; % También se puede usar x(2,:) como estado inicial
s2init = sign(sinit * w);
s(:,1) = sinit;
s2(:,1) = s2init;

% Bucle de entrenamiento a través de las épocas
for epoc = 2:1:epocMax
    % Actualización del estado de la red en ambas direcciones
    s(:, epoc) = sign(w * s2(:, epoc-1));
    s2(:, epoc) = sign(s(:, epoc)' * w);
    
    % Comprobación de convergencia
    if sum(s(:, epoc) == s(:, epoc-1)) == size(x,2)
        % Si la red ha convergido, mostrar la entrada y el patrón reconocido y terminar el bucle
        subplot(3,1,1)
        imshow(reshape(s(:,1),size(barco.barco,1),size(barco.barco,2)))
        subplot(3,1,2)
        imshow(reshape(s(:,epoc),size(barco.barco,1),size(barco.barco,2)))
        subplot(3,1,3)
        imshow(reshape(s2(:,epoc),size(textoBarco.textoBarco,1),size(textoBarco.textoBarco,2)))
        return
    end
end
