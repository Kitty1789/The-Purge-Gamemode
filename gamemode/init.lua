-- Include and AddCSLua everything
include("shared.lua")
AddCSLuaFile("shared.lua")

MsgN("_-_-_-_- purge Server Side -_-_-_-_")
MsgN("Loading Server Files")
for _, file in pairs (file.Find("purge/gamemode/server/*.lua", "LUA")) do
	MsgN("-> "..file)
	include("purge/gamemode/server/"..file)
end

MsgN("Loading Shared Files")
for _, file in pairs (file.Find("purge/gamemode/shared/*.lua", "LUA")) do
	MsgN("-> "..file)
	AddCSLuaFile("purge/gamemode/shared/"..file)
end

MsgN("Loading Clientside Files")
for _, file in pairs (file.Find("purge/gamemode/client/*.lua", "LUA")) do
	MsgN("-> "..file)
	AddCSLuaFile("purge/gamemode/client/"..file)
end

MsgN("Loading Clientside VGUI Files")
for _, file in pairs (file.Find("purge/gamemode/client/vgui/*.lua", "LUA")) do
	MsgN("-> "..file)
	AddCSLuaFile("purge/gamemode/client/vgui/"..file)
end

-- Timer ConVars! Yay!
CreateConVar("purge_build_time", 160, FCVAR_NOTIFY, "Time allowed for building (def: 200)")
CreateConVar("purge_purge_time", 20, FCVAR_NOTIFY, "Time between build phase and fight phase (def: 70)")
CreateConVar("purge_fight_time", 300, FCVAR_NOTIFY, "Time allowed for fighting (def: 300)")
CreateConVar("purge_reset_time", 10, FCVAR_NOTIFY, "Time after fight phase to allow water to drain and other ending tasks (def: 13 - Dont recommend changing)")

-- Cash Convars
CreateConVar("purge_participation_cash", 150, FCVAR_NOTIFY, "Amount of cash given to a player every 5 seconds of being alive (def: 50)")
CreateConVar("purge_bonus_cash", 5000, FCVAR_NOTIFY, "Amount of cash given to the winner of a round (def: 500)")

-- Water Hurt System
CreateConVar("purge_wh_enabled", 0, FCVAR_NOTIFY, "Does the water hurt players - 1=true 2=false (def: 0)")
CreateConVar("purge_wh_damage", 0, FCVAR_NOTIFY, "How much damage a player takes per cycle (def: 0)")

-- Prop Limits
CreateConVar("purge_max_player_props", 20, FCVAR_NOTIFY, "How many props a player can spawn (def: 30)")
CreateConVar("purge_max_donator_props", 30, FCVAR_NOTIFY, "How many props a donator can spawn (def: 30)")
CreateConVar("purge_max_admin_props", 40, FCVAR_NOTIFY, "How many props an admin can spawn (def: 40)")

function GM:Initialize()
	self.ShouldHaltGamemode = false
	self:InitializeRoundController()

	-- Dont allow the players to noclip
	RunConsoleCommand("sbox_noclip", "0")

	-- We have our own prop spawning system
	RunConsoleCommand("sbox_maxprops", "0")
end

function GM:Think()
	self:ForcePlayerSpawn()
	self:CheckForWinner()

	if self.ShouldHaltGamemode == true then
		hook.Remove("Think", "purge_TimeController")
	end
end

function GM:CleanupMap()
	-- Refund what we can
	--self:RefundAllProps()

	-- Cleanup the rest
	game.CleanUpMap()

	-- Call InitPostEntity
	self:InitPostEntity()
end

function GM:ShowHelp(ply)
	ply:ConCommand("purge_helpmenu")
end

function GM:EntityTakeDamage(ent, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if GAMEMODE:GetGameState() ~= 2 and GAMEMODE:GetGameState() ~= 3 then
		return false
	else
		if not ent:IsPlayer() then
			if attacker:IsPlayer() then
				if attacker:GetActiveWeapon() ~= NULL then
					if attacker:GetActiveWeapon():GetClass() == "weapon_pistol" then
						ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - 1)
					else
						for _, Weapon in pairs(Weapons) do
							if attacker:GetActiveWeapon():GetClass() == Weapon.Class then
								ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - tonumber(Weapon.Damage))
							end
						end
					end
				end
			else
				if attacker:GetClass() == "entityflame" then
					ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - 0.5)
				else
					ent:SetNWInt("CurrentPropHealth", ent:GetNWInt("CurrentPropHealth") - 1)
				end
			end

			if ent:GetNWInt("CurrentPropHealth") <= 0 and IsValid(ent) then
				ent:Remove()
			end
		end
	end
end

function ShouldTakeDamage(victim, attacker)
	if GAMEMODE:GetGameState() ~= 3 then
		return true
	else
		if attacker:IsPlayer() and victim:IsPlayer() then
			return true
		else
			if attacker:GetClass() ~= "prop_*" and attacker:GetClass() ~= "entityflame" then
				return true
			end
		end
	end
end
hook.Add("PlayerShouldTakeDamage", "purge_PlayerShouldTakeDamge", ShouldTakeDamage)

function GM:KeyPress(ply, key)
 	if ply:Alive() ~= true then
 		local mode
 		if ply:GetObserverMode() == 4 then
 			mode = 5
 		else
 			mode = 4
 		end
 		if key == IN_ATTACK then
 			ply:CycleSpectator(1)
 		end
 		if key == IN_ATTACK2 then
 			ply:CycleSpectator(-1)
 		end
 		if key == IN_JUMP then
 			ply:SetObserverMode(mode)
 		end
 	end
end