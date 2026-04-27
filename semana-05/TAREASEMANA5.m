clear; clc; close all;

% --- DEFINICIÓN DE LA FUNCIÓN ---
% f(x) = x^3 - 5x^2 + 7x - 3
f = @(x) x.^3 - 5.*x.^2 + 7.*x - 3;
df = @(x) 3.*x.^2 - 10.*x + 7; % Derivada exacta para Newton
tol = 1e-6; % Tolerancia solicitada 10^-6

% --- GRÁFICA INICIAL ---
x_val = linspace(0, 4, 100);
y_val = f(x_val);
figure('Name', 'Visualizacion de la Funcion');
plot(x_val, y_val, 'b', 'LineWidth', 2); hold on; grid on;
line([0 4], [0 0], 'Color', 'k'); % Eje X
title('f(x) = x^3 - 5x^2 + 7x - 3');
xlabel('x'); ylabel('f(x)');

% --- MENÚ INTERACTIVO ---
fprintf('==========================================\n');
fprintf('   IMPLEMENTACIÓN DE MÉTODOS NUMÉRICOS   \n');
fprintf('==========================================\n');
fprintf('1. Biseccion\n2. Newton-Raphson\n3. Secante\n4. Comparativo (Ejecutar todos)\n');
opc = input('Seleccione el metodo a usar: ');

% --- MÉTODO 1: BISECCIÓN ---
if opc == 1 || opc == 4
    fprintf('\n--- MÉTODO DE BISECCIÓN ---\n');
    a = input('Ingrese limite inferior (a): ');
    b = input('Ingrese limite superior (b): ');

    if f(a) * f(b) >= 0
        fprintf('ERROR: No hay cambio de signo en [%g, %g]. Bolzano no se cumple.\n', a, b);
    else
        it = 0; err = abs(b - a);
        while err > tol
            it = it + 1;
            c = (a + b) / 2;
            if f(a) * f(c) < 0
                b = c;
            else
                a = c;
            end
            err = abs(b - a);
        end
        fprintf('RAIZ: %.8f | ITERACIONES: %d | ERROR: %.2e\n', c, it, err);
    end
end

% --- MÉTODO 2: NEWTON-RAPHSON ---
if opc == 2 || opc == 4
    fprintf('\n--- MÉTODO DE NEWTON-RAPHSON ---\n');
    x0 = input('Ingrese punto semilla (x0): ');
    it = 0; err = 100;
    xi = x0;

    while err > tol
        it = it + 1;
        d_val = df(xi);
        if abs(d_val) < 1e-12 % Evitar división por cero
            fprintf('ERROR: Derivada cercana a cero. El metodo no puede continuar.\n');
            break;
        end
        xn = xi - f(xi)/d_val;
        err = abs(xn - xi);
        xi = xn;
        if it > 100, break; end % Seguridad contra divergencia
    end
    fprintf('RAIZ: %.8f | ITERACIONES: %d | ERROR: %.2e\n', xi, it, err);
end

% --- MÉTODO 3: SECANTE ---
if opc == 3 || opc == 4
    fprintf('\n--- MÉTODO DE LA SECANTE ---\n');
    x0 = input('Ingrese primera semilla (x0): ');
    x1 = input('Ingrese segunda semilla (x1): ');
    it = 0; err = 100;

    while err > tol
        it = it + 1;
        f0 = f(x0); f1 = f(x1);
        if abs(f1 - f0) < 1e-12
            fprintf('ERROR: Division por cero en la secante.\n');
            break;
        end
        % Formula de la secante
        xn = x1 - (f1 * (x1 - x0)) / (f1 - f0);
        err = abs(xn - x1);
        x0 = x1;
        x1 = xn;
        if it > 100, break; end
    end
    fprintf('RAIZ: %.8f | ITERACIONES: %d | ERROR: %.2e\n', x1, it, err);
end
