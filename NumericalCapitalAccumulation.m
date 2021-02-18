function [k_numerical_vector] = NumericalCapitalAccumulation( ...
    n, g, delta, alpha, s, k_null)

k_numerical_vector = [];
k_numerical_vector(1, 1) = k_null;

k = k_null;

for i = 1 : 99
    k_new = ((s / (delta + g + n)) + (k^(1 - alpha) - ...
        (s / (delta + g + n) )) * exp(-(1 - alpha) * ...
        (delta + g + n)))^(1 / (1 - alpha));
    
    k_numerical_vector(1, i+1) = k_new;
    k = k_new;
end