-- LUA SETTINGS #START
disableAll = false -- Disables Tranquility, regardless of settings.

streamerMode = true -- Disables players names from showing.

hidePlayerRanks = false -- Hides player ranks from showing. (Hiding ranks will also hide the promotion texts that appears underneath it)

hidePlayerPlates = false -- Hides player plates so they're not shown.

hideTekkenPower = true -- Hides Tekken Power from showing.

hideProgressBar = true -- Hide Rank Progress bar.

hidePromotions = false -- Hide rank promotions if they occur.

hideRankPrompts = true -- Hides information that says you're near Promotion/Demotion.

disableMakuaiInfo = false -- Hides the Makuai stats all together.

panelOffset = 285 -- The distance that the panel will be moved to when rank information is hidden.
-- LUA SETTINGS #END

WidgetLayoutLibrary = nil
PolarisHud = nil
PlayerHud = nil
rankUpdated = false
defaultPanelPos = {
    ["X"] = 625,
    ["Y"] = 362,
}
character_codeTable = {
    ["aml"] = "Jun",
    ["ant"] = "Jin",
    ["bbn"] = "Raven",
    ["bsn"] = "Steve",
    ["cat"] = "Azucena",
    ["ccn"] = "Jack-8",
    ["cht"] = "Bryan",
    ["cml"] = "Yoshimitsu",
    ["crw"] = "Zafina",
    ["ctr"] = "Claudio",
    ["der"] = "Asuka",
    ["ghp"] = "Leo",
    ["grf"] = "Paul",
    ["grl"] = "Kazuya",
    ["hms"] = "Lili",
    ["hrs"] = "Shaheen",
    ["jly"] = "Leroy",
    ["kal"] = "Nina",
    ["klw"] = "Feng",
    ["kmd"] = "Dragunov",
    ["lon"] = "Victor",
    ["lzd"] = "Lars",
    ["mnt"] = "Alisa",
    ["pgn"] = "King",
    ["pig"] = "Law",
    ["rat"] = "Xiaoyu",
    ["rbt"] = "Kuma",
    ["snk"] = "Hwoarang",
    ["swl"] = "Devil Jin",
    ["ttr"] = "Panda",
    ["wlf"] = "Lee",
    ["zbr"] = "Reina",
}

function table_contains(tbl, x)
    found = false
    for _, v in pairs(tbl) do
        if _ == x then
            found = true
        end
    end
    return found
end



-- Main Update function
function OnBattleHudUpdate()

    if disableAll then
        return
    end

    -- We make sure game references for the hud are up to date before we do any changes.
    UpdateGameReferences()

    -- Stop execution if we fail to get any of the required hud elements.
    if not PlayerHud:IsValid() then error("Player Hud cannot be found, Tranquility cannot make changes!") end
    if not WidgetLayoutLibrary:IsValid() then error("WidgetLayoutLibrary not valid, Tranquility cannot make changes!\n") end

    -- Loop logic for P1 and P2
    for i = 1, 2 do
        local playerIndex = i - 1

        -- Code to hide Player Names
        if streamerMode then
            AdjustFighterNames(playerIndex)
        end

        -- Code to hide Tekken Power.
        if hideTekkenPower then
            AdjustTekkenPowerVisbility(playerIndex)
        end

        -- Code to hide player ranks.
        if hidePlayerRanks then
            AdjustRankVisibility(playerIndex)
        end

        -- Hide Player Plates.
        AdjustPlayerPlates(playerIndex)
    end
end

function UpdateGameReferences()
    WidgetLayoutLibrary = StaticFindObject("/Script/UMG.Default__WidgetLayoutLibrary")

    PolarisHud = FindFirstOf("WBP_UI_HUD_C")
    PlayerHud = PolarisHud.ref_player
end

function GetCharacterNameFromTexture(textureToUse)
    name = string.sub(textureToUse:GetFullName(), -3)
    return name
end

function AdjustPlayerPlates(player)

    local shogoPanel = nil

    if player == 0 then
        shogoPanel = PlayerHud.WBP_UI_ShogoPanel_L
    else
        shogoPanel = PlayerHud.WBP_UI_ShogoPanel_R
    end

    if hidePlayerPlates then
        shogoPanel:SetVisibility(2)
    else
        if hidePlayerRanks then
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
end

function AdjustFighterNames(player)
    PlayerHud:SetFighterNameTexture2(player, nil)

    local charImage = nil
    if player == 0 then
        charImage = PlayerHud.Rep_T_UI_HUD_CH_ICON_L
    else
        charImage = PlayerHud.Rep_T_UI_HUD_CH_ICON_R
    end

    -- local charSel = string.sub(charImage.Brush.ResourceObject:GetFullName(), -3)
    local charSel = GetCharacterNameFromTexture(charImage.Brush.ResourceObject)
    local name_texture = StaticFindObject("/Game/UI/Rep_Texture/HUD_Character_Name/T_UI_HUD_Character_Name_" .. charSel .. ".T_UI_HUD_Character_Name_" .. charSel)
    PlayerHud:SetFighterNameTexture(player, name_texture)

    -- Add a slight delay to make sure it's probably catching the Ghost Icon.
    ExecuteWithDelay(100, function()
        local ghosticon = nil
        if player == 0 then
            ghosticon = PlayerHud.Ghost_Icon_L
        else
            ghosticon = PlayerHud.Gh_Icon_R
        end

        if ghosticon:IsValid() then
            ghosticon:SetVisibility(2)
        end
    end)
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
    if player == 0 then
        rnkRoot = PlayerHud.RNK_Root_L
    else
        rnkRoot = PlayerHud.RNK_Root_R
    end

    rnkRoot:SetVisibility(2)
end


RegisterHook("/Game/UI/Widget/HUD/WBP_UI_HUD_Player.WBP_UI_HUD_Player_C:SetZoneChainVisibility", function()
    OnBattleHudUpdate()
end)

NotifyOnNewObject("/Script/Polaris.PolarisUMGMakuai", function(makuai)
    if disableAll then
        return
    end

    ExecuteWithDelay(500, function()
        -- print("Executed asynchronously after a 1 second delay\n")

        for i = 1, 2 do
            local playerInfo = nil
            if i == 1 then
                playerInfo = makuai.WBP_UI_PlayerInfo_L
            else
                playerInfo = makuai.WBP_UI_PlayerInfo_R
            end

            if disableMakuaiInfo then
                playerInfo:SetVisibility(2)
            else
                if hidePlayerRanks then
                    playerInfo.Rep_T_UI_CMN_RNK_S:SetVisibility(2)
                end

                if hideTekkenPower then
                    playerInfo.BG_TekkenPower:SetVisibility(2)
                    playerInfo.TB_TekkenPower:SetVisibility(2)
                    playerInfo.TB_TekkenPower_data:SetVisibility(2)
                end

                if streamerMode then

                    local charNameTexture = nil
                    if i == 1 then
                        charNameTexture = makuai.Rep_T_UI_Makuai_Character_Name_L
                    else
                        charNameTexture = makuai.Rep_T_UI_Makuai_Character_Name_R
                    end


                    if charNameTexture:IsValid() then
                        -- print("Character name texture has been located")
                        local materialInstance = charNameTexture.Brush.ResourceObject
                        local texture = materialInstance:K2_GetTextureParameterValue(FName("MainTexture"))
                        
                        local name = GetCharacterNameFromTexture(texture)
                        -- print(string.format("Found Character Name: %s", name))
                        local text_name = nil

                        if table_contains(character_codeTable, name) then
                            text_name = character_codeTable[name]
                        else
                            text_name = "???"
                        end

                        playerInfo.TB_PlayerID:SetRawText(string.upper(text_name), true)
                    else
                        -- print("No character name found.")
                    end

                    -- local characterName = character_codeTable[GetCharacterNameFromTexture(charNameTexture)]
                    -- print(string.format("Replaced Char Name with: %s", characterName))

                    -- playerInfo.TB_PlayerID:SetRawText("TEKKEN PLAYER", true)
                end
            end
        end
    end)
end)

NotifyOnNewObject("/Script/Polaris.PolarisUMGResultNew", function(result)

    if disableAll then
        return
    end

    if streamerMode then

        -- print("Test execution of UMG edits.")
        result:SetRenderOpacity(0.0)

        ExecuteWithDelay(60, function()

            result:SetRenderOpacity(1)
            local rematchMenu = result.WBP_UI_Result_New_RematchMenu
            for i = 1, 2 do
                local playerList = nil
                if i == 1 then
                    playerList = rematchMenu.WBP_UI_Result_New_RematchMenu_List_1p
                else
                    playerList = rematchMenu.WBP_UI_Result_New_RematchMenu_List_2p
                end

                local iconTexture = playerList.Rep_T_UI_CMN_Character_Icon_List
                local materialInstance = iconTexture.Brush.ResourceObject

                local texture = materialInstance:K2_GetTextureParameterValue(FName("MainTexture"))

                local name = GetCharacterNameFromTexture(texture)
                print(string.format("Found Character Name: %s", name))
                local text_name = nil

                if table_contains(character_codeTable, name) then
                    text_name = character_codeTable[name]
                else
                    text_name = "???"
                end

                playerList:SetName(string.upper(text_name))
            end
        end)
    end
end)

-- Rank Progess bar that moves up and down if you win or lose a match.
NotifyOnNewObject("/Script/Polaris.PolarisUMGBattleResultRank", function(rankProgress)

    if hideProgressBar and not disableAll then
        rankProgress:SetRenderOpacity(0)
    else
        rankProgress:SetRenderOpacity(1)
    end
end)


-- When your promotion is successful, the rank pop-up that happens.
NotifyOnNewObject("/Script/Polaris.PolarisUMGBattleResult", function(promotion)

    if hidePromotions and not disableAll then
        -- print("Rank promotion hidden..")
        promotion:SetRenderOpacity(0)
    else
        promotion:SetRenderOpacity(1)
    end
end)

-- Text that pops up saying "PROMOTION CHANCE" or "DEMOTION CHANCE"
NotifyOnNewObject("/Script/Polaris.PolarisUMGAppearStage", function(notceMatch)
    if hideRankPrompts and not disableAll then
        -- print("Notce Match information hidden..")
        notceMatch:SetRenderOpacity(0)
    else
        notceMatch:SetRenderOpacity(1)
    end
end)

-- RegisterHook("/Game/UI/Widget/Makuai/WBP_UI_Makuai.WBP_UI_Makuai_C:PlayAnimIn", function()

--[[
RegisterHook("/Game/UI/Widget/HUD/WBP_UI_HUD_Player.WBP_UI_HUD_Player_C:SetRank", function(Context, side, rank, change)

    if not rankUpdated then
        rankUpdated = true

        print(string.format("Player Side: %s Rank: %s\n", side:get(), rank:get()))

        if Context:get() then
            -- print("Attempting to replace side.")
            -- Context:get():SetRank(side:get(), rank:get(), 0)
        end
    end
end)
]]


RegisterHook("/Script/Engine.PlayerController:ClientRestart", function()
    rankUpdated = false
end)

function PrintTest()
    --[[
    local PolarisTAMFunctionLibrary = StaticFindObject("/Script/Polaris.Default__PolarisTAMFunctionLibrary")
    if PolarisTAMFunctionLibrary:IsValid() then
        local playerName = PolarisTAMFunctionLibrary:GetMyPlayerName()
        print(playerName:ToString())
    end
    ]]

    local rankProgress = FindFirstOf("WBP_UI_Result_RankProgress_C")
    if rankProgress:IsValid() then
        -- print("Rank progress found.")
        rankProgress:SetRenderOpacity(1)
    else
        -- print("No find!")
    end

    --[[
    local player = FindFirstOf("WBP_UI_HUD_C")
    local ref_player = player.ref_player
    if ref_player:IsValid() then
        print("Rank change supposed to happen")
        ref_player:SetRank(0, 22, 0)
    end
    ]]
end

-- For testing updates.
-- RegisterKeyBind(Key.F8, PrintTest)