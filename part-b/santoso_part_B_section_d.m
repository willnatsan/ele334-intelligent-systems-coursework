%% Part B(d): Prediction for 4-MF and 5-MF Models
% Required: settings (original 5-var struct), out_settings (output-only struct)

% 1. Define the Raw Input Vectors
raw_inputs = [
    0.15, 0.22, 1.0, 0.011;  % Input Vector 1
    0.06, 0.28, 0.4, 0.012   % Input Vector 2
];

% 2. Prepare Input Settings (Reuse your corrected logic)
in_settings = settings;
in_settings.xmin = settings.xmin(1:4);
in_settings.xmax = settings.xmax(1:4);
in_settings.xrange = settings.xrange(1:4);
% Ensure xoffset/gain are truncated only if they are vectors
if length(settings.xoffset) > 1
    in_settings.xoffset = settings.xoffset(1:4);
    in_settings.gain = settings.gain(1:4);
end

% 3. Normalize inputs
norm_inputs = mapminmax('apply', raw_inputs', in_settings)';

% 4. Load your winners from Part B(c)
% Replace these filenames with your actual best-performing .fis files
best_4mf_fis = readfis('santoso_part_B_section_c1.fis'); 
best_5mf_fis = readfis('santoso_part_B_section_c2.fis');

% 5. Run Inference & Denormalize for both models
% 4-MF Model Results
norm_out_4 = evalfis(best_4mf_fis, norm_inputs);
pred_4mf = mapminmax('reverse', norm_out_4', out_settings)';

% 5-MF Model Results
norm_out_5 = evalfis(best_5mf_fis, norm_inputs);
pred_5mf = mapminmax('reverse', norm_out_5', out_settings)';

% 6. Display Results for Part B(d)
fprintf('\n--- Results for Part B(d) ---\n');
fprintf('BEST 4-MF MODEL PREDICTIONS:\n');
fprintf('Vector 1: %.4f | Vector 2: %.4f\n', pred_4mf(1), pred_4mf(2));

fprintf('\nBEST 5-MF MODEL PREDICTIONS:\n');
fprintf('Vector 1: %.4f | Vector 2: %.4f\n', pred_5mf(1), pred_5mf(2));