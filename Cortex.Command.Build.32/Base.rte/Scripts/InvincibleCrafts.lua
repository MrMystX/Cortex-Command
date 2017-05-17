function InvincibleCraftsScript:StartScript()
end

function InvincibleCraftsScript:UpdateScript()
	--print ("InvincibleCraftsScript:UpdateScript()")
	for actor in MovableMan.Actors do
		if not actor:NumberValueExists("InvincibleCraftsScript") then
			actor:SetNumberValue("InvincibleCraftsScript", 1)

			if IsACDropShip(actor) then
				local dropship = ToACDropShip(actor)
				if dropship then
					dropship.HitsMOs = false
					dropship.GetsHitByMOs = false
					if dropship.RThruster then
						dropship.RThruster.HitsMOs = false
						dropship.RThruster.GetsHitByMOs = false
						dropship.RThruster.JointStrength = 1000000
					end
					if dropship.LThruster then
						dropship.LThruster.HitsMOs = false
						dropship.LThruster.GetsHitByMOs = false
						dropship.LThruster.JointStrength = 1000000
					end
					if dropship.RHatch then
						dropship.RHatch.HitsMOs = false
						dropship.RHatch.GetsHitByMOs = false
						dropship.RHatch.JointStrength = 1000000
					end
					if dropship.LHatch then
						dropship.LHatch.HitsMOs = false
						dropship.LHatch.GetsHitByMOs = false
						dropship.LHatch.JointStrength = 1000000
					end
				end
			end
		
			if IsACRocket(actor) then
				local rocket = ToACRocket(actor)
				if rocket then
					rocket.HitsMOs = false
					rocket.GetsHitByMOs = false
				end
			end
		end
	end
end

function InvincibleCraftsScript:EndScript()
	--print ("InvincibleCraftsScript:UpdateScript()")
end

function InvincibleCraftsScript:PauseScript()
	--print ("InvincibleCraftsScript:UpdateScript()")
end

function InvincibleCraftsScript:CraftEnteredOrbit()
	--print ("InvincibleCraftsScript:UpdateScript()")
end
