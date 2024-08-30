function [difW, difT] = retropropagacionError(patron, Z, y, w, s, h, u, Beta, eta)
% Función que calcula los diferenciales de los pesos W y T

% Incialización de variables
nSalidas=size(y,1);
nOcultas=size(w,2);

delta2=zeros(nSalidas,1);
difW=zeros(nSalidas, nOcultas);
delta1=zeros(nOcultas,1);
difT=zeros(nOcultas,size(patron,2));



% s --> fila
% delta1 --> columna
% eta --> escalar
% --> Cálculo de deltas2 y difW <--
delta2 = (Z - y) .* derivadaLogistica(h, Beta);
difW = eta * (delta2 .* s);

% patron --> fila
% delta2 --> columna
% eta --> escalar
% derivadaLogistica(u, Beta) --> fila
% w --> matriz
% --> Cálculo de deltas1 y difT <--
delta1 = (derivadaLogistica(u, Beta) .* delta2) .* w;
difT = eta * (delta1 .* patron);

end

% Z = y_{n, j}
% δ2j (i, n) = (ynj − yˆnj (i))g′1(hjn(i))
% δ1l(i, n) = g′2(uln(i))PJj=1 δ2j(i, n)wlj (i, n)
