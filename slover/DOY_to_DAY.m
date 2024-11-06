function [month, day] = DOY_to_DAY(year, dayOfYear)
    % Determine if it's a leap year
    if mod(year, 4) == 0 && (mod(year, 100) ~= 0 || mod(year, 400) == 0)
        leapYear = true;
    else
        leapYear = false;
    end

    % Define the number of days in each month
    daysInMonth = [31 28+leapYear 31 30 31 30 31 31 30 31 30 31];
    
    % Find the month
    month = 1;
    while dayOfYear > daysInMonth(month)
        dayOfYear = dayOfYear - daysInMonth(month);
        month = month + 1;
    end
    
    % Output the result
    day = dayOfYear;
end