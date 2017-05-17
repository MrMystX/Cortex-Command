function ToughCraftsScript:StartScript()
	--print ("ToughCraftsScript:StartScript()")
	self.Multiplier = 4
end

function ToughCraftsScript:UpdateScript()
	--print ("ToughCraftsScript:UpdateScript()")
	for actor in MovableMan.Actors do
		if not actor:NumberValueExists("ToughCraftsScript") then
			actor:SetNumberValue("ToughCraftsScript", 1)

			if IsACDropShip(actor) then
				local dropship = ToACDropShip(actor)
				if dropship then
					dropship.GibWoundLimit = dropship.GibWoundLimit * self.Multiplier
					dropship.GibImpulseLimit = dropship.GibImpulseLimit * self.Multiplier
					if dropship.RThruster then
						dropship.RThruster.GibWoundLimit = dropship.RThruster.GibWoundLimit * self.Multiplier
						dropship.RThruster.GibImpulseLimit = dropship.RThruster.GibImpulseLimit * self.Multiplier
						dropship.RThruster.JointStrength = dropship.RThruster.JointStrength * self.Multiplier
					end
					if dropship.LThruster then
						dropship.LThruster.GibWoundLimit = dropship.LThruster.GibWoundLimit * self.Multiplier
						dropship.LThruster.GibImpulseLimit = dropship.LThruster.GibImpulseLimit * self.Multiplier
						dropship.LThruster.JointStrength = dropship.LThruster.JointStrength * self.Multiplier
					end
					if dropship.RHatch then
						dropship.RHatch.GibWoundLimit = dropship.RHatch.GibWoundLimit * self.Multiplier
						dropship.RHatch.GibImpulseLimit = dropship.RHatch.GibImpulseLimit * self.Multiplier
						dropship.RHatch.JointStrength = dropship.RHatch.JointStrength * self.Multiplier
					end
					if dropship.LHatch then
						dropship.LHatch.GibWoundLimit = dropship.LHatch.GibWoundLimit * self.Multiplier
						dropship.LHatch.GibImpulseLimit = dropship.LHatch.GibImpulseLimit * self.Multiplier
						dropship.LHatch.JointStrength = dropship.LHatch.JointStrength * self.Multiplier
					end
				end
			end
		
			if IsACRocket(actor) then
				local rocket = ToACRocket(actor)
				if rocket then
					rocket.GibWoundLimit = rocket.GibWoundLimit * self.Multiplier
					rocket.GibImpulseLimit = rocket.GibImpulseLimit * self.Multiplier
				end
			end
		end
	end
end

function ToughCraftsScript:EndScript()
	--print ("ToughCraftsScript:UpdateScript()")
end

function ToughCraftsScript:PauseScript()
	--print ("ToughCraftsScript:UpdateScript()")
end

function ToughCraftsScript:CraftEnteredOrbit()
	--print ("ToughCraftsScript:UpdateScript()")
end
