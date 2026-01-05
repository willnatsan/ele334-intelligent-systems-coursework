%% Part B(b): Full Prediction Pipeline (Normalization + Inference + Denormalization)

% 1. Define the Raw Input Vectors from the Assignment
% Rows = different samples, Columns = Input 1, Input 2, Input 3, Input 4
raw_inputs = [
    0.15, 0.22, 1.0, 0.011;  % Input Vector 1
    0.06, 0.28, 0.4, 0.012   % Input Vector 2
];

% 2. Create Input-Specific Settings Struct
% We isolate the first 4 parameters (inputs) from your 5-parameter (input+output) settings
in_settings = settings;
in_settings.xmin = settings.xmin(1:4);
in_settings.xmax = settings.xmax(1:4);
in_settings.xrange = settings.xrange(1:4);
in_settings.xoffset = settings.xoffset(1:4);
in_settings.gain = settings.gain(1:4);

% 3. Normalize the new inputs using the 'apply' command
% This ensures Input 1 is scaled relative to the original Input 1's min/max, etc.
norm_inputs = mapminmax('apply', raw_inputs', in_settings)';

% 4. Model Inference
% Evaluate using the best model found in section (a)
best_3mf_fis = readfis('santoso_part_B_section_a.fis');
norm_out = evalfis(best_3mf_fis, norm_inputs);

% 5. Denormalize the output back to Original Units
% Using 'out_settings' which we derived from the 5th variable (the output)
final_predictions = mapminmax('reverse', norm_out', out_settings)';

% 6. Display Final Results
fprintf('\n--- Final Predicted Outputs for Part B(b) ---\n');
for i = 1:size(final_predictions, 1)
    fprintf('Vector %d: Input [%.3f, %.3f, %.3f, %.4f] -> Output: %.4f\n', ...
        i, raw_inputs(i,1), raw_inputs(i,2), raw_inputs(i,3), raw_inputs(i,4), final_predictions(i));
end