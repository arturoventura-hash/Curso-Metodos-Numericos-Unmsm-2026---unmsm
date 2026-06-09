% Solución para la integral de ln(x)/x usando Gauss-Legendre (n = 3) + Gráfica
clear; clc; clf;
format long;

%% 1. Definición de la función e intervalo
f = @(x) log(x) ./ x; 
a = 1;
b = 3;

%% 2. Nodos (t) y Pesos (w) estándar de Gauss-Legendre (n = 3)
t = [-sqrt(3/5); 0; sqrt(3/5)];
w = [5/9; 8/9; 5/9];

%% 3. Cambio de variable a intervalo [a, b]
x_transformado = ((b - a) .* t + (b + a)) / 2;
dx_dt = (b - a) / 2;

%% 4. Cálculo de la aproximación
suma_gauss = sum(w .* f(x_transformado)) * dx_dt;

%% 5. Generación de la Gráfica
% Curva continua de la función
x_viga = linspace(a, b, 500);
y_viga = f(x_viga);

figure(1);
plot(x_viga, y_viga, 'b-', 'LineWidth', 2); hold on;

% Sombrear el área bajo la curva (área exacta)
area(x_viga, y_viga, 'FaceColor', [0.85, 0.95, 1], 'EdgeColor', 'none', 'DisplayName', 'Área bajo la curva');

% Graficar los 3 puntos donde Gauss-Legendre evalúa la función
y_nodos = f(x_transformado);
plot(x_transformado, y_nodos, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8, 'DisplayName', 'Nodos de Gauss (n=3)');

% Dibujar líneas verticales desde el eje X hasta los puntos de evaluación
for i = 1:length(x_transformado)
    plot([x_transformado(i), x_transformado(i)], [0, y_nodos(i)], 'r--', 'LineWidth', 1.2);
end

%% 6. Estética del gráfico (LÍNEA CORREGIDA AQUÍ)
titulo_texto = sprintf('Cuadratura de Gauss-Legendre (n = 3) | Integral \\approx %.6f', suma_gauss);
title(titulo_texto);
xlabel('Eje X');
ylabel('f(x) = Ln(x) / x');
xlim([a - 0.2, b + 0.2]);
ylim([0, max(y_viga) + 0.1]);
grid on;
legend('f(x) = Ln(x)/x', 'Área a integrar', 'Nodos evaluados', 'Location', 'south');
hold off;

%% 7. Mostrar resultados en consola
fprintf('--- Resultados del Cálculo ---\n');
fprintf('Valor aproximado de la integral: %.6f\n', suma_gauss);