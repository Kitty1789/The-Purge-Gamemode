hook.Add("DoPlayerDeath", "playerreward", function(victim, attacker)
	if attacker:IsPlayer() then -- Just to be sure, I never used this hook.
		if attacker != victim then -- Why give cash for suicides?
			attacker:AddCash(700)
		end
	end
end)
