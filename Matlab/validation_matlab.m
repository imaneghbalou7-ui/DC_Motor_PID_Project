%% ============================================================
%  validation_matlab.m
%  VALIDATION CROISEE : MATLAB PUR vs SIMULINK
% =============================================================

clear;
clc;
close all;

disp('============================================================');
disp('     VALIDATION CROISEE : MATLAB PUR vs SIMULINK');
disp('============================================================');
disp(' ');

%% ============================================================
%  1. CHARGEMENT DES PARAMETRES
% =============================================================

disp('Chargement des parametres...');

run('parameters.m');

disp('Parametres charges avec succes.');
disp(' ');


%% ============================================================
%  2. CREATION DE LA FONCTION DE TRANSFERT DU MOTEUR
% =============================================================

disp('Creation de la fonction de transfert du moteur...');

s = tf('s');

G = K / ...
    (L*J*s^2 + (L*B + R*J)*s + (R*B + K^2));

disp('Fonction de transfert du moteur :');
disp(G);
disp(' ');


%% ============================================================
%  3. CREATION DU CONTROLEUR PID
% =============================================================

disp('Creation du controleur PID...');

% Gains PID utilises pour la validation
Kp = Kp_PID;
Ki = Ki_PID;
Kd = Kd_PID;

C_PID = pid(Kp, Ki, Kd);

disp('Controleur PID :');
disp(C_PID);
disp(' ');


%% ============================================================
%  4. CREATION DE LA BOUCLE FERMEE MATLAB PUR
% =============================================================

disp('Creation de la boucle fermee MATLAB pur...');

sys_cl = feedback(C_PID * G, 1);

disp('Fonction de transfert en boucle fermee :');
disp(sys_cl);
disp(' ');


%% ============================================================
%  5. SIMULATION MATLAB PUR
% =============================================================

disp('Simulation MATLAB pur...');

% Temps de simulation
t_matlab = linspace(0, Simulation_Time, 1000);

% Reponse a un echelon unitaire
[y_matlab, t_matlab] = step(sys_cl, t_matlab);

% Prise en compte de la consigne
y_matlab = Speed_ref * y_matlab;

disp('Simulation MATLAB pur terminee.');
disp(' ');


%% ============================================================
%  6. CALCUL DES PERFORMANCES MATLAB PUR
% =============================================================

disp('============================================');
disp('PERFORMANCES MATLAB PUR');
disp('============================================');

% Calcul des performances
info_matlab = stepinfo(y_matlab, t_matlab);

% Valeur finale
final_value_matlab = y_matlab(end);

% Erreur statique
steady_state_error_matlab = ...
    abs(Speed_ref - final_value_matlab);

% Erreur statique en pourcentage
steady_state_error_percent_matlab = ...
    (steady_state_error_matlab / abs(Speed_ref)) * 100;

% Affichage
fprintf('Rise Time              : %.4f s\n', ...
    info_matlab.RiseTime);

fprintf('Settling Time          : %.4f s\n', ...
    info_matlab.SettlingTime);

fprintf('Overshoot              : %.4f %%\n', ...
    info_matlab.Overshoot);

fprintf('Peak                   : %.4f\n', ...
    info_matlab.Peak);

fprintf('Final Value            : %.4f\n', ...
    final_value_matlab);

fprintf('Steady-State Error     : %.4f %%\n', ...
    steady_state_error_percent_matlab);

disp(' ');


%% ============================================================
%  7. SIMULATION DU MODELE SIMULINK
% =============================================================

disp('============================================');
disp('SIMULATION DU MODELE SIMULINK');
disp('============================================');

% Chemin vers le modele Simulink
model_path = '../Simulink/validation';

% Ouverture du modele
disp('Ouverture du modele validation.slx...');

load_system(model_path);

disp('Modele Simulink charge avec succes.');
disp(' ');

% Simulation du modele
disp('Execution de la simulation Simulink...');

out = sim(model_path);

disp('Simulation Simulink terminee.');
disp(' ');


%% ============================================================
%  8. RECUPERATION DU RESULTAT SIMULINK
% =============================================================

disp('============================================');
disp('RECUPERATION DU RESULTAT SIMULINK');
disp('============================================');

% Recuperation du signal depuis l'objet SimulationOutput
y_validation = out.y_validation;

disp('Signal y_validation recupere avec succes.');

% Verification du type
disp('Type du signal :');
disp(class(y_validation));

disp(' ');


%% ============================================================
%  9. CALCUL DES PERFORMANCES SIMULINK
% =============================================================

% Recuperation du temps et des donnees
t_simulink = y_validation.Time;
y_simulink = y_validation.Data;

% Conversion en vecteur colonne si necessaire
t_simulink = t_simulink(:);
y_simulink = y_simulink(:);

% Calcul des performances Simulink
info_simulink = stepinfo(y_simulink, t_simulink);

% Valeur finale
final_value_simulink = y_simulink(end);

% Erreur statique
steady_state_error_simulink = ...
    abs(Speed_ref - final_value_simulink);

% Erreur statique en pourcentage
steady_state_error_percent_simulink = ...
    (steady_state_error_simulink / abs(Speed_ref)) * 100;


%% ============================================================
%  10. AFFICHAGE DES PERFORMANCES SIMULINK
% =============================================================

disp('============================================');
disp('PERFORMANCES SIMULINK');
disp('============================================');

fprintf('Rise Time              : %.4f s\n', ...
    info_simulink.RiseTime);

fprintf('Settling Time          : %.4f s\n', ...
    info_simulink.SettlingTime);

fprintf('Overshoot              : %.4f %%\n', ...
    info_simulink.Overshoot);

fprintf('Peak                   : %.4f\n', ...
    info_simulink.Peak);

fprintf('Final Value            : %.4f\n', ...
    final_value_simulink);

fprintf('Steady-State Error     : %.4f %%\n', ...
    steady_state_error_percent_simulink);

disp(' ');


%% ============================================================
%  11. COMPARAISON DES COURBES
% =============================================================

disp('============================================');
disp('COMPARAISON MATLAB PUR / SIMULINK');
disp('============================================');

figure('Name', 'Validation croisee MATLAB vs Simulink');

plot(t_matlab, y_matlab, ...
    'LineWidth', 1.5);

hold on;

plot(t_simulink, y_simulink, '--', ...
    'LineWidth', 1.5);

yline(Speed_ref, ':', ...
    'LineWidth', 1.2);

grid on;

legend('MATLAB pur', ...
       'Simulink', ...
       'Reference', ...
       'Location', 'best');

title('Validation croisee du modele DC Motor');

xlabel('Temps (s)');

ylabel('Vitesse normalisee');

hold off;


%% ============================================================
%  12. SAUVEGARDE DE LA FIGURE
% =============================================================

if ~exist('../Figures', 'dir')
    mkdir('../Figures');
end

saveas(gcf, ...
    '../Figures/Validation_MATLAB_vs_Simulink.png');

disp('Figure de validation sauvegardee dans :');
disp('../Figures/Validation_MATLAB_vs_Simulink.png');

disp(' ');


%% ============================================================
%  13. SAUVEGARDE DES RESULTATS
% =============================================================

if ~exist('../Results', 'dir')
    mkdir('../Results');
end

save('../Results/validation_results.mat', ...
    't_matlab', ...
    'y_matlab', ...
    't_simulink', ...
    'y_simulink', ...
    'info_matlab', ...
    'info_simulink', ...
    'final_value_matlab', ...
    'final_value_simulink', ...
    'steady_state_error_percent_matlab', ...
    'steady_state_error_percent_simulink');

disp('Resultats de validation sauvegardes dans :');
disp('../Results/validation_results.mat');

disp(' ');


%% ============================================================
%  14. TABLEAU COMPARATIF
% =============================================================

disp('============================================');
disp('TABLEAU COMPARATIF FINAL');
disp('============================================');

fprintf('\n');
fprintf('                 MATLAB PUR       SIMULINK\n');
fprintf('------------------------------------------------\n');

fprintf('Rise Time       :   %.4f s        %.4f s\n', ...
    info_matlab.RiseTime, ...
    info_simulink.RiseTime);

fprintf('Settling Time   :   %.4f s        %.4f s\n', ...
    info_matlab.SettlingTime, ...
    info_simulink.SettlingTime);

fprintf('Overshoot       :   %.4f %%        %.4f %%\n', ...
    info_matlab.Overshoot, ...
    info_simulink.Overshoot);

fprintf('Final Value     :   %.4f          %.4f\n', ...
    final_value_matlab, ...
    final_value_simulink);

fprintf('Erreur statique :   %.4f %%        %.4f %%\n', ...
    steady_state_error_percent_matlab, ...
    steady_state_error_percent_simulink);

fprintf('------------------------------------------------\n');

disp(' ');

disp('============================================================');
disp('VALIDATION CROISEE TERMINEE AVEC SUCCES');
disp('============================================================');

% ============================================================
% SAUVEGARDE DE LA FIGURE DE VALIDATION
% ============================================================

if ~exist('../Figures/validation', 'dir')
    mkdir('../Figures/validation');
end

saveas(gcf, '../Figures/validation/validation_matlab_vs_simulink.png');

fprintf('\nFigure de validation sauvegardee avec succes.\n');
fprintf('Fichier : Figures/validation/validation_matlab_vs_simulink.png\n');