function [Y] = derivadaLogistica(X,beta)
% Calcula la derivada de la función logística para cada uno de los elementos del vector columna X

    Y = 2 * beta .* logistica(X, beta) .* (1 - logistica(X, beta));

end

