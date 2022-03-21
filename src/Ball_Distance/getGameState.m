function out = getGameState(refbox_commands_values,IDXRolePlayer)
% Today I have kidney pain again.
% Can one of you please kill me ?
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
[~,dimension]=size(refbox_commands_values);
for i=1:1:dimension
    if IDXRolePlayer==i-1
        out=refbox_commands_values(i);
    end
end
% -------------------------------------------------------------------------

%--------------------------------------------------------------------------
end