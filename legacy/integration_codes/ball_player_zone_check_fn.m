function [violationsA,violationsB,AOI,state_params] = ball_player_zone_check_fn(test_frame,calibration_params,state_params,AOI)
% This function returns a decision on the game states, a vector of
% violators from team A and a vector of violators from team B, given a
% test_frame from a video, a calibration params struct, containing zone of field information
% and pixel-meter-ratio generated from an image of the empty field, and 
% information regarding the game state.


% obtain parameters from calibration_params object
plotFlag = 0; % no plots to be generated in decision making block

zoned_field = calibration_params.zoned_field;
meter_pixel_ratio = calibration_params.meter_pixel_ratio;
image_size = calibration_params.image_size; % contains the width and height of the calibration image in pixels


ball_color = calibration_params.ball_color;
teamA_color = calibration_params.teamA_color;
teamB_color = calibration_params.teamB_color;
ball_tolerance = calibration_params.ball_tolerance;
player_tolerance = calibration_params.player_tolerance;

gameState = state_params.gameState;
r_min = state_params.r_min;
r_max = state_params.r_max;
kickerTeam = state_params.kickerTeam;

% ball coordinates in world frame are based on the center of the field as the
% origin, x-axis towards the right half, and y-axis towards the upper touch
% line, with z-axis upwards away from the ground

% detect ball location, in pixels, in the current test frame
% disp('Ball detection time: ')
% tstart = tic;
[ball_centre]=DetectBall(test_frame,ball_color,ball_tolerance);
% toc(tstart);

% if ball was hidden in this frame, use the last stored ball centre
% location! (ideally from previous frame)! Does not work if ball is
% completely hidden in the first frame itself
if isempty(ball_centre)
   ball_centre = state_params.last_ball_centre_pixel;
else
    state_params.last_ball_centre_pixel = ball_centre;
end
if state_params.gameState>0
if isempty(state_params.reference_ball_location)
%     warning('reference location of the ball is out-of-bounds');
    state_params.reference_ball_location = ((ball_centre)' - 0.5*image_size)/meter_pixel_ratio.*[1; -1];
end

reference_ball_location_pixels = floor(state_params.reference_ball_location*meter_pixel_ratio.*[1;-1] + 0.5*image_size);
reference_ball_location_pixels = reference_ball_location_pixels';

% if (reference_ball_location_pixels(1)<1 || reference_ball_location_pixels(2)<1 || reference_ball_location_pixels(1) > image_size(1) || reference_ball_location_pixels(2) > image_size(2))
% %     warning('reference location of the ball is out-of-bounds');
%     reference_ball_location_pixels = ball_centre;
% end

% distance of ball from reference location set by referee, in meters
distance_ball_reference = norm(ball_centre- reference_ball_location_pixels)/meter_pixel_ratio;
% disp('Area of interest function')
% t2 = tic;
if isempty(AOI)
AOI = Area_of_interest_fn(test_frame,reference_ball_location_pixels,r_min,r_max,meter_pixel_ratio);
end
% toc(t2);
% AOI_inner = AOI == 2; % attacking teams area of interest (smaller circle)
% AOI_outer = AOI == 1; % defending team's area of interest (bigger circle)
% AOI_outer = imfill(AOI_outer,'holes');

AOI_inner = AOI(:,:,1);
AOI_outer = AOI(:,:,2);
% disp('Player detection');
% t3 = tic;
[B, player_detections] = Player_detection(test_frame);
% toc(t3);
% disp('Team classification');
% t4 = tic;
[~, player_detections,Player_area_TeamA,Player_area_TeamB,Player_id_TeamA,Player_id_TeamB]= ClassifyTeams(B,player_detections,test_frame,teamA_color,teamB_color,player_tolerance);
% toc(t4);
% ensure that the player detections do not have other numbers as artefacts
player_detections(player_detections >2) =0;

% convert from uint8 to double
player_detections = double(player_detections);
% disp('Decision making')
% t5 = tic;
[violationsA,violationsB] = decision_making_fn(AOI_inner, AOI_outer,player_detections,zoned_field,kickerTeam,Player_area_TeamA,Player_area_TeamB,Player_id_TeamA,Player_id_TeamB,plotFlag);

else
    violationsA.number = 0;
    violationsB.number = 0;
end

% toc(t5);
% [nViolatorsA, nViolatorsB,trustA,trustB] = decision_making_fn(AOI_inner, AOI_outer,player_detections,aa_zone,gameState,kickerTeam,plotFlag,Player_area_TeamA,Player_area_TeamB);

% fused_image = rgb2gray(imfuse((test_frame),AOI));
% figure, imshow(fused_image);


end