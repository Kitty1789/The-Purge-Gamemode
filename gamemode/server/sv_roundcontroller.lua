util.AddNetworkString("RoundState")
GM.GameState = GAMEMODE and GAMEMODE.GameState or 0

--
-- Game States
-- 0 = Waiting for players to join
-- 1 = Building Phase
-- 2 = purge Phase
-- 3 = Fight Phase
-- 4 = Reset Phase
--

function GM:InitializeRoundController()
	purge_buildTime = GetConVar("purge_build_time"):GetFloat()
	purge_purgeTime = GetConVar("purge_purge_time"):GetFloat()
	purge_fightTime = GetConVar("purge_fight_time"):GetFloat()
	purge_resetTime = GetConVar("purge_reset_time"):GetFloat()

	--hook.Add("Think", "purge_TimeController", function() hook.Call("TimerController", GAMEMODE) end)
	timer.Create("PurgeTimerControl", 1, 0, function() hook.Call("NewTimerController", GAMEMODE) end)
end

function GM:GetGameState()
	return self.GameState
end

function GM:SetGameState(state)
	self.GameState = state
	local gamestate = hook.Run('purge_GameStateSet', state)
	if gamestate then
		self.GameState = gamestate		
	end
end

function GM:GetStateStart()
	return self.StateStart
end

function GM:GetStateRunningTime()
	return CurTime() - self.StateStart
end

function GM:NewTimerController()
	-- Ran every second.. smarter way, right? who would've thought of such monstrosity
	
	local GameState = self:GetGameState()
	local StateTime = purge_buildTime
	
	if GameState == 0 then
		self:CheckPhase()
	elseif GameState == 1 then
		if purge_buildTime < 1 then
			self:BuildPhase()
			self:SetGameState(2)
			StateTime = purge_purgeTime
		else
			purge_buildTime = purge_buildTime - 1
			StateTime = purge_buildTime
		end

	elseif GameState == 2 then
		if purge_purgeTime < 1 then
			self:purgePhase()
			self:SetGameState(3)
			StateTime = purge_fightTime
		else
			purge_purgeTime = purge_purgeTime - 1
			StateTime = purge_purgeTime
		end
	elseif GameState == 3 then
		if purge_fightTime < 1 then
			self:FightPhase()
			self:SetGameState(4)
			StateTime = purge_resetTime
		else
			purge_fightTime = purge_fightTime - 1
			StateTime = purge_fightTime
		end
	elseif GameState == 4 then
		if purge_resetTime < 1 then
			self:ResetPhase()
			self:SetGameState(0)
			StateTime = -1
		else
			purge_resetTime = purge_resetTime - 1
			StateTime = purge_resetTime
		end
	end
	
	net.Start("RoundState")
		net.WriteFloat(self:GetGameState())
		net.WriteFloat(StateTime)
	net.Broadcast()
end


function GM:CheckPhase()
	local count = #player.GetAll()

	if count >= 2 then
		-- Clean the map, game is about to start
		self:CleanupMap()
		
		for _, v in pairs(ents.FindByClass("func_breakable")) do
			v:Remove()
		end
		for k, v in pairs(ents.FindByClass("func_breakable_surf")) do
			v:Remove()

		end
	
		-- Time to build
		self:SetGameState(1)

		-- Respawn all the players
		for _, v in pairs(player.GetAll()) do
			if IsValid(v) then
				v:SetCanRespawn(true)
				
				timer.Simple(0.3, function()
					v:StripWeapons()
					v:RemoveAllAmmo()
					v:SetHealth(v:GetMaxHealth())
					v:SetArmor(0)

					timer.Simple(1.5, function()
						v:Give("gmod_tool")
						v:Give("weapon_physgun")
						//v:Give("purge_propseller")

						v:SelectWeapon("weapon_physgun")
					end)
				end)
			end
		end
		
	end
end

function GM:BuildPhase()
	-- Nobody can respawn now
	for _, v in pairs(player.GetAll()) do
		if IsValid(v) then
			v:SetCanRespawn(false)
		end
	end

	-- Prep phase two
	for _, v in pairs(self:GetActivePlayers()) do
		v:StripWeapons()
		v:RemoveAllAmmo()
		v:SetHealth(v:GetMaxHealth())
		v:SetArmor(0)
	end
end

function GM:purgePhase()
	self:GivePlayerWeapons()
end

function GM:FightPhase()
	-- Declare winner is nobody because time ran out
	self:DeclareWinner(3)
		
	--purge_fightTime = purge_fightTime - 1
	--self:ParticipationBonus()
end

function GM:ResetPhase()
	-- Give people their money
	--self:RefundAllProps()

	-- Reset all the round timers
	self:ResetAllTimers()
		
	for _, v in pairs(player.GetAll()) do
		if IsValid(v) then
			v:KillSilent()
		end
	end

end

function GM:ResetAllTimers()
	purge_buildTime = GetConVar("purge_build_time"):GetFloat()
	purge_purgeTime = GetConVar("purge_purge_time"):GetFloat()
	purge_fightTime = GetConVar("purge_fight_time"):GetFloat()
	purge_resetTime = GetConVar("purge_reset_time"):GetFloat()
end
