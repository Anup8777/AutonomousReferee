%% 
function [teamID] = assignPossession(lastPlayerTouchedID, fieldBoundaryID, matchData)

% The assign possession needs the latest infomration from the functions
% whichFieldBoundary and lastPlayerTouched to assign possession to the team
% and the team should start the game

% This method when called should inherintly call the dependent methods for
% the latest information, if the dependent functions are not called inside
% this scope, then the we will not have the latest information to decide to
% whom to give the possession and which robot to give the posession.

% synthetic data to be tested, could be commented out later

% allPlayerID = [1;2;3;4];
% noRobotsInTeam = length(allPlayerID)/2;
% tmpTeamID = reshape( repmat( [1:noRobotsInTeam], noRobotsInTeam,1 ), 1, [] )';

% allFieldBoundaryID = 1:8;

teamID =  matchData.replay.data(matchData.replay.metadata.turtle(lastPlayerTouchedID).idx_teamcolor);

% you get all possible combinations of players and field reigions where
% ball could go out.

% if tmpTeamID(playerID) == 1
%    teamID = 2;
% else
%     teamID = 1;
% end

% we could have a simple logic as to what part of the matrix results in 
% what team could take the possession of the ball.

end