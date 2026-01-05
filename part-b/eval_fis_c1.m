%% Master ANFIS Evaluator: Automated Selection & Shuffled Data Visualization
% Required: trdata, ckdata (normalized), settings (mapminmax struct)

% 1. Robust Output Settings Extraction (using 'end' for scalar/vector safety)
out_settings = settings;
out_settings.xmin = settings.xmin(end);
out_settings.xmax = settings.xmax(end);
out_settings.xrange = settings.xrange(end);
out_settings.ymin = settings.ymin(end);
out_settings.ymax = settings.ymax(end);
out_settings.xoffset = settings.xoffset(end);
out_settings.gain = settings.gain(end);

% 2. Automated Model Selection
fis_files = dir('section_c1_fis/*.fis');
num_files = length(fis_files);
if num_files == 0, error('No .fis files found in current directory.'); end

results = table();
for i = 1:num_files
    fname = fis_files(i).name;
    fis = readfis(append('section_c1_fis/', fname));
    
    % Evaluate and Denormalize for Metrics
    y_tr_norm = evalfis(fis, trdata(:, 1:end-1));
    y_tr_p = mapminmax('reverse', y_tr_norm', out_settings)';
    y_tr_t = mapminmax('reverse', trdata(:, end)', out_settings)';
    
    y_ck_norm = evalfis(fis, ckdata(:, 1:end-1));
    y_ck_p = mapminmax('reverse', y_ck_norm', out_settings)';
    y_ck_t = mapminmax('reverse', ckdata(:, end)', out_settings)';
    
    % Statistics calculation
    tr_rmse = sqrt(mean((y_tr_t - y_tr_p).^2));
    ck_rmse = sqrt(mean((y_ck_t - y_ck_p).^2));
    
    row = table({fname}, tr_rmse, ck_rmse, 'VariableNames', {'Model', 'TR_RMSE', 'CK_RMSE'});
    results = [results; row];
end

% Determine the Best Model based on CK_RMSE
results = sortrows(results, 'CK_RMSE', 'ascend');
best_model_name = results.Model{1};
best_fis = readfis(append('section_c1_fis/', best_model_name));
writeFIS(best_fis, 'santoso_part_B_section_c1.fis')

fprintf('\n--- VALIDITY ASSESSMENT SUMMARY ---\n');
disp(results);
fprintf('Optimal Model Selected: %s\n', best_model_name);

% 3. Final Denormalization for the Best Model
y_tr_p = mapminmax('reverse', evalfis(best_fis, trdata(:,1:end-1))', out_settings)';
y_tr_t = mapminmax('reverse', trdata(:, end)', out_settings)';
y_ck_p = mapminmax('reverse', evalfis(best_fis, ckdata(:,1:end-1))', out_settings)';
y_ck_t = mapminmax('reverse', ckdata(:, end)', out_settings)';

% --- VISUALIZATION 1: TRAINING PERFORMANCE (Sorted & Residuals) ---
figure('Name', ['Training Validity: ' best_model_name], 'Color', 'w');
subplot(2,1,1);
[y_tr_sort, tr_idx] = sort(y_tr_t);
plot(y_tr_sort, 'o-', 'Color', [0.2 0.6 0.2], 'LineWidth', 0.5); hold on;
plot(y_tr_p(tr_idx), 'k.', 'MarkerSize', 8);
title(['Training Data Tracking - RMSE: ', num2str(results.TR_RMSE(1), '%.3f')]);
ylabel('Output Value'); legend('Actual Data', 'ANFIS Prediction'); grid on;

subplot(2,1,2);
stem(y_tr_t - y_tr_p, 'MarkerSize', 4, 'Color', [0.8 0.2 0.2]); hold on;
yline(0, 'k-', 'LineWidth', 1.5);
title('Training Error (Residuals) per Sample');
ylabel('Error (Actual - Pred)'); xlabel('Sample Index'); grid on;

% --- VISUALIZATION 2: CHECKING PERFORMANCE (Sorted & Regression) ---
figure('Name', ['Checking Validity: ' best_model_name], 'Color', 'w');
subplot(2,1,1);
[y_ck_sort, ck_idx] = sort(y_ck_t);
plot(y_ck_sort, 'o-', 'LineWidth', 0.5); hold on;
plot(y_ck_p(ck_idx), 'r.', 'MarkerSize', 8);
title(['Checking Data Tracking - RMSE: ', num2str(results.CK_RMSE(1), '%.3f')]);
ylabel('Output Value'); legend('Actual Data', 'ANFIS Prediction'); grid on;

subplot(2,1,2);
scatter(y_ck_t, y_ck_p, 'filled', 'MarkerFaceAlpha', 0.4); hold on;
plot([min(y_ck_t) max(y_ck_t)], [min(y_ck_t) max(y_ck_t)], 'r--', 'LineWidth', 2);
title('Regression Analysis (Identity Fit)');
xlabel('Actual Values'); ylabel('Predicted Values');
legend('Model Output', 'Perfect Fit (Y=X)'); grid on;