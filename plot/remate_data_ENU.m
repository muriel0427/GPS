 %function remate_data_ENU()
load navigation_data_final_findsat_with_loop.mat

% 計算數據的平均值和標準差
mean_value = mean(data_all(:,7:9));

ENU_coords = lla2enu(data_all(:,7:9), mean_value, 'flat');

[mean_ENU, std_deviation] = custom_std(ENU_coords);
%{
% 找到超出兩個標準差的數據的索引
outlier_idx_E = find(abs(ENU_coords(:,1) - mean_ENU(1)) < 2*std_deviation(1));
outlier_idx_N = find(abs(ENU_coords(:,2) - mean_ENU(2)) < 2*std_deviation(2));
outlier_idx_U = find(abs(ENU_coords(:,3) - mean_ENU(3)) < 2*std_deviation(3));

outlier_idx_intersection = intersect(intersect(outlier_idx_E, outlier_idx_N), outlier_idx_U);
% 從 data_all 中刪除超出2個標準差的數據
ENU_coords = ENU_coords(outlier_idx_intersection, :);

data_all = data_all(outlier_idx_intersection, :);
%}
time_all = nan(length(data_all), 1);

for i = 1:length(data_all)
    time_all(i) = data_all(i,4)*3600 + data_all(i,5)*60 + data_all(i,6);
end

figure;
subplot(3, 1, 1);
hold on;
plot(mod(time_all + 8*3600, 86400), ENU_coords(:,1), 'rx','MarkerSize', 1); 
%line([min(time_all), max(time_all)], [2*std_deviation(1), 2*std_deviation(1)], 'Color', 'black', 'LineStyle', '-');
line([min(time_all), max(time_all)], [0, 0], 'Color', 'black', 'LineStyle', '-');
%line([min(time_all), max(time_all)], [-2*std_deviation(1), -2*std_deviation(1)], 'Color', 'black', 'LineStyle', '-');
title('NCUS4 Position "East" offset per sceond based on position average.')
%ylim([-100, 100])
xlabel('Local Time (hr)(UTC+8)');
ylabel('East Offset(m)');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
xlim([min(mod(time_all + 8*3600, 86400)), max(mod(time_all + 8*3600, 86400))]);
hold off;

subplot(3, 1, 2);
hold on;
plot(mod(time_all + 8*3600, 86400), ENU_coords(:,2), 'gx','MarkerSize', 1); 
%line([min(time_all), max(time_all)], [2*std_deviation(2), 2*std_deviation(2)], 'Color', 'black', 'LineStyle', '-');
line([min(time_all), max(time_all)], [0, 0], 'Color', 'black', 'LineStyle', '-');
%line([min(time_all), max(time_all)], [-2*std_deviation(2), -2*std_deviation(2)], 'Color', 'black', 'LineStyle', '-');
title('NCUS4 Position "North" offset per sceond based on position average.')
%ylim([-100, 100])
xlabel('Local Time (hr)(UTC+8)');
ylabel('North Offset(m)');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數0
xlim([min(mod(time_all + 8*3600, 86400)), max(mod(time_all + 8*3600, 86400))]);
hold off;

subplot(3, 1, 3);
hold on;
plot(mod(time_all + 8*3600, 86400), ENU_coords(:,3), 'bx','MarkerSize', 1); 
%line([min(time_all), max(time_all)], [2*std_deviation(3), 2*std_deviation(3)], 'Color', 'black', 'LineStyle', '-');
line([min(time_all), max(time_all)], [0, 0], 'Color', 'black', 'LineStyle', '-');
%line([min(time_all), max(time_all)], [-2*std_deviation(3), -2*std_deviation(3)], 'Color', 'black', 'LineStyle', '-');
title('NCUS4 Position "Up" offset per sceond based on position average.')
%ylim([-300, 300])
xlabel('Local Time (hr)(UTC+8)');
ylabel('Up Offset(m)');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
xlim([min(mod(time_all + 8*3600, 86400)), max(mod(time_all + 8*3600, 86400))]);
hold off;

saveas(gcf, 'C:\Users\USER\Downloads\111.png');
%{
% 計算每秒區間的資料數
secondly_counts = histcounts(time_all, 0:1:86400);

% 繪製折線圖
figure;
plot(0:86399, secondly_counts, '-o', 'LineWidth', 1, 'MarkerSize', 1);
title('Number of Data Points per Second');
xlabel('Second of the Day');
ylabel('Number of Data Points');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23));
xlim([-5, 86405]);
%}