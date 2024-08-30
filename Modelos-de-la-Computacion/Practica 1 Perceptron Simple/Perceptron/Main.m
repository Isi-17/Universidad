clear;
clc;
close all;

%load DatosAND
%load DatosLS5
%load DatosLS10
%load DatosLS50
%load DatosOR
load DatosXOR 

% DatosXOR no clasifica correctamente, pues es imposible encontrar una recta que divida en dos segmentos con O y X 

LR=0.5; % tasa de aprendizaje (u)
Limites=[-1.5, 2.5, -1.5, 2.5]; % limites del gráfico
MaxEpoc=100; % num max de iteraciones

W=PerceptronWeigthsGenerator(Data); % inicializa la matriz de pesos

Epoc=1;

while ~CheckPattern(Data,W) && Epoc<MaxEpoc % mientras que la clasificacion del paton no sea correcto || epoc < maxIteraciones
     for i=1:size(Data,1) % itera a través de cada fila de los datos
        [Input,Output,Target]=ValoresIOT(Data,W,i); % para la fila i
        % Input: valores de entrada
        % Output: valores de salida
        % Target: valor objetivo 
        
        % Representacion:
        GrapDatos(Data,Limites);
        GrapPatron(Input,Output,Limites);
        GrapNeuron(W,Limites);hold off;
        drawnow
%         pause;
        
        if Output~=Target % si la salida actual no coincide con el valor objetivo
           W=UpdateNet(W,LR,Output,Target,Input); % actualizar los pesos
        end
        
        GrapDatos(Data,Limites);
        GrapPatron(Input,Output,Limites)
        GrapNeuron(W,Limites);hold off;
        drawnow
%         pause;
     
    end
    Epoc=Epoc+1;
end

