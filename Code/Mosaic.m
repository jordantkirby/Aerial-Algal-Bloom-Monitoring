% Jordan T. Kirby
% Image Mosaic

%http://www.mathworks.com/help/images/perform-a-2-d-translation-transformation.html

clc;format compact;close all

imageStart = 1;
imageEnd = 1;

disp('Starting Mosaic')
imageDirectory = uigetdir('Z:\Joyce\jkirby\Multi-Rotor\','Choose Photo Directory');
disp(['Reading Files from ',imageDirectory])
Files = dir([imageDirectory,'\*.jpg']);
disp(['Number of Photos: ',num2str(length(Files))]);

% Importing Calibration File
disp('Importing calibration file')
[filename, pathname] = ...
    uigetfile('C:\Users\Jordan\Documents\GitHub\Aerial-Algal-Bloom-Monitoring\Calibration Data\*.mat',...
    'Choose Camera Calibration File');
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
% for i = 1:length(Files)
for i = imageStart:imageEnd
    Images = imread([imageDirectory,'\' Files(i).name]);
    disp(['Read Image ', num2str(i), ' of ',num2str(length(Files))])
    undistortedImage = undistortImage(Images,calibrationData.calibrationSession.CameraParameters);
    disp(['Undistorted Image ', num2str(i), ' of ',num2str(length(Files))])
    Files(i).RotatedImages = imrotate(undistortedImage,Location.Yaw(i)-180);
    Files(i).ImageSize = size(Images);
    clear Images undistortedImage
    disp(['Rotated Image ', num2str(i), ' of ',num2str(length(Files))])
    disp(['Deleted Image ', num2str(i)])
end
disp('Image Rotation Complete')

%%
% %Image Center
% cX = calibrationData.calibrationSession.CameraParameters.IntrinsicMatrix(3,1);
% cY = calibrationData.calibrationSession.CameraParameters.IntrinsicMatrix(3,2);
% %Image Focal Length
% fX = calibrationData.calibrationSession.CameraParameters.IntrinsicMatrix(1,1);
% fY = calibrationData.calibrationSession.CameraParameters.IntrinsicMatrix(2,2);
% % %Pixels per Milimeter
% % S = focalLength.\[fX fY]
% % sX = S(1);sY = S(2);
%% Computing Pixels per Meter
%Sensor size (mm) 1/2.7(http://www.dpreview.com/articles/8095816568/sensorsizes)
sensorX = 5.270;
sensorY = 3.960;
% for i = 1:length(Files)
for i = imageStart:imageEnd       % only going through some of the images for testing.
    Files(i).FrameSizeX = ((sensorX*abs(Location.Height(i)*1000))...
        /focalLength)/1000;
    Files(i).FrameSizeY = ((sensorY*abs(Location.Height(i)*1000))...
        /focalLength)/1000;
    Files(i).PpMY = Files(i).ImageSize(2) / Files(i).FrameSizeY;
    Files(i).PpMX = Files(i).ImageSize(1) / Files(i).FrameSizeX;
end

%%
close all
% R1 = imref2d(size(Files(100).RotatedImages));
% R = imref2d(size(Files(101).RotatedImages));
% % Finding spatial difference between two images
% xDiff = Location.LocalX(101)-Location.LocalX(100);
% yDiff = Location.LocalY(101)-Location.LocalY(100);
% % Averaging pixels per meter in X and Y directions between the two images
% xStep = abs(xDiff*mean([Files(100).PpMX:Files(101).PpMX]))
% yStep = abs(yDiff*mean([Files(100).PpMY:Files(101).PpMY]))
% % Setting up transformation matrix
% A = eye(3);
% A(3,1) = xStep
% A(3,2) = yStep
% tform = affine2d(A);
% % Setting current size of figure frame
% Rout = R1;
% Rout.XWorldLimits(2) = Rout.XWorldLimits(2)+xStep;
% Rout.YWorldLimits(2) = Rout.YWorldLimits(2)+yStep;
A = eye(3);
r = imref2d(size(Files(imageStart).RotatedImages));
[maxX, maxXIndex] = max(Location.LocalX(imageStart:imageEnd))
[maxY, maxYIndex] = max(Location.LocalY(imageStart:imageEnd))
maxX_Pixel = maxX*Files(imageStart+maxXIndex).PpMX
maxY_Pixel = maxY*Files(imageStart+maxYIndex).PpMY
r.XWorldLimits(2) = maxX_Pixel;
r.YWorldLimits(2) = maxY_Pixel;
for i = imageStart:imageEnd
%     R1 = imref2d(size(Files(i).RotatedImages));
%     R = imref2d(size(Files(i).RotatedImages));
    % Finding spatial difference between two images
    xDiff = Location.LocalX(i+1)-Location.LocalX(i);
    yDiff = Location.LocalY(i+1)-Location.LocalY(i);
    disp(['xDiff = ', num2str(xDiff) , 'm']);
    disp(['yDiff = ', num2str(yDiff) , 'm']);
    
    % Averaging pixels per meter in X and Y directions between the two images
    xStep = xDiff*mean([Files(i+1).PpMX,Files(i).PpMX]);
    yStep = yDiff*mean([Files(i+1).PpMY,Files(i).PpMY]);
    
    disp(['xStep = ', num2str(xStep) , ' pixels']);
    disp(['yStep = ', num2str(yStep) , ' pixels']);
    
    
    A(3,1) = maxX_Pixel - xStep;
    A(3,2) = maxY_Pixel - yStep;
    tform = affine2d(A);
    Rout = r;
    if(xStep <= 0)
        Rout.XWorldLimits(1) = Rout.XWorldLimits(1)+xStep;
    elseif(xStep >0)
        Rout.XWorldLimits(2) = Rout.XWorldLimits(2)+xStep;
    end
    if(yStep <= 0)
        Rout.YWorldLimits(1) = Rout.YWorldLimits(1)+yStep;
    elseif(yStep >0)
        Rout.YWorldLimits(2) = Rout.YWorldLimits(2)+yStep;
    end
    disp(['XWorldLimit = ', num2str(Rout.XWorldLimits) , ' pixels']);
    disp(['YWorldLimit = ', num2str(Rout.YWorldLimits) , ' pixels']);
    [out,Rout] = imwarp(Files(i).RotatedImages,tform,'OutputView',Rout);
    imshow(out,Rout)
    hold on;
%     pause(3)
end

% % Translating Image
% [out,Rout] = imwarp(Files(100).RotatedImages,tform,'OutputView',Rout);
% % Displaying Image
% figure;
% imshow(Files(101).RotatedImages,R);
% figure;
% imshow(out,Rout)
% figure
% imshow(out,Rout);
% hold on
% imshow(Files(101).RotatedImages,R)
%
[Width Height Pixel] = size(ImageSmall);
index = []
ImageSmallFound = ImageSmall;
imshow(ImageSmall)
[light_algaeIndex dark_algaeIndex] = ginput(2);
light_algae = ImageSmall(light_algaeIndex(1),light_algaeIndex(2),:);
dark_algae = ImageSmall(dark_algaeIndex,:);
for i = 1:Width
    for j = 1:Height
        redC = ImageSmall(i,j,1);
        greenC = ImageSmall(i,j,2);
        blueC = ImageSmall(i,j,3);
        colorC = [redC greenC blueC];
        if colorC <= light_algae & colorC >= dark_algae
            index = [index; i j];
            disp('found')
            ImageSmallFound(i,j,:) = ImageSmallFound(i,j,[1 1 1]);
        end
    end
end