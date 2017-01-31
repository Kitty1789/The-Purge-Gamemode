GM.ConstraintTools = GAMEMODE and GM.ConstraintTools or {}
GM.ConstructionTools = GAMEMODE and GM.ConstructionTools or {}
GM.PosingTools = GAMEMODE and GM.PosingTools or {}
GM.RenderTools = GAMEMODE and GM.RenderTools or {}

-- Tables are {"internal toolname", DonatorOnly bool, Enabled? bool},
GM.ConstraintTools = {
	{"axis", false, false}, 		{"ballsocket", false, true},
	{"elastic", false, true}, 	{"hydraulic", false, false},
	{"motor", false, false}, 	{"muscle", false, false},
	{"pulley", false, true}, 	{"rope", false, false},
	{"slider", false, false}, 	{"weld", false, true},
	{"winch", false, true}
}

GM.ConstructionTools = {
	{"balloon", false, false},	{"button", false, false},
	{"duplicator", false, false},{"dynamite", false, false},
	{"emitter", false, false}, 	{"hoverball", false, false},
	{"lamp", false, false}, 		{"light", false, false},
	{"nocollide", false, false},	{"physprop", false, false},
	{"remover", false, true}, 	{"thruster", false, false},
	{"wheel", false, false}
}

GM.PosingTools = {
	{"eyeposer", false, false}, 	{"faceposer", false, false},
	{"finger", false, false}, 	{"inflator", false, false}
}

GM.RenderTools = {
	{"camera", false, true}, {"colour", false, true},
	{"material", false, true}, {"paint", false, false},
	{"trails", false, false}
}

function GM:CompileToolTable()
	local tools = {}

	for _, v in pairs(self.ConstraintTools) do
		table.insert(tools, v)
	end

	for _, v in pairs(self.ConstructionTools) do
		table.insert(tools, v)
	end

	for _, v in pairs(self.PosingTools) do
		table.insert(tools, v)
	end

	for _, v in pairs(self.RenderTools) do
		table.insert(tools, v)
	end

	return tools
end