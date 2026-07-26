%% ============================================================
% PERFORMANCE_ANALYSIS.M
%
% Phase 16 - Tableau automatique des performances
%
% Analyse les performances des :
%   - Controleur P
%   - Controleur PI
%   - Controleur PID
%
% Parametres calcules :
%   Tr  : Temps de montee
%   Ts  : Temps d'etablissement
%   Mp  : Depassement maximal
%   Ess : Erreur statique
%
% Le tableau est :
%   1. Affiche dans MATLAB
%   2. Sauvegarde en CSV
%
% ============================================================


clear;
clc;


%% ============================================================
% 1. DEFINITION DES CHEMINS
% ============================================================

% Dossier contenant ce script

matlabFolder = fileparts(mfilename('fullpath'));


% Dossier principal du projet

projectFolder = fileparts(matlabFolder);


% Dossier Results

resultsFolder = fullfile( ...
    projectFolder, ...
    'Results');


% Fichier params.mat

paramsFile = fullfile( ...
    matlabFolder, ...
    'params.mat');


%% ============================================================
% 2. AFFICHAGE DU TITRE
% ============================================================

fprintf('\n');

fprintf('============================================================\n');

fprintf('       PHASE 16 - TABLEAU AUTOMATIQUE DES PERFORMANCES\n');

fprintf('============================================================\n');


%% ============================================================
% 3. CHARGEMENT DES PARAMETRES
% ============================================================

if ~exist(paramsFile, 'file')

    error([ ...
        'ERREUR : Le fichier params.mat est introuvable ici :\n' ...
        '%s'], ...
        paramsFile);

end


load(paramsFile);


fprintf('\nParametres charges avec succes.\n');

fprintf('Consigne = %.4f\n', Speed_ref);


%% ============================================================
% 4. DEFINITION DES FICHIERS DE RESULTATS
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


%% ============================================================
% 5. VERIFICATION DES FICHIERS
% ============================================================

if ~exist(fileP, 'file')

    error( ...
        'ERREUR : results_P.mat est introuvable.');

end


if ~exist(filePI, 'file')

    error( ...
        'ERREUR : results_PI.mat est introuvable.');

end


if ~exist(filePID, 'file')

    error( ...
        'ERREUR : results_PID.mat est introuvable.');

end


fprintf('\nFichiers de resultats trouves.\n');


%% ============================================================
% 6. CHARGEMENT DES RESULTATS
% ============================================================

P = load(fileP);

PI = load(filePI);

PID = load(filePID);


%% ============================================================
% 7. RECUPERATION DES SIGNAUX
% ============================================================

% Controleur P

t_P = P.time;

y_P = P.data;


% Controleur PI

t_PI = PI.time;

y_PI = PI.data;


% Controleur PID

t_PID = PID.time;

y_PID = PID.data;


%% ============================================================
% 8. CONVERSION EN VECTEURS COLONNES
% ============================================================

t_P = t_P(:);

y_P = y_P(:);


t_PI = t_PI(:);

y_PI = y_PI(:);


t_PID = t_PID(:);

y_PID = y_PID(:);


%% ============================================================
% 9. CALCUL DES PERFORMANCES
% ============================================================

fprintf('\nCalcul des performances...\n');


% ------------------------------------------------------------
% Controleur P
% ------------------------------------------------------------

info_P = stepinfo( ...
    y_P, ...
    t_P, ...
    Speed_ref);


% ------------------------------------------------------------
% Controleur PI
% ------------------------------------------------------------

info_PI = stepinfo( ...
    y_PI, ...
    t_PI, ...
    Speed_ref);


% ------------------------------------------------------------
% Controleur PID
% ------------------------------------------------------------

info_PID = stepinfo( ...
    y_PID, ...
    t_PID, ...
    Speed_ref);


%% ============================================================
% 10. CALCUL DE L'ERREUR STATIQUE
% ============================================================

% Erreur absolue finale

Ess_P = abs( ...
    Speed_ref - y_P(end));


Ess_PI = abs( ...
    Speed_ref - y_PI(end));


Ess_PID = abs( ...
    Speed_ref - y_PID(end));


% Erreur statique en pourcentage

Ess_P_percent = ...
    100 * Ess_P / abs(Speed_ref);


Ess_PI_percent = ...
    100 * Ess_PI / abs(Speed_ref);


Ess_PID_percent = ...
    100 * Ess_PID / abs(Speed_ref);


%% ============================================================
% 11. CREATION DU TABLEAU
% ============================================================

Regulateur = { ...
    'P'; ...
    'PI'; ...
    'PID'};


% Temps de montee

Tr = [ ...
    info_P.RiseTime; ...
    info_PI.RiseTime; ...
    info_PID.RiseTime];


% Temps d'etablissement

Ts = [ ...
    info_P.SettlingTime; ...
    info_PI.SettlingTime; ...
    info_PID.SettlingTime];


% Depassement maximal

Mp = [ ...
    info_P.Overshoot; ...
    info_PI.Overshoot; ...
    info_PID.Overshoot];


% Erreur statique en pourcentage

Ess = [ ...
    Ess_P_percent; ...
    Ess_PI_percent; ...
    Ess_PID_percent];


% Valeur finale

ValeurFinale = [ ...
    y_P(end); ...
    y_PI(end); ...
    y_PID(end)];


% Valeur maximale

Peak = [ ...
    info_P.Peak; ...
    info_PI.Peak; ...
    info_PID.Peak];


%% ============================================================
% 12. CREATION DE LA TABLE MATLAB
% ============================================================

PerformanceTable = table( ...
    Regulateur, ...
    Tr, ...
    Ts, ...
    Mp, ...
    Ess, ...
    ValeurFinale, ...
    Peak);


%% ============================================================
% 13. AFFICHAGE DU TABLEAU
% ============================================================

fprintf('\n');

fprintf('============================================================\n');

fprintf('              TABLEAU DES PERFORMANCES\n');

fprintf('============================================================\n');


disp(PerformanceTable);


%% ============================================================
% 14. EXPORT CSV
% ============================================================

csvFile = fullfile( ...
    resultsFolder, ...
    'performance_table.csv');


writetable( ...
    PerformanceTable, ...
    csvFile);


%% ============================================================
% 15. CONFIRMATION
% ============================================================

fprintf('\n');

fprintf('============================================================\n');

fprintf('TABLEAU GENERE AVEC SUCCES\n');

fprintf('============================================================\n');


fprintf('\nFichier CSV :\n');

fprintf('%s\n', csvFile);


fprintf('\nLes performances ont ete calculees automatiquement.\n');


fprintf('\n');

fprintf('============================================================\n');