/*-------------------------------------------------------------------------------------------------------------------------
	Clientside initialization
-------------------------------------------------------------------------------------------------------------------------*/

// Show startup message
MsgN( "\n=====================================================" )
MsgN( " Evolve 1.0 by Northdegree succesfully started clientside." )
MsgN( "=====================================================\n" )

usermessage.Hook( "EV_Init", function( um )
	evolve.installed = true
	
	// Load plugins
	evolve:LoadPlugins()
end )