function [evidence] = task2(matchObject, startStream, finishStream)

% Get ball position from match object
ballPos = matchObject.BallPosition;
% Concatenate ball X and Y coordinates
ballCoordsAll = [ballPos(1,:); ballPos(2,:)];
ballX = ballPos(1,:); 
ballY = ballPos(2,:); 
ballZ = ballPos(3,:);

% Apply a simple 2D smoothing filter to the ball trajectory (optional)
h = fspecial('average', [1 10]);
ballCoordsAll = filter2(h, ballCoordsAll, 'same');

% Get all Player coordinates from match object
playerCoordsAll = matchObject.PlayerPosition;

% Get positions at all kicks during the game according to special treshold
useWeightAve = 1;
accelThreshold = 2; 
playerIDs = matchObject.PlayerID4BallEst;
[ball_x, ball_y, ball_z, kickInd] = detectKickBall(matchObject.GameMatchData, useWeightAve, accelThreshold, playerIDs);

% violation detection
[distViolation, indxViolation] = checkDistance(ball_x, ball_y, kickInd);

% get id of player closest to the ball at violaion
player_id = zeros(size(indxViolation));
for i = 1:size(indxViolation,2)
    player_id(i) = matchObject.getPlayerNearBall(ballX(indxViolation), ballY(indxViolation), indxViolation);
end
% create violation log
logTask2 = zeros(1,size(matchObject.GameMatchData.replay.data,2));
logTask2(indxViolation) = 1; 
logEvidence(matchObject.GameMatchData,logTask2,distViolation,indxViolation, ball_x, ball_y, kickInd, player_id);

%% Animation
% Set specific start and finish indices to select a subsection of the data
% caseN = 2;
% if caseN == 1
%     start = 4100;
%     finish = 4200;
% else
%     start = 10250;
%     finish = 10350;
% end


% Set specific start and finish indices to select a subsection of the data
start = startStream;
finish = finishStream;

bufferSize = 300; % Stream buffer length
ballStream = NaN(2,bufferSize); % Initialize the ball stream 
playerStream = NaN(14,bufferSize); % Initialize the player stream

figure('units','normalized','outerposition',[0 0 1 1])
[fieldX, fieldY] = initFieldArea_main(matchObject.GameMatchData); % Get the matrix of field 
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
        timeViolation = getRealTime(i, matchObject.GameMatchData.replay.time); 
        disp(timeViolation)
        disp('At Distance: ')
        disp(distViolation((indxViolation==i)));
        [~, J, ~] = find(indxViolation==i);
       
        message = sprintf('VIOLATION! Roll distance = %0.2f m at %s', distViolation(J), timeViolation);
        addpoints(aniball,ballX(i), ballY(i));
        txt = text(-6,-6,message, 'Color', 'r');  
    else
        message = 'No violation detected.'
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

evidence = message;
end