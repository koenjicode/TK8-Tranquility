-- Here you can adjust the settings for Tranquility v1.2.0!

local _mod_config = {
    -- Disables Tranquility, regardless of settings (Added to Tranquility with v.1.1.1).
    disable_everything = true,

    -- Disables player names from showing.
    -- This does NOT apply the changes on the other player's client, the other player will still be able to see your name as these changes are purely client side (like everything else in this mod!).
    streamer_mode = false,

    -- Hides player ranks from showing.
    -- Hiding ranks will also hide the promotion texts that appears underneath it.
    hide_player_ranks = true,

    -- Hides player plates so they're not shown.
    -- These are the panels shown in Battle, not at the start of the match, if you want to hide the Loading Panels, set "hide_makuai_info" to true.
    hide_player_panels = false,

    -- Adjusts the distance of the Player Panels from their default position if rank information is hidden.
    -- Default: 285, I wouldn't really change this, but the option is there you know?
    panel_offset = 285,

    -- Hides Tekken Prowess/Power from showing.
    -- This will also hide prowess in the loading screen.
    hide_tekken_power = false,

    -- Hide Rank Progress bar.
    hide_progress_bar = false,

    -- If a rank promotion occurs, it won't show it (You've been promoted to this rank etc;).
    -- This does NOT hide the "This is the first time you've reached this rank". Blame the Tekken Team for that. :(
    hide_rank_promotions = false,

    -- Hides information that says you're near Promotion/Demotion.
    -- This does NOT hide the text underneath ranks. To hide that set "hide_player_ranks" to true.
    hide_rank_prompts = true,

    -- Hides Win Streaks that appear at the bottom of the screen (Added to Tranquility with v.1.2.0).
    hide_win_streaks = true,

    -- Hides Player Stats info on the "GET READY FOR THE NEXT BATTLE" screen.
    hide_makuai_info = false,
}

return _mod_config