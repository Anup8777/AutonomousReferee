% The simulator might work with different functions on 2016 matlab version
% output: coordinate of the players

%% Filter the image into black(non-player) and white(player) parts.
function [B, L] = Player_detection(image_frame)
% RGB = imread(image); % For image testing
%subplot(2,1,1),imshow(RGB)
I = image_frame(:,:,1)*0+ image_frame(:,:,2)*3+ image_frame(:,:,3)*0; % filter out non-dark objects
%imshow(I)
bw = imbinarize(I);
max_y = size(bw,1);
max_x = size(bw,2);
for i = 1:max_y % Black and white reversal, so players should be white
    for j = 1:max_x
        if bw(i,j)==1
            bw(i,j)=0;
        else
            bw(i,j)=1;
        end 
    end
end
%imshow(bw)
bw = bwareaopen(bw,30); % noise filter
%imshow(bw)
se = strel('disk',2); % optimize the object 
bw = imclose(bw,se);
%imshow(bw)
bw = imfill(bw,'holes');
%subplot(2,1,2),imshow(bw)
%hold on

% find the boundary and center of players with various shapes

stats = regionprops('table',bw,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
centers = stats.Centroid; % find the center of white regions

[B,L] = bwboundaries(bw,'noholes'); %collect boundaries locations in matrix
LabelRGB = label2rgb(L,@jet,[.5 .5 .5]);
%hold on
%for k = 1:length(B) % plot the boundary and center for each player
 % plot(centers(k,1),centers(k,2),'x')
  %boundary = B{k};
  %plot(boundary(:,2),boundary(:,1),'r','LineWidth',1)
%end
%center_col(:,:,n) = centers;
end

