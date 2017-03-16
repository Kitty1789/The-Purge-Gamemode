local PANEL = {}
function PANEL:Init()
	self.purgeWeaponIconList = {}
	self.purgeWeaponIconList_Collapse = {}

	self.TabList = vgui.Create("DPanelList", self)
	self.TabList:Dock(FILL)
	self.TabList:EnableVerticalScrollbar(true)

	if WeaponCategories then
		for k,v in pairs (WeaponCategories) do
			self.purgeWeaponIconList[k] = vgui.Create("DPanelList", self)
			self.purgeWeaponIconList[k]:SetAutoSize(true) 
		 	self.purgeWeaponIconList[k]:EnableHorizontal(true) 
		 	self.purgeWeaponIconList[k]:SetPadding(4) 
			self.purgeWeaponIconList[k]:SetVisible(true) 
			self.purgeWeaponIconList[k].OnMouseWheeled = nil
			
			self.purgeWeaponIconList_Collapse[k] = vgui.Create("DCollapsibleCategory", self)
			self.purgeWeaponIconList_Collapse[k]:SizeToContents()
			self.purgeWeaponIconList_Collapse[k]:SetLabel(v) 
			self.purgeWeaponIconList_Collapse[k]:SetVisible(true) 
			self.purgeWeaponIconList_Collapse[k]:SetContents(self.purgeWeaponIconList[k])
			self.purgeWeaponIconList_Collapse[k].Paint = function(self, w, h) 
				draw.RoundedBox(0, 0, 1, w, h, Color(0, 0, 0, 0)) 
				draw.RoundedBox(0, 0, 0, w, self.Header:GetTall(), Color(24, 24, 24, 255)) 
			end

			self.TabList:AddItem(self.purgeWeaponIconList_Collapse[k])
		end
	else
		LocalPlayer():ChatPrint([[Failed to load weapon categories table - please notify the server operator.]])
	end

	net.Start('plsgiveweaponlistibeengoodgirldaddy')
		net.WriteString("ILoveCum - blobles")
	net.SendToServer()
	
	local WeaponTable = {}
	net.Receive('purgeWeaponListTable', function(ply)
		WeaponTable = net.ReadTable()
		
		if Weapons then
			for k,v in pairs(Weapons) do
				if (table.HasValue(WeaponTable, v.Class)) then
					local ItemIcon = vgui.Create("SpawnIcon", self)
					ItemIcon:SetModel(v.Model)
					ItemIcon:SetSize(55,55)
					ItemIcon.DoClick = function() 
						RunConsoleCommand("purgeSellWeapon", k)
						surface.PlaySound("ui/buttonclick.wav")		
						ItemIcon:Remove()
					end

					if v.Name and v.Price then ItemIcon:SetToolTip(Format("%s", "Name: "..v.Name.."\nSell Price: $"..(v.Price * 0.65))) 
					else ItemIcon:SetToolTip(Format("%s", "Failed to load tooltip - Missing Description")) end

					if v.Group then	self.purgeWeaponIconList[v.Group]:AddItem(ItemIcon) end
					ItemIcon:InvalidateLayout(true) 
				end
			end
		end
		
	end)
	
	local AddWeapon = {}
	net.Receive('purgeWeaponListUpdate', function(ply)
		AddWeapon = net.ReadTable()
		
		local wepIndex = 0
		for k,v in pairs(Weapons) do
			if (v.Class == AddWeapon.Class) then
				wepIndex = k
			end
		end
		
		local ItemIcon = vgui.Create("SpawnIcon", self)
		ItemIcon:SetModel(AddWeapon.Model)
		ItemIcon:SetSize(55,55)
		ItemIcon.DoClick = function()
			RunConsoleCommand("purgeSellWeapon", wepIndex)
			surface.PlaySound("ui/buttonclick.wav")
			ItemIcon:Remove()
		end

		if AddWeapon.Name and AddWeapon.Price then ItemIcon:SetToolTip(Format("%s", "Name: "..AddWeapon.Name.."\nSell Price: $"..(AddWeapon.Price * 0.65))) 
		else ItemIcon:SetToolTip(Format("%s", "Failed to load tooltip - Missing Description")) end

		if AddWeapon.Group then	self.purgeWeaponIconList[AddWeapon.Group]:AddItem(ItemIcon) end
		ItemIcon:InvalidateLayout(true)
	end)
end
vgui.Register("purge_ShopMenu_SellWeapons", PANEL)
