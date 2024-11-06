% Load data
load navigation_data_final.mat

% Calculate mean and standard deviation of data
mean_value = mean(data_all(:,7:9));
ENU_coords = lla2enu(data_all(:,7:9), mean_value, 'flat');
[mean_ENU, std_deviation] = custom_std(ENU_coords);

% Find indices of data points outside two standard deviations
outlier_idx_E = find(abs(ENU_coords(:,1) - mean_ENU(1)) < 2*std_deviation(1));
outlier_idx_N = find(abs(ENU_coords(:,2) - mean_ENU(2)) < 2*std_deviation(2));
outlier_idx_U = find(abs(ENU_coords(:,3) - mean_ENU(3)) < 2*std_deviation(3));
outlier_idx_intersection = intersect(intersect(outlier_idx_E, outlier_idx_N), outlier_idx_U);

% Remove outliers from data_all and ENU_coords
ENU_coords = ENU_coords(outlier_idx_intersection, :);
data_all = data_all(outlier_idx_intersection, :);

% Calculate time in seconds for each data point
time_all = data_all(:,4)*3600 + data_all(:,5)*60 + data_all(:,6);

% Calculate standard deviation of East offset per second
[~, ~, ic] = unique(time_all);
std_devs_per_time_E = accumarray(ic, ENU_coords(:,1), [], @std);
std_devs_per_time_N = accumarray(ic, ENU_coords(:,2), [], @std);
%std_devs_per_time_U = accumarray(ic, ENU_coords(:,3), [], @std);

std_devs_per_time = [std_devs_per_time_E std_devs_per_time_N];%std_devs_per_time_U];

ENU_coords_norm = vecnorm(ENU_coords(:,1:2), 2, 2);
std_devs_per_time_norm = vecnorm(std_devs_per_time, 2, 2);

% Adjust time to UTC+8 and wrap around to 0-8 range
time_adjusted = mod(time_all + 8*3600, 24*3600);

figure;
yyaxis right; % Use right y-axis
plot(mod(unique(ic) + 8*3600, 86400), std_devs_per_time_norm, 'rx','MarkerSize', 3); 
line([min(unique(ic)), max(unique(ic))], [0, 0], 'Color', 'black', 'LineStyle', '-');
title('Positioning Offsets (04/03/22-03/07/23)')
%ylim([0, 12])
xlabel('Local Time (hr)(UTC+8)');
ylabel('Standard Deviation (m)');
xticks(0:3600:86400); % Every hour from 0 to 8, then 24
xticklabels(string(0:1:23)); % Label from 0 to 8, then 0 again for 24
hold on;

% Plot East offset over time
yyaxis left; % Use left y-axis
plot(time_adjusted, ENU_coords_norm, 'b.','MarkerSize', 0.001); 
line([min(time_adjusted), max(time_adjusted)], [mean_ENU(1), mean_ENU(1)], 'Color', 'black', 'LineStyle', '-');
%ylim([-100, 100])
ylabel('Distance from Mean (m)');
hold off;
xlim([min(time_adjusted), max(time_adjusted)]);

saveas(gcf, 'C:\Users\USER\Downloads\Positioning_Offsets.png');


