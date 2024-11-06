load navigation_data_final_findsat_with_loop.mat

datetime_array = datetime(data_all(:,1:6));

% 計算數據的平均值和標準差
mean_value = mean(data_all(:,7:9));

ENU_coords = lla2enu(data_all(:,7:9), mean_value, 'flat');

% 繪製圖形
figure;
subplot(3, 1, 1);
hold on;
plot(datetime_array, ENU_coords(:,1), 'rx','MarkerSize', 1); 
%line([min(time_all), max(time_all)], [0, 0], 'Color', 'black', 'LineStyle', '-');
title('NCUS4 Position "East" offset per sceond based on position average.')
ylim([-50, 50])
xlabel('Date(YYYY-MM)');
ylabel('East Offset(m)');
start_date = min(datetime_array(ENU_coords(:,3) ~= 0));
end_date = max(datetime_array(ENU_coords(:,3) ~= 0));
xlim([start_date, end_date]);
datetick('x', 'yyyy-mm','keeplimits', 'keepticks');
hold off;

subplot(3, 1, 2);
hold on;
plot(datetime_array, ENU_coords(:,2), 'gx','MarkerSize', 1); 
%line([min(time_all), max(time_all)], [0, 0], 'Color', 'black', 'LineStyle', '-');
title('NCUS4 Position "North" offset per sceond based on position average.')
ylim([-50, 50])
xlabel('Date(YYYY-MM)');
ylabel('North Offset(m)');
start_date = min(datetime_array(ENU_coords(:,3) ~= 0));
end_date = max(datetime_array(ENU_coords(:,3) ~= 0));
xlim([start_date, end_date]);
datetick('x', 'yyyy-mm','keeplimits', 'keepticks');
hold off;


subplot(3, 1, 3);
hold on;
plot(datetime_array, ENU_coords(:,3), 'bx','MarkerSize', 1); 
%line([min(time_all), max(time_all)], [0, 0], 'Color', 'black', 'LineStyle', '-');
title('NCUS4 Position "Up" offset per sceond based on position average.')
ylim([-100, 100])
xlabel('Date(YYYY-MM)');
ylabel('Up Offset(m)');
start_date = min(datetime_array(ENU_coords(:,3) ~= 0));
end_date = max(datetime_array(ENU_coords(:,3) ~= 0));
xlim([start_date, end_date]);
datetick('x', 'yyyy-mm','keeplimits', 'keepticks');
hold off;

%saveas(gcf, 'C:\Users\USER\Downloads\year.png');