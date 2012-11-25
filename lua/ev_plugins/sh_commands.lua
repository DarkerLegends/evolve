
/*-------------------------------------------------------------------------------------------------------------------------
	Display all chat commands
-------------------------------------------------------------------------------------------------------------------------*/
MsgN("Loaded Commands!")
local PLUGIN = {}
PLUGIN.Title = "Chatcommands"
PLUGIN.Description = "Display all available chat commands."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "commands"
PLUGIN.Usage = "[1/0 (all/yours)]"
PLUGIN.plugs = {}

function PLUGIN:Initialize()
	self.plugs = {}
	for k,v in pairs( evolve.plugins ) do
		if v.ChatCommand then
			self.plugs[#self.plugs+1] = table.Copy(v)
		end
	end

	table.sort( self.plugs, function( a, b )
		if not a then return false end
		if not b then return false end

		local tempa = a.ChatCommand
		local tempb = b.ChatCommand

		if type(tempa) == "table" then tempa = a.ChatCommand[1] end
		if type(tempb) == "table" then tempb = b.ChatCommand[1] end

		return tempa < tempb
	end)
end

function PLUGIN:Call( ply, args )
	if ( ply:IsValid() ) then
		local printall = false
		if (args[1] and args[1] == "1") then printall = true end

		if (printall) then
			umsg.Start( "EV_CommandStart", ply ) umsg.End()
		
			for _, plug in ipairs( self.plugs ) do
				if ( plug.ChatCommand ) then
					umsg.Start( "EV_Command", ply )
						umsg.String( (type(plug.ChatCommand) == "table" and table.concat( plug.ChatCommand, ", " ) or plug.ChatCommand) )
						umsg.String( tostring( plug.Usage ) )
						umsg.String( plug.Description )
					umsg.End()
				end
			end
		else
			umsg.Start( "EV_CommandStart", ply ) umsg.String( ply:EV_GetRank() ) umsg.End()
			
			for _, plug in ipairs( self.plugs ) do
				if ( plug.ChatCommand and plug.Privileges ) then
					for k,v in ipairs( plug.Privileges ) do
						if ( ply:EV_HasPrivilege(v) ) then
							umsg.Start( "EV_Command", ply )
								umsg.String( (type(plug.ChatCommand) == "table" and table.concat( plug.ChatCommand, ", " ) or plug.ChatCommand) )
								umsg.String( plug.Usage or "" )
								umsg.String( plug.Description )
							umsg.End()
							break
						end
					end
				end
			end
		end
		
		umsg.Start( "EV_CommandEnd", ply ) umsg.End()
		evolve:Notify( ply, evolve.colors.white, "All chat commands have been printed to your console." )
	else
		for _, plugin in ipairs( self.plugs ) do
			if ( plugin.ChatCommand ) then
				if ( plugin.Usage ) then
					MsgN( "!" .. (type(plugin.ChatCommand) == "table" and table.concat( plugin.ChatCommand, ", " ) or plugin.ChatCommand) .. " " .. plugin.Usage .. " - " .. plugin.Description )
				else
					MsgN( "!" .. (type(plugin.ChatCommand) == "table" and table.concat( plugin.ChatCommand, ", " ) or plugin.ChatCommand) .. " - " .. plugin.Description )
				end
			end
		end
	end
end

usermessage.Hook( "EV_CommandStart", function( um )
	local rank = um:ReadString()
	if (rank and #rank > 0) then
		MsgN( "\n============ Available chat commands for the rank " .. rank .. " ============\n" )
	else
		MsgN( "\n============ Available chat commands for Evolve ============\n" )
	end
end )

usermessage.Hook( "EV_CommandEnd", function( um )
	MsgN( "" )
end )

usermessage.Hook( "EV_Command", function( um )
	local com = um:ReadString()
	local usage = um:ReadString()
	local desc = um:ReadString()
	
	if ( usage and #usage > 0 ) then
		MsgN( "!" .. com .. " " .. usage .. " - " .. desc )
	else
		MsgN( "!" .. com .. " - " .. desc )
	end
end )

evolve:RegisterPlugin( PLUGIN )
