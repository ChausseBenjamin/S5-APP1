clc
clear all
close all

% Global parameters following the structure from example.m
global l_0 l_1 l_2 omega
l_0 = 50e-2; %% Base Shaft (converted to meters)
l_1 = 25e-2; %% First Arm (OB) (converted to meters)  
l_2 = 25e-2; %% Second Arm (BA) (converted to meters)
omega = 25; %% Angular velocity (rad/s)

% Position functions for x-bound motion (phi = -theta)
function result = pos_A_x(theta)
    global l_1 l_2
    % A_x = l_1*cos(theta) + l_2*cos(-theta) = l_1*cos(theta) + l_2*cos(theta)
    result = l_1 * cos(theta) + l_2 * cos(-theta);
end

function result = pos_A_y(theta)
    global l_0 l_1 l_2
    % A_y = l_0 + l_1*sin(theta) + l_2*sin(-theta)
    result = l_0 + l_1 * sin(theta) + l_2 * sin(-theta);
end

% Velocity functions (from LaTeX equations 259-269)
function result = vel_A_x(theta)
    global l_1 l_2 omega
    % V_A_x = -l_1*sin(theta)*omega + l_2*sin(-theta)*omega
    result = -l_1 * sin(theta) * omega + l_2 * sin(-theta) * omega;
end

function result = vel_A_y(theta)
    global l_1 l_2 omega
    % V_A_y = l_1*cos(theta)*omega - l_2*cos(-theta)*omega
    result = l_1 * cos(theta) * omega - l_2 * cos(-theta) * omega;
end

% Acceleration functions (from LaTeX equations 270-282)
function result = acc_A_x(theta)
    global l_1 l_2 omega
    % alpha_A_x = -l_1*cos(theta)*omega^2 + l_2*cos(-theta)*omega^2
    result = -l_1 * cos(theta) * omega^2 + l_2 * cos(-theta) * omega^2;
end

function result = acc_A_y(theta)
    global l_1 l_2 omega
    % alpha_A_y = -l_1*sin(theta)*omega^2 + l_2*sin(-theta)*omega^2
    result = -l_1 * sin(theta) * omega^2 + l_2 * sin(-theta) * omega^2;
end

%% Analysis from theta=0 to theta=pi/3
dt = 1e-3;
thetas = [0:dt:pi/3];

% Pre-allocate vectors for efficiency
A_x_pos = zeros(length(thetas), 1);
A_y_pos = zeros(length(thetas), 1);
A_x_vel = zeros(length(thetas), 1);
A_y_vel = zeros(length(thetas), 1);
A_x_acc = zeros(length(thetas), 1);
A_y_acc = zeros(length(thetas), 1);

% Compute all values
for k = 1:length(thetas)
    A_x_pos(k) = pos_A_x(thetas(k));
    A_y_pos(k) = pos_A_y(thetas(k));
    A_x_vel(k) = vel_A_x(thetas(k));
    A_y_vel(k) = vel_A_y(thetas(k));
    A_x_acc(k) = acc_A_x(thetas(k));
    A_y_acc(k) = acc_A_y(thetas(k));
end

%% Create 2D plots for position, velocity, and acceleration

% Position plots
figure(1)
subplot(2,1,1)
plot(thetas, A_x_pos, 'b-', 'LineWidth', 2)
grid on
xlabel('\theta (rad)')
ylabel('A_x (m)')
title('Position Component X vs \theta')

subplot(2,1,2)
plot(thetas, A_y_pos, 'r-', 'LineWidth', 2)
grid on
xlabel('\theta (rad)')
ylabel('A_y (m)')
title('Position Component Y vs \theta')

% Velocity plots
figure(2)
subplot(2,1,1)
plot(thetas, A_x_vel, 'b-', 'LineWidth', 2)
grid on
xlabel('\theta (rad)')
ylabel('V_{A_x} (m/s)')
title('Velocity Component X vs \theta')

subplot(2,1,2)
plot(thetas, A_y_vel, 'r-', 'LineWidth', 2)
grid on
xlabel('\theta (rad)')
ylabel('V_{A_y} (m/s)')
title('Velocity Component Y vs \theta')

% Acceleration plots
figure(3)
subplot(2,1,1)
plot(thetas, A_x_acc, 'b-', 'LineWidth', 2)
grid on
xlabel('\theta (rad)')
ylabel('\alpha_{A_x} (m/s^2)')
title('Acceleration Component X vs \theta')

subplot(2,1,2)
plot(thetas, A_y_acc, 'r-', 'LineWidth', 2)
grid on
xlabel('\theta (rad)')
ylabel('\alpha_{A_y} (m/s^2)')
title('Acceleration Component Y vs \theta')

% Combined trajectory plot (bonus)
figure(4)
plot(A_x_pos, A_y_pos, 'g-', 'LineWidth', 2)
grid on
xlabel('A_x (m)')
ylabel('A_y (m)')
title('Trajectory of point A (X-bound motion, \phi = -\theta)')
axis equal

% Display some key values
fprintf('Analysis for x-bound motion (phi = -theta)\n');
fprintf('Parameters: l_0=%.2f m, l_1=%.2f m, l_2=%.2f m, omega=%.1f rad/s\n', l_0, l_1, l_2, omega);
fprintf('Theta range: 0 to pi/3 (%.3f rad)\n', pi/3);
fprintf('\nInitial values (theta=0):\n');
fprintf('Position: A_x=%.3f m, A_y=%.3f m\n', A_x_pos(1), A_y_pos(1));
fprintf('Velocity: V_A_x=%.3f m/s, V_A_y=%.3f m/s\n', A_x_vel(1), A_y_vel(1));
fprintf('Acceleration: alpha_A_x=%.3f m/s^2, alpha_A_y=%.3f m/s^2\n', A_x_acc(1), A_y_acc(1));
fprintf('\nFinal values (theta=pi/3):\n');
fprintf('Position: A_x=%.3f m, A_y=%.3f m\n', A_x_pos(end), A_y_pos(end));
fprintf('Velocity: V_A_x=%.3f m/s, V_A_y=%.3f m/s\n', A_x_vel(end), A_y_vel(end));
fprintf('Acceleration: alpha_A_x=%.3f m/s^2, alpha_A_y=%.3f m/s^2\n', A_x_acc(end), A_y_acc(end));