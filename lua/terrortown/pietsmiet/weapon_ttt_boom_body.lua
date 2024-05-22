if SERVER then
    util.PrecacheSound("pietsmiet/das_ist_fake.mp3")

    hook.Add("TTT2BoomBodyOnExplode", "PietSmietBoomBodyFake", function(rag)
        sound.Play("pietsmiet/das_ist_fake.mp3", rag:GetPos())
    end)

    function PIETSMIET:PrimaryAttack()
        local ply = self:GetOwner()

        ply:EmitSound("pietsmiet/das_ist_fake.mp3", 70, 100, 0.25)
    end
end
