clc; clear; close all;

% ==========================================================
% EJERCICIO 1: f(x) = e^x en x = 2
% ==========================================================
f = @(x) exp(x);
x0 = 2;
val_real = exp(2);
h_vec = [0.5, 0.1, 0.05, 0.01, 0.005, 0.001];

% Preparamos almacenamiento para la tabla
fprintf('--- TABLA EJERCICIO 1: PRIMERA DERIVADA f''(2) ---\n');
fprintf('h \t f''(2) 6-dec \t f''(2) 8-dec \t Err%% 6-dec \t Err%% 8-dec\n');
fprintf('----------------------------------------------------------------------\n');

for i = 1:length(h_vec)
    h = h_vec(i);

    % Simulación de precisión (Redondeo de f(x+h) y f(x-h))
    fx_p6 = round(f(x0+h) * 1e6) / 1e6;
    fx_m6 = round(f(x0-h) * 1e6) / 1e6;
    d_cent6 = (fx_p6 - fx_m6) / (2*h);
    err6(i) = abs((val_real - d_cent6)/val_real) * 100;

    fx_p8 = round(f(x0+h) * 1e8) / 1e8;
    fx_m8 = round(f(x0-h) * 1e8) / 1e8;
    d_cent8 = (fx_p8 - fx_m8) / (2*h);
    err8(i) = abs((val_real - d_cent8)/val_real) * 100;

    fprintf('%.3f \t %.6f \t %.8f \t %.5f%% \t %.7f%%\n', ...
            h, d_cent6, d_cent8, err6(i), err8(i));
end

% GRÁFICA 1: Error vs h
figure(1);
loglog(h_vec, err6, '-bo', 'linewidth', 2, 'DisplayName', 'Error % (6 dec)');
hold on;
loglog(h_vec, err8, '-rx', 'linewidth', 2, 'DisplayName', 'Error % (8 dec)');
grid on;
title('Análisis de Error: Diferencias Centrales (6 vs 8 decimales)');
xlabel('Paso h'); ylabel('Error Relativo Porcentual (%)');
legend('location', 'northeast');

% ==========================================================
% EJERCICIO 2: DATOS TABULADOS (Método Interpolante)
% ==========================================================
x_data = [1.5, 1.9, 2.1, 2.4, 2.6, 3.1];
y_data = [1.0628, 1.3961, 1.5432, 1.7349, 1.8423, 2.0397];
xi = 2.25;

% Ajustamos un polinomio (Método Interpolante)
% Usamos grado 2 (parábola) que es común para diferencias finitas no equiespaciadas
p = polyfit(x_data, y_data, 2);
dp = polyder(p);      % Coeficientes primera derivada
ddp = polyder(dp);    % Coeficientes segunda derivada

f1_xi = polyval(dp, xi);
f2_xi = polyval(ddp, xi);

fprintf('\n--- RESULTADOS EJERCICIO 2 (x = 2.25) ---\n');
fprintf('f''(2.25) aproximado: %.6f\n', f1_xi);
fprintf('f''''(2.25) aproximado: %.6f\n', f2_xi);

% GRÁFICA 2: Curva de Interpolación
figure(2);
xfine = linspace(1.4, 3.2, 100);
yfine = polyval(p, xfine);
plot(x_data, y_data, 'ks', 'MarkerFaceColor', 'k', 'DisplayName', 'Datos Tabla');
hold on;
plot(xfine, yfine, 'b-', 'linewidth', 1.5, 'DisplayName', 'Polinomio Interpolante');
plot(xi, polyval(p, xi), 'ro', 'markersize', 10, 'linewidth', 2, 'DisplayName', 'Punto Evaluado (2.25)');
grid on;
title('Derivación Numérica por Interpolación');
xlabel('x'); ylabel('f(x)');
legend('location', 'northwest');
