% Function to get the position of the ball given the replay data and robots' id, which are the source of ball estimation
% Inputs:
% matchData - load(mat file of replay data of the soccer match)
% varagring - robots' ids, which estimations are used to give ball
% position. Should be listed with comma.
% Example: getBallPosition2(matchData, 1,2,3) 
% Output:
% x, y, and z coordinates of the ball position

function [x,y,z] = getBallPosition2(matchData, varargin) 

    matchData = matchData.replay; % load data
    
    % initialize ball pose
    x = 0;
    y = 0;
    z = 0;
    
    numRob = nargin - 1; % number of robots from which ball is estimated; -1 to exlude 1st argument, which is matchData
    
    if numRob == 1
        if floor(varargin{1}) == varargin{1} && varargin{1} > 0 && varargin{1} < 8
            ball_ind1 = matchData.metadata.turtle(varargin{1}).idx_ball; 
            x = matchData.data(ball_ind1(1), :);
            y = matchData.data(ball_ind1(2), :);
            z = matchData.data(ball_ind1(3), :); 
        end
    else
        for i = 1:numRob
            ball_ind = matchData.metadata.turtle(varargin{i}).idx_ball; 
            x = x + matchData.data(ball_ind(1), :);
            y = y + matchData.data(ball_ind(2), :);
            z = z + matchData.data(ball_ind(3), :);
        end
         x = x/numRob;
         y = y/numRob;
         z = z/numRob;
    end
end