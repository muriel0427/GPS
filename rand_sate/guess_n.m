function [obsPos] = guess_n(receiver_position, sate_position, num_sate)
format long
%計算偽距
pseudoR = sqrt(sum((sate_position - receiver_position).^2, 2));
% 定義光速
c = 299792458 * 0.000157; % 光速
% 設置擾動的均值和標準差
mean_dist = 0;       % 擾動均值
sigma_dist = 0.0001;  % 擾動標準差（可根據需要調整）

% 生成擾動值
disturbance = normrnd(mean_dist, sigma_dist, size(pseudoR));
pseudoR = pseudoR + disturbance;
% 設定衛星數量和初始猜測
guess = [0 0 0];
stop = 0;

while (stop == 0)
    % 創建猜測矩陣
    guessmatrix = repmat(guess, num_sate, 1);
    
    % 計算從猜測位置到衛星的距離
    delXYZ = sate_position - guessmatrix;
    range = sqrt(sum(delXYZ.^2, 2));
    
    % 計算時間補償
    tcorr = range / c;
    
    % 計算新的 range
    delXYZ = sate_position - guessmatrix;
    range = sqrt(sum(delXYZ.^2, 2));
    
    % 計算 l 和 A 矩陣
    l = pseudoR - range;
    cmatrix = c * ones(num_sate, 1);
    pmatrix = range * ones(1, 3);
    A = delXYZ ./ pmatrix;
    A = -[A, cmatrix];
    
    % 求解 deltaPOS
    deltaPOS = A \ l;
    
    % 更新猜測位置
    obsPos = [guess, 0] + deltaPOS';
    
    % 檢查停止條件
    if (norm(obsPos(1:3) - guess) < 1e-6)
        stop = 1;
    end
    
    % 更新猜測位置
    guess = obsPos(1:3);
end

% 輸出結果
disp('最終位置估算：');
disp(obsPos(1:4));
end