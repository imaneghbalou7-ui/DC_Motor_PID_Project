%% ROBUSTNESS ANALYSIS
% Analyse de robustesse du régulateur PID
% Variation de la résistance R et de l'inertie J

clear;
clc;
close all;

%% =========================================================
% 1. PARAMETRES NOMINAUX DU MOTEUR
% ==========================================================

R = 1.0;        % Résistance (Ohm)
L = 0.5;        % Inductance (H)
J = 0.01;       % Inertie (kg.m^2)
B = 0.1;        % Coefficient de frottement
K = 0.01;       % Constante moteur

%% =========================================================
% 2. GAINS DU PID RETENUS
% ==========================================================

Kp_PID = 21.23;
Ki_PID = 36.03;
Kd_PID = 1.815;

%% =========================================================
% 3. CONSIGNE
% ==========================================================

Speed_ref = 1;

%% =========================================================
% 4. CREATION DU PID
% ==========================================================

C_PID = pid(Kp_PID, Ki_PID, Kd_PID);

%% =========================================================
% 5. VARIATIONS DES PARAMETRES
% ==========================================================

% Variation de -30% à +30% avec un pas de 10%
variations = -0.3:0.1:0.3;

%% =========================================================
% 6. INITIALISATION DES RESULTATS POUR R
% ==========================================================

overshoot_R = zeros(size(variations));
risetime_R = zeros(size(variations));
settlingtime_R = zeros(size(variations));

%% =========================================================
% 7. ANALYSE DE ROBUSTESSE POUR LA RESISTANCE R
% ==========================================================

for i = 1:length(variations)

    % Nouvelle valeur de R
    R_test = R * (1 + variations(i));

    % Fonction de transfert du moteur avec R modifié
    s = tf('s');

    G_test = K / ...
        (L*J*s^2 + ...
        (L*B + R_test*J)*s + ...
        (R_test*B + K^2));

    % Fonction de transfert en boucle fermée
    sys_cl = feedback(C_PID * G_test, 1);

    % Calcul des performances
    info = stepinfo(sys_cl);

    % Sauvegarde des résultats
    overshoot_R(i) = info.Overshoot;
    risetime_R(i) = info.RiseTime;
    settlingtime_R(i) = info.SettlingTime;

end

%% =========================================================
% 8. AFFICHAGE DES RESULTATS POUR R
% ==========================================================

disp('==============================================');
disp('ANALYSE DE ROBUSTESSE - VARIATION DE R');
disp('==============================================');

T_R = table( ...
    variations'*100, ...
    R*(1+variations)', ...
    risetime_R', ...
    settlingtime_R', ...
    overshoot_R', ...
    'VariableNames', ...
    {'Variation_R_percent', ...
     'R_test', ...
     'RiseTime_s', ...
     'SettlingTime_s', ...
     'Overshoot_percent'});

disp(T_R);

%% =========================================================
% 9. GRAPHIQUE : INFLUENCE DE R SUR LE DEPASSEMENT
% ==========================================================

figure;

plot(variations*100, overshoot_R, '-o');

grid on;

xlabel('Variation de R (%)');
ylabel('Dépassement (%)');

title('Influence de la variation de R sur le dépassement');

%% =========================================================
% 10. GRAPHIQUE : INFLUENCE DE R SUR LE TEMPS DE MONTEE
% ==========================================================

figure;

plot(variations*100, risetime_R, '-o');

grid on;

xlabel('Variation de R (%)');
ylabel('Temps de montée (s)');

title('Influence de la variation de R sur le temps de montée');

%% =========================================================
% 11. INITIALISATION DES RESULTATS POUR J
% ==========================================================

overshoot_J = zeros(size(variations));
risetime_J = zeros(size(variations));
settlingtime_J = zeros(size(variations));

%% =========================================================
% 12. ANALYSE DE ROBUSTESSE POUR L'INERTIE J
% ==========================================================

for i = 1:length(variations)

    % Nouvelle valeur de J
    J_test = J * (1 + variations(i));

    % Fonction de transfert du moteur avec J modifié
    s = tf('s');

    G_test = K / ...
        (L*J_test*s^2 + ...
        (L*B + R*J_test)*s + ...
        (R*B + K^2));

    % Fonction de transfert en boucle fermée
    sys_cl = feedback(C_PID * G_test, 1);

    % Calcul des performances
    info = stepinfo(sys_cl);

    % Sauvegarde des résultats
    overshoot_J(i) = info.Overshoot;
    risetime_J(i) = info.RiseTime;
    settlingtime_J(i) = info.SettlingTime;

end

%% =========================================================
% 13. AFFICHAGE DES RESULTATS POUR J
% ==========================================================

disp('==============================================');
disp('ANALYSE DE ROBUSTESSE - VARIATION DE J');
disp('==============================================');

T_J = table( ...
    variations'*100, ...
    J*(1+variations)', ...
    risetime_J', ...
    settlingtime_J', ...
    overshoot_J', ...
    'VariableNames', ...
    {'Variation_J_percent', ...
     'J_test', ...
     'RiseTime_s', ...
     'SettlingTime_s', ...
     'Overshoot_percent'});

disp(T_J);

%% =========================================================
% 14. GRAPHIQUE : INFLUENCE DE J SUR LE DEPASSEMENT
% ==========================================================

figure;

plot(variations*100, overshoot_J, '-o');

grid on;

xlabel('Variation de J (%)');
ylabel('Dépassement (%)');

title('Influence de la variation de J sur le dépassement');

%% =========================================================
% 15. GRAPHIQUE : INFLUENCE DE J SUR LE TEMPS DE MONTEE
% ==========================================================

figure;

plot(variations*100, risetime_J, '-o');

grid on;

xlabel('Variation de J (%)');
ylabel('Temps de montée (s)');

title('Influence de la variation de J sur le temps de montée');

%% =========================================================
% 16. FIN DE L'ANALYSE
% ==========================================================

disp('==============================================');
disp('ANALYSE DE ROBUSTESSE TERMINEE');
disp('==============================================');

disp('Les résultats de la variation de R sont stockés dans T_R.');
disp('Les résultats de la variation de J sont stockés dans T_J.');