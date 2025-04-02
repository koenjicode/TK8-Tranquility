local config = require "config"
local helper = require "helper"

local widget_layout_library = nil
local polaris_hud = nil
local player_hud = nil

local hudRegistered = false

if config.disable_everything then
    return
end

-- Main Update function
function onBattleHudUpdate()
    -- We make sure game references for the hud are up to date before we do any changes.
    updateGameReferences()

    -- Stop execution if we fail to get any of the required hud elements.
    if not player_hud:IsValid() then error("Player Hud cannot be found, Tranquility cannot make changes!") end
    if not widget_layout_library:IsValid() then error("WidgetLayoutLibrary not valid, Tranquility cannot make changes!\n") end

    print("Hud hooked, applying changes")

    -- Loop logic for P1 and P2
    for i = 1, 2 do
        local playerIndex = i - 1

        -- Code to hide Player Names
        if config.streamer_mode then
            adjustFighterNames(playerIndex)
        end

        -- Code to hide Tekken Power.
        if config.hide_tekken_power then
            adjustTekkenPowerVisbility(playerIndex)
        end

        -- Code to hide player ranks.
        if config.hide_player_ranks then
            adjustRankVisibility(playerIndex)
        end

        if config.hide_win_streaks then
            adjustWinStreak(playerIndex)
        end

        -- Hide Player Plates.
        adjustPlayerPanels(playerIndex)
    end
end

function updateGameReferences()
    widget_layout_library = StaticFindObject("/Script/UMG.Default__WidgetLayoutLibrary")
    print("Finding HUD")

    polaris_hud = FindFirstOf("WBP_UI_HUD_S2_C")
    player_hud = polaris_hud.ref_player
end

function adjustWinStreak(playerIndex)
    local _information = polaris_hud.ref_information
    if playerIndex == 0 then
        _information.WINS_L:SetVisibility(2)
    else
        _information.WINS_R:SetVisibility(2)
    end
end

function adjustPlayerPanels(player)
    local _shogo_panel = nil

    if player == 0 then
        _shogo_panel = player_hud.WBP_UI_ShogoPanel_L
    else
        _shogo_panel = player_hud.WBP_UI_ShogoPanel_R
    end

    if config.hide_player_panels then
        _shogo_panel:SetVisibility(2)
    else
        if config.hide_player_ranks then
            local _ref_canvas = widget_layout_library:SlotAsCanvasSlot(_shogo_panel)
            local _panel_position = {
                ["X"] = helper.default_panel_position.X - config.panel_offset,
                ["Y"] = helper.default_panel_position.Y,
            }

            if player == 1 then
                _panel_position.X = (_panel_position.X * -1 )
            end

            _ref_canvas:SetPosition(_panel_position)
        end
    end
end

function adjustFighterNames(player)
    player_hud:SetFighterNameTexture2(player, nil)

    local _char_image = nil
    if player == 0 then
        _char_image = player_hud.WBP_UI_HUD_Char_Icon_1P.Rep_T_UI_HUD_CH_ICON_L
    else
        _char_image = player_hud.WBP_UI_HUD_Char_Icon_2P.Rep_T_UI_HUD_CH_ICON_R
    end

    print(_char_image:GetFullName())

    local _char_brush = helper.getCharacterNameFromTexture(_char_image.Brush.ResourceObject)
    local _name_texture = StaticFindObject("/Game/UI/Rep_Texture/HUD_Character_Name/T_UI_HUD_Character_Name_" .. _char_brush .. ".T_UI_HUD_Character_Name_" .. _char_brush)
    player_hud:SetFighterNameTexture(player, _name_texture)

    ExecuteWithDelay(100, function()
        local _ghost_icon = nil
        if player == 0 then
            _ghost_icon = player_hud.Ghost_Icon_L
        else
            _ghost_icon = player_hud.Gh_Icon_R
        end

        if _ghost_icon:IsValid() then
            _ghost_icon:SetVisibility(2)
        end
    end)
end

function adjustTekkenPowerVisbility(player)

    local _tekken_power_root = nil
    if player == 0 then
        _tekken_power_root = player_hud.TekkenPower_Root_L
    else
        _tekken_power_root = player_hud.TekkenPower_Root_R
    end

    _tekken_power_root:SetVisibility(2)
end

function adjustRankVisibility(player)

    local _rank_root = nil
    if player == 0 then
        _rank_root = player_hud.RNK_Root_L
    else
        _rank_root = player_hud.RNK_Root_R
    end

    _rank_root:SetVisibility(2)
end

NotifyOnNewObject("/Script/Polaris.PolarisUMGMakuai", function(makuai)
    ExecuteWithDelay(500, function()
        for i = 1, 2 do
            local _player_info = nil
            if i == 1 then
                _player_info = makuai.WBP_UI_PlayerInfo_L
            else
                _player_info = makuai.WBP_UI_PlayerInfo_R
            end

            if config.hide_makuai_info then
                _player_info:SetVisibility(2)
            else
                if config.hide_player_ranks then
                    _player_info.Rep_T_UI_CMN_RNK_S:SetVisibility(2)
                end

                if config.hide_tekken_power then
                    _player_info.BG_TekkenPower:SetVisibility(2)
                    _player_info.TB_TekkenPower:SetVisibility(2)
                    _player_info.TB_TekkenPower_data:SetVisibility(2)
                end

                if config.streamer_mode then

                    local _character_name_texture = nil
                    if i == 1 then
                        _character_name_texture = makuai.Rep_T_UI_Makuai_Character_Name_L
                    else
                        _character_name_texture = makuai.Rep_T_UI_Makuai_Character_Name_R
                    end


                    if _character_name_texture:IsValid() then
                        -- print("Character name texture has been located")
                        local _material_instance = _character_name_texture.Brush.ResourceObject
                        local _texture = _material_instance:K2_GetTextureParameterValue(FName("MainTexture"))

                        local name = helper.getCharacterNameFromTexture(_texture)
                        -- print(string.format("Found Character Name: %s", name))
                        local text_name = nil

                        if helper.tableContains(helper.character_codes, name) then
                            text_name = helper.character_codes[name]
                        else
                            text_name = "???"
                        end

                        _player_info.TB_PlayerID:SetRawText(string.upper(text_name), true)
                    end
                end
            end
        end
    end)
end)

NotifyOnNewObject("/Script/Polaris.PolarisUMGResultNew", function(result)
    if config.streamer_mode then
        result:SetRenderOpacity(0.0)

        ExecuteWithDelay(60, function()

            result:SetRenderOpacity(1)
            local _rematch_menu = result.WBP_UI_Result_New_RematchMenu
            for i = 1, 2 do
                local _player_list = nil
                if i == 1 then
                    _player_list = _rematch_menu.WBP_UI_Result_New_RematchMenu_List_1p
                else
                    _player_list = _rematch_menu.WBP_UI_Result_New_RematchMenu_List_2p
                end

                local _icon_texture = _player_list.Rep_T_UI_CMN_Character_Icon_List
                local _material_instance = _icon_texture.Brush.ResourceObject

                local texture = _material_instance:K2_GetTextureParameterValue(FName("MainTexture"))

                local name = helper.getCharacterNameFromTexture(texture)
                -- print(string.format("Found Character Name: %s", name))
                local text_name = nil

                if helper.tableContains(helper.character_codes, name) then
                    text_name = helper.character_codes[name]
                else
                    text_name = "???"
                end

                _player_list:SetName(string.upper(text_name))
            end
        end)
    end
end)

-- Rank Progess bar that moves up and down if you win or lose a match.
NotifyOnNewObject("/Script/Polaris.PolarisUMGBattleResultRank", function(rankProgress)
    if config.hide_progress_bar then
        rankProgress:SetRenderOpacity(0)
    else
        rankProgress:SetRenderOpacity(1)
    end
end)


-- When your promotion is successful, the rank pop-up that happens.
NotifyOnNewObject("/Script/Polaris.PolarisUMGBattleResult", function(promotion)
    if config.hide_rank_promotions then
        -- print("Rank promotion hidden..")
        promotion:SetRenderOpacity(0)
    else
        promotion:SetRenderOpacity(1)
    end
end)

-- Text that pops up saying "PROMOTION CHANCE" or "DEMOTION CHANCE"
NotifyOnNewObject("/Script/Polaris.PolarisUMGAppearStage", function(notceMatch)
    if config.hide_rank_prompts then
        -- print("Notce Match information hidden..")
        notceMatch:SetRenderOpacity(0)
    else
        notceMatch:SetRenderOpacity(1)
    end
end)

-- When your promotion is successful, the rank pop-up that happens.
NotifyOnNewObject("/Script/Polaris.PolarisUMGMainMenu", function(main_menu)
    print("Run hide code for main menu")
    ExecuteWithDelay(500, function()
        -- hideItemsMainMenu(main_menu)
    end)
end)

-- When your promotion is successful, the rank pop-up that happens.
NotifyOnNewObject("/Script/Polaris.PolarisUMGHudGauge", function()
    if not hudRegistered then

        hudRegistered = true
        RegisterHook("/Game/UI/Widget/HUD/S2/WBP_UI_HUD_Player_S2.WBP_UI_HUD_Player_S2_C:SetZoneChainVisibility", function()
            onBattleHudUpdate()
        end)
    end

    return true
end)
