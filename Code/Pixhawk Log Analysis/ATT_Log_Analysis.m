%Mission Planner Log Attitude Analysis
%GPS_Cell = mat2cell(GPS,length(GPS),ones(1,15));
% s = cell2struct(GPS_Cell,GPS_label,2)
close all
clc;
clear;
  TextSizes.DefaultAxesFontSize = 14;
  TextSizes.DefaultTextFontSize = 16;
  set(0,TextSizes);


[filename, pathname] = uigetfile('C:\Users\Jordan\Documents\GitHub\Aerial-Algal-Bloom-Monitoring\Vehicle Logs\*.mat', 'MATLAB Log File');                                       %Prompt user for log file
load([pathname filename]);
% Attitude Vars
Time = (ATT(:,2)-ATT(1,2))/1000;   %Convert time from ms to s
DesRoll = ATT(:,3);
Roll = ATT(:,4);
DesPitch = ATT(:,5);
Pitch = ATT(:,6);
DesYaw = ATT(:,7);
Yaw = ATT(:,8);
% IMU Vars
TimeIMU = (IMU(:,2)-IMU(1,2))/1000;   %Convert time from ms to s
AccX1 = IMU(:,6);
AccY1 = IMU(:,7);
AccZ1 = IMU(:,8);
AccX2 = IMU2(:,6);
AccY2 = IMU2(:,7);
AccZ2 = IMU2(:,8);

%% Plotting Attitude
figure(1)
plot(Time,DesRoll,'r-', Time, Roll,'b-','linewidth',2)
title('Desired Roll and Measured Roll');
xlabel('Time (s)')
ylabel('Centi-Degrees');
grid on
legend('Desired Roll','Measured Roll')

figure(2)
plot(Time,DesPitch,'r-', Time, Pitch,'b-','linewidth',2)
title('Desired Pitch and Measured Pitch','fontsize',16);
xlabel('Time (s)')
ylabel('Centi-Degrees');
grid on
legend('Desired Pitch','Measured Pitch')

%% Plotting IMU
figure(3)
plot(TimeIMU,AccX1,'r-', TimeIMU, AccX2,'b-','linewidth',2)
title('X-Axis Accelerations','fontsize',16);
xlabel('Time (s)')
ylabel('m/s^{2}');
grid on
legend('IMU 1','IMU 2')

figure(4)
plot(TimeIMU,AccY1,'r-', TimeIMU, AccY2,'b-','linewidth',2)
title('Y-Axis Accelerations','fontsize',16);
xlabel('Time (s)')
ylabel('m/s^{2}');
grid on
legend('IMU 1','IMU 2')

figure(5)
plot(TimeIMU,AccZ1,'r-', TimeIMU, AccZ2,'b-','linewidth',2)
title('Z-Axis Accelerations','fontsize',16);
xlabel('Time (s)')
ylabel('m/s^{2}');

grid on
legend('IMU 1','IMU 2')

%% Plotting RC Outputs
TimeRC = (RCOU(:,2)-RCOU(1,2))/1000;   %Convert time from ms to s
RC_Min = min(RCOU(:,4));
RC_Max = 2000-RC_Min;
figure(6)
marker = {'b','g','r','c','m','k','r.-','k.-'};
hold on
for i = 3:10
    h(i) = plot(TimeRC,RCOU(:,i),marker{i-2},'linewidth',1);
end

plot(TimeRC,RCIN(:,5),'b','linewidth',3)
%-RC_Min)/RC_Max)*100
title('Motor Outputs','fontsize',16);
xlabel('Time (s)')
ylabel('Motor Pulse Width');

grid on
% legend('CH1','CH2','CH3','CH4','CH5','CH6','CH7','CH8','location','BestOutside')
legend('M1','M5','M8','M6','M2','M4','M3','M7','Throttle','location','BestOutside')

%% Plotting RC Inputs
TimeRC = (RCIN(:,2)-RCIN(1,2))/1000;   %Convert time from ms to s
RC_Min = [1092 1094 1094 1097 1094 1094 1094 1094];
RC_Max = [1932 1934 1934 1937 1934 1934 1934 1934];
figure(7)
marker = {'b','g','r','c','m','k','r.-','k.-'};
hold on
for i = 3:4
    h(i) = plot(TimeRC,RCIN(:,i),marker{i-2},'linewidth',2);
end
RC_Diff = RC_Max(1)-RC_Min(1);
RC_HalfMax = RC_Max(1)-(RC_Diff/4);
RC_HalfMin = RC_Min(1)+(RC_Diff/4);
plot(TimeRC,ones(length(TimeRC),1)*RC_HalfMin,'r-.',TimeRC,ones(length(TimeRC),1)*RC_HalfMax,'r--','linewidth',2);
title('RC Inputs','fontsize',16);
xlabel('Time (s)')
ylabel('Input Pulse Width');

grid on
% legend('Roll','Pitch','Throttle','Yaw','location','BestOutside')
legend('Roll','Pitch','Min RC Input','Max RC Input','location','BestOutside')

%% Roll Input vs. Roll Output
figure;
hR1 = subplot(2,1,1);
plot(TimeRC,RCIN(:,3),'linewidth',2);
ylabel('Pulse-Width (ms)');
xlabel('Time (s)');
title('Roll Input (RC)','fontsize',16);
grid on

hR2 = subplot(2,1,2);
plot(Time,DesRoll,'linewidth',2);
ylabel('Centi-Degrees');
xlabel('Time (s)');
title('Commanded Roll Output (RC)','fontsize',16);
grid on

linkaxes([hR1 hR2],'x');
hR2.YLim = [-50,50];
%% GPS Sats and HDOP
figure;
TimeGPS = (GPS(:,3)-GPS(1,3))/1000;   %Convert time from ms to s
hR1 = subplot(3,1,1);
plot(TimeGPS,GPS(:,6),'linewidth',2);
ylabel('N-Sats');
xlabel('Time (s)');
title('Number of GPS Satelites Aquired','fontsize',16);

grid on

hR2 = subplot(3,1,2);
plot(TimeGPS,GPS(:,7),'linewidth',2);
ylabel('HDOP');
xlabel('Time (s)');
title('GPS HDOP (Lower is Better)','fontsize',16);

grid on
hR2.YLim = [0,2];

hR3 = subplot(3,1,3);
plot(TimeRC,RCIN(:,5),'r-','linewidth',2)
ylabel('Pulse-Width (ms)');
xlabel('Time (s)');
title('Throttle Input','fontsize',16);
grid on


linkaxes([hR1 hR2 hR3],'x');

%% Desired Motion Plot
close all
for i = 1:length(NTUN(:,1))
    subplot(2,1,1);plot(NTUN(:,4)/100,NTUN(:,5)/100);
    hold on;
    plot(NTUN(:,6)/100,NTUN(:,7)/100,'r-');
    plot(NTUN(i,4)/100,NTUN(i,5)/100,'b*','markersize',10);
    plot(NTUN(i,6)/100,NTUN(i,7)/100,'r*','markersize',10);
    pause(0.05)
    hold off
end
for i = 1:length(RCIN(:,1))
    subplot(2,1,2);plot(TimeRC,RCIN(:,3));
    hold on
    plot(TimeRC(i),RCIN(i,3),'b*','markersize',10);
    hold off
    pause(0.05);
end
%%
close all;figure;
 for i = 1:length(DesRoll)
plot(Time,DesRoll,'b',Time,DesPitch,'r');
hold on

plot(Time,Roll+100,'b.-',Time,Pitch+100,'r.-');

plot(Time(i),DesRoll(i),'b*',Time(i),DesPitch(i),'r*','markersize',10);
plot(Time(i),Roll(i)+100,'bo',Time(i),Pitch(i)+100,'ro','markersize',10);
hold off
pause(0.05);
end
%% Plotting Attitude
figure
h1 = subplot(2,1,1);plot(Time,DesRoll,'r-', Time, Roll,'b-','linewidth',2)
title('Desired Roll and Measured Roll','fontsize',16);
xlabel('Time (s)')
ylabel('Centi-Degrees');

grid on
legend('Desired Roll','Measured Roll','location','best')

h2 = subplot(2,1,2);plot(TimeRC,RCIN(:,3),marker{3-2},'linewidth',2);
hold on
RC_Diff = RC_Max(1)-RC_Min(1);
RC_HalfMax = RC_Max(1)-(RC_Diff/4);
RC_HalfMin = RC_Min(1)+(RC_Diff/4);
plot(TimeRC,ones(length(TimeRC),1)*RC_HalfMin,'r-.',TimeRC,ones(length(TimeRC),1)*RC_HalfMax,'r--','linewidth',2);
title('RC Roll Input','fontsize',16);
xlabel('Time (s)')
ylabel('Input Pulse Width');

grid on
% linkaxes([h1 h2],'x');


figure
h3 = subplot(2,1,1);plot(Time,DesPitch,'r-', Time, Pitch,'b-','linewidth',2)
title('Desired Pitch and Measured Pitch','fontsize',16);
xlabel('Time (s)')
ylabel('Centi-Degrees');

grid on
legend('Desired Pitch','Measured Pitch','location','best')

h4 = subplot(2,1,2);plot(TimeRC,RCIN(:,4),marker{4-2},'linewidth',2);
hold on
plot(TimeRC,ones(length(TimeRC),1)*RC_HalfMin,'r-.',TimeRC,ones(length(TimeRC),1)*RC_HalfMax,'r--','linewidth',2);
title('RC Pitch Input','fontsize',16);
xlabel('Time (s)')
ylabel('Input Pulse Width');

grid on
linkaxes([h1 h2 h3 h4],'x');
%% GPS Comparison

if exist('GPS2','var') == 1
    GPS2_zeroLon = find(GPS2(:,9)==0);
    GPS2(GPS2_zeroLon,9) = nan;
    GPS2_zeroLat = find(GPS2(:,8)==0);
    GPS2(GPS2_zeroLat,8) = nan;
    
    floatRTK = find(GPS2(:,3)==4);
    fixedRTK = find(GPS2(:,3)==5);
    noRTK = find(GPS2(:,3) == 1);
    legendEntry = [];
    %     figure
    hold on;
    GPS_hand = plot(GPS(:,9),GPS(:,8),'k','DisplayName','Stock GPS')
    plot(GPS(:,9),GPS(:,8),'k.')
    legendEntry = [legendEntry,GPS_hand];
    legendString = {'Stock GPS'}
    if isempty(fixedRTK) ~= 1
        fixedRTK_hand = plot(GPS2(fixedRTK,9),GPS2(fixedRTK,8),'r','DisplayName','Fixed RTK');
        plot(GPS2(fixedRTK,9),GPS2(fixedRTK,8),'r.')
        legendString{end+1} = 'Fixed RTK';
        legendEntry = [legendEntry,fixedRTK_hand];
    end
    if isempty(floatRTK) ~= 1
        floatRTK_hand = plot(GPS2(floatRTK,9),GPS2(floatRTK,8),'b','DisplayName','Float RTK');
        plot(GPS2(floatRTK,9),GPS2(floatRTK,8),'b.')
        legendString{end+1} = 'Float RTK';
        legendEntry = [legendEntry,floatRTK_hand];
    end
    if isempty(noRTK) ~= 1
        noRTK_hand = plot(GPS2(noRTK,9),GPS2(noRTK,8),'ms','DisplayName','No RTK Comms');
        legendString{end+1} = 'no RTK Comms';
        legendEntry = [legendEntry,noRTK_hand];
    end
    legend(legendEntry,legendString,'location','bestoutside')
end
