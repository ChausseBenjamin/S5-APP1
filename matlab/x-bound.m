clc
clear all
close all

% Mechanical arm parameters
global l_0 l_1 l_2 omega_B
l_0 = 50e-2;    % Base shaft [m] (converted from 50cm)
l_1 = 25e-2;    % First arm (OB) [m] (converted from 25cm)
l_2 = 25e-2;    % Second arm (BA) [m] (converted from 25cm)
omega_B = 25;   % Angular velocity of motor B [rad/s]

% For x-bound motion constraint: phi = -theta
% This means the second arm moves opposite to the first arm

function result = A_x(theta)
    global l_1 l_2
    % Position of point A in x-direction
    % A_x = l_1*cos(theta) + l_2*cos(phi)
    % With phi = -theta: A_x = l_1*cos(theta) + l_2*cos(-theta)
    % Since cos(-theta) = cos(theta): A_x = l_1*cos(theta) + l_2*cos(theta)
    result = l_1 * cos(theta) + l_2 * cos(theta);
end

function result = V_Ax(theta)
    global l_1 l_2 omega_B
    % Velocity of point A in x-direction
    % A_x = l_1*cos(theta) + l_2*cos(theta) = (l_1 + l_2)*cos(theta)
    % V_Ax = dA_x/dt = -(l_1 + l_2)*sin(theta)*theta_dot
    theta_dot = omega_B;
    result = -(l_1 + l_2) * sin(theta) * theta_dot;
end

function result = Alpha_Ax(theta)
    global l_1 l_2 omega_B
    % Acceleration of point A in x-direction
    % V_Ax = -(l_1 + l_2)*sin(theta)*theta_dot
    % Alpha_Ax = dV_Ax/dt = -(l_1 + l_2)*[cos(theta)*theta_dot^2 + sin(theta)*theta_ddot]
    theta_dot = omega_B;
    theta_ddot = 0;  % Constant angular velocity, so acceleration = 0

    result = -(l_1 + l_2) * cos(theta) * theta_dot^2;
end

% Define theta range from 0 to pi/3 radian
dt = 1e-3;
thetas = [0:dt:pi/3];

% Pre-allocate arrays
A_x_values = zeros(size(thetas));
V_Ax_values = zeros(size(thetas));
Alpha_Ax_values = zeros(size(thetas));

% Compute values for each theta
for k = 1:length(thetas)
    A_x_values(k) = A_x(thetas(k));
    V_Ax_values(k) = V_Ax(thetas(k));
    Alpha_Ax_values(k) = Alpha_Ax(thetas(k));
end

% Set gnuplot as graphics toolkit and force specific options
graphics_toolkit('gnuplot');

% Plot 1: Position A_x(theta)
figure(1)
plot(thetas, A_x_values, '-', 'linewidth', 4, 'Color', '#00BA38')
grid on
xlabel('{/Symbol q} (rad)')
ylabel('A_x (m)')
axis tight
% Set figure size and position to minimize margins
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [6 4]);
set(gcf, 'PaperPosition', [0 0 6 4]);
print('rapport/figures/x-bound-pos.pdf', '-dpdf', '-color');

% Plot 2: Velocity V_Ax(theta)
figure(2)
plot(thetas, V_Ax_values, '-', 'linewidth', 4, 'Color', '#629CFF')
grid on
xlabel('{/Symbol q} (rad)')
ylabel('V_{Ax} (m/s)')
axis tight
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [6 4]);
set(gcf, 'PaperPosition', [0 0 6 4]);
print('rapport/figures/x-bound-v.pdf', '-dpdf', '-color');

% Plot 3: Acceleration Alpha_Ax(theta)
figure(3)
plot(thetas, Alpha_Ax_values, '-', 'linewidth', 4, 'Color', '#F8766D')
grid on
xlabel('{/Symbol q} (rad)')
ylabel('{/Symbol a}_{Ax} (m/s^2)')
axis tight
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [6 4]);
set(gcf, 'PaperPosition', [0 0 6 4]);
print('rapport/figures/x-bound-alpha.pdf', '-dpdf', '-color');

fprintf('\nPDF files have been generated with gnuplot:\n');
fprintf('- rapport/figures/x-bound-pos.pdf\n');
fprintf('- rapport/figures/x-bound-v.pdf\n');
fprintf('- rapport/figures/x-bound-alpha.pdf\n');

% Display some key values
fprintf('At theta = 0 rad:\n');
fprintf('  A_x = %.4f m\n', A_x(0));
fprintf('  V_Ax = %.4f m/s\n', V_Ax(0));
fprintf('  Alpha_Ax = %.4f m/s^2\n', Alpha_Ax(0));

fprintf('At theta = pi/3 rad:\n');
fprintf('  A_x = %.4f m\n', A_x(pi/3));
fprintf('  V_Ax = %.4f m/s\n', V_Ax(pi/3));
fprintf('  Alpha_Ax = %.4f m/s^2\n', Alpha_Ax(pi/3));
