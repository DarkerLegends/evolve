/*-------------------------------------------------------------------------------------------------------------------------
	Serverside menu framework
-------------------------------------------------------------------------------------------------------------------------*/

// Send all tabs to the clients
for _, tab in ipairs( file.Find( "ev_menu/tab_*.lua", "LUA" ) ) do
	AddCSLuaFile( tab )
end

// Register privileges
table.insert( evolve.privileges, "Menu" )

function evolve:RegisterTab( tab )
	table.Add( evolve.privileges, tab.Privileges or {} )
end

for _, tab in ipairs( file.Find( "ev_menu/tab_*.lua", "LUA" ) ) do
	include( tab )
end