% 1. Calculate Min and Max for each column
min_vals = min(acs323assignmentdata);
max_vals = max(acs323assignmentdata);
ranges = max_vals - min_vals;

% 2. Create labels for the columns (assuming last column is Output)
num_vars = size(acs323assignmentdata, 2);
var_names = cell(1, num_vars);
for i = 1:num_vars-1
    var_names{i} = sprintf('Input_%d', i);
end
var_names{end} = 'Output';

% 3. Format and display as a Table
bounds_table = table(min_vals', max_vals', ranges', ...
    'VariableNames', {'Lower_Bound', 'Upper_Bound', 'Range'}, ...
    'RowNames', var_names);

disp('--- Data Bounds Analysis ---');
disp(bounds_table);