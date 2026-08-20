%% ============================================================
%  AUTOMATIC FREQUENCY-DOMAIN INTERPRETATION
%  DC Motor Speed Control Project
%
%  Purpose:
%  - Load frequency-domain analysis results
%  - Compare P, PI and PID controllers
%  - Interpret stability margins
%  - Compare dynamic characteristics
%  - Generate an automatic engineering conclusion
%
%  Author: Imane Ghbalou
%  Project: DC Motor Speed Control
% =============================================================

clear;
clc;

fprintf('\n');
fprintf('============================================================\n');
fprintf('     AUTOMATIC FREQUENCY-DOMAIN INTERPRETATION\n');
fprintf('============================================================\n');
fprintf('\n');


%% ============================================================
% 1. PROJECT PATHS
% ============================================================

fprintf('Initializing project paths...\n');

% The script is executed from:
% DC_Motor_PID_Project/Matlab/

projectRoot = fileparts(pwd);

resultsFolder = fullfile(projectRoot, 'Results');

resultsFile = fullfile(resultsFolder, ...
    'frequency_analysis_results.mat');

outputFile = fullfile(resultsFolder, ...
    'frequency_domain_interpretation.txt');

fprintf('Project paths initialized successfully.\n');


%% ============================================================
% 2. CHECK RESULTS FILE
% ============================================================

fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('CHECKING FREQUENCY ANALYSIS RESULTS\n');
fprintf('------------------------------------------------------------\n');

if ~isfile(resultsFile)

    error(['Frequency analysis results file not found: ', ...
        resultsFile, newline, ...
        'Please run frequency-analysis.m first.']);

end

fprintf('Results file found:\n');
fprintf('%s\n', resultsFile);


%% ============================================================
% 3. LOAD RESULTS
% ============================================================

fprintf('\n');
fprintf('Loading frequency-domain results...\n');

data = load(resultsFile);

fprintf('Results loaded successfully.\n');


%% ============================================================
% 4. CHECK FREQUENCY RESULTS
% ============================================================

if ~isfield(data, 'frequency_results')

    error(['The variable "frequency_results" was not found ', ...
        'inside frequency_analysis_results.mat.']);

end

% Extract the frequency results table
frequency_results = data.frequency_results;


%% ============================================================
% 5. DISPLAY AVAILABLE VARIABLES
% ============================================================

fprintf('\n');
fprintf('Variables available in results file:\n');

disp(fieldnames(data));


%% ============================================================
% 6. DISPLAY FREQUENCY RESULTS TABLE
% ============================================================

fprintf('\n');
fprintf('Frequency-domain result structure:\n');

disp(frequency_results);


%% ============================================================
% 7. EXTRACT P / PI / PID RESULTS FROM TABLE
% ============================================================

% The variable "frequency_results" is a MATLAB table.
% The controller names are stored in the "Controller" column.

% Find the row corresponding to each controller

idx_P = strcmp(string(frequency_results.Controller), "P");

idx_PI = strcmp(string(frequency_results.Controller), "PI");

idx_PID = strcmp(string(frequency_results.Controller), "PID");


% Check that all controllers exist

if ~any(idx_P)

    error('P controller results were not found.');

end

if ~any(idx_PI)

    error('PI controller results were not found.');

end

if ~any(idx_PID)

    error('PID controller results were not found.');

end


% Extract rows

P_results = frequency_results(idx_P, :);

PI_results = frequency_results(idx_PI, :);

PID_results = frequency_results(idx_PID, :);


%% ============================================================
% 8. EXTRACT NUMERICAL VALUES
% ============================================================

% P controller

P_phase_margin = P_results.PhaseMargin_deg;

P_gain_crossover = P_results.GainCrossover_rad_s;

P_gain_margin = P_results.GainMargin_dB;

P_phase_crossover = P_results.PhaseCrossover_rad_s;


% PI controller

PI_phase_margin = PI_results.PhaseMargin_deg;

PI_gain_crossover = PI_results.GainCrossover_rad_s;

PI_gain_margin = PI_results.GainMargin_dB;

PI_phase_crossover = PI_results.PhaseCrossover_rad_s;


% PID controller

PID_phase_margin = PID_results.PhaseMargin_deg;

PID_gain_crossover = PID_results.GainCrossover_rad_s;

PID_gain_margin = PID_results.GainMargin_dB;

PID_phase_crossover = PID_results.PhaseCrossover_rad_s;


%% ============================================================
% 9. DISPLAY BASIC RESULTS
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('             FREQUENCY-DOMAIN RESULTS\n');
fprintf('============================================================\n');


fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('P CONTROLLER\n');
fprintf('------------------------------------------------------------\n');

fprintf('Gain Margin              = %g dB\n', ...
    P_gain_margin);

fprintf('Phase Margin             = %g degrees\n', ...
    P_phase_margin);

fprintf('Gain Crossover Frequency = %g rad/s\n', ...
    P_gain_crossover);

fprintf('Phase Crossover Frequency = %g rad/s\n', ...
    P_phase_crossover);


fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('PI CONTROLLER\n');
fprintf('------------------------------------------------------------\n');

fprintf('Gain Margin              = %g dB\n', ...
    PI_gain_margin);

fprintf('Phase Margin             = %.4f degrees\n', ...
    PI_phase_margin);

fprintf('Gain Crossover Frequency = %.4f rad/s\n', ...
    PI_gain_crossover);

fprintf('Phase Crossover Frequency = %g rad/s\n', ...
    PI_phase_crossover);


fprintf('\n');
fprintf('------------------------------------------------------------\n');
fprintf('PID CONTROLLER\n');
fprintf('------------------------------------------------------------\n');

fprintf('Gain Margin              = %g dB\n', ...
    PID_gain_margin);

fprintf('Phase Margin             = %.4f degrees\n', ...
    PID_phase_margin);

fprintf('Gain Crossover Frequency = %.4f rad/s\n', ...
    PID_gain_crossover);

fprintf('Phase Crossover Frequency = %g rad/s\n', ...
    PID_phase_crossover);


%% ============================================================
% 10. INITIALIZE INTERPRETATION
% ============================================================

interpretation = {};

interpretation{end+1} = ...
    'AUTOMATIC FREQUENCY-DOMAIN INTERPRETATION';

interpretation{end+1} = ...
    '==========================================';

interpretation{end+1} = '';

interpretation{end+1} = ...
    'This report summarizes the frequency-domain analysis of the P, PI and PID controllers.';

interpretation{end+1} = '';


%% ============================================================
% 11. P CONTROLLER ANALYSIS
% ============================================================

interpretation{end+1} = ...
    'P CONTROLLER ANALYSIS';

interpretation{end+1} = ...
    '---------------------';


if isinf(P_phase_margin)

    interpretation{end+1} = ...
        ['The P controller does not exhibit a finite phase ', ...
         'margin under the selected operating conditions.'];

else

    if P_phase_margin > 45

        interpretation{end+1} = ...
            sprintf(['The P controller has a phase margin of ', ...
            '%.2f degrees, indicating a relatively good ', ...
            'stability reserve.'], ...
            P_phase_margin);

    elseif P_phase_margin > 0

        interpretation{end+1} = ...
            sprintf(['The P controller has a positive phase ', ...
            'margin of %.2f degrees, indicating stability ', ...
            'with a limited stability reserve.'], ...
            P_phase_margin);

    else

        interpretation{end+1} = ...
            ['The P controller has a non-positive phase ', ...
             'margin, indicating potential stability issues.'];

    end

end


interpretation{end+1} = ...
    ['The P controller does not provide integral action, ', ...
     'which explains its inability to completely eliminate ', ...
     'the steady-state tracking error observed in the time-domain analysis.'];

interpretation{end+1} = '';


%% ============================================================
% 12. PI CONTROLLER ANALYSIS
% ============================================================

interpretation{end+1} = ...
    'PI CONTROLLER ANALYSIS';

interpretation{end+1} = ...
    '----------------------';


if PI_phase_margin > 45

    interpretation{end+1} = ...
        sprintf(['The PI controller provides a phase margin ', ...
        'of %.2f degrees, indicating a good stability reserve.'], ...
        PI_phase_margin);

elseif PI_phase_margin > 0

    interpretation{end+1} = ...
        sprintf(['The PI controller provides a positive phase ', ...
        'margin of %.2f degrees, indicating stability but ', ...
        'with a moderate stability reserve.'], ...
        PI_phase_margin);

else

    interpretation{end+1} = ...
        ['The PI controller has a non-positive phase margin, ', ...
         'indicating potential stability issues.'];

end


interpretation{end+1} = ...
    sprintf(['The gain crossover frequency is %.4f rad/s.'], ...
    PI_gain_crossover);

interpretation{end+1} = ...
    ['The integral action improves steady-state tracking ', ...
     'accuracy by eliminating or strongly reducing persistent ', ...
     'steady-state error.'];

interpretation{end+1} = '';


%% ============================================================
% 13. PID CONTROLLER ANALYSIS
% ============================================================

interpretation{end+1} = ...
    'PID CONTROLLER ANALYSIS';

interpretation{end+1} = ...
    '-----------------------';


if PID_phase_margin > 45

    interpretation{end+1} = ...
        sprintf(['The PID controller provides a phase margin ', ...
        'of %.2f degrees, indicating a good stability reserve.'], ...
        PID_phase_margin);

elseif PID_phase_margin > 0

    interpretation{end+1} = ...
        sprintf(['The PID controller provides a positive phase ', ...
        'margin of %.2f degrees, indicating stability but ', ...
        'with a moderate stability reserve.'], ...
        PID_phase_margin);

else

    interpretation{end+1} = ...
        ['The PID controller has a non-positive phase margin, ', ...
         'indicating potential stability issues.'];

end


interpretation{end+1} = ...
    sprintf(['The gain crossover frequency is %.4f rad/s.'], ...
    PID_gain_crossover);

interpretation{end+1} = ...
    ['The derivative action contributes to improved transient ', ...
     'performance by increasing the dynamic bandwidth of the ', ...
     'controlled system. However, it also increases sensitivity ', ...
     'to measurement noise, which is why derivative filtering ', ...
     'was introduced in the Simulink implementation.'];

interpretation{end+1} = '';


%% ============================================================
% 14. PI VS PID COMPARISON
% ============================================================

interpretation{end+1} = ...
    'PI vs PID COMPARISON';

interpretation{end+1} = ...
    '--------------------';


% ------------------------------------------------------------
% Phase margin comparison
% ------------------------------------------------------------

if PID_phase_margin > PI_phase_margin

    interpretation{end+1} = ...
        sprintf(['The PID controller has a higher phase margin ', ...
        '(%.2f degrees) than the PI controller (%.2f degrees).'], ...
        PID_phase_margin, ...
        PI_phase_margin);

elseif PID_phase_margin < PI_phase_margin

    interpretation{end+1} = ...
        sprintf(['The PI controller has a higher phase margin ', ...
        '(%.2f degrees) than the PID controller (%.2f degrees).'], ...
        PI_phase_margin, ...
        PID_phase_margin);

else

    interpretation{end+1} = ...
        ['The PI and PID controllers have the same phase margin.'];

end


% ------------------------------------------------------------
% Gain crossover frequency comparison
% ------------------------------------------------------------

if PID_gain_crossover > PI_gain_crossover

    interpretation{end+1} = ...
        sprintf(['The PID controller has a higher gain crossover ', ...
        'frequency (%.4f rad/s) than the PI controller ', ...
        '(%.4f rad/s).'], ...
        PID_gain_crossover, ...
        PI_gain_crossover);

    interpretation{end+1} = ...
        ['A higher gain crossover frequency generally indicates ', ...
         'a larger closed-loop bandwidth and faster dynamic ', ...
         'response.'];

elseif PID_gain_crossover < PI_gain_crossover

    interpretation{end+1} = ...
        sprintf(['The PI controller has a higher gain crossover ', ...
        'frequency (%.4f rad/s) than the PID controller ', ...
        '(%.4f rad/s).'], ...
        PI_gain_crossover, ...
        PID_gain_crossover);

else

    interpretation{end+1} = ...
        ['The PI and PID controllers have similar gain ', ...
         'crossover frequencies.'];

end


interpretation{end+1} = '';


%% ============================================================
% 15. NUMERICAL COMPARISON
% ============================================================

interpretation{end+1} = ...
    'NUMERICAL COMPARISON';

interpretation{end+1} = ...
    '--------------------';


% Difference in phase margin

phase_margin_difference = ...
    PI_phase_margin - PID_phase_margin;


% Difference in crossover frequency

crossover_difference = ...
    PID_gain_crossover - PI_gain_crossover;


% Percentage increase in crossover frequency

crossover_percentage = ...
    (crossover_difference / PI_gain_crossover) * 100;


interpretation{end+1} = ...
    sprintf(['The PI phase margin is %.2f degrees higher than ', ...
    'the PID phase margin.'], ...
    phase_margin_difference);


interpretation{end+1} = ...
    sprintf(['The PID gain crossover frequency is %.4f rad/s ', ...
    'higher than the PI gain crossover frequency.'], ...
    crossover_difference);


interpretation{end+1} = ...
    sprintf(['This corresponds to an increase of approximately ', ...
    '%.2f%% in the gain crossover frequency.'], ...
    crossover_percentage);


interpretation{end+1} = '';


%% ============================================================
% 16. FINAL FREQUENCY-DOMAIN CONCLUSION
% ============================================================

interpretation{end+1} = ...
    'FINAL FREQUENCY-DOMAIN CONCLUSION';

interpretation{end+1} = ...
    '---------------------------------';


if PID_gain_crossover > PI_gain_crossover && ...
        PI_phase_margin > PID_phase_margin

    interpretation{end+1} = ...
        ['The frequency-domain analysis reveals a clear trade-off ', ...
         'between dynamic speed and stability reserve.'];

    interpretation{end+1} = ...
        ['The PID controller provides a higher gain crossover ', ...
         'frequency, indicating a larger bandwidth and faster ', ...
         'potential dynamic response.'];

    interpretation{end+1} = ...
        ['The PI controller provides a higher phase margin, ', ...
         'indicating a slightly larger stability reserve.'];

    interpretation{end+1} = ...
        ['Therefore, the PID controller is preferable when faster ', ...
         'dynamic performance is prioritized, while the PI controller ', ...
         'may be preferred when a larger stability margin and simpler ', ...
         'controller structure are desired.'];

else

    interpretation{end+1} = ...
        ['The frequency-domain analysis indicates that the PID ', ...
         'controller provides a strong overall compromise between ', ...
         'dynamic performance and stability for the selected ', ...
         'operating conditions.'];

end


interpretation{end+1} = '';


%% ============================================================
% 17. RELATION WITH TIME-DOMAIN RESULTS
% ============================================================

interpretation{end+1} = ...
    'RELATION BETWEEN TIME-DOMAIN AND FREQUENCY-DOMAIN RESULTS';

interpretation{end+1} = ...
    '------------------------------------------------------------';


interpretation{end+1} = ...
    ['The frequency-domain results should be interpreted together ', ...
     'with the time-domain performance indicators obtained from ', ...
     'the automated P, PI and PID simulations.'];


interpretation{end+1} = ...
    ['The PID controller exhibits a higher gain crossover frequency ', ...
     'than the PI controller. This is consistent with the faster ', ...
     'transient response observed in the time-domain analysis.'];


interpretation{end+1} = ...
    ['The PI controller exhibits a slightly higher phase margin, ', ...
     'which indicates a larger stability reserve under the selected ', ...
     'operating conditions.'];


interpretation{end+1} = ...
    ['The combined time-domain and frequency-domain analyses ', ...
     'therefore provide a more complete evaluation of the P, PI ', ...
     'and PID control strategies.'];


interpretation{end+1} = '';


%% ============================================================
% 18. DISPLAY INTERPRETATION
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('             AUTOMATIC INTERPRETATION\n');
fprintf('============================================================\n');


for i = 1:length(interpretation)

    fprintf('%s\n', interpretation{i});

end


%% ============================================================
% 19. SAVE INTERPRETATION TO TEXT FILE
% ============================================================

fprintf('\n');
fprintf('Saving interpretation...\n');


fid = fopen(outputFile, 'w');


if fid == -1

    error('Unable to create interpretation output file.');

end


for i = 1:length(interpretation)

    fprintf(fid, '%s\n', interpretation{i});

end


fclose(fid);


fprintf('Interpretation saved successfully.\n');


fprintf('\n');
fprintf('Output file:\n');

fprintf('%s\n', outputFile);


%% ============================================================
% 20. FINAL MESSAGE
% ============================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('FREQUENCY-DOMAIN INTERPRETATION COMPLETED SUCCESSFULLY\n');
fprintf('============================================================\n');