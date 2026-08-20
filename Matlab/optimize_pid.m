%% ============================================================
%  optimize_pid.m
%
%  AUTOMATIC PID OPTIMIZATION OF DC MOTOR
%
%  This script compares:
%       1. Manual PID tuning
%       2. PID Tuner
%       3. Automatically optimized PID
%
%  The optimization minimizes a weighted cost function based on:
%       - Rise Time
%       - Settling Time
%       - Overshoot
%       - Steady-State Error
%
%  Figures are saved in:
%       Figures/tuning/
%
%  Results are saved in:
%       Results/
%
% ============================================================

clear;
clc;
close all;

fprintf('\n');
fprintf('============================================================\n');
fprintf('       AUTOMATIC PID OPTIMIZATION OF DC MOTOR\n');
fprintf('============================================================\n\n');


%% ============================================================
%  1. INITIALIZE PROJECT PATHS
% =============================================================

fprintf('Initializing project paths...\n');

% Current script directory
scriptFolder = fileparts(mfilename('fullpath'));

% Project root
projectRoot = fileparts(scriptFolder);

% If the script is directly inside the project root
if isempty(projectRoot) || strcmp(projectRoot, scriptFolder)
    projectRoot = scriptFolder;
end

% Matlab folder
matlabFolder = fullfile(projectRoot, 'Matlab');

% Results folder
resultsFolder = fullfile(projectRoot, 'Results');

% Figures folder
figuresFolder = fullfile(projectRoot, 'Figures');

% New folder dedicated to tuning results
tuningFiguresFolder = fullfile(figuresFolder, 'tuning');

% Create folders if they do not exist
if ~exist(resultsFolder, 'dir')
    mkdir(resultsFolder);
end

if ~exist(figuresFolder, 'dir')
    mkdir(figuresFolder);
end

if ~exist(tuningFiguresFolder, 'dir')
    mkdir(tuningFiguresFolder);
end

fprintf('Project paths initialized successfully.\n');


%% ============================================================
%  2. LOAD PROJECT PARAMETERS
% =============================================================

fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('LOADING PROJECT PARAMETERS\n');
fprintf('------------------------------------------------------------\n');

paramsFile = fullfile(matlabFolder, 'params.mat');

if ~exist(paramsFile, 'file')

    % Try alternative location
    paramsFile = fullfile(projectRoot, 'params.mat');

end

if ~exist(paramsFile, 'file')

    error(['params.mat was not found. ', ...
           'Please run parameters.m before executing optimize_pid.m.']);

end

load(paramsFile);

fprintf('Parameters loaded from params.mat successfully.\n');


%% ============================================================
%  3. CHECK REQUIRED PARAMETERS
% =============================================================

requiredParameters = {'R','L','J','B','K'};

for i = 1:length(requiredParameters)

    if ~exist(requiredParameters{i}, 'var')

        error(['Required parameter ', ...
               requiredParameters{i}, ...
               ' is missing from params.mat.']);

    end

end

fprintf('All required motor parameters are available.\n');


%% ============================================================
%  4. DISPLAY MOTOR PARAMETERS
% =============================================================

fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('DC MOTOR PARAMETERS\n');
fprintf('------------------------------------------------------------\n');

fprintf('R = %.4f Ohm\n', R);
fprintf('L = %.4f H\n', L);
fprintf('J = %.4f kg.m^2\n', J);
fprintf('B = %.4f N.m.s/rad\n', B);
fprintf('K = %.4f\n', K);


%% ============================================================
%  5. CREATE DC MOTOR TRANSFER FUNCTION
% =============================================================

fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('CREATING DC MOTOR TRANSFER FUNCTION\n');
fprintf('------------------------------------------------------------\n');

s = tf('s');

G_motor = K / ...
    (L*J*s^2 + (L*B + R*J)*s + (R*B + K^2));

disp(G_motor);


%% ============================================================
%  6. REFERENCE VALUE
% =============================================================

% Normalized reference
Reference = 1;

fprintf('\nReference value = %.2f\n', Reference);


%% ============================================================
%  7. MANUAL PID PARAMETERS
% =============================================================

fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('PID CONTROLLER PARAMETERS\n');
fprintf('------------------------------------------------------------\n');

% Manual tuning
Kp_manual = 10;
Ki_manual = 10;
Kd_manual = 0.1;

% PID Tuner
Kp_tuner = 21.23;
Ki_tuner = 36.03;
Kd_tuner = 1.815;

fprintf('\nManual PID:\n');
fprintf('Kp = %.4f\n', Kp_manual);
fprintf('Ki = %.4f\n', Ki_manual);
fprintf('Kd = %.4f\n', Kd_manual);

fprintf('\nPID Tuner:\n');
fprintf('Kp = %.4f\n', Kp_tuner);
fprintf('Ki = %.4f\n', Ki_tuner);
fprintf('Kd = %.4f\n', Kd_tuner);


%% ============================================================
%  8. CREATE MANUAL AND PID TUNER CONTROLLERS
% =============================================================

C_manual = pid(Kp_manual, Ki_manual, Kd_manual);

C_tuner = pid(Kp_tuner, Ki_tuner, Kd_tuner);

fprintf('\nManual and PID Tuner controllers created successfully.\n');


%% ============================================================
%  9. COST FUNCTION WEIGHTS
% =============================================================

fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('AUTOMATIC PID OPTIMIZATION\n');
fprintf('------------------------------------------------------------\n');

% Cost function weights
w1 = 1.0;      % Rise Time
w2 = 1.0;      % Settling Time
w3 = 0.5;      % Overshoot
w4 = 10.0;     % Steady-State Error

fprintf('\nCost function weights:\n');
fprintf('w1 (Rise Time)          = %.2f\n', w1);
fprintf('w2 (Settling Time)      = %.2f\n', w2);
fprintf('w3 (Overshoot)          = %.2f\n', w3);
fprintf('w4 (Steady-State Error) = %.2f\n', w4);


%% ============================================================
%  10. INITIAL GUESS
% =============================================================

x0 = [Kp_manual, Ki_manual, Kd_manual];

fprintf('\nInitial guess:\n');
fprintf('Kp = %.4f\n', x0(1));
fprintf('Ki = %.4f\n', x0(2));
fprintf('Kd = %.4f\n', x0(3));


%% ============================================================
%  11. OPTIMIZATION BOUNDS
% =============================================================

Kp_min = 0.01;
Kp_max = 100;

Ki_min = 0.01;
Ki_max = 200;

Kd_min = 0.001;
Kd_max = 20;

fprintf('\nOptimization bounds:\n');
fprintf('Kp : %.3f --> %.3f\n', Kp_min, Kp_max);
fprintf('Ki : %.3f --> %.3f\n', Ki_min, Ki_max);
fprintf('Kd : %.3f --> %.3f\n', Kd_min, Kd_max);


%% ============================================================
%  12. DEFINE COST FUNCTION
% =============================================================

costFunction = @(x) pidCostFunction( ...
    x, ...
    G_motor, ...
    Reference, ...
    w1, ...
    w2, ...
    w3, ...
    w4, ...
    Kp_min, Kp_max, ...
    Ki_min, Ki_max, ...
    Kd_min, Kd_max);


%% ============================================================
%  13. OPTIMIZATION OPTIONS
% =============================================================

options = optimset( ...
    'Display', 'iter', ...
    'MaxIter', 1000, ...
    'MaxFunEvals', 3000, ...
    'TolX', 1e-6, ...
    'TolFun', 1e-6);


%% ============================================================
%  14. START OPTIMIZATION
% =============================================================

fprintf('\nStarting automatic PID optimization...\n');
fprintf('Please wait...\n\n');

tic;

[x_opt, J_opt, exitflag, output] = ...
    fminsearch(costFunction, x0, options);

optimizationTime = toc;


%% ============================================================
%  15. APPLY FINAL BOUNDS
% =============================================================

Kp_opt = min(max(x_opt(1), Kp_min), Kp_max);
Ki_opt = min(max(x_opt(2), Ki_min), Ki_max);
Kd_opt = min(max(x_opt(3), Kd_min), Kd_max);

% Recalculate final cost
J_opt = costFunction([Kp_opt Ki_opt Kd_opt]);


%% ============================================================
%  16. DISPLAY OPTIMIZATION RESULTS
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('           OPTIMIZATION COMPLETED\n');
fprintf('============================================================\n');

fprintf('\nOptimization exit flag = %d\n', exitflag);
fprintf('Number of iterations = %d\n', output.iterations);
fprintf('Function evaluations = %d\n', output.funcCount);
fprintf('Optimization time = %.4f seconds\n', optimizationTime);

fprintf('\nOptimized PID parameters:\n');

fprintf('Kp = %.6f\n', Kp_opt);
fprintf('Ki = %.6f\n', Ki_opt);
fprintf('Kd = %.6f\n', Kd_opt);

fprintf('\nOptimized cost function value:\n');
fprintf('J = %.6f\n', J_opt);


%% ============================================================
%  17. CREATE OPTIMIZED PID CONTROLLER
% =============================================================

C_opt = pid(Kp_opt, Ki_opt, Kd_opt);

fprintf('\nOptimized PID controller created successfully.\n');


%% ============================================================
%  18. CREATE CLOSED-LOOP SYSTEMS
% =============================================================

T_manual = feedback(C_manual * G_motor, 1);

T_tuner = feedback(C_tuner * G_motor, 1);

T_opt = feedback(C_opt * G_motor, 1);


%% ============================================================
%  19. SIMULATION SETTINGS
% =============================================================

t = 0:0.001:10;


%% ============================================================
%  20. SIMULATE ALL CONTROLLERS
% =============================================================

fprintf('\nSimulating controllers...\n');

[y_manual, t_manual] = step(Reference*T_manual, t);

[y_tuner, t_tuner] = step(Reference*T_tuner, t);

[y_opt, t_opt] = step(Reference*T_opt, t);


%% ============================================================
%  21. PERFORMANCE ANALYSIS
% =============================================================

info_manual = stepinfo(y_manual, t_manual, Reference);

info_tuner = stepinfo(y_tuner, t_tuner, Reference);

info_opt = stepinfo(y_opt, t_opt, Reference);


%% ============================================================
%  22. STEADY-STATE ERROR
% =============================================================

ss_manual = abs(Reference - y_manual(end));

ss_tuner = abs(Reference - y_tuner(end));

ss_opt = abs(Reference - y_opt(end));


%% ============================================================
%  23. DISPLAY PERFORMANCE COMPARISON
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('             PERFORMANCE COMPARISON\n');
fprintf('============================================================\n');

fprintf('\n');

fprintf('%-18s %-12s %-14s %-12s %-15s\n', ...
    'Method', ...
    'RiseTime', ...
    'SettlingTime', ...
    'Overshoot', ...
    'SS Error');

fprintf('%-18s %-12.4f %-14.4f %-12.4f %-15.6f\n', ...
    'Manual', ...
    info_manual.RiseTime, ...
    info_manual.SettlingTime, ...
    info_manual.Overshoot, ...
    ss_manual);

fprintf('%-18s %-12.4f %-14.4f %-12.4f %-15.6f\n', ...
    'PID Tuner', ...
    info_tuner.RiseTime, ...
    info_tuner.SettlingTime, ...
    info_tuner.Overshoot, ...
    ss_tuner);

fprintf('%-18s %-12.4f %-14.4f %-12.4f %-15.6f\n', ...
    'Optimized', ...
    info_opt.RiseTime, ...
    info_opt.SettlingTime, ...
    info_opt.Overshoot, ...
    ss_opt);


%% ============================================================
%  24. CREATE RESULTS TABLE
% =============================================================

Controller = {
    'Manual PID'
    'PID Tuner'
    'Optimized PID'
    };

Kp_values = [
    Kp_manual
    Kp_tuner
    Kp_opt
    ];

Ki_values = [
    Ki_manual
    Ki_tuner
    Ki_opt
    ];

Kd_values = [
    Kd_manual
    Kd_tuner
    Kd_opt
    ];

RiseTime = [
    info_manual.RiseTime
    info_tuner.RiseTime
    info_opt.RiseTime
    ];

SettlingTime = [
    info_manual.SettlingTime
    info_tuner.SettlingTime
    info_opt.SettlingTime
    ];

Overshoot = [
    info_manual.Overshoot
    info_tuner.Overshoot
    info_opt.Overshoot
    ];

SteadyStateError = [
    ss_manual
    ss_tuner
    ss_opt
    ];

CostFunction = [
    costFunction([Kp_manual Ki_manual Kd_manual])
    costFunction([Kp_tuner Ki_tuner Kd_tuner])
    J_opt
    ];


resultsTable = table( ...
    Controller, ...
    Kp_values, ...
    Ki_values, ...
    Kd_values, ...
    RiseTime, ...
    SettlingTime, ...
    Overshoot, ...
    SteadyStateError, ...
    CostFunction);


%% ============================================================
%  25. DISPLAY FINAL TABLE
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('              FINAL OPTIMIZATION RESULTS\n');
fprintf('============================================================\n');

disp(resultsTable);


%% ============================================================
%  26. FIGURE 1 - PID RESPONSE COMPARISON
% =============================================================

fprintf('\nGenerating PID comparison figure...\n');

fig1 = figure('Visible', 'off');

plot(t_manual, y_manual, 'LineWidth', 1.8);
hold on;

plot(t_tuner, y_tuner, 'LineWidth', 1.8);

plot(t_opt, y_opt, 'LineWidth', 1.8);

plot(t, Reference*ones(size(t)), '--', 'LineWidth', 1.5);

grid on;

xlabel('Time (s)');
ylabel('Normalized Speed');

title('PID Tuning Comparison');

legend( ...
    {'Manual PID', ...
     'PID Tuner', ...
     'Optimized PID', ...
     'Reference'}, ...
     'Location', 'best');

hold off;

saveas( ...
    fig1, ...
    fullfile(tuningFiguresFolder, ...
    'PID_Tuning_Comparison.png'));

close(fig1);


%% ============================================================
%  27. FIGURE 2 - PERFORMANCE COMPARISON
% =============================================================

fprintf('Generating performance comparison figure...\n');

fig2 = figure('Visible', 'off');

performanceData = [
    info_manual.RiseTime
    info_tuner.RiseTime
    info_opt.RiseTime
    ];

bar(performanceData);

grid on;

set(gca, ...
    'XTick', 1:3, ...
    'XTickLabel', ...
    {'Manual PID', 'PID Tuner', 'Optimized PID'});

xlabel('Controller');

ylabel('Rise Time (s)');

title('Rise Time Comparison');

saveas( ...
    fig2, ...
    fullfile(tuningFiguresFolder, ...
    'PID_Performance_Comparison.png'));

close(fig2);


%% ============================================================
%  28. FIGURE 3 - COST FUNCTION COMPARISON
% =============================================================

fprintf('Generating cost function comparison figure...\n');

fig3 = figure('Visible', 'off');

costData = [
    CostFunction(1)
    CostFunction(2)
    CostFunction(3)
    ];

bar(costData);

grid on;

set(gca, ...
    'XTick', 1:3, ...
    'XTickLabel', ...
    {'Manual PID', 'PID Tuner', 'Optimized PID'});

xlabel('Controller');

ylabel('Cost Function J');

title('PID Optimization Cost Function Comparison');

saveas( ...
    fig3, ...
    fullfile(tuningFiguresFolder, ...
    'PID_CostFunction_Comparison.png'));

close(fig3);


%% ============================================================
%  29. SAVE MATLAB RESULTS
% =============================================================

fprintf('\nSaving MATLAB results...\n');

save( ...
    fullfile(resultsFolder, ...
    'pid_optimization_results.mat'), ...
    'G_motor', ...
    'C_manual', ...
    'C_tuner', ...
    'C_opt', ...
    'T_manual', ...
    'T_tuner', ...
    'T_opt', ...
    'Kp_manual', ...
    'Ki_manual', ...
    'Kd_manual', ...
    'Kp_tuner', ...
    'Ki_tuner', ...
    'Kd_tuner', ...
    'Kp_opt', ...
    'Ki_opt', ...
    'Kd_opt', ...
    'J_opt', ...
    'resultsTable', ...
    'optimizationTime', ...
    'exitflag', ...
    'output');


%% ============================================================
%  30. SAVE CSV RESULTS
% =============================================================

fprintf('Saving CSV results...\n');

writetable( ...
    resultsTable, ...
    fullfile(resultsFolder, ...
    'pid_optimization_results.csv'));


%% ============================================================
%  31. FINAL DISPLAY
% =============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('       PID OPTIMIZATION COMPLETED SUCCESSFULLY\n');
fprintf('============================================================\n');

fprintf('\nOptimized PID gains:\n');

fprintf('Kp = %.6f\n', Kp_opt);
fprintf('Ki = %.6f\n', Ki_opt);
fprintf('Kd = %.6f\n', Kd_opt);

fprintf('\nOptimized performance:\n');

fprintf('Rise Time          = %.6f s\n', ...
    info_opt.RiseTime);

fprintf('Settling Time      = %.6f s\n', ...
    info_opt.SettlingTime);

fprintf('Overshoot          = %.6f %%\n', ...
    info_opt.Overshoot);

fprintf('Steady-State Error = %.6f %%\n', ...
    ss_opt*100);


fprintf('\nGenerated figures:\n');

fprintf('1. Figures/tuning/PID_Tuning_Comparison.png\n');
fprintf('2. Figures/tuning/PID_Performance_Comparison.png\n');
fprintf('3. Figures/tuning/PID_CostFunction_Comparison.png\n');

fprintf('\nGenerated result files:\n');

fprintf('1. Results/pid_optimization_results.mat\n');
fprintf('2. Results/pid_optimization_results.csv\n');

fprintf('\n');
fprintf('============================================================\n');


%% ============================================================
%  LOCAL COST FUNCTION
% =============================================================

function J = pidCostFunction( ...
    x, ...
    G_motor, ...
    Reference, ...
    w1, ...
    w2, ...
    w3, ...
    w4, ...
    Kp_min, Kp_max, ...
    Ki_min, Ki_max, ...
    Kd_min, Kd_max)


%% ------------------------------------------------------------
% Extract PID gains
% ------------------------------------------------------------

Kp = x(1);
Ki = x(2);
Kd = x(3);


%% ------------------------------------------------------------
% Check bounds
% ------------------------------------------------------------

if Kp < Kp_min || Kp > Kp_max || ...
   Ki < Ki_min || Ki > Ki_max || ...
   Kd < Kd_min || Kd > Kd_max

    J = 1e6;
    return;

end


%% ------------------------------------------------------------
% Create PID controller
% ------------------------------------------------------------

try

    C = pid(Kp, Ki, Kd);

    T = feedback(C * G_motor, 1);

catch

    J = 1e6;
    return;

end


%% ------------------------------------------------------------
% Check stability
% ------------------------------------------------------------

if ~isstable(T)

    J = 1e6;
    return;

end


%% ------------------------------------------------------------
% Simulation
% ------------------------------------------------------------

t = 0:0.005:10;

try

    [y, t] = step(Reference*T, t);

catch

    J = 1e6;
    return;

end


%% ------------------------------------------------------------
% Performance information
% ------------------------------------------------------------

try

    info = stepinfo(y, t, Reference);

catch

    J = 1e6;
    return;

end


%% ------------------------------------------------------------
% Check invalid results
% ------------------------------------------------------------

if isnan(info.RiseTime) || ...
   isnan(info.SettlingTime) || ...
   isinf(info.RiseTime) || ...
   isinf(info.SettlingTime)

    J = 1e6;
    return;

end


%% ------------------------------------------------------------
% Steady-state error
% ------------------------------------------------------------

ssError = abs(Reference - y(end));


%% ------------------------------------------------------------
% Normalize performance metrics
% ------------------------------------------------------------

% Normalized terms avoid one metric dominating the optimization
riseTerm = info.RiseTime / 1.0;

settlingTerm = info.SettlingTime / 2.0;

overshootTerm = info.Overshoot / 10.0;

errorTerm = ssError;


%% ------------------------------------------------------------
% Weighted cost function
% ------------------------------------------------------------

J = ...
    w1 * riseTerm + ...
    w2 * settlingTerm + ...
    w3 * overshootTerm + ...
    w4 * errorTerm;


%% ------------------------------------------------------------
% Additional penalty for excessive overshoot
% ------------------------------------------------------------

if info.Overshoot > 5

    J = J + 10 * (info.Overshoot - 5);

end


end