function [AOI] = Area_of_interest_fn(image_frame, center_ball, rad_meter_1, rad_meter_2, MPratio)

% RGB = imread(image_frame);
%subplot(2,2,1),imshow(RGB)
bw = imbinarize(image_frame);
max_y = size(bw,1);
max_x = size(bw,2);
blank_inner = zeros(max_y,max_x);
blank_outer = zeros(max_y,max_x);
%subplot(2,1,2),imshow(blank)


%center_ball = [500 250];
rad_1 = rad_meter_1 * MPratio; % MPratio is the ratio between the length in meter and in pixel
rad_2 = rad_meter_2 * MPratio;
%rad_3 = 80;
%A1_pre = insertShape(blank,'FilledCircle',[center_ball rad_3],...
%    'Color','blue');

A_outer = insertShape(blank_outer,'FilledCircle',[center_ball rad_2],...
    'Color','green'); % execution time for insertShape ~ 0.05 seconds

A_inner = insertShape(blank_inner,'FilledCircle',[center_ball rad_1],...
    'Color','red');

AOI(:,:,1) = A_inner(:,:,1)>0.5;
AOI(:,:,2) = A_outer(:,:,2)>0.5;


end