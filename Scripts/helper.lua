local tranquility_helper = {
    default_panel_position = {
        ["X"] = 625,
        ["Y"] = 362,
    },

    character_codes = {
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
    },
}

function tranquility_helper.tableContains(tbl, x)
    found = false
    for _, v in pairs(tbl) do
        if _ == x then
            found = true
        end
    end
    return found
end

function tranquility_helper.getCharacterNameFromTexture(texture)
    name = string.sub(texture:GetFullName(), -3)
    return name
end

return tranquility_helper