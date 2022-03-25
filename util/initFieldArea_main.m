%This main script body plots the field with all the field markings present
%inside the field area, taking the field parameters from the mat file.
%This main script body also calls the function initFieldArea to get back X
%and Y coordinates with [0,0] being the center of the field.
%-----------------------------------------------------------------------------------------------------%
function [Xcoordinates, Ycoordinates] = initFieldArea_main(matchData)
replay = matchData.replay;

%Loading the field parameters from mat file%
%-----------------------------------------------------------------------------------------------------%
% load replaydata_15-Mar-2022_21_25.mat %loading mat file from turlte
fieldWidth = replay.metadata.var.fieldwidth; %loading fieldwidth from mat file
fieldLength = replay.metadata.var.fieldlength; %loading fieldlength from mat file
fieldCenter = [fieldLength/2,fieldWidth/2]; %field center with respect actual length and and width of field
circleRadius = replay.metadata.var.circleradius; %loading center circle radius from mat file
goalAreaWidth = replay.metadata.var.goalareawidth; %loading goalareawidth from mat file
goalAreaLength = replay.metadata.var.goalarealength; %loading goalarealength from mat file
penaltyAreaWidth = replay.metadata.var.penaltyareawidth; %loading penaltyareawidth from mat file
penaltyAreaLength = replay.metadata.var.penaltyarealength; %loading penaltyarealength from mat file
lineWidth = replay.metadata.var.linewidth; %loading linewidth from mat file

%-----------------------------------------------------------------------------------------------------%

%Drawing the field%
%-----------------------------------------------------------------------------------------------------%
hold on;

%overall field
field = rectangle('Position', [-fieldLength/2 -fieldWidth/2 fieldLength fieldWidth],'FaceColor',1/255*[20,126,15], 'EdgeColor',1/255*[255,255,255], 'LineWidth',lineWidth);
%center circle
fieldCenterCircle = rectangle('Position', [-circleRadius -circleRadius 2*circleRadius 2*circleRadius], 'Curvature',[1,1], 'EdgeColor',1/255*[255,255,255], 'LineWidth',lineWidth);
%goal area on one side
fieldGoalArea1 = rectangle('Position', [-fieldLength/2 (0-goalAreaWidth/2) goalAreaLength goalAreaWidth], 'EdgeColor',1/255*[255,255,255], 'LineWidth',lineWidth);
%penalty area on one side
fieldPenaltyArea1 = rectangle('Position', [-fieldLength/2 (0-penaltyAreaWidth/2) penaltyAreaLength penaltyAreaWidth], 'EdgeColor',1/255*[255,255,255], 'LineWidth',lineWidth);
%goal area on second side
fieldGoalArea2 = rectangle('Position', [fieldLength/2-goalAreaLength (0-goalAreaWidth/2) goalAreaLength goalAreaWidth], 'EdgeColor',1/255*[255,255,255], 'LineWidth',lineWidth);
%penalty area on second side
fieldPenaltyArea2 = rectangle('Position', [fieldLength/2-penaltyAreaLength (0-penaltyAreaWidth/2) penaltyAreaLength penaltyAreaWidth], 'EdgeColor',1/255*[255,255,255], 'LineWidth',lineWidth);
%center line
Xline = [0,0]; Yline = [-fieldWidth/2, fieldWidth/2];
fieldCenterLine = line(Xline,Yline, 'Color', 'white', 'LineWidth',lineWidth);
% Define parameters of the corner arcs
xCenter1 = -fieldLength/2; yCenter1 = fieldWidth/2; 
xCenter2 = -fieldLength/2; yCenter2 = -fieldWidth/2; 
xCenter3 = fieldLength/2; yCenter3 = -fieldWidth/2; 
xCenter4 = fieldLength/2; yCenter4 = fieldWidth/2; 
radius = replay.metadata.var.cornerradius;
% Define the angle theta in 100 steps.
theta1 = linspace(270, 360, 100); theta2 = linspace(0, 90, 100);
theta3 = linspace(90, 180, 100); theta4 = linspace(180, 270, 100);
% Define x and y using "Degrees" version of sin and cos.
x1 = radius * cosd(theta1) + xCenter1; y1 = radius * sind(theta1) + yCenter1; 
x2 = radius * cosd(theta2) + xCenter2; y2 = radius * sind(theta2) + yCenter2; 
x3 = radius * cosd(theta3) + xCenter3; y3 = radius * sind(theta3) + yCenter3; 
x4 = radius * cosd(theta4) + xCenter4; y4 = radius * sind(theta4) + yCenter4; 
% plotting corner arcs
plot(x1, y1, 'Color','white', 'LineWidth',lineWidth); 
plot(x2, y2, 'Color','white', 'LineWidth',lineWidth); 
plot(x3, y3, 'Color','white', 'LineWidth',lineWidth); 
plot(x4, y4, 'Color','white', 'LineWidth',lineWidth); 
%plotting penaltyspots and centerspot
scatter(-fieldLength/2+replay.metadata.var.penaltyspot, 0, 'MarkerEdgeColor', 'white', 'MarkerFaceColor','white','LineWidth', 0.1);
scatter(fieldLength/2-replay.metadata.var.penaltyspot, 0, 'MarkerEdgeColor', 'white', 'MarkerFaceColor','white','LineWidth', 0.1);
scatter(0, 0, 'MarkerEdgeColor', 'white', 'MarkerFaceColor','white', 'LineWidth', 0.1);

% hold off;

%-------------------------------------------------------------------------------------------------------%

%calling the initFieldArea function for getting X and Y coordinates%
%-------------------------------------------------------------------------------------------------------%
[Xcoordinates, Ycoordinates] = initFieldArea(fieldLength, fieldWidth);
%-------------------------------------------------------------------------------------------------------%

