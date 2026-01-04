%% Fuzzy PID Performance Analysis (Updated with Steady-State Offset)
% 1. Extract Data from Workspace
t = out.Time;
y = out.Data;
e = error.Data;
setpoint = target.Data(1); % Target level (e.g., 0.8)

% 2. Calculate Time-Domain Specs (Induction Phase)
% Analyze response before the disturbance at t=150
idx_induction = t < 145; 
t_ind = t(idx_induction);
y_ind = y(idx_induction);
specs = stepinfo(y_ind, t_ind, setpoint);

% 3. Calculate Steady-State Offset (Post-Disturbance)
% We look at the final steady state (the last 5% of the simulation)
num_samples = length(y);
idx_ss = round(0.95 * num_samples):num_samples; 
final_value = mean(y(idx_ss));
SS_Offset = abs(setpoint - final_value);

% 4. Calculate Error Indices (Total Performance)
MAE  = mean(abs(e));
MSE  = mean(e.^2);
RMSE = sqrt(MSE);

% 5. Generate Results Table
Metric_Names = {'Rise Time (min)'; 'Settling Time (min)'; 'Overshoot (%)'; ...
                'Steady-State Offset'; 'MAE'; 'MSE'; 'RMSE'};
Values = [specs.RiseTime; specs.SettlingTime; specs.Overshoot; ...
          SS_Offset; MAE; MSE; RMSE];
PerformanceTable = table(Metric_Names, Values);

% Display Table
disp('--- Controller Performance Results ---');
disp(PerformanceTable);

% 6. Plot for Verification
figure('Name', 'Performance Verification');
subplot(2,1,1);
plot(t, y, 'LineWidth', 1.5); hold on;
plot(t, target.Data, '--r', 'LineWidth', 1.2);
yline(final_value, 'g:', 'Settled Value', 'LabelVerticalAlignment','bottom');
title('Patient Output vs Target');
ylabel('Muscle Relaxation');
legend('Actual Output', 'Target', 'Final Settled Value');
grid on;

subplot(2,1,2);
plot(t, e, 'Color', [0.8500 0.3250 0.0980]);
title('Error Signal (Offset Visualization)');
ylabel('Error');
xlabel('Time (s)');
grid on;