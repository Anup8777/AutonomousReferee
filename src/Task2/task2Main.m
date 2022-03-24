% Visualization of Task2
%% Initialization
clear all
close all

%% Getting data
% Load the specified .mat file and assign it to matchData
matchData = load('replaydata_15-Mar-2022_21_01.mat'); %loading mat file from turlte);
% Adjust field length and width (sometimes this is necessary if the .mat
% file dimensions don't seem to make sense, in the case they were input
% incorrectly
flength = 12.1;
fwidth = 8.5;
% Overwrite the field dimensions in the .mat file
matchData.replay.metadata.var.fieldlength = flength;
matchData.replay.metadata.var.fieldwidth = fwidth;

% Get the entire ball trajectory from the .mat file
useWeightAve = 1; % 1 in case if weight averaging is used  
[ballX, ballY, ballZ] = getBallPosition(matchData, useWeightAve, 2,3);
% Get positions at all kicks during the game according to special treshold
accelThreshold = 2; 
[ball_x, ball_y, ball_z, kickInd] = detectKickBall(matchData,useWeightAve, accelThreshold, 2,3);

% violation detection
[distViolation, indxViolation, player_id] = checkDistance(ball_x, ball_y, kickInd);

% create violation log
logTask2 = zeros(1,size(matchData.replay.data,2));
logTask2(indxViolation) = 1; 
logEvidence(matchData,logTask2,distViolation,indxViolation, ball_x, ball_y, kickInd, player_id);

% Concatenate ball X and Y coordinates
ballCoordsAll = [ballY; ballX];

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

%% Animation
% Set specific start and finish indices to select a subsection of the data
caseN = 2;
if caseN == 1
    start = 4100;
    finish = 4200;
else
    start = 10250;
    finish = 10350;
end
bufferSize = 300; % Stream buffer length
ballStream = NaN(2,bufferSize); % Initialize the ball stream 
playerStream = NaN(14,bufferSize); % Initialize the player stream

figure('units','normalized','outerposition',[0 0 1 1])
[fieldX, fieldY] = initFieldArea_main(matchData); % Get the matrix of field 
% coordinates and add the field graphic to the figure
daspect([1,1,1])
axis([-10 10 -10 10]);

% Create animated line objects for the ball and each player, with object
% properties defined (color, marker, etc.)
ani1=animatedline('Color','k', 'LineStyle', 'none', "Marker", '.', "MarkerSize", 20,'DisplayName','Ball');
ani2=animatedline('Color','g', 'LineStyle', 'none', "Marker", '.', "MarkerSize", 20,'DisplayName','P1');
ani3=animatedline('Color','b','LineStyle', 'none', 'LineWidth',2, "Marker", '*', "MarkerSize", 10,'DisplayName','P2');
ani4=animatedline('Color','r','LineStyle', 'none', 'LineWidth',2, "Marker", '*', "MarkerSize", 10,'DisplayName','P3');
ani5=animatedline('Color','c','LineStyle', 'none', "Marker", '.', "MarkerSize", 20,'DisplayName','P4');
ani6=animatedline('Color','m','LineStyle', 'none', 'LineWidth',2, "Marker", '^', "MarkerSize", 10,'DisplayName','P5');
ani7=animatedline('Color','y','LineStyle', 'none', 'LineWidth',2, "Marker", '^', "MarkerSize", 10,'DisplayName','P6');
ani8=animatedline('Color','#FF8800','LineStyle', 'none', "Marker", '.', "MarkerSize", 20,'DisplayName','P7');
aniball = animatedline('Color','k', 'LineStyle', 'none', "Marker", '.', "MarkerSize", 20,'DisplayName','Ball');

% Record the animation
recordVideo = 0; % set to 1 to record the animation

% Initialize video
if recordVideo == 1
    videoName =  sprintf('Task2case%i', caseN);
    myVideo = VideoWriter(videoName,  'MPEG-4'); %open video file
    myVideo.FrameRate = 10;  %can adjust this, 5 - 10 works well for me
    open(myVideo)
end

% Start to "stream" the data from the .mat file for the specified window
for i = start:finish
    
    % Overwrite the last buffer slot with the most recent index from the
    % .mat file for ball and players
    ballStream = [ballStream(:,2:end), ballCoordsAll(:,i)];
    playerStream = [playerStream(:,2:end), playerCoordsAll(:,i)];

    % Clear previous animation points
    clearpoints(ani1);
    clearpoints(ani2);
    clearpoints(ani3);
    clearpoints(ani4);
    clearpoints(ani5);
    clearpoints(ani6);
    clearpoints(ani7);
    clearpoints(ani8);

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
    legend('','','','','','','','', 'Ball', '', 'P2', 'P3', '','P5', 'P6','Position',[0.67 0.43 0.02 0.2])

    % Check Task2 violation
    if ismember(i, indxViolation) && distViolation((indxViolation==i)) > 0.1 
        
        
        disp('Violation at ')
        timeViolation = getRealTime(i, matchData.replay.time); 
        disp(timeViolation)
        disp('At Distance: ')
        disp(distViolation((indxViolation==i)));
        [~, J, ~] = find(indxViolation==i);
       
        message = sprintf('VIOLATION! Roll distance = %0.2f m at %s', distViolation(J), timeViolation);
        addpoints(aniball,ballX(i), ballY(i));
        txt = text(-6,-6,message, 'Color', 'r');       
    end

    drawnow
    pause(0.1);
    
    if recordVideo == 1
        frame = getframe(gcf); %get frame
        writeVideo(myVideo, frame);
    end
end

if recordVideo == 1
    close(myVideo)
end