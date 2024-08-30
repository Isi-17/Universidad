function [Label] = Normalizar(A)
%Normalizar Summary of this function goes here
%   Detailed explanation goes here
[M, I] = max(A');
        Label = zeros(size(A));
        for k = 1:size(A,1)
            Label(k, I(k)) = 1;
        end
end
