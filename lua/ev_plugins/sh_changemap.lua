/*-------------------------------------------------------------------------------------------------------------------------
	Change the map
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Change Map"
PLUGIN.Description = "Change the map."
PLUGIN.Author = "Overv, General Wrex updated for gmod 13"
PLUGIN.ChatCommand = "map"
PLUGIN.Usage = "<map> [gamemode]"
PLUGIN.Privileges = { "Map changing" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Map changing" ) ) then
		if ( args[1] and file.Exists( "maps/" .. args[1] .. ".bsp", "GAME" ) and file.Exists( "gamemodes/" .. ( args[2] or GAMEMODE.FolderName ), "GAME" ) ) then
			if ( args[2] ) then
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has changed the map to ", evolve.colors.red, args[1], evolve.colors.white, " and the gamemode to ", evolve.colors.red, args[2], evolve.colors.white, "." )
			else
				evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has changed the map to ", evolve.colors.red, args[1], evolve.colors.white, "." )
			end

			timer.Simple( 0.5, function() 
			RunConsoleCommand( "gamemode", args[2] or GAMEMODE.FolderName)
			RunConsoleCommand( "changelevel", args[1] ) 
			
			end )
		else
			evolve:Notify( ply, evolve.colors.red, "Specified map or gamemode not found!" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )