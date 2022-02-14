% Script for running and testing videos
clear;
clc;
close all;
%%
% Load the video from appropriate location

% Set the video parameters


% 0. Get user-inputs on plotting images during the execution, and saving
% the video in ..\output_videos
%%%% Plotting images
plotFlag = input('Show images of distance violations during execution? (y/n): ','s');

%%%% Input video number
input_video_number = input('Enter the input video number: ');

%%%%
saveFlag = input('Do you want to save an output video? (y/n): ', 's');
if strcmp(saveFlag,'y')
    output_video_number = input('Enter the video number : ');
    videofile_name = strcat('..\output_videos\virtual_video_',num2str(output_video_number),'.avi');
    v_out = VideoWriter(videofile_name,'Motion JPEG AVI');
end

% 1. Load the calibration image of the empty field, and the input video
% Note: Ensure that the calibration image and input video has the same
% dimensions!
% The calibration image used here is of size 1080 x 1920 (RGB) 

%%%%%%%$%%%%%%%%changed for debugging
calibration_image_name = '..\images\calibration_image.png';
calibration_image = imread(calibration_image_name);

v_in = VideoReader(['..\videos\virtual_video_',num2str(input_video_number),'.avi']);
%%%%%%%%%%v_in = VideoReader(['..\videos\virtual_video_103.avi']);
% Checking here if the dimensions match!
if (v_in.Height ~= size(calibration_image,1)) || (v_in.Width ~= size(calibration_image,2))
    disp(['Calibration frame dimensions: ', mat2str(size(calibration_image,1:2))]);
    disp(['Video frame dimensions: ', mat2str([v_in.Height v_in.Width])]);
    error('Calibration frame and input video dimensions do not match'); 
end


% Obtaining user inputs on game state
quickTestFlag = input('Provide default game state conditions, i.e.,free-kick by Team B ? (y/n): ','s');
if strcmp (quickTestFlag,'y')
    state_params.gameState = 2; % 18-3-21: For now, set to 6 to set dropped ball condition
    state_params.kickerTeam = 2; % 1 if team A attacks, 2 if team B attacks, it is reset to zero for dropped ball   
    
else
    disp('Game states: ');
    disp(' ball in play : 0');
    disp(' kick-off     : 1');
    disp(' free-kick    : 2');
    disp(' goal-kick    : 3');
    disp(' throw-in     : 4');
    disp(' corner-kick  : 5');
    disp(' drop-ball    : 6');
    disp(' penalty-kick : 7');
    state_params.gameState = input('Enter the game state (0-7): ');
    state_params.kickerTeam = input('Enter the attacking team number (1- for team A, 2 for team B): ');
end
% ensuring only values 0,1 or 2 are used in the kickerTeam variable
state_params.kickerTeam = round(max(min(state_params.kickerTeam,2),0));
% 2. Mark different zones of the field based on line boundaries extracted
% from the calibration image. 
% Also obtain the ratio of pixels to meter 
% based on the known field dimensions : 22 x 14 m 
[field_zones,calibration_params.meter_pixel_ratio] = zone_of_field_fn(calibration_image_name);


% 3. Fill up the calibration parameters
calibration_params.image_size = [size(calibration_image,2); size(calibration_image,1)];
% The following parameters on ball and team colors were manually filled
% after testing on sample images from the game. Changes in image colours
% would require changing the below parameters, as well as the tolerances in
% RGB values
calibration_params.ball_color = [255 175 10]; % RGB values for ball colour
calibration_params.teamA_color = [240 10 10]; % RGB values for team A colour
calibration_params.teamB_color = [250 250 10]; % RGB values for team B colour

% half the R,G,B band sizes, accounting for change in colour due to light and shadow
calibration_params.ball_tolerance = 20; % ball colour tolerances
calibration_params.player_tolerance = 20; % player colour tolerances
calibration_params.zoned_field = get_penalty_zones_fn(field_zones);

% 2. Set the game state parameters
%%% Test parameters
% The reference ball location is not specified here, the first ball
% location in the input video is used to set this value
state_params.reference_ball_location = []; %100*[-7;0]; % set to value out-of bounds so that the current ball location is chosen as the reference location 
state_params.last_ball_centre_pixel = [];

% Refining state parameters based on specific states
if state_params.gameState ==6
    state_params.stateName = 'drop-ball';    
    state_params.kickerTeam = 0;
    state_params.r_min = 1;
    state_params.r_max = 1;
        
elseif state_params.gameState ==7
    state_params.stateName = 'penalty';
    state_params.r_min = 3;
    state_params.r_max = 3;
    
else % 
    state_params.r_min = 2;
    state_params.r_max = 3;
    
    switch state_params.gameState
        case 0 
            state_params.stateName = 'ball-in-play';           
        case 1
            state_params.stateName = 'kick-off';
            state_params.reference_ball_location = [0;0];    
        case 2
            state_params.stateName = 'free-kick';
        case 3
            state_params.stateName = 'goal-kick';
        case 4
            state_params.stateName = 'throw-in';            
        case 5
            state_params.stateName = 'corner-kick';
            
    end
end

%%% position and text for output images

position = [calibration_params.image_size(1)/2-500,20];
% text_start = 'No. of violations';

%%% confidence threshold for violation determination
% confidence of violation for each player 
% = projected area on the area of interest/ total projected area of the player

% Used to account for perspective distortions, where players away from the
% centre of the field have larger projected areas on the ground, which
% could result in false positives (detection of violation of area of interest when there is actually none)
% A rudimentary workaround to the issue of perspective distortions is to 
% use confidence values and a confidence threshold to estimate the certainty of violation.  
confidenceThreshold = 33; % enter a value in the range 0-100, used in visualisations


% Display information on the game state

disp('Testing for conditions: ');
disp(['Game state: ',state_params.stateName]);
disp(['Kicking team (A => 1, B => 2): ',num2str(state_params.kickerTeam)]);
disp(['Required ball location : ',mat2str(state_params.reference_ball_location)]);

% Initialising:
% area of interest matrix and frame number
AOI = [];
% frame number
ii = 0;
% vector containing the time taken for a decision on each frame
t_end = zeros(v_in.NumFrames,1);

if strcmp(saveFlag,'y')
    open(v_out)
end


if strcmp(plotFlag,'y')
   figure, hold on; 
end
while hasFrame(v_in) && ii < v_in.NumFrames
ii = ii + 1;

tStart = tic;
test_frame = readFrame(v_in); 
[violatorsA,violatorsB,AOI,state_params] = ball_player_zone_check_fn(test_frame,calibration_params,state_params,AOI);
t_end(ii) = toc(tStart);

text = ['Number of violations, team A: ', num2str(violatorsA.number),', team B: ',num2str(violatorsB.number)];
if ~isempty(AOI)
  fused_image = (imfuse((test_frame),AOI(:,:,1),'blend'));
  fused_image = (imfuse((fused_image),AOI(:,:,2),'blend'));
else
    fused_image = (test_frame);
end
% fused_image = (imfuse((fused_image),violatorsA.checkA,'blend'));
% fused_image = (imfuse((fused_image),violatorsB.checkB,'blend'));

%  disp(violatorsB.number);
% disp(violatorsA.number); 


if violatorsA.number >0 || violatorsB.number >0
fused_image = insertText(fused_image,position,text,'FontSize',33,'TextColor','white',...
    'BoxColor','green','BoxOpacity',0.1);  
    if strcmp(plotFlag,'y')
        imshow(fused_image);
        hold on;
        title([state_params.stateName,', team: ',num2str(state_params.kickerTeam) ', t = ',num2str(ii/v_in.FrameRate),' s']); 
        if ~isempty(violatorsA.centroids) && violatorsA.number >0
            plot((violatorsA.centroids(violatorsA.confidence>=confidenceThreshold,1)),(violatorsA.centroids(violatorsA.confidence>=confidenceThreshold,2)),'r+');
            plot((violatorsA.centroids(violatorsA.confidence<confidenceThreshold,1)),(violatorsA.centroids(violatorsA.confidence<confidenceThreshold,2)),'ro');
        end
        if ~isempty(violatorsB.centroids) && violatorsB.number >0
            plot((violatorsB.centroids(violatorsB.confidence>=confidenceThreshold,1)),(violatorsB.centroids(violatorsB.confidence>=confidenceThreshold,2)),'y+');
            plot((violatorsB.centroids(violatorsB.confidence<confidenceThreshold,1)),(violatorsB.centroids(violatorsB.confidence<confidenceThreshold,2)),'yo');
        end
        
        drawnow;
        
    end
end

if strcmp(saveFlag,'y')
    writeVideo(v_out,fused_image);
end

% end
end
if strcmp(saveFlag,'y')
    close(v_out);
end

Total_time = sum(t_end(:));
Ideal_time = ii/v_in.FrameRate;
%%
Average_algorithm_speed = 1/mean(t_end(:));

disp(['Average algorithm speed (Hz): ',num2str(Average_algorithm_speed)]);
