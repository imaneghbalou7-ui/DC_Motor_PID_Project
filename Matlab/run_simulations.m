%% ============================================================
% RUN_SIMULATIONS.M
% Phase 15 - Simulations automatiques
%
% Controleurs :
%   P
%   PI
%   PID
%
% La perturbation et le bruit du modele Simulink
% sont conserves.
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

simulinkFolder = fullfile( ...
    projectFolder, ...
    'Simulink');

resultsFolder = fullfile( ...
    projectFolder, ...
    'Results');

paramsFile = fullfile( ...
    matlabFolder, ...
    'params.mat');

modelFile = fullfile( ...
    simulinkFolder, ...
    'DC_Motor_ClosedLoop.slx');


%% ============================================================
% 2. VERIFICATION DE params.mat
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('       PHASE 15 - SIMULATIONS AUTOMATIQUES\n');
fprintf('============================================================\n');

if ~exist(paramsFile, 'file')

    error([ ...
        'ERREUR : params.mat est introuvable ici :\n' ...
        '%s\n\n' ...
        'Execute d abord parameters.m.'], ...
        paramsFile);

end


fprintf('\nparams.mat trouve.\n');


%% ============================================================
% 3. CHARGEMENT DES PARAMETRES
% ============================================================

load(paramsFile);

fprintf('Parametres charges.\n');


%% ============================================================
% 4. VERIFICATION DU MODELE SIMULINK
% ============================================================

if ~exist(modelFile, 'file')

    error([ ...
        'ERREUR : DC_Motor_ClosedLoop.slx est introuvable.\n' ...
        'Chemin recherche :\n%s'], ...
        modelFile);

end


fprintf('Modele Simulink trouve.\n');


%% ============================================================
% 5. CREATION DU DOSSIER RESULTS
% ============================================================

if ~exist(resultsFolder, 'dir')

    mkdir(resultsFolder);

end


%% ============================================================
% 6. SUPPRESSION DES ANCIENS RESULTATS
% ============================================================

fprintf('\n');
fprintf('Suppression des anciens resultats...\n');


oldResults = { ...
    fullfile(resultsFolder, 'results_P.mat'), ...
    fullfile(resultsFolder, 'results_PI.mat'), ...
    fullfile(resultsFolder, 'results_PID.mat') ...
    };


for i = 1:length(oldResults)

    if exist(oldResults{i}, 'file')

        delete(oldResults{i});

        fprintf('Supprime : %s\n', ...
            oldResults{i});

    end

end


fprintf('Anciens resultats supprimes.\n');


%% ============================================================
% 7. NOM DU MODELE
% ============================================================

modelName = 'DC_Motor_ClosedLoop';


%% ============================================================
% 8. OUVERTURE DU MODELE
% ============================================================

fprintf('\nOuverture du modele Simulink...\n');

load_system(modelFile);

fprintf('Modele ouvert.\n');


%% ============================================================
% 9. DEFINITION DES CONTROLEURS
% ============================================================

controllers = {'P', 'PI', 'PID'};


Kp_values = [ ...
    Kp_P, ...
    Kp_PI, ...
    Kp_PID];


Ki_values = [ ...
    0, ...
    Ki_PI, ...
    Ki_PID];


Kd_values = [ ...
    0, ...
    0, ...
    Kd_PID];


%% ============================================================
% 10. AFFICHAGE DES GAINS
% ============================================================

fprintf('\n');
fprintf('GAINS UTILISES\n');
fprintf('------------------------------------------------------------\n');

fprintf('P   : Kp = %.4f | Ki = %.4f | Kd = %.4f\n', ...
    Kp_values(1), ...
    Ki_values(1), ...
    Kd_values(1));

fprintf('PI  : Kp = %.4f | Ki = %.4f | Kd = %.4f\n', ...
    Kp_values(2), ...
    Ki_values(2), ...
    Kd_values(2));

fprintf('PID : Kp = %.4f | Ki = %.4f | Kd = %.4f\n', ...
    Kp_values(3), ...
    Ki_values(3), ...
    Kd_values(3));


fprintf('\nPerturbation : CONSERVEE\n');

fprintf('Bruit : CONSERVE\n');


%% ============================================================
% 11. SIMULATIONS P / PI / PID
% ============================================================

for i = 1:3

    controllerName = controllers{i};


    fprintf('\n');
    fprintf('============================================================\n');

    fprintf('SIMULATION %d / 3 : %s\n', ...
        i, controllerName);

    fprintf('============================================================\n');


    %% --------------------------------------------------------
    % DEFINIR LES GAINS ACTIFS
    % ---------------------------------------------------------

    Kp_actif = Kp_values(i);

    Ki_actif = Ki_values(i);

    Kd_actif = Kd_values(i);


    % Variables principales utilisees par Simulink

    Kp = Kp_actif;

    Ki = Ki_actif;

    Kd = Kd_actif;


    fprintf('\nGains actifs :\n');

    fprintf('Kp = %.4f\n', Kp);

    fprintf('Ki = %.4f\n', Ki);

    fprintf('Kd = %.4f\n', Kd);


    %% --------------------------------------------------------
    % MISE A JOUR DU MODELE
    % ---------------------------------------------------------

    set_param( ...
        modelName, ...
        'StopTime', ...
        num2str(Simulation_Time));


    %% --------------------------------------------------------
    % SIMULATION
    % ---------------------------------------------------------

    fprintf('\nSimulation en cours...\n');


    out = sim( ...
        modelName, ...
        'ReturnWorkspaceOutputs', ...
        'on');


    fprintf('Simulation terminee.\n');


    %% --------------------------------------------------------
    % RECUPERATION DE y_closed_loop
    % ---------------------------------------------------------

    if ~isprop(out, 'y_closed_loop')

        error([ ...
            'ERREUR : y_closed_loop est absent pour %s.\n\n' ...
            'Verifie le bloc To Workspace dans Simulink.'], ...
            controllerName);

    end


    y_closed_loop = out.y_closed_loop;


    %% --------------------------------------------------------
    % CONVERSION TIMESERIES
    % ---------------------------------------------------------

    if isa(y_closed_loop, 'timeseries')

        time = y_closed_loop.Time;

        data = y_closed_loop.Data;


    elseif isstruct(y_closed_loop)

        time = y_closed_loop.time;

        data = y_closed_loop.signals.values;


    else

        error([ ...
            'ERREUR : format de y_closed_loop non reconnu ' ...
            'pour %s.'], ...
            controllerName);

    end


    %% --------------------------------------------------------
    % CONVERSION EN VECTEURS
    % ---------------------------------------------------------

    time = time(:);

    data = data(:);


    %% --------------------------------------------------------
    % SAUVEGARDE
    % ---------------------------------------------------------

    resultFile = fullfile( ...
        resultsFolder, ...
        ['results_' controllerName '.mat']);


    save( ...
        resultFile, ...
        'time', ...
        'data', ...
        'Kp_actif', ...
        'Ki_actif', ...
        'Kd_actif', ...
        'Speed_ref');


    fprintf('\nResultat sauvegarde :\n');

    fprintf('%s\n', resultFile);


end


%% ============================================================
% 12. FERMETURE
% ============================================================

close_system( ...
    modelName, ...
    0);


%% ============================================================
% 13. FIN
% ============================================================

fprintf('\n');
fprintf('============================================================\n');

fprintf('SIMULATIONS TERMINEES AVEC SUCCES\n');

fprintf('============================================================\n');

fprintf('\nFichiers generes :\n');

fprintf('results_P.mat\n');

fprintf('results_PI.mat\n');

fprintf('results_PID.mat\n');

fprintf('\n');
fprintf('Tu peux maintenant executer :\n');

fprintf('analyse_results\n');

fprintf('\n');