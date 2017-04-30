hook.Add('PlayerInitialSpawn', 'Anti-Proptouch', function(ply)
	ply:SetTrigger(true)
	function ply:Touch(ent)
		if IsValid(ent) and ent:GetClass() == 'prop_physics' and ent:IsFrozen() != true then
			ent:Freeze(true)
		end
	end
end)

hook.Add('PlayerShouldTakeDamage', 'Anti-Propdamage', function(ply, ent)
	if IsValid(ent) and ent:GetClass() == 'prop_physics' then
		return false
	end
end)
