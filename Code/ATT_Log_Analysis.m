% Mission Planner Log Attitude Analysis
close all
clc; 
[filename, pathname] = uigetfile('*.mat', 'MATLAB Log File');                                       %Prompt user for log file
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
title('Desired Roll and Measured Roll','fontsize',16);
xlabel('Time (s)','fontsize',14)
ylabel('Centi-Degrees','fontsize',14);
set(gca,'fontsize',14)
grid on
legend('Desired Roll','Measured Roll')

figure(2)
plot(Time,DesPitch,'r-', Time, Pitch,'b-','linewidth',2)
title('Desired Pitch and Measured Pitch','fontsize',16);
xlabel('Time (s)','fontsize',14)
ylabel('Centi-Degrees','fontsize',14);
set(gca,'fontsize',14)
grid on
legend('Desired Pitch','Measured Pitch')

%% Plotting IMU
figure(3)
plot(TimeIMU,AccX1,'r-', TimeIMU, AccX2,'b-','linewidth',2)
title('X-Axis Accelerations','fontsize',16);
xlabel('Time (s)','fontsize',14)
ylabel('m/s^{2}','fontsize',14);
set(gca,'fontsize',14)
grid on
legend('IMU 1','IMU 2')

figure(4)
plot(TimeIMU,AccY1,'r-', TimeIMU, AccY2,'b-','linewidth',2)
title('Y-Axis Accelerations','fontsize',16);
xlabel('Time (s)','fontsize',14)
ylabel('m/s^{2}','fontsize',14);
set(gca,'fontsize',14)
grid on
legend('IMU 1','IMU 2')

figure(5)
plot(TimeIMU,AccZ1,'r-', TimeIMU, AccZ2,'b-','linewidth',2)
title('Z-Axis Accelerations','fontsize',16);
xlabel('Time (s)','fontsize',14)
ylabel('m/s^{2}','fontsize',14);
set(gca,'fontsize',14)
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
xlabel('Time (s)','fontsize',14)
ylabel('Motor Pulse Width','fontsize',14);
set(gca,'fontsize',14)
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
xlabel('Time (s)','fontsize',14)
ylabel('Input Pulse Width','fontsize',14);
set(gca,'fontsize',14)
grid on
% legend('Roll','Pitch','Throttle','Yaw','location','BestOutside')
legend('Roll','Pitch','Min RC Input','Max RC Input','location','BestOutside')

%% Roll Input vs. Roll Output
figure;
hR1 = subplot(2,1,1);
plot(TimeRC,RCIN(:,3),'linewidth',2);
ylabel('Pulse-Width (ms)','fontsize',14);
xlabel('Time (s)','fontsize',14);
title('Roll Input (RC)','fontsize',16);
grid on
set(gca,'fontsize',14)
hR2 = subplot(2,1,2);
plot(Time,DesRoll,'linewidth',2);
ylabel('Centi-Degrees','fontsize',14);
xlabel('Time (s)','fontsize',14);
title('Commanded Roll Output (RC)','fontsize',16);
grid on
set(gca,'fontsize',14)
linkaxes([hR1 hR2],'x');
hR2.YLim = [-50,50];
%% GPS Sats and HDOP
figure;
TimeGPS = (GPS(:,3)-GPS(1,3))/1000;   %Convert time from ms to s
hR1 = subplot(3,1,1);
plot(TimeGPS,GPS(:,5),'linewidth',2);
ylabel('N-Sats','fontsize',14);
xlabel('Time (s)','fontsize',14);
title('Number of GPS Satelites Aquired','fontsize',16);
grid on
set(gca,'fontsize',14)
hR2 = subplot(3,1,2);
plot(TimeGPS,GPS(:,6),'linewidth',2);
ylabel('HDOP','fontsize',14);
xlabel('Time (s)','fontsize',14);
title('GPS HDOP (Lower is Better)','fontsize',16);
set(gca,'fontsize',14)
grid on

hR3 = subplot(3,1,3);
plot(TimeRC,RCIN(:,5),'r-','linewidth',2)
ylabel('Pulse-Width (ms)','fontsize',14);
xlabel('Time (s)','fontsize',14);
title('Throttle Input','fontsize',16);
grid on
set(gca,'fontsize',14)
linkaxes([hR1 hR2 hR3],'x');
hR2.YLim = [-50,50];

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
% %%
% close all;figure;
%  for i = 1:length(DesRoll)
% plot(Time,DesRoll,'b',Time,DesPitch,'r');
% hold on
% 
% plot(Time,Roll+100,'b.-',Time,Pitch+100,'r.-');
% 
% plot(Time(i),DesRoll(i),'b*',Time(i),DesPitch(i),'r*','markersize',10);
% plot(Time(i),Roll(i)+100,'bo',Time(i),Pitch(i)+100,'ro','markersize',10);
% hold off
% pause(0.05);
% end
%% Plotting Attitude
figure
h1 = subplot(2,1,1);plot(Time,DesRoll,'r-', Time, Roll,'b-','linewidth',2)
title('Desired Roll and Measured Roll','fontsize',16);
xlabel('Time (s)','fontsize',14)
ylabel('Centi-Degrees','fontsize',14);
set(gca,'fontsize',14)
grid on
legend('Desired Roll','Measured Roll','location','best')

h2 = subplot(2,1,2);plot(TimeRC,RCIN(:,3),marker{3-2},'linewidth',2);
hold on
RC_Diff = RC_Max(1)-RC_Min(1);
RC_HalfMax = RC_Max(1)-(RC_Diff/4);
RC_HalfMin = RC_Min(1)+(RC_Diff/4);
plot(TimeRC,ones(length(TimeRC),1)*RC_HalfMin,'r-.',TimeRC,ones(length(TimeRC),1)*RC_HalfMax,'r--','linewidth',2);
title('RC Roll Input','fontsize',16);
xlabel('Time (s)','fontsize',14)
ylabel('Input Pulse Width','fontsize',14);
set(gca,'fontsize',14)
grid on
% linkaxes([h1 h2],'x');


figure
h3 = subplot(2,1,1);plot(Time,DesPitch,'r-', Time, Pitch,'b-','linewidth',2)
title('Desired Pitch and Measured Pitch','fontsize',16);
xlabel('Time (s)','fontsize',14)
ylabel('Centi-Degrees','fontsize',14);
set(gca,'fontsize',14)
grid on
legend('Desired Pitch','Measured Pitch','location','best')

h4 = subplot(2,1,2);plot(TimeRC,RCIN(:,4),marker{4-2},'linewidth',2);
hold on
plot(TimeRC,ones(length(TimeRC),1)*RC_HalfMin,'r-.',TimeRC,ones(length(TimeRC),1)*RC_HalfMax,'r--','linewidth',2);
title('RC Pitch Input','fontsize',16);
xlabel('Time (s)','fontsize',14)
ylabel('Input Pulse Width','fontsize',14);
set(gca,'fontsize',14)
grid on
linkaxes([h1 h2 h3 h4],'x');
