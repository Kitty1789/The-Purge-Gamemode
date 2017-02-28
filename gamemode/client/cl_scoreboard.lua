scoreboard = scoreboard or {}
scoreboard.ranks = {}
scoreboard.ranks['superadmin'] 	= 'Owner'
scoreboard.ranks['admin'] 		= 'Admin'
scoreboard.ranks['moderator'] 	= 'Moderator'
scoreboard.ranks['vip'] 		= 'VIP'
scoreboard.ranks['user'] 		= 'User'
function scoreboard:show()
	scoreboard.base = vgui.Create('DPanel')
	scoreboard.base:SetSize(ScrW() / 3, ScrH() - 200)
	--scoreboard.base:SetPos(ScrW() / 2, ScrH() - 100)
	scoreboard.base:Center()
	scoreboard.base:MakePopup()
	function scoreboard.base:Paint(w, h)
		draw.RoundedBox(3, 0, 0, w, h, Color(236, 240, 241))
		draw.RoundedBoxEx(3, 0, 0, w, 25, Color(192, 57, 43), true, true, false, false)
		draw.SimpleText(GetHostName(), 'Trebuchet24', w/2, 25/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	scoreboard.scroll = vgui.Create('DScrollPanel', scoreboard.base)
	scoreboard.scroll:SetSize(scoreboard.base:GetWide(), scoreboard.base:GetTall() - 30)
	scoreboard.scroll:SetPos(0, 30)

	scoreboard.list = vgui.Create('DListView', scoreboard.scroll)
	scoreboard.list:SetSize(scoreboard.scroll:GetWide(), scoreboard.scroll:GetTall())
	scoreboard.list:SetPos(0, 0)
	scoreboard.list:SetMultiSelect(false)
	scoreboard.list:AddColumn('Rank')
	scoreboard.list:AddColumn('Player Name')
	scoreboard.list:AddColumn('Kills')
	scoreboard.list:AddColumn('Deaths')
	scoreboard.list:AddColumn('Money')
	scoreboard.list:AddColumn('Ping')
	scoreboard.list:AddColumn('Muted')

	for k, v in pairs(player.GetAll()) do
		if v:IsMuted() then
			v.mutedval = 'Yes'
		else
			v.mutedval = 'No'
		end
		local plyline = scoreboard.list:AddLine(scoreboard.ranks[v:GetUserGroup()], v:GetName(), v:Frags(), v:Deaths(), math.Clamp(v:GetNWInt("Purge_cash"), 0, 9999999999), v:Ping(), v.mutedval)
		plyline.ply = v
		function plyline:Paint(w, h)
			draw.RoundedBox(1, 0, 0, w, h, Color(255, 255, 255))
		end
		for k, v in pairs(plyline.Columns) do
			v:SetTextColor(Color(44, 62, 80))
		end
		plyline.Columns[5]:SetTextColor(Color(46, 204, 113))
		if v:Ping() > 100 then
			plyline.Columns[6]:SetTextColor(Color(255, 0, 0))
		end
	end
	function scoreboard.list:OnRowRightClick(index, panel)
		local menu = DermaMenu()
		local ply = panel.ply
		menu:AddOption('Toggle Mute On/Off', function()
			ply:SetMuted(!ply:IsMuted())
			scoreboard:hide()
			scoreboard:show()
		end)
		menu:AddOption('Open Profile', function()
			ply:ShowProfile()
		end)
		menu:AddOption('Copy Basic Information', function()
			SetClipboardText('Name: '..ply:GetName()..'\nSteam-ID32: '..ply:SteamID()..'\nSteam-ID64: '..ply:SteamID64()..'\nURL: https://steamcommunity.com/profiles/'..ply:SteamID64())
		end)
		menu:Open()
	end

	for _, v in pairs( scoreboard.list.Columns ) do
		function v.Header:Paint( w, h )
			draw.RoundedBox(0, 0, 0, w, h , Color(231, 76, 60))
		end
		v.Header:SetTextColor( Color( 255, 255, 255, 255 ) ) -- Set its text alpha with this incase you paint the text manually
	end

	local tallness = (#scoreboard.list:GetLines()*17) + 16 + 30
	scoreboard.base:SetTall(tallness)
end

function scoreboard:hide()
	scoreboard.base:Remove()
end

function GM:ScoreboardShow()
	scoreboard:show()
end

function GM:ScoreboardHide()
	scoreboard:hide()
end