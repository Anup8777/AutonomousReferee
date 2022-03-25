function [playerID] = lastPlayerTouched(ballCoords, playerCoords)
%{  
Description: Receives vectors containing X and Y coordinates for the ball
and all players from the buffer. Assumes that the last coordinate contained
within the ball coordinates is the coordinate at which the ball went out of
bounds.
Determines the team of the last player who made contact with the ball and 
outputs this in the form of a unique team ID (0 or 1).

This function utilizes the 'reducepoly' function to transform the ball 
trajectory into a sequence of lower resolution vectors, and assumes that
the second to last point in this reducepoly matrix is the point at which a
player made contact with the ball and changed its trajectory.

%}

% Use the reducepoly function (which implements the Ramer-Douglas-Peucker
% algorithm) to simplify the ball trajectory to consecutive vector segments
% whose resolution is determined by the threshold. Since the stream is
% initialized with NaN entries, the code below ignores all NaN entries
tolerance = 0.01;
ramerDoug = reducepoly(ballCoords(:,all(~isnan(ballCoords)))', tolerance);

% Add a vector of zeros to make the matrix a 3D trajectory (required for
% the dsearchn function)
rd3 = [ramerDoug, zeros(length(ramerDoug),1)];

% Display the coordinate of the last inflection point in the trajectory
% (optional)
% disp(rd3(end-1,:))
% Get the ball coordinate closest to the last inflection point
[ix, d] = dsearchn(ballCoords', rd3(end-1,1:2));

% Get all player coordinates at the index of the ball coordinate
playerCoordsatix = [playerCoords(1,ix), playerCoords(2,ix); 
                    playerCoords(3,ix), playerCoords(4,ix);
                    playerCoords(5,ix), playerCoords(6,ix);
                    playerCoords(7,ix), playerCoords(8,ix);
                    playerCoords(9,ix), playerCoords(10,ix);
                    playerCoords(11,ix), playerCoords(12,ix);
                    playerCoords(13,ix), playerCoords(14,ix)];

% Find the player closest to the ball coordinate at the last inflection
% point
for i = 1:7
    [ixPlayer, dPlayer] = dsearchn(playerCoordsatix, ballCoords(:,ix)');
end

% Outputs the ID number of the player closest to the ball, who is assumed
% to be responsible for changing the ball trajectory
playerID = ixPlayer;

%{
% Plot the ball trajectory and reducepoly trajectory (optional)
figure
plot(ballCoords(1,:), ballCoords(2,:));
hold on
plot(ramerDoug(:,1), ramerDoug(:,2))
axis([-10 10 -10 10]);
legend('ballXY','ramerdoug')
%}
end