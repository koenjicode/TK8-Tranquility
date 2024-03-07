local UEHelpers = require("UEHelpers")

-- LUA SETTINGS #START
toggleKeyBind = Key.F8 -- The key that's pressed to toggle your hud!

hidePlayerRanks = true -- Hides player ranks from showing.
hidePlayerPlates = false -- Hides player plates so they're not shown.
hideTekkenPower = true -- Hides Tekken Power from showing.
hideNames = false -- Disables names from showing, acts as a streamer mode as well!

panelOffset = 285 -- The distance that the panel will be moved to when rank information is hidden.

-- LUA SETTINGS #END

WidgetLayoutLibrary = nil
PolarisHud = nil
PlayerHud = nil
defaultPanelPos = {
    ["X"] = 625,
    ["Y"] = 362,
}


function OnBattleHudUpdate()
    UpdateGameReferences()

    if not PlayerHud:IsValid() then error("Player Hud cannot be found, Tranquility cannot make changes!") end
    if not WidgetLayoutLibrary:IsValid() then error("WidgetLayoutLibrary not valid, Tranquility cannot make changes!\n") end

    for i = 1, 2 do
        local playerIndex = i - 1

        if hideNames then
            AdjustFighterNames(playerIndex)
        end

        if hideTekkenPower then
            AdjustTekkenPowerVisbility(playerIndex)
        end

        if hidePlayerRanks then
            AdjustRankVisibility(playerIndex)
        end
    end
end

function UpdateGameReferences()
    WidgetLayoutLibrary = StaticFindObject("/Script/UMG.Default__WidgetLayoutLibrary")

    PolarisHud = FindFirstOf("WBP_UI_HUD_C")
    PlayerHud = PolarisHud.ref_player
end

function AdjustFighterNames(player)
    PlayerHud:SetFighterNameTexture2(player, nil)

    local charImage = nil
    if player == 0 then
        charImage = PlayerHud.Rep_T_UI_HUD_CH_ICON_L
    else
        charImage = PlayerHud.Rep_T_UI_HUD_CH_ICON_R
    end

    local charSel = string.sub(charImage.Brush.ResourceObject:GetFullName(), -3)
    local nameTexture = StaticFindObject("/Game/UI/Rep_Texture/HUD_Character_Name/T_UI_HUD_Character_Name_" .. charSel .. ".T_UI_HUD_Character_Name_" .. charSel)

    PlayerHud:SetFighterNameTexture(player, nameTexture)
end

function AdjustTekkenPowerVisbility(player)

    local powerRoot = nil
    if player == 0 then
        powerRoot = PlayerHud.TekkenPower_Root_L
    else
        powerRoot = PlayerHud.TekkenPower_Root_R
    end

    powerRoot:SetVisibility(2)
end

function AdjustRankVisibility(player)

    local rnkRoot = nil
    local shogoPanel = nil

    if player == 0 then
        rnkRoot = PlayerHud.RNK_Root_L
        shogoPanel = PlayerHud.WBP_UI_ShogoPanel_L
    else
        rnkRoot = PlayerHud.RNK_Root_R
        shogoPanel = PlayerHud.WBP_UI_ShogoPanel_R
    end

    rnkRoot:SetVisibility(2)

    -- Depending of the ranks are hidden or not, we adjust the position.
    if not hidePlayerPlates then
        local ref_canvas = WidgetLayoutLibrary:SlotAsCanvasSlot(shogoPanel)
        local panelPos = {
            ["X"] = defaultPanelPos.X - panelOffset,
            ["Y"] = defaultPanelPos.Y,
        }

        if player == 1 then
            panelPos.X = (panelPos.X * -1 )
        end

        ref_canvas:SetPosition(panelPos)
    end
end

function AdjustPlayerPanelVisibility()
    shogoPanel:SetVisibility(2)
end

RegisterHook("/Game/UI/Widget/HUD/WBP_UI_HUD_Player.WBP_UI_HUD_Player_C:SetZoneChainVisibility", function()
   OnBattleHudUpdate()
end)

RegisterKeyBind(toggleKeyBind, OnBattleHudUpdate)