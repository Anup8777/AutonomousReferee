% This script runs a simple test on a single test image to check if the basic function,
% of detecting players who violate the ball player distance rules, is met
% by the developed modules

tic;
clear 
clc
close all

%%
%%% Test parameters
gameState = 6; % 18-3-21: For now, set to 6 to set dropped ball condition
kickerTeam = 2; % 1 if team A attacks, 2 if team B attacks, it is reset to zero for dropped ball

plotFlag = 0; % set to one to get plots in decision making fn


% Test image on which the distance violation rules are checked
test_image_name = '..\images\HD_test_image_1.png';
test_image = imread(test_image_name);
%figure,imshow(test_image);


% Pre-match calibration image (without ball or players on it,
% used to detect the zones of the field based on line detection).
% Note: Both the calibration and test images must be from the same position
% and FOV of the camera!
% Currently, we need to ensure that both calibration and test images have
% the same size
%
% calibration_image_name = '..\test_images\field_calibration_image.png';
calibration_image_name = '..\images\calibration_image.png';
calibration_image = imread(calibration_image_name);
%figure,imshow(calibration_image);

%%
[aa_zone,meter_pixel_ratio] = zone_of_field_fn(calibration_image_name);
%%
%imshow(aa_zone)
if gameState ==6
    
    r_min = 1;
    r_max = 1;
    
else
    r_min = 2;
    r_max = 3;
end
toc
%% Detect current ball location on the test image (run ball detection algorithm)

% Use the ball detection function to detect the coordinates!
%ball_centre = [1250, 400];

ball_color = [255 175 10];
tolerance = 25;

[ball_centre]=DetectBall(test_image,ball_color,tolerance); % returns ball center (x then y coordinates)

%% verifying ball detection output
% imshow(test_image);
% 
% %plot the circles
% viscircles(ball_centre,radii,'Edgecolor','b');
%%
% TODO: obtain r_min and r_max in terms of pixels based on the metres to
% pixel ratio obtained from the zone_of_interest_fn 

%%
AOI = Area_of_interest_fn(test_image,ball_centre,r_min,r_max,meter_pixel_ratio);

AOI_inner = AOI == 2;
AOI_outer = AOI == 1;
AOI_outer = imfill(AOI_outer,'holes');

if gameState ==6
   AOI_outer= AOI_inner;
end
    
toc
%% verifying AOI function output

[B, player_detections] = Player_detection(test_image);

teamA_color = [240 10 10];
teamB_color = [250 250 10];

[~, player_detections,Player_area_TeamA,Player_area_TeamB,Player_id_TeamA,Player_id_TeamB]= ClassifyTeams(B,player_detections,test_image,teamA_color,teamB_color,tolerance);

toc
player_detections(player_detections >2) =0;

player_detections = double (player_detections);

toc
%%

% decision making block 
[violationsA,violationsB] = decision_making_fn(AOI_inner, AOI_outer,player_detections,aa_zone,kickerTeam,Player_area_TeamA,Player_area_TeamB,Player_id_TeamA,Player_id_TeamB,plotFlag);

% [nViolatorsA, nViolatorsB,trustA,trustB] = decision_making_fn(AOI_inner, AOI_outer,player_detections,aa_zone,gameState,kickerTeam,plotFlag,Player_area_TeamA,Player_area_TeamB);
%%
fused_image = rgb2gray(imfuse((test_image),0.5*(sum(AOI,3))));
figure, imshow(fused_image);
toc
