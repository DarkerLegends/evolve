--[[

	Fixed by MadDog
	May 2012
]]

/*-------------------------------------------------------------------------------------------------------------------------
	Restriction
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Restriction"
PLUGIN.Description = "Restricts weapons."
PLUGIN.Author = "Overv"

function PLUGIN:PlayerSpawnSWEP( ply, name, tbl )
	if ( GAMEMODE.IsSandboxDerived and table.HasValue( evolve.privileges, "@" .. name ) and !ply:EV_HasPrivilege( "@" .. name ) ) then
		evolve:Notify( ply, evolve.colors.red, "You are not allowed to spawn this weapon!" )
		return false
	end
end
function PLUGIN:PlayerGiveSWEP( ply, name, tbl )
	if ( self:PlayerSpawnSWEP( ply, name, tbl ) == false ) then
		return false
	end
end

function PLUGIN:PlayerSpawnSENT( ply, class )
	if ( GAMEMODE.IsSandboxDerived and table.HasValue( evolve.privileges, ":" .. class ) and !ply:EV_HasPrivilege( ":" .. class ) ) then
		evolve:Notify( ply, evolve.colors.red, "You are not allowed to spawn this entity!" )
		return false
	end
end

function PLUGIN:CanTool( ply, tr, class )
	if ( GAMEMODE.IsSandboxDerived and table.HasValue( evolve.privileges, "#" .. class ) and !ply:EV_HasPrivilege( "#" .. class ) ) then
		evolve:Notify( ply, evolve.colors.red, "You are not allowed to use this tool!" )
		return false
	end
end

function PLUGIN:PlayerSpawn( ply )
	// Only block picking up when a player spawns, because we still want to make it possible to use !give and allow admins to drop weapons for players!
	ply.EV_PickupTimeout = CurTime() + 0.5
end

function PLUGIN:PlayerCanPickupWeapon( ply, wep )
	if ( GAMEMODE.IsSandboxDerived and table.HasValue( evolve.privileges, "@" .. wep:GetClass() ) and !ply:EV_HasPrivilege( "@" .. wep:GetClass() ) and ( !ply.EV_PickupTimeout or CurTime() < ply.EV_PickupTimeout ) ) then
		return false
	end
end

function PLUGIN:Initialize()
	if CLIENT then return end

	evolve:LoadRanks()

	// Weapons
	local weps = {}

	for _, wep in pairs( weapons.GetList() ) do
		table.insert( weps, "@" .. wep.ClassName )
	end

	table.Add( weps, {
		"@weapon_crowbar",
		"@weapon_pistol",
		"@weapon_smg1",
		"@weapon_frag",
		"@weapon_physcannon",
		"@weapon_crossbow",
		"@weapon_shotgun",
		"@weapon_357",
		"@weapon_Rpg",
		"@weapon_ar2",
		"@weapon_physgun",
	} )

	table.Add( evolve.privileges, weps )

	// Entities
	local entities = {}

	for class, ent in pairs( scripted_ents.GetList() ) do
		if ( ent.t.Spawnable or ent.t.AdminSpawnable ) then
			table.insert( entities, ":" .. ( ent.ClassName or class ) )
		end
	end

	table.Add( evolve.privileges, entities )

	// Tools
	local tools = {}

	if ( GAMEMODE.IsSandboxDerived ) then
		for _, val in ipairs( file.Find( "weapons/gmod_tool/stools/*.lua", "LUA" )  ) do
			local _, __, class = string.find( val, "([%w_]*).lua" )
			table.insert( tools, "#" .. class )
		end
	end

	table.Add( evolve.privileges, tools )

	--this table is kept so when new entities/tools are added they get added to every rank
	if ( file.Exists( "ev_allentitiescache.txt", "DATA" ) ) then
		evolve.allentities = glon.decode( file.Read( "ev_allentitiescache.txt", "DATA" ) )
	else
		evolve.allentities = {}
	end

	for id, rank in pairs( evolve.ranks ) do
		if ( id == "owner" ) then continue; end

		for id,name in pairs(weps) do
			if !table.HasValue(evolve.allentities, name) then
				table.insert( rank.Privileges, name )
				table.insert( evolve.allentities, name)
			end
		end

		for id,name in pairs(entities) do
			if !table.HasValue(evolve.allentities, name) then
				table.insert( rank.Privileges, name )
				table.insert( evolve.allentities, name)
			end
		end

		for id,name in pairs(tools) do
			if !table.HasValue(evolve.allentities, name) then
				table.insert( rank.Privileges, name )
				table.insert( evolve.allentities, name)
			end
		end
	end

	file.Write( "ev_allentitiescache.txt", glon.encode( evolve.allentities ) )

	evolve:SaveRanks()
end

evolve:RegisterPlugin( PLUGIN )