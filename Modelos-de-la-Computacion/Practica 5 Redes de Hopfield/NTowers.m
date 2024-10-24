% Definición del estado inicial
% estado_inicial = [0 1 1; 1 1 0; 0 1 0];

% Configuración de la red
N = 8;
Theta = zeros(N, N);
Theta(:, :) = -1; % Theta vale -1 para todas las neuronas
% H = zeros(N, N); % Almacena el potencial sináptico de la neurona que se está actualizando en cada momento

W = zeros(N, N, N, N); % Define la matriz de pesos
% Cada punto del tablero con quien esta conectado. Las dos primeras N el tablero, Las dos siguientes N con quien esta conectado.
for i = 1:1:N
    for j = 1:1:N
        W(i, j, 1:N, j) = -2; % Conexiones con la fila j
        W(i, j, i, 1:N) = -2; % Conexiones con la columna i
        W(i, j, i, j) = 0; % Diagonal principal
    end
end

% Número de iteraciones cuando va reduciendo la energia.
epoc = 20;

% Almacena los estados históricos de cada peso de la matriz
Shist = zeros(N, N, epoc);

% Bucle para minimizar la energía
for e = 2:1:epoc
    cambio = false;
    Shist(:, :, e) = Shist(:, :, e-1); % El histórico en el punto nuevo es igual al histórico del punto anterior
    
    % Recorrido secuencial
    for i = 1:1:N
        for j = 1:1:N
            h = 0;
            % Cálculo del potencial sináptico
            for l = 1:1:N
                for k = 1:1:N
                    h = h + Shist(l, k, e) * W(i, j, l, k);
                end
            end

            % Almacena el potencial sináptico de la neurona que se está actualizando en cada momento
            % H(i, j) = h;
            
            % Regla de actualización
            Shist(i, j, e) = int16(h >= Theta(i, j));
            % Shist(i, j, e) = int16(H(i, j) >= Theta(i, j));
            % Verificar cambio en el histórico. Si alguno coincide sale del
            % bucle.
        end
    end

    % Verificar si hay cambio en el histórico
    % Si no hay cambio, significa que converge a un optimo local
    if isequal(Shist(:, :, e) , Shist(:, :, e-1))
        cambio = true; % si cambia seguimos iterando
        disp('Se alcanzó un óptimo local:');
        disp(Shist(:, :, e));
        break;
    end
end
