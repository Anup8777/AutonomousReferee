% AUTOREFMAIN
%{
Main script of the AutoRef system. Loads data, applies cognition for
implemented tasks (currently 1 and 2), and logs evidence.

%}

clear all
close all

% Load the specified .mat file from a Tech United match and assign it to the match object
[matFile, path] = uigetfile('*.mat');
matFileFull = fullfile(path, matFile);
% Create an object from the DataProcessing class
match1 = DataProcessing();
match1.setGameMatchData(matFileFull);
% Set field dims
match1.setFieldDimensions();
% Set Player IDs for players present in the match
match1.setPlayerID([2 3 5 6]);
% Set Player IDs for ball location estimation
match1.setPlayerID4BallEst([2 3]);
% Retrieve Player positions from .mat file
match1.setPlayerPos();
% Set ball position using the weighted average
match1.setBallPos(1);
% Set ball velocity using the weighted average
match1.setBallVel(1);

% Perform Task 1 cognition
task1Evidence = task1(match1, 12100, 12500);

% Perform Task 2 cognition
task2Evidence = task2(match1, 500, 1000);
