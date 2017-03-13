function numWithCommas(n)
  return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								:gsub(",(%-?)$","%1"):reverse()
end
--Pay player
local function Purge_Pay(ply, txt)
	local command = string.Explode(" ", txt)
	if command[1] == "!pay" then
		local ct = ChatText()
		local ct2 = ChatText()
		local ct3 = ChatText()
		local ct4 = ChatText()
		local ct5 = ChatText()
		--sooo many chattexts lol

		local commandname = command[1]
		
		--Combine all the command arguments (Normally wouldn't work with players with spaces, so this is the fix)
		local playerStr = ""
		for i=2,#command-1,1 do
			if i == 2 then
				playerStr = command[i]
			else
				playerStr = playerStr .. " " .. command[i]
			end
		end
		
		local pay_player = FindPlayer(ply, playerStr)
		local pay_amount = command[#command] -- Get the last value in the array (the amount to send)
		
		
		if CheckInput(ply, pay_amount, commandname) then
		pay_amount = math.floor(pay_amount) --pay amount is valid, so round it down, so no decimals
			if IsValid(pay_player) and (ply != pay_player) then
				if (pay_amount != 0) then
					if ply:GetCash() < tonumber(pay_amount) then
					--Player does not have enough cash to send this amount.
						ct2:AddText("[Purge] ", Color(158, 49, 49, 255))
						ct2:AddText("You do not have enough money to send that amount.")
						ct2:Send(ply)
					else
					--Player has enough & is valid
						ct3:AddText("[Purge] ", Color(132, 199, 29, 255))
						ct3:AddText("You have given $" .. numWithCommas(pay_amount) .. " to " .. pay_player:Nick() .. "!")
						ct3:Send(ply)
						
						ply:SubCash(pay_amount) --Take cash from sending player
						pay_player:AddCash(pay_amount) --Give cash to recieving player
						
						ct4:AddText("[Purge] ", Color(132, 199, 29, 255))
						ct4:AddText("You have received $".. numWithCommas(pay_amount) .." from " .. ply:Nick() .. "!")
						ct4:Send(pay_player)
						
					end
				else
					ct5:AddText("[Purge] ", Color(158, 49, 49, 255))
					ct5:AddText("Value must be above 0.")
					ct5:Send(ply)
				end
			else
				ct:AddText("[Purge] ", Color(158, 49, 49, 255))
				ct:AddText("Target player could not be found.")
				ct:Send(ply)
			end
		end

	end
end
hook.Add("PlayerSay", "Purge_Pay", Purge_Pay)

-- Give Cash
local function Purge_GiveCash(ply, txt)
	local command = string.Explode(" ", txt)
	if command[1] == "!givecash" then
		local ct = ChatText()
		local ct2 = ChatText()
		if ply:IsAdmin() then
			local target_player = FindPlayer(ply, command[2])
			local target_amount = command[3]
			local commandname = command[1]
			if CheckInput(ply, target_amount, commandname) then
				if IsValid(target_player) then	
					target_player:AddCash(command[3])

					ct:AddText("[Purge] ", Color(132, 199, 29, 255))					
					ct:AddText("You gave "..target_player:Nick().." $"..target_amount..".")
					ct:Send(ply)

					ct2:AddText("[Purge] ", Color(132, 199, 29, 255))					
					ct2:AddText("You were given $"..target_amount.." by "..ply:Nick()..".")
					ct2:Send(target_player)
				else
					ct:AddText("[Purge] ", Color(158, 49, 49, 255))
					ct:AddText("Target player could not be found.")
					ct:Send(ply)
				end
			end
		else
			ct:AddText("[Purge] ", Color(158, 49, 49, 255))
			ct:AddText("You don't have permission to use this command.")
			ct:Send(ply)
		end
	end
end
hook.Add("PlayerSay", "Purge_GiveCash", Purge_GiveCash)

-- Check Cash
local function Purge_CheckCash(ply, txt)
	local command = string.Explode(" ", txt)
	if command[1] == "!checkcash" then
		local ct = ChatText()
		if ply:IsAdmin() then
			local target_player = FindPlayer(ply, command[2])
			if IsValid(target_player) then	
				ct:AddText("[Purge] ", Color(132, 199, 29, 255))					
				ct:AddText(target_player:Nick().." has $"..target_player:GetCash()..".")
				ct:Send(ply)
			else
				ct:AddText("[Purge] ", Color(158, 49, 49, 255))
				ct:AddText("Target player could not be found.")
				ct:Send(ply)
			end
		else
			ct:AddText("[Purge] ", Color(158, 49, 49, 255))
			ct:AddText("You don't have permission to use this command.")
			ct:Send(ply)
		end
	end
end
hook.Add("PlayerSay", "Purge_CheckCash", Purge_CheckCash)

-- Set Cash
local function Purge_SetCash(ply, txt)
	local command = string.Explode(" ", txt)
	if command[1] == "!setcash" then
		local ct = ChatText()
		local ct2 = ChatText()
		if ply:IsAdmin() then
			local target_player = FindPlayer(ply, command[2])
			local target_amount = command[3]
			local commandname = command[1]
			if CheckInput(ply, target_amount, commandname) then
				if IsValid(target_player) then
					target_player:SetCash(target_amount)

					ct:AddText("[Purge] ", Color(132, 199, 29, 255))					
					ct:AddText("You set "..target_player:Nick().."'s cash to $"..target_amount..".")
					ct:Send(ply)

					ct2:AddText("[Purge] ", Color(132, 199, 29, 255))					
					ct2:AddText("Your cash has been set to $"..target_amount.." by "..ply:Nick()..".")
					ct2:Send(target_player)
				else
					ct:AddText("[Purge] ", Color(158, 49, 49, 255))
					ct:AddText("Target player could not be found.")
					ct:Send(ply)
				end
			end
		else
			ct:AddText("[Purge] ", Color(158, 49, 49, 255))
			ct:AddText("You don't have permission to use this command.")
			ct:Send(ply)
		end
	end
end
hook.Add("PlayerSay", "Purge_SetCash", Purge_SetCash)

-- Take Cash
local function Purge_TakeCash(ply, txt)
	local command = string.Explode(" ", txt)
	if command[1] == "!takecash" then
		local ct = ChatText()
		local ct2 = ChatText()
		if ply:IsAdmin() then
			local target_player = FindPlayer(ply, command[2])
			local target_amount = command[3]
			local commandname = command[1]
			if CheckInput(ply, target_amount, commandname) then
				if IsValid(target_player) then	
					target_player:SubCash(target_amount)	

					ct:AddText("[Purge] ", Color(132, 199, 29, 255))					
					ct:AddText("You have taken $"..target_amount.." from "..target_player:Nick()..".")
					ct:Send(ply)

					ct2:AddText("[Purge] ", Color(132, 199, 29, 255))					
					ct2:AddText("You had  $"..target_amount.." taken by "..ply:Nick()..".")
					ct2:Send(target_player)
				else
					ct:AddText("[Purge] ", Color(158, 49, 49, 255))
					ct:AddText("Target player could not be found.")
					ct:Send(ply)
				end
			end
		else
			ct:AddText("[Purge] ", Color(158, 49, 49, 255))
			ct:AddText("You don't have permission to use this command.")
			ct:Send(ply)
		end
	end
end
hook.Add("PlayerSay", "Purge_TakeCash", Purge_TakeCash)

-- Set Time
local function Purge_SetTime(ply, txt)
	local command = string.Explode(" ", txt)
	if command[1] == "!settime" then
		local ct = ChatText()
		if ply:IsAdmin() then
			if command[2] == "build" then
				if Purge_buildTime then
					Purge_buildTime = tonumber(command[3])

					ct:AddText("[Purge] ", Color(132, 199, 29, 255))					
					ct:AddText("You have set the build time for this round to "..command[3])
					ct:Send(ply)
				else
					ct:AddText("[Purge] ", Color(158, 49, 49, 255))
					ct:AddText("Build timer couldn't be found.")
					ct:Send(ply)
				end
			elseif command[2] == "Purge" then
				if Purge_PurgeTime then
					Purge_PurgeTime = tonumber(command[3])
					ct:AddText("[Purge] ", Color(132, 199, 29, 255))					
					ct:AddText("You have set the Purge time for this round to "..command[3])
					ct:Send(ply)
				else
					ct:AddText("[Purge] ", Color(158, 49, 49, 255))
					ct:AddText("Purge timer couldn't be found.")
					ct:Send(ply)
				end
			elseif command[2] == "fight" then
				if Purge_fightTime then
					Purge_fightTime = tonumber(command[3])
					ct:AddText("[Purge] ", Color(132, 199, 29, 255))					
					ct:AddText("You have set the fight time for this round to "..command[3])
					ct:Send(ply)
				else
					ct:AddText("[Purge] ", Color(158, 49, 49, 255))
					ct:AddText("Fight timer couldn't be found.")
					ct:Send(ply)
				end
			elseif command[2] == "reset" then
				if Purge_resetTime then
					Purge_resetTime = tonumber(command[3])
					ct:AddText("[Purge] ", Color(132, 199, 29, 255))					
					ct:AddText("You have set the reset time for this round to "..command[3])
					ct:Send(ply)
				else
					ct:AddText("[Purge] ", Color(158, 49, 49, 255))
					ct:AddText("Reset timer couldn't be found.")
					ct:Send(ply)
				end
			end			
		else
			ct:AddText("[Purge] ", Color(158, 49, 49, 255))
			ct:AddText("You don't have permission to use this command.")
			ct:Send(ply)
		end
	end
end
hook.Add("PlayerSay", "Purge_SetTime", Purge_SetTime)

-- Returns string
function FindPlayer(ply, target)
	name = string.lower(target)
	for _,v in ipairs(player.GetHumans()) do
		if(string.find(string.lower(v:Name()), name, 1, true) != nil) then 
			return v
		end
	end
end

-- Returns boolean
function CheckInput(ply, num, commandname)
	local numeric_num = tonumber(num)
	local string_num = tostring(num)
	local commandname = tostring(commandname)
	local ct = ChatText()

	if numeric_num or string_num then
		if string_num == "nan" or string_num == "inf" then 
			ct:AddText("[Purge] ", Color(158, 49, 49, 255))
			ct:AddText("Attempted to pass illegal characters as command argument.")
			ct:Send(ply)
			return false
		elseif numeric_num == nil or string_num == nil then 
			ct:AddText("[Purge] ", Color(158, 49, 49, 255))
			ct:AddText("Invalid parameters specified.")
			ct:Send(ply)
			return false
		elseif numeric_num < 0 then
			ct:AddText("[Purge] ", Color(158, 49, 49, 255))
			ct:AddText("Invalid number specified. Negatives not allowed.")
			ct:Send(ply)
			return false
		else 
			return true
		end
	elseif commandname then
		ct:AddText("[Purge] ", Color(158, 49, 49, 255))
		ct:AddText("Invalid number specified.\nCommand: "..commandname)
		ct:Send(ply)
		return false
	else
		ct:AddText("[Purge] ", Color(158, 49, 49, 255))
		ct:AddText("Invalid number specified.")
		ct:Send(ply)
		return false
	end
end
