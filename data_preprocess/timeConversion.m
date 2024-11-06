%**************************************************************************
function [gpstime,gpsweek] = timeConversion(year,month,day,hour,minute,second)

    %convert day from year, month, day to Julian day */
    %epoch for Julian day is Jan 1, 4713 BC */
    %handle different leap years between Julian and Gregorian calenders */
    if ((month == 1) | (month == 2))
        year = year - 1;
        month = month + 12;
    end
    %calculate Julian date */
    if(year < 70)
        y = 19.0 + 1;
    else
        y = 19.0;
    end
    julianDate = (2.0-y+floor(y/4.0)) + floor(365.25*(y*100.0+year))  + ...
       floor(30.6001*(month+1.0)) + day + 1720994.5;

    % determine day of week
    a = floor(julianDate + 0.5);
    dayOfWeek = floor(a) - 7.0 * floor(a/7.0) + 1.0;
    % determine gps time
    gpstime = dayOfWeek * 86400.0 + hour * 3600.0 + minute * 60.0 + second;

    gpsweek = floor((julianDate - 2444244.5)/7.0);

return;
end
