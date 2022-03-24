% function to detect the position of the ball at the kick
% Input:
% matchData - load(mat file of replay data of the soccer match)
% useWeight - boolean value whether the weight should be used in averaging; useWeight = 0 is a direct average and useWeight = 1 is a weight average 
% accel_th - acceleration threshold value to detect the kick, for fast kicks reccomended 2, for slow between 0.8 and 1
% varagrin - robots' ids, which estimations are used to give ball
% position. Should be listed with comma.
% Example: getBallPosition(matchData, useWeight,1,2,3) 
% Output:
% x, y, and z coordinates of the ball position

function [ball_x, ball_y, ball_z, ind] = detectKickBall(matchData,useWeight, accel_th, varargin)

%get velocity of the ball
[bvx, bvy, ~] = getBallVelocity(matchData, useWeight, varargin{:});
%speed_ball = hypot(bvx,bvy);
%[~, speed_ind, ~] = find(speed_ball);

%get acceleration
bax = diff(bvx,1);
bay = diff(bvy,1);
accel_ball = hypot(bax, bay);

[~, accel_ind, ~] = find(accel_ball>accel_th); 

%get output: ball position when acceleration exceeds threshold value
[bx, by, bz] = getBallPosition(matchData, useWeight, varargin{:});

ball_x = bx(accel_ind);
ball_y = by(accel_ind);
ball_z = bz(accel_ind);
ind = accel_ind;

end