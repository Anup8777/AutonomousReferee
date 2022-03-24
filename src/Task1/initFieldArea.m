% Outputs vectors containing the x and y coordinate values that are inside the field boundary. 
% Units are in meters currently, as the dimensions are taken from the mat file, 
% but can be converted to pixels (for future compatibility with CV-based system)
% A value of [0,0] would be at the center of the field.
%-------------------------------------------------------------------------%


%function declaration and definitaion of initFieldArea%
%-------------------------------------------------------------------------%
function [X, Y] = initFieldArea(fieldLength, fieldWidth)

m = 1001; n = 1001 ; %number of coordinates along x and y directions
l = linspace(-fieldLength/2,fieldLength/2,m) ;
b = linspace(-fieldWidth/2,fieldWidth/2,n) ;
[mX,mY] = meshgrid(l,b) ;
X = mX(1,:);
Y = -mY(:,1);
%-------------------------------------------------------------------------%