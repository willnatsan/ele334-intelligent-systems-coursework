%% Fuzzy PID Performance Analysis

% 1. Extract Data from Workspace
t = out.Time;
y = out.Data;
e = error.Data;
setpoint = target.Data(1); % Usually 0.8

% 2. Calculate Time-Domain Specs (Induction Phase)
% We analyze the response before the disturbance at t=150
idx_induction = t < 145; 
t_ind = t(idx_induction);
y_ind = y(idx_induction);

% Calculate Rise Time, Settling Time, and Overshoot
specs = stepinfo(y_ind, t_ind, setpoint);

% 3. Calculate Error Indices (Total Performance)
% These indices cover the full 300s including disturbance
MAE  = mean(abs(e));
MSE  = mean(e.^2);
RMSE = sqrt(MSE);

% 4. Generate Results Table
Metric_Names = {'Rise Time (s)'; 'Settling Time (s)'; 'Overshoot (%)'; 'MAE'; 'MSE'; 'RMSE'};
Values = [specs.RiseTime; specs.SettlingTime; specs.Overshoot; MAE; MSE; RMSE];

PerformanceTable = table(Metric_Names, Values);

% Display Table
disp('--- Controller Performance Results ---');
disp(PerformanceTable);

% 5. Plot for Verification
figure('Name', 'Performance Verification');
subplot(2,1,1);
plot(t, y); hold on;
plot(t, target.Data, '--r');
title('Patient Output vs Target');
ylabel('Muscle Relaxation');
grid on;

subplot(2,1,2);
plot(t, e);
title('Error Signal Over Time');
ylabel('Error');
xlabel('Time (s)');
grid on;