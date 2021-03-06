% function to detect whether the free roll is less than 0.5 m
% Input:
% bx, by - position of the ball at the kick (output from detectBallPositionAtkick())
% ind - indices of the data when kick happend (output from detectBallPositionAtkick())
% Output:
% dist, indxAtViolation - distance of free roll at which ball was
% interrupted and indices when violation happends

function [dist, indxAtViolation] = checkDistance(bx, by, ind)

dx = diff(bx);
dy = diff(by);

dist  = hypot(dx,dy);

[~,indx] = find(dist < 0.5 & dist > 0.05);

indxAtViolation = ind(indx);
%indxAtViolation = indxAtViolation - 1;
dist = dist(indx);

end
