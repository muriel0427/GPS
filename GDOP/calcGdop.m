function [min_GDOP, best_sate_combination] = calcGdop(ephem, gpsTime, obs)
    % calcGdop 計算所有可能衛星組合的 GDOP
    %
    % 輸入:
    %   ephem - 星曆資料矩陣（每行對應一顆衛星）
    %   gpsTime - GPS 時間
    %   obs - 觀測者位置（根據 ecef 函數的需求，例如經度、緯度、高度）
    %
    % 輸出:
    %   GDOP_List - 所有組合的 GDOP 值（向量）
    %   Combinations_List - 對應每個 GDOP 的衛星組合（單元格陣列）

    % 將觀測者位置轉換為 ECEF 坐標系
    obsXYZ = ecef(obs);
    obsX = obsXYZ(1);
    obsY = obsXYZ(2);
    obsZ = obsXYZ(3);
    
    % 獲取衛星數量
    numSats = size(ephem, 1);
    
    % 確保至少有四顆衛星
    if numSats < 4
        error('至少需要四顆衛星來計算 GDOP。');
    end

    % 預計算在給定 GPS 時間下的衛星位置
    satLoc = findsat(ephem, gpsTime);
    satPositions = satLoc(:, 3:5);  % 假設第 3, 4, 5 列為 X, Y, Z 坐標

    % 初始化 GDOP 列表和組合列表
    GDOP_List = [];
    Combinations_List = {};  % 使用單元格陣列以存儲不同大小的組合

    % 迭代所有可能的組合大小，從 4 到 numSats
    for k = 4:numSats
        combinations = nchoosek(1:numSats, k);
        numComb = size(combinations, 1);
        
        % 迭代每個組合
        for i = 1:numComb
            currentCombo = combinations(i, :);
            currentSatPos = satPositions(currentCombo, :);
            
            % 提取 X, Y, Z 坐標
            satX = currentSatPos(:, 1);
            satY = currentSatPos(:, 2);
            satZ = currentSatPos(:, 3);
            
            % 計算與每顆衛星的距離
            r = sqrt((satX - obsX).^2 + (satY - obsY).^2 + (satZ - obsZ).^2);
            
            % 構建 'A' 矩陣
            A = [ -((satX - obsX) ./ r), ...
                  -((satY - obsY) ./ r), ...
                  -((satZ - obsZ) ./ r), ...
                  -ones(k, 1) ];
            
            % 檢查 A 矩陣是否滿秩，以避免奇異矩陣
            if rank(A) < 4
                continue;  % 如果 A 矩陣秩不足，跳過此組合
            end
            
            % 計算協因子矩陣 'Q'（正常方程矩陣的逆）
            Q = inv(A' * A);
            
            % 提取對角元素
            qXX = Q(1,1);
            qYY = Q(2,2);
            qZZ = Q(3,3);
            qtt = Q(4,4);
            
            % 計算 GDOP
            GDOP = sqrt(qXX + qYY + qZZ + qtt);
            
            % 將 GDOP 和對應的組合儲存起來
            GDOP_List(end+1, 1) = GDOP;  %#ok<AGROW>
            Combinations_List{end+1, 1} = currentCombo;  %#ok<AGROW>
        end
    end

    % 將結果排序（從小到大）
    [GDOP_List, sortIdx] = sort(GDOP_List);
    Combinations_List = Combinations_List(sortIdx);

    min_GDOP = GDOP_List(1);
   
    % 獲取最佳衛星組合的 ID
    bestComboIndices = Combinations_List{1};  % 最佳組合的索引
    best_sate_combination = ephem(bestComboIndices, 1);  % 假設第一列是衛星 ID
end
