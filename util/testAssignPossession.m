
function [decisions] = testAssignPossession()
% the function to test the assignPossession function.
% could be improved for the further case when goalkeepers are involved.
%

playerID = 1:4;
fieldBoundaryID = 1:8;
decisions = zeros(length(fieldBoundaryID), length(playerID));
for i=1:length(fieldBoundaryID)
    for j=1:length(playerID)
        decisions(i,j) =  assignPossession(playerID(j), fieldBoundaryID(i));   
    end
end
heatmap(decisions);
end