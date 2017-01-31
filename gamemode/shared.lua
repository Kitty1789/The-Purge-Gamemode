DeriveGamemode("sandbox")

GM.Name 	= "The Purge"
GM.Author 	= "WTC - GhostCommunity"
GM.Base 	= "Flood 2.0"
GM.Version  = "1.5"
GM.Email 	= "N/A"
GM.Website 	= "https://wtcghostcommunity.com"

-- Include Shared files
for _, file in pairs (file.Find("purge/gamemode/shared/*.lua", "LUA")) do
   include("purge/gamemode/shared/"..file);
end

TEAM_PLAYER = 2

team.SetUp(TEAM_PLAYER, "Player", Color(16, 153, 156))

-- Format coloring because garry likes vectors for playermodels
function GM:FormatColor(col)
	col = Color(col.r * 255, col.g * 255, col.b * 255)
	return col
end