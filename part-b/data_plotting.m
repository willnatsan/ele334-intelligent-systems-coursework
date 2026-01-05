% Extract the 5th column
col5 = acs323assignmentdata(:, 5);

% Find where the data is NOT a NaN
validIndices = ~isnan(col5);

% Plot only the valid points
plot(col5(validIndices), '-o');
title('Cleaned Plot (NaNs Removed)');