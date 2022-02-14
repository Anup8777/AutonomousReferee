function [aa_zone,meter_pixel_ratio] = zone_of_field_fn(image_name)
% This function is intended to try and segment the regions of a football
% field based on the lines on the field

%% LOG Filter params
hsize = 10;
sigma = 0.3; 

% load input field image
% aa = imread('test_images\virtual_field_anim_1.png');
aa_col = imread(image_name);
%%

% convert to greyscale
aa = rgb2gray(aa_col);

% figure;
 %imshow(aa);

h = fspecial('log',hsize,sigma);
% apply LOG filter to obtain the edges (field lines)
image_filt = (abs(imfilter(aa,h,'replicate')));

image_filt = imclose(image_filt,strel('square',8));

% binarize the image 
image_filt = imbinarize(image_filt);
%imshow(image_filt);

%%
   

% find connected regions 
cc = bwconncomp(~image_filt,8);
% Given an input binary image, bwconncomp finds all the 
% Clusters of '1's by checking the nearest neighbours of each pixel with value 1
% Since the regions of interest are zeros in the constructed binary image,
% we must take its complement (using the 'NOT' operator) as the input to
% bwconncomp
% the second input argument (8 or 4) relates to the number of directions in which
% connectivity is checked for each pixel of value 1, 

% initialise the final zone matrix containing zone information 
aa_zone = -1*ones(size(aa));

% get the number of zones identified
n_zones = length(cc.PixelIdxList);

% start filling the zone matrix by going through each identified cluster
for ii = 1:n_zones

% get the indices for the i'th cluster
vect = cc.PixelIdxList{ii};

% convert the indices into row and column format
[r , c] = ind2sub(size(aa_zone),vect);

% fill the elements in each index with the zone number
for jj = 1:length(vect)
   aa_zone(r(jj),c(jj)) = ii;
%    if ii==14   %if loop for finding the zone number(used in decision making zonedField)
%        aa_zone(r(jj),c(jj)) = 127;
%    end
    
end

end


%%%%%%%%%% Calculating the meter-pixel ratio
I_ground = aa < 200;
I_ground = imfill(I_ground, 'holes');
% 
% figure;
% imshow(I_ground);
% title('I ground')

Ibin =  aa> 200 & aa<=255 & I_ground; % the ground field lines are less white than goal post lines!
%imshow(Ibin);
Ibin = imfill(Ibin, 'holes'); % This step returns the field region inside the boundary lines
% Ibin = bwareafilt(Ibin,1);
%imshow(Ibin);
props = regionprops(Ibin, 'BoundingBox');

width_m = 22; % metres
height_m = 14; % metres


%%% If multiple boxes are found, find the one that matches the ratio of the
%%% football field (22 x 18 m2)
width = 1;
height =  1;
for ii =1:numel(props)
    boundingBox = props(ii).BoundingBox;   

    
    if abs(width/height-width_m/height_m)> abs(boundingBox(3)/boundingBox(4) - width_m/height_m)
        width = boundingBox(3);
        height = boundingBox(4);
    end
end
% metre to pixel ratio

meter_pixel_ratio_w = width/width_m;

meter_pixel_ratio_h = height/height_m;

meter_pixel_ratio = (meter_pixel_ratio_h + meter_pixel_ratio_w)/2;
% figure;
 %imshow(Ibin);
% figure;
% imshow(~image_filt);
% figure;
% imshow(field_bound_image);

end
%%
% save('test_images\zones_of_field',aa_zone);
