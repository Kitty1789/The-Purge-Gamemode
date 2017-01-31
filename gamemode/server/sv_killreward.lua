hook.Add("DoPlayerDeath", "playerreward", function(victim, attacker)
	if attacker:IsPlayer() then -- Just to be sure, I never used this hook.
		attacker:AddCash(700)
	end
end)