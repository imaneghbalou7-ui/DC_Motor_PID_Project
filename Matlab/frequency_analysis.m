%% ============================================================
%  FREQUENCY ANALYSIS
%  DC Motor Speed Control Project
%
%  Purpose:
%  - Build the DC motor transfer function
%  - Define P, PI and PID controllers
%  - Analyze open-loop frequency response
%  - Compute gain margin, phase margin and crossover frequencies
%  - Analyze closed-loop frequency response
%  - Generate Bode plots
%  - Generate Nyquist plots
%  - Save figures and numerical results
%
%  Author: Imane Ghbalou
%  Project: DC Motor Speed Control
% =============================================================

clear;
clc;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf('        FREQUENCY-DOMAIN ANALYSIS OF DC MOTOR\n');
fprintf('============================================================\n\n');


%% ============================================================
% 1. PROJECT PATHS
% =============================================================

% Get the folder containing this script
script_folder = fileparts(mfilename('fullpath'));

% Project root directory
project_root = fileparts(script_folder);

% Results folder
results_folder = fullfile(project_root, 'Results');

% Figures folder
figures_folder = fullfile(project_root, 'Figures');

% Frequency analysis figures folder
frequency_figures_folder = fullfile(figures_folder, ...
                                    'Frequency_Analysis');

% Create folders if they do not exist
if ~exist(results_folder, 'dir')
    mkdir(results_folder);
end

if ~exist(figures_folder, 'dir')
    mkdir(figures_folder);
end

if ~exist(frequency_figures_folder, 'dir')
    mkdir(frequency_figures_folder);
end


%% ============================================================
% 2. LOAD PROJECT PARAMETERS
% =============================================================

fprintf('Loading project parameters...\n');

params_file = fullfile(script_folder, 'params.mat');

if exist(params_file, 'file')

    load(params_file);

    fprintf('Parameters loaded successfully.\n\n');

else

    error(['ERROR: params.mat not found.\n' ...
           'Please run parameters.m first.']);

end


%% ============================================================
% 3. DISPLAY MOTOR PARAMETERS
% =============================================================

fprintf('------------------------------------------------------------\n');
fprintf('DC MOTOR PARAMETERS\n');
fprintf('------------------------------------------------------------\n');

fprintf('R = %.4f Ohm\n', R);
fprintf('L = %.4f H\n', L);
fprintf('J = %.4f kg.m^2\n', J);
fprintf('B = %.4f N.m.s/rad\n', B);
fprintf('K = %.4f\n', K);

fprintf('\n');


%% ============================================================
% 4. DEFINE THE LAPLACE VARIABLE
% =============================================================

s = tf('s');


%% ============================================================
% 5. BUILD THE DC MOTOR TRANSFER FUNCTION
% =============================================================

% DC motor transfer function:
%
%             K
% G(s) = -----------------------------
%        L*J*s^2 + (L*B+R*J)*s
%        + (R*B+K^2)

G_motor = K / ...
    (L*J*s^2 + ...
    (L*B + R*J)*s + ...
    (R*B + K^2));


fprintf('DC motor transfer function:\n');
G_motor


%% ============================================================
% 6. DEFINE CONTROLLER GAINS
% =============================================================

% Final benchmark gains used in the project

% P controller
Kp_P = 5;
Ki_P = 0;
Kd_P = 0;

% PI controller
Kp_PI = 3;
Ki_PI = 15;
Kd_PI = 0;

% PID controller
Kp_PID = 4;
Ki_PID = 20;
Kd_PID = 0.05;


%% ============================================================
% 7. CREATE THE CONTROLLERS
% =============================================================

% P controller

C_P = pid(Kp_P, Ki_P, Kd_P);


% PI controller

C_PI = pid(Kp_PI, Ki_PI, Kd_PI);


% PID controller

C_PID = pid(Kp_PID, Ki_PID, Kd_PID);


fprintf('\nControllers created successfully.\n');


%% ============================================================
% 8. CREATE OPEN-LOOP TRANSFER FUNCTIONS
% =============================================================

% Open-loop transfer functions:
%
% L(s) = C(s) * G(s)

L_P = C_P * G_motor;

L_PI = C_PI * G_motor;

L_PID = C_PID * G_motor;


fprintf('\nOpen-loop transfer functions created.\n');


%% ============================================================
% 9. CREATE CLOSED-LOOP TRANSFER FUNCTIONS
% =============================================================

% Closed-loop transfer functions:
%
% T(s) = C(s)G(s) / (1 + C(s)G(s))

T_P = feedback(L_P, 1);

T_PI = feedback(L_PI, 1);

T_PID = feedback(L_PID, 1);


fprintf('Closed-loop transfer functions created.\n');


%% ============================================================
% 10. FREQUENCY ANALYSIS
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('FREQUENCY-DOMAIN RESULTS\n');
fprintf('============================================================\n');


%% ------------------------------------------------------------
% P CONTROLLER
% ------------------------------------------------------------

[GM_P, PM_P, Wcg_P, Wcp_P] = margin(L_P);

fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('P CONTROLLER\n');
fprintf('------------------------------------------------------------\n');

fprintf('Gain Margin  = %.4f dB\n', 20*log10(GM_P));
fprintf('Phase Margin = %.4f degrees\n', PM_P);
fprintf('Gain Crossover Frequency = %.4f rad/s\n', Wcp_P);
fprintf('Phase Crossover Frequency = %.4f rad/s\n', Wcg_P);


%% ------------------------------------------------------------
% PI CONTROLLER
% ------------------------------------------------------------

[GM_PI, PM_PI, Wcg_PI, Wcp_PI] = margin(L_PI);

fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('PI CONTROLLER\n');
fprintf('------------------------------------------------------------\n');

fprintf('Gain Margin  = %.4f dB\n', 20*log10(GM_PI));
fprintf('Phase Margin = %.4f degrees\n', PM_PI);
fprintf('Gain Crossover Frequency = %.4f rad/s\n', Wcp_PI);
fprintf('Phase Crossover Frequency = %.4f rad/s\n', Wcg_PI);


%% ------------------------------------------------------------
% PID CONTROLLER
% ------------------------------------------------------------

[GM_PID, PM_PID, Wcg_PID, Wcp_PID] = margin(L_PID);

fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('PID CONTROLLER\n');
fprintf('------------------------------------------------------------\n');

fprintf('Gain Margin  = %.4f dB\n', 20*log10(GM_PID));
fprintf('Phase Margin = %.4f degrees\n', PM_PID);
fprintf('Gain Crossover Frequency = %.4f rad/s\n', Wcp_PID);
fprintf('Phase Crossover Frequency = %.4f rad/s\n', Wcg_PID);


%% ============================================================
% 11. BODE PLOT - ALL CONTROLLERS
% =============================================================

fprintf('\nGenerating Bode plot...\n');

figure('Name', 'Bode Comparison P PI PID');

bode(L_P, L_PI, L_PID);

grid on;

legend('P Controller', ...
       'PI Controller', ...
       'PID Controller', ...
       'Location', 'best');

title('Open-Loop Bode Diagram - P, PI and PID Controllers');

saveas(gcf, fullfile( ...
    frequency_figures_folder, ...
    'Bode_Comparison_P_PI_PID.png'));


%% ============================================================
% 12. BODE PLOT WITH MARGINS
% =============================================================

fprintf('Generating stability margin plots...\n');


% P Controller

figure('Name', 'Bode Margins P Controller');

margin(L_P);

grid on;

title('Bode Diagram with Stability Margins - P Controller');

saveas(gcf, fullfile( ...
    frequency_figures_folder, ...
    'Bode_Margins_P.png'));


% PI Controller

figure('Name', 'Bode Margins PI Controller');

margin(L_PI);

grid on;

title('Bode Diagram with Stability Margins - PI Controller');

saveas(gcf, fullfile( ...
    frequency_figures_folder, ...
    'Bode_Margins_PI.png'));


% PID Controller

figure('Name', 'Bode Margins PID Controller');

margin(L_PID);

grid on;

title('Bode Diagram with Stability Margins - PID Controller');

saveas(gcf, fullfile( ...
    frequency_figures_folder, ...
    'Bode_Margins_PID.png'));


%% ============================================================
% 13. NYQUIST PLOT
% =============================================================

fprintf('Generating Nyquist plot...\n');


figure('Name', 'Nyquist Comparison P PI PID');

nyquist(L_P, L_PI, L_PID);

grid on;

legend('P Controller', ...
       'PI Controller', ...
       'PID Controller', ...
       'Location', 'best');

title('Nyquist Diagram - P, PI and PID Controllers');

saveas(gcf, fullfile( ...
    frequency_figures_folder, ...
    'Nyquist_Comparison_P_PI_PID.png'));


%% ============================================================
% 14. CLOSED-LOOP BODE COMPARISON
% =============================================================

fprintf('Generating closed-loop Bode plot...\n');


figure('Name', 'Closed Loop Bode Comparison');

bode(T_P, T_PI, T_PID);

grid on;

legend('P Closed Loop', ...
       'PI Closed Loop', ...
       'PID Closed Loop', ...
       'Location', 'best');

title('Closed-Loop Bode Diagram - P, PI and PID');

saveas(gcf, fullfile( ...
    frequency_figures_folder, ...
    'Bode_ClosedLoop_Comparison.png'));


%% ============================================================
% 15. CREATE PERFORMANCE RESULTS TABLE
% =============================================================

Controller = {'P'; 'PI'; 'PID'};

Kp = [Kp_P; Kp_PI; Kp_PID];

Ki = [Ki_P; Ki_PI; Ki_PID];

Kd = [Kd_P; Kd_PI; Kd_PID];


GainMargin_dB = [
    20*log10(GM_P);
    20*log10(GM_PI);
    20*log10(GM_PID)
];


PhaseMargin_deg = [
    PM_P;
    PM_PI;
    PM_PID
];


GainCrossover_rad_s = [
    Wcp_P;
    Wcp_PI;
    Wcp_PID
];


PhaseCrossover_rad_s = [
    Wcg_P;
    Wcg_PI;
    Wcg_PID
];


frequency_results = table( ...
    Controller, ...
    Kp, ...
    Ki, ...
    Kd, ...
    GainMargin_dB, ...
    PhaseMargin_deg, ...
    GainCrossover_rad_s, ...
    PhaseCrossover_rad_s);


%% ============================================================
% 16. DISPLAY RESULTS TABLE
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('FINAL FREQUENCY-DOMAIN RESULTS\n');
fprintf('============================================================\n');

disp(frequency_results);


%% ============================================================
% 17. SAVE RESULTS
% =============================================================

results_file = fullfile( ...
    results_folder, ...
    'frequency_analysis_results.mat');

save(results_file, ...
    'frequency_results', ...
    'G_motor', ...
    'C_P', ...
    'C_PI', ...
    'C_PID', ...
    'L_P', ...
    'L_PI', ...
    'L_PID', ...
    'T_P', ...
    'T_PI', ...
    'T_PID');


%% ============================================================
% 18. EXPORT RESULTS TO CSV
% =============================================================

csv_file = fullfile( ...
    results_folder, ...
    'frequency_analysis_results.csv');

writetable(frequency_results, csv_file);


%% ============================================================
% 19. FINAL MESSAGE
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('FREQUENCY ANALYSIS COMPLETED SUCCESSFULLY\n');
fprintf('============================================================\n');

fprintf('\nGenerated figures:\n');

fprintf('1. Bode_Comparison_P_PI_PID.png\n');
fprintf('2. Bode_Margins_P.png\n');
fprintf('3. Bode_Margins_PI.png\n');
fprintf('4. Bode_Margins_PID.png\n');
fprintf('5. Nyquist_Comparison_P_PI_PID.png\n');
fprintf('6. Bode_ClosedLoop_Comparison.png\n');

fprintf('\nGenerated result files:\n');

fprintf('1. frequency_analysis_results.mat\n');
fprintf('2. frequency_analysis_results.csv\n');

fprintf('\nAll files have been saved successfully.\n');
fprintf('============================================================\n');