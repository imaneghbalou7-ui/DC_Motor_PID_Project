%% ============================================================
% ANALYSE_RESULTS.M
% Comparaison P / PI / PID
%
% Une seule figure :
%   - P
%   - PI
%   - PID
%   - Consigne = 1
%
% ============================================================

clear;
clc;
close all;


%% ============================================================
% 1. CHEMINS
% ============================================================

matlabFolder = fileparts(mfilename('fullpath'));

projectFolder = fileparts(matlabFolder);

resultsFolder = fullfile( ...
    projectFolder, ...
    'Results');

figuresFolder = fullfile( ...
    projectFolder, ...
    'Figures');

paramsFile = fullfile( ...
    matlabFolder, ...
    'params.mat');


%% ============================================================
% 2. CHARGEMENT DE params.mat
% ============================================================

if ~exist(paramsFile, 'file')

    error( ...
        'ERREUR : params.mat est introuvable.');

end


load(paramsFile);


fprintf('\n');
fprintf('============================================================\n');
fprintf('       ANALYSE DES RESULTATS P / PI / PID\n');
fprintf('============================================================\n');

fprintf('\nConsigne = %.4f\n', Speed_ref);


%% ============================================================
% 3. CHARGEMENT DES RESULTATS
% ============================================================

fileP = fullfile( ...
    resultsFolder, ...
    'results_P.mat');

filePI = fullfile( ...
    resultsFolder, ...
    'results_PI.mat');

filePID = fullfile( ...
    resultsFolder, ...
    'results_PID.mat');


if ~exist(fileP, 'file')

    error('results_P.mat est introuvable.');

end


if ~exist(filePI, 'file')

    error('results_PI.mat est introuvable.');

end


if ~exist(filePID, 'file')

    error('results_PID.mat est introuvable.');

end


%% ============================================================
% 4. CHARGEMENT
% ============================================================

P = load(fileP);

PI = load(filePI);

PID = load(filePID);


%% ============================================================
% 5. RECUPERATION DES SIGNAUX
% ============================================================

t_P = P.time;

y_P = P.data;


t_PI = PI.time;

y_PI = PI.data;


t_PID = PID.time;

y_PID = PID.data;


%% ============================================================
% 6. CONVERSION EN VECTEURS
% ============================================================

t_P = t_P(:);

y_P = y_P(:);


t_PI = t_PI(:);

y_PI = y_PI(:);


t_PID = t_PID(:);

y_PID = y_PID(:);


%% ============================================================
% 7. CALCUL DES PERFORMANCES
% ============================================================

info_P = stepinfo( ...
    y_P, ...
    t_P, ...
    Speed_ref);


info_PI = stepinfo( ...
    y_PI, ...
    t_PI, ...
    Speed_ref);


info_PID = stepinfo( ...
    y_PID, ...
    t_PID, ...
    Speed_ref);


%% ============================================================
% 8. ERREURS STATIQUES
% ============================================================

error_P = abs( ...
    Speed_ref - y_P(end));


error_PI = abs( ...
    Speed_ref - y_PI(end));


error_PID = abs( ...
    Speed_ref - y_PID(end));


error_P_percent = ...
    100 * error_P / abs(Speed_ref);


error_PI_percent = ...
    100 * error_PI / abs(Speed_ref);


error_PID_percent = ...
    100 * error_PID / abs(Speed_ref);


%% ============================================================
% 9. AFFICHAGE DES RESULTATS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('                 RESULTATS COMPARATIFS\n');
fprintf('============================================================\n');


fprintf('\n');

fprintf('                         P          PI         PID\n');

fprintf('------------------------------------------------------------\n');


fprintf('Kp                 %8.4f   %8.4f   %8.4f\n', ...
    P.Kp_actif, ...
    PI.Kp_actif, ...
    PID.Kp_actif);


fprintf('Ki                 %8.4f   %8.4f   %8.4f\n', ...
    P.Ki_actif, ...
    PI.Ki_actif, ...
    PID.Ki_actif);


fprintf('Kd                 %8.4f   %8.4f   %8.4f\n', ...
    P.Kd_actif, ...
    PI.Kd_actif, ...
    PID.Kd_actif);


fprintf('------------------------------------------------------------\n');


fprintf('Rise Time (s)      %8.4f   %8.4f   %8.4f\n', ...
    info_P.RiseTime, ...
    info_PI.RiseTime, ...
    info_PID.RiseTime);


fprintf('Settling Time (s)  %8.4f   %8.4f   %8.4f\n', ...
    info_P.SettlingTime, ...
    info_PI.SettlingTime, ...
    info_PID.SettlingTime);


fprintf('Overshoot (%%)      %8.4f   %8.4f   %8.4f\n', ...
    info_P.Overshoot, ...
    info_PI.Overshoot, ...
    info_PID.Overshoot);


fprintf('Peak               %8.4f   %8.4f   %8.4f\n', ...
    info_P.Peak, ...
    info_PI.Peak, ...
    info_PID.Peak);


fprintf('Valeur finale      %8.4f   %8.4f   %8.4f\n', ...
    y_P(end), ...
    y_PI(end), ...
    y_PID(end));


fprintf('Erreur statique %%  %8.4f   %8.4f   %8.4f\n', ...
    error_P_percent, ...
    error_PI_percent, ...
    error_PID_percent);


fprintf('------------------------------------------------------------\n');


%% ============================================================
% 10. CREATION DU DOSSIER FIGURES
% ============================================================

if ~exist(figuresFolder, 'dir')

    mkdir(figuresFolder);

end


%% ============================================================
% 11. SUPPRESSION DE L'ANCIENNE FIGURE
% ============================================================

figureFile = fullfile( ...
    figuresFolder, ...
    'Comparaison_P_PI_PID.png');


if exist(figureFile, 'file')

    delete(figureFile);

end


%% ============================================================
% 12. CREATION DE LA FIGURE UNIQUE
% ============================================================

figure( ...
    'Name', ...
    'Comparaison P PI PID', ...
    'NumberTitle', ...
    'off');


% P

plot( ...
    t_P, ...
    y_P, ...
    'LineWidth', ...
    1.5);


hold on;


% PI

plot( ...
    t_PI, ...
    y_PI, ...
    'LineWidth', ...
    1.5);


% PID

plot( ...
    t_PID, ...
    y_PID, ...
    'LineWidth', ...
    1.5);


% Consigne

plot( ...
    [t_P(1), t_P(end)], ...
    [Speed_ref, Speed_ref], ...
    '--', ...
    'LineWidth', ...
    1.5);


%% ============================================================
% 13. CONFIGURATION
% ============================================================

grid on;


xlabel( ...
    'Temps (s)', ...
    'FontSize', ...
    12);


ylabel( ...
    'Sortie du systeme', ...
    'FontSize', ...
    12);


title( ...
    'Comparaison des controleurs P, PI et PID', ...
    'FontSize', ...
    13);


legend( ...
    'Controleur P', ...
    'Controleur PI', ...
    'Controleur PID', ...
    'Consigne', ...
    'Location', ...
    'best');


%% ============================================================
% 14. SAUVEGARDE
% ============================================================

saveas( ...
    gcf, ...
    figureFile);


fprintf('\n');
fprintf('============================================================\n');

fprintf('ANALYSE TERMINEE\n');

fprintf('============================================================\n');

fprintf('\nFigure sauvegardee :\n');

fprintf('%s\n', figureFile);

fprintf('\n');