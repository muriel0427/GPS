load navigation_data_final.mat

datetime_array = datetime(data_all(:,1:6));
time_all = data_all(:,4)*3600 + data_all(:,5)*60 + data_all(:,6);
time_adjusted = mod(time_all + 8*3600, 24*3600);

colors = ['r', 'g', 'b', 'k', 'm',];
figure;
plot(time_adjusted, data_all(:, 13), 'o', 'MarkerEdgeColor', colors(1), 'MarkerFaceColor', colors(1), 'MarkerSize', 1);
title('2022/04/03-2023/03/07 GDOP estimation at NCUS4.')
xlim([min(time_adjusted), max(time_adjusted)]);
ylim([0, 20])
xlabel('Local Time (hr, UTC+8)');
ylabel('GDOP');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
legend('GDOP', 'Location', 'best');
saveas(gcf, 'C:\Users\USER\Downloads\GDOP.png');

figure;
plot(time_adjusted, data_all(:, 14), 'o', 'MarkerEdgeColor', colors(2), 'MarkerFaceColor', colors(2), 'MarkerSize', 1);
title('2022/04/03-2023/03/07 PDOP estimation at NCUS4.')
xlim([min(time_adjusted), max(time_adjusted)]);
ylim([0, 20])
xlabel('Local Time (hr, UTC+8)');
ylabel('PDOP');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
legend('PDOP', 'Location', 'best');
saveas(gcf, 'C:\Users\USER\Downloads\PDOP.png');

figure;
plot(time_adjusted, data_all(:, 15), 'o', 'MarkerEdgeColor', colors(3), 'MarkerFaceColor', colors(3), 'MarkerSize', 1);
title('2022/04/03-2023/03/07 TDOP estimation at NCUS4.')
xlim([min(time_adjusted), max(time_adjusted)]);
ylim([0, 20])
xlabel('Local Time (hr, UTC+8)');
ylabel('TDOP');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
legend('TDOP', 'Location', 'best');
saveas(gcf, 'C:\Users\USER\Downloads\TDOP.png');

figure;
plot(time_adjusted, data_all(:, 16), 'o', 'MarkerEdgeColor', colors(4), 'MarkerFaceColor', colors(4), 'MarkerSize', 1);
title('2022/04/03-2023/03/07 HDOP estimation at NCUS4.')
xlim([min(time_adjusted), max(time_adjusted)]);
ylim([0, 20])
xlabel('Local Time (hr, UTC+8)');
ylabel('HDOP');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
legend('HDOP', 'Location', 'best');
saveas(gcf, 'C:\Users\USER\Downloads\HDOP.png');

figure;
plot(time_adjusted, data_all(:, 17), 'o', 'MarkerEdgeColor', colors(5), 'MarkerFaceColor', colors(5), 'MarkerSize', 1);
title('2022/04/03-2023/03/07 VDOP estimation at NCUS4.')
xlim([min(time_adjusted), max(time_adjusted)]);
ylim([0, 20])
xlabel('Local Time (hr, UTC+8)');
ylabel('VDOP');
xticks(0:3600:86400); % 每小時一個標記
xticklabels(string(0:1:23)); % 標記的內容為0到最大小時數
legend('VDOP', 'Location', 'best');
saveas(gcf, 'C:\Users\USER\Downloads\VDOP.png');
%{
for i = 18:19
    plot(datetime_array, data_all(:, i), 'o', 'MarkerEdgeColor', colors(i-16), 'MarkerFaceColor', colors(i-16), 'MarkerSize', 1);
end
title('2022/04/03-2023/03/07 DOP estimation at NCUS4.')
ylim([0, 20])
xlabel('Date(YYYY-MM)');
ylabel('DOPs');
start_date = min(datetime_array(data_all(:, 13) ~= 0));
end_date = max(datetime_array(data_all(:, 13) ~= 0));
xlim([start_date, end_date]);
datetick('x', 'yyyy-mm','keeplimits', 'keepticks');
legend('EDOP', 'NDOP', 'best');
hold off;
%}