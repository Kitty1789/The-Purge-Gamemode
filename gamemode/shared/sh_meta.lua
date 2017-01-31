local MetaPlayer = FindMetaTable("Player")
local EntityMeta = FindMetaTable("Entity")
local Donators = { "vip", "superadmin" }

function MetaPlayer:IsDonator()
	for _,v in pairs(Donators) do
		if self:IsUserGroup(v) then
			return true
		end
	end

	return false
end

-- Player Scores
function MetaPlayer:GetScore()
	return self:GetNWInt("purge_score") or 0
end

function MetaPlayer:SetScore(score)
	self:SetNWInt("purge_score", score)
end

-- Player Color
function EntityMeta:GetPlayerColor()
	return self:GetNWVector("playerColor") or Vector()
end

function EntityMeta:SetPlayerColor(vec)
	self:SetNWVector("playerColor", vec)
end

-- Can Respawn
function MetaPlayer:CanRespawn()
	return self:GetNWBool("purge_canrespawn")
end

function MetaPlayer:SetCanRespawn(bool)
	self:SetNWBool("purge_canrespawn", bool)
end

-- Currency
function MetaPlayer:AddCash(amount)
	if amount then
		self:SetNetworkedInt("purge_cash", self:GetNetworkedInt("purge_cash") + tonumber(amount))
		self:Save()
	else
		print("purge: Error occured in AddCash function - No amount was passed.")
		return
	end
end

function MetaPlayer:SubCash(amount)
	if amount then
		self:SetNetworkedInt("purge_cash", self:GetNetworkedInt("purge_cash") - tonumber(amount))
		self:Save()
	else
		print("purge: Error occured in SubCash function - No amount was passed.")
		return
	end
end

function MetaPlayer:SetCash(amount)
	self:SetNetworkedInt("purge_cash", tonumber(amount))
end

function MetaPlayer:GetCash()
	return tonumber(self:GetNetworkedInt("purge_cash"))
end

function MetaPlayer:CanAfford(price)
	if tonumber(self:GetNetworkedInt("purge_cash")) >= tonumber(price) then
		return true
	else
		return false
	end
end

-- Save Data
function MetaPlayer:Save()
	if not file.IsDir("purge","DATA") then
		file.CreateDir("purge")
	end

	if not self.Weapons then
		self.Weapons = { }
		table.insert(self.Weapons, "weapon_pistol")
	end

	local data = {
		name =  string.gsub(self:Nick(), "\"", " ") or "bob",
		cash = self:GetNWInt("purge_cash"),
		weapons = string.Implode("\n", self.Weapons)
	}

	file.Write("purge/"..self:SteamID64()..".txt", util.TableToKeyValues(data))
end