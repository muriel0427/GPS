load data_by_date.mat

all_localTimes = [];
all_E_coords = [];
all_N_coords = [];
all_U_coords = [];
for i = 1:numel(data_by_date)
    % 將日期時間轉換為 MATLAB 序號
    localTimes = datetime(data_by_date(i).data(:,4:6));
    
    % 收集所有的 localTimes 和 ENU_coords
    all_localTimes = [all_localTimes; localTimes];
    all_E_coords = [all_E_coords; data_by_date(i).ENU_coords(:,1)];
    all_N_coords = [all_N_coords; data_by_date(i).ENU_coords(:,2)];
    all_U_coords = [all_U_coords; data_by_date(i).ENU_coords(:,3)];
end

% 繪製圖表
figure;
subplot(3, 1, 1);
hold on;
plot(all_localTimes, all_E_coords,'b-','MarkerSize', 2);
datetick('x', ); % 將 x 軸標籤轉換為時間格式
xlabel('Local Time');
ylabel('East Offset');
xtickangle(90);
hold off;

subplot(3, 1, 2);
plot(all_localTimes, all_N_coords,'g-','MarkerSize', 2);
hold on;
datetick('x', 'HH:MM:SS'); % 將 x 軸標籤轉換為時間格式
xlabel('Local Time');
ylabel('North Offset');
xtickangle(90)
hold off;

subplot(3, 1, 3);
plot(all_localTimes, all_U_coords,'r-','MarkerSize', 2);
hold on;
datetick('x', 'HH:MM:SS'); % 將 x 軸標籤轉換為時間格式
xlabel('Local Time');
ylabel('Up Offset');
xtickangle(90)
hold off;
