%Mission Planner Log Attitude Analysis

close all
clc;
clear;
Matlab_Defaults
marker = {'b','g','r','c','m','k','r.-','k.-'};
[filename, pathname] = uigetfile('C:\Users\Jordan\Documents\GitHub\Aerial-Algal-Bloom-Monitoring\Vehicle Logs\*.mat', 'MATLAB Log File');                                       %Prompt user for log file
load([pathname filename]);
%% Crash Detector for printing log plots
if exist('ERR')== 1
    CRASH_Log = ERR.ECode(find(ERR.Subsys == 12 & ERR.ECode == 1));
    disp(['CRASH_Log == ',num2str(CRASH_Log)]);
else
    disp('CRASH_Log = 0');
end
%% Time Units Detector
% Attitude
switch(num2str(isfield(ATT,{'TimeUS', 'TimeMS'})))
    case num2str([ 0 1])
        ATT.Time = ATT.TimeMS/1e3;
    case num2str([ 1 0])
        ATT.Time = ATT.TimeUS/1e6
    otherwise
        disp('ERR: No ATT Time Field Dectected');
end
% IMU
switch(num2str(isfield(IMU,{'TimeUS', 'TimeMS'})))
    case num2str([ 0 1])
        IMU.Time = IMU.TimeMS/1e3;
        IMU2.Time = IMU2.TimeMS/1e3;
    case num2str([ 1 0])
        IMU.Time = IMU.TimeUS/1e6
        IMU2.Time = IMU2.TimeUS/1e6
    otherwise
        disp('ERR: No IMU Time Field Dectected');
end
% RCIN/RCOUT
switch(num2str(isfield(RCIN,{'TimeUS', 'TimeMS'})))
    case num2str([ 0 1])
        RCIN.Time = RCIN.TimeMS/1e3;
        RCOU.Time = RCOU.TimeMS/1e3;
    case num2str([ 1 0])
        RCIN.Time = RCIN.TimeUS/1e6
        RCOU.Time = RCOU.TimeUS/1e6
    otherwise
        disp('ERR: No RC Time Field Dectected');
end
% GPS
switch(num2str(isfield(RCIN,{'TimeUS', 'TimeMS'})))
    case num2str([ 0 1])
        GPS.Time = GPS.TimeMS/1e3;
    case num2str([ 1 0])
        GPS.Time = GPS.TimeUS/1e6
    otherwise
        disp('ERR: No GPS Time Field Dectected');
end
if exist('GPS2','var') == 1
    switch(num2str(isfield(GPS2,{'TimeUS', 'TimeMS'})))
    case num2str([ 0 1])
        GPS2.Time = GPS2.TimeMS/1e3;
    case num2str([ 1 0])
        GPS2.Time = GPS2.TimeUS/1e6
    otherwise
        disp('ERR: No GPS2 Time Field Dectected');
    end
end
%% Plotting Attitude
figure('units','normalized','outerposition',[0 0 1 1])
plot(ATT.Time,ATT.DesRoll,'r-', ATT.Time, ATT.Roll,'b-')
title('Desired Roll and Measured Roll');
xlabel('Time (s)')
ylabel('Centi-Degrees');
grid minor
legend('Desired Roll','Measured Roll')

figure('units','normalized','outerposition',[0 0 1 1])
plot(ATT.Time,ATT.DesPitch,'r-', ATT.Time, ATT.Pitch,'b-')
title('Desired Pitch and Measured Pitch');
xlabel('Time (s)')
ylabel('Centi-Degrees');
grid minor
legend('Desired Pitch','Measured Pitch')

%% Plotting IMU
figure('units','normalized','outerposition',[0 0 1 1])
plot(IMU.Time,IMU.AccX,'r-',IMU.Time, IMU.AccX,'b-')
title('X-Axis Accelerations');
xlabel('Time (s)')
ylabel('m/s^{2}');
grid on
legend('IMU 1','IMU 2')

figure('units','normalized','outerposition',[0 0 1 1])
plot(IMU.Time,IMU.AccY,'r-', IMU.Time, IMU2.AccY,'b-')
title('Y-Axis Accelerations');
xlabel('Time (s)')
ylabel('m/s^{2}');
grid on
legend('IMU 1','IMU 2')

figure('units','normalized','outerposition',[0 0 1 1])
plot(IMU.Time,IMU.AccZ,'r-', IMU.Time, IMU2.AccZ,'b-')
title('Z-Axis Accelerations');
xlabel('Time (s)')
ylabel('m/s^{2}');

grid on
legend('IMU 1','IMU 2')

%% Roll Input vs. Roll Output
figure('units','normalized','outerposition',[0 0 1 1])
hR1 = subplot(3,1,1);plot(RCIN.Time,RCIN.C1);
ylabel('Pulse-Width (s)');
xlabel('Time (s)');
title('Roll Input (RC)');
grid on
hR1.YLim = [min(RCIN.C1)-100,max(RCIN.C1)+100];

hR2 = subplot(3,1,2);plot(ATT.TimeUS/1E6,ATT.DesRoll,'linewidth',2);
ylabel('Centi-Degrees');
xlabel('Time (s)');
title('Commanded Roll Output (RC)');
grid on

hR3 = subplot(3,1,3);plot(ATT.TimeUS/1E6,ATT.Roll,'linewidth',2);
ylabel('Centi-Degrees');
xlabel('Time (s)');
title('Measured Roll');
grid on

axis tight
hR2.YLim = [-50,50];
hR3.YLim = [-50,50];
linkaxes([hR3 hR2 hR1],'x');
%% Pitch Input vs. Pitch Output
figure('units','normalized','outerposition',[0 0 1 1])
hR1 = subplot(3,1,1);plot(RCIN.Time,RCIN.C2);
ylabel('Pulse-Width (s)');
xlabel('Time (s)');
title('Roll Input (RC)');
grid on
hR1.YLim = [min(RCIN.C2)-100,max(RCIN.C2)+100];

hR2 = subplot(3,1,2);plot(ATT.TimeUS/1E6,ATT.DesPitch,'linewidth',2);
ylabel('Centi-Degrees');
xlabel('Time (s)');
title('Commanded Pitch Output (RC)');
grid on

hR3 = subplot(3,1,3);plot(ATT.TimeUS/1E6,ATT.Pitch,'linewidth',2);
ylabel('Centi-Degrees');
xlabel('Time (s)');
title('Measured Pitch');
grid on

axis tight
hR2.YLim = [-50,50];
hR3.YLim = [-50,50];
linkaxes([hR3 hR2 hR1],'x');

%% Desired Motion Plot
% close all
% for i = 1:length(NTUN(:,1))
%     subplot(2,1,1);plot(NTUN(:,4)/100,NTUN(:,5)/100);
%     hold on;
%     plot(NTUN(:,6)/100,NTUN(:,7)/100,'r-');
%     plot(NTUN(i,4)/100,NTUN(i,5)/100,'b*','markersize',10);
%     plot(NTUN(i,6)/100,NTUN(i,7)/100,'r*','markersize',10);
%     pause(0.05)
%     hold off
% end
% for i = 1:length(RCIN(:,1))
%     subplot(2,1,2);plot(TimeRC,RCIN(:,3));
%     hold on
%     plot(TimeRC(i),RCIN(i,3),'b*','markersize',10);
%     hold off
%     pause(0.05);
% end
%%
% close all;figure;
% for i = 1:length(DesRoll)
%     plot(Time,DesRoll,'b',Time,DesPitch,'r');
%     hold on
%     
%     plot(Time,Roll+100,'b.-',Time,Pitch+100,'r.-');
%     
%     plot(Time(i),DesRoll(i),'b*',Time(i),DesPitch(i),'r*','markersize',10);
%     plot(Time(i),Roll(i)+100,'bo',Time(i),Pitch(i)+100,'ro','markersize',10);
%     hold off
%     pause(0.05);
% end
%% Plotting Attitude
figure('units','normalized','outerposition',[0 0 1 1])

h1 = subplot(2,1,1);plot(ATT.Time,ATT.DesRoll-ATT.Roll,'r-')
title('Roll Error');
xlabel('Time (s)')

ylabel('Centi-Degrees');

grid on

h2 = subplot(2,1,2);plot(RCIN.Time,RCIN.C1,marker{3-2});
hold on
title('RC Roll Input');
xlabel('Time (s)')
ylabel('Input Pulse Width');

grid on
% linkaxes([h1 h2],'x');


figure('units','normalized','outerposition',[0 0 1 1])

h3 = subplot(2,1,1);plot(ATT.Time,ATT.DesPitch-ATT.Pitch,'r-')
title('Pitch Error');
xlabel('Time (s)')
ylabel('Centi-Degrees');

grid on
% legend('Desired Pitch','Measured Pitch','location','best')

h4 = subplot(2,1,2);plot(RCIN.Time,RCIN.C2,marker{4-2});
hold on
title('RC Pitch Input');
xlabel('Time (s)')
ylabel('Input Pulse Width');

grid on
linkaxes([h1 h2 h3 h4],'x');
%% GPS Comparison
%% GPS Sats and HDOP
figure('units','normalized','outerposition',[0 0 1 1])
hR1 = subplot(3,1,1);
plot(GPS.Time,GPS.NSats);
ylabel('N-Sats');
xlabel('Time (s)');
title('Number of GPS Satelites Aquired');

grid on

hR2 = subplot(3,1,2);
plot(GPS.Time,GPS.HDop);
ylabel('HDOP');
xlabel('Time (s)');
title('GPS HDOP (Lower is Better)');
grid on
axis tight

hR3 = subplot(3,1,3);
plot(RCIN.Time,RCIN.C3,'r-')
ylabel('Pulse-Width (ms)');
xlabel('Time (s)');
title('Throttle Input');
grid on
hR3.YLim = [800 2100]

linkaxes([hR1 hR2 hR3],'x');

if exist('GPS2','var') == 1
    GPS2_zeroLon = find(GPS2.Lng==0);
    GPS2.Lng(GPS2_zeroLon) = nan;
    GPS2_zeroLat = find(GPS2.Lat==0);
    GPS2.Lat(GPS2_zeroLat) = nan;
    floatRTK = find(GPS2.Status==4);
    fixedRTK = find(GPS2.Status==5);
    noRTKComms = find(GPS2.Status == 1);
    noRTKConnect = find(GPS2.Status == 0);
    legendEntry = [];
    
    figure('units','normalized','outerposition',[0 0 1 1])
    hold on;
    GPS_hand = plot(GPS.Lng,GPS.Lat,'k-o','DisplayName','Stock GPS')
    GPS_hand_Origin = plot(GPS.Lng(1),GPS.Lat(1),'r*','DisplayName','Stock GPS Start')
    legendEntry = [legendEntry,GPS_hand];
    legendString = {'Stock GPS'}
    if isempty(fixedRTK) ~= 1
        fixedRTK_hand = plot(GPS2.Lng(fixedRTK),GPS2.Lat(fixedRTK),'r-o','DisplayName','Fixed RTK');
        legendString{end+1} = 'Fixed RTK';
        legendEntry = [legendEntry,fixedRTK_hand];
    end
    if isempty(floatRTK) ~= 1
        floatRTK_hand = plot(GPS2.Lng(floatRTK),GPS2.Lat(floatRTK),'b-o','DisplayName','Float RTK');
        legendString{end+1} = 'Float RTK';
        legendEntry = [legendEntry,floatRTK_hand];
    end
    if isempty(noRTKComms) ~= 1
        noRTK_hand = plot(GPS2.Lng(noRTKComms),GPS2.Lat(noRTKComms),'ms','DisplayName','No RTK Comms');
        legendString{end+1} = 'no RTK Comms';
        legendEntry = [legendEntry,noRTK_hand];
    end
    legend(legendEntry,legendString,'location','bestoutside')
end
%% EKF
% plot(EKF1.TimeUS/1e6,EKF1.Pitch)