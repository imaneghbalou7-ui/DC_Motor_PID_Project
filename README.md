# DC Motor Speed Control — P / PI / PID

![Made with MATLAB](https://img.shields.io/badge/Made%20with-MATLAB-orange)

## Project Overview

This project focuses on the mathematical modeling, simulation and closed-loop speed control of a DC motor using MATLAB and Simulink.

Three classical control strategies are implemented and compared:

* Proportional (P)
* Proportional-Integral (PI)
* Proportional-Integral-Derivative (PID)

The project was developed progressively, starting from the basic open-loop motor model and moving toward a complete closed-loop control system with controller comparison, external disturbance, measurement noise and automated performance evaluation.

---

## Objectives

The main objectives of this project are:

* Develop a mathematical model of a DC motor.
* Analyze the motor response in open loop.
* Implement a closed-loop speed control system.
* Design and evaluate P, PI and PID controllers.
* Study the effect of external disturbances.
* Study the effect of measurement noise.
* Compare the dynamic and steady-state performances of the controllers.
* Automate the simulation and performance analysis process using MATLAB.
* Generate quantitative performance indicators for objective comparison.

---

## System Modeling

The DC motor is modeled using its electrical and mechanical equations.

The main motor parameters used in the project are:

| Parameter | Description                    |
| --------- | ------------------------------ |
| R         | Armature resistance            |
| L         | Armature inductance            |
| J         | Rotor inertia                  |
| B         | Viscous friction coefficient   |
| K         | Motor torque/back-emf constant |

The resulting motor transfer function is used to represent the relationship between the applied motor voltage and the motor angular speed.

The system is first studied in open loop and is then integrated into a closed-loop feedback control architecture.

The mathematical modeling and corresponding representations developed during the project are documented in:

```text
Figures/modele_mathematique/
```

---

## Development Methodology

The project was developed progressively using MATLAB and Simulink.

The main development steps were:

1. DC motor mathematical modeling.
2. Open-loop simulation.
3. Closed-loop feedback implementation.
4. P controller implementation.
5. PI controller implementation.
6. PID controller implementation.
7. Study of external disturbance effects.
8. Study of measurement noise effects.
9. Automated P / PI / PID simulations.
10. Automated performance analysis.
11. Quantitative comparison of the three controllers.

The project was developed progressively by modifying and improving the control system step by step. The same closed-loop architecture was used throughout several phases while additional elements and experiments were introduced.

Screenshots documenting the progressive development of the Simulink models are available in:

```text
Figures/Simulink_Development_Steps/
```

---

## Simulink Models

The project contains two main Simulink models representing the progressive development of the control system:

```text
Simulink/
├── DC_Motor_OpenLoop.slx
└── DC_Motor_ClosedLoop.slx
```

### `DC_Motor_OpenLoop.slx`

This is the initial and basic Simulink model used to start the project.

It represents the DC motor in an open-loop configuration and was used as the starting point for the modeling and simulation work.

This first model allowed the initial behavior of the DC motor to be studied before introducing feedback control.

It corresponds to the initial stage of the project, where the motor model and its open-loop response were first analyzed.

---

### `DC_Motor_ClosedLoop.slx`

This is the final and complete closed-loop Simulink model developed progressively throughout the project.

Starting from the closed-loop control architecture, this model incorporates the different developments carried out during the project, including:

* Feedback control of the DC motor speed.
* Implementation and comparison of P, PI and PID controllers.
* Integration of an external disturbance.
* Integration of measurement noise.
* Evaluation of the controllers under different operating conditions.
* Automated simulations and performance analysis.

The `DC_Motor_ClosedLoop.slx` model therefore represents the final control architecture resulting from the progressive development of the project.

It integrates the different elements introduced throughout the project, from the initial closed-loop feedback structure to the addition of disturbance, measurement noise and the subsequent controller analysis and comparison stages.

The `DC_Motor_OpenLoop.slx` model represents the initial starting point of the study, while `DC_Motor_ClosedLoop.slx` represents the final and complete control architecture developed throughout the project.

The different stages of the Simulink model development are documented through screenshots available in:

```text
Figures/Simulink_Development_Steps/
```

These screenshots illustrate the progressive evolution of the system, from the initial open-loop model to the final closed-loop configuration with the different elements introduced throughout the project.

---

## Control Strategies

### P Controller

The proportional controller generates a control action proportional to the tracking error.

The P controller provides a simple and fast control strategy but generally cannot completely eliminate the steady-state error.

---

### PI Controller

The PI controller combines proportional and integral actions.

The integral term accumulates the tracking error over time and allows the controller to significantly reduce or eliminate the steady-state error.

However, the integral action may increase overshoot and settling time if the controller is not properly tuned.

---

### PID Controller

The PID controller combines proportional, integral and derivative actions.

The derivative term reacts to the variation of the error and helps improve the transient response.

The PID controller is evaluated in this project in terms of response speed, settling time, overshoot and steady-state accuracy.

---

## Disturbance and Measurement Noise

The control system was progressively evaluated under different operating conditions.

The study includes:

* Normal operation without disturbance.
* Operation with an external disturbance.
* Operation with measurement noise.
* Operation with both disturbance and noise.

These experiments are used to evaluate the robustness of the control strategies under more realistic conditions.

The corresponding simulation figures and screenshots documenting the different stages are available in the `Figures/` directory.

The folder:

```text
Figures/Simulink_Development_Steps/
```

contains screenshots illustrating the progressive development of the Simulink system.

Since several project phases used the same Simulink architecture, screenshots were captured only when a significant modification or new development step was introduced. Duplicate screenshots were therefore not created for phases using the same model structure.

---

## Automated Simulation and Analysis

The final stage of the project includes MATLAB scripts for automating the simulation and performance analysis of the P, PI and PID controllers.

The main scripts are:

```text
Matlab/
├── parameters.m
├── run_simulations.m
├── analyse_results.m
└── performance_analysis.m
```

### Parameter Configuration

The file:

```text
parameters.m
```

contains the main motor, simulation and controller parameters used in the project.

It is used to initialize the required variables before running the simulations.

The corresponding parameter data are stored in:

```text
Matlab/params.mat
```

### Automated Simulation

The script:

```text
run_simulations.m
```

automatically runs the simulations for the three controllers and saves the obtained results.

The simulation results are stored in the `Results/` directory.

### Result Analysis

The script:

```text
analyse_results.m
```

loads and compares the simulation results and generates the final comparison between the P, PI and PID controllers.

The comparison figure is saved as:

```text
Figures/Comparaison_P_PI_PID.png
```

### Performance Analysis

The script:

```text
performance_analysis.m
```

calculates quantitative performance indicators such as:

* Rise Time (Tr)
* Settling Time (Ts)
* Overshoot (Mp)
* Steady-state error (Ess)
* Final value
* Peak value

The resulting performance table is exported as:

```text
Results/performance_table.csv
```

---

## Performance Comparison

The final simulation results obtained for the selected controller parameters are summarized below.

| Controller | Rise Time (s) | Settling Time (s) | Overshoot (%) | Steady-State Error (%) |
| ---------- | ------------: | ----------------: | ------------: | ---------------------: |
| P          |           NaN |               NaN |         0.000 |                 32.395 |
| PI         |        1.1383 |            4.5782 |        35.549 |                  0.948 |
| PID        |        0.8812 |            4.1548 |        32.810 |                  0.959 |

### Interpretation

The P controller presents a significant steady-state error of approximately 32.4%, with a final value of approximately 0.676 for a unit reference.

The PI controller significantly reduces the steady-state error to approximately 0.95%. However, its settling time is approximately 4.58 seconds and its overshoot reaches approximately 35.55%.

The PID controller provides a faster transient response than the PI controller, with a rise time of approximately 0.88 seconds and a settling time of approximately 4.15 seconds. Its overshoot is also slightly lower than that of the PI controller, at approximately 32.81%.

Based on these results, the PID controller provides the best overall compromise between response speed, settling behavior and steady-state accuracy for the selected operating conditions.

The final comparison figure is available in:

```text
Figures/Comparaison_P_PI_PID.png
```

---

## Project Structure

```text
DC_Motor_PID_Project/
│
├── README.md
├── CHANGELOG.md
├── LICENSE
├── .gitignore
│
├── Simulink/
│   ├── DC_Motor_OpenLoop.slx
│   └── DC_Motor_ClosedLoop.slx
│
├── Matlab/
│   ├── parameters.m
│   ├── run_simulations.m
│   ├── analyse_results.m
│   ├── performance_analysis.m
│   └── params.mat
│
├── Figures/
│   │
│   ├── Simulink_Development_Steps/
│   │   └── ...
│   │
│   ├── modele_mathematique/
│   │   └── ...
│   │
│   ├── Comparaison_P_PI_PID.png
│   │
│   └── ...
│
├── Results/
│   ├── results_P.mat
│   ├── results_PI.mat
│   ├── results_PID.mat
│   └── performance_table.csv
│
└── docs/
    └── ...
```

The `Figures/` directory contains the visual documentation and results of the project:

* `Simulink_Development_Steps/` contains screenshots documenting the progressive development of the Simulink models and the different stages of the project.
* `modele_mathematique/` contains figures related to the mathematical modeling of the DC motor.
* `Comparaison_P_PI_PID.png` presents the final comparison of the P, PI and PID controller responses.
* The remaining figures document the simulation results obtained throughout the different project phases.

---

## How to Run the Project

### 1. Open MATLAB

Open the project directory:

```text
DC_Motor_PID_Project/
```

### 2. Open the MATLAB folder

Navigate to:

```text
Matlab/
```

### 3. Load the project parameters

Run:

```matlab
parameters
```

### 4. Run the automated simulations

Run:

```matlab
run_simulations
```

### 5. Analyze the simulation results

Run:

```matlab
analyse_results
```

### 6. Generate the performance table

Run:

```matlab
performance_analysis
```

The simulation results are saved in:

```text
Results/
```

and the generated figures are saved in:

```text
Figures/
```

---

## Technologies

* MATLAB
* Simulink
* Control System Toolbox
* MATLAB scripting
* Classical control theory
* DC motor modeling
* Feedback control systems

---

## Conclusion

This project demonstrates the complete development of a DC motor speed control system, from mathematical modeling to closed-loop control and automated performance evaluation.

The comparison of P, PI and PID controllers demonstrates the importance of controller selection and tuning.

The P controller is simple but maintains a significant steady-state error. The PI controller provides high steady-state accuracy but introduces a slower transient response and significant overshoot. The PID controller provides the best overall compromise for the selected parameters, combining a faster response with low steady-state error and slightly reduced overshoot compared with the PI controller.

The project also evaluates the effect of disturbances and measurement noise, providing a more realistic assessment of the robustness of the control strategies.

The progressive development documented in the project demonstrates the transition from a basic open-loop DC motor model to a complete closed-loop control system incorporating P, PI and PID control, disturbance rejection, measurement noise analysis and automated performance evaluation.

---

## Author

**Imane Ghbalou**
s
Academic project — 2026
