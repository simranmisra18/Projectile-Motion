clc;    
close all;  
clear;   
workspace;   
 
format long g; 
format compact; 
fontSize = 10; 
g = -9.81;   
x0 = 0;    
y0 = 10;   
v0 = 16;   
angle = 45;   
 
defaultValue = {num2str(angle), num2str(x0), num2str(y0), num2str(v0)}; 
titleBar = 'Enter values'; 
userPrompt = {'Initial angle (in degrees): ', 'Initial launch lateral distance (in meters): ', 'Initial launch height (in 
meters): ', 'Initial velocity (in meters per second): '}; 
caUserInput = inputdlg(userPrompt, titleBar, 1, defaultValue, 'on'); 
if isempty(caUserInput), 
    return, 
end      %Incase they clicked Cancel. 
 
3 
 
 
% Convert to floating point from string. 
usersValue1 = str2double(caUserInput{1}); 
usersValue2 = str2double(caUserInput{2}); 
usersValue3 = str2double(caUserInput{3}); 
usersValue4 = str2double(caUserInput{4}); 
 
% Check for a valid number. 
if isnan(usersValue1) 
    usersValue1 = str2double(defaultValue{1}); 
    message = sprintf('ERROR: A number had to be entered.\nUsed %.2f and continue.', usersValue1); 
    uiwait(warndlg(message)); 
end 
if isnan(usersValue2) 
    usersValue2 = str2double(defaultValue{2}); 
    message = sprintf('ERROR: A number had to be entered.\nUsed %.2f and continue.', usersValue1); 
    uiwait(warndlg(message)); 
end 
if isnan(usersValue3) 
    usersValue3 = str2double(defaultValue{3}); 
    message = sprintf('ERROR: A number had to be a entered.\nUsed %.2f and continue.', usersValue1); 
    uiwait(warndlg(message)); 
end 
angle = usersValue1; 
x0 = usersValue2; 
y0 = usersValue3; 
v0 = usersValue4; 
 
% Get the x and y components of velocity (in x and y directions) 
v0x = v0*cosd(angle); 
v0y = v0*sind(angle); 
 
% Compute the distance along the y-direction.  y = y0 +y_velocity_initial.* time +(1/2)*g*time^2 
% Now assume that the y is zero when the projectile hits the ground. 
4 
 
% So we basically have the familiar quadratic equation : 0 = a*time^2 + b * time + c,  
% where a = (1/2)*g, b = y_velocity_initial, and c = y0. 
% When the projectile lands on the ground, we have y=0. Time is tFinal now. 
% So basically we have 0 = a*tFinal^2 + b * tFinal + c 
a = (1/2) * g; 
b = v0y; 
c = y0; 
tFinal = roots([a, b, c]) 
tFinal = max(tFinal); % Take only the positive value of the times. 
 
% To double check that y is zero at time tFinal 
yFinal = y0+ v0y * tFinal + (1/2) * g * tFinal .^2; 
 
% Calculate the range in the x direction. 
xFinal = x0 + v0x * tFinal 
 
% Compute the final velocity when it hits the ground. 
% First compute the final velocity in the x direction. 
% It's the same as the initial since gravity doesn't operate horizontally. 
vX_final = v0x   
% Then compute the final velocity in the y direction. 
vY_final = v0y + g * tFinal 
% Final velocity 
vFinal = sqrt(vX_final ^ 2 + vY_final ^ 2) 
% Let's make up a time vector going from 0 to tFinal rounded up to the next larger integer. 
t = linspace(0, tFinal, 1000); 
% Compute the distance along the x direction.   
x = x0 + v0x * t; 
% Compute the distance along the y direction (the height).  
y = y0 + v0y * t + (1/2) * g * t .^ 2; 
  % Put y to 0. It will not penetrate the ground and have a negative y. 
y(y < 0) = 0; 
% Here velocity for every single time point. 
v_x = v0x * ones(1, length(t));  
5 
 
v_y = v0y + g * t; 
 
% This velocity is along the direction of travel -- ALONG the curve, not in the x and y direction separately 
(which are vx and vy). 
velocity = sqrt(v_x .^ 2 + v_y .^ 2); 
% When the projectile is at its maximum height, this will be when v_y = 0 and projectile will turn around (in 
vertical direction). 
% OR if the projectile is aimed downward (the angle is negative), it will be y0.If the angle is negative, it's 
pointed down so the max height will be at time = 0. 
tTop = max([- v0y / g, 0]) 
% Compute the y value at the top.  y = y0 +y_velocity_initial * time +(1/2)*g*time^2 
xTop = x0 + v0x * tTop 
yTop = y0 + v0y * tTop + (1/2) * g * tTop .^ 2 
% The velocity in the direction of travel when it's at the top will either be 
% v0x, for when the angle is positive and the projectile is aimed upwards, OR 
% the initial velocity, for when the angle is downwards. 
if angle > 0 
 % Aimed upwards. Velocity at top will be initial velocity in the x direction. 
 vTop = v0x 
else 
 % Aimed downwards. Velocity at top will be initial velocity in the direction of travel. 
 vTop = v0 
end 
 
% Plot the location of the projectile. 
hFigure = figure; 
subplot(2, 2, 1); 
plot(x, y, 'b-', 'LineWidth', 3); 
grid on; 
xlabel('x-axis (meters)', 'FontSize', fontSize); 
ylabel('y-axis (meters)', 'FontSize', fontSize); 
title ('Projectile Trajectory', 'FontSize', fontSize) 
% x and y have the same scale and the angles will look correct. 
axis equal; 
6 
 
% Make x axis start at 0. 
xl = xlim(); 
xlim([0, xl(end)]);  
% Make y axis start at 0. 
yl = ylim();  
yl(2) = max(yl(2), yTop); 
ylim([0, yl(2)]); 
 
% Making y axis start at 0. 
yl = ylim(); % Getting current y axis limits 
yl(2) = max(yl(2), yTop); 
ylim([0, yl(2)]); % Making bottom limit 0. 
line([xTop, xTop], [0, yTop], 'Color', 'r', 'LineWidth', 2); 
line([0, xTop], [yTop, yTop], 'Color', 'r', 'LineWidth', 2); 
 
 
% Enlarge figure to full screen. 
set(gcf,'Units','Normalized', 'OuterPosition',[0, 0.1, 1, 0.9]); 
% Giving name to the title bar 
set(gcf,'Name','Projectile Trajectory','NumberTitle', 'Off') 
 
%Plotting height of projectile 
subplot(2,2,2); 
plot(t, y, 'b-', 'LineWidth', 3); 
grid on; 
xlabel('Time(sec)', 'FontSize', fontSize); 
ylabel('Y Coordinate(m)', 'FontSize', fontSize); 
line([tTop, tTop], [0, yTop], 'Color', 'r', 'LineWidth', 2); 
line([0, tTop], [yTop, yTop], 'Color', 'r', 'LineWidth', 2); 
title ('Projectile Height vs function of Time', 'FontSize', fontSize); 
 
 
%Plotting velocity as a function of distance 
subplot(2, 2, 3); 
7 
 
plot(x, velocity, 'b-', 'LineWidth', 3); 
grid on; 
xlabel('Distance(m)', 'FontSize', fontSize); 
ylabel('Velocity in Direction of Travel(m/s)', 'FontSize', fontSize); 
title ('Projectile Velocity vs Distance', 'FontSize', fontSize); 
line([xTop, xTop], [0, vTop], 'Color', 'r', 'LineWidth', 2); 
line([xFinal, xFinal], [0, vFinal], 'Color', 'r', 'LineWidth', 2); 
line([0, xTop], [vTop, vTop], 'Color', 'r', 'LineWidth', 2); 
line([0, xFinal], [vFinal, vFinal], 'Color', 'r', 'LineWidth', 2); 
 
%Plotting velocity as a function of time 
subplot(2, 2, 4); 
plot(t, velocity, 'b-', 'LineWidth', 3); 
grid on; 
xlabel('Time(sec)', 'FontSize', fontSize); 
ylabel('Velocity in Direction of Travel(m/s)', 'FontSize', fontSize); 
title ('Projectile Velocity vs Time', 'FontSize', fontSize); 
line([tTop, tTop], [0, vTop], 'Color', 'r', 'LineWidth', 2); 
line([tFinal, tFinal], [0, vFinal], 'Color', 'r', 'LineWidth', 2); 
line([0, tTop], [vTop, vTop], 'Color', 'r', 'LineWidth', 2); 
line([0, tFinal], [vFinal, vFinal], 'Color', 'r', 'LineWidth', 2); 
 
 
 
% Display final results 
s1 = sprintf('Total time of travel= %f sec.\n', tFinal); 
s2 = sprintf('Maximum x coordinate= %f m.\n', xFinal); 
s3 = sprintf('Range= %f m.\n', xFinal - x0); 
s4 = sprintf('Distance x until the top= %f m.\n', xTop); 
s5 = sprintf('Max height y at the top= %f m.\n', yTop); 
s6 = sprintf('Time taken until the top is %f sec.\n', tTop); 
s7 = sprintf('Min velocity at the top= %f m/s.\n', vTop); 
s8 = sprintf('Max velocity at the end= %f m/s.\n', vFinal); 
message = sprintf('%s%s%s%s%s%s%s%s', s1, s2, s3, s4, s5, s6, s7, s8); 
8 
 
uiwait(helpdlg(message, 'Final Results')); 
 
%----Trajectory for several angles 
 
angle = 90;        %To find maximum time of flight, which is when projectile is thrown 90 degree into the air. 
v0x = v0*cosd(angle); 
v0y = v0*sind(angle); 
 
a = (1/2) * g; 
b = v0y; 
c = y0; 
tFinal = roots([a, b, c]); 
tFinal = max(tFinal);      %That is, the positive value is taken 
hFig2 = figure();          %Form new Figure 
 
% Creating a time vector going from 0 to tFinal rounded up to the next larger integer 
t = linspace(0, tFinal, 1000); 
legends = {}; % Instantiating an empty cell for the angle legend. 
counter = 1; 
for angle = 5 : 10 : 90 
 v0x = v0*cosd(angle);    %Component in x direction 
 v0y = v0*sind(angle);    %Component in y direction   
 % Formula: x = x0 + x_velocity * time. 
 x = x0 + v0x * t; 
 % Formula: y = y0 + y_velocity_initial * time + (1/2)*g*time^2 
 y = y0 + v0y * t + (1/2) * g * t .^ 2; 
 % Clipping y to zero as we assume the projectile stays on the ground when it hits.   
 % No penetration, so no negative y. 
 y(y < 0) = 0; 
 indexHitGround=find(y>0,1,'last'); 
 
 plot(x, y, '-', 'LineWidth', 2); 
 hold on; 
 legends{end+1} = sprintf('Angle = %d', angle); 
9 
 
  
 % Calculating the range in x direction. 
 xFinal(counter) = x(indexHitGround); 
 counter = counter + 1;  
end 
grid on; 
xlabel('X Coordinate(m)', 'FontSize', fontSize); 
ylabel('Y Coordinate(m)', 'FontSize', fontSize); 
title ('Projectile Trajectory for a Variety of Angles', 'FontSize', fontSize) 
line(xlim, [y0, y0], 'Color', 'k', 'LineWidth', 2); 
legends{end+1} = 'Starting Height'; 
legend(legends); 
xlim([0, max(xFinal)]);       % Finding the max xFinal and setting the range of the graph to be that 
 
% Enlarge figure to full screen. 
set(gcf,'Units','Normalized','OuterPosition', [0.1, 0.15, 0.8, 0.7]); 
set(gcf,'Name','Projectile Trajectory With Variety of Angles','NumberTitle','Off');
