L = size(acs323assignmentdata, 1);

% Seed for Reproducibility
rng(42); 

shuffled_indices = randperm(L);
shuffled_data = acs323assignmentdata(shuffled_indices, :);

tr_limit = floor(2/3 * L);

trdata = shuffled_data(1:tr_limit, :);        % Training set (Random 66%)
ckdata = shuffled_data(tr_limit+1:end, :);    % Checking set (Random 33%)

fprintf('Total samples: %d\n', L);
fprintf('Training samples: %d\n', size(trdata, 1));
fprintf('Checking samples: %d\n', size(ckdata, 1));

save('santoso_part_B_section_a.mat', 'trdata', 'ckdata');