/*-------------------------------------------------------------------------------------------------------------------------
	Default custom scoreboard
-------------------------------------------------------------------------------------------------------------------------*/

resource.AddFile( "materials/gui/scoreboard_header.vtf" )
resource.AddFile( "materials/gui/scoreboard_header.vmt" )
resource.AddFile( "materials/gui/scoreboard_middle.vtf" )
resource.AddFile( "materials/gui/scoreboard_middle.vmt" )
resource.AddFile( "materials/gui/scoreboard_bottom.vtf" )
resource.AddFile( "materials/gui/scoreboard_bottom.vmt" )
resource.AddFile( "materials/gui/scoreboard_ping.vtf" )
resource.AddFile( "materials/gui/scoreboard_ping.vmt" )
resource.AddFile( "materials/gui/scoreboard_frags.vtf" )
resource.AddFile( "materials/gui/scoreboard_frags.vmt" )
resource.AddFile( "materials/gui/scoreboard_skull.vtf" )
resource.AddFile( "materials/gui/scoreboard_skull.vmt" )
resource.AddFile( "materials/gui/scoreboard_playtime.vtf" )
resource.AddFile( "materials/gui/scoreboard_playtime.vmt" )

if SERVER then
	CreateConVar("sbox_ev_scoreboard", 1, _, FCVAR_REPLICATED || FCVAR_ARCHIVE )
end


local PLUGIN = {}
PLUGIN.Title = "Scoreboard"
PLUGIN.Description = "Default custom scoreboard."
PLUGIN.Author = "Overv"

if ( CLIENT ) then
	PLUGIN.TexHeader = surface.GetTextureID( "gui/scoreboard_header" )
	PLUGIN.TexMiddle = surface.GetTextureID( "gui/scoreboard_middle" )
	PLUGIN.TexBottom = surface.GetTextureID( "gui/scoreboard_bottom" )
	PLUGIN.TexPing = surface.GetTextureID( "gui/scoreboard_ping" )
	PLUGIN.TexFrags = surface.GetTextureID( "gui/scoreboard_frags" )
	PLUGIN.TexDeaths = surface.GetTextureID( "gui/scoreboard_skull" )
	PLUGIN.TexPlaytime = surface.GetTextureID( "gui/scoreboard_playtime" )
	
	PLUGIN.Width = 687
	
	--surface.CreateFont( "Tahoma", 22, 400, true, false, "EvolveScoreboardHeader" )
	--surface.CreateFont( "Tahoma", 16, 1000, true, false, "EvolveScoreboardText" )
	--surface.CreateFont( "Tahoma", 16, 100, true, false, "EvolveDefault" )
	--surface.CreateFont( "Tahoma", 16, 1000, true, false, "EvolveDefaultBold" )
	surface.CreateFont( "EvolveScoreboardHeader", {"Tahoma", 22, 400, 1, 2, true, false, false, false, false, false, false, false, false})
	surface.CreateFont( "EvolveScoreboardText", {"Tahoma", 16, 1000, 1, 2, true, false, false, false, false, false, false, false, false})
	surface.CreateFont( "EvolveDefault", {"Tahoma", 16, 100, 1, 2, true, false, false, false, false, false, false, false, false})
	surface.CreateFont( "EvolveDefaultBold", {"Tahoma", 16, 1000, 1, 2, true, false, false, false, false, false, false, false, false})
end

function PLUGIN:ScoreboardShow()
	if ( GAMEMODE.IsSandboxDerived and evolve.installed ) then
		self.DrawScoreboard = true
		return true
	end
end

function PLUGIN:ScoreboardHide()
	if ( self.DrawScoreboard ) then
		self.DrawScoreboard = false
		return true
	end
end

function PLUGIN:DrawTexturedRect( tex, x, y, w, h )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( tex )
	surface.DrawTexturedRect( x, y, w, h )
end

function PLUGIN:QuickTextSize( font, text )
	surface.SetFont( font )
	return surface.GetTextSize( text )
end

function PLUGIN:FormatTime( raw )
	if ( raw < 60 ) then
		return math.floor( raw ) .. " secs"
	elseif ( raw < 3600 ) then
		if ( raw < 120 ) then return "1 min" else return math.floor( raw / 60 ) .. " mins" end
	elseif ( raw < 3600*24 ) then
		if ( raw < 7200 ) then return "1 hour" else return math.floor( raw / 3600 ) .. " hours" end
	else
		if ( raw < 3600*48 ) then return "1 day" else return math.floor( raw / 3600 / 24 ) .. " days" end
	end
end

local black = Color( 0, 0, 0, 255 )

function PLUGIN:DrawInfoBar()
	// Background
	surface.SetDrawColor( 192, 218, 160, 255 )
	surface.DrawRect( self.X + 15, self.Y + 110, self.Width - 30, 28 )
	
	surface.SetDrawColor( 168, 206, 116, 255 )
	surface.DrawOutlinedRect( self.X + 15, self.Y + 110, self.Width - 30, 28 )
	
	// Content
	local x = self.X + 24
	draw.SimpleText( "Currently playing ", "EvolveDefault", x, self.Y + 116, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

	x = x + self:QuickTextSize( "EvolveDefault", "Currently playing " )
	draw.SimpleText( GAMEMODE.Name, "EvolveDefaultBold", x, self.Y + 116, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

	x = x + self:QuickTextSize( "EvolveDefaultBold", GAMEMODE.Name )
	draw.SimpleText( " on the map ", "EvolveDefault", x, self.Y + 116, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

	x = x + self:QuickTextSize( "EvolveDefault", " on the map " )
	draw.SimpleText( game.GetMap(), "EvolveDefaultBold", x, self.Y + 116, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

	x = x + self:QuickTextSize( "EvolveDefaultBold", game.GetMap() )
	draw.SimpleText( ", with ", "EvolveDefault", x, self.Y + 116, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

	x = x + self:QuickTextSize( "EvolveDefault", ", with " )
	draw.SimpleText( #player.GetAll(), "EvolveDefaultBold", x, self.Y + 116, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

	x = x + self:QuickTextSize( "EvolveDefaultBold", #player.GetAll() )
	local s = ""
	if ( #player.GetAll() > 1 ) then s = "s" end
	draw.SimpleText( " player" .. s .. ".", "EvolveDefault", x, self.Y + 116, black, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
end

function PLUGIN:DrawUsergroup( playerinfo, usergroup, title, icon, y )
	local playersFound = false
	for _, pl in ipairs( playerinfo ) do
		if ( pl.Usergroup == usergroup ) then
			playersFound = true
			break
		end
	end
	if ( !playersFound ) then return y end
	
	surface.SetDrawColor( 168, 206, 116, 255 )
	surface.DrawRect( self.X + 0.5, y, self.Width - 2, 22 )
	surface.SetMaterial( icon )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( self.X + 15, y + 4, 14, 14 )
	draw.SimpleText( title, "EvolveDefaultBold", self.X + 40, y + 2, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
	
	self:DrawTexturedRect( self.TexPing, self.X + self.Width - 50, y + 4, 14, 14 )
	self:DrawTexturedRect( self.TexDeaths, self.X + self.Width - 150.5, y + 4, 14, 14 )
	self:DrawTexturedRect( self.TexFrags, self.X + self.Width - 190.5,  y + 4, 14, 14 )
	self:DrawTexturedRect( self.TexPlaytime, self.X + self.Width - 100,  y + 4, 14, 14 )
	
	y = y + 26
	
	for _, pl in ipairs( playerinfo ) do
		if ( pl.Usergroup == usergroup ) then
			draw.SimpleText( pl.Nick, "EvolveScoreboardText", self.X + 40, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( pl.Frags, "EvolveScoreboardText", self.X + self.Width - 187, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( pl.Deaths, "EvolveScoreboardText", self.X + self.Width - 147, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( pl.Ping, "EvolveScoreboardText", self.X + self.Width - 50, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
			draw.SimpleText( self:FormatTime( pl.PlayTime ), "EvolveScoreboardText", self.X + self.Width - 92, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
			
			y = y + 20
		end
	end
	
	return y + 10
end

function PLUGIN:DrawPlayers()
	local playerInfo = {}
	for _, v in pairs( player.GetAll() ) do
		local plynick
		if v:SteamID() == "STEAM_0:1:11323123" then
			plynick = v:Nick().." [Developer]"
		else
			plynick = v:Nick()
		end
		table.insert( playerInfo, { Nick = plynick, Usergroup = v:EV_GetRank(), Frags = v:Frags(), Deaths = v:Deaths(), Ping = v:Ping(), PlayTime = evolve:Time() - v:GetNWInt( "EV_JoinTime" ) + v:GetNWInt( "EV_PlayTime" ) } )
	end
	table.SortByMember( playerInfo, "Frags" )
	
	local y = self.Y + 155
	
	local sortedRanks = {}
	for id, rank in pairs( evolve.ranks ) do
		table.insert( sortedRanks, { ID = id, Title = rank.Title, Immunity = rank.Immunity, Icon = rank.IconTexture } )
	end
	table.SortByMember( sortedRanks, "Immunity" )
	
	for _, rank in ipairs( sortedRanks ) do
		if( string.Right( rank.Title, 2 ) != "ed" ) then
			y = self:DrawUsergroup( playerInfo, rank.ID, rank.Title .. "s", rank.Icon, y )
		else
			y = self:DrawUsergroup( playerInfo, rank.ID, rank.Title, rank.Icon, y )
		end
	end
	
	return y
end

function PLUGIN:HUDDrawScoreBoard()
	if ( !self.DrawScoreboard ) then return end
	if ( !self.Height ) then self.Height = 139 end
	
	// Update position
	self.X = ScrW() / 2 - self.Width / 2
	self.Y = ScrH() / 2 - ( self.Height ) / 2
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	surface.SetTexture( self.TexHeader )
	surface.DrawTexturedRect( self.X, self.Y, self.Width, 122 )
	draw.SimpleText( GetHostName(), "EvolveScoreboardHeader", self.X + 133, self.Y + 51, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	draw.SimpleText( GetHostName(), "EvolveScoreboardHeader", self.X + 132, self.Y + 50, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( self.TexMiddle )
	surface.DrawTexturedRect( self.X, self.Y + 122, self.Width, self.Height - 122 - 37 )
	surface.SetTexture( self.TexBottom )
	surface.DrawTexturedRect( self.X, self.Y + self.Height - 37, self.Width, 37 )
	
	self:DrawInfoBar()
	
	local y = self:DrawPlayers()
	
	self.Height = y - self.Y
end

evolve:RegisterPlugin( PLUGIN )