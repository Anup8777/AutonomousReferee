%given replay data and a column vector with the number of turtle (robot_ids) get_turtlePose() function return x,y
%and theta coordinate of the turtle in the field

function [x, y, z] = get_ballPosi(replay,act_rob_id)

%act_rob_id=[6,2,4,5]';
replay = replay.replay; % load data

% assign size to the matrix
xset_c=zeros(size(act_rob_id,1),size(replay.data,2));
yset_c=zeros(size(act_rob_id,1),size(replay.data,2));
zset_c=zeros(size(act_rob_id,1),size(replay.data,2));
weightset_c=zeros(size(act_rob_id,1),size(replay.data,2));
posi_f=zeros(3,size(replay.data,2));

for i=1:size(act_rob_id,1)
    s=struct;
    s.robot_id= act_rob_id(i);
    s.ball_ind = replay.metadata.turtle(s.robot_id).idx_ball;
    s.weight_ind= replay.metadata.turtle(s.robot_id).idx_ball_confidence;
    x = replay.data(s.ball_ind(1), :);
    y = replay.data(s.ball_ind(2), :);
    z = replay.data(s.ball_ind(3), :);
    weight=replay.data(s.weight_ind, :);

    [~,s.ind_unreliable]=find(x<-30|y<-30|weight<=0);
    s.posiset=[x;y;z;weight];
    for j=1:size(s.ind_unreliable,2)
        s.posiset(:,s.ind_unreliable(j))=[NaN;NaN;NaN;0];
    end

    xset_c(i,:)=s.posiset(1,:);
    yset_c(i,:)=s.posiset(2,:);
    zset_c(i,:)=s.posiset(3,:);
    weightset_c(i,:)=s.posiset(4,:);
    eval(['Ball_Robot_',num2str(i),'=','s']);
end

for i=1:size(replay.data,2)
    [~,TFx]=rmoutliers(xset_c(:,i));
    [~,TFy]=rmoutliers(yset_c(:,i));
    [~,TFz]=rmoutliers(zset_c(:,i));
    xset_c(find(TFx),i)=NaN;
    yset_c(find(TFy),i)=NaN;
    zset_c(find(TFz),i)=NaN;

    tx=isnan(xset_c);
    ty=isnan(yset_c);
    tz=isnan(zset_c);
    xset_c(tx)=0;
    yset_c(ty)=0;
    zset_c(tz)=0;

    for j=1:size(xset_c,1)
        posi_f(1,i)=posi_f(1,i)+xset_c(j,i)*weightset_c(j,i);
        posi_f(2,i)=posi_f(2,i)+yset_c(j,i)*weightset_c(j,i);
        posi_f(3,i)=posi_f(3,i)+zset_c(j,i)*weightset_c(j,i);
    end



end

posi_f=posi_f./[sum(weightset_c); sum(weightset_c); sum(weightset_c)];
x=posi_f(1,:);
y=posi_f(2,:);
z=posi_f(3,:);
end