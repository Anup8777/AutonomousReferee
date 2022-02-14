
%%
%objective:this code is part of a ball-player distance violation detection code for a robot soccer referee match.
% This part of the code is for finding the ball center within an image frame input

%Steps
% 1.	Masking the image using a color filter  
% 2.	Performing morphological operations on the filtered image
% 3.    Cropping the filtered image 4. find the ball center and the radii using Circular Hough  Transform
% 4.    Finding the ball center function

%inputs
% 1.	Test_image – 3 channel RGB matrix of the image frame of the game video
% 2.	ball_color – a 3 element array input for the color filter operation in step 2
% 3.	tolerance - input for the color filter operation in step 2

%output
% 1.	centers – a 2 element array input of the ball center in pixel coordinates
function [centers]= DetectBall(test_image,ball_color,tolerance)   %ball detection function
 %% ball detection
 %% mask the ball in the picture 

 % Convert RGB image to chosen color space. 
 % For the current scope RGB space was chosen.
 
% Define thresholds for channel 1 based on histogram settings
channel1Min = max(1,ball_color(1) -tolerance);
channel1Max = min(ball_color(1)+tolerance,255);

% Define thresholds for channel 2 based on histogram settings
channel2Min = max(1,ball_color(2) - tolerance);
channel2Max = min(255,ball_color(2) + tolerance);

% Define thresholds for channel 3 based on histogram settings
channel3Min = max(1,ball_color(3) - tolerance);
channel3Max = min(255,ball_color(3) + tolerance);

% Create mask based on chosen histogram thresholds
BW = (  (test_image(:,:,1) >= channel1Min ) & (test_image(:,:,1) <= channel1Max) & ...
    (test_image(:,:,2) >= channel2Min ) & (test_image(:,:,2) <= channel2Max) & ...
    (test_image(:,:,3) >= channel3Min ) & (test_image(:,:,3) <= channel3Max)   ) ;

%% morphological operations
SE = strel('disk',1);
openedimg = imclose(BW,SE); % was initially imopen, but that removes very small ball detections
filledimg = imfill(openedimg,'holes');

%% image cropping operation 
bb=bwconncomp(filledimg);
size_bb = numel(bb.PixelIdxList);
%% 
xmin = 0; ymin = 0 ;
pixelInd = cell(size_bb + 1);
for k=1:size_bb
[pixelInd{k}.row(:),pixelInd{k}.col(:)] = ind2sub(size(filledimg),bb.PixelIdxList{k}(:));
pixelInd{size_bb+1}.row =pixelInd{k}.row(:);
pixelInd{size_bb+1}.col =pixelInd{k}.col(:);
end

xmin = min(pixelInd{size_bb+1}.col(:));
if xmin > 30
    xmin =xmin-30; 
end
xmax = max(pixelInd{size_bb+1}.col(:));
if xmax < (size(filledimg,2)-30)
   xmax =xmax+30; 
end

ymin = min(pixelInd{size_bb+1}.row(:));
if ymin > 30
    ymin =ymin-30; 
end
ymax = max(pixelInd{size_bb+1}.row(:));
if ymax < (size(filledimg,1)-30)
   ymax =ymax+30; 
end

rect = [xmin ymin xmax-xmin  ymax-ymin];
croppedimg = imcrop(filledimg,rect);
%% finding the circles
[centers, radii] = imfindcircles(croppedimg,[6 10], 'Sensitivity',0.97); % Find circular forms with the defined pixel radius and with a non-aggresive acceptance criteria 
%% averaging multiple detections if there is only one bounding object
if size(centers,1)>1 && bb.NumObjects==1 
    centers = sum(centers,1)/size(centers,1);
    radii =sum(radii)/size(centers,1);
end
%%
if ~isempty(centers)
centers(1,1)= centers(1,1) + xmin;  % there is a slight error of 1.5 , this may be solved by chekcing the imcrop output
centers(1,2)= centers(1,2) + ymin;
end
%% plotting the detected ball Boundary to verify

%imshow(I);
%plot the circles
%viscircles(centers,radii,'Edgecolor','b');
end  %end of the function
