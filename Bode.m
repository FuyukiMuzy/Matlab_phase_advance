%% PROJETO DE CONTROLADOR POR AVANÇO DE FASE
% Planta: G(s) = 4 / (s*(s+10))
% Requisitos: Kv = 16 s⁻¹, MF ≈ 40°, MG > 6 dB

clc;
clear;
close all;

%% --- Definição da planta ---
s = tf('s');
G = 3 / (s * (s + 2))
MF=38 %Magem de fase desejada em deg
MG=10  %Margem de ganho em dB
KV=41 %s-1
%% Satisfazer o requisito da constante de erro estático
K = KV / (dcgain(s * G))  % dcgain calcula o valor em s → 0
G1=K*G
%Gráfico bode G e G1
figure;
bodeplot(G, G1);
legend('G', 'G1', 'Location', 'southwest');
[Gm,MF1,Wcg,Wcp1] = margin(G1); %Pm = Margem de fase; Wcp=Frequência de corte; Gm=margem de ganho
MF1
Wcp1
%% 
phi= MF - MF1 + 3  % Avanço de fase máximo requerido.
alpha = (1 - sind(phi)) / (1 + sind(phi))
%%
Gc_=1/((alpha)^(1/2))
Gcdb=20*log10(Gc_) %dB a ser atingido
%% linha em -Gcdb e ponto de cruzamento com G1 ---

% Obter dados de Bode de G1
[mag, phase, w] = bode(G1);
mag = squeeze(mag);  % Remove dimensões extras
mag_dB = 20*log10(mag);
w = squeeze(w);

% Encontrar a frequência onde |G1(jw)| ≈ -Gcdb dB
% Interpolação para encontrar frequência onde mag_dB == -Gcdb
w_cross = interp1(mag_dB, w, -Gcdb, 'linear');  % agora mais preciso
mag_cross = interp1(w, mag_dB, w_cross);        % reavalia para confirmar
phase_cross = interp1(w, squeeze(phase), w_cross);  % Fase interpolada (opcional)

% Novo gráfico de Bode com marcações
figure;
h = bodeplot(G1);
grid on;
title('G1 com linha horizontal em -Gcdb e ponto de cruzamento');

% Espera o gráfico ser renderizado
drawnow;

% Acessa o eixo de magnitude
ax = findall(gcf, 'Type', 'axes');
mag_ax = ax(2);  % eixo da magnitude

% Linha horizontal em -Gcdb dB
yline(mag_ax, -Gcdb, '--r', sprintf('-%.2f dB', Gcdb), ...
    'LabelHorizontalAlignment', 'left', ...
    'LabelVerticalAlignment', 'bottom', ...
    'FontWeight', 'bold');

% Marcar o ponto de cruzamento
hold(mag_ax, 'on');
semilogx(mag_ax, w_cross, mag_cross, 'ks', ...
    'MarkerSize', 8, 'MarkerFaceColor', 'r');
text(w_cross, mag_cross, sprintf('  (%.2f rad/s)', w_cross), ...
    'Parent', mag_ax, 'Color', 'r', 'FontWeight', 'bold', ...
    'VerticalAlignment', 'bottom');
%% localização do zero do controlador 1/T = zero
zero=w_cross * ((alpha)^(1/2))
%% localização do polo do controlador 1/Ta = zero
pole = zero/alpha
%% localização do ganho do controlador KC
KC=K/alpha
%% Controlador e resposta da planta
Gc=KC*(s+zero)/(s+pole)
GGc=G*Gc
[GmGGc,MFGGc,WcgGGc,WcpGGc] = margin(GGc);
figure;
bodeplot(GGc,Gc,G,G1)
legend('GGc','Gc','G','G1', 'Location', 'southwest');
%% Verificação do erro estático (entrada rampa)
Kv_calc = dcgain(s * GGc)  % s*GGc para constante de velocidade
ess_rampa = 1 / Kv_calc;
MFGGc
GmGGc
%% Resposta ao degrau da malha fechada original vs compensada

% Malha fechada com realimentação unária (feedback = 1)
T_original = feedback(G, 1);  % com ganho K, mas sem compensador
T_compensado = feedback(GGc, 1);  % G * Gc

% Resposta ao degrau
t = 0:0.01:5;  % tempo de simulação
[y_orig, t_out] = step(T_original, t);
[y_comp, ~] = step(T_compensado, t);

% Gráfico
figure;
plot(t_out, y_orig, 'b--', 'LineWidth', 1.5);
hold on;
plot(t_out, y_comp, 'r-', 'LineWidth', 1.8);
grid on;
legend('Original (G)', 'Compensado (G*Gc)', 'Location', 'southeast');
xlabel('Tempo (s)');
ylabel('Saída');
title('Resposta ao Degrau: Sistema Original vs Compensado');