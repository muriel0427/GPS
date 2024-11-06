function [I] = getion(infile)
    % get the header info
    IONA = [0 0 0 0];
    IONB = [0 0 0 0];

    while (true)   
        buff = getline(infile);

        if (startsWith(buff, 'GPSA'))   
            buff = strrep(buff, 'D', 'E');
            C = textscan(buff, 'GPSA   %f%f%f%f', 'CollectOutput', true);
            IONA = C{1}';
        end

        if (startsWith(buff, 'GPSB'))  
            buff = strrep(buff, 'D', 'E');
            C = textscan(buff, 'GPSB   %f%f%f%f', 'CollectOutput', true);
            IONB = C{1}';
        end
    
        if (~isempty(findstr(buff,'END OF HEADER')))
            break;
        end
    end
    buff=getline(infile);
        
    IONA = reshape(IONA, 4, []);
    IONB = reshape(IONB, 4, []);
    I = [IONA IONB];

    % check for end of file
    return;
