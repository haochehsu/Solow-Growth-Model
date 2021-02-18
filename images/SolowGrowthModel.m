clc
clear
close all

x_vector = linspace(1,100,100);

%% The path

figure(1)
% I-2 Settings
subplot(3,1,1);
[k_vector_2, y_vector_2, c_vector_2] = solow(0.02, 0.03, 0.05, 0.3, 0.4, 1);
plot(x_vector, k_vector_2, x_vector, y_vector_2, x_vector, c_vector_2);
title('Settings: n = 0.02, g = 0.03, \delta = 0.05, \alpha=0.3, s = 0.4, k_{null} = 1')
legend('k_t', 'y_t','c_t')
xlabel('time')
ylabel('values')

% I-3 Settings
subplot(3,1,2);
[k_vector, y_vector, c_vector] = solow(0.02, 0.03, 0.05, 0.3, 0.4, 10);
plot(x_vector, k_vector, x_vector, y_vector, x_vector, c_vector);
title('Settings: n = 0.02, g = 0.03, \delta = 0.05, \alpha = 0.3, s = 0.4, k_{null} = 10')
legend('k_t', 'y_t','c_t')
xlabel('time')
ylabel('values')

% Numeric Comparison
subplot(3,1,3);
[k_numerical_vector] = NumericalCapitalAccumulation(...
    0.02, 0.03, 0.05, 0.3, 0.4, 1);
plot(x_vector, k_vector_2, x_vector, k_numerical_vector);
title({'Numeric Computation with Closed Form Expression', ...
    'Settings: n = 0.02, g = 0.03, \delta = 0.05, \alpha = 0.3, s = 0.4, k_{null} = 1'})
legend('k_t (numerical)', 'k_t (closed-form)')
xlabel('time')
ylabel('values')

%% Breakeven curve

figure(2)
% ssEquilibria
plot1 = fplot(@(k) 0.4 * k^(0.3), [0, 15]);
hold on
plot2 = fplot(@(k) (0.05 + 0.03 + 0.02 + (0.02 * 0.03)) * k, [0, 15]);
title('Investmet Breakeven Curve')
legend('Investment', 'Breakeven')
xlabel('k_t')
ylabel('Inverstment per unit of effective labor')

% Analytical Solving
syms s k a n g d
equation = s * k^a - (d + n + g + (n * g)) * k == 0;
solution = solve(equation, k);
disp(solution)

% Numerical Solving
initial = 10;
[k_level] = fsolve(@solowModel, initial);
invest_k_level = 0.4 * k_level^0.3;

str1 = sprintf('The equilibrium capital level k* is %.3g.', k_level);
str2 = sprintf(...
    'The investment per unit of effective labor is %.3g.', ...
    invest_k_level);
disp(str1);
disp(str2);

%% Balanced growth path

figure(3)
% Optimal Consumption
plot1 = fplot(@(k) k^0.3, [0, 8]);
hold on
plot2 = fplot(@(k) 0.2 * k^0.3, [0, 8]);
hold on
plot3 = fplot(@(k) 0.4 * k^0.3, [0, 8]);
hold on
plot4 = fplot(@(k) 0.3 * k^0.3, [0, 8]);
hold on
plot5 = fplot(@(k) (0.05 + 0.03 + 0.02 + (0.02 * 0.03)) * k, [0, 8]);
line([(0.3 / 0.1006)^(10/7) (0.3 / 0.1006)^(10/7)], [0 1.9])
title('Balance Growth Path')
legend('f(k)', 'sf(k), s = 0.2', 'sf(k), s = 0.4', ...
    'sf(k), s = 0.3, k = Golden Rule', ...
    '(n + g + ng + \delta)k', 'k_t = 4.763')
xlabel('k_t')
ylabel('Output and investment per unit effective labor')

figure(4)
capital_vector = [];
saving_vector = [];
output_vector = [];
consumption_vector = [];

initial = 10;
for i = 100:200
    [capital_level, Value] = fsolve(@(k) (0.002 * i) * k^(0.3) - ...
        (0.05 + 0.03 + 0.02 + (0.02 * 0.03)) * k, initial);
    consumption = (1 - (0.002 * i)) * capital_level^0.3;
    
    output_vector(1, i - 99) = capital_level^0.3;
    capital_vector(1, i - 99) = capital_level;
    saving_vector(1, i - 99) = 0.002 * i;
    consumption_vector(1, i - 99) = consumption;
end

subplot(3,1,1);
plot(saving_vector, consumption_vector);
title('Change of consumption on saving rate')
xlabel('savings')
ylabel('consumption')
legend('c')

subplot(3,1,2);
plot(saving_vector, capital_vector);
title('Change of capital on saving rate')
xlabel('savings')
ylabel('capital')
legend('k')

subplot(3,1,3);
plot(saving_vector, output_vector);
title('Change of output on saving rate')
xlabel('savings')
ylabel('output')
legend('y')

% s = 0.2
initial = 10;
[k_level_low] = fsolve(@(k) 0.2 * k^(0.3) - ( ...
    0.05 + 0.03 + 0.02 + (0.02 * 0.03)) * k, initial);
investPerAL_low = 0.2 * k_level^0.3;

% s = 0.4
initial = 10;
[k_level_high] = fsolve(@(k) 0.4 * k^(0.3) - ( ...
    0.05 + 0.03 + 0.02 + (0.02 * 0.03)) * k, initial);
investPerAL_high = 0.4 * k_level^0.3;

% s = 0.3 (The optimal saving rate when capital level is at golden rule)
initial = 10;
[k_level_optimal] = fsolve(@(k) 0.3 * k^(0.3) - ( ...
    0.05 + 0.03 + 0.02 + (0.02 * 0.03)) * k, initial);
investPerAL_optimal = 0.3 * k_level^0.3;

disp('◆ When the saving rate is 0.2:');
str3 = sprintf('The equilibrium capital level k* is %.3g.', k_level_low);
str4 = sprintf(...
    'The inverstment per unit of effective labor is %.3g.', ...
    investPerAL_low);
disp(str3);
disp(str4);
disp('--------------------');

disp('◆ When the saving rate is 0.4:');
str5 = sprintf('The equilibrium capital level k* is %.3g.', k_level_high);
str6 = sprintf(...
    'The inverstment per unit of effective labor is %.3g.', ...
    investPerAL_high);
disp(str5);
disp(str6);
disp('--------------------');

disp('◆ When the saving rate is 0.3 (optimal):');
str7 = sprintf('The equilibrium capital level k* is %.3g.', ...
    k_level_optimal);
str8 = sprintf('The inverstment per unit of effective labor is %.3g.', ...
    investPerAL_optimal);
disp(str7);
disp(str8);
disp('--------------------');

%% Saving rate = 0.4

% Numerical: search from path of kt for the index
% whose kt = 7.1842/2 = 3.5921
k_from_one = [];
k = 1;
k_from_one(1, 1) = k;
for i = 1 : 20
    k_next = (0.4 * k^0.3 + (1 - 0.05) * k)/((1 + 0.03) * (1 + 0.02));
    k_from_one(1, i + 1) = abs(k_next - ((k_level_high - 1) / 2));
    k = k_next;
end

[minimum, index] = min(k_from_one);

str9 = sprintf( ...
    'Numerically, the time of converging to half-way is %.4g years.', ...
    index + 1);
disp(str9);

% Analytical: linearize law of motion of k
lambda = -(((0.05 + 0.03 + 0.02) * k_level_high * 0.3 * ...
    k_level_high^(0.3 - 1) / (k_level_high^0.3)) - (0.05 + 0.03 + 0.02));
halfTime = log(2)/lambda;
str10 = sprintf( ...
    'Analytically, the time of converging to half-way is %.4g years.', ...
    halfTime);
disp(str10);