% Jordan T. Kirby
% Image Mosaic

clc;format compact;close all
disp('Starting Mosaic')
directoryName = uigetdir('','Choose Photo Directory');
cd(directoryName)
disp(['Reading Files from ',directoryName])
Files = dir('*.jpg');                
disp(['Number of Photos: ',num2str(length(Files))]);


% Importing Calibration File
disp('Importing calibration file')
[filename, pathname] = uigetfile('*.mat','Choose Camera Calibration File');
calibrationData = load([pathname filename]);
clear filename pathname
disp('Success')

% Importing Focal Length
focalLength = input('Please enter focal length for camera: ');
disp(['Focal Length = ', num2str(focalLength) , 'mm']);

% Importing Location Data
% This section is replaced by LogLocation function
originLat = 41.540371;
originLon = -70.941636;

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