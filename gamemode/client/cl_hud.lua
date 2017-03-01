surface.CreateFont( "Purge_HUD_Small", {
	 font = "Tehoma",
	 size = 14,
	 weight = 500,
	 antialias = true
})

surface.CreateFont( "Purge_HUD", {
	 font = "Tehoma",
	 size = 16,
	 weight = 500,
	 antialias = true
})

surface.CreateFont( "Purge_HUD_Large", {
	 font = "Tehoma",
	 size = 30,
	 weight = 500,
	 antialias = true
})

surface.CreateFont( "Purge_HUD_B", {
	 font = "Tehoma",
	 size = 18,
	 weight = 600,
	 antialias = true
})

-- Hud Stuff
local color_grey = Color(135, 135, 135, 200)
local color_black = Color(0, 0, 0, 200)
local active_color = Color(24, 24, 24, 255)
local outline_color = Color(0, 0, 0, 255)

local active_box_color = Color(255, 55, 55, 255)
local inactive_box_color = active_color

local text_inactive = Color(80,80,80,255)

local text_active = Color(255,255,255,255)

local x = ScrW()
local y = ScrH()

-- Timer Stuff
local GameState = 0
local BuildTimer = -1
local purgeTimer = -1
local FightTimer = -1
local ResetTimer = -1

local xPos = x * 0.0025
local yPos = y * 0.005

-- Hud Positioning
local Spacer = y * 0.006
local xSize = x * 0.2
local ySize = y * 0.04
local bWidth = Spacer + xSize + Spacer
local bHeight = Spacer + ySize + Spacer

net.Receive("RoundState", function(len)
	GameState = net.ReadFloat()
	BuildTimer = net.ReadFloat()
	purgeTimer = net.ReadFloat()
	FightTimer = net.ReadFloat()
	ResetTimer = net.ReadFloat()
end)

function GM:HUDPaint()
	if BuildTimer and purgeTimer and FightTimer and ResetTimer then
		if GameState == 0 then
			draw.RoundedBox(0, xPos, (y * 0.005)+20, x * 0.175,  x * 0.018, active_color)
			draw.RoundedBox(0, xPos, (y * 0.005)+20, 5, x * 0.018, active_box_color) -- ayy look pretty side boxes

			draw.SimpleText("Waiting for players.", "Purge_HUD", x * 0.01, (y * 0.01)+20, text_active, 0, 0)
			draw.SimpleText("Rush to get home!", "Purge_HUD", x * 0.01, (y * 0.044)+20, text_inactive, 0, 0)
			draw.SimpleText("Purge Activating!", "Purge_HUD", x * 0.01, (y * 0.078)+20, text_inactive, 0, 0)
			draw.SimpleText("Purge or Hide.", "Purge_HUD", x * 0.01, (y * 0.115)+20, text_inactive, 0, 0)
			draw.SimpleText("Restarting the round.", "Purge_HUD", x * 0.01, (y * 0.151)+20, text_inactive, 0, 0)
		else
			draw.RoundedBox(0, xPos, (y * 0.005)+20, x * 0.175,  x * 0.018, color_grey)
			draw.RoundedBox(0, xPos, (y * 0.005)+20, 5, x * 0.018, inactive_box_color) -- ayy look pretty side boxes
		end

		if GameState == 1 then
			draw.RoundedBox(0, xPos, yPos + (Spacer * 6) + 20, x * 0.175,  x * 0.018, active_color)
			draw.RoundedBox(0, xPos, yPos + (Spacer * 6) + 20, 5, x * 0.018, active_box_color) -- weeee another box
			draw.SimpleText(BuildTimer, "Purge_HUD", x * 0.15, (y * 0.044)+20, text_active, 0, 0)

			draw.SimpleText("Waiting for players.", "Purge_HUD", x * 0.01, (y * 0.01)+20, text_inactive, 0, 0)
			draw.SimpleText("Rush to get home!", "Purge_HUD", x * 0.01, (y * 0.044)+20, text_active, 0, 0)
			draw.SimpleText("Purge Activating!", "Purge_HUD", x * 0.01, (y * 0.078)+20, text_inactive, 0, 0)
			draw.SimpleText("Purge or Hide.", "Purge_HUD", x * 0.01, (y * 0.115)+20, text_inactive, 0, 0)
			draw.SimpleText("Restarting the round.", "Purge_HUD", x * 0.01, (y * 0.151)+20, text_inactive, 0, 0)
		else
			draw.RoundedBox(0, xPos, yPos + (Spacer * 6) + 20, x * 0.175,  x * 0.018, color_grey)
			draw.RoundedBox(0, xPos, yPos + (Spacer * 6) + 20, 5, x * 0.018, inactive_box_color) -- weeee another box
			draw.SimpleText(BuildTimer, "Purge_HUD", x * 0.15, (y * 0.044)+20, color_grey, 0, 0)
		end

		if GameState == 2 then
			draw.RoundedBox(0, xPos, yPos + (Spacer * 12) + 20, x * 0.175,  x * 0.018, active_color)
			draw.RoundedBox(0, xPos, yPos + (Spacer * 12) + 20, 5, x * 0.018, active_box_color) --  i run out of funny things
			draw.SimpleText(purgeTimer, "Purge_HUD", x * 0.15, (y * 0.078)+20, text_active, 0, 0)

			draw.SimpleText("Waiting for players.", "Purge_HUD", x * 0.01, (y * 0.01)+20, text_inactive, 0, 0)
			draw.SimpleText("Rush to get home!", "Purge_HUD", x * 0.01, (y * 0.044)+20, text_inactive, 0, 0)
			draw.SimpleText("Purge Activating!", "Purge_HUD", x * 0.01, (y * 0.078)+20, text_active, 0, 0)
			draw.SimpleText("Purge or Hide.", "Purge_HUD", x * 0.01, (y * 0.115)+20, text_inactive, 0, 0)
			draw.SimpleText("Restarting the round.", "Purge_HUD", x * 0.01, (y * 0.151)+20, text_inactive, 0, 0)
		else
			draw.RoundedBox(0, xPos, yPos + (Spacer * 12) + 20, x * 0.175,  x * 0.018, color_grey)
			draw.RoundedBox(0, xPos, yPos + (Spacer * 12) + 20, 5, x * 0.018, inactive_box_color) -- i ran out of funny things
			draw.SimpleText(purgeTimer, "Purge_HUD", x * 0.15, (y * 0.078)+20, color_grey, 0, 0)
		end

		if GameState == 3 then
			draw.RoundedBox(0, xPos, yPos + (Spacer * 18) + 20, x * 0.175,  x * 0.018, active_color)
			draw.RoundedBox(0, xPos, yPos + (Spacer * 18) + 20, 5, x * 0.018, active_box_color)
			draw.SimpleText(FightTimer, "Purge_HUD", x * 0.15, (y * 0.115)+20, text_active, 0, 0)

			draw.SimpleText("Waiting for players.", "Purge_HUD", x * 0.01, (y * 0.01)+20, text_inactive, 0, 0)
			draw.SimpleText("Rush to get home!", "Purge_HUD", x * 0.01, (y * 0.044)+20, text_inactive, 0, 0)
			draw.SimpleText("Purge Activating!", "Purge_HUD", x * 0.01, (y * 0.078)+20, text_inactive, 0, 0)
			draw.SimpleText("Purge or Hide.", "Purge_HUD", x * 0.01, (y * 0.115)+20, text_active, 0, 0)
			draw.SimpleText("Restarting the round.", "Purge_HUD", x * 0.01, (y * 0.151)+20, text_inactive, 0, 0)
		else
			draw.RoundedBox(0, xPos, yPos + (Spacer * 18) + 20, x * 0.175,  x * 0.018, color_grey)
			draw.RoundedBox(0, xPos, yPos + (Spacer * 18) + 20, 5, x * 0.018, inactive_box_color)
			draw.SimpleText(FightTimer, "Purge_HUD", x * 0.15, (y * 0.115)+20, color_grey, 0, 0)
		end

		if GameState == 4 then
			draw.RoundedBox(0, xPos, yPos + (Spacer * 24.1) + 20, x * 0.175,  x * 0.018, active_color) -- Changed this to 24.1 because the spacing was actually off for some reason
			draw.RoundedBox(0, xPos, yPos + (Spacer * 24.1) + 20, 5, x * 0.018, active_box_color)
			draw.SimpleText(ResetTimer, "Purge_HUD", x * 0.15, (y * 0.151)+20, text_active, 0, 0)

			draw.SimpleText("Waiting for players.", "Purge_HUD", x * 0.01, (y * 0.01)+20, text_inactive, 0, 0)
			draw.SimpleText("Rush to get home!", "Purge_HUD", x * 0.01, (y * 0.044)+20, text_inactive, 0, 0)
			draw.SimpleText("Purge Activating!", "Purge_HUD", x * 0.01, (y * 0.078)+20, text_inactive, 0, 0)
			draw.SimpleText("Purge or Hide.", "Purge_HUD", x * 0.01, (y * 0.115)+20, text_inactive, 0, 0)
			draw.SimpleText("Restarting the round.", "Purge_HUD", x * 0.01, (y * 0.151)+20, text_active, 0, 0)
		else
			draw.RoundedBox(0, xPos, yPos + (Spacer * 24.1) + 20, x * 0.175,  x * 0.018, color_grey)
			draw.RoundedBox(0, xPos, yPos + (Spacer * 24.1) + 20, 5, x * 0.018, inactive_box_color)

			draw.SimpleText(ResetTimer, "Purge_HUD", x * 0.15, (y * 0.151)+20, color_grey, 0, 0)
		end
	end

	-- Display Prop's Health
	local tr = util.TraceLine(util.GetPlayerTrace(LocalPlayer()))
	if tr.Entity:IsValid() and not tr.Entity:IsPlayer() then
		if tr.Entity:GetNWInt("CurrentPropHealth") == "" or tr.Entity:GetNWInt("CurrentPropHealth") == nil or tr.Entity:GetNWInt("CurrentPropHealth") == NULL then
			draw.SimpleText("Fetching Health", "Purge_HUD_Small", x * 0.5, y * 0.5 - 25, color_white, 1, 1)
		else
			draw.SimpleText("Health: " .. tr.Entity:GetNWInt("CurrentPropHealth"), "Purge_HUD_Small", x * 0.5, y * 0.5 - 25, color_white, 1, 1)
		end
	end

	-- Display Player's Health and Name
	if tr.Entity:IsValid() and tr.Entity:IsPlayer() then
		draw.SimpleText("Name: " .. tr.Entity:GetName(), "Purge_HUD_Small", x * 0.5, y * 0.5 - 75, color_white, 1, 1)
		draw.SimpleText("Health: " .. tr.Entity:Health(), "Purge_HUD_Small", x * 0.5, y * 0.5 - 60, color_white, 1, 1)
	end

	-- Bottom left HUD Stuff
	if LocalPlayer():Alive() and IsValid(LocalPlayer()) then
		draw.RoundedBox(6, 4, y - ySize - Spacer - (bHeight * 2), bWidth, bHeight * 2 + ySize, Color(24, 24, 24, 255))

		-- Health
		local pHealth = LocalPlayer():Health()
		local pHealthClamp = math.Clamp(pHealth / 100, 0, 1)
		local pHealthWidth = (xSize - Spacer) * pHealthClamp

		draw.RoundedBoxEx(6, Spacer * 2, y - (Spacer * 4) - (ySize * 3), Spacer + pHealthWidth, ySize, Color(128, 28, 28, 255), true, true, false, false)
		draw.SimpleText(math.Max(pHealth, 0).." HP","Purge_HUD_B", xSize * 0.5 + (Spacer * 2), y - (ySize * 2.5) - (Spacer * 4), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		-- Ammo
		if IsValid(LocalPlayer():GetActiveWeapon()) then
			if LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) > 0 or LocalPlayer():GetActiveWeapon():Clip1() > 0 then
				local wBulletCount = (LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) + LocalPlayer():GetActiveWeapon():Clip1()) + 1
				local wBulletClamp = math.Clamp(wBulletCount / 100, 0, 1)
				local wBulletWidth = (xSize - bWidth) * wBulletClamp

				draw.RoundedBox(0, Spacer * 2, y - (ySize * 2) - (Spacer * 3), bWidth + wBulletWidth, ySize, Color(30, 105, 105, 255))
				draw.SimpleText(wBulletCount.." Bullets", "Purge_HUD_B", xSize * 0.5 + (Spacer * 2), y - ySize - (ySize * 0.5) - (Spacer * 3), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.RoundedBox(0, Spacer * 2, y - (ySize * 2) - (Spacer * 3), xSize, ySize, Color(30, 105, 105, 255))
				draw.SimpleText("Doesn't Use Ammo", "Purge_HUD_B", xSize * 0.5 + (Spacer * 2), y - ySize - (ySize * 0.5) - (Spacer * 3), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		else
			draw.RoundedBox(0, Spacer * 2, y - (ySize * 2) - (Spacer * 3), xSize, ySize, Color(30, 105, 105, 255))
			draw.SimpleText("No Ammo", "Purge_HUD_B", xSize * 0.5 + (Spacer * 2), y - ySize - (ySize * 0.5) - (Spacer * 3), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		-- Cash
		local pCash = LocalPlayer():GetNWInt("Purge_cash") or 0
		local pCashClamp = math.Clamp(pCash / 5000, 0, xSize)

		draw.RoundedBoxEx(6, Spacer * 2, y - ySize - (Spacer * 2), xSize, ySize, Color(63, 140, 64, 255), false, false, true, true)
		draw.SimpleText("$"..pCash, "Purge_HUD_B", (xSize * 0.5) + (Spacer * 2), y - (ySize * 0.5) - (Spacer * 2), WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function hidehud(name)
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "hidehud", hidehud)
