clc;clear;format compact;format long
% close all;
[filename, pathname] = uigetfile( ...
    {'*.jpg';'*.png'; '*.*'}, ...
    'Select Image(s)', ...
    'MultiSelect', 'on');

    CamInfo = imfinfo([pathname,filename{1}]);
for i = 1:length(filename)
    Images{i} = imread([pathname,filename{i}]);
end
%%
sensorSize = sensorSizeLookup(CamInfo.Model)
a=[41 32 32.92   -70 57 23.72];
%41.54248 -70.95659
[localEast localNorth localZone] = deg2utm(dms2dd(a(1),a(2),a(3)),dms2dd(a(4),a(5),a(6)));
% [localEast localNorth localZone] = deg2utm(41.542676, -70.956529);
maxCorner_vec = [];
minCorner_vec = [];
for i = 1:length(filename)
    CamInfo = imfinfo([pathname,filename{i}]);
    Lat = CamInfo.GPSInfo.GPSLatitude
    Lon = CamInfo.GPSInfo.GPSLongitude
    Altitude = CamInfo.GPSInfo.GPSAltitude;
    imageSize = ((sensorSize.*(Altitude*1000))/CamInfo.DigitalCamera.FocalLength)/1000;
    
    LatDD = dms2dd(Lat(1),Lat(2),Lat(3));
    LonDD = -dms2dd(Lon(1),Lon(2),Lon(3));
    
    [East North UTMZone] = deg2utm(LatDD,LonDD);
    diffEast = East-localEast;
    diffNorth = North-localNorth;
    imageCenter = [diffEast diffNorth];
    Location(i).imageEdges = [...
        diffEast-imageSize(1)/2 diffNorth+imageSize(2)/2; ...
        diffEast-imageSize(1)/2 diffNorth-imageSize(2)/2;...
        diffEast+imageSize(1)/2 diffNorth+imageSize(2)/2;...
        diffEast+imageSize(1)/2 diffNorth-imageSize(2)/2];      
%     figure(i)
    image(Images{i},'XData',Location(i).imageEdges(:,1),'YData',Location(i).imageEdges(:,2))
    hold on
    axis xy
    plot(0,0,'r*',diffEast,diffNorth,'r^')
    axis equal
    clear camInfo
end
%%
for i = 1:length(filename)
    maxCorner_vec = [maxCorner_vec; max(Location(i).imageEdges)];
    minCorner_vec = [minCorner_vec; min(Location(i).imageEdges)];
end
NorthLim = max(maxCorner_vec(:,2))
SouthLim = min(minCorner_vec(:,2))
WestLim = min(minCorner_vec(:,1))
EastLim = max(maxCorner_vec(:,1))
xlim([WestLim EastLim]);
ylim([SouthLim NorthLim]);
% axis([WestLim EastLim SouthLim NorthLim])