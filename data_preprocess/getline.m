%***************************************************************************
%* Get the next line from the input file (up to 80 characters).
%**************************************************************************
function line = getline(file)
    line = fgets(file);
    if(length(line)<10)
        line = fgets(file);
    end
return;