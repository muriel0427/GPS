%function merge_data(folderpath)
% 輸入資料夾路徑
folderpath.final = 'C:\Users\USER\OneDrive\桌面\navigation_sol_findsat_with_loop';
% 讀取資料夾中的所有.mat檔案
files = dir(fullfile(folderpath.final, '*.mat'));

% 初始化儲存資料的變數
data_all = [];

% 逐一讀取每個.mat檔案
for i = 1:length(files)
    % 讀取.mat檔案中的資料
    file_path = fullfile(folderpath.final, files(i).name);
    load(file_path);  % 讀取資料到變數data中

    % 刪除全為0或NaN的列
    data = navigation(~all(navigation == 0 | isnan(navigation), 2), :);

    % 將資料加入到整合的變數中
    data_all = [data_all; data];
end

% 將整合後的資料存儲為一個新的.mat檔案
save('navigation_data_final_findsat_with_loop.mat', 'data_all');
%end
