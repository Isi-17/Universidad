clear;
clc;
close all;

%load DatosAND
%load DatosLS5
load DatosLS10
%load DatosLS50
%load DatosOR
%load DatosXOR

Data(:,end)=Data(:,end)==1;

LR=0.5;
Limites=[-1.5, 2.5, -1.5, 2.5];
MaxEpoc=100;

W=PerceptronWeigthsGenerator(Data);

%W = [0 0 0];  % Inicializa los pesos a [0 0 0]

% Apartado 2
% LR = -0.1;  % Tasa de aprendizaje negativa
% Proporcionar valor negativo da problemas en la convergencia.
% Al ser negativo, los pesos del modelo pueden aumentar sin control y
% alejarse cada vez más de una solución.


ECM = [];  % Vector para almacenar los valores del ECM en cada época

Epoc=1;

while ~CheckPattern(Data,W) && Epoc<MaxEpoc
    sum_squared_error = 0;  % Inicializa el error cuadrático acumulado en esta época

     for i=1:size(Data,1)
        [Input,Output,Target]=ValoresIOT(Data,W,i); % valores IOT es un valor real. Debemos discretizarlo
        
        GrapDatos(Data,Limites);
        GrapPatron(Input,Output,Limites);
        GrapNeuron(W,Limites);hold off;
        drawnow
%         pause;
        
        if Signo(Output)~=Target   % discretizamos salida
           W=UpdateNet(W,LR,Signo(Output),Target,Input);
        end
        
% Calcula el error cuadrático para esta entrada y lo acumula
        error = (Target - Signo(Output))^2;
        sum_squared_error = sum_squared_error + error;

 % Calcula el ECM promedio para esta época y lo agrega al vector ECM
    mean_squared_error = sum_squared_error / size(Data, 1);
    ECM = [ECM, mean_squared_error];

        GrapDatos(Data,Limites);
        GrapPatron(Input,Output,Limites)
        GrapNeuron(W,Limites);hold off;
        drawnow
        
%         pause;
 

    end
    Epoc=Epoc+1;
end

if CheckPattern(Data, W)
       disp('Se consigue');
       % Grafica la evolución del ECM
        figure;
        plot(1:length(ECM), ECM);
        title('Evolución del Error Cuadrático Medio (ECM)');
        xlabel('Época');
        ylabel('ECM');
end
     


%D = datosAnD
%X = D(:, 1:end-1)
%Y= D(:, end)
%X = [X - ones(Size(D,1),1]
%W = inv(X' * X) * X'Y
%Output = X* w, ---> Rn

%Aqui trabajamos con codificación 0,1 => Y € {0,1}
%Disctetizamos (etiqueta de clase label)
%Label = (X*w >=0,5); --> {0,1}n -- esto en matlab si vale mayor que 0,5 te pone 1 y si es mejor te pone 0
%ECN = (norm(Y - Output, 2))²/size(D, 1) -- norma 2 del vector diferencia ||Y - Xw|| y dividimos entre el numero de patrones. La función norma te hace ka raiz cuadeada. 
%Calculamos el porcentaje de patrones buen clasificados
%Acc = sum(Y== label)/size(X, 1) -- genera un vector donde vale 1 si coinciden y 0 si no coinciden y dividimos entre el numerk de patrones 

%.* Es multiplicación punto a punto luego requiere tamaños de matriz igual

%sum(X.w) genera un vector de dim X y suma los elementos. Se puede gacer Xt w ó w Xt