
%%
function [violationsA, violationsB] = decision_making_fn(Area_detection_matrix_attack, Area_detection_matrix_defense,Player_detection_matrix,zonedField,kickerTeam,Player_area_TeamA,Player_area_TeamB,Player_id_TeamA,Player_id_TeamB,plotFlag)
% This script should make a decision on if a rule is violated and
% by which team it was done. The outputs violationsA and violationsB are
% structs containing information on the number of distance violations, the
% confidence values related to each violation and the centroids of
% projected area of each player detected within their corresponding areas
% of interest. 
% The inputs include the 
% 1 and 2. areas of interest for the attacking and defending
% teams, 
% 3. the player detection matrix displaying players on the field,
% labelled 1 for team A and 2 for team B
% 4. the zonedField matrix which labels the penalty and goal areas of the
% field
% 5. the kickerTeam variable (1 for team A, 2 for team B and 0 in the case of dropped ball)
% 6 and 7. player area matrices for teams A and B in which players are labelled by their projected areas
% 8 and 9. player ID matrices for teams A and B in which players are
% labelled with unique numbers to ensure that multiple counts of the same
% player are avoided, especially when the player is at the edge of the area
% of interest.
% Initialise the confidence matrices as empty matrices
Confidence_matrix_A = [];
Confidence_matrix_B = [];



if kickerTeam == 1 % Team A attacks
checkA = logical((Player_detection_matrix==1).*Area_detection_matrix_attack);
checkA1 = checkA.*Player_id_TeamA; % for checking double detection of the same player
checkB = logical((Player_detection_matrix==2).*Area_detection_matrix_defense);
checkB1 = checkB.*Player_id_TeamB; % for checking double detection of the same player
% find defending players who are in a penalty box, and store as a separate
% variable
%%%%%%changed for multiple detection of the same object
checkB_penalty = logical(checkB.*(zonedField==3)); 

%%%%%%changed for multiple detection of the same object
ccA = regionprops('table',(checkA)); 
ccB = regionprops('table',(checkB));
ccB_penalty = regionprops('table',(checkB_penalty));

% one player from attacking team is allowed inside the area of interest
%%%%%%changed for multiple detection of the same object
%nViolatorsA = max(size(ccA,1)-1,0);
nViolatorsA = max(numel(unique(checkA1))-2,0);

% one player from defending team is allowed inside the area of interest, if
% on their own penalty box
%%%%%%changed for multiple detection of the same object
%nViolatorsB = (size(ccB,1) - min(size(ccB_penalty,1),1);
nViolatorsB = (numel(unique(checkB1))-1) - min(size(ccB_penalty,1),1);

elseif kickerTeam ==2 % Team B attacks
checkB = logical(((Player_detection_matrix==2).*Area_detection_matrix_attack));


checkA = logical(((Player_detection_matrix==1).*Area_detection_matrix_defense));
checkB1 = checkB.*Player_id_TeamB; % for checking double detection of the same player
%imshow(checkA);
checkA_penalty = logical((checkA.*(zonedField==2)));  % this line may not bee needed here
checkA1 = checkA.*Player_id_TeamA; % for checking double detection of the same player
%imshow(checkB);
%%%%%%changed for multiple detection of the same object
ccA = regionprops('table',(checkA)); 
ccB = regionprops('table',(checkB));
ccA_penalty = regionprops('table',(checkA_penalty));

% one player from defending team is allowed inside the area of interest, if
% on their own penalty box
%%%%%%changed for multiple detection of the same object
%nViolatorsA = size(ccA,1) - min(size(ccA_penalty,1),1);
nViolatorsA = (numel(unique(checkA1))-1) - min(size(ccA_penalty,1),1);
% one player from attacking team is allowed inside the area of interest
%%%%%%changed for multiple detection of the same object
%nViolatorsB = max(size(ccB,1)-1,0);   
% nViolatorsB = max(numel(unique(checkB1)-1)-1,0);
nViolatorsB = max(numel(unique(checkB1))-2,0);

else % dropped ball case 
    % both attack and defense matrices have same dimensions
    checkB = logical((Player_detection_matrix==2).*Area_detection_matrix_defense);
    %%%%%%%%%%%%%%%%added by anand
    checkB1 = checkB.*Player_id_TeamB; % for checking double detection of the same player
    
    checkA = logical((Player_detection_matrix==1).*Area_detection_matrix_defense);
%     checkA = logical(checkA.*(zonedField==1));
%     checkB = logical(checkB.*(zonedField==2));
    checkA1 = checkA.*Player_id_TeamA; % for checking double detection of the same player
     %%%%%%changed for multiple detection of the same object
    checkA_penalty = logical((checkA.*(zonedField==2)));  
    checkB_penalty = logical((checkB.*(zonedField==3)));  
     %%%%%%changed for multiple detection of the same object
    ccA = regionprops('table',(checkA1)); 
    ccB = regionprops('table',(checkB1));
    
    ccA_penalty = regionprops('table',(checkA_penalty));
    ccB_penalty = regionprops('table',(checkB_penalty));
    %%%%%%changed for multiple detection of the same object
    %nViolatorsA = size(ccA,1) - min(size(ccA_penalty,1),1);
    nViolatorsA =  (numel(unique(checkA1))-1)- min(size(ccA_penalty,1),1);
    %%%%%%changed for multiple detection of the same object
    %nViolatorsB = size(ccB,1) - min(size(ccB_penalty,1),1); deleted for debugging
    %numel -1 to ignore the 0 value 
    nViolatorsB =  (numel(unique(checkB1))-1)- min(size(ccB_penalty,1),1);
    
end
%% Uncertainity estimation for the team A
if(nViolatorsA~=0)
ccA_conn= bwconncomp(Player_area_TeamA);% finding the connected objects(team a, team B  and the rest)

% S_A = regionprops('table',ccA_conn,'Centroid');
% ccA = regionprops('table',(checkA),'Area','Centroid');

%index form the centroid value
%%%%%%changed for multiple detection of the same object
idx = size(checkA1,1)*(round(ccA.Centroid(:,1))-1)+round(ccA.Centroid(:,2)); % calculating the linear indices from the centroid coordinates

%i=0;%zeros(numel(cc.PixelIdxList)); % variable for the below if loop entry checking
NrTeamA = size(ccA.Centroid,1);

%searching the centroid index in the pixel id list of objects in bw
%the beloe pizel value assignemetn for team A may not be needed as th eteam A memebers are already with 1 pixel
 Confidence_matrix_A = zeros(NrTeamA,1);
 
for n = 1:NrTeamA
     for k=1:numel(ccA_conn.PixelIdxList)
             if nnz(ccA_conn.PixelIdxList{k}==idx(n))%n=1:numel(cc.PixelIdxList{k}) 
                % i(n)=k; %for checking entry into the if loop                 
                 Confidence_matrix_A (n) =ccA.Area(n) /numel(ccA_conn.PixelIdxList{k}(:))*100;
              
             end
      end    
  end

else
    Confidence_matrix_A = 100;
end
 
%% Uncertainity estimation for the team B
if(nViolatorsB~=0)
ccB_conn= bwconncomp(Player_area_TeamB);
% S_B = regionprops('table',ccB_conn,'Centroid');
% ccB = regionprops('table',logical(checkB),'Area','Centroid');
%%%%%%changed for multiple detection of the same object
idxB = size(checkB1,1)*(round(ccB.Centroid(:,1))-1)+round(ccB.Centroid(:,2));
NrTeamB = size(ccB.Centroid,1);
 Confidence_matrix_B = zeros(NrTeamB,1);
for n = 1:NrTeamB
     for k= 1:numel(ccB_conn.PixelIdxList)
             if nnz(ccB_conn.PixelIdxList{k}==idxB(n))%n=1:numel(cc.PixelIdxList{k}) 
                % i(n)=k; %for checking entry into the if loop                 
                 Confidence_matrix_B (n) = ccB.Area(n) /numel(ccB_conn.PixelIdxList{k}(:))*100;
              
             end
      end    
end
 
else
    Confidence_matrix_B=100;
end
%%
%%% Goal area violation check
%%% Only one player from each team can be in the goal area (goalkeepers)
% 
% %%%%%changed for multiple detection of the same object
% checkA_goal = checkA1.*(zonedField==1 | zonedField==4);
% checkB_goal = checkB1.*(zonedField==1 | zonedField==4);
% 
% ccA_goal = regionprops('table',checkA_goal);
% ccB_goal = regionprops('table',checkB_goal);
% 
% % Currently adding these violators to the original nViolators values, but
% % could be kept as a separate field in the function blocks
% if ((numel(unique(checkA_goal))-1)>1 || (numel(unique(checkB_goal))-1)>1)
%    disp('Goal area violation!'); 
% end
% 
% nViolatorsA = nViolatorsA + max((numel(unique(checkA_goal))-1),0);
% nViolatorsB = nViolatorsB + max((numel(unique(checkB_goal))-1),0);

if plotFlag ==1
figure, imshow(zonedField,[]);
%%%%%%changed for multiple detection of the same object
figure, imshow(checkA1);title('Player A violation');
figure, imshow(checkB1);title('Player B violation');
end

violationsA.number = nViolatorsA;
violationsA.confidence = Confidence_matrix_A;
%%%%%%changed for multiple detection of the same object
violationsA.checkA = checkA1;
if ~isempty(ccA)
    violationsA.centroids = ccA.Centroid; % locations of the centroids of team A inside the area of interest
else 
    violationsA.centroids = [];
end
violationsB.number = nViolatorsB;
%%%%%%%%%%%%%the B confidence would have changed because of making area
%%%%%%%%%%%%%matrix unique for debugging
violationsB.confidence = Confidence_matrix_B;
violationsB.checkB = checkB;
if ~isempty(ccB)
    violationsB.centroids = ccB.Centroid;
else 
    violationsB.centroids = [];
end
%%



end