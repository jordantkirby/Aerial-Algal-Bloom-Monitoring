% Jordan T. Kirby
% Image Mosaic

clc;format compact;close all
disp('Starting Mosaic')
directory = ('E:\Round_Hill_Algae');
cd(directory)
disp(['Reading Files from ',directory])
Files = dir('*.jpg');                
disp(['Number of Photos: ',num2str(length(Files))]);

% Importing Location Data
disp('Importing Site Location')
Location = importdata('location.txt',' ',1);
Location.Filename = Location.textdata(2:end,1);
Location.Lat = Location.data(:,1);
disp('Site Lat Imported')
Location.Lon = Location.data(:,2);
disp('Site Lon Imported')
Location.Height = Location.data(:,3);
disp('Vehicle Height Imported')
Location.Yaw = Location.data(:,4);
disp('Vehicle Yaw Imported')
Location.originLat = 41.540371;
Location.originLon = -70.941636;
disp(['Site Origin Set to: ' num2str([Location.originLat Location.originLon])])
%Transforming Lat/Long to Northing/Easting, make centering image at coordinate easier
[Location.XOrigin, Location.YOrigin Location.UTM] = deg2utm(Location.originLat,Location.originLon);
[Location.X Location.Y Location.UTM] = deg2utm(Location.Lat,Location.Lon);  
disp('Site Location Imported')
%Transforming Global Coordinate System to Local Coordinate System
Location.LocalX = Location.X - Location.XOrigin;
Location.LocalY = Location.Y - Location.YOrigin;
disp('Global Coordinate System Converted to Local Coordinate System')
% Reading Images
disp('Starting Image Reading and Rotation Using Yaw Data')
for i = 100:100+length(Files)/20
    Files(i).Images = imread(Files(i).name);
    disp(['Read Image ', num2str(i), ' of ',num2str(length(Files))])
    Files(i).RotatedImages = imrotate(Files(i).Images,Location.Yaw(i));
%     clear Files(i).Images
    disp(['Rotated Image ', num2str(i), ' of ',num2str(length(Files))])
    disp(['Deleted Image ', num2str(i)])
end
disp('Image Rotation Complete')

%%
close all
PpM = 163.384216302504;

htranslate = vision.GeometricTranslator;
htranslate.OutputSize = 'Full';
% htranslate.Offset = [Location.LocalX(120) Location.LocalY(120)];
% Y = step(htranslate, Files(120).RotatedImages);
% imshow(Y);

for i = 110:115
    hold on
    htranslate.release
    htranslate.Offset = [PpM*abs(Location.LocalX(i)-Location.LocalX(i-1)) PpM*abs(Location.LocalY(i)-Location.LocalY(i-1))];
    Y = step(htranslate, Files(i).RotatedImages);
    imshow(Y)
    htranslate.release
%     pause
    disp(['Displaying Image ', num2str(i), ' of ',num2str(length(Files))])
    pause
end