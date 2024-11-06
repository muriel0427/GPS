% check on 08/2006o
% plotsat.m	(acutal file name: plotsat.m)
%
% this utility plots the calculated satellite positions or 
% trajectories in an elevation-azimuth plot
%
% input: 'el-az' martix which rows contain an SV id number, a GPS 
%		time (seconds), and the elevation-azimuth look angles 
%		(degrees) to the satellite location; if positional plot is 
%		desired the following condition must be met: the GPS time for 
%		all satellites must be the same; if trajectory plot is desired
%		the following conditions must be met: the same number of 
%		satellites must be included in each sample and within each 
%		sample all GPS times must be the same 
%							[ svID GPStime elevation azimuth ;
%		  					  svID GPStime elevation azimuth ;
%												...
%		  					  svID GPStime elevation azimuth ]
%
function [ ] = plotsat(el_az, month, day, initial)
% define physical constants
	constant
% find out from 'el_az' if plotting satellite locations or 
% trajectories in addition determine how many satellites are being 
% tracked and how many samples for each satellite 
% (# samples / satellite must always be equal)
	gpsTime = el_az(1,2);
	i = 1;
	t = gpsTime;
	while ((i ~= size(el_az,1)) & (t == gpsTime))
		i = i + 1;
		t = el_az(i,2);
	end
	if (t == gpsTime)
		sats = i;
	else
		sats = i - 1;
	end;
	samples = size(el_az,1) / sats;
% convert all elevation and azimuth measurements into radians
	SVs = el_az(1:sats,1);
	elevation = el_az(:,3) .* degrad;
	azimuth = el_az(:,4) .* degrad;
% initialize polar - plotting area
	close;
	axis([-1.4 1.4 -1.1 1.1]);
	axis('off');
	axis(axis);
	hold on;
	% plot circular axis and labels
		th = 0:pi/50:2*pi;
		x = [ cos(th) .67.*cos(th) .33.*cos(th) ];
		y = [ sin(th) .67.*sin(th) .33.*sin(th) ];
		plot(x,y,'color','w');
		text(1.1,0,'E','horizontalalignment','center');
		text(0,1.1,'N','horizontalalignment','center');
		text(-1.1,0,'W','horizontalalignment','center');
		text(0,-1.1,'S','horizontalalignment','center'); 
	% plot spoke axis and labels
		th = (1:6)*2*pi/12;
		x = [ -cos(th); cos(th) ];
		y = [ -sin(th); sin(th) ];
      plot(x,y,'color','w');
 		text(-.46,.93,'0','horizontalalignment','center');
		text(-.30,.66,'30','horizontalalignment','center');
		text(-.13,.36,'60','horizontalalignment','center');
		text(.04,.07,'90','horizontalalignment','center');
	% plot titles
		if (samples == 1)
			title('Satellite Position Plot');
			subtitle = sprintf('GPS time : %.2f sec',el_az(1,2));
		else
			title('skyplot of 2022/06/22 04:35:28 – 04:37:08 at NCUS4');
         subtitle = sprintf('GPS time range : %.2f sec to %.2f sec', ...
            el_az(1,2),el_az(size(el_az,1),2));
			text(-1.6,1,'SVID/Last Position','color','r');
			text(-1.6,.9,'Positive Elevation','color','g');
			text(-1.6,.8,'Negative Elevation','color','b');
		end
		text(0,-1.3,subtitle,'horizontalalignment','center');
% plot trajectories (or positions) and label the last postion with
% the satellite SV id; in addition, last postions are in red,
% otherwise position elevations are yellow and negative elavations
% are blue
	% loop through samples
	for s = 1:samples		
		% plot each satellite location for that sample
		for sv = 1:sats
			% check if positive or negative elevation
			if (elevation((s - 1) * sats + sv) < 0)
				elNeg = 1;
			else
				elNeg = 0;
			end
			% convert to plottable cartesian coordinates
         el = elevation((s - 1) * sats + sv);
			az = azimuth((s - 1) * sats + sv);
         x = (pi/2-abs(el))/(pi/2).*cos(az-pi/2);
         y = -1*(pi/2-abs(el))/(pi/2).*sin(az-pi/2);
			% check for final sample
			if (s == samples)
				plot(x,y,'r*');
				text(x,y+.07,int2str(SVs(sv)), ...
					'horizontalalignment', ...
					'center','color','r');
			else
				% check for +/- elevation
				if (elNeg == 0)
					plot(x,y,'g.');
				else
					plot(x,y,'b.');
				end
			end
		end
    end
    figname = sprintf('C:\\Users\\USER\\OneDrive\\桌面\\skyplot\\satellite_plot_%s%s_%d.png', sprintf('%02d', month), sprintf('%02d', day), initial.sample);
    saveas(gcf, figname);
    close(gcf);
% return
	return;