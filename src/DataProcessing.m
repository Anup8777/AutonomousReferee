classdef DataProcessing < handle
    %DATAPROCESSING Retrieves and processes data for the AutoRef cognition
    %system
    %   Includes relevant properties and methods to represent RoboCup
    %   match data recorded in a .mat file by calling utility functions in
    %   separate .m files external to the class. An individual .mat file is
    %   represented as an object of this class.
    
    properties(Access=public)
        %Game information
        FieldDimensions = struct('fieldWidth', 10.1, 'fieldLength', 10.1, 'fieldCenter', [5.1 5.1], ... 
        'circleRadius', 1.2, 'goalAreaWidth', 3.1, 'goalAreaLength', 0.5, ...
        'goalWidth', 2, 'goalHeight', 1, 'goalDepth', 0.5, 'penaltyAreaWidth', 5.1, ... 
        'penaltyAreaLength', 1.5, 'lineWidth', 0.1) 
    
        GameState
        GameMatchData
        
        %Player information
        PlayerPosition=[];
        PlayerID = [1 2 3 4 5 6 7];% default value, which will be overwritten by the set function
        PlayerID4BallEst = [2 3];% default value, which will be overwritten by the set function
        
        %Ball information
        BallPosition
        BallVelocity
    end
    
    methods
        % % 'get' function, which is used to read the properties of a member/object.
        
        % get function for Game Field information
        function getFieldDimensions(this)
            this.FieldDimensions
        end
        
        function getGameState(this)
            this.GameState
        end
        
        % get function for Player information
        function getPlayerID(this)
            this.PlayerID
        end
        
        function getPlayerPos(this)
            this.PlayerPosition
        end
        
        % get function for Ball information
        function getBallPos(this)
            this.BallPosition
        end
        
        function getBallVel(this)
            this.BallVelocity
        end

        function [ID] = getPlayerNearBall(this,ballX, ballY, ind)
            distance= inf(1,7);
            for i=1:1:7
%                 [p_x, p_y, ~, ~] = getPlayerPos(this.GameMatchData,i);
                p_x = this.PlayerPosition(i*2-1,:);
                p_y = this.PlayerPosition(i*2,:);
                player_pos = [p_x(ind) p_y(ind)];
                ball_pos = [ballX ballY];
                temp_distance = norm(ball_pos-player_pos);
                distance(i)=temp_distance;
            end
            [~,ID]=min(distance);
        end
        
        % %set information, which will read data from .mat file and set them as the properties of a object/member

        function setGameMatchData(this,filename)
            temp=load(filename);
            this.GameMatchData=temp;
        end

        %set information for Game information
        function setGameState(this,GameState)
            this.GameState=GameState;
            % this function is not finished yet
        end
        
        function setFieldDimensions(obj)
            GameMatchDatalocal=obj.GameMatchData.replay.metadata;
            obj.FieldDimensions.fieldWidth = GameMatchDatalocal.var.fieldwidth; %loading fieldwidth from mat file
            obj.FieldDimensions.fieldLength = GameMatchDatalocal.var.fieldlength; %loading fieldlength from mat file
            obj.FieldDimensions.fieldCenter = [obj.FieldDimensions.fieldLength/2,obj.FieldDimensions.fieldWidth/2]; %field center with respect actual length and and width of field
            obj.FieldDimensions.circleRadius = GameMatchDatalocal.var.circleradius; %loading center circle radius from mat file
            obj.FieldDimensions.goalAreaWidth = GameMatchDatalocal.var.goalareawidth; %loading goalareawidth from mat file
            obj.FieldDimensions.goalAreaLength = GameMatchDatalocal.var.goalarealength; %loading goalarealength from mat file
            obj.FieldDimensions.goalWidth = GameMatchDatalocal.var.goalwidth; % 3D goal box width
            obj.FieldDimensions.goalHeight= GameMatchDatalocal.var.goalheight; % 3D goal box height
            obj.FieldDimensions.goalDepth = GameMatchDatalocal.var.goaldepth; % 3D goal box depth
            obj.FieldDimensions.penaltyAreaWidth = GameMatchDatalocal.var.penaltyareawidth; %loading penaltyareawidth from mat file
            obj.FieldDimensions.penaltyAreaLength = GameMatchDatalocal.var.penaltyarealength; %loading penaltyarealength from mat file
            obj.FieldDimensions.lineWidth = GameMatchDatalocal.var.linewidth; %loading linewidth from mat file
                       
        end
        
        %set information for Player information

        function setPlayerID(this,ID)
            if length(ID)>7
                warning('You have input too many player IDs. A maximum of 7 player IDs is allowed.')
            end
            for i=1:length(ID)
                if ID(i)>7|| ID(i)<=0
                    warning('Player IDs should be in the range of 1 : 7 only.')
                end
            end
            this.PlayerID=ID;
        end
        function setPlayerID4BallEst(this,ID)
            for i=1:length(ID)
                if ID(i)>7|| ID(i)<=0
                    warning('Player IDs should be in the range of 1 : 7 only')
                end
            end
            this.PlayerID4BallEst=ID;
        end
        function setPlayerPos(this)
            for i=1:7
                [playerx, playery, ~, ~] = getPlayerPosition(this.GameMatchData, i);
                this.PlayerPosition=[this.PlayerPosition;playerx;playery];
            end
        end
        %set information for Ball information
        function setBallPos(this,useWeight)
            [bx,by,bz] = getBallPosition(this.GameMatchData, useWeight, this.PlayerID4BallEst);
            this.BallPosition=[bx;by;bz];
        end
        
        function setBallVel(this,useWeight)
            [bvx,bvy,bvz] = getBallVelocity(this.GameMatchData, useWeight, this.PlayerID4BallEst);
            this.BallVelocity=[bvx; bvy; bvz];
        end
        
        
        
        % %other function
        
        function stopPlay(obj)
            disp('Game Stopped!!')
        end
    end
end

