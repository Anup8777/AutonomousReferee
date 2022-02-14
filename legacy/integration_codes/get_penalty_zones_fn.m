function zonedField = get_penalty_zones_fn(field_zones_matrix)
% Given the field zones matrix from the zone_of_field_fn, this function
% separates the penalty and goal areas of each team, with team A on the left half and
% team B on the right half
% Team A: goal area = 1
% Team A: penalty area = 2
% Team B: goal area = 4
% Team B: penalty area = 3
% Note: Big changes in the calibration image, may result in changes in the
% zone numbers in the field_zones_matrix. The penalty and goal areas are
% obtained from hard-coded values of the zone numbers, therefore, a check
% should always be made on the field_zones_matrix
% if changing the calibration image.

zonedField = zeros(size(field_zones_matrix));

for i = 1:size(zonedField,1)
   for j = 1:size(zonedField,2)
      if (field_zones_matrix(i,j) == 10) % add lines to the penalty zones
          zonedField(i,j) = 1; % team A goal area
      elseif (field_zones_matrix(i,j) == 9)
          zonedField(i,j) = 2; % team A penalty area
      elseif (field_zones_matrix(i,j) == 15) 
          zonedField(i,j) = 3; % team B penalty zone
      elseif (field_zones_matrix(i,j) == 16) 
          zonedField(i,j) = 4; % team B goal zone          
      else 
          zonedField(i,j) = 0;
      end
   end
end

zonedField = imclose(zonedField,strel('disk',5)); % gets ride of lines inside the penalty box region

end