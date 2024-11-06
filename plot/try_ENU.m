load navigation_data_final.mat

% 計算數據的平均值和標準差
mean_value = mean(data_all(:,7:9));

ENU_coords = lla2enu(data_all(:,7:9), mean_value, 'flat');

time_all = data_all(:,4)*3600 + data_all(:,5)*60 + data_all(:,6);

[~, ~, ic] = unique(time_all);



%mean_values_per_time_E = accumarray(ic, ENU_coords(:,1), [], @mean);
std_devs_per_time_E = accumarray(ic, ENU_coords(:,1), [], @std);


figure;
%subplot(3, 1, 1);
hold on;
plot(unique(ic), std_devs_per_time_E, 'rx','MarkerSize', 2); 
line([min(unique(ic)), max(unique(ic))], [0, 0], 'Color', 'black', 'LineStyle', '-');
title('Position "East" offset per sceond based on hourly position average.')
ylim([0, 50])
xlabel('Local Time');
ylabel('East Offset(m)');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
hold off;