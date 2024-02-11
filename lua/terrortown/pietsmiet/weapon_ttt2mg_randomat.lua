if CLIENT then
    PIETSMIET.PrintName = "ps_randomat"
end

PIETSMIET.InLoadoutFor = { ROLE_DETECTIVE }

if SERVER then
    util.PrecacheSound("pietsmiet/exekutiv.wav")

    function PIETSMIET:PrimaryAttack()
        self:GetOwner():EmitSound("pietsmiet/exekutiv.wav")
    end
end
