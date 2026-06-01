clc;
clear;
close all;

% =====================================================
% DATOS EXPERIMENTALES
% =====================================================

V = [1 1.25 1.5 1.75 2 2.25 2.5 2.75 3 3.25 3.5 3.75 4];

P = [300.2 242.1 201.5 169.8 151 134.3 ...
     120.8 107.9 99.1 93.4 86.2 79.5 75.1];

n = length(V)-1;
h = 0.25;

% =====================================================
% 1) REGLA DEL TRAPECIO COMPUESTA
% =====================================================

suma = 0;

for i = 2:n
    suma = suma + P(i);
end

W_trap = (h/2)*(P(1) + 2*suma + P(n+1));

% =====================================================
% 2) REGLA DE SIMPSON 1/3
% =====================================================

suma_impar = 0;
suma_par = 0;

for i = 2:n

    if mod(i,2)==0
        suma_impar = suma_impar + P(i);
    else
        suma_par = suma_par + P(i);
    end

end

W_s13 = (h/3)*(P(1) + 4*suma_impar + ...
               2*suma_par + P(n+1));

% =====================================================
% 3) REGLA DE SIMPSON 3/8
% =====================================================

suma3 = 0;
suma2 = 0;

for i = 2:n

    if mod(i-1,3)==0
        suma2 = suma2 + P(i);
    else
        suma3 = suma3 + P(i);
    end

end

W_s38 = (3*h/8)*(P(1) + 3*suma3 + ...
                 2*suma2 + P(n+1));

% =====================================================
% 4) GAUSS-LEGENDRE m = 3
% =====================================================

a = 1;
b = 4;

% Nodos
t1 = -sqrt(3/5);
t2 = 0;
t3 = sqrt(3/5);

% Pesos
w1 = 5/9;
w2 = 8/9;
w3 = 5/9;

% Cambio de variable
x1 = ((b-a)/2)*t1 + ((a+b)/2);
x2 = ((b-a)/2)*t2 + ((a+b)/2);
x3 = ((b-a)/2)*t3 + ((a+b)/2);

% Interpolacion spline
y1 = spline(V,P,x1);
y2 = spline(V,P,x2);
y3 = spline(V,P,x3);

W_gauss = ((b-a)/2)*(w1*y1 + w2*y2 + w3*y3);

% =====================================================
% ERRORES RELATIVOS
% =====================================================

W_real = W_gauss;

err_trap = abs((W_real-W_trap)/W_real)*100;
err_s13 = abs((W_real-W_s13)/W_real)*100;
err_s38 = abs((W_real-W_s38)/W_real)*100;
err_gauss = 0;

% =====================================================
% TABLA DE RESULTADOS
% =====================================================

fprintf('\n');
fprintf('========================================================\n');
fprintf('METODO          VALOR APROXIMADO      ERROR RELATIVO %%\n');
fprintf('========================================================\n');

fprintf('Trapecio        %12.4f          %10.4f\n', ...
        W_trap, err_trap);

fprintf('Simpson 1/3     %12.4f          %10.4f\n', ...
        W_s13, err_s13);

fprintf('Simpson 3/8     %12.4f          %10.4f\n', ...
        W_s38, err_s38);

fprintf('Gauss-Legendre  %12.4f          %10.4f\n', ...
        W_gauss, err_gauss);

fprintf('========================================================\n');

% =====================================================
% GRAFICA
% =====================================================

xx = linspace(1,4,200);

yy = spline(V,P,xx);

figure;
plot(V,P,'ro','LineWidth',2);
hold on;
plot(xx,yy,'b','LineWidth',2);

xlabel('Volumen V (L)');
ylabel('Presion P (kPa)');
title('Interpolacion Spline Cubico');

legend('Datos experimentales','Spline cubico');

grid on;