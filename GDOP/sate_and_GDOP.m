% Ephemeris data folder
folderPathEphem = 'C:\Users\USER\OneDrive\桌面\navigation_information'; 
navigation_information_files = dir(fullfile(folderPathEphem, '*.mat')); % Read .mat files from ephem folder

% User position data folder
folderPathObs = 'C:\Users\USER\OneDrive\桌面\navigation_sol_findsat_with_loop'; 
obs_information_files = dir(fullfile(folderPathObs, '*.mat')); % Read .mat files from obs folder

for k = 2%:length(navigation_information_files)
    navigation_information_filePath = fullfile(folderPathEphem, navigation_information_files(k).name);
    load(navigation_information_filePath, 'ephemData', 'obsTime', 'obsData', 'yearData'); % Load ephem-related data
    
    % Load the corresponding obs file (assuming matching filenames)
    obs_information_filePath = fullfile(folderPathObs, obs_information_files(k).name);
    load(obs_information_filePath, 'navigation'); % Load obs-related data
    
    [initial.total_sample, ~] = size(obsData);
    [month, day] = DOY_to_DAY(yearData(1), yearData(2)); % Convert DOY to month/day
    fprintf('running %d/%d\n', month, day)

    tic;

    % Initialize best_sate_Combination as a cell array
    best_sate_Combination = cell(initial.total_sample, 1);

    for s = 1:initial.total_sample
        initial.sample = s;
        initial.SVID = find(~isnan(obsData(initial.sample, :)) == 1); % Get available satellite data
        
        if length(initial.SVID) < 4
            continue
        else
            % Satellite clock correction
            constant;
            
            % First layer - Get corresponding ephem and obs
            ephem_idx = ismember(ephemData(:, 1), initial.SVID);
            ephem_subData = ephemData(ephem_idx, :);
            obs_time = obsTime(initial.sample, 5); % Get obs time for this sample
            ephem_time = ephem_subData(:, 24); % Get ephem time data
            e_idx = ephem_time <= obs_time & (obs_time - ephem_time < 9000); % Filter ephem data based on time
            ephem = ephem_subData(e_idx, :);
            
            % Remove duplicate ephem entries
            [~, firstIndices, ~] = unique(ephem(:, 1), 'stable');
            duplicateIndices = setdiff(1:length(ephem(:, 1)), firstIndices);
            ephem(duplicateIndices - 1, :) = [];
            
            % Second layer - Filter for unique ephem elements
            unique_elements = unique(ephem(:, 2));
            if numel(unique_elements) > 1
                ephem = ephem(ismember(ephem(:, 2), unique_elements(2:end)), :);
            end
            
            % Now process the corresponding obs data
            obs = navigation(initial.sample, 7:9); % Get the obs data for this sample
            
            % Further processing for ephem and obs can be done here...
        end
        [minGDOP, bestCombination] = calcGdop(ephem, obsTime(initial.sample, 6), obs);
        data(s,:) = [yearData(1), month, day, obsTime(initial.sample, 1), obsTime(initial.sample, 2), obsTime(initial.sample, 3), minGDOP];
        best_sate_Combination{s} = bestCombination;
    end
    name = ['C:\Users\USER\OneDrive\桌面\best_GDOP\best_GDOP_file_', sprintf('%02d', month), sprintf('%02d', day)];
    save(name, 'data', 'best_sate_Combination')

    toc
end