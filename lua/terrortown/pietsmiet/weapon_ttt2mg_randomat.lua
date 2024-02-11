if CLIENT then
    PIETSMIET.PrintName = "ps_randomat"
end

PIETSMIET.InLoadoutFor = { ROLE_DETECTIVE }

if SERVER then
    function PIETSMIET:PrimaryAttack()
        print("this would be a sound")
    end
end
