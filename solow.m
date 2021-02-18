function [k_vector, y_vector, c_vector] = solow( ...
    n, g, delta, alpha, s, k_null)

% capital
k_vector = [];
k_vector(1, 1) = k_null;

% output
y_vector = [];
y_vector(1, 1) = k_null^alpha;

% consumption
c_vector = [];
c_vector(1, 1) = k_null^alpha - s * k_null^alpha;

k = k_null;

for i = 1 : 99
    k_new = (s * k^alpha + (1 - delta) * k)/((1 + g) * (1 + n));
    output = k_new^alpha;
    consumption = k_new^alpha - s * k_new^alpha;
    
    k_vector(1, i+1) = k_new;
    y_vector(1, i+1) = output;
    c_vector(1, i+1) = consumption;
    
    k = k_new;
end