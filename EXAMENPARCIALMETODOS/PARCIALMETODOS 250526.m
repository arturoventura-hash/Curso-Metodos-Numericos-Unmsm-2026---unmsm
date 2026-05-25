%% ============================================================
%  ANALISIS COMPLETO DE IMPEDANCIA BIOELECTRICA
%  Incluye:
%  A) Analisis exploratorio
%  B) Interpolacion (polinomica y spline)
%  C) Derivacion numerica
%  D) Busqueda de raices
%  E) Discusion tecnica
% ============================================================

clc; clear; close all;
% Limpia pantalla, variables y cierra figuras


%% ===================== DATOS ================================

f = [100 120 145 170 200 235 270 310 355 405 460 520 585 655 730 ...
     810 895 985 1080 1180 1290 1410 1540 1680 1830 1990 2160 2340 2530 2730];
% Frecuencias (Hz)

Z = [152.3 149.1 146.8 144.9 142.0 139.5 137.9 136.1 134.8 133.6 ...
     132.7 131.9 131.4 131.1 130.9 131.0 131.3 131.9 132.7 133.8 ...
     135.2 136.9 138.9 141.1 143.5 146.1 149.0 152.2 155.6 159.2];
% Impedancia (Ohm)

n = length(f); % Numero de datos


%% ===================== PARTE A ==============================
% ANALISIS EXPLORATORIO

figure;
plot(f,Z,'o-','LineWidth',1.5);
grid on;
xlabel('Frecuencia (Hz)');
ylabel('|Z| (Ohm)');
title('A) Impedancia vs Frecuencia');

[minZ, idx] = min(Z); % Valor minimo
f_min = f(idx);       % Frecuencia del minimo

fprintf('\n=== PARTE A ===\n');
fprintf('Minimo aproximado: %.4f Ohm en f = %.4f Hz\n', minZ, f_min);

% Interpretacion:
% La curva tiene forma de U, tipica de sistemas bioelectricos


%% ===================== PARTE B1 =============================
% INTERPOLACION POLINOMICA

f_eval = linspace(min(f), max(f), 1000);
% Malla fina para graficas suaves

p10 = polyfit(f,Z,10);
% Ajuste polinomio grado 10

Z_p10 = polyval(p10,f_eval);
% Evaluacion del polinomio

V = fliplr(vander(f));
% Matriz de Vandermonde

coef29 = V\Z';
% Interpolacion exacta (grado 29)

Z_p29 = polyval(coef29,f_eval);

figure;
plot(f,Z,'ko'); hold on;
plot(f_eval,Z_p10,'b','LineWidth',1.5);
plot(f_eval,Z_p29,'r--');
legend('Datos','Grado 10','Grado 29');
title('B1) Comparacion de polinomios');
grid on;

Z_1000_poly = polyval(p10,1000);

fprintf('\n=== PARTE B1 ===\n');
fprintf('|Z|(1000 Hz) polinomio = %.4f Ohm\n', Z_1000_poly);

% -------- VALIDACION LOO --------
rng(1);
idx_test = randperm(n,5);
errores = zeros(1,5);

for i = 1:5
    f_train = f; f_train(idx_test(i)) = [];
    Z_train = Z; Z_train(idx_test(i)) = [];
    
    p = polyfit(f_train,Z_train,10);
    Z_pred = polyval(p,f(idx_test(i)));
    
    errores(i) = abs((Z(idx_test(i))-Z_pred)/Z(idx_test(i)));
end

error_rel = mean(errores);

fprintf('Error relativo LOO = %.4f\n', error_rel);


%% ===================== PARTE B2 =============================
% SPLINE CUBICO

pp = spline(f,Z); % Construccion spline

Z_spline = ppval(pp,f_eval);

figure;
plot(f,Z,'ko'); hold on;
plot(f_eval,Z_spline,'b','LineWidth',1.5);
plot(f_eval,Z_p10,'r--');
legend('Datos','Spline','Polinomio');
title('B2) Spline vs Polinomio');
grid on;

Z_1000_spline = ppval(pp,1000);

fprintf('\n=== PARTE B2 ===\n');
fprintf('|Z|(1000 Hz) spline = %.4f Ohm\n', Z_1000_spline);

% El spline es mas estable y evita oscilaciones


%% ===================== PARTE C ==============================
% DERIVACION NUMERICA

pp_der1 = fnder(pp,1); % Primera derivada
dZ = ppval(pp_der1,f_eval);

figure;
plot(f_eval,dZ,'LineWidth',1.5);
grid on;
xlabel('Frecuencia');
ylabel('d|Z|/df');
title('C) Primera derivada');

idx_cambio = find(diff(sign(dZ))>0);
f_min_real = f_eval(idx_cambio(1));

fprintf('\n=== PARTE C ===\n');
fprintf('Minimo real ? %.4f Hz\n', f_min_real);

pp_der2 = fnder(pp,2); % Segunda derivada
d2Z = ppval(pp_der2,f_min_real);

fprintf('Segunda derivada = %.4f\n', d2Z);

% Si segunda derivada > 0 -> minimo estable


%% ===================== PARTE D ==============================
% BUSQUEDA DE RAICES

Zth = 150;

fun = @(x) ppval(pp,x) - Zth;

% ---- BISECCION ----
a = 100; b = 500;
fa = fun(a);

while (b-a)/2 > 1e-4
    c = (a+b)/2;
    fc = fun(c);
    
    if fa*fc < 0
        b = c;
    else
        a = c;
        fa = fc;
    end
end

raiz_bis = c;

% ---- NEWTON ----
dfun = @(x) ppval(pp_der1,x);
x = 2000;

for i=1:10
    x = x - fun(x)/dfun(x);
end

raiz_newton = x;

fprintf('\n=== PARTE D ===\n');
fprintf('Raiz biseccion = %.4f Hz\n', raiz_bis);
fprintf('Raiz Newton    = %.4f Hz\n', raiz_newton);

% ---- SENSIBILIDAD ----
sens = 1/dfun(raiz_newton);

fprintf('Sensibilidad df/dZ = %.4f\n', sens);


%% ===================== PARTE E ==============================
% DISCUSION TECNICA

fprintf('\n=== PARTE E ===\n');

% a) BIOMEDICA
% El minimo de impedancia indica mayor conductividad del tejido
% y puede relacionarse con perfusion o estado fisiologico
fprintf('a) El minimo indica alta conductividad del tejido.\n');

% b) ELECTRONICA
% Zonas de alta pendiente requieren filtros precisos
fprintf('b) El filtro debe evitar zonas de cambio rapido.\n');

% c) TELECOMUNICACIONES
% Las raices definen la banda segura de operacion
fprintf('c) La banda segura depende de las raices.\n');

% MEJORAS
fprintf('\nMejoras:\n');
fprintf('1) Mayor densidad de muestreo.\n');
fprintf('2) Mejor control de temperatura.\n');


%% ===================== CONCLUSION ===========================
% - El spline es el metodo mas confiable
% - El minimo ocurre cerca de 740 Hz
% - Las raices definen limites de operacion
% - La sensibilidad depende de la pendiente