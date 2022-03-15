
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