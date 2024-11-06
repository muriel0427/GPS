%tested 8/31/01
% calcdop.m		(actual file name: calcdop.m)
%
% this function calculates the dilution of precision of a 
% navigational solution based on the satellite geometry; given the
% parameters 'ephem' and 'gpsTime', calcdop can calculate satellite
% locations; the navigational solution 'posOBS' allows calcdop to 
% determine the 'A' matrix; it will return the output 'DOP' 
% formatted in the following way:
%
%	DOP(1)		geometrical dilution of precision
%	DOP(2)		positional dilution of precision
%	DOP(3)		time dilution of precision
%	DOP(4)		horizontal dilution of precision
%	DOP(5)		vertical dilution of precision
% 
function DOP = calcdop(ephem,gpsTime,GaussNewton)
% determine number of satellites
	numSats = size(ephem,1);
% format 'posOBS' to only have the observations ECEF coordinates
	posOBS = GaussNewton.position(1:3);
	obsX = posOBS(1);
	obsY = posOBS(2);
	obsZ = posOBS(3);
% calculate the 'A' matrix
	% calculate the satellite locations and ranges to them
	satLoc = findsat(ephem,gpsTime);
	satLoc = satLoc(:,3:5);
	satX = satLoc(:,1);
	satY = satLoc(:,2);
	satZ = satLoc(:,3);
	r = ((satX - obsX).^2 + (satY - obsY).^2 + (satZ - obsZ).^2).^0.5;
	% format 'A' matrix
	A = [ -((satX - obsX) ./ r) -((satY - obsY) ./ r) -((satZ - obsZ) ./ r) -ones(numSats,1) ];
% calculate the cofactor matrix 'Q' which is the inverse of the normal
% equation matrix the 'Q' matrix has the following components
% [ qXX qXY qXZ qXt; qYX qYY qYZ qYt; qZX qZY qZZ qZt; qtX qtY qtZ qtt]
	Q = inv(A' * A);
% assign diagonal elements 'qXX', 'qYY', 'qZZ', 'qtt'
	qXX = Q(1,1);
	qYY = Q(2,2);
	qZZ = Q(3,3);
	qtt = Q(4,4);
% compute 'GDOP', 'PDOP', and 'TDOP' 
	GDOP = sqrt(qXX + qYY + qZZ + qtt);
	PDOP = sqrt(qXX + qYY + qZZ);
	TDOP = sqrt(qtt);
% to compute 'HDOP' and 'VDOP' need rotation matrix from ECEF to local frame
	% convert ECEF OBS into latitude-longitude coordinates
	posOBS = latlong(posOBS);
	psi = posOBS(1); 			% latitude
	lamda = posOBS(2);			% longitude
	% rotation matrix  'R'
	R = [ (-sin(psi)*cos(lamda)) (-sin(psi)*sin(lamda)) (cos(psi)); ...
		(-sin(lamda)) (cos(lamda)) (0) ; ...
		(cos(psi)*cos(lamda)) (cos(psi)*sin(lamda)) (sin(psi)) ];
	% calculate the local cofactor matrix
	Qgeom = Q(1:3,1:3);
	Qlocal = R * Qgeom * R';
	% assign diagonal elements
	qXX = Qlocal(1,1);
	qYY = Qlocal(2,2);
	qhh = Qlocal(3,3);
	% calculate 'HDOP' and 'VDOP'
    EDOP = sqrt(qXX);
    NDOP = sqrt(qYY);
	HDOP = sqrt(qXX + qYY);
	VDOP = sqrt(qhh);	
% return 'DOP'
DOP = [ GDOP PDOP TDOP HDOP VDOP EDOP NDOP];
return;