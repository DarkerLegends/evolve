/*-------------------------------------------------------------------------------------------------------------------------
	Tab with Spacebuild settings
-------------------------------------------------------------------------------------------------------------------------*/

local convars = evolve:FindPlugin("Cconvar")

table.insert(convars.AllowedCommands, "SB_") --spacebuild commands
table.insert(convars.AllowedCommands, "LS_") --life support commands

local TAB = {}
TAB.Title = "Spacebuild2"
TAB.Description = "Manage Spacebuild2 settings."
TAB.Icon = "icon16/world.png"
TAB.Author = "MadDog"
TAB.Width = 520
TAB.Privileges = { "Spacebuild2 menu" }

TAB.Limits = {
	{ "sbox_maxreceptacles", "Receptacles" },
	{ "sbox_maxlife_support", "Life Support" },
	{ "sbox_maxenergysystems", "Energy Systems" }
}
TAB.ConVars = {
	{ "SB_NoClip", "Space NoClip" },
	{ "SB_PlanetNoClipOnly", "Planet NoClip Only" },
	{ "SB_AdminSpaceNoclip", "Admin Space NoClip" },
	{ "SB_SuperAdminSpaceNoclip", "SuperAdmin Space NoClip" },
	{ "LS_AllowNukeEffect", "Fusion Nukes" }
}

TAB.ConVarSliders = {}
TAB.ConVarCheckboxes = {}

function TAB:ApplySettings()
	for _, v in pairs( self.ConVarSliders ) do
		if ( GetConVar( v.ConVar ):GetInt() != v:GetValue() ) then
			RunConsoleCommand( "ev", "convar", v.ConVar, v:GetValue() )
		end
	end
	
	for _, v in pairs( self.ConVarCheckboxes ) do
		if ( GetConVar( v.ConVar ):GetBool() != v:GetChecked() ) then
			RunConsoleCommand( "ev", "convar", v.ConVar, evolve:BoolToInt( v:GetChecked() ) * ( v.OnValue or 1 ) )
		end
	end
end

function TAB:IsAllowed()
	return LocalPlayer():EV_HasPrivilege( "Spacebuild2 menu" )
end

function TAB:Update()
	for _, v in pairs( self.ConVarSliders ) do
		v:SetValue( GetConVar( v.ConVar ):GetInt() )
	end
	
	for _, v in pairs( self.ConVarCheckboxes ) do
		v:SetChecked( GetConVar( v.ConVar ):GetInt() > 0 )
	end
end

function TAB:Initialize( pnl )	

	

	self.LimitsContainer = vgui.Create( "DPanelList", pnl )
	self.LimitsContainer:SetPos( 0, 2 )
	self.LimitsContainer:SetSize( self.Width - 170, pnl:GetParent():GetTall() - 33 )
	self.LimitsContainer:SetSpacing( 9 )
	self.LimitsContainer:SetPadding( 10 )
	self.LimitsContainer:EnableHorizontal( true )
	self.LimitsContainer:EnableVerticalScrollbar( true )
	self.LimitsContainer.Think = function( self )
		if ( input.IsMouseDown( MOUSE_LEFT ) ) then
			self.applySettings = true
		elseif ( !input.IsMouseDown( MOUSE_LEFT ) and self.applySettings ) then
			TAB:ApplySettings()
			self.applySettings = false
		end
	end
	
	for i, cv in pairs( self.Limits ) do
		if ( ConVarExists( cv[1] ) ) then
			local cvSlider = vgui.Create( "DNumSlider", pnl )
			cvSlider:SetText( cv[2] )
			cvSlider:SetWide( self.LimitsContainer:GetWide() / 2 - 15 )
			cvSlider:SetMin( 0 )
			cvSlider:SetMax( 200 )
			cvSlider:SetDecimals( 0 )
			cvSlider:SetValue( GetConVar( cv[1] ):GetInt() )
			cvSlider.ConVar = cv[1]
			self.LimitsContainer:AddItem( cvSlider )
		
			table.insert( self.ConVarSliders, cvSlider )
		end
	end
	
	self.Settings = vgui.Create( "DPanelList", pnl )
	self.Settings:SetPos( self.Width - 165, 2 )
	self.Settings:SetSize( 165, pnl:GetParent():GetTall() - 33 )
	self.Settings:SetSpacing( 9 )
	self.Settings:SetPadding( 10 )
	self.Settings:EnableHorizontal( true )
	self.Settings:EnableVerticalScrollbar( true )
	
	for i, cv in pairs( self.ConVars ) do
		if ( ConVarExists( cv[1] ) ) then
			local cvCheckbox = vgui.Create( "DCheckBoxLabel", self.Settings )
			cvCheckbox:SetText( cv[2] )
			cvCheckbox:SetWide( self.Settings:GetWide() - 15 )
			cvCheckbox:SetValue( GetConVar( cv[1] ):GetInt() > 0 )
			cvCheckbox.ConVar = cv[1]
			cvCheckbox.OnValue = cv[3]
			cvCheckbox.DoClick = function( self )
				TAB:ApplySettings()
			end
			self.Settings:AddItem( cvCheckbox )
			
			table.insert( self.ConVarCheckboxes, cvCheckbox )
		end
	end
end

if ( CLIENT and GAMEMODE.IsSpaceBuildDerived ) then
	evolve:RegisterTab( TAB )
elseif ( SERVER ) then
	evolve:RegisterTab( TAB )
end