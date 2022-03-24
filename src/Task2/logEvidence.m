%-------------------------------------------------------------------------%
%function for logging the evidence%
%-------------------------------------------------------------------------%
function OutAutoRef = logEvidence()
ruleViolationFlagArray =[0 0 1 0 0 1 0 0 1 0 1 0 1 1]; %rule violation flag array
[~,n]=size(ruleViolationFlagArray);

EvidenceLogData=[];
for i=1:1:n
    if ruleViolationFlagArray(i)==1
        EvidenceLogRow=[1 2];
        %getGameState() getPlayerID() getRealTime()
        %detectBallPositionAtKick() getBallVelocity() getTaskID()
        %getRobotPos()
        EvidenceLogData=[EvidenceLogData; EvidenceLogRow];
    end
end
OutAutoRef = EvidenceLogData;
save EvidenceLog.mat EvidenceLogData -v7.3; %saving in mat file
end
%-------------------------------------------------------------------------%