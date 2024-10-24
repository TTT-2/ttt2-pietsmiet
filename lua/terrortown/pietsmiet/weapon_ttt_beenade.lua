if CLIENT then
    PIETSMIET.PrintName = "ps_beenade"
    PIETSMIET.Icon = "vgui/ttt/pietsmiet/icon_jay.png"
end

if SERVER then
    util.PrecacheSound("pietsmiet/spinnen.mp3")

    hook.Add("OnEntityCreated", "PietSmietBeenadeSpinnen", function(ent)
        if ent:GetClass() ~= "ttt_beenade_proj" then
            return
        end

        ent:EmitSound("pietsmiet/spinnen.mp3")
    end)
end
