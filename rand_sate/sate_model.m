load Navigation_Imformation.mat
% 輸入參數
startTime = [2022,04,03,00,00,00]; % 開始時間
endTime = [2022,04,03,00,01,00];   % 結束時間

% 將時間點轉換為 datetime 對象
startDateTime = datetime(startTime);
endDateTime = datetime(endTime);

% 計算時間差
timeDifference = endDateTime - startDateTime;

% 將時間差轉換為秒數
timeDifferenceInSeconds = seconds(timeDifference);

gpstime_in_gpsweek_start = mod(timeConversion(startTime(1)-2000, startTime(2),startTime(3),startTime(4),startTime(5),startTime(6)),604800);
for i = 0:timeDifferenceInSeconds
gpstime_in_gpsweek_end = gpstime_in_gpsweek_start + i;
sate_pos = findsat(ephemData, gpstime_in_gpsweek_end);
end

% 繪圖
figure;
for i = 1:length(filteredTimeStamps)
    % 清空當前圖像
    clf;
    
    % 畫衛星位置
    plot3(filteredLongitudes(i), filteredLatitudes(i), filteredHeights(i), 'o', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
    hold on;
    
    % 設置圖形顯示範圍
    xlim([-180 180]);
    ylim([-90 90]);
    zlim([0 max(filteredHeights)]);
    
    % 設置標籤和標題
    xlabel('Longitude');
    ylabel('Latitude');
    zlabel('Height');
    title(sprintf('Satellite Position at %s', datestr(filteredTimeStamps(i))));
    
    % 畫出時間戳
    text(filteredLongitudes(i), filteredLatitudes(i), filteredHeights(i), datestr(filteredTimeStamps(i)), 'VerticalAlignment', 'bottom');
    
    % 設置視角
    view(3);
    
    % 更新圖像
    pause(0.1); % 根據需要調整動畫速度
end
