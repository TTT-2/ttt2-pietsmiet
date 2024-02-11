local function OnInitialization(class, path, name)
    class.type = name
    class.base = class.base or "base_pietsmiet"

    _G["PIETSMIET_" .. string.upper(name)] = name

    Dev(1, "Added TTT2 pietsmiet file: ", path, name)
end

local function ShouldInherit(t, base)
    return t.base ~= t.type
end

hook.Add("TTT2FinishedLoading", "PSClassBuiler", function()
    pietSmietReplacements = classbuilder.BuildFromFolder(
        "terrortown/pietsmiet/",
        SHARED_FILE,
        "PIETSMIET", -- class scope
        OnInitialization, -- on class loaded
        true, -- should inherit
        ShouldInherit -- special inheritance check
    )

    for name, class in pairs(pietSmietReplacements) do
        local wep = weapons.GetStored(name) or items.GetStored(name)

        if not wep then continue end

        if class.name then
            class.OldName = wep.Name

            wep.Name = class.Name
        end

        if class.Icon then
            class.OldIcon = wep.Icon
            class.OldIconMaterial = wep.iconMaterial

            wep.Icon = class.Icon
            wep.iconMaterial = Material(class.Icon)
        end

        if class.InLoadoutFor then
            class.OldInLoadoutFor = wep.InLoadoutFor

            wep.InLoadoutFor = class.InLoadoutFor
        end

        if class.PrimaryAttack and wep.PrimaryAttack then
            class.OldPrimaryAttach = wep.PrimaryAttack

            wep.PrimaryAttack = function(slf) -- is this the correct reference here?
                class.OldPrimaryAttach(slf)
                class.PrimaryAttack(slf)
            end
        end

        if class.SecondaryAttack and wep.SecondaryAttack then
            class.OldSecondaryAttack = wep.SecondaryAttack

            wep.PrimaryAttack = function(slf) -- is this the correct reference here?
                class.OldSecondaryAttack(slf)
                class.SecondaryAttack(slf)
            end
        end
    end
end)
