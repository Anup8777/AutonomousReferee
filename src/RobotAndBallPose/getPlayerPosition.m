%given replay data and number of turtle (id) get_turtlePose() function return x,y
%and theta coordinate of the turtle in the field

function [x, y, theta] = getPlayerPosition(matchData, id)
    matchData = matchData.replay;
    robot_ind = matchData.metadata.turtle(id).idx_pose;
    x = matchData.data(robot_ind(1), :);
    y = matchData.data(robot_ind(2), :);
    theta = matchData.data(robot_ind(3), :);
end