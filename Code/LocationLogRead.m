function LocationLogRead(filename,originLat,originLong)
disp(strvcat({'Importing Site Location' ; '______' }))
[filename path] = uigetfile('*.txt','Choose Location Log');
Location = importdata([path filename]);
Location.Filename = Location.textdata(2:end,1);
Location.Lat = Location.data(:,1);
disp('Site Lat Imported')
Location.Lon = Location.data(:,2);
disp('Site Lon Imported')
Location.Height = Location.data(:,3);
disp('Vehicle Height Imported')
Location.Yaw = Location.data(:,4);
disp('Vehicle Yaw Imported')
Location.Pitch = Location.data(:,5);
disp('Vehicle Pitch Imported')
Location.Roll = Location.data(:,6);
disp('Vehicle Roll Imported')
disp(['Site Origin Set to: ' num2str([Location.originLat Location.originLon])])

%Transforming Lat/Long to Northing/Easting, make centering image at coordinate easier
[Location.XOrigin Location.YOrigin Location.UTM] = deg2utm(originLat,originLon);
[Location.X Location.Y Location.UTM] = deg2utm(Location.Lat,Location.Lon);  
disp('Site Location Imported')

%Transforming Global Coordinate System to Local Coordinate System
Location.LocalX = Location.X - Location.XOrigin;
Location.LocalY = Location.Y - Location.YOrigin;
disp('Global Coordinate System Converted to Local Coordinate System')