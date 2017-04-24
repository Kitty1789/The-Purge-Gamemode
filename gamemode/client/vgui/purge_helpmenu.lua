local x = ScrW()
local y = ScrH()
local HelpMenu

local PANEL = {}
function PANEL:Init()
	self.MainFrame = vgui.Create("DFrame")
	self.MainFrame:SetSize(x/2, y/2)
	self.MainFrame:Center()
	self.MainFrame:SetTitle("Purge Help Menu")
	self.MainFrame:SetScreenLock(true)
	self.MainFrame:SetDraggable(false)
	self.MainFrame:ShowCloseButton(false)
	self.MainFrame:SetBackgroundBlur(true)
	self.MainFrame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 200))
	end
	HelpMenu = self.MainFrame
	local wm,hm = HelpMenu:GetSize()
	
	local CloseButton = vgui.Create("DButton", HelpMenu)
	CloseButton:SetText("X")
	CloseButton.DoClick = function()
		RunConsoleCommand( "purge_help" )
	end
	CloseButton:SetWidth(20)
	CloseButton:SetPos(wm-20,0)
	CloseButton:SetFont("Purge_HUD_B")
	CloseButton.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,200))
	end
	
	local helpSheet = vgui.Create( "DPropertySheet", HelpMenu )
	helpSheet:Dock( FILL )
	
	local panel1Text = [[---- About ----

The Purge is a round-based gamemode where you either hide or kill other players during the round, in the top left of the screen there is a set of timers, each representing a different state of the game, you are given time to build in the 'Rush to get home' stage, and then once that's over the purge will start activating, once the 'Purge or hide' state is active then your guns which you have purchased will be given to you, it is your choice to either stay in a safe area, or try and face other players. Be warned, other players may have much better guns than you! It is recommended for the first few rounds to hide until you accumulate enough money (You get money for just staying alive) to buy a basic gun. If you feel like you can't survive on your own, team up with other players with the !party command, but be warned, they might betray you. If you need additional information, feel free to ask anyone in chat, everyone is always willing to help!]]
	local panel2Text = [[---- Weapons ----

Weapons are a crucial part in staying safe and alive in the purge, There are many different weapons to purchase (all of which are permanent) The best weapon for one person may not suit your play style. It would be good to test out a variety of different weapons, to see which suits you. You can purchase weapons by holding Q and going to the weapons tab. Please keep in mind, we cannot refund anything if you purchase something you did not mean to.]]
	local panel4Text = [[---- Credits ----

All credits go to WTC - Ghostcommunity, all rights reserved.
Owners: Lisa & Kermit 
With help from Amateur Ex-Developer: Blobles]]
	
	local panel1 = vgui.Create( "DPanel", helpSheet ) -- About
	local text = vgui.Create("DLabel", panel1)
	text:SetPos(5,1)
	text:Dock( FILL )
	text:DockMargin(10,10,10,10)
	text:SetWrap( true)
	text:SetColor(Color(0,0,0,255))
	text:SetContentAlignment(7)
	text:SetText(panel1Text)

	local panel2 = vgui.Create( "DPanel", helpSheet ) -- Weapons
	local text = vgui.Create("DLabel", panel2)
	text:SetPos(5,1)
	text:Dock( FILL )
	text:DockMargin(10,10,10,10)
	text:SetWrap( true)
	text:SetColor(Color(0,0,0,255))
	text:SetContentAlignment(7)
	text:SetText(panel2Text)
	
	local panel3 = vgui.Create( "DPanel", helpSheet ) -- Changelog
	local text = vgui.Create("RichText", panel3)
	text:SetPos(5,1)
	text:InsertColorChange(0,0,0,255)
	text:Dock( FILL )
	text:DockMargin(10,10,10,10)
	
	local returnedData = "Fetching changelog.."

	http.Fetch( "https://raw.githubusercontent.com/WTC-GhostCommunity/The-Purge-Gamemode/master/changelog.txt",
		function( body, len, headers, code )
			if string.match(body, "404") then
				text:SetText("Failed to get changelog.")
			else
				text:AppendText(body)
			end
		end,
		function( error )
			text:SetText("Failed to get changelog.")
		end
	 )
	text:SetWrap(true)
	
	local panel4 = vgui.Create( "DPanel", helpSheet ) -- Credits
	local text = vgui.Create("DLabel", panel4)
	text:SetPos(5,1)
	text:Dock( FILL )
	text:SetWrap( true)
	text:SetColor(Color(0,0,0,255))
	text:SetContentAlignment(7)
	text:SetText(panel4Text)
	text:DockMargin(10,10,10,10)
	
	local panel5 = vgui.Create( "DPanel", helpSheet)
	
	local rankList = vgui.Create( "DListView", panel5 )
	rankList:SetPos(5,1)
	rankList:Dock( FILL )
	rankList:SetMultiSelect( false )
	rankList:AddColumn( "Rank" )
	rankList:AddColumn( "XP To Level" )
	rankList:AddColumn( "Total XP" )
		
	if SimpleXPConfig.CustomRanks and #SimpleXPConfig.CustomRanks > 0 then
		for i,v in ipairs(SimpleXPConfig.CustomRanks) do
			i = i -1
			
			local xpToL = SimpleXPCalculateLevelToXP(i+1) - SimpleXPCalculateLevelToXP(i)
			rankList:AddLine(SimpleXPConfig.CustomRanks[i], xpToL, SimpleXPCalculateLevelToXP(i+1))
		end
	end
	
	
	helpSheet:AddSheet( "About", panel1, "icon16/information.png" )
	helpSheet:AddSheet( "Weapons", panel2, "icon16/gun.png" )
	helpSheet:AddSheet( "Changelog", panel3, "icon16/pencil_add.png" )
	helpSheet:AddSheet( "Credits", panel4, "icon16/heart.png" )
	helpSheet:AddSheet( "SimpleXP Ranks", panel5, "icon16/award_star_gold_2.png")
	
end

function PANEL:DoClick()
	surface.PlaySound(Sound("ui/buttonclickrelease.wav"))
end
vgui.Register("purge_HelpMenu", PANEL)

function GAMEMODE:PlayerBindPress( ply, bind, pressed )
    if ( bind == "gm_showhelp" ) then RunConsoleCommand( "purge_help" ) end
end

function purge_helpmenucmd()

	if HelpMenu == nil or not HelpMenu:IsValid() then
		vgui.Create("purge_HelpMenu")
		gui.EnableScreenClicker(true)
		RestoreCursorPosition()	
	else
		if HelpMenu:IsVisible() then
			HelpMenu:SetVisible(false)
			RememberCursorPosition()
			gui.EnableScreenClicker(false)
		else
			HelpMenu:SetVisible(true)
			gui.EnableScreenClicker(true)
			RestoreCursorPosition()	
		end
	end
	
end
concommand.Add("purge_help", purge_helpmenucmd)
