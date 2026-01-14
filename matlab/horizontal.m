clc
clear all
close all

global l_O l_1 l_2 omega
l_O   = 50; %% Base Shaft
l_1   = 25; %% First Arm  (OB)
l_2   = 25; %% Second Arm (BA)
omega = 25; %% Theta's speed (rad/s)

%% X axis is theta
thetas = linspace(0,pi/3,1000)

function result = A_x(theta)
	global l_O l_1 l_2 omega
	l = l_1
	result = l*(cos(theta) + cos( -1 * theta ))
end

function result = V_A_x(theta)
	global l_O l_1 l_2 omega
	l = l_1
	result = -2*l*sin(theta)*omega
end

function result = Alpha_A_x(theta)
	global l_O l_1 l_2 omega
	l = l_1
	result = l*(omega^2)*( cos(-1*theta) - cos(theta) )
end
