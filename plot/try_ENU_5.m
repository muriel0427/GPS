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

time_all = nan(length(data_all), 1);

for i = 1:length(data_all)
    time_all(i) = data_all(i,4)*3600 + data_all(i,5)*60 + data_all(i,6);
end

q1_E = quantile(ENU_coords(:,1), 0.25, 2); % 第一四分位數
q3_E = quantile(ENU_coords(:,1), 0.75, 2); % 第三四分位數

q1_N = quantile(ENU_coords(:,2), 0.25, 2); % 第一四分位數
q3_N = quantile(ENU_coords(:,2), 0.75, 2); % 第三四分位數

q1_U = quantile(ENU_coords(:,3), 0.25, 2); % 第一四分位數
q3_U = quantile(ENU_coords(:,3), 0.75, 2); % 第三四分位數

figure;
subplot(3, 1, 1);
hold on;
plot(time_all, ENU_coords(:,1), 'r.','MarkerSize', 1); 
plot(time_all, q1_E, 'k-','LineWidth',0.001); % 下限
plot(time_all, q3_E, 'k-','LineWidth',0.001); % 上限
line([min(time_all), max(time_all)], [0, 0], 'Color', 'black', 'LineStyle', '-');
title('NCUS4 Position "East" offset per sceond based on position average.')
xlabel('UTC Time (24-hour)');
ylabel('East Offset (m)');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
hold off;

subplot(3, 1, 2);
hold on;
plot(time_all, ENU_coords(:,2), 'g.','MarkerSize',1); 
plot(time_all, q1_N, 'k-','LineWidth',0.001); % 下限
plot(time_all, q3_N, 'k-','LineWidth',0.001); % 上限
line([min(time_all), max(time_all)], [0, 0], 'Color', 'black', 'LineStyle', '-');
title('NCUS4 Position "North" offset per sceond based on position average.')
xlabel('UTC Time (24-hour)');
ylabel('North Offset (m)');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
hold off;

subplot(3, 1, 3);
hold on;
plot(time_all, ENU_coords(:,3), 'b.','MarkerSize', 1); 
plot(time_all, q1_U, 'k-','LineWidth',0.001); % 下限
plot(time_all, q3_U, 'k-','LineWidth',0.001); % 上限
line([min(time_all), max(time_all)], [0, 0], 'Color', 'black', 'LineStyle', '-');
title('NCUS4 Position "Up" offset per sceond based on position average.')
xlabel('UTC Time (24-hour)');
ylabel('Up Offset (m)');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
hold off;
%{
% 生成連續時間
start_time = datetime('now'); % 現在時間
end_time = start_time + minutes(1); % 結束時間，加一分鐘
time_points = start_time:seconds(1):end_time; % 每秒一個時間點

% 生成隨機資料
num_data_points = numel(time_points); % 時間點數量
data = rand(num_data_points, 100); % 每個時間點有100個隨機資料點

% 將時間點轉換為序數，用於繪製
time_points_num = datenum(time_points);

% 計算每個時間點的四分位數
q1 = quantile(data, 0.25, 2); % 第一四分位數
q3 = quantile(data, 0.75, 2); % 第三四分位數

% 繪製資料和四分位線
figure;
plot(time_points_num, data, 'k.', 'MarkerSize',0.01);
hold on;
plot(time_points_num, q1, 'r-','LineWidth',1); % 下限
plot(time_points_num, q3, 'b-','LineWidth',1); % 上限
datetick('x', 'HH:MM:SS'); % 格式化 x 軸為時間
xlabel('時間');
ylabel('值');
title('隨機資料點在一分鐘內的分佈和四分位線');
legend('隨機資料', '第一四分位數', '中位數', '第三四分位數', 'Location', 'Best');
hold off;
%}