close all
clc;
% clear;
[filename, pathname] = uigetfile('C:\Users\Jordan\Documents\GitHub\Aerial-Algal-Bloom-Monitoring\Vehicle Logs\*.mat', 'MATLAB Log File');                                       %Prompt user for log file
load([pathname filename]);

camTimeUS = CAM(:,2);
camGPSTime = CAM(:,3);
camGPSWeek = CAM(:,4);
camLat = CAM(:,5);
camLon = CAM(:,6);
camAlt = CAM(:,7);
camRelAlt = CAM(:,8);
camRoll = CAM(:,9);
camPitch = CAM(:,10);
camYaw = CAM(:,11);


% Load image
% img = imread('initial_image.jpg');

% Full rotation matrix. Z-axis included, but not used.
for i = length(camYaw)-37:length(camYaw)
    R_z = [cosd(camYaw(i)) -sind(camYaw(i)) 0;
        sind(camYaw(i))  cosd(camYaw(i)) 0;
        0          0         1];
    R_x = [cosd(camPitch(i))    0   sind(camPitch(i));0 1   0;-sind(camPitch(i))   0   cosd(camPitch(i))];
    R_y = [1  0  0; 0  cosd(camRoll(i))   -sind(camRoll(i));0  sind(camRoll(i))   cosd(camRoll(i))];
    R_rot= R_y.*R_x.*R_z;
    
    
    % Strip the values related to the Z-axis from R_rot
    R_2d  = [   R_rot(1,1)  R_rot(1,2) 0;
        R_rot(2,1)  R_rot(2,2) 0;
        0           0          1    ];
    
    % Generate transformation matrix, and warp (matlab syntax)
    tform = affine2d(R_2d);
    outputImage = imwarp(Images{i-114},tform);
    
    % Display image
    figure; imshow(outputImage);
    
    
end