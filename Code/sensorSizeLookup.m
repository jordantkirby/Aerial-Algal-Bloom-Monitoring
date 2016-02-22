function sensorSize = sensorSizeLookup(CameraModel)
% function sensorSize = sensorSizeLookup(CameraModel)
% Simple look-up table for finding sensor size of specific camera models.
% Can be updated with as many cameras as needed. 
% *IMPORTANT* Added cameras should use the name provided from EXIF data to
% prevent issues in matching the name to sensor size.
% Sensor sizes found from http://www.dpreview.com/glossary/camera-system/sensor-sizes
% Input: 
%        CameraModel: String provided from EXIF data, typically under
%                       'Model' field
% Output:
%        sensorSize: 1x2 vector containing x and y lengths of sensor in mm
%
% Error Msgs:
%       'Camera Not Found': If camera name passed to function is not
%       already in the look-up table, this error is thrown.
% Jordan T. Kirby
% 11/6/2015
CameraName = {
    'Canon PowerShot SX260 HS';
    'NEX-7';
    'HERO3+ Black Edition';
    'HERO3+ Silver Edition'};
    
sensorSize = [
    6.2, 4.6;...
    23.5, 15.6;...
    6.17, 4.62;...
    5.371,4.035];
    
sensorIndex = strmatch(CameraModel,CameraName);
sensorSize = sensorSize(sensorIndex,:);
if (isempty(sensorIndex))
    error('Camera Not Found')
end