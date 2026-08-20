%% ============================================================
%  STABILITY ANALYSIS OF DC MOTOR CONTROL
%  P / PI / PID CLOSED-LOOP SYSTEMS
%
%  Author: Imane
%  Project: DC Motor PID Control
%
%  This script:
%  1. Loads project parameters
%  2. Builds the DC motor transfer function
%  3. Creates P, PI and PID controllers
%  4. Creates closed-loop systems
%  5. Calculates poles and zeros
%  6. Checks closed-loop stability
%  7. Identifies dominant poles
%  8. Generates pole-zero maps
%  9. Generates pole comparison plot
% 10. Saves numerical results
%
%  Figures are saved in:
%  Figures/analysis/
%
%  Results are saved in:
%  Results/
%
% =============================================================

clear;
clc;
close all;

disp(' ');
disp('============================================================');
disp('          STABILITY ANALYSIS OF DC MOTOR CONTROL');
disp('============================================================');
disp(' ');


%% ============================================================
% 1. INITIALIZE PROJECT PATHS
% =============================================================

disp('Initializing project paths...');

% Get current script directory
script_dir = fileparts(mfilename('fullpath'));

% Project root directory
project_root = fileparts(script_dir);

% Define important directories
results_dir = fullfile(project_root, 'Results');
figures_dir = fullfile(project_root, 'Figures');

% Create analysis folder inside Figures
figures_analysis_dir = fullfile(figures_dir, 'analysis');

% Create directories if they do not exist
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

if ~exist(figures_dir, 'dir')
    mkdir(figures_dir);
end

if ~exist(figures_analysis_dir, 'dir')
    mkdir(figures_analysis_dir);
end

disp('Project paths initialized successfully.');
disp(' ');


%% ============================================================
% 2. LOAD PROJECT PARAMETERS
% =============================================================

disp('------------------------------------------------------------');
disp('LOADING PROJECT PARAMETERS');
disp('------------------------------------------------------------');

% Expected location of params.mat
params_file = fullfile(project_root, 'Matlab', 'params.mat');

% If params.mat is not found there, search in project folder
if ~exist(params_file, 'file')

    alternative_params = fullfile(project_root, 'params.mat');

    if exist(alternative_params, 'file')
        params_file = alternative_params;
    else
        error(['params.mat not found. Please run parameters.m ', ...
               'before running stability_analysis.m']);
    end

end

% Load parameters
load(params_file);

disp('Parameters loaded from params.mat successfully.');
disp(' ');


%% ============================================================
% 3. DISPLAY DC MOTOR PARAMETERS
% =============================================================

disp('------------------------------------------------------------');
disp('DC MOTOR PARAMETERS');
disp('------------------------------------------------------------');

fprintf('R = %.4f Ohm\n', R);
fprintf('L = %.4f H\n', L);
fprintf('J = %.4f kg.m^2\n', J);
fprintf('B = %.4f N.m.s/rad\n', B);
fprintf('K = %.4f\n', K);

disp(' ');


%% ============================================================
% 4. CREATE DC MOTOR TRANSFER FUNCTION
% =============================================================

disp('------------------------------------------------------------');
disp('DC MOTOR TRANSFER FUNCTION');
disp('------------------------------------------------------------');

% Laplace variable
s = tf('s');

% DC motor transfer function
%
%        K
% G(s) = -------------------------------
%        L*J*s^2 + (L*B + R*J)*s
%        + (R*B + K^2)

G_motor = K / ...
    (L*J*s^2 + (L*B + R*J)*s + (R*B + K^2));

disp(' ');
disp('G_motor = ');
G_motor

disp(' ');


%% ============================================================
% 5. DEFINE CONTROLLER GAINS
% =============================================================

disp('------------------------------------------------------------');
disp('CREATING CONTROLLERS');
disp('------------------------------------------------------------');

% P controller gains
Kp_P = 5;
Ki_P = 0;
Kd_P = 0;

% PI controller gains
Kp_PI = 3;
Ki_PI = 15;
Kd_PI = 0;

% PID controller gains
Kp_PID = 4;
Ki_PID = 20;
Kd_PID = 0.05;


%% ============================================================
% 6. CREATE P / PI / PID CONTROLLERS
% =============================================================

% P controller
C_P = pid(Kp_P, Ki_P, Kd_P);

% PI controller
C_PI = pid(Kp_PI, Ki_PI, Kd_PI);

% PID controller
C_PID = pid(Kp_PID, Ki_PID, Kd_PID);

disp('P controller created.');
disp('PI controller created.');
disp('PID controller created.');

disp(' ');


%% ============================================================
% 7. CREATE OPEN-LOOP SYSTEMS
% =============================================================

% Open-loop transfer functions
L_P = C_P * G_motor;
L_PI = C_PI * G_motor;
L_PID = C_PID * G_motor;


%% ============================================================
% 8. CREATE CLOSED-LOOP SYSTEMS
% =============================================================

disp('------------------------------------------------------------');
disp('CREATING CLOSED-LOOP SYSTEMS');
disp('------------------------------------------------------------');

% Unity feedback
T_P = feedback(L_P, 1);
T_PI = feedback(L_PI, 1);
T_PID = feedback(L_PID, 1);

disp('Closed-loop systems created successfully.');
disp(' ');


%% ============================================================
% 9. CALCULATE POLES AND ZEROS
% =============================================================

disp('------------------------------------------------------------');
disp('POLES AND ZEROS CALCULATION');
disp('------------------------------------------------------------');

% P
poles_P = pole(T_P);
zeros_P = zero(T_P);

% PI
poles_PI = pole(T_PI);
zeros_PI = zero(T_PI);

% PID
poles_PID = pole(T_PID);
zeros_PID = zero(T_PID);


%% ============================================================
% 10. DISPLAY CLOSED-LOOP POLES
% =============================================================

disp(' ');
disp('============================================================');
disp('                    CLOSED-LOOP POLES');
disp('============================================================');

disp(' ');
disp('P CONTROLLER POLES:');
disp(poles_P);

disp(' ');
disp('PI CONTROLLER POLES:');
disp(poles_PI);

disp(' ');
disp('PID CONTROLLER POLES:');
disp(poles_PID);


%% ============================================================
% 11. DISPLAY CLOSED-LOOP ZEROS
% =============================================================

disp(' ');
disp('============================================================');
disp('                    CLOSED-LOOP ZEROS');
disp('============================================================');

disp(' ');
disp('P CONTROLLER ZEROS:');

if isempty(zeros_P)
    disp('No finite zeros.');
else
    disp(zeros_P);
end


disp(' ');
disp('PI CONTROLLER ZEROS:');

if isempty(zeros_PI)
    disp('No finite zeros.');
else
    disp(zeros_PI);
end


disp(' ');
disp('PID CONTROLLER ZEROS:');

if isempty(zeros_PID)
    disp('No finite zeros.');
else
    disp(zeros_PID);
end


%% ============================================================
% 12. STABILITY ANALYSIS
% =============================================================

disp(' ');
disp('============================================================');
disp('                    STABILITY ANALYSIS');
disp('============================================================');


% P stability
stable_P = isstable(T_P);

disp(' ');
disp('------------------------------------------------------------');
disp('P CONTROLLER');
disp('------------------------------------------------------------');

if stable_P
    stability_P = 'Stable';
    disp('Stability status: STABLE');
else
    stability_P = 'Unstable';
    disp('Stability status: UNSTABLE');
end


% PI stability
stable_PI = isstable(T_PI);

disp(' ');
disp('------------------------------------------------------------');
disp('PI CONTROLLER');
disp('------------------------------------------------------------');

if stable_PI
    stability_PI = 'Stable';
    disp('Stability status: STABLE');
else
    stability_PI = 'Unstable';
    disp('Stability status: UNSTABLE');
end


% PID stability
stable_PID = isstable(T_PID);

disp(' ');
disp('------------------------------------------------------------');
disp('PID CONTROLLER');
disp('------------------------------------------------------------');

if stable_PID
    stability_PID = 'Stable';
    disp('Stability status: STABLE');
else
    stability_PID = 'Unstable';
    disp('Stability status: UNSTABLE');
end


%% ============================================================
% 13. DETERMINE DOMINANT POLES
% =============================================================

% The dominant pole is the pole with the largest real part.
% For a stable system, it is the pole closest to the imaginary axis.

[~, index_P] = max(real(poles_P));
dominant_pole_P = poles_P(index_P);


[~, index_PI] = max(real(poles_PI));
dominant_pole_PI = poles_PI(index_PI);


[~, index_PID] = max(real(poles_PID));
dominant_pole_PID = poles_PID(index_PID);


%% ============================================================
% 14. DISPLAY DOMINANT POLES
% =============================================================

disp(' ');
disp('============================================================');
disp('                    DOMINANT POLES');
disp('============================================================');

disp(' ');
disp('P controller dominant pole:');
disp(dominant_pole_P);

disp(' ');
disp('PI controller dominant pole:');
disp(dominant_pole_PI);

disp(' ');
disp('PID controller dominant pole:');
disp(dominant_pole_PID);


%% ============================================================
% 15. GENERATE P POLE-ZERO MAP
% =============================================================

disp(' ');
disp('Generating P controller pole-zero map...');

figure('Name', 'Pole-Zero Map - P Controller', ...
       'NumberTitle', 'off', ...
       'Color', 'w');

hold on;

% Plot poles
plot(real(poles_P), imag(poles_P), ...
     'x', ...
     'MarkerSize', 12, ...
     'LineWidth', 2);

% Plot zeros if available
if ~isempty(zeros_P)

    plot(real(zeros_P), imag(zeros_P), ...
         'o', ...
         'MarkerSize', 10, ...
         'LineWidth', 2);

end

% Imaginary axis
xline(0, '--', 'LineWidth', 1.2);

% Real axis
yline(0, '--', 'LineWidth', 1.2);

grid on;
box on;

xlabel('Real Axis (s^{-1})');
ylabel('Imaginary Axis (s^{-1})');

title('Pole-Zero Map - P Controller');

if ~isempty(zeros_P)

    legend('Poles', ...
           'Zeros', ...
           'Imaginary Axis', ...
           'Real Axis', ...
           'Location', 'best');

else

    legend('Poles', ...
           'Imaginary Axis', ...
           'Real Axis', ...
           'Location', 'best');

end

% Calculate axis limits
all_P = [poles_P(:); zeros_P(:)];

x_min_P = min(real(all_P));
x_max_P = max(real(all_P));

y_min_P = min(imag(all_P));
y_max_P = max(imag(all_P));

% Ensure non-zero range
if x_max_P == x_min_P
    x_min_P = x_min_P - 1;
    x_max_P = x_max_P + 1;
end

if y_max_P == y_min_P
    y_min_P = y_min_P - 1;
    y_max_P = y_max_P + 1;
end

% Add margins
x_margin_P = 0.2 * (x_max_P - x_min_P);
y_margin_P = 0.2 * (y_max_P - y_min_P);

xlim([x_min_P - x_margin_P, ...
      max(1, x_max_P + x_margin_P)]);

ylim([y_min_P - y_margin_P, ...
      y_max_P + y_margin_P]);

% Save figure
saveas(gcf, ...
       fullfile(figures_analysis_dir, ...
       'PoleZeroMap_P.png'));

close(gcf);


%% ============================================================
% 16. GENERATE PI POLE-ZERO MAP
% =============================================================

disp('Generating PI controller pole-zero map...');

figure('Name', 'Pole-Zero Map - PI Controller', ...
       'NumberTitle', 'off', ...
       'Color', 'w');

hold on;

% Plot poles
plot(real(poles_PI), imag(poles_PI), ...
     'x', ...
     'MarkerSize', 12, ...
     'LineWidth', 2);

% Plot zeros
if ~isempty(zeros_PI)

    plot(real(zeros_PI), imag(zeros_PI), ...
         'o', ...
         'MarkerSize', 10, ...
         'LineWidth', 2);

end

% Imaginary axis
xline(0, '--', 'LineWidth', 1.2);

% Real axis
yline(0, '--', 'LineWidth', 1.2);

grid on;
box on;

xlabel('Real Axis (s^{-1})');
ylabel('Imaginary Axis (s^{-1})');

title('Pole-Zero Map - PI Controller');

if ~isempty(zeros_PI)

    legend('Poles', ...
           'Zeros', ...
           'Imaginary Axis', ...
           'Real Axis', ...
           'Location', 'best');

else

    legend('Poles', ...
           'Imaginary Axis', ...
           'Real Axis', ...
           'Location', 'best');

end

% Calculate axis limits
all_PI = [poles_PI(:); zeros_PI(:)];

x_min_PI = min(real(all_PI));
x_max_PI = max(real(all_PI));

y_min_PI = min(imag(all_PI));
y_max_PI = max(imag(all_PI));

% Ensure non-zero range
if x_max_PI == x_min_PI
    x_min_PI = x_min_PI - 1;
    x_max_PI = x_max_PI + 1;
end

if y_max_PI == y_min_PI
    y_min_PI = y_min_PI - 1;
    y_max_PI = y_max_PI + 1;
end

% Add margins
x_margin_PI = 0.2 * (x_max_PI - x_min_PI);
y_margin_PI = 0.2 * (y_max_PI - y_min_PI);

xlim([x_min_PI - x_margin_PI, ...
      max(1, x_max_PI + x_margin_PI)]);

ylim([y_min_PI - y_margin_PI, ...
      y_max_PI + y_margin_PI]);

% Save
saveas(gcf, ...
       fullfile(figures_analysis_dir, ...
       'PoleZeroMap_PI.png'));

close(gcf);


%% ============================================================
% 17. GENERATE PID POLE-ZERO MAP
% =============================================================

disp('Generating PID controller pole-zero map...');

figure('Name', 'Pole-Zero Map - PID Controller', ...
       'NumberTitle', 'off', ...
       'Color', 'w');

hold on;

% Plot poles
plot(real(poles_PID), imag(poles_PID), ...
     'x', ...
     'MarkerSize', 12, ...
     'LineWidth', 2);

% Plot zeros
if ~isempty(zeros_PID)

    plot(real(zeros_PID), imag(zeros_PID), ...
         'o', ...
         'MarkerSize', 10, ...
         'LineWidth', 2);

end

% Imaginary axis
xline(0, '--', 'LineWidth', 1.2);

% Real axis
yline(0, '--', 'LineWidth', 1.2);

grid on;
box on;

xlabel('Real Axis (s^{-1})');
ylabel('Imaginary Axis (s^{-1})');

title('Pole-Zero Map - PID Controller');

if ~isempty(zeros_PID)

    legend('Poles', ...
           'Zeros', ...
           'Imaginary Axis', ...
           'Real Axis', ...
           'Location', 'best');

else

    legend('Poles', ...
           'Imaginary Axis', ...
           'Real Axis', ...
           'Location', 'best');

end

% Calculate axis limits
all_PID = [poles_PID(:); zeros_PID(:)];

x_min_PID = min(real(all_PID));
x_max_PID = max(real(all_PID));

y_min_PID = min(imag(all_PID));
y_max_PID = max(imag(all_PID));

% Ensure non-zero range
if x_max_PID == x_min_PID
    x_min_PID = x_min_PID - 1;
    x_max_PID = x_max_PID + 1;
end

if y_max_PID == y_min_PID
    y_min_PID = y_min_PID - 1;
    y_max_PID = y_max_PID + 1;
end

% Add margins
x_margin_PID = 0.2 * (x_max_PID - x_min_PID);
y_margin_PID = 0.2 * (y_max_PID - y_min_PID);

xlim([x_min_PID - x_margin_PID, ...
      max(1, x_max_PID + x_margin_PID)]);

ylim([y_min_PID - y_margin_PID, ...
      y_max_PID + y_margin_PID]);

% Save
saveas(gcf, ...
       fullfile(figures_analysis_dir, ...
       'PoleZeroMap_PID.png'));

close(gcf);


%% ============================================================
% 18. GENERATE POLE COMPARISON P / PI / PID
% =============================================================

disp('Generating pole comparison plot...');

figure('Name', 'Closed-Loop Pole Comparison', ...
       'NumberTitle', 'off', ...
       'Color', 'w');

hold on;

% Plot P poles
plot(real(poles_P), ...
     imag(poles_P), ...
     'x', ...
     'MarkerSize', 12, ...
     'LineWidth', 2);

% Plot PI poles
plot(real(poles_PI), ...
     imag(poles_PI), ...
     'o', ...
     'MarkerSize', 10, ...
     'LineWidth', 2);

% Plot PID poles
plot(real(poles_PID), ...
     imag(poles_PID), ...
     '+', ...
     'MarkerSize', 12, ...
     'LineWidth', 2);

% Imaginary axis
xline(0, '--', 'LineWidth', 1.2);

% Real axis
yline(0, '--', 'LineWidth', 1.2);

grid on;
box on;

xlabel('Real Axis (s^{-1})');
ylabel('Imaginary Axis (s^{-1})');

title('Closed-Loop Pole Comparison');

legend('P Controller', ...
       'PI Controller', ...
       'PID Controller', ...
       'Imaginary Axis', ...
       'Real Axis', ...
       'Location', 'best');

% Combine all poles
all_poles = [poles_P(:); ...
             poles_PI(:); ...
             poles_PID(:)];

% Calculate axis limits
x_min_all = min(real(all_poles));
x_max_all = max(real(all_poles));

y_min_all = min(imag(all_poles));
y_max_all = max(imag(all_poles));

% Ensure non-zero range
if x_max_all == x_min_all
    x_min_all = x_min_all - 1;
    x_max_all = x_max_all + 1;
end

if y_max_all == y_min_all
    y_min_all = y_min_all - 1;
    y_max_all = y_max_all + 1;
end

% Add margins
x_margin_all = 0.2 * ...
    (x_max_all - x_min_all);

y_margin_all = 0.2 * ...
    (y_max_all - y_min_all);

xlim([x_min_all - x_margin_all, ...
      max(1, x_max_all + x_margin_all)]);

ylim([y_min_all - y_margin_all, ...
      y_max_all + y_margin_all]);

% Save figure
saveas(gcf, ...
       fullfile(figures_analysis_dir, ...
       'Poles_Comparison_P_PI_PID.png'));

close(gcf);


%% ============================================================
% 19. CREATE NUMERICAL RESULTS TABLE
% =============================================================

disp(' ');
disp('Creating stability results table...');

% Number of poles
NumberOfPoles = [
    length(poles_P);
    length(poles_PI);
    length(poles_PID)
];

% Maximum real pole
MaxRealPole = [
    max(real(poles_P));
    max(real(poles_PI));
    max(real(poles_PID))
];

% Dominant pole real part
DominantPoleReal = [
    real(dominant_pole_P);
    real(dominant_pole_PI);
    real(dominant_pole_PID)
];

% Dominant pole imaginary part
DominantPoleImag = [
    imag(dominant_pole_P);
    imag(dominant_pole_PI);
    imag(dominant_pole_PID)
];

% Controller names
Controller = {
    'P';
    'PI';
    'PID'
};

% Gains
Kp_values = [
    Kp_P;
    Kp_PI;
    Kp_PID
];

Ki_values = [
    Ki_P;
    Ki_PI;
    Ki_PID
];

Kd_values = [
    Kd_P;
    Kd_PI;
    Kd_PID
];

% Stability status
Stability = {
    stability_P;
    stability_PI;
    stability_PID
};


%% ============================================================
% 20. CREATE RESULTS TABLE
% =============================================================

stability_results = table( ...
    Controller, ...
    Kp_values, ...
    Ki_values, ...
    Kd_values, ...
    NumberOfPoles, ...
    MaxRealPole, ...
    DominantPoleReal, ...
    DominantPoleImag, ...
    Stability);


%% ============================================================
% 21. DISPLAY FINAL RESULTS
% =============================================================

disp(' ');
disp('============================================================');
disp('              FINAL STABILITY RESULTS');
disp('============================================================');

disp(stability_results);


%% ============================================================
% 22. SAVE MAT RESULTS
% =============================================================

disp(' ');
disp('Saving MAT results...');

stability_results_file = ...
    fullfile(results_dir, ...
    'stability_analysis_results.mat');

save(stability_results_file, ...
    'G_motor', ...
    'C_P', ...
    'C_PI', ...
    'C_PID', ...
    'L_P', ...
    'L_PI', ...
    'L_PID', ...
    'T_P', ...
    'T_PI', ...
    'T_PID', ...
    'poles_P', ...
    'poles_PI', ...
    'poles_PID', ...
    'zeros_P', ...
    'zeros_PI', ...
    'zeros_PID', ...
    'dominant_pole_P', ...
    'dominant_pole_PI', ...
    'dominant_pole_PID', ...
    'stability_results');


%% ============================================================
% 23. SAVE CSV RESULTS
% =============================================================

disp('Saving CSV results...');

stability_csv_file = ...
    fullfile(results_dir, ...
    'stability_analysis_results.csv');

writetable(stability_results, ...
           stability_csv_file);


%% ============================================================
% 24. FINAL MESSAGE
% =============================================================

disp(' ');
disp('============================================================');
disp('      STABILITY ANALYSIS COMPLETED SUCCESSFULLY');
disp('============================================================');

disp(' ');
disp('Generated figures:');

fprintf('1. %s\n', ...
    fullfile('Figures', ...
    'analysis', ...
    'PoleZeroMap_P.png'));

fprintf('2. %s\n', ...
    fullfile('Figures', ...
    'analysis', ...
    'PoleZeroMap_PI.png'));

fprintf('3. %s\n', ...
    fullfile('Figures', ...
    'analysis', ...
    'PoleZeroMap_PID.png'));

fprintf('4. %s\n', ...
    fullfile('Figures', ...
    'analysis', ...
    'Poles_Comparison_P_PI_PID.png'));

disp(' ');

disp('Generated result files:');

fprintf('1. %s\n', ...
    fullfile('Results', ...
    'stability_analysis_results.mat'));

fprintf('2. %s\n', ...
    fullfile('Results', ...
    'stability_analysis_results.csv'));

disp(' ');

disp('All stability analysis files have been saved successfully.');

disp('============================================================');
disp(' ');