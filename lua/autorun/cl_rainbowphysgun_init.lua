
if SERVER then return end

local rainbowPhysgunEnabled = CreateClientConVar( "rainbowphysgun_enable", 1, true, false, "Enables the rainbow physgun.", 0, 1 ):GetBool()
local rainbowPhysgunSelfOnly = CreateClientConVar( "rainbowphysgun_selfonly", 0, true, false, "Do you want to only see the rainbow physgun for yourself?", 0, 1 ):GetBool()
local rainbowPhysgunSpeed = CreateClientConVar( "rainbowphysgun_speed", 20, true, false, "What should the speed of the rainbow physgun be?", 1, 50 ):GetInt()

cvars.AddChangeCallback( "rainbowphysgun_enable", function( convar, oldValue, newValue ) rainbowPhysgunEnabled = tobool( newValue ) end )
cvars.AddChangeCallback( "rainbowphysgun_selfonly", function( convar, oldValue, newValue ) rainbowPhysgunSelfOnly = tobool( newValue ) end )
cvars.AddChangeCallback( "rainbowphysgun_speed", function( convar, oldValue, newValue ) rainbowPhysgunSpeed = tonumber( newValue ) end )

local function rainbowColor( speed )
    local rainbowCol = HSVToColor( CurTime() * speed % 360, 1, 1 )
    return Vector( rainbowCol.r / 255, rainbowCol.g / 255, rainbowCol.b / 255 )
end

local localPly

local function SetPhysgunColorForPlayer( ply )
    if ply and ply:Alive() and ply:GetActiveWeapon():GetClass() == "weapon_physgun" then
        ply:SetWeaponColor( rainbowColor( rainbowPhysgunSpeed ) )
    end
end

hook.Add( "Think", "RainbowPhysgun.Think", function()
    if not rainbowPhysgunEnabled then return end

    if rainbowPhysgunSelfOnly then
        if not localPly then localPly = LocalPlayer() end
        SetPhysgunColorForPlayer( localPly )
    else for k, v in ipairs( player.GetAll() ) do SetPhysgunColorForPlayer( v ) end end
end )