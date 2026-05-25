clc; clear; close all; % Limpia todo

%% =========================
% DATOS DEL PROBLEMA
% =========================

f = [10 12.5 15 17.5 20 22.5 25 27.5 30 32.5 35 37.5 40 42.5 ...
     45 47.5 50 52.5 55 57.5 60 62.5 65 67.5 70 72.5 75 ...
     77.5 80 82.5 85 87.5 90 92.5 95 97.5 100 102.5 105 107.5];

V = [0.842 0.911 0.986 1.062 1.143 1.227 1.314 1.401 1.482 1.551 ...
     1.216 1.048 0.866 0.689 0.521 0.364 0.223 0.103 0.012 -0.041 ...
     -0.057 -0.034 0.018 0.096 0.197 0.318 0.452 0.579 0.700 ...
     0.809 0.611 0.688 0.756 0.811 0.856 0.894 0.926 0.954 ...
     0.980 1.004];

Z = [182.4 178.9 175.1 171.0 166.8 162.7 158.9 155.4 152.0 149.0 ...
     146.1 145.2 145.8 147.3 149.9 153.5 158.0 163.2 168.9 174.8 ...
     180.5 186.2 191.5 196.2 200.1 203.1 205.2 206.3 206.1 ...
     204.7 198.0 194.4 190.9 187.8 185.1 183.0 181.6 180.8 ...
     180.6 180.9];

%% =========================
% PARTE 1: SPLINE
% =========================

f_eval = linspace(min(f), max(f), 500); % puntos para graficar

V_spline = spline(f, V, f_eval); % spline voltaje
Z_spline = spline(f, Z, f_eval); % spline impedancia

% Evaluaciones
V_41 = spline(f, V, 41);
Z_41 = spline(f, Z, 41);

V_73 = spline(f, V, 73);
Z_73 = spline(f, Z, 73);

fprintf('--- SPLINE ---\n');
fprintf('V(41) = %.4f\n', V_41);
fprintf('Z(41) = %.4f\n', Z_41);
fprintf('V(73) = %.4f\n', V_73);
fprintf('Z(73) = %.4f\n\n', Z_73);

%% =========================
% PARTE 2: DERIVADAS
% =========================

h = 2.5; % paso

idx = @(val) find(abs(f - val) < 1e-6); % función índice

% Diferencias centradas
dV_40 = (V(idx(42.5)) - V(idx(37.5))) / (2*h);
dV_70 = (V(idx(72.5)) - V(idx(67.5))) / (2*h);
dV_100 = (V(idx(102.5)) - V(idx(97.5))) / (2*h);

fprintf('--- DERIVADAS ---\n');
fprintf('dV/df(40) = %.4f\n', dV_40);
fprintf('dV/df(70) = %.4f\n', dV_70);
fprintf('dV/df(100) = %.4f\n\n', dV_100);

% Derivada con spline
pp = spline(f, V);
pp_der = fnder(pp);

fprintf('--- DERIVADAS SPLINE ---\n');
fprintf('dV/df(40) = %.4f\n', ppval(pp_der,40));
fprintf('dV/df(70) = %.4f\n', ppval(pp_der,70));
fprintf('dV/df(100) = %.4f\n\n', ppval(pp_der,100));

%% =========================
% PARTE 3: RAÍZ (BISECCIÓN)
% =========================

% Buscar cambio de signo
for i = 1:length(V)-1
    if V(i)*V(i+1) < 0
        a = f(i);
        b = f(i+1);
        break;
    end
end

tol = 1e-4;

while (b - a)/2 > tol
    c = (a + b)/2;
    fc = spline(f, V, c);
    
    if spline(f,V,a)*fc < 0
        b = c;
    else
        a = c;
    end
end

raiz = (a + b)/2;

fprintf('--- RAÍZ ---\n');
fprintf('Raíz ? %.4f kHz\n\n', raiz);

%% =========================
% GRÁFICAS (SIN yline)
% =========================

figure;

% Voltaje
subplot(2,1,1)
plot(f, V, 'o','LineWidth',2); hold on;
plot(f_eval, V_spline,'LineWidth',2);

% Línea horizontal en 0 (compatible con todas versiones)
plot([min(f) max(f)], [0 0], 'r--','LineWidth',1.5);

title('Voltaje vs Frecuencia');
xlabel('Frecuencia (kHz)');
ylabel('Voltaje (V)');
legend('Datos','Spline','Nivel 0');
grid on;

% Impedancia
subplot(2,1,2)
plot(f, Z, 'o','LineWidth',2); hold on;
plot(f_eval, Z_spline,'LineWidth',2);

title('Impedancia vs Frecuencia');
xlabel('Frecuencia (kHz)');
ylabel('|Z| (Ohm)');
legend('Datos','Spline');
grid on;