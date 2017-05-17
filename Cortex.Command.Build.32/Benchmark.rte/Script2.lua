-----------------------------------------------------------------------------------------
-- Start Activity
-----------------------------------------------------------------------------------------
function Benchmark2:StartActivity()
	print ("Benchmark2:StartActivity");
	
	self.Area = SceneMan.Scene:GetArea("Benchmark2")

	-- Spawn player brain
	local brain = CreateActor("Brain Case", "Base.rte")
	if brain ~= nil then
		brain.Team = 0
		brain.Pos = SceneMan:MovePointToGround(Vector(0 , 0) , 10 , 3) + Vector(0, -100);
		brain.Scale = 0
		brain.HitsMOs = false
		brain.GetsHitByMOs = false
		MovableMan:AddActor(brain);
		
		self:SetPlayerBrain(brain, 0);
		self:SwitchToActor(brain, 0, 0);
	end
	
	--TimerMan.EnableAveraging = false
	
	self.StartTime = 2000
	self.Length = 50000000
	
	self.Modules = {"Coalition.rte", "Dummy.rte", "Ronin.rte", "Imperatus.rte", "Techion.rte", "Browncoats.rte"}
	--self.Modules = {"Browncoats.rte"}
	--self.Modules = {"Coalition.rte", "Dummy.rte", "Ronin.rte"}
	
	self.Frames5 = 0
	self.Frames15 = 0
	self.Frames30 = 0
	self.FramesSlow = 0
	self.FrameCount = 0
	self.MaxFrameTime = 0
	self.TotalFrameTime = 0
	self.LastFrameTime = 0
	
	self.Enabled = true
	
	self.MOIDLimit = 80
	
	self.SpawnTimer = Timer()
	self.SpawnTimer:Reset()

	self.KeyTimer = Timer()
	self.KeyTimer:Reset()

	
	self.Complete = false
	
	self.Text = ""

	self.SeamMiddle = SceneMan:MovePointToGround(Vector(0, 0) , 10 , 3);
	
	self.GenericTimer = Timer();
	self.GenericTimer:Reset();

	self.Benchmark2Timer = Timer();
	self.Benchmark2Timer:Reset();
	
	-- Spawn actors
	for i = 1, 10 do
		self:SpawnActor(SceneMan:MovePointToGround(self.SeamMiddle + Vector(math.random(160) + 50, 0) , 10 , 3) + Vector(0,-10), true)
		self:SpawnActor(SceneMan:MovePointToGround(self.SeamMiddle - Vector(math.random(160) + 50, 0) , 10 , 3) + Vector(0,-10), false)
	end
	
	self:SetTeamFunds(0, 0)
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function Benchmark2:SpawnActor(pos, flipped)
	local actor = nil;
	local team;
	
	local mdl = self.Modules[math.random(#self.Modules)]
	
	actor = RandomAHuman("Any", mdl)
	
	if flipped then
		team = 1
	else
		team = 2
	end

	if actor then 
		actor.Team = team
		actor.Pos = pos
		actor.AIMode = Actor.AIMODE_BRAINHUNT;
		actor.HFlipped = flipped
		MovableMan:AddActor(actor)

		if math.random() > 0.10 then
			item = RandomHDFirearm("Primary Weapons", mdl)
		else
			item = RandomHDFirearm("Heavy Weapons", mdl)
		end--]]--
		--item = CreateHDFirearm("CA-01 Firestorm", "Browncoats.rte")
		if item then
			actor:AddInventoryItem(item)
		end

		item = RandomHDFirearm("Secondary Weapons", mdl)
		if item then
			actor:AddInventoryItem(item)
		end
		
		local item;
		item = RandomTDExplosive("Bombs", mdl)
		if item then
			actor:AddInventoryItem(item)
		end
		
		--[[local item;
		item = RandomTDExplosive("Bombs", mdl)
		if item then
			actor:AddInventoryItem(item)
		end--]]--
	end
	
	return nil
end

-----------------------------------------------------------------------------------------
-- Pause Activity
-----------------------------------------------------------------------------------------
function Benchmark2:PauseActivity(pause)
end
-----------------------------------------------------------------------------------------
-- End Activity
-----------------------------------------------------------------------------------------
function Benchmark2:EndActivity()
end
-----------------------------------------------------------------------------------------
-- Update Activity
-----------------------------------------------------------------------------------------
function Benchmark2:UpdateActivity()
	-- Reload all scripts on space
	if UInputMan:KeyPressed(75) and self.KeyTimer:IsPastSimMS(250) then
		--print ("Reload scripts")
		--PresetMan:ReloadAllScripts();
		self.Enabled = not self.Enabled
		self.KeyTimer:Reset()
	end--]]--
	
	--[[if UInputMan:KeyPressed(2) then
		if self.ActivityState == Activity.EDITING then
			self.ActivityState = Activity.RUNNING
		else
			self.ActivityState = Activity.EDITING
		end
	end--]]--		
	
	if not self.GenericTimer:IsPastSimMS(self.StartTime) then
		self.Text = "Waiting for stuff to settle"
	end
	
	if self.Enabled and self.SpawnTimer:IsPastSimMS(100) then
		if MovableMan:GetTeamMOIDCount(1) < self.MOIDLimit then
			self:SpawnActor(SceneMan:MovePointToGround(self.SeamMiddle + Vector(math.random(180) - 30, 0) , 10 , 3) + Vector(0,-10), true)
		end
		if MovableMan:GetTeamMOIDCount(2) < self.MOIDLimit then
			self:SpawnActor(SceneMan:MovePointToGround(self.SeamMiddle - Vector(math.random(180) + 30, 0) , 10 , 3) + Vector(0,-10), false)
		end
		
		for actor in MovableMan.Actors do
			if actor.Pos.X < 350 or actor.Pos.X > SceneMan.Scene.Width - 350 then
				
			else
				actor.Health = 0
			end
		end--]]--

		for item in MovableMan.Items do
			if item.Pos.X < 350 or item.Pos.X > SceneMan.Scene.Width - 350 then
				
			else
				item.ToSettle = true
			end
		end--]]--

		
		self.SpawnTimer:Reset();
	end
	
	-- Do Benchmark2
	if self.GenericTimer:IsPastSimMS(self.StartTime) and not self.GenericTimer:IsPastSimMS(self.StartTime + self.Length) then
		if self.FrameCount == 0 then
			self.Benchmark2Timer:Reset()
		end
	
		self.FrameCount = self.FrameCount + 1
		
		if self.FrameCount > 0 then
			local frametime = self.Benchmark2Timer.ElapsedRealTimeMS - self.LastFrameTime
			self.LastFrameTime = self.Benchmark2Timer.ElapsedRealTimeMS

			if frametime < 1000 / 30 then
				self.Frames30 = self.Frames30 + 1
			elseif frametime < 1000 / 15 then
				self.Frames15 = self.Frames15 + 1
			elseif frametime < 1000 / 5 then
				self.Frames5 = self.Frames5 + 1
			else
				self.FramesSlow = self.FramesSlow + 1
			end
			
			if frametime > self.MaxFrameTime then
				self.MaxFrameTime = frametime
			end
			
			self.TotalFrameTime = self.TotalFrameTime + frametime
			
			self.Text = "Frame " .. self.FrameCount .. " \n"

			self.Text = self.Text .. "Time " .. math.floor(self.TotalFrameTime) .. "ms \n"
			self.Text = self.Text .. "Frame Time " .. math.floor(frametime) .. "ms \n"
			self.Text = self.Text .. "30fps frames " .. math.floor(self.Frames30 / self.FrameCount * 100) .. "% \n"
			self.Text = self.Text .. "15fps frames " .. math.floor(self.Frames15 / self.FrameCount * 100) .. "% \n"
			self.Text = self.Text .. "5fps frames " .. math.floor(self.Frames5 / self.FrameCount * 100) .. "% \n"
			self.Text = self.Text .. "Other frames " .. math.floor(self.FramesSlow / self.FrameCount * 100) .. "% \n"
			self.Text = self.Text .. "Avg. frame time " .. math.floor(self.TotalFrameTime / self.FrameCount) .. "ms \n"
			self.Text = self.Text .. "Max. frame time " .. math.floor(self.MaxFrameTime) .. "ms \n"
			self.Text = self.Text .. "Lua Memory " .. math.floor(collectgarbage("count") / 1024) .. "Mb \n"
			if not self.Enabled then
				self.Text = self.Text .. "SPAWN DISABLED !!! \n"
			end
		end
	end
	
	if self.GenericTimer:IsPastSimMS(self.StartTime + self.Length) then 
		if not self.Complete then
			self.Complete = true
			self.Text = self.Text .. "COMPLETE"
		end
	end
	
	FrameMan:SetScreenText(self.Text, 0, 0, 100, false)

	self:YSortObjectivePoints();
end
-----------------------------------------------------------------------------------------
-- That's all folks!!!
-----------------------------------------------------------------------------------------