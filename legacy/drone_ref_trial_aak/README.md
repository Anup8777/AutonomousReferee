## Welcome
This is the documentation repository for the drone referee project 2020-21 done by the PDENG MSD trainees in Feb-March 2021. The repository includes MATLAB codes used to implement ball-player distance violation checking task during: kick-offs, free-kicks, goal-kicks, throw-ins, corner-kicks, dropped-ball situations, and penalty-kicks. The repository also contains codes used to generate virtual scenarios (.png images and .avi videos) using MATLAB, simulink 3D animation, and a virtual reality modelling language (.vrml) file.


## Requirements/Specifications for using this repository
1. MATLAB 2020b -- for running the decision making code and the test scenario simulation codes
2. Simulink-- for running the test scenario simulation codes
3. Simulink 3D Animation Toolbox-- for running the test scenario simulation codes 
4. V-REALM Builder 2.0 (optional-- for editing the test scenario environment *if required*, other VRML editors could also be used)



# Working directory structure
**Note:** The repository does not include any images or videos, which are required for running the integration codes. Appropriate test images could be generated first using the simulation files, and saved in the appropriate directories. 

````
code-repository
|  
|  
|------ integration_codes  
|       |     			
|       |---- video_test_main.m  (for testing virtual scenarios (.avi files) without skipping video frames)
|       |     			
|       |---- video_test_frequency_main.m (for testing virtual scenarios with skipping of video frames based on algorithm speed and video frame rate)   
|       |     			
|       |---- main_task_script.m  (for preliminary image testing)   
|       |     			
|       |---- ball_player_zone_check_fn.m  (integrated code called for the implementation of distance violation checking task)
|       | 			
|       |---- zone_of_field_fn.m
|       | 			
|       |---- get_penalty_zones_fn.m
|       | 			
|       |---- DetectBall.m
|       | 			
|       |---- Area_of_interest_fn.m
|       | 			
|       |---- Player_detection.m
|       | 			
|       |---- ClassifyTeams.m
|       | 			
|       |---- decision_making_fn.m
|
|
|------ simulation_files
|       | 			
|       |---- simulation_script_calibration.m (running this script generates a calibration image of the empty field) 
|       | 			
|       |---- simulation_script_main.m (running this script after specifying player and ball initial conditions generates a virtual scenario (.avi file) that can be tested)
|       | 			
|       |---- field_simulator.slx (simulink file that interfaces between MATLAB scipt and the .vrml model file)
|       | 			
|       |---- virtual_field.WRL (.vrml model file)
|
|
|------ simulation_game_states
|       | 			
|       |---- <.mat files-- preload test scenario variables when running simulation_script_main.m>
|
|------ images (test image files not included in repository, handed in separately, can be generated)
|       |
|       |---- calibration_image.png
|
|------ videos (test video files not included in repository, handed in separately, can be generated)
|       |
|       |---- <virtual_video_#.avi>    
|
|------ output_videos (output videos not included in repository)

````

# Instructions

## Creating simulated images and videos
#### Background information
Due to time constraints and limited accessibility to the testing field, equipment and data, the ball-player distance violation checking algorithm was tested on artificially created simulation videos. These videos are generated from a virtual reality model (virtual_field.WRL), containing several 'objects' (players, ball, field, viewpoints and lighting), with the location and movements of the players and the ball controlled using MATLAB and Simulink.

 The virtual reality model can be viewed from fixed viewpoints of known position and orientations with respect to a global coordinate system. The centre of the field is chosen as the global origin, such that when viewed from above, the X-axis points towards the right half, the Y-axis towards the upper touch line, and the Z-axis points outwards from the ground. 

To simulate a top-view camera, one viewpoint object is used. The location and field of view angle (FOV) of this viewpoint can be edited in the MATLAB script 'simulation_script_main.m'. The final design choice of a camera height of 12 m and FOV of 1.2 radians is hard-coded into this script.


#### Creating a calibration image
Following the below instructions should generate an RGB calibration image of size 1920x1080 pixels.
1. Navigate to the working directory: simulation_files/
2. Open simulation_script_calibration.m.
3. Note the default camera parameter variables in the script, and change if needed.
4. Run the script.
5. Once the simulation is over, a prompt will appear on the terminal, checking for the image save preference.
6. If needed, choose to save the calibration image.
7. The calibration image can now be found in the images/ folder.

#### Creating a test video
Following the below instructions should generate an RGB video of size 1920x1080 pixels. The default video length has been set to 5 seconds. To edit the duration, change the variable T in the file simulation_script_main.m.
1. Navigate to the working directory: simulation_files/
2. Open simulation_script_main.m.
3. Note the default camera parameter variables in the script. *Ensure that they match the camera parameter variables used for the calibration image.*
4. Run the script. 
5. When prompted, choose whether to load a preset scenario file from the simulation_game_states/ folder, or to use the scenario already hardcoded in the script.
6. Once the simulation is over, a prompt will appear on the terminal, checking for the video save preference.
7. If needed, choose to save the video, and provide a suffix number when prompted.
8. The saved test case video can now be found in the videos/ folder. 

## Testing the integrated code on a generated video
Running the test on the integrated code involves loading a test video from the videos/ folder, the calibration image from the images/ folder. Each frame in the video is tested during the script, and the time for testing each iteration is stored in a variable (t_end). 

The video can be tested frame by frame independant of algorithm speed by running video_test_main.m or, by skipping frames based on the algorithm speed and video frame rate (use video_test_frequency_main.m).

1. Navigate to the integration_codes/ folder
2. Open the file video_test_main.m/video_test_frequency_main.m
3. When prompted, choose whether or not to display cases of violation during the simulation.
4. Select the input video (located in the videos/ folder), when prompted, by inputting the video number.
5. When prompted, choose whether to save the results in an output video.
6. When prompted, choose whether to load default state parameters or enter custom state parameters into the terminal.

## Sugggestions for improving the simulation environment

Any changes to the player geometries, color markers, field lighting etc could be done by editing the VRML file virtual_world.wrl. Currently a single camera view in the VRML file is linked to the Simulink and MATLAB environment. Additional camera viewpoints could be linked to the Simulink environment by setting the block parameters of the 'VR sink block' used in the simulink file.   






 
