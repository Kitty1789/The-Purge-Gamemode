local PANEL = {}
function PANEL:Init()
	self.purgePropIconList = {}
	self.purgePropIconList_Collapse = {}

	self.TabList = vgui.Create("DPanelList", self)
	self.TabList:Dock(FILL)
	self.TabList:EnableVerticalScrollbar(true)

	if PropCategories then
		for k,v in pairs (PropCategories) do
			self.purgePropIconList[k] = vgui.Create("DPanelList", self)
			self.purgePropIconList[k]:SetAutoSize(true) 
		 	self.purgePropIconList[k]:EnableHorizontal(true) 
		 	self.purgePropIconList[k]:SetPadding(4) 
			self.purgePropIconList[k]:SetVisible(true) 
			self.purgePropIconList[k].OnMouseWheeled = nil
			
			self.purgePropIconList_Collapse[k] = vgui.Create("DCollapsibleCategory", self)
			self.purgePropIconList_Collapse[k]:SizeToContents()
			self.purgePropIconList_Collapse[k]:SetLabel(v) 
			self.purgePropIconList_Collapse[k]:SetVisible(true) 
			self.purgePropIconList_Collapse[k]:SetContents(self.purgePropIconList[k])
			self.purgePropIconList_Collapse[k].Paint = function(self, w, h) 
				draw.RoundedBox(0, 0, 1, w, h, Color(0, 0, 0, 0)) 
				draw.RoundedBox(0, 0, 0, w, self.Header:GetTall(), Color(24, 24, 24, 255)) 
			end

			self.TabList:AddItem(self.purgePropIconList_Collapse[k])
		end
	else
		LocalPlayer():ChatPrint([[Failed to load prop categories table - please notify the server operator.]])
	end

	if Props then
		for k, v in pairs(Props) do	
			local ItemIcon = vgui.Create("SpawnIcon", self)
			ItemIcon:SetModel(v.Model)
			ItemIcon:SetSize(55,55)
			ItemIcon.DoClick = function() 
				RunConsoleCommand("purgePurchaseProp", k)
				surface.PlaySound("ui/buttonclick.wav")		
			end

			if v.Description and v.Health and v.Price then ItemIcon:SetToolTip(Format("%s", "Name: "..v.Description.."\nHealth: "..v.Health.."\nPrice: $"..v.Price)) 
			else ItemIcon:SetToolTip(Format("%s", "Failed to load tooltip - Missing Description")) end

			if v.Group then self.purgePropIconList[v.Group]:AddItem(ItemIcon) end
			ItemIcon:InvalidateLayout(true) 
		end
	else
		LocalPlayer():ChatPrint([[Failed to load prop table - please notify the server operator.]])
	end
end
vgui.Register("purge_ShopMenu_Props", PANEL)