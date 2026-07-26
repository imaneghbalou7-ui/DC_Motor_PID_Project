%% ============================================================
% PARAMETERS.M
% Projet : Asservissement d'un moteur a courant continu
% Controleurs : P - PI - PID
% ============================================================

clear;
clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       GENERATION DES PARAMETRES DU PROJET\n');
fprintf('============================================================\n');


%% ============================================================
% 1. PARAMETRES PHYSIQUES DU MOTEUR
% ============================================================

R = 1.0;        % Resistance (Ohm)
L = 0.5;        % Inductance (H)
J = 0.01;       % Inertie (kg.m^2)
B = 0.1;        % Frottement visqueux
K = 0.01;       % Constante du moteur


%% ============================================================
% 2. CONSIGNE
% ============================================================

% La consigne utilisee dans le modele est unitaire

Speed_ref = 1;


%% ============================================================
% 3. PARAMETRES DE SIMULATION
% ============================================================

Simulation_Time = 5;       % secondes
Sample_Time = 0.001;       % secondes


%% ============================================================
% 4. LIMITATION DE LA TENSION
% ============================================================

Vmax = 24;


%% ============================================================
% 5. GAINS DU CONTROLEUR P
% ============================================================

Kp_P = 5;


%% ============================================================
% 6. GAINS DU CONTROLEUR PI
% ============================================================

Kp_PI = 3;

Ki_PI = 15;


%% ============================================================
% 7. GAINS DU CONTROLEUR PID
% ============================================================

Kp_PID = 4;

Ki_PID = 20;

Kd_PID = 0.05;


%% ============================================================
% 8. PERTURBATION
% ============================================================

% Ces variables sont conservees pour etre disponibles
% dans le workspace MATLAB / Simulink.
%
% La perturbation presente directement dans Simulink
% n'est PAS supprimee par ce script.

Perturbation_Amplitude = 0.2;

Perturbation_Time = 2;


%% ============================================================
% 9. BRUIT
% ============================================================

% Le bruit present dans Simulink est conserve.

Noise_Amplitude = 0.01;


%% ============================================================
% 10. VALEURS INITIALES DU CONTROLEUR
% ============================================================

Kp = Kp_P;

Ki = 0;

Kd = 0;


% Variables utilisees pour le controleur actif

Kp_actif = Kp;

Ki_actif = Ki;

Kd_actif = Kd;


%% ============================================================
% 11. CHEMIN DE SAUVEGARDE
% ============================================================

scriptFolder = fileparts(mfilename('fullpath'));

paramsFile = fullfile( ...
    scriptFolder, ...
    'params.mat');


%% ============================================================
% 12. SAUVEGARDE DE params.mat
% ============================================================

save( ...
    paramsFile, ...
    'R', ...
    'L', ...
    'J', ...
    'B', ...
    'K', ...
    'Speed_ref', ...
    'Vmax', ...
    'Simulation_Time', ...
    'Sample_Time', ...
    'Kp_P', ...
    'Kp_PI', ...
    'Ki_PI', ...
    'Kp_PID', ...
    'Ki_PID', ...
    'Kd_PID', ...
    'Perturbation_Amplitude', ...
    'Perturbation_Time', ...
    'Noise_Amplitude', ...
    'Kp', ...
    'Ki', ...
    'Kd', ...
    'Kp_actif', ...
    'Ki_actif', ...
    'Kd_actif');


%% ============================================================
% 13. AFFICHAGE
% ============================================================

fprintf('\n');
fprintf('PARAMETRES DU MOTEUR\n');
fprintf('------------------------------------------------------------\n');

fprintf('R = %.4f Ohm\n', R);
fprintf('L = %.4f H\n', L);
fprintf('J = %.4f kg.m^2\n', J);
fprintf('B = %.4f\n', B);
fprintf('K = %.4f\n', K);


fprintf('\n');
fprintf('CONSIGNE\n');
fprintf('------------------------------------------------------------\n');

fprintf('Speed_ref = %.4f\n', Speed_ref);


fprintf('\n');
fprintf('GAINS DES CONTROLEURS\n');
fprintf('------------------------------------------------------------\n');

fprintf('P   : Kp = %.4f | Ki = 0 | Kd = 0\n', Kp_P);

fprintf('PI  : Kp = %.4f | Ki = %.4f | Kd = 0\n', ...
    Kp_PI, Ki_PI);

fprintf('PID : Kp = %.4f | Ki = %.4f | Kd = %.4f\n', ...
    Kp_PID, Ki_PID, Kd_PID);


fprintf('\n');
fprintf('PERTURBATION : CONSERVEE\n');
fprintf('BRUIT        : CONSERVE\n');


fprintf('\n');
fprintf('============================================================\n');

fprintf('params.mat genere avec succes.\n');

fprintf('Fichier : %s\n', paramsFile);

fprintf('============================================================\n');