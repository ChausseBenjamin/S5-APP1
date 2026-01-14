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

function result = A_y(theta)
	global l_0 l_1 l_2 omega
	l = l_1
	result = l* (1+ sin(theta) + sin( acos(1-cos(theta)) ) )
end

function result = V_A_y(theta)
	global l_0 l_1 l_2 omega
	result = l*(cos(theta)*omega - cos( acos(1-cos(theta)) ) * (sin(theta)*omega/sin( acos(1-cos(theta)) )) )
end
