% Jordan T. Kirby
% Image Mosaic

clc;format compact;close all
disp('Starting Mosaic')
imageDirectory = uigetdir('Z:\Joyce\jkirby\Multi-Rotor\','Choose Photo Directory');
disp(['Reading Files from ',imageDirectory])
Files = dir([imageDirectory,'\*.jpg']);
disp(['Number of Photos: ',num2str(length(Files))]);

% Importing Calibration File
disp('Importing calibration file')
[filename, pathname] = uigetfile('*.mat','Choose Camera Calibration File');
calibrationData = load([pathname filename]);
clear filename pathname
disp('Success')

% Importing Focal Length
cameraInfo = imfinfo([imageDirectory,'\' Files(1).name]);
focalLength = cameraInfo.DigitalCamera.FocalLength;
disp(['Focal Length = ', num2str(focalLength) , 'mm']);

% Importing Location Data
originLat = 41.539640; 
originLong = -70.943726;
Location = LocationLogRead(originLat,originLong);

% Reading Images
disp('Starting Image Reading and Rotation Using Yaw Data')
for i = 1:length(Files)
    Images = imread([imageDirectory,'\' Files(i).name]);
    disp(['Read Image ', num2str(i), ' of ',num2str(length(Files))])
    undistortedImage = undistortImage(Images,calibrationData.calibrationSession.CameraParameters);
    disp(['Undistorted Image ', num2str(i), ' of ',num2str(length(Files))])
    Files(i).RotatedImages = imrotate(undistortedImage,Location.Yaw(i));
    Files(i).ImageSize = size(Images);
    clear Images undistortedImage
    disp(['Rotated Image ', num2str(i), ' of ',num2str(length(Files))])
    disp(['Deleted Image ', num2str(i)])
end
disp('Image Rotation Complete')

%%
%Image Center
cX = calibrationData.calibrationSession.CameraParameters.IntrinsicMatrix(3,1);
cY = calibrationData.calibrationSession.CameraParameters.IntrinsicMatrix(3,2);
%Image Focal Length
fX = calibrationData.calibrationSession.CameraParameters.IntrinsicMatrix(1,1);
fY = calibrationData.calibrationSession.CameraParameters.IntrinsicMatrix(2,2);
% %Pixels per Milimeter
% S = focalLength.\[fX fY]
% sX = S(1);sY = S(2);

%Sensor size (mm) 1/2.7(http://www.dpreview.com/articles/8095816568/sensorsizes)
sensorX = 5.270;
sensorY = 3.960;
for i = 1:length(Files)
    Files(i).FrameSizeX = ((sensorX*abs(Location.Height(i)*1000))/2.77)/1000;
    Files(i).FrameSizeY = ((sensorY*abs(Location.Height(i)*1000))/2.77)/1000;
end

Files.PpMY = Files.ImageSize(2)/Files.FrameSizeY;
Files.PpMY = Files.ImageSize(1)/Files.FrameSizeX;


%%
close all
htranslate = vision.GeometricTranslator;
htranslate.OutputSize = 'Full';
 htranslate.Offset = [PpMY*Location.LocalY(120) PpMX*Location.LocalX(120)];
 Y = step(htranslate, Files(120).RotatedImages);
 imshow(Y);

for i = 110:115
    hold on
    htranslate.release
    htranslate.Offset = [PpMX*abs(Location.LocalX(i)-Location.LocalX(i-1)) PpMY*abs(Location.LocalY(i)-Location.LocalY(i-1))];
    Y = step(htranslate, Files(i).RotatedImages);
    imshow(Y)
    htranslate.release
    %     pause
    disp(['Displaying Image ', num2str(i), ' of ',num2str(length(Files))])
    pause
end