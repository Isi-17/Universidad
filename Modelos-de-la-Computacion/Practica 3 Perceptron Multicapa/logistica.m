function [Y] = logistica(X,beta)
% Calcula la función logística para cada uno de los elementos del vector columna X
    Y = 1 ./(1 + exp(-2 * beta * X));
end

% El comportamiento del algoritmo si lo ejecutamos 5, 20 veces los
% resultaods van a ser distintos porque la función de error va a ser una
% función convexa.

% El algoritmo de descenso de gradiente depende del PUNTO DE
% INICIALIZACIÓN.
% Lo que nos asegura el algoritmo de descenso de gradiente asegura que va a
% conseguir el mínimo. Sin embargo, puede no ser el menor mínimo. Si
% continuamos las iteraciones podemos encontrar otro mínimo en el
% gradiente.


% Si Beta = 0.1 aumenta el ECM porque añade constanates al sistema. No
% discrimina correctamente. 