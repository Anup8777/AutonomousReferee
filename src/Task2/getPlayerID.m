% function to find the id of player closest to che ball
% Inputs:
% matchData - load(mat file of replay data of the soccer match)
% bx, by, ind - position of the ball and indence when violation happend
% 
% Output:
% ID - id of the player closest to the ball

function ID = getPlayerID(matchData, bx, by, ind)

distance= inf(1,7);

for i=1:1:7
    [p_x, p_y, ~, ~] = getPlayerPosition(matchData,i);
    player_pos = [p_x(ind) p_y(ind)];
    ball_pos = [bx by];
    temp_distance = norm(ball_pos-player_pos);
    distance(i)=temp_distance;
end
[~,ID]=min(distance);

end
