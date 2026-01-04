data = [input_data, output_data];
L = size(data, 1);

% Seed for Reproducibility
rng(42); 

shuffled_indices = randperm(L);
shuffled_data = data(shuffled_indices, :);

tr_limit = floor(2/3 * L);

trdata = shuffled_data(1:tr_limit, :);        % Training set (Random 66%)
ckdata = shuffled_data(tr_limit+1:end, :);    % Checking set (Random 33%)

fprintf('Total samples: %d\n', L);
fprintf('Training samples: %d\n', size(trdata, 1));
fprintf('Checking samples: %d\n', size(ckdata, 1));

save('data_file.mat', 'trdata', 'ckdata');