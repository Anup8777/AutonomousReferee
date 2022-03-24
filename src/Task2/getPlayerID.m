function ID = getPlayerID(matchData, useWeight, varargin)
%
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
distance=[];
for i=1:1:7
    temp_distance=norm(getBallPosition(matchData, useWeight, varargin)-getPlayerPosition(matchData,i))
    distance=[distance temp_distance];
end
[~,ID]=min(distance);
% -------------------------------------------------------------------------
end
