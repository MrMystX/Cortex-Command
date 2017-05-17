-----------------------------------------------------------------------------------------
-- Start Activity
-----------------------------------------------------------------------------------------
function Benchmark5:StartActivity()
	print ("Benchmark5:StartActivity");
	
	self.Area = SceneMan.Scene:GetArea("Benchmark")

	-- Spawn player brain
	local brain = CreateActor("Brain Case", "Base.rte")
	if brain ~= nil then
		brain.Team = 0
		brain.Pos = SceneMan:MovePointToGround(Vector(0 , 0) , 10 , 3) + Vector(0,-50);
		MovableMan:AddActor(brain);
		
		self:SetPlayerBrain(brain, 0);
		self:SwitchToActor(brain, 0, 0);
	end
	
	--TimerMan.EnableAveraging = false
	
	self.StartTime = 2000
	self.Length = 10000
	
	self.Frames30 = 0
	self.FramesSlow = 0
	self.FrameCount = 0
	self.TotalFrameTime = 0
	self.LastFrameTime = 0
	
	self.Complete = false
	
	self.Text = ""

	self.SeamMiddle = SceneMan:MovePointToGround(Vector(0, 0) , 10 , 3);
	
	-- Spawn actors
	for i = 1, 13 do
		self:SpawnActor(SceneMan:MovePointToGround(self.SeamMiddle + Vector(i * 20 , 0) , 10 , 3) + Vector(0,-25), false)
		self:SpawnActor(SceneMan:MovePointToGround(self.SeamMiddle - Vector(i * 20 , 0) , 10 , 3) + Vector(0,-25), true)
	end
	
	self.GenericTimer = Timer();
	self.GenericTimer:Reset();

	self.Benchmark5Timer = Timer();
	self.Benchmark5Timer:Reset();
	
	--[[self.Emitter = CreateAEmitter("MOPixel Emitter");
	self.Emitter.Pos = self.SeamMiddle + Vector(0,-150);
	self.Emitter:EnableEmission(true);
	self.Emitter.RotAngle = 90 / 57;
	MovableMan:AddParticle(self.Emitter);

	self.Emitter = CreateAEmitter("MOPixel Emitter");
	self.Emitter.Pos = self.SeamMiddle + Vector(50,-150);
	self.Emitter:EnableEmission(true);
	self.Emitter.RotAngle = 90 / 57;
	MovableMan:AddParticle(self.Emitter);

	self.Emitter = CreateAEmitter("MOPixel Emitter");
	self.Emitter.Pos = self.SeamMiddle + Vector(-50,-150);
	self.Emitter:EnableEmission(true);
	self.Emitter.RotAngle = 90 / 57;
	MovableMan:AddParticle(self.Emitter);

	self.Emitter = CreateAEmitter("MOPixel Emitter");
	self.Emitter.Pos = self.SeamMiddle + Vector(0,-125);
	self.Emitter:EnableEmission(true);
	self.Emitter.RotAngle = 90 / 57;
	MovableMan:AddParticle(self.Emitter);

	self.Emitter = CreateAEmitter("MOPixel Emitter");
	self.Emitter.Pos = self.SeamMiddle + Vector(50,-125);
	self.Emitter:EnableEmission(true);
	self.Emitter.RotAngle = 90 / 57;
	MovableMan:AddParticle(self.Emitter);

	self.Emitter = CreateAEmitter("MOPixel Emitter");
	self.Emitter.Pos = self.SeamMiddle + Vector(-50,-125);
	self.Emitter:EnableEmission(true);
	self.Emitter.RotAngle = 90 / 57;
	MovableMan:AddParticle(self.Emitter);

	self.Emitter = CreateAEmitter("MOPixel Emitter");
	self.Emitter.Pos = self.SeamMiddle + Vector(0,-100);
	self.Emitter:EnableEmission(true);
	self.Emitter.RotAngle = 90 / 57;
	MovableMan:AddParticle(self.Emitter);

	self.Emitter = CreateAEmitter("MOPixel Emitter");
	self.Emitter.Pos = self.SeamMiddle + Vector(50,-100);
	self.Emitter:EnableEmission(true);
	self.Emitter.RotAngle = 90 / 57;
	MovableMan:AddParticle(self.Emitter);

	self.Emitter = CreateAEmitter("MOPixel Emitter");
	self.Emitter.Pos = self.SeamMiddle + Vector(-50,-100);
	self.Emitter:EnableEmission(true);
	self.Emitter.RotAngle = 90 / 57;
	MovableMan:AddParticle(self.Emitter);--]]--
	
	self:SetTeamFunds(0, 0)
end
-----------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
function Benchmark5:SpawnActor(pos, flipped)
	local actor = nil;
	
	actor = CreateAHuman("Dummy", "Dummy.rte")
	if actor then 
		actor.Team = 0--math.random(2)
		actor.Pos = pos
		actor.AIMode = Actor.AIMODE_SENTRY;
		actor.HFlipped = flipped
		MovableMan:AddActor(actor)

		actor.HitsMOs = false
		actor.GetsHitByMOs = false
		
		actor.Head.HitsMOs = false
		actor.Head.GetsHitByMOs = false
		actor.FGArm.HitsMOs = false
		actor.FGArm.GetsHitByMOs = false
		actor.BGArm.HitsMOs = false
		actor.BGArm.GetsHitByMOs = false
		actor.FGLeg.HitsMOs = false
		actor.FGLeg.GetsHitByMOs = false
		actor.BGLeg.HitsMOs = false
		actor.BGLeg.GetsHitByMOs = false
		
		local item;
		item = CreateHDFirearm("Assault Rifle", "Coalition.rte")
		if item then
			item.HitsMOs = false
			item.GetsHitByMOs = false
		
			actor:AddInventoryItem(item)
		end
	end
	
	return nil
end

-----------------------------------------------------------------------------------------
-- Pause Activity
-----------------------------------------------------------------------------------------
function Benchmark5:PauseActivity(pause)
end
-----------------------------------------------------------------------------------------
-- End Activity
-----------------------------------------------------------------------------------------
function Benchmark5:EndActivity()
end
-----------------------------------------------------------------------------------------
-- Update Activity
-----------------------------------------------------------------------------------------
function Benchmark5:UpdateActivity()
	-- Reload all scripts on space
	if UInputMan:KeyPressed(75) then
		print ("Reload scripts")
		PresetMan:ReloadAllScripts();
	end
	
	if UInputMan:KeyPressed(2) then
		if self.ActivityState == Activity.EDITING then
			self.ActivityState = Activity.RUNNING
		else
			self.ActivityState = Activity.EDITING
		end
	end		
	
	if not self.GenericTimer:IsPastSimMS(self.StartTime) then
		self.Text = "Waiting for stuff to settle"
	end
	
	-- Do Benchmark5
	if self.GenericTimer:IsPastSimMS(self.StartTime) and not self.GenericTimer:IsPastSimMS(self.StartTime + self.Length) then
		if self.FrameCount == 0 then
			self.Benchmark5Timer:Reset()
		end
	
		self.FrameCount = self.FrameCount + 1
		
		if self.FrameCount > 0 then
			local frametime = self.Benchmark5Timer.ElapsedRealTimeMS - self.LastFrameTime
			self.LastFrameTime = self.Benchmark5Timer.ElapsedRealTimeMS

			if frametime < 1000 / 30 then
				self.Frames30 = self.Frames30 + 1
			else
				self.FramesSlow = self.FramesSlow + 1
			end
			
			self.TotalFrameTime = self.TotalFrameTime + frametime
			
			self.Text = "Frame " .. self.FrameCount .. " \n"

			self.Text = self.Text .. "Time " .. math.floor(self.TotalFrameTime) .. "ms \n"
			self.Text = self.Text .. "Frame Time " .. math.floor(frametime) .. "ms \n"
			self.Text = self.Text .. "30fps frames " .. math.floor(self.Frames30 / self.FrameCount * 100) .. "% \n"
			self.Text = self.Text .. "Other frames " .. math.floor(self.FramesSlow / self.FrameCount * 100) .. "% \n"
			self.Text = self.Text .. "Avg. frame time " .. math.floor(self.TotalFrameTime / self.FrameCount) .. "ms \n"
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