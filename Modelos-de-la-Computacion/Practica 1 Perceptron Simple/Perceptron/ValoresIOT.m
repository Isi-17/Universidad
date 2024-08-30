function [Input, Output, Target] = ValoresIOT(Data,W, i)

Input = Data(i, 1:end-1);
Target = Data(i, end);
Output = Signo(sum(W' .* [Input -1]));

end
% Esta función calcula los valores de entrada, salida y objetivo para una fila específica del conjunto de datos. Aquí está cómo funciona:

% 1. Obtiene la entrada (Input) tomando todas las columnas de la fila i excepto la última (asumiendo que la última columna contiene el valor objetivo).
% 2. Calcula la salida (Output) del perceptrón utilizando la función Signo. 
%    Toma el producto de los pesos (W') y la entrada extendida [Input -1], y luego aplicando la función de signo al resultado. 
%    La entrada se extiende con un término de sesgo (-1) al final.
% 3. Obtiene el valor objetivo (Target) tomando el valor de la última columna de la fila i.