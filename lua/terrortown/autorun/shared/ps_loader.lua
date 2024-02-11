local pietSmietReplacements = {}

local cvEnableNameReplacement =
    CreateConVar("ttt2_ps_name_replacement", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED })
local cvEnableIconReplacement =
    CreateConVar("ttt2_ps_icon_replacement", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED })
local cvEnableLoadoutReplacement = CreateConVar(
    "ttt2_ps_loadout_replacement",
    "1",
    { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }
)
local cvEnableAttackReplacement = CreateConVar(
    "ttt2_ps_attack_replacement",
    "1",
    { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED }
)

local function OnInitialization(class, path, name)
    class.type = name
    class.base = class.base or "base_pietsmiet"

    Dev(1, "Added TTT2 pietsmiet file: ", path, name)
end

local function UpdateWeapons()
    for name, class in pairs(pietSmietReplacements) do
        local wep = weapons.GetStored(name)
            or scripted_ents.GetStored(name)
            or items.GetStored(name)

        if not wep then
            continue
        end

        if class.PrintName then
            if cvEnableNameReplacement:GetBool() then
                class.OldPrintName = wep.EquipMenuData and wep.EquipMenuData.name or wep.PrintName

                wep.PrintName = class.PrintName

                if wep.EquipMenuData then
                    wep.EquipMenuData.name = class.PrintName
                end
            elseif class.OldPrintName then
                wep.PrintName = class.OldPrintName

                if wep.EquipMenuData then
                    wep.EquipMenuData.name = class.OldPrintName
                end
            end
        end

        if class.Icon then
            if cvEnableIconReplacement:GetBool() then
                class.OldIcon = wep.Icon
                class.OldIconMaterial = wep.iconMaterial

                wep.Icon = class.Icon
                wep.iconMaterial = Material(class.Icon)
            elseif class.OldIcon and class.OldIconMaterial then
                wep.Icon = class.OldIcon
                wep.iconMaterial = class.OldIconMaterial
            end
        end

        if class.InLoadoutFor then
            if cvEnableLoadoutReplacement:GetBool() then
                class.OldInLoadoutFor = wep.InLoadoutFor

                wep.InLoadoutFor = class.InLoadoutFor
            elseif class.OldInLoadoutFor then
                wep.InLoadoutFor = class.OldInLoadoutFor
            end
        end

        if class.PrimaryAttack then
            if cvEnableAttackReplacement:GetBool() and not class.OldPrimaryAttach then
                class.OldPrimaryAttach = wep.PrimaryAttack

                wep.PrimaryAttack = function(slf)
                    class.PrimaryAttack(slf)
                    class.OldPrimaryAttach(slf)
                end
            elseif class.OldPrimaryAttach then
                wep.PrimaryAttack = class.OldPrimaryAttach

                class.OldPrimaryAttach = nil
            end
        end

        if class.SecondaryAttack then
            if cvEnableAttackReplacement:GetBool() and not class.OldSecondaryAttack then
                class.OldSecondaryAttack = wep.SecondaryAttack

                wep.SecondaryAttack = function(slf)
                    class.SecondaryAttack(slf)
                    class.OldSecondaryAttack(slf)
                end
            elseif class.OldSecondaryAttack then
                wep.SecondaryAttack = class.OldSecondaryAttack

                class.OldSecondaryAttack = nil
            end
        end
    end
end

hook.Add("TTT2FinishedLoading", "PSClassBuiler", function()
    pietSmietReplacements = classbuilder.BuildFromFolder(
        "terrortown/pietsmiet/",
        SHARED_FILE,
        "PIETSMIET", -- class scope
        OnInitialization, -- on class loaded
        false -- should inherit
    )

    UpdateWeapons()
end)

if SERVER then
    util.AddNetworkString("TTT2PSUpdatedConvar")

    cvars.AddChangeCallback(cvEnableNameReplacement:GetName(), function(name, old, new)
        net.Start("TTT2PSUpdatedConvar")
        net.Broadcast()

        UpdateWeapons()
    end)
    cvars.AddChangeCallback(cvEnableIconReplacement:GetName(), function(name, old, new)
        net.Start("TTT2PSUpdatedConvar")
        net.Broadcast()

        UpdateWeapons()
    end)
    cvars.AddChangeCallback(cvEnableLoadoutReplacement:GetName(), function(name, old, new)
        net.Start("TTT2PSUpdatedConvar")
        net.Broadcast()

        UpdateWeapons()
    end)
    cvars.AddChangeCallback(cvEnableAttackReplacement:GetName(), function(name, old, new)
        net.Start("TTT2PSUpdatedConvar")
        net.Broadcast()

        UpdateWeapons()
    end)
end

if CLIENT then
    net.Receive("TTT2PSUpdatedConvar", function()
        UpdateWeapons()
    end)
end
