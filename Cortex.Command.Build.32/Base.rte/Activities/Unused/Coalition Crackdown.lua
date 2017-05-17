function CoalitionCrackdown:SceneTest()
--[[ THIS TEST IS DONE AUTOMATICALLY BY THE GAME NOW; IT SCANS THE SCRIPT FOR ANY MENTIONS OF "GetArea" AND TESTS THE SCENES FOR HAVING THOSE USED AREAS DEFINED!
	-- See if the required areas are present in the test scene
	if not (TestScene:HasArea("LZ Team 2")) then
		-- If the test scene failed the compatibility test, invalidate it
		TestScene = nil;
	end
--]]
end


function CoalitionCrackdown:StartActivity()
	print("START! -- CoalitionCrackdown:StartActivity()!");
    for player = Activity.PLAYER_1, Activity.MAXPLAYERCOUNT - 1 do
        if self:PlayerActive(player) and self:PlayerHuman(player) then
		-- Check if we already have a brain assigned
			if not self:GetPlayerBrain(player) then
				local foundBrain = MovableMan:GetUnassignedBrain(self:GetTeamOfPlayer(player));
				-- If we can't find an unassigned brain in the scene to give each player, then force to go into editing mode to place one
				if not foundBrain then
					self.ActivityState = Activity.EDITING;
					AudioMan:ClearMusicQueue();
					AudioMan:PlayMusic("Base.rte/Music/dBSoundworks/ccambient4.ogg", -1, -1);
				else
					-- Set the found brain to be the selected actor at start
					self:SetPlayerBrain(foundBrain, player);
					self:SwitchToActor(foundBrain, player, self:GetTeamOfPlayer(player));
					self:SetLandingZone(self:GetPlayerBrain(player).Pos, player);
					-- Set the observation target to the brain, so that if/when it dies, the view flies to it in observation mode
					self:SetObservationTarget(self:GetPlayerBrain(player).Pos, player)
				end
			end
		end
	end
	self.WList = { "Auto Cannon", "Flak Cannon", "Revolver Cannnon", "Spike Launcher", "Uber Cannon", "Napalm Flamer", "Flamer", "Grenade Launcher", "Rocket Launcher", "Gatling Gun", "Compact Assault Rifle", "Assault Rifle", "Pistol", "Auto Pistol", "Heavy Pistol", "Sniper Rifle", "Heavy Sniper Rifle", "Shotgun", "Auto Shotgun", "Mauler Shotgun" };
	self.AList = { "Soldier Light", "Soldier Heavy" };
	self.BList = { "Grenade", "Cluster Grenade", "Explosive Charge" };
	self.ESpawnTimer = Timer();
	self.TimeLeft = math.random(10000);
	self.EnemyLZ = SceneMan.Scene:GetArea("LZ Team 2");
end

function CoalitionCrackdown:PauseActivity(pause)
    	print("PAUSE! -- CoalitionCrackdown:PauseActivity()!");
end

function CoalitionCrackdown:EndActivity()
    	print("END! -- CoalitionCrackdown:EndActivity()!");
end


function CoalitionCrackdown:UpdateActivity()
	if self.ActivityState == Activity.RUNNING then
		for player = Activity.PLAYER_1, Activity.MAXPLAYERCOUNT - 1 do
			if self:PlayerActive(player) and self:PlayerHuman(player) then
				-- The current player's team
				local team = self:GetTeamOfPlayer(player);
				-- Make sure the game is not already ending
				if not (self.ActivityState == Activity.OVER) then
					-- Check if any player's brain is dead
					if not MovableMan:IsActor(self:GetPlayerBrain(player)) then
						self:SetPlayerBrain(nil, player);
						FrameMan:SetScreenText("Your brain has been destroyed!", player, 333, -1, false);
						-- Now see if all brains of self player's team are dead, and if so, end the game
						if not MovableMan:GetClosestBrainActor(team) then
							self.WinnerTeam = self:OtherTeam(team);
							ActivityMan:EndActivity();
						end
						self:ResetMessageTimer(player);
					end
				-- Game over, show the appropriate messages until a certain time
				elseif not self.GameOverTimer:IsPastSimMS(self.GameOverPeriod) then
				-- TODO: make more appropriate messages here for run out of funds endings
					if team == self.WinnerTeam then
						FrameMan:SetScreenText("Your competition's wetware is mush!", player, 0, -1, false);
					else
						FrameMan:SetScreenText("Your brain has been destroyed!", player, 0, -1, false);
					end
				end
			end
		end

		--Spawn the AI.
		if self.ESpawnTimer:LeftTillSimMS(self.TimeLeft) <= 0 then
			local actor = {};
			for x = 0, math.ceil(math.random(3)) do
				actor[x] = CreateAHuman(self.AList[math.random(#self.AList)],"Coalition.rte");
				actor[x].Team = 1;
				actor[x].AIMode = Actor.AIMODE_BRAINHUNT;
				actor[x]:AddInventoryItem(CreateHDFirearm(self.WList[math.random(#self.WList)],"Coalition.rte"));
				if math.random() > 0.90 then
					local explosive = self.BList[math.random(#self.BList)];
					actor[x]:AddInventoryItem(CreateTDExplosive(explosive));
					actor[x]:AddInventoryItem(CreateTDExplosive(explosive));
					actor[x]:AddInventoryItem(CreateTDExplosive(explosive));
				end
				actor[x]:AddInventoryItem(CreateHDFirearm("Pulse Digger"));
			end
			local ship = nil;
			local z = math.random();
			if z > 0.7 then
				ship = CreateACRocket("Rocket MK1");
			elseif z > 0.5 then
				ship = CreateACRocket("Rocket MK2");
			else
				ship = CreateACDropShip("Drop Ship MK1");
			end
			for n = 0, #actor do
				ship:AddInventoryItem(actor[n]);
			end
			ship.Team = 1;
			ship.Pos = Vector(self.EnemyLZ:GetRandomPoint().X,-50);
			MovableMan:AddActor(ship);
			self.ESpawnTimer:Reset();
			self.TimeLeft = math.random(5000)+5000;
		end
	end
end