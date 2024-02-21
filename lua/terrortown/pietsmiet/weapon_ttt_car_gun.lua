if CLIENT then
    PIETSMIET.PrintName = "ps_car_gun"
end

if SERVER then
    util.PrecacheSound("pietsmiet/sportswaggon.wav")

    function PIETSMIET:PrimaryAttack()
        local ply = self:GetOwner()

        timer.Simple(0.6, function()
            if not IsValid(ply) then
                return
            end

            ply:EmitSound("pietsmiet/sportswaggon.wav")
        end)
    end
end
