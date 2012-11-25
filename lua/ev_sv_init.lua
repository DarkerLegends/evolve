/*-------------------------------------------------------------------------------------------------------------------------
	Serverside initialization
-------------------------------------------------------------------------------------------------------------------------*/

// Show startup message
MsgN( "\n=====================================================" )
MsgN( " Evolve 1.0 by Northdegree succesfully started serverside." )
MsgN( "=====================================================\n" )

// Load plugins
evolve:LoadPlugins()

// Tell the clients Evolve is installed on the server
hook.Add( "PlayerSpawn", "EvolveInit", function( ply )
	if ( !ply.EV_SentInit and ply:IsValid() ) then
		timer.Simple( 1, function()
			umsg.Start( "EV_Init", ply )
			umsg.End()
		end )
		
		ply.EV_SentInit = true
	end
end )

// Add Evolve to the tag list
timer.Create( "TagCheck", 1, 0, function()
	if not GetConVar( "sv_tags" ) then CreateConVar("sv_tags","") end
	if ( !string.find( GetConVar( "sv_tags" ):GetString(), "Evolve" ) ) then
	RunConsoleCommand( "sv_tags", GetConVar( "sv_tags" ):GetString() .. ",Evolve" )
	end
end )