-- Here you can adjust the settings for Tranquility v1.2.0!

local _mod_config = {
    -- Disables Tranquility, regardless of settings.
    disable_everything = false,

    -- Disables players names from showing.
    streamer_mode = true,

    -- Hides player ranks from showing.
    -- NOTE: Hiding ranks will also hide the promotion texts that appears underneath it.
    hide_player_ranks = true,

    -- Hides player plates so they're not shown.
    -- NOTE: These are the panels shown in Battle, not at the start of the match, check "hide_makuai_info" for that!
    hide_player_panels = false,

    -- The distance that the panel will be moved to when rank information is hidden.
    panel_offset = 285,

    -- Hides Tekken Power from showing.
    hide_tekken_power = true,

    -- Hide Rank Progress bar.
    hide_progress_bar = true,

    -- If a rank promotions occurs, it won't show it.
    -- NOTE: This does not hide the "This is the first time you've reached this rank". Blame the Tekken Team for that. :(
    hide_rank_promotions = false,

    -- Hides information that says you're near Promotion/Demotion.
    hide_rank_prompts = true,

    -- Hides Win Streaks that appear at the bottom of the screen.
    hide_win_streaks = true,

    -- Hides the Makuai stats all together.
    -- NOTE: This in particular refers to the information that comes up during the "GET READY FOR THE NEXT BATTLE" screen.
    hide_makuai_info = false,
}

return _mod_config