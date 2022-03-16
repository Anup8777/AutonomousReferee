function [in,ID] = isBallInside(PosBall,meta_data)
%This is a function to check whether the ball is inside the field or not.
%   Output of "in" is equal to 1 if the ball is inside the field.
%   Otherwise, it is equal to 0.
%   In this case of outside and inside, the output of "ID" gives the
%   explanations.
%   The input "PosBall" carry the position of the ball in [x;y].
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%Field Parameters
l=meta_data.var.linewidth;    %Line Width in meter
y=meta_data.var.fieldwidth;   %Field Width in meter
x=meta_data.var.fieldlength;  %Field Length in meter
%b=meta_data.var.ballradius;  %Ball Radius in meter
g=meta_data.var.goalwidth;    %Goal Width in meter
h=meta_data.var.goaldepth;    %Goal Depth in meter
%--------------------------------------------------------------------------

%Polygon Definitions-------------------------------------------------------

%Inside Polygon 
IP=[x/2-l,l-x/2,l-x/2,x/2-l,x/2-l;y/2-l,y/2-l,l-y/2,l-y/2,y/2-l];

%Up Line Polygon
ULP=[x/2-l,x/2,-x/2,l-x/2,x/2-l;y/2-l,y/2,y/2,y/2-l,y/2-l];

%Down Line Polygon
DLP=[x/2,x/2-l,l-x/2,-x/2,x/2;-y/2,l-y/2,l-y/2,-y/2,-y/2];

%Left Up Polygon
LUP=[l-x/2,-x/2,-x/2,l-x/2,l-x/2;y/2-l,y/2,g/2,g/2,y/2-l];

%Left Down Polygon
LDP=[l-x/2,-x/2,-x/2,l-x/2,l-x/2;-g/2,-g/2,-y/2,l-y/2,-g/2];

%Right Down Polygon
RDP=[x/2-l,x/2,x/2,x/2-l,x/2-l;l-y/2,-y/2,-g/2,-g/2,l-y/2];

%Right Up Polygon
RUP=[x/2-l,x/2,x/2,x/2-l,x/2-l;g/2,g/2,y/2,y/2-l,g/2];

%Left Goal Line Polygon
LGLP=[l-x/2,-x/2,-x/2,l-x/2,l-x/2;g/2,g/2,-g/2,-g/2,g/2];

%Right Goal Line Polygon
RGLP=[x/2-l,x/2,x/2,x/2-l,x/2-l;-g/2,-g/2,g/2,g/2,-g/2];

%Left Goal Polygon
LGP=[-x/2,-h-x/2,-h-x/2,-x/2,-x/2;g/2,g/2,-g/2,-g/2,g/2];

%Right Goal Polygon
RGP=[x/2,h+x/2,h+x/2,x/2,x/2;-g/2,-g/2,g/2,g/2,-g/2];

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
[in_IP,~]   = inpolygon(PosBall(1),PosBall(2),IP(1,:),IP(2,:));
[in_ULP,~]  = inpolygon(PosBall(1),PosBall(2),ULP(1,:),ULP(2,:));
[in_DLP,~]  = inpolygon(PosBall(1),PosBall(2),DLP(1,:),DLP(2,:));
[in_LUP,~]  = inpolygon(PosBall(1),PosBall(2),LUP(1,:),LUP(2,:));
[in_LDP,~]  = inpolygon(PosBall(1),PosBall(2),LDP(1,:),LDP(2,:));
[in_RDP,~]  = inpolygon(PosBall(1),PosBall(2),RDP(1,:),RDP(2,:));
[in_RUP,~]  = inpolygon(PosBall(1),PosBall(2),RUP(1,:),RUP(2,:));
[in_LGLP,~] = inpolygon(PosBall(1),PosBall(2),LGLP(1,:),LGLP(2,:));
[in_RGLP,~] = inpolygon(PosBall(1),PosBall(2),RGLP(1,:),RGLP(2,:));
[in_LGP,~]  = inpolygon(PosBall(1),PosBall(2),LGP(1,:),LGP(2,:));
[in_RGP,~]  = inpolygon(PosBall(1),PosBall(2),RGP(1,:),RGP(2,:));

if in_IP==1
    in=in_IP; ID='Inside';
else
    if in_ULP==1
        in=in_IP; ID='UpLine';
    end
    if in_DLP==1
        in=in_IP; ID='DownLine';
    end
    if in_LUP==1
        in=in_IP; ID='LeftUpCorner';
    end
    if in_LDP==1
        in=in_IP; ID='LeftDownCorner';
    end
    if in_RDP==1
        in=in_IP; ID='RightDownCorner';
    end
    if in_RUP==1
        in=in_IP; ID='RightUpCorner';
    end
    if in_LGLP==1
        in=in_IP; ID='LeftGoalLine';
    end
    if in_RGLP==1
        in=in_IP; ID='RightGoalLine';
    end
    if in_RGP==1
        in=in_IP; ID='RightGoalArea';
    end
    if in_LGP==1
        in=in_IP; ID='LeftGoalArea';
    end
end

end

