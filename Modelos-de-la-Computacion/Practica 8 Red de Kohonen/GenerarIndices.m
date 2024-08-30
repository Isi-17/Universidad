function Indices = GenerarIndices(FC)
    % Inicializar la matriz de índices con ceros
    Indices = zeros(2, FC(1), FC(2));
    
    % Iterar sobre las filas del mapa de neuronas
    for x = 1:FC(1)
        % Iterar sobre las columnas del mapa de neuronas
        for y = 1:FC(2)
            % Asignar las coordenadas (x, y) como índices para la neurona actual
            Indices(:, x, y) = [x, y];
        end
    end
end
