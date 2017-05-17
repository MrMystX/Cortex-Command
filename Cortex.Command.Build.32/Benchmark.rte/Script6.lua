-----------------------------------------------------------------------------------------
-- Start Activity
-----------------------------------------------------------------------------------------
function Benchmark6:StartActivity()
	print ("Benchmark6:StartActivity");
	
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
	
	-- Spawn emitters
	
	self.GenericTimer = Timer();
	self.GenericTimer:Reset();

	self.Benchmark6Timer = Timer();
	self.Benchmark6Timer:Reset();
	
	self.Emitter = CreateAEmitter("MOSParticle Emitter", "Benchmark.rte");
	self.Emitter.Pos = self.SeamMiddle + Vector(0,-200);
	self.Emitter:EnableEmission(true);
	self.Emitter.RotAngle = 90 / 57;
	MovableMan:AddParticle(self.Emitter);--]]--
	
	self:SetTeamFunds(0, 0)
end
-----------------------------------------------------------------------------------------
-- Pause Activity
-----------------------------------------------------------------------------------------
function Benchmark6:PauseActivity(pause)
end
-----------------------------------------------------------------------------------------
-- End Activity
-----------------------------------------------------------------------------------------
function Benchmark6:EndActivity()
end
-----------------------------------------------------------------------------------------
-- Update Activity
-----------------------------------------------------------------------------------------
function Benchmark6:UpdateActivity()
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
	
	-- Do Benchmark6
	if self.GenericTimer:IsPastSimMS(self.StartTime) and not self.GenericTimer:IsPastSimMS(self.StartTime + self.Length) then
		if self.FrameCount == 0 then
			self.Benchmark6Timer:Reset()
		end
	
		self.FrameCount = self.FrameCount + 1
		
		if self.FrameCount > 0 then
			local frametime = self.Benchmark6Timer.ElapsedRealTimeMS - self.LastFrameTime
			self.LastFrameTime = self.Benchmark6Timer.ElapsedRealTimeMS

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