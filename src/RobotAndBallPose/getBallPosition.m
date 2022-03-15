%given replay data and number of turtle (robot_ids) get_turtlePose() function return x,y
%and theta coordinate of the turtle in the field

function [x, y, z] = getBallPosition(matchData, robotID1, robotID2)

    %N = robot_ids.size();
    matchData = matchData.replay;
    ball_ind1 = matchData.metadata.turtle(robotID1).idx_ball; 
    x1 = matchData.data(ball_ind1(1), :);
    y1 = matchData.data(ball_ind1(2), :);
    z1 = matchData.data(ball_ind1(3), :);


    ball_ind2 = matchData.metadata.turtle(robotID2).idx_ball; 
    x2 = matchData.data(ball_ind2(1), :);
    y2 = matchData.data(ball_ind2(2), :);
    z2 = matchData.data(ball_ind2(3), :);

%     ball_ind3 = matchData.metadata.turtle(robotID3).idx_ball; 
%     x3 = matchData.data(ball_ind3(1), :);
%     y3 = matchData.data(ball_ind3(2), :);
%     z3 = matchData.data(ball_ind3(3), :);

    x1((x1<-30)) = NaN;
    y1((y1<-30)) = NaN;

    x2((x2<-30)) = NaN;
    y2((y2<-30)) = NaN;
% 
%     x3((x3<-30)) = NaN;
%     y3((y3<-30)) = NaN;


    x = (x1+x2)/2;
    y = (y1+y2)/2;
    z = (z1+z2)/2;


end