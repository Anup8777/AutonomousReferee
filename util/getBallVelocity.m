% Function to get the position of the ball given the replay data and robots' id, which are the source of ball estimation
% Inputs:
% matchData - load(mat file of replay data of the soccer match)
% useWeight - boolean value whether the weight should be used in averaging; useWeight = 0 is a direct average and useWeight = 1 is a weight average
% playerIDs - robots' ids, whose estimations are used to give ball
% position. Should be listed as 1xN matrix.
% Example: getBallVelocity(matchData, useWeight, [2,3])
% Output:
% x, y, and z coordinates of the ball position
function [vx,vy,vz] = getBallVelocity(matchData, useWeight, playerIDs)

matchData = matchData.replay; % load data

% initialize ball pose
vx = 0;
vy = 0;
vz = 0;
t=zeros(1,size(matchData.data,2));

numRob = length(playerIDs); % number of robots from which ball is estimated; -1 to exlude 1st argument, which is matchData

if numRob == 1
    ball_ind1 = matchData.metadata.turtle(playerIDs).idx_ball_xyz_vxvyvz_est;
    vx = matchData.data(ball_ind1(4), :);
    vy = matchData.data(ball_ind1(5), :);
    vz = matchData.data(ball_ind1(6), :);
    
else
    if useWeight == 0
        for i = 1:numRob
            ball_ind = matchData.metadata.turtle(playerIDs(i)).idx_ball_xyz_vxvyvz_est;
            vx = vx + matchData.data(ball_ind(4), :);
            vy = vy + matchData.data(ball_ind(5), :);
            vz = vz + matchData.data(ball_ind(6), :);
        end
        vx = vx/numRob;
        vy = vy/numRob;
        vz = vz/numRob;
    else
        for i = 1:numRob
            ball_ind = matchData.metadata.turtle(playerIDs(i)).idx_ball_xyz_vxvyvz_est;
            weight_ind = matchData.metadata.turtle(playerIDs(i)).idx_ball_confidence;
            vx = vx + matchData.data(ball_ind(4), :).*matchData.data(weight_ind, :);
            vy = vy + matchData.data(ball_ind(5), :).*matchData.data(weight_ind, :);
            vz = vz + matchData.data(ball_ind(6), :).*matchData.data(weight_ind, :);
            t = t + matchData.data(weight_ind, :);
        end
        vx = vx./t;
        vy = vy./t;
        vz = vz./t;
    end
end
end