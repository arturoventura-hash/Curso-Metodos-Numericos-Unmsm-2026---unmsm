clear; clc; close all;

% 1. FORZAR VENTANA (Configuración de emergencia)
set(0, 'DefaultFigureWindowStyle', 'normal');
graphics_toolkit('fltk'); % Es el motor más estable

% --- DATOS DEL PROBLEMA ---
f = @(x) x .* cos(x) - 1;
df = @(x) cos(x) - x .* sin(x);
tol = 1e-6;

% 2. ABRIR LA GRÁFICA ANTES DE CUALQUIER COSA
figure(1);
x_p = linspace(0, 1.5, 200);
y_p = f(x_p);
plot(x_p, y_p, 'b', 'LineWidth', 2); hold on; grid on;
line([0 1.5], [0 0], 'Color', 'k', 'LineWidth', 2);
title('f(x) = x*cos(x) - 1');
xlabel('x'); ylabel('f(x)');
shg; % Fuerza a mostrar la ventana
drawnow; % Refresca la pantalla

% 3. MENÚ (Mira la Command Window ahora)
fprintf('\n--- EJERCICIO DE LA IMAGEN (TOLERANCIA 10^-6) ---\n');
fprintf('1. Biseccion\n2. Newton-Raphson\n3. Secante\n4. COMPARATIVO\n');
opc = input('ELIJA UNA OPCION Y PRESIONE ENTER: ');

% --- PROCESOS ---

if opc == 1 || opc == 4
    a = 0.6; b = 0.7; it = 0; err = 1;
    while err > tol
        it++; c = (a + b) / 2;
        plot([a a], [-0.5 0.5], 'r--'); % Dibuja líneas rojas
        if f(a)*f(c) < 0, b = c; else a = c; end
        err = abs(f(c));
    end
    fprintf('\nBISECCION -> Raiz: %.8f | It: %d | Error: %.2e\n', c, it, err);
    plot(c, 0, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
end

if opc == 2 || opc == 4
    xi = 0.5; it = 0; err = 1;
    while err > tol
        it++;
        xn = xi - f(xi)/df(xi);
        plot([xi xn], [f(xi) 0], 'm-o', 'LineWidth', 1.5); % Líneas magenta
        err = abs(xn - xi);
        xi = xn;
    end
    fprintf('NEWTON    -> Raiz: %.8f | It: %d | Error: %.2e\n', xi, it, err);
    plot(xi, 0, 'mo', 'MarkerFaceColor', 'm', 'MarkerSize', 8);
end

if opc == 3 || opc == 4
    x0 = 0.5; x1 = 0.7; it = 0; err = 1;
    while err > tol
        it++;
        f0 = f(x0); f1 = f(x1);
        xn = x1 - (f1*(x1-x0))/(f1-f0);
        plot([x0 x1], [f0 f1], 'c-x', 'LineWidth', 1.5); % Líneas cian
        err = abs(xn - x1);
        x0 = x1; x1 = xn;
    end
    fprintf('SECANTE   -> Raiz: %.8f | It: %d | Error: %.2e\n', x1, it, err);
    plot(x1, 0, 'co', 'MarkerFaceColor', 'c', 'MarkerSize', 8);
end

shg; % Último empujón a la gráfica
