% Script for loading simulator and initialising player positions,
% specifying velocities


% Consider 5 players in each team, and specify initial values for their x,
% y coordinates 

% 2x5 matrix, consider (0,0) as centre of field, +x moves right and +y
% moves upward

clear;
clc;
close all;

%%
% player_height = 0.8; % in metres
% ball_radius = 0.11; % in metres
% 

% n_players = 5;


% simulation time
T = 5;
%%%%%%%%%%%%%%% Avoid changing the camera parameters %%%%%%%%%%%%%%%%%%
% the camera always points downward, but the position and the field of view
% angle can be modified. 
camera_position = [0 ; 0 ; 12];
camera_fov = 1.2*180/pi; % input in degrees

% converting FOV to radians for WRL file
camera_fov = camera_fov*pi/180;




% 
loadStateFlag = input('Load predefined game state settings? (y/n): ','s');
% Load pre-defined game conditions used earlier for video generation
if strcmp(loadStateFlag,'y')
    % The .mat files are located in ..\simulation_game_states
    input_file_name = input('Enter the .mat file name containing state variables ','s');
    load(['..\simulation_game_states\',input_file_name,'.mat']);
else  
%--%%%%%%%%% For testing use cases, please make changes to below cell
%%
%%% Notes: origin is the center of the field
%%% the 2 d positions, initial velocities and orientations (yaw) can be adjusted

% ball initial position
% [0;0] corresponds to field centre


    ball_init_position = [7.5;0];
    % team on the left side: team A
    team_A_init_positions = [ 6.5  2  2   4  -10.5;...
                              0   -3  3   6  -0.5];

    % initial velocities in body frame (m/s)                     
    % each player is given an initial constant velocity value

    team_A_init_vel_BF = [0.1 0.1 0.1 0.02 0]; % considering velocities in robot's frame!                     

    % Yaw angles (rad)
    team_A_orientations = pi/180*[0 150 -3 179 0];                     


    % team on the right side: team B
    team_B_init_positions = [ 10  10  7      9   10.5;...
                             -6    6  6     -1    -0.5];

    % Initial velocities in body frame : set to realistic values
    team_B_init_vel_BF = [0 0.01 0.02 0.02 0.1]; % considering velocities in robot's frame!                     

    % Yaw angles
    team_B_orientations = pi/180*(180+[70 3 -3 -5 -5]);                     
    end
%%

%%%%%%%%%%%%%%%%%%%%%%%% Avoid making changes below this line %%%%%%%%%%%%%%%%%%%%%%%%%
team_A_vel_global = [team_A_init_vel_BF.*cos(team_A_orientations); team_A_init_vel_BF.*sin(team_A_orientations)];
team_B_vel_global = [team_B_init_vel_BF.*cos(team_B_orientations); team_B_init_vel_BF.*sin(team_B_orientations)];

open_system('field_simulator.slx');
% set_param('field_simulator/My Constant','Value','25')

set_param('field_simulator/TeamA_X0','Value',mat2str(team_A_init_positions(:)));

set_param('field_simulator/TeamB_X0','Value',mat2str(team_B_init_positions(:)));

set_param('field_simulator/Ball_X0','Value',mat2str(ball_init_position));

set_param('field_simulator/TeamA_V0','Value',mat2str(team_A_vel_global(:)));

set_param('field_simulator/TeamB_V0','Value',mat2str(team_B_vel_global(:)));

set_param('field_simulator/Camera_FOV','Value',num2str(camera_fov));

set_param('field_simulator/Camera_position','Value',mat2str(camera_position));

set_param('field_simulator', 'SimulationCommand', 'update')
%%

%%%%% 3D Animation preferences 
%%% Lighting preferences 
vrsetpref('DefaultFigureLighting','off');

%%% Default file names for captured images
%%% saves the images in a folder 'images'
vrsetpref('DefaultFigureCaptureFileName','..\images\%f_anim_%n.png');

%%% Setting playback FPS, auto for setting playback speed to simulation
%%% speed
vrsetpref('DefaultFigureRecord2DFPS','auto');

%%% Default video names for recorded videos
%%% saves the videos in a folder 'videos'
vrsetpref('DefaultFigureRecord2DFileName','..\videos\%f_anim_%n.avi');


sim('field_simulator');

%%
%%%% Save video from vout variable in workspace
%%%% Note : run simulations less than 60 seconds long, else, only the last
%%%% 60 seconds get saved
saveFlag = input('Do you want to save video? (y/n)', 's');

if strcmp(saveFlag,'y')

video_number = input('Enter the video number : ');
videofile_name = strcat('..\videos\virtual_video_',num2str(video_number),'.avi');

v = VideoWriter(videofile_name,'Motion JPEG AVI');
open(v)
writeVideo(v,vout)
close(v)
end