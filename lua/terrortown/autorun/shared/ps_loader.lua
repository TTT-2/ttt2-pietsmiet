local function OnInitialization(class, path, name)
    class.type = name
    class.base = class.base or "base_pietsmiet"

    _G["PIETSMIET_" .. string.upper(name)] = name

    Dev(1, "Added TTT2 pietsmiet file: ", path, name)
end

hook.Add("TTT2FinishedLoading", "PSClassBuiler", function()
    pietSmietReplacements = classbuilder.BuildFromFolder(
        "terrortown/pietsmiet/",
        SHARED_FILE,
        "PIETSMIET", -- class scope
        OnInitialization, -- on class loaded
        false -- should inherit
    )

    for name, class in pairs(pietSmietReplacements) do
        local wep = weapons.GetStored(name) or ents.GetStored(name) or items.GetStored(name)

        if not wep then
            continue
        end

        if CLIENT and class.PrintName then
            class.OldPrintName = wep.EquipMenuData.name

            wep.EquipMenuData.name = class.PrintName
            wep.PrintName = class.PrintName
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

            wep.PrimaryAttack = function(slf)
                class.PrimaryAttack(slf)
                class.OldPrimaryAttach(slf)
            end
        end

        if class.SecondaryAttack and wep.SecondaryAttack then
            class.OldSecondaryAttack = wep.SecondaryAttack

            wep.PrimaryAttack = function(slf)
                class.SecondaryAttack(slf)
                class.OldSecondaryAttack(slf)
            end
        end
    end
end)
