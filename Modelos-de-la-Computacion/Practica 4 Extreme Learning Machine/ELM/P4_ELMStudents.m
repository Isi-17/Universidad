clear all;

D = load('handwriting.mat');
% 5000 imagenes asociadas a nº del 1 al 10
% -> 500 -> 0
% -> 500 -> 1
% ...
% -> 500 -> 10
X = D.X;

[N, K] = size(X);
J = 10;

Y = zeros(N,J);

% Generate the Y Label. Genera la etiqueta de clase.
for i =1:10
    Y(1+(500*(i-1)):i*500,i) =1;
end

% Scale the data. Formula de escalado de datos.
Xscaled = (X-min(X))./(max(X)-min(X));

% Remove the NaN elements
Xscaled = Xscaled(:,any(~isnan(Xscaled)));

% Compute again the number of total elements and attributes
[N, K] = size(Xscaled);

CVHO = cvpartition(N,'HoldOut',0.25);

% Creamos los conjuntos de datos diferentes: 
% Entrenamiento -> TrainVal
% Validacion -> Val
% Prueba -> Test
% -> Train -> Incorpora algunos valores de 'Val' a 'TrainVal'
XscaledTrain = Xscaled(CVHO.training(1),:);
XscaledTest = Xscaled(CVHO.test(1),:);
YTrain = Y(CVHO.training(1),:);
YTest = Y(CVHO.test(1),:);


% Create the validation set
[NTrain, K] = size(XscaledTrain);
CVHOV = cvpartition(NTrain,'HoldOut',0.25);

% Generate the validation sets
XscaledTrainVal = XscaledTrain(CVHOV.training(1),:);
NewCol = -1*ones(size(XscaledTrainVal,1),1);
XscaledTrainVal = [XscaledTrain(CVHOV.training(1),:) NewCol];

XscaledVal = XscaledTrain(CVHOV.test(1),:);
NewCol = -1*ones(size(XscaledVal,1),1);
XscaledVal = [XscaledTrain(CVHOV.test(1),:) NewCol];
YTrainVal = YTrain(CVHOV.training(1),:);
YVal = YTrain(CVHOV.test(1),:);

% Performance Matrix
Performance = zeros(7,6);

i = 0;
j = 0;

% XscaledTrainVal = (XscaledTrainVal - 1);
% Estimate the hyper-parameters values
for C = [10^(-3) 10^(-2) 10^(-1) 1 10 100 1000]
    i = i+1;
    for L = [50 100 500 1000 1500 2000]
        j = j+1;

    %         ELM-NEURONAL (D, L, C):
    % 1: X ← (X − 1N ) ∈ R^N×(K+1)
    % 2: t ← 2 · rand(L, K + 1) − 1
    % 3: for n = 1 until N do
    % 4: for l = 1 until L do
    % 5: Hnl ← g2(tl, xn)
    % 6: end for
    % 7: end for
    % 8: w ←  I C + H′H −1 H′Y
    % 9: return w, t


        t = 2 * rand(L, K+1)-1;
        % H = TransferFunction(t,XscaledTrainVal);
        H = 1./(1 + exp(-XscaledTrainVal * t'));
        w = inv(eye(L)/C + H'*H)*H'*YTrainVal;

        % Hval = TransferFunction(XscaledVal, t);
        Hval = 1./(1 + exp(-XscaledVal * t'));
        YestimatedVal = Normalizar(Hval * w);
        
        %Label = max(YestimatedVal);
       % CCR = sum(Label == Yval) / (K + 1);
       % Performance(i, j) = CCR;

       % MSE = mean((YPred - YVal).^2);
        % Performance(i, j) = MSE
       Performance(i,j)= sum((sum(YestimatedVal == YVal,2)-8)/2)/size(YestimatedVal,1);

    end
    j=0;
end

C = [10^(-3) 10^(-2) 10^(-1) 1 10 100 1000];
L = [50 100 500 1000 1500 2000];

[maxValue, linearIndexesOfMaxes] = max(Performance(:));
[rowsOfMaxes colsOfMaxes] = find(Performance == maxValue);

Copt = C(rowsOfMaxes(1));
Lopt = L(colsOfMaxes(1));

% Calcular con el conjunto de entrenamiento el ELM neuronal y reportar el error cometido en test
% Calcular el MSE (Error Cuadrático Medio)
%MSE = mean((YPred - YTest).^2);

% Calcular la CCR (Tasa de Clasificación Correcta)
%CCR = sum(all(YPred == YTest, 2)) / size(YTest, 1);

NewCol = -1*ones(size(XscaledTrain,1),1);
XscaledTrain = [XscaledTrain NewCol];

NewCol = -1*ones(size(XscaledTest,1),1);
XscaledTest = [XscaledTest NewCol];


t = 2*rand(Lopt,K+1) - 1;
H = 1 ./ (1+exp(-XscaledTrain * t'));
w = inv(eye(Lopt)/Copt + H' * H) * H' * YTrain;


Hval = 1 ./ (1+exp(-XscaledTest * t'));
YstimatedTest = Hval * w;



ECM = sum(sum((YstimatedTest-YTest).^2))/(size(YTest,1));
ECM2 = norm(YstimatedTest-YTest)/size(YTest,1);
YstimatedTest = Normalizar(YstimatedTest);
CCR= sum((sum(YstimatedTest == YTest,2)-8)/2)/size(YstimatedTest,1);

% Salida.
disp(ECM)
disp(ECM2)
disp(CCR)



