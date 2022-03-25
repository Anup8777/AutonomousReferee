% function to log evidance of all AutoRef decisions (currently limited to 
% task 1 and task 2 implementations)
% Inputs:
% matchData - load(mat file of replay data of the soccer match)
% dist, indxAtViolation - distance of free roll at which ball was
% interrupted and indices when violation happends (output of checkDistance())
% bx, by, indx - position of the ball and index (output of detectKickBall())
% pID - id of the player closest to the ball at violation (getPlayerID())
% Output:
% EvidenceLog.mat file with all information about Task2 violation

function OutAutoRef = logEvidence(matchData, ruleViolationFlagArray,distV,indxV, bx, by, indxb, pID)

[~,n]=size(ruleViolationFlagArray);

EvidenceLogData=[];
for i=1:1:n
    if ruleViolationFlagArray(i)==1
        EvidenceLogRow=[getRealTime(i,matchData.replay.time) sprintf('distance of Violation: %0.3f m', distV((indxV==i))) sprintf('ball X position: %0.3f m', bx(indxb == i)) sprintf('ball Y position: %0.3f m', by(indxb == i)) sprintf('Player closest to the ball: %i', pID(indxV==i))];
        EvidenceLogData=[EvidenceLogData; EvidenceLogRow];
    end
end
OutAutoRef = EvidenceLogData;
save EvidenceLog.mat EvidenceLogData -v7.3; %saving in mat file
end
