%given replay data and number of turtle (id) get_turtlePose() function return x,y
%and theta coordinate of the turtle in the field

function [x, y, theta] = getPlayerPosition(matchData, id)
    matchData = matchData.replay;
    robot_ind = matchData.metadata.turtle(id).idx_pose;
    team_color =  matchData.data(matchData.metadata.turtle(id).idx_teamcolor);
    if team_color == 1
        orientation = 1;
    else 
        orientation = -1;
    end

 
    x = orientation*matchData.data(robot_ind(1), :);
    y = orientation*matchData.data(robot_ind(2), :);
    theta = matchData.data(robot_ind(3), :) - (1-orientation)*pi/2;
end