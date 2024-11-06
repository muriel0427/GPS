function Data_Preprocess(folderPath)

    gzFiles_nav = dir(fullfile(folderPath.navigation, '*.gz'));
    gzFiles_obs = dir(fullfile(folderPath.observation, '*.tar.gz'));

    yearData = nan(length(gzFiles_nav),2);

    ionData = nan(4,2,length(gzFiles_nav));

    ephemData = nan(480,24,length(gzFiles_nav));
    ephemTime = nan(480,5,length(gzFiles_nav));

    obsData = nan(86410,32,length(gzFiles_obs));
    obsTime = nan(86410,6,length(gzFiles_obs));

    % navigation-------------------------------------------------------------
    for i = 1:length(gzFiles_nav)
        gzFile_nav = gzFiles_nav(i);  % gzFiles_nav(i)
        fileName_nav = gzFile_nav.name;
    
      % get Year and DOY
        pattern = '(\d{4})(\d{3})'; 
        match = regexp(fileName_nav, pattern, 'tokens', 'once');
        year = str2double(match{1});
        dayOfYear = str2double(match{2});

        yearData(i,:) = [year, dayOfYear];

      % unzip navigation file
        gzFilePath_nav = fullfile(folderPath.navigation, fileName_nav);
        FilePath_nav = gunzip(gzFilePath_nav, folderPath.navigation);
        rinexNav = FilePath_nav{1};
        fid = fopen(rinexNav);
    
      % get ion 
        [I] = getion(fid);

        ionData(:,:,i) = I;
    
     % gat ephem  
        [ephem_Data, ephem_Time] = getephem(rinexNav);
    
        [m_nav,n_nav] = size(ephem_Data);
        [o_nav,p_nav] = size(ephem_Time);
    
        ephemData(1:m_nav,1:n_nav,i) = ephem_Data;
        ephemTime(1:o_nav,1:p_nav,i) = ephem_Time;
        
      % close and delete unzip nav file  
        fclose(fid);
        delete(rinexNav);
    end
  
  % observation------------------------------------------------------------
    for j = 1:length(gzFiles_obs)
    gzFile_obs = gzFiles_obs(j); % gzFiles_obs(j)
    fileName_obs = gzFile_obs.name;

    % unzip observation file 
    gzFilePath_obs = fullfile(folderPath.observation, fileName_obs);
    
    try
        FilePath_obs = untar(gzFilePath_obs, folderPath.observation);

        % check if extraction was successful
        if isempty(FilePath_obs)
            disp(['Skipping ', fileName_obs, ' as it is corrupt or damaged.']);
            continue;  % Skip to the next iteration of the loop
        end

        [fileNames] = listFilesInFolder(FilePath_obs{1});

        if isempty(fileNames)
           disp([fileName_obs, ' No Data.']);
           break;
        end    
        obs_Data_day = [];
        obs_Time_day = [];  

        for k = 1:length(fileNames) 
            path_obs = [FilePath_obs{1},fileNames{k}]; % fileNames{k}
            rinexobs = fopen(path_obs);

            % get file size
            fseek(rinexobs, 0, 'eof');
            fileSize = ftell(rinexobs);
            frewind(rinexobs);

            % check if file is empty
            if fileSize > 0
                [obs_Time, obs_Data] = getobs(rinexobs);

                % 
                obs_Time_day = [obs_Time_day ; obs_Time];
                obs_Data_day = [obs_Data_day ; obs_Data];
            end

            % close the file
            fclose(rinexobs);
        end
        [m,n] = size(obs_Data_day);
        [o,p] = size(obs_Time_day);

        obsData(1:m,1:n,j) = obs_Data_day;
        obsTime(1:o,1:p,j) = obs_Time_day;
        rmdir(FilePath_obs{1}, 's');
    catch ME
        disp(['Error processing ', fileName_obs]);
        % Optionally, you can log the error or take other actions here
    end
end
    obsData(obsData == 0) = NaN;
    [month, day] = DOY_to_DAY(yearData(1), yearData(2));
    name = ['C:\Users\USER\OneDrive\桌面\navigation_information\navigation_information_file_', sprintf('%02d', month), sprintf('%02d', day)];
    save(name,"yearData","ionData","ephemTime","ephemData","obsTime","obsData")
end