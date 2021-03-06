function Create(self)

	--Speed at which this can dissipate energy.
	self.speedThreshold = 40;
	
	--Strength of material which will dissipate energy.
	self.strengthThreshold = 5;
	
	--Speed of the effect.
	self.effectSpeed = 4;
	
	--The shot effect.
	self.shotEffect = CreateMOSRotating("Techion.rte/Laser Shot Effect");
	self.shotEffect.Pos = self.Pos;
	self.shotEffect.Vel = self.Vel;
	MovableMan:AddParticle(self.shotEffect);
	
	--Check backward.
	local pos = Vector();
	local trace = Vector(self.Vel.X, self.Vel.Y):RadRotate(math.pi) * TimerMan.DeltaTimeSecs * 20;
	if SceneMan:CastObstacleRay(self.Pos, trace, pos, Vector(), 0, self.Team, 0, 5) >= 0 then
		--Check that the position is actually strong enough to cause dissipation.
		trace = SceneMan:ShortestDistance(self.Pos, pos, true);
		local strength = SceneMan:CastStrengthRay(self.Pos, trace, self.strengthThreshold, Vector(), 0, 0, true);
		local mo = SceneMan:CastMORay(self.Pos, trace, 0, self.Team, 0, true, 5);
		if strength or (mo ~= 255 and mo ~= 0) then
			local effect = CreateAEmitter("Techion.rte/Laser Dissipate Effect");
			effect.Pos = pos + Vector(self.Vel.X, self.Vel.Y):RadRotate(math.pi):SetMagnitude(3);
			effect.Vel = Vector(self.Vel.X, self.Vel.Y):RadRotate(math.pi):SetMagnitude(self.effectSpeed);
			MovableMan:AddParticle(effect);
			effect:GibThis();
		end
	end


	self.target = null;

	self.adjustmentAmount = 2;

	self.trailPar = {};
	self.trailParNum = 1;

	self.delayTimer = Timer();

	self.target = null;
	local longDist = 800;
	local shortDist = 98;
	if self.HFlipped == false then
		self.negativeNum = 1;
	else
		self.negativeNum = -1;
	end
	for i = 1, MovableMan:GetMOIDCount()-1 do
		local mo = MovableMan:GetMOFromID(i);
		if mo and (mo.Team ~= self.Team or mo.ClassName == "TDExplosive" or mo.ClassName == "MOSRotating" or (mo.ClassName == "AEmitter" and mo.RootID == moCheck)) then

		local distCheck = SceneMan:ShortestDistance(self.Pos,mo.Pos,SceneMan.SceneWrapsX);
			if distCheck.Magnitude-mo.Radius < longDist then

				local toCheckPos = Vector(distCheck.Magnitude*self.negativeNum,0):RadRotate(self.Vel.AbsRadAngle);
				local checkPos = self.Pos + toCheckPos;
				if SceneMan.SceneWrapsX == true then
					if checkPos.X > SceneMan.SceneWidth then
						checkPos = Vector(checkPos.X - SceneMan.SceneWidth,checkPos.Y);
					elseif checkPos.X < 0 then
						checkPos = Vector(SceneMan.SceneWidth + checkPos.X,checkPos.Y);
					end
				end

				local distCheck2 = SceneMan:ShortestDistance(checkPos,mo.Pos,SceneMan.SceneWrapsX);

				if distCheck2.Magnitude-mo.Radius < shortDist then

					if SceneMan:CastStrengthRay(self.Pos,toCheckPos,0,Vector(0,0),3,0,SceneMan.SceneWrapsX) == false and SceneMan:CastStrengthRay(checkPos,distCheck2:SetMagnitude(distCheck2.Magnitude-mo.Radius),0,Vector(0,0),3,0,SceneMan.SceneWrapsX) == false then
						self.target = mo;
						longDist = distCheck.Magnitude-mo.Radius;
						shortDist = distCheck2.Magnitude-mo.Radius;
					end
				end

			end

		end
	end


	for i = 1, self.trailParNum do
		self.trailPar[i] = CreateMOPixel("Particle Micro Pulsar Damage");
		self.trailPar[i].Pos = Vector(self.Pos.X,self.Pos.Y);
		self.trailPar[i].Vel = Vector(self.Vel.X,self.Vel.Y);
		self.trailPar[i].Team = self.Team;
		self.trailPar[i].IgnoresTeamHits = true;
		MovableMan:AddParticle(self.trailPar[i]);
	end

end

function Update(self)

	if self.delayTimer:IsPastSimMS(25) and self.target ~= null and self.target.ID ~= 255 then
		local checkVel = SceneMan:ShortestDistance(self.Pos,self.target.Pos,SceneMan.SceneWrapsX);
		checkVel = checkVel:SetMagnitude(checkVel.Magnitude-self.target.Radius);
		if SceneMan:CastStrengthRay(self.Pos,checkVel,0,Vector(0,0),3,0,SceneMan.SceneWrapsX) == false then
			local aimVel = Vector(self.Vel.X,self.Vel.Y):SetMagnitude(1) + SceneMan:ShortestDistance(self.Pos,self.target.Pos,SceneMan.SceneWrapsX):SetMagnitude(self.adjustmentAmount);
			self.Vel = Vector(self.Vel.Magnitude,0):RadRotate(aimVel.AbsRadAngle);
		end
	end

	for i = 1, self.trailParNum do
		if MovableMan:IsParticle(self.trailPar[i]) and self.trailPar[i].PresetName == "Particle Micro Pulsar Damage" then
			self.trailPar[i].Pos = Vector(self.Pos.X,self.Pos.Y);
			self.trailPar[i].Vel = Vector(self.Vel.X,self.Vel.Y);
			self.trailPar[i].Team = self.Team;
		end
	end

	if not self.ToDelete then
		if self.Vel.Magnitude >= self.speedThreshold then
			--Collide with objects and deploy the dissipate effect.
			local pos = Vector();
			local trace = Vector(self.Vel.X, self.Vel.Y) * TimerMan.DeltaTimeSecs * 20;
			if SceneMan:CastObstacleRay(self.Pos, trace, pos, Vector(), 0, self.Team, 0, 5) >= 0 then
				--Check that the position is actually strong enough to cause dissipation.
				trace = SceneMan:ShortestDistance(self.Pos, pos, true);
				local strength = SceneMan:CastStrengthRay(self.Pos, trace, self.strengthThreshold, Vector(), 0, 0, true);
				local mo = SceneMan:CastMORay(self.Pos, trace, 0, self.Team, 0, true, 5);
				if strength or (mo ~= 255 and mo ~= 0) then
					local effect = CreateAEmitter("Techion.rte/Laser Dissipate Effect");
					effect.Pos = pos + Vector(self.Vel.X, self.Vel.Y):RadRotate(math.pi):SetMagnitude(3);
					effect.Vel = Vector(self.Vel.X, self.Vel.Y):RadRotate(math.pi):SetMagnitude(self.effectSpeed);
					MovableMan:AddParticle(effect);
					effect:GibThis();
				end
			end
		end
	end
	
	--Display the laser shot effect.
	if MovableMan:IsParticle(self.shotEffect) then
		if self.Vel.Magnitude >= self.speedThreshold then
			self.shotEffect.Pos = self.Pos;
			self.shotEffect.Vel = self.Vel;
			self.shotEffect.ToDelete = false;
		else
			self.shotEffect.ToDelete = true;
		end
	end

end

function Destroy(self)
	if MovableMan:IsParticle(self.shotEffect) then
		--Destroy the laser shot effect.
		self.shotEffect.ToDelete = true;
	end
end