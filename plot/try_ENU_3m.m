%function remate_data_ENU()
load navigation_data_final.mat

% 計算數據的平均值和標準差
mean_value = mean(data_all(:,7:9));

ENU_coords = lla2enu(data_all(:,7:9), mean_value, 'flat');

[mean_ENU, std_deviation] = custom_std(ENU_coords);

% 找到超出兩個標準差的數據的索引
outlier_idx_E = find(abs(ENU_coords(:,1) - mean_ENU(1)) < 2*std_deviation(1));
outlier_idx_N = find(abs(ENU_coords(:,2) - mean_ENU(2)) < 2*std_deviation(2));
outlier_idx_U = find(abs(ENU_coords(:,3) - mean_ENU(3)) < 2*std_deviation(3));

outlier_idx_intersection = intersect(intersect(outlier_idx_E, outlier_idx_N), outlier_idx_U);
% 從 data_all 中刪除超出1個標準差的數據
ENU_coords = ENU_coords(outlier_idx_intersection, :);

data_all = data_all(outlier_idx_intersection, :);

time_all = data_all(:,4)*3600 + data_all(:,5)*60 + data_all(:,6);

[~, ~, ic] = unique(time_all);

%mean_values_per_time_E = accumarray(ic, ENU_coords(:,1), [], @mean);
std_devs_per_time_E = accumarray(ic, ENU_coords(:,1), [], @std);
std_devs_per_time_N = accumarray(ic, ENU_coords(:,2), [], @std);
std_devs_per_time_U = accumarray(ic, ENU_coords(:,3), [], @std);

figure;
plot(mod(unique(ic) + 8*3600, 86400), std_devs_per_time_E, 'rx','MarkerSize', 3); 
line([min(unique(ic)), max(unique(ic))], [0, 0], 'Color', 'black', 'LineStyle', '-');
title('Standard Deviation of Position "East" offset (per sec)')
%ylim([0, 12])
xlabel('Local Time (hr)(UTC+8)');
ylabel('Standard Deviation (m)');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
hold off;
xlim([min(time_adjusted), max(time_adjusted)]);
saveas(gcf, 'C:\Users\USER\Downloads\STD_East_offset.png');


figure;
plot(mod(unique(ic) + 8*3600, 86400), std_devs_per_time_N, 'gx','MarkerSize', 3); 
line([min(unique(ic)), max(unique(ic))], [0, 0], 'Color', 'black', 'LineStyle', '-');
title('Standard Deviation of Position "North" offset (per sec)')
%ylim([0, 12])
xlabel('Local Time (hr)(UTC+8)');
ylabel('Standard Deviation (m)');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
hold off;
xlim([min(time_adjusted), max(time_adjusted)]);
saveas(gcf, 'C:\Users\USER\Downloads\STD_North_offset.png');

figure;
plot(mod(unique(ic) + 8*3600, 86400), std_devs_per_time_U, 'bx','MarkerSize', 3); 
line([min(unique(ic)), max(unique(ic))], [0, 0], 'Color', 'black', 'LineStyle', '-');
title('Standard Deviation of Position "Up" offset (per sec)')
%ylim([0, 12])
xlabel('Local Time (hr)(UTC+8)');
ylabel('Standard Deviation (m)');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
hold off;
xlim([min(time_adjusted), max(time_adjusted)]);
saveas(gcf, 'C:\Users\USER\Downloads\STD_Up_offset.png');
