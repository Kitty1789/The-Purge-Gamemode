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

-- New HUD Stuffs; blobles was here
local gsActive = Color(255,255,255,255)
local gsInactive = Color(50,50,50,255)

local gsInactiveBox = Color(80,80,80,255)
local gsActivebox = Color(50,50,50,255)

local sideboxGSActive = Color(255, 55, 55, 255)
local sideboxGSInactive = Color(24, 24, 24, 255)

local gs0color,gs1color,gs2color,gs3color,gs4color = gsInactive
local sideboxGS0,sideboxGS1,sideboxGS2,sideboxGS3,sideboxGS4 = sideboxGSInactive
local boxGS0,boxGS1,boxGS2,boxGS3,boxGS4 = gsInactiveBox

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
			--Waiting for players
			gs0color = gsActive
			gs1color,gs2color,gs3color,gs4color = gsInactive,gsInactive,gsInactive,gsInactive
			
			sideboxGS0 = sideboxGSActive
			sideboxGS1,sideboxGS2,sideboxGS3,sideboxGS4 = sideboxGSInactive,sideboxGSInactive,sideboxGSInactive,sideboxGSInactive
			
			boxGS0 = gsActivebox
			boxGS1,boxGS2,boxGS3,boxGS4 = gsInactiveBox,gsInactiveBox,gsInactiveBox,gsInactiveBox
		end
		if GameState == 1 then
			--Rush to get home
			gs0color,gs2color,gs3color,gs4color = gsInactive,gsInactive,gsInactive,gsInactive
			gs1color = gsActive
			
			sideboxGS0,sideboxGS2,sideboxGS3,sideboxGS4 = sideboxGSInactive,sideboxGSInactive,sideboxGSInactive,sideboxGSInactive
			sideboxGS1 = sideboxGSActive
			
			boxGS0,boxGS2,boxGS3,boxGS4 = gsInactiveBox,gsInactiveBox,gsInactiveBox,gsInactiveBox
			boxGS1 = gsActivebox
		end
		if GameState == 2 then
			--Purge activating
			gs0color,gs1color,gs3color,gs4color = gsInactive,gsInactive,gsInactive,gsInactive
			gs2color = gsActive

			sideboxGS0,sideboxGS1,sideboxGS3,sideboxGS4 = sideboxGSInactive,sideboxGSInactive,sideboxGSInactive,sideboxGSInactive
			sideboxGS2 = sideboxGSActive
			
			boxGS0,boxGS1,boxGS3,boxGS4 = gsInactiveBox,gsInactiveBox,gsInactiveBox,gsInactiveBox
			boxGS2 = gsActivebox
		end
		if GameState == 3 then
			--Purge or hide
			gs0color,gs1color,gs2color,gs4color = gsInactive,gsInactive,gsInactive,gsInactive
			gs3color = gsActive
			
			sideboxGS0,sideboxGS1,sideboxGS2,sideboxGS4 = sideboxGSInactive,sideboxGSInactive,sideboxGSInactive,sideboxGSInactive
			sideboxGS3 = sideboxGSActive

			boxGS0,boxGS1,boxGS2,boxGS4 = gsInactiveBox,gsInactiveBox,gsInactiveBox,gsInactiveBox
			boxGS3 = gsActivebox
		end
		if GameState == 4 then
			--Reset
			gs0color,gs1color,gs2color,gs3color = gsInactive,gsInactive,gsInactive,gsInactive
			gs4color = gsActive
			
			sideboxGS0,sideboxGS1,sideboxGS2,sideboxGS3 = sideboxGSInactive,sideboxGSInactive,sideboxGSInactive,sideboxGSInactive
			sideboxGS4 = sideboxGSActive
			
			boxGS0,boxGS1,boxGS2,boxGS3 = gsInactiveBox,gsInactiveBox,gsInactiveBox,gsInactiveBox
			boxGS4 = gsActivebox
		end
		
		local nY = 25
		local itemHeight = 25
		local spacingPerItem = 3

		-- Ouline boxes
		draw.RoundedBox(0, xPos, nY, x * 0.175, itemHeight, boxGS0)
		nY = nY + spacingPerItem + itemHeight
		draw.RoundedBox(0, xPos, nY, x * 0.175, itemHeight, boxGS1)
		nY = nY + spacingPerItem + itemHeight
		draw.RoundedBox(0, xPos, nY, x * 0.175, itemHeight, boxGS2)
		nY = nY + spacingPerItem + itemHeight
		draw.RoundedBox(0, xPos, nY, x * 0.175, itemHeight, boxGS3)
		nY = nY + spacingPerItem + itemHeight
		draw.RoundedBox(0, xPos, nY, x * 0.175, itemHeight, boxGS4)
		
		nY = 25 -- reset nY
		-- Side box thingies
		draw.RoundedBox(0, xPos, nY, 5, itemHeight, sideboxGS0)
		nY = nY + spacingPerItem + itemHeight
		draw.RoundedBox(0, xPos, nY, 5, itemHeight, sideboxGS1)
		nY = nY + spacingPerItem + itemHeight
		draw.RoundedBox(0, xPos, nY, 5, itemHeight, sideboxGS2)
		nY = nY + spacingPerItem + itemHeight
		draw.RoundedBox(0, xPos, nY, 5, itemHeight, sideboxGS3)
		nY = nY + spacingPerItem + itemHeight
		draw.RoundedBox(0, xPos, nY, 5, itemHeight, sideboxGS4)
		
		nY = 30 -- reset nY
		-- Text & Timers
		draw.SimpleText("Waiting for players.", "Purge_HUD", x * 0.01, nY, gs0color, 0, 0)
		nY = nY + spacingPerItem + itemHeight
		
		draw.SimpleText("Rush to get home!", "Purge_HUD", x * 0.01, nY, gs1color, 0, 0)
		draw.SimpleText(BuildTimer, "Purge_HUD", x * 0.15, nY, gs1color, 0, 0)
		nY = nY + spacingPerItem + itemHeight
		
		draw.SimpleText("Purge Activating!", "Purge_HUD", x * 0.01, nY, gs2color, 0, 0)
		draw.SimpleText(purgeTimer, "Purge_HUD", x * 0.15, nY, gs2color, 0, 0)
		nY = nY + spacingPerItem + itemHeight

		draw.SimpleText("Purge or Hide.", "Purge_HUD", x * 0.01, nY, gs3color, 0, 0)
		draw.SimpleText(FightTimer, "Purge_HUD", x * 0.15, nY, gs3color, 0, 0)
		nY = nY + spacingPerItem + itemHeight

		draw.SimpleText("Restarting the round.", "Purge_HUD", x * 0.01, nY, gs4color, 0, 0)
		draw.SimpleText(ResetTimer, "Purge_HUD", x * 0.15, nY, gs4color, 0, 0)
		

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

	function numWithCommas(n)
	  return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
									:gsub(",(%-?)$","%1"):reverse()
	end
	
	-- Bottom left HUD Stuff
	if LocalPlayer():Alive() and IsValid(LocalPlayer()) then
		--draw.RoundedBoxEx( number cornerRadius, number x, number y, number width, number height, table color, boolean roundTopLeft=false, boolean roundTopRight=false, boolean roundBottomLeft=false, boolean roundBottomRight=false )
		-- Background box
		draw.RoundedBox(4, 4, ScrH() - 148, 250, 144, Color(24,24,24,255)) 
		
		-- The Purge / Players Alive
		local pText = "The Purge"
		
		if (GameState == 3) then
			local pCount = 0
			for k, v in pairs( player.GetAll() ) do
				if ( v:Alive() ) then
				 pCount = pCount + 1
				end
			end
		
			pText = "The Purge - Players Alive: "..pCount
		end
		draw.RoundedBoxEx(4, 8, ScrH() - 118, 242, 5, Color(55, 55, 55, 255), false, false, true, true)
		draw.RoundedBoxEx(4, 8, ScrH() - 143, 242, 27, Color(80, 80, 80, 255), true, true, false, false)
		draw.SimpleText(pText,"Purge_HUD_B", 130, ScrH()-128, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		-- Health
		local pHealth = LocalPlayer():Health()
		local pHealthClamp = math.Clamp(pHealth / 100, 0, 1)
		local pHealthWidth = pHealthClamp * 242
		
		draw.RoundedBoxEx(4, 8, ScrH() - 84, 242, 5, Color(255, 41, 28, 255), false, false, true, true)
		draw.RoundedBoxEx(4, 8, ScrH() - 109, pHealthWidth, 27, Color(255, 65, 54, 255), true, true, false ,false)
		draw.SimpleText(math.Max(pHealth, 0).." HP","Purge_HUD_B", 130, ScrH()-93, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		-- Ammo
		if IsValid(LocalPlayer():GetActiveWeapon()) then
			if LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) > 0 or LocalPlayer():GetActiveWeapon():Clip1() > 0 then
				local wBulletCount = (LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()) + LocalPlayer():GetActiveWeapon():Clip1()) + 1
				local wBulletClamp = math.Clamp(wBulletCount / 100, 0, 1)
				local wBulletWidth = (xSize - bWidth) * wBulletClamp

				draw.RoundedBoxEx(4, 8, ScrH() - 49, 242, 5, Color(15, 100, 133, 255), false, false, true, true)
				draw.RoundedBoxEx(4, 8, ScrH() - 74, 242, 27,Color(21, 140, 186, 255), true, true, false, false)
				draw.SimpleText(numWithCommas(wBulletCount).." Bullets", "Purge_HUD_B", 130, ScrH()-59, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.RoundedBoxEx(4, 8, ScrH() - 49, 242, 5, Color(15, 100, 133, 255), false, false, true, true)
				draw.RoundedBoxEx(4, 8, ScrH() - 74, 242, 27,Color(21, 140, 186, 255), true, true, false, false)
				draw.SimpleText("Doesn't Use Ammo", "Purge_HUD_B", 130, ScrH()-59, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		else
			draw.RoundedBoxEx(4, 8, ScrH() - 49, 242, 5, Color(15, 100, 133, 255), false, false, true, true)
			draw.RoundedBoxEx(4, 8, ScrH() - 74, 242, 27,Color(21, 140, 186, 255), true, true, false, false)
			draw.SimpleText("No Ammo", "Purge_HUD_B", 130, ScrH()-59, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		
		-- Moany ;)
		local pCash = LocalPlayer():GetNWInt("Purge_cash") or 0
		local pCashClamp = math.Clamp(pCash / 5000, 0, 99999999)

		draw.RoundedBoxEx(4, 8, ScrH() - 14, 242, 5, Color(30, 138, 34, 255), false, false, true, true)
		draw.RoundedBoxEx(4, 8, ScrH() - 39, 242, 27,Color(40, 182, 44,255), true, true, false, false)
		draw.SimpleText("$"..numWithCommas(pCash), "Purge_HUD_B", 130, ScrH() - 25, WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

end

function hidehud(name)
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "hidehud", hidehud)
