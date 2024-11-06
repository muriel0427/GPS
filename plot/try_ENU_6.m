load navigation_data_final.mat
data_all = real(data_all);
datetime_array = datetime(data_all(:,1:6));

colors = ['r', 'g', 'b', 'k', 'm'];
hold on;
for i = 13:17
    plot(datetime_array, data_all(:, i), 'o', 'MarkerEdgeColor', colors(i-12), 'MarkerFaceColor', colors(i-12), 'MarkerSize', 1);
end
title('2022/04/03-2023/03/07 DOP estimation at NCUS4.')
ylim([0, 20])
xlabel('Date(YYYY-MM)');
ylabel('DOPs');
start_date = min(datetime_array(data_all(:, 13) ~= 0));
end_date = max(datetime_array(data_all(:, 13) ~= 0));
xlim([start_date, end_date]);
datetick('x', 'yyyy-mm','keeplimits', 'keepticks');
legend('GDOP', 'PDOP', 'TDOP', 'HDOP', 'VDOP', 'Location', 'best');
hold off;

saveas(gcf, 'C:\Users\USER\Downloads\DOPs.png');