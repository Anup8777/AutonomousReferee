% Function to get the position of the player given the replay data and robots' id
% Inputs:
% matchData - load(mat file of replay data of the soccer match)
% id - robot's id, which position is asked
% Example: getPlayerPosition(matchData, 1) 
% Output:
% x, y, and theta values of the player position

function [x, y, theta, team_color] = getPlayerPosition(matchData, id)

    matchData = matchData.replay; % get data
    robot_ind = matchData.metadata.turtle(id).idx_pose; % pose indices of the robot in data
    team_color =  matchData.data(matchData.metadata.turtle(id).idx_teamcolor); % get team color to which robot belongs (1 or 0)

    if team_color == 1
        orientation = 1;
    else 
        orientation = -1; % opposite team has an inverted orientation
    end

    % Set pose of the robot
    x = orientation*matchData.data(robot_ind(1), :);
    y = orientation*matchData.data(robot_ind(2), :);
    theta = matchData.data(robot_ind(3), :) - (1-orientation)*pi/2;

end