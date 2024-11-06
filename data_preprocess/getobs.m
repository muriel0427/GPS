function [obsTime, observation] = getobs(infile)
constant;
buff = getline(infile);
numobs = 0;
observation = nan(60, 32);
obsTime = nan(60,5);

    while (~isempty(buff))
        if (contains(buff, 'END OF HEADER'))
            break;
        elseif (contains(buff, 'TYPES OF OBSERV'))
            numobs = sscanf(buff, '%*s %d');
        end
        buff = getline(infile);
    end

    if (feof(infile))
        return;
    end
    i = 0;
    j = 1; 
    while (~feof(infile))
        buff = getline(infile);
        if (feof(infile))
            break;
        end
        
        if startsWith(buff, '>')
           
           time = sscanf(buff(3:end),'%d %d %d %d %d %f' );

           % Calculate drift
           drift = abs(time(6) - round(time(6)));

           obsTime(j,1) = time(4); % HH 
           obsTime(j,2) = time(5); % MM
           obsTime(j,3) = time(6); % SS 
           obsTime(j,4) = drift; % drift 

           % If we successfully read time, return it.
            if isempty(time)
                continue;
            end
        
            numsats = time(8);

            if numsats > 0
                % get the gpstime
                gpstime = timeConversion(time(1)-2000,time(2),time(3),time(4),time(5),time(6));
                gpstime_in_gpsweek = mod(timeConversion(time(1)-2000,time(2),time(3),time(4),time(5),time(6)),604800);
                obsTime(j,5) = gpstime;
                obsTime(j,6) = gpstime_in_gpsweek;

                % Treat ephemeris as valid 2 hrs before or 4 hrs after
                % time of ephemeris.
            end
           i = i + 1;
           j = j + 1;
        end

        if startsWith(buff, 'G')  % Check if line starts with 'G'
            data_part = buff(2:end); % Adjust index to skip the satellite identifier

            % Modify the format specifier based on the data structure
            ROW = sscanf(data_part, '%f %f %f %f %f %f %f %f %f %f %f %f');
            observation(i,ROW(1)) = ROW(2);
            if isempty(ROW)
                continue;  
            end         
        end
    end
    frewind(infile);
    return;