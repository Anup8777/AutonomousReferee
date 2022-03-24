% Function to get the position of the player given the replay data and robots' id
% Inputs:
% matchData - load(mat file of replay data of the soccer match)
% id - robot's id, which position is asked
% Example: getPlayerPosition(matchData, 1) 
% Output:
% x, y, and theta values of the player position

function [vx, vy, vtheta] = getPlayerVelocity(matchData, id)

    [x, y, theta] = getPlayerPosition(matchData, id);

    vx = gradient(x, 1, 0.1);
    vy = gradient(y, 1, 0.1);
    vtheta = gradient(theta, 1, 0.1);

end