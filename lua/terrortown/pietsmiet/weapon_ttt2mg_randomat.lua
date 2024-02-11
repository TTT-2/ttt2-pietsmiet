if CLIENT then
    PIETSMIET.Name = "ps_randomat"
end

PIETSMIET.InLoadoutFor = {ROLE_DETECTIVE}

if SERVER then
    function PIETSMIET:PrimaryAttack()
        -- add custom sound here
    end
end
