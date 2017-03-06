util.AddNetworkString("RoundState")
GM.GameState = GAMEMODE and GAMEMODE.GameState or 1

--
-- Game States
-- 0 = Waiting for players to join
-- 1 = Building Phase
-- 2 = purge Phase
-- 3 = Fight Phase
-- 4 = Reset Phase
--

--
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

local tNextThink = 0
function GM:TimerController()
	if CurTime() >= tNextThink then
		if self:GetGameState() == 0 then
			self:CheckPhase()
		elseif self:GetGameState() == 1 then
			self:BuildPhase()
		elseif self:GetGameState() == 2 then
			self:purgePhase()
		elseif self:GetGameState() == 3 then
			self:FightPhase()
		elseif self:GetGameState() == 4 then
			self:ResetPhase()
		end

		local gState = self:GetGameState() -- Because gamestate was nil every other way -_-
		net.Start("RoundState")
			net.WriteFloat(gState)
			net.WriteFloat(purge_buildTime)
			net.WriteFloat(purge_purgeTime)
			net.WriteFloat(purge_fightTime)
			net.WriteFloat(purge_resetTime)
		net.Broadcast()

		tNextThink = CurTime() + 1
	end
end

function GM:CheckPhase()
	local count = 0
	for _, v in pairs(player.GetAll()) do
		if IsValid(v) and v:Alive() then
			count = count + 1
		end
	end

	if count >= 2 then
		-- Time to build
		self:SetGameState(1)

		-- Clean the map, game is about to start
		self:CleanupMap()

		-- Respawn all the players
		for _, v in pairs(player.GetAll()) do
			if IsValid(v) then
				v:Spawn()
			end
		end
	end

	-- Updated: Breaks all vents & windows
	for _, v in pairs(ents.FindByClass("func_breakable")) do
		v:Remove()
	end
	for k, v in pairs(ents.FindByClass("func_breakable_surf")) do
		v:Remove()

	end
end

function GM:BuildPhase()
	if purge_buildTime <= 0 then
		-- Time to purge
		self:SetGameState(2)


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
	else
		purge_buildTime = purge_buildTime - 1
	end
end

function GM:purgePhase()
	if purge_purgeTime <= 0 then
		-- Time to Kill
		self:SetGameState(3)

		-- Its time to fight!
		self:GivePlayerWeapons()
	else
		purge_purgeTime = purge_purgeTime - 1
	end
end

function GM:FightPhase()
	if purge_fightTime <= 0 then
		-- Time to Reset
		self:SetGameState(4)
		-- BroadcastLua([[surface.PlaySound('audio/purge/thepurgeend.mp3')]])

		-- Declare winner is nobody because time ran out
		self:DeclareWinner(3)
	else
		purge_fightTime = purge_fightTime - 1
		self:ParticipationBonus()
	end
end

function GM:ResetPhase()
	if purge_resetTime <= 0 then
		-- Time to wait for players (if players exist, should go to build phase)
		self:SetGameState(0)

		-- Give people their money
		--self:RefundAllProps()
		self:CleanupMap()

		-- Game is over, lets tidy up the players
		for _, v in pairs(player.GetAll()) do
			if IsValid(v) then
				v:SetCanRespawn(true)

				-- Wait till they respawn
				timer.Simple(0.3, function()
					v:StripWeapons()
					v:RemoveAllAmmo()
					v:SetHealth(v:GetMaxHealth())
					v:SetArmor(0)
                    v:Give("weapon_physgun")

					timer.Simple(1.5, function()
						v:Give("gmod_tool")
						v:Give("weapon_physgun")
						//v:Give("purge_propseller")

						v:SelectWeapon("weapon_physgun")
					end)
				end)
			end
		end

		-- Reset all the round timers
		self:ResetAllTimers()
	else
		purge_resetTime = purge_resetTime - 1
	end
end

function GM:InitializeRoundController()
	purge_buildTime = GetConVar("purge_build_time"):GetFloat()
	purge_purgeTime = GetConVar("purge_purge_time"):GetFloat()
	purge_fightTime = GetConVar("purge_fight_time"):GetFloat()
	purge_resetTime = GetConVar("purge_reset_time"):GetFloat()

	hook.Add("Think", "purge_TimeController", function() hook.Call("TimerController", GAMEMODE) end)
end

function GM:ResetAllTimers()
	purge_buildTime = GetConVar("purge_build_time"):GetFloat()
	purge_purgeTime = GetConVar("purge_purge_time"):GetFloat()
	purge_fightTime = GetConVar("purge_fight_time"):GetFloat()
	purge_resetTime = GetConVar("purge_reset_time"):GetFloat()
end
