-- Include everything
include("shared.lua")
 
MsgN("_-_-_-_- Purge Client Side -_-_-_-_")
MsgN("Loading Clientside Files")
for _, file in pairs(file.Find("ThePurge/gamemode/client/*.lua", "LUA")) do
	MsgN("-> "..file)
	include("ThePurge/gamemode/client/"..file)
end

MsgN("Loading Clientside VGUI Files")
for _, file in pairs(file.Find("ThePurge/gamemode/client/vgui/*.lua", "LUA")) do
	MsgN("-> "..file)
	include("ThePurge/gamemode/client/vgui/"..file)
end

function GM:SpawnMenuOpen(ply)
	return false
end

function GM:ContextMenuOpen(ply)
	return false
end

function GM:CanProperty(ply, property, ent)
	return false
end