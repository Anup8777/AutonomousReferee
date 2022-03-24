% task1.main

%{ 
This script gets data and calls all required functions to determine:

1. Whether the ball is inside or outside the field
    and which boundary line it crossed when going out
2. Which player last touched the ball before it went out
    and which team to assign possession to.

Displays an animation of the ball and player movement that generated the
decision

%}

clear all
close all

% Load the specified .mat file and assign it to matchData
[matFile, path] = uigetfile('*.mat');
matFileFull = fullfile(path, matFile);
matchData = load(matFileFull);
% Adjust field length and width (sometimes this is necessary if the .mat
% file dimensions don't seem to make sense, in the case they were input
% incorrectly
flength = 12.1;
fwidth = 8.5;
% Overwrite the field dimensions in the .mat file
matchData.replay.metadata.var.fieldlength = flength;
matchData.replay.metadata.var.fieldwidth = fwidth;

% Get the entire ball trajectory from the .mat file
[ballY, ballX, ballZ] = getBallPosition(matchData, 1, 2,3);

% Concatenate ball X and Y coordinates
ballCoordsAll = [ballX; ballY];

% Apply a simple 2D smoothing filter to the ball trajectory (optional)
h = fspecial('average', [1 10]);
ballCoordsAll = filter2(h, ballCoordsAll, 'same');

% Initialize a matrix for all player coordinates where each player's X and
% Y coordinate trajectories are consecutive rows in the matrix i.e. Player
% 1 uses rows 1 & 2 (for X and Y, respectively)
playerCoordsAll = zeros(14,size(ballCoordsAll,2));
theta = 0; % Initialize a temp variable for player orientation (not used)
for i = 1:7
    turtleN = i;
    % Get player trajectories from the .mat file
    [playerCoordsAll(i*2,:), playerCoordsAll(i*2-1,:), theta, playerIDColor] = getPlayerPosition(matchData,(turtleN));
end

%% Generate a fake data stream from the .mat file

% Set specific start and finish indices to select a subsection of the data
start = 12200;
finish = 12500;

bufferSize = 300; % Stream buffer length
ballStream = NaN(2,bufferSize); % Initialize the ball stream 
playerStream = NaN(14,bufferSize); % Initialize the player stream

figure
[fieldX, fieldY] = initFieldArea_main(matchData); % Get the matrix of field 
pause(5)
% coordinates and add the field graphic to the figure
daspect([1,1,1])
axis([-10 10 -10 10]);

% Create animated line objects for the ball and each player, with object
% properties defined (color, marker, etc.)
ani1=animatedline('Color','k', 'LineStyle', 'none', "Marker", '.', "MarkerSize", 30,'DisplayName','Ball');
% ani2=animatedline('Color','g', 'LineStyle', 'none', "Marker", '.', "MarkerSize", 20,'DisplayName','P1');
ani3=animatedline('Color','b','LineStyle', 'none', 'LineWidth',2, "Marker", '*', "MarkerSize", 10,'DisplayName','P2');
ani4=animatedline('Color','r','LineStyle', 'none', 'LineWidth',2, "Marker", '*', "MarkerSize", 10,'DisplayName','P3');
% ani5=animatedline('Color','c','LineStyle', 'none', "Marker", '.', "MarkerSize", 20,'DisplayName','P4');
ani6=animatedline('Color','m','LineStyle', 'none', 'LineWidth',2, "Marker", '^', "MarkerSize", 10,'DisplayName','P5');
ani7=animatedline('Color','#FF8800','LineStyle', 'none', 'LineWidth',2, "Marker", '^', "MarkerSize", 10,'DisplayName','P6');
% ani8=animatedline('Color','y','LineStyle', 'none', "Marker", '.', "MarkerSize", 20,'DisplayName','P7');

% Start to "stream" the data from the .mat file for the specified window
for i = start:finish
    % Overwrite the last buffer slot with the most recent index from the
    % .mat file for ball and players
    ballStream = [ballStream(:,2:end), ballCoordsAll(:,i)];
    playerStream = [playerStream(:,2:end), playerCoordsAll(:,i)];
    % Check if the current ball position is inside the field, returns "0"
    % if it is, "1" if not
    [in, ID, locID] = isBallInside([ballStream(1,end); ballStream(2,end)],matchData);
    if in==0
        ID;
        ballStream(1:2,end);
%         disp(i)
        % Output the ID number of the predicted player who last touched the 
        % ball
        playerID = lastPlayerTouched(ballStream, playerStream);
        % Assign possession based on the player's team ID (0 or 1)
        violationTeam = assignPossession(playerID, locID, matchData);
        ballOutText = "Player " + playerID + " kicked the ball out at coordinate: "...
            + ballStream(1,end) + ", " + ballStream(2,end) + newline + " on the " ...
            + ID + " border of the field." + newline + "Possession "...
            + "is awarded to team " + abs(violationTeam - 1) + ".";
        text(-8,-8,ballOutText,'Color','red','FontSize',14)
        break
    end
    % Clear previous animation points
    clearpoints(ani1);
%     clearpoints(ani2);
    clearpoints(ani3);
    clearpoints(ani4);
%     clearpoints(ani5);
    clearpoints(ani6);
    clearpoints(ani7);
%     clearpoints(ani8);
    % Add new animation points with current object positions from the
    % buffer
    addpoints(ani1,ballStream(1,end), ballStream(2,end));
%     addpoints(ani2,playerStream(1,end), playerStream(2,end));
    addpoints(ani3,playerStream(3,end), playerStream(4,end));
    addpoints(ani4,playerStream(5,end), playerStream(6,end));
%     addpoints(ani5,playerStream(7,end), playerStream(8,end));
    addpoints(ani6,playerStream(9,end), playerStream(10,end));
    addpoints(ani7,playerStream(11,end), playerStream(12,end));
%     addpoints(ani8,playerStream(13,end), playerStream(14,end));
    legend('','','','','','','','', 'Ball', 'P2', 'P3', 'P5', 'P6','Position',[0.67 0.43 0.02 0.2])
    drawnow
    pause(0.1);
end
