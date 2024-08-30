function out = CheckPattern(Data,W)
    i = 1;
    out = true;

    while out && i <= size(Data,1)
        [~, Output, Target] = ValoresIOT(Data,W,i);
        if Target ~= Signo(Output)
            out = false;
        end
        i = i + 1;
    end
end

% Esta función verifica si el perceptrón ha clasificado correctamente todos los patrones en el conjunto de datos. Aquí está cómo funciona:

% 1. Itera a través de cada fila del conjunto de datos (Data)
% 2. Para cada fila, utiliza la función ValoresIOT para obtener la salida (Output) y el valor objetivo (Target) del perceptrón.
% 3. Compara la salida con el valor objetivo. Si son diferentes, establece out como false, indicando que al menos un patrón no se clasificó correctamente.
% 4. Devuelve el valor de out, que indica si todos los patrones se clasificaron correctamente (true) o no (false).