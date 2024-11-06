function fileNames = listFilesInFolder(folderPath)
    % 檢查輸入的資料夾路徑是否存在
    if ~exist(folderPath, 'dir')
        error('指定的資料夾路徑不存在！');
    end

    % 取得資料夾內的所有檔案和資料夾
    filesAndFolders = dir(folderPath);
    
    % 過濾掉 . 和 .. (當前資料夾和上層資料夾) 並列出檔案名稱
    fileNames = {filesAndFolders(~[filesAndFolders.isdir]).name};
    
    % 使用正則表達式過濾掉不符合特定模式的檔案名稱
    % pattern = 'NCUS4\d{4}\.rnx'; % 匹配 NCUS4 加上四個數字加上 .rnx 的模式
    isMatch = cellfun(@(x) endsWith(x, '.rnx') && ~contains(x, '_'), fileNames);
    fileNames = fileNames(isMatch);
end