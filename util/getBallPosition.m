% Function to get the position of the ball given the replay data and robots' id, which are the source of ball estimation
% Inputs:
% matchData - load(mat file of replay data of the soccer match)
% playerIDs - robots' ids, whose estimations are used to give ball
% position. Should be listed as 1xN matrix.
% Example: getBallVelocity(matchData, useWeight, [2,3]) 
% Output:
% x, y, and z coordinates of the ball position

function [x,y,z] = getBallPosition(matchData, useWeight, playerIDs) 

    matchData = matchData.replay; % load data
    
    % initialize ball pose
    x = 0;
    y = 0;
    z = 0;
    t=zeros(1,size(matchData.data,2));
    
    numRob = length(playerIDs); % number of robots from which ball is estimated; -1 to exlude 1st argument, which is matchData
    
    if useWeight == 0
        if numRob == 1
                ball_ind1 = matchData.metadata.turtle(playerIDs).idx_ball; 
                x = matchData.data(ball_ind1(1), :);
                y = matchData.data(ball_ind1(2), :);
                z = matchData.data(ball_ind1(3), :); 
        else
            for i = 1:numRob
                ball_ind = matchData.metadata.turtle(playerIDs(i)).idx_ball; 
                x = x + matchData.data(ball_ind(1), :);
                y = y + matchData.data(ball_ind(2), :);
                z = z + matchData.data(ball_ind(3), :);
            end
             x = x/numRob;
             y = y/numRob;
             z = z/numRob;
        end
    else
        if numRob == 1
                ball_ind1 = matchData.metadata.turtle(playerIDs).idx_ball; 
                x = matchData.data(ball_ind1(1), :);
                y = matchData.data(ball_ind1(2), :);
                z = matchData.data(ball_ind1(3), :); 
        else
            for i = 1:numRob
                ball_ind = matchData.metadata.turtle(playerIDs(i)).idx_ball;
                weight_ind = matchData.metadata.turtle(playerIDs(i)).idx_ball_confidence;
                x = x + matchData.data(ball_ind(1), :).*matchData.data(weight_ind, :);
                y = y + matchData.data(ball_ind(2), :).*matchData.data(weight_ind, :);
                z = z + matchData.data(ball_ind(3), :).*matchData.data(weight_ind, :);
                t=t+matchData.data(weight_ind, :);
            end
             x = x./t;
             y = y./t;
             z = z./t;
        end
    end
end