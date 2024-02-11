CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "submenu_server_addons_pietsmiet_title"

function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_pietsmiet_settings")

    form:MakeHelp({
        label = "help_pietsmiet",
    })

    form:MakeCheckBox({
        label = "label_ttt2_ps_name_replacement",
        serverConvar = "ttt2_ps_name_replacement",
    })

    form:MakeCheckBox({
        label = "label_ttt2_ps_icon_replacement",
        serverConvar = "ttt2_ps_icon_replacement",
    })

    form:MakeCheckBox({
        label = "label_ttt2_ps_loadout_replacement",
        serverConvar = "ttt2_ps_loadout_replacement",
    })

    form:MakeCheckBox({
        label = "label_ttt2_ps_attack_replacement",
        serverConvar = "ttt2_ps_attack_replacement",
    })
end
