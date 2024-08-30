function W = UpdateNet(W,LR,Output,Target,Input)
    DeltaW = (LR * (Target - Output)) * [Input -1];
    W = W + DeltaW';   % DeltaW'  (traspuesta)
end

% Actualiza el vector de pesos
% La actualización de los pesos se realiza utilizando la regla de aprendizaje del perceptrón
% Esta función se encarga de actualizar los pesos del perceptrón. Aquí está cómo funciona:

% 1. Calcula la diferencia entre la salida actual (Output) y el valor objetivo (Target).
% 2. Multiplica esta diferencia por la tasa de aprendizaje (LR) para obtener DeltaW.
% 3. Multiplica DeltaW por la matriz [Input -1], que es la entrada extendida con un término de sesgo (-1) al final.
% 4. Suma este valor a la matriz de pesos actual (W) para obtener los nuevos pesos del perceptrón.
