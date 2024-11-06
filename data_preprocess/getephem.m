function [ephem_Data, ephem_Time] = getephem(folderPath) 

infile = fopen(folderPath);
while ~feof(infile)
    buff = getline(infile);

    % Check for "END OF HEADER" and skip lines until G data starts
    if contains(buff, 'END OF HEADER')
        % Initialize a struct to store data for the current time point
        ephemData = struct('Time', [], 'Data', []);

        while ~feof(infile)
            buff = getline(infile);
            buff = strrep(buff, 'D', 'E');

            if startsWith(buff, 'G')
                ROW1 = sscanf(buff, 'G%d %d %d %d %d %d %d%e%e%e');
                HH = ROW1(5); MM = ROW1(6); SS = ROW1(7);

                % Calculate drift
                drift = mod(2 * 3600 - mod((HH * 3600 + MM * 60 + SS), 2 * 3600), 2 * 3600);

                navTime = struct('SVID', ROW1(1), 'HH', HH, 'MM', MM, 'SS', SS, 'drift', drift);

                % Add drift to ephemData.Time
                ephemData.Time = [ephemData.Time; navTime.SVID, navTime.HH, navTime.MM, navTime.SS, navTime.drift];

                toc = timeConversion(ROW1(2)-2000, ROW1(3), ROW1(4), ROW1(5), ROW1(6), ROW1(7));

                if 0 %abs(ComputeDiffSec(mod(sec+3600, SECONDS_IN_WEEK), gpstime)) > 10800
                    for i = 0:6
                        buff = getline(infile);
                        if isempty(buff)
                            return;
                        end
                    end
                else
                    % Initialize a struct to store data for the current satellite
                    satelliteData = struct('Ephemerides', zeros(1, 24));

                    buff = getline(infile); buff = strrep(buff, 'D', 'E'); ROW2 = sscanf(buff, '   %e%e%e%e', 82);
                    buff = getline(infile); buff = strrep(buff, 'D', 'E'); ROW3 = sscanf(buff, '   %e%e%e%e', 82);
                    buff = getline(infile); buff = strrep(buff, 'D', 'E'); ROW4 = sscanf(buff, '   %e%e%e%e', 82);
                    buff = getline(infile); buff = strrep(buff, 'D', 'E'); ROW5 = sscanf(buff, '   %e%e%e%e', 82);
                    buff = getline(infile); buff = strrep(buff, 'D', 'E'); ROW6 = sscanf(buff, '   %e%e%e%e', 82);
                    buff = getline(infile); buff = strrep(buff, 'D', 'E'); ROW7 = sscanf(buff, '   %e%e%e%e', 82);
                    buff = getline(infile); buff = strrep(buff, 'D', 'E'); ROW8 = sscanf(buff, '   %e%e%e%e', 82);

                    % fill in a row of E
                    satelliteData.Ephemerides(1) = ROW1(1);
                    % get the gpsweek
                    [dummy, satelliteData.Ephemerides(2)] = timeConversion(ROW1(2)-2000, ROW1(3), ROW1(4), 0, 0, 0);  %need to convert a GMT time to GPS
                    satelliteData.Ephemerides(4) = ROW4(1); %toe
                    satelliteData.Ephemerides(3) = satelliteData.Ephemerides(2) * 604800 + satelliteData.Ephemerides(4);  %weeks*604800 + toe
                    satelliteData.Ephemerides(5) = ROW3(2); %ecc;
                    satelliteData.Ephemerides(6) = ROW3(4); %sqrtA;
                    satelliteData.Ephemerides(7) = ROW5(3); %w0
                    satelliteData.Ephemerides(8) = ROW2(4);  %M0
                    satelliteData.Ephemerides(9) = ROW4(3); %OMEGA
                    satelliteData.Ephemerides(10) = ROW5(4); %OMEGA dot
                    satelliteData.Ephemerides(11) = ROW2(3);  %deltaN
                    satelliteData.Ephemerides(12) = ROW5(1); %incl;
                    satelliteData.Ephemerides(13) = ROW6(1); %idot;
                    satelliteData.Ephemerides(14) = ROW3(1); %Cuc;
                    satelliteData.Ephemerides(15) = ROW3(3); %Cus;
                    satelliteData.Ephemerides(16) = ROW5(2); %Crc
                    satelliteData.Ephemerides(17) = ROW2(2); %Crs;
                    satelliteData.Ephemerides(18) = ROW4(2); %Cic;
                    satelliteData.Ephemerides(19) = ROW4(4); %Cis;
                    satelliteData.Ephemerides(20) = ROW1(8); %af0
                    satelliteData.Ephemerides(21) = ROW1(9); %af1
                    satelliteData.Ephemerides(22) = ROW1(10); %af2
                    satelliteData.Ephemerides(23) = ROW7(3); %tgd
                    satelliteData.Ephemerides(24) = toc; %toc
               

                    % Add satellite data to the timeData struct
                    ephemData.Data = [ephemData.Data; satelliteData.Ephemerides]; 

                    
                end
            end
        end
    end
end
fclose(infile);

% Delete data that is too far from the hour
%idx = find(ephemData.Time(:,5) > 1800);
%ephemData.Data(idx,:) = [];
%ephemData.Time(idx,:) = [];
ephem_Data = ephemData.Data;
ephem_Time = ephemData.Time;
