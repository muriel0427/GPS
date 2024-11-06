clc; 
clear;
format long
% -------------------------------------------------------------------------
% Input the path of observation & navigation file
folderPath.obs = 'C:\Users\USER\OneDrive\桌面\新增資料夾\obs'; 
folderPath.observation = 'C:\Users\USER\OneDrive\桌面\新增資料夾\NCUS4'; 
folderPath.nav = 'C:\Users\USER\OneDrive\桌面\新增資料夾\nav'; 
folderPath.navigation = 'C:\Users\USER\OneDrive\桌面\新增資料夾\navigation';
folderpath.final = 'C:\Users\USER\OneDrive\桌面\navigation_sol';

% Input initial guess (your approximate location)
initial.position = [25 121 200]; % 現在是ecef，之後要改[lat long alt]
% input sample to determine which pseudorange measurement will be used
% "sample means:The data provided by the observation file indicates that 
% 1Hz corresponds to 1 sample data per second."
initial.sampling = 1;
% initial setting for Iteration termination condition 
initial.step_limit = 50;
initial.threshold = 1e-6;
%--------------------------------------------------------------------------

%{
% 取得資料夾中的所有檔案
files1 = dir(fullfile(folderPath.obs, '*.tar.gz')); 
files2 = dir(fullfile(folderPath.nav, '*.rnx.gz'));
% 逐一處理每個檔案
for i = 1:numel(files1)
    filename1 = files1(i).name; % 取得檔案名稱
    filepath1 = fullfile(folderPath.obs, filename1); % 取得檔案完整路徑
    % 移動檔案到B資料夾
    movefile(filepath1, folderPath.observation);
    filename2 = files2(i).name; % 取得檔案名稱
    filepath2 = fullfile(folderPath.nav, filename2); % 取得檔案完整路徑
    % 移動檔案到D資料夾
    movefile(filepath2, folderPath.navigation);

    % Data preprocess
    Data_Preprocess(folderPath); 

    movefile(fullfile(folderPath.navigation, filename2), folderPath.nav)
    % 移動檔案回A資料夾
    movefile(fullfile(folderPath.observation, filename1), folderPath.obs);
end
%}

solver(initial);


%merge_data(folderpath)

  


