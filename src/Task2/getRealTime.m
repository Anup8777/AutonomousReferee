function out = getRealTime(n,replaytime)
% getRealTime function returns the real time for a given time serie 
% 'replaytime' and index number 'n'. Detailed
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
% Y=Year M=Month D=Day H=Hour MN=Minute S=Second
[Y, M, D, H, MN, S] = datevec(replaytime(n)); % Time Converting from UNIX
% -------------------------------------------------------------------------

% Output-------------------------------------------------------------------
% If 'Option' is equal to '1', output looks like [Y, M, D, H, MN, S].
% If 'Option' is equal to '2', output looks like 'HH:MM:SS DD-MM-YYYY'.
option=2;       %Output Option
if option==1
    out=[Y, M, D, H, MN, S];
end
if option==2
    formatSpec = "%d:%d:%d %d-%d-%d";
    HH = H; MNMN = MN; SS = S;
    DD = D; MM = M; YYYY = Y;  
    out = sprintf(formatSpec,HH,MNMN,round(SS),DD,MM,YYYY);
end
% -------------------------------------------------------------------------
end

