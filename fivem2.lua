-- | PECA Menu |
local blockInput = false
local DeveloperMode = false
local inputBlockActive = true -- Starts when menu is open
local getNearbyPlayerInfo = false -- Gets Joining player info

-- | Player |
local tog = true
local togg = false
local playerId = PlayerId()
local playerPedId = PlayerPedId()

-- | Weapon |
local noReload = false
local quickReload = false
local infiniteAmmo = false

-- | Run Speed |
local RunSpeedSpeed = 2.0
local FastRunning = false

-- | Super Jump |
local superJump = false
local fixedJumpZ = 5.0 -- Jump Height

-- | Main |
local godMdRunning = false
local staminaLoop = false
local hungerRunning = false
local thirstRunning = false
local coords = GetEntityCoords(playerPedId)

local SuperPunchEnabled = false

-- Noclip state + speed
local noclipRunning = false
local noclipSpeed = 2.0 -- adjust to your liking (move speed)


-- Menu Setup
local MenuSize = vec2(650, 350)
local screenW, screenH = GetActiveScreenResolution()
local MenuStartCoords = vec2(screenW / 2 - MenuSize.x / 2, screenH / 2 - MenuSize.y / 2) -- Center menu

local TabsBarWidth = 130.0
local SectionsPadding = 12
local MachoPaneGap = 10

-- Sections count for 3-column tabs
local SectionsCount = 3
local SectionChildWidth = MenuSize.x - TabsBarWidth
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

-- 3-column sections coordinates (for VEHICLE, EVENTS, EXPLOITS)
local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1) + (EachSectionWidth * 0), SectionsPadding + MachoPaneGap)
local SectionOneEnd   = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + (EachSectionWidth * 1), SectionsPadding + MachoPaneGap)
local SectionTwoEnd   = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local SectionThreeStart = vec2(TabsBarWidth + (SectionsPadding * 3) + (EachSectionWidth * 2), SectionsPadding + MachoPaneGap)
local SectionThreeEnd   = vec2(SectionThreeStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

-- Sections count for 2-column tabs (PLAYER and SETTINGS)
local TwoSectionsCount = 2
local TwoEachSectionWidth = (SectionChildWidth - (SectionsPadding * (TwoSectionsCount + 1))) / TwoSectionsCount

local TwoSectionOneStart = vec2(TabsBarWidth + SectionsPadding, SectionsPadding + MachoPaneGap)
local TwoSectionOneEnd = vec2(TwoSectionOneStart.x + TwoEachSectionWidth, MenuSize.y - SectionsPadding)

local TwoSectionTwoStart = vec2(TwoSectionOneEnd.x + SectionsPadding, SectionsPadding + MachoPaneGap)
local TwoSectionTwoEnd = vec2(TwoSectionTwoStart.x + TwoEachSectionWidth, MenuSize.y - SectionsPadding)

-- Fiveguard Bypass (exactly your original LoadBypasses)
local function FiveGuardBypass()
    Wait(1500)

    MachoMenuNotification("Notification", "Bypass Loading.")

    local function DetectFiveGuard()
        local function ResourceFileExists(resourceName, fileName)
            local file = LoadResourceFile(resourceName, fileName)
            return file ~= nil
        end

        local fiveGuardFile = "ai_module_fg-obfuscated.lua"
        local numResources = GetNumResources()

        for i = 0, numResources - 1 do
            local resourceName = GetResourceByFindIndex(i)
            if ResourceFileExists(resourceName, fiveGuardFile) then
                return true, resourceName
            end
        end

        return false, nil
    end

    Wait(100)

    local found, resourceName = DetectFiveGuard()
    if found and resourceName then
        MachoResourceStop(resourceName)
    end

    Wait(100)

    MachoMenuNotification("Notification", "Finalizing.")

    Wait(500)

    MachoMenuNotification("Notification", "Bypassed.")

end

-- Shared helper (kept as in your original snippet)
local function ResourceFileExists(resourceName, fileName)
    local file = LoadResourceFile(resourceName, fileName)
    return file ~= nil
end

-- Menu button: original anti-cheat scan code (kept as close to original as possible)
local function LoadBypasses()
    local function notify(fmt, ...)
        MachoMenuNotification("NOTIFICATION", string.format(fmt, ...))
    end

    local function ResourceFileExists_local(resourceNameTwo, fileNameTwo)
        local file = LoadResourceFile(resourceNameTwo, fileNameTwo)
        return file ~= nil
    end

    local numResources = GetNumResources()

    local acFiles = {
        { name = "ai_module_fg-obfuscated.lua", acName = "FiveGuard" },
    }

    for i = 0, numResources - 1 do
        local resourceName  = GetResourceByFindIndex(i)
        local resourceLower = string.lower(resourceName)

        for _, acFile in ipairs(acFiles) do
            if ResourceFileExists_local(resourceName, acFile.name) then
                notify("Anti-Cheat: %s", acFile.acName)
                AntiCheat = acFile.acName

                -- If FiveGuard is found, run the bypass loader (calls your original FiveGuardBypass)
                if acFile.acName == "FiveGuard" then
                    FiveGuardBypass()
                end

                return resourceName, acFile.acName
            end
        end

        local friendly = nil
        if resourceLower:sub(1, 7) == "reaperv" then
            friendly = "ReaperV4"
        elseif resourceLower:sub(1, 4) == "fini" then
            friendly = "FiniAC"
        elseif resourceLower:sub(1, 7) == "chubsac" then
            friendly = "ChubsAC"
        elseif resourceLower:sub(1, 6) == "fireac" then
            friendly = "FireAC"
        elseif resourceLower:sub(1, 7) == "drillac" then
            friendly = "DrillAC" -- Server: Drill UK Reborn uses ElectronAC
        elseif resourceLower:sub(-7) == "eshield" then
            friendly = "WaveShield"
        elseif resourceLower:sub(-10) == "Likizao-AC" then
            friendly = "Likizao-AC"
        elseif resourceLower:sub(1, 5) == "greek" then
            friendly = "GreekAC"
        elseif resourceLower == "pac" then
            friendly = "PhoenixAC"
        elseif resourceLower == "electronac" then
            friendly = "ElectronAC"
        end

        if friendly then
            notify("Anti-Cheat: %s", friendly)
            AntiCheat = friendly

            -- If ReaperV4 is found, run the bypass loader (calls your original LoadBypasses)
            if friendly == "ReaperV4" then
                MachoMenuNotification("Notification", "Bypass Loading.")
                
                Wait(500)

                MachoMenuNotification("Notification", "Finalizing.")

                Wait(500)

                MachoMenuNotification("Notification", "Bypassed.")
            end

            -- If FiniAC is found, run the bypass loader (calls your original LoadBypasses)
            if friendly == "FiniAC" then
                MachoMenuNotification("Notification", "Bypass Loading.")
                
                Wait(500)

                MachoMenuNotification("Notification", "Finalizing.")

                Wait(500)

                MachoMenuNotification("Notification", "Bypassed.")
            end

            -- If ChubsAC is found, run the bypass loader (calls your original LoadBypasses)
            if friendly == "ChubsAC" then
                MachoMenuNotification("Notification", "Bypass Loading.")
                
                Wait(500)

                MachoMenuNotification("Notification", "Finalizing.")

                Wait(500)

                MachoMenuNotification("Notification", "Bypassed.")
            end

            -- If FireAC is found, run the bypass loader (calls your original LoadBypasses)
            if friendly == "FireAC" then
                MachoMenuNotification("Notification", "Bypass Loading.")
                
                Wait(500)

                MachoMenuNotification("Notification", "Finalizing.")

                Wait(500)

                MachoMenuNotification("Notification", "Bypassed.")
            end

            -- If DrillAC is found, run the bypass loader (calls your original LoadBypasses)
            if friendly == "DrillAC" then
                MachoMenuNotification("Notification", "Bypass Loading.")
                
                Wait(500)

                MachoMenuNotification("Notification", "Finalizing.")

                Wait(500)

                MachoMenuNotification("Notification", "Bypassed.")
            end

            -- If WaveShield is found, run the bypass loader (calls your original LoadBypasses)
            if friendly == "WaveShield" then
                MachoMenuNotification("Notification", "Bypass Loading.")
                
                Wait(500)

                MachoMenuNotification("Notification", "Finalizing.")

                Wait(500)

                MachoMenuNotification("Notification", "Bypassed.")
            end

            -- If Likizao-AC is found, run the bypass loader (calls your original LoadBypasses)
            if friendly == "Likizao-AC" then
                MachoMenuNotification("Notification", "Bypass Loading.")
                
                Wait(500)

                MachoMenuNotification("Notification", "Finalizing.")

                Wait(500)

                MachoMenuNotification("Notification", "Bypassed.")
            end

            -- If GreekAC is found, run the bypass loader (calls your original LoadBypasses)
            if friendly == "GreekAC" then
                MachoMenuNotification("Notification", "Bypass Loading.")
                
                Wait(500)

                MachoMenuNotification("Notification", "Finalizing.")

                Wait(500)

                MachoMenuNotification("Notification", "Bypassed.")
            end

            -- If GreekAC is found, run the bypass loader (calls your original LoadBypasses)
            if friendly == "PhoenixAC" then
                MachoMenuNotification("Notification", "Bypass Loading.")
                
                Wait(500)

                MachoMenuNotification("Notification", "Finalizing.")

                Wait(500)

                MachoMenuNotification("Notification", "Bypassed.")
            end

            -- If GreekAC is found, run the bypass loader (calls your original LoadBypasses)
            if friendly == "ElectronAC" then
                MachoMenuNotification("Notification", "Bypass Loading.")
                
                Wait(500)

                MachoMenuNotification("Notification", "Finalizing.")

                Wait(500)

                MachoMenuNotification("Notification", "Bypassed.")
            end

            return resourceName, friendly
        end
    end

    notify("No Anti-Cheat found")
    return nil, nil
end

LoadBypasses()






-- Function to stop a resource safely
local function StartTargetResource(resourceName)
    local state = GetResourceState(resourceName)
    if state == "started" then
        if type(MachoResourceStop) == "function" then
            MachoResourceStart(resourceName)
        elseif type(StopResource) == "function" then
            StartResource(resourceName)
        end
        MachoMenuNotification("Notification", string.format("Resource '%s' has been started.", resourceName))
    end
end

-- Main button logic
local function StartLogs()
    -- List of known log / anti-cheat resources
    local targets = {
     -- Start Logs

     -- "monitor",
        "ak47_monitor",
        "petris-discordlogs",
        "snag_discord_logging",
        "discordlink",
        "scrp-idlogs",
        "JD_logsV3",
        "JD_logs",
        "fivem-logs",
        "qb-logs",
        "esx_logs",
        "logs",

      -- Start Identifier Logging
      -- Logs all player identifiers (Steam, Discord, IP, etc.) to a database upon connection.
        "FiveMIdentifierLogger",

      -- Start Screenshots
        "screenshot",
        "screenshot-basic"
    }

    local startedCount = 0

    for _, name in ipairs(targets) do
        local found = false

        if type(CheckResource) == "function" and CheckResource(name) then
            found = true
        else
            local ok, state = pcall(GetResourceState, name)
            if ok and state == "started" then
                found = true
            end
        end

        if found then
            StartTargetResource(name)
            startedCount = startedCount + 1
            Wait(200)
        end
    end

    if startedCount == 0 then
        MachoMenuNotification("Notification", "No logging resources found to start.")
    else
        MachoMenuNotification("Notification", string.format("Started %d resources.", startedCount))
    end
end

-- Function to stop a resource safely
local function StopTargetResource(resourceName)
    local state = GetResourceState(resourceName)
    if state == "started" then
        if type(MachoResourceStop) == "function" then
            MachoResourceStop(resourceName)
        elseif type(StopResource) == "function" then
            StopResource(resourceName)
        end
        MachoMenuNotification("Notification", string.format("Resource '%s' has been stopped.", resourceName))
    end
end

-- Main button logic
local function StopLogs()
    -- List of known log / anti-cheat resources
    local targets = {
      -- Disable Logs
     -- "monitor",
        "ak47_monitor",
        "petris-discordlogs",
        "snag_discord_logging",
        "discordlink",
        "scrp-idlogs",
        "JD_logsV3",
        "JD_logs",
        "fm-logs",
        "fivem-logs",
        "qb-logs",
        "esx_logs",
        "logs",

      -- Stop Identifier Logging
      -- Logs all player identifiers (Steam, Discord, IP, etc.) to a database upon connection.
        "FiveMIdentifierLogger",

      -- Disable Screenshots
        "screenshot",
        "screenshot-basic"
    }

    local stoppedCount = 0

    for _, name in ipairs(targets) do
        local found = false

        if type(CheckResource) == "function" and CheckResource(name) then
            found = true
        else
            local ok, state = pcall(GetResourceState, name)
            if ok and state == "started" then
                found = true
            end
        end

        if found then
            StopTargetResource(name)
            stoppedCount = stoppedCount + 1
            Wait(200)
        end
    end

    if stoppedCount == 0 then
        MachoMenuNotification("Notification", "No resources found to stop")
    else
        MachoMenuNotification("Notification", string.format("Stopped %d resources.", stoppedCount))
    end
end

StopLogs()






-- Client-sided spectate variables
local Spectating = false
local TargetPlayer = nil

-- Client-sided Function to spectate a player
function SpectatePlayer(id)
    local player = GetPlayerPed(id)
    if Spectating then
        MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        RequestCollisionAtCoord(GetEntityCoords(]] .. player .. [[))
        NetworkSetInSpectatorMode(true, ]] .. player .. [[)
    ]])
    else
        MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        NetworkSetInSpectatorMode(false, ]] .. player .. [[)
        TargetPlayer = nil
    ]])
    end
end


-- NoClip

local function toggleNoClip(state)
    noclipRunning = state

    if state then
        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()

            while noclipRunning do
                
                Citizen.Wait(0)
                
                ShowHudComponentThisFrame(14)

                -- Get camera and player coords
                local coords = GetEntityCoords(playerPed)
                local camRot = GetGameplayCamRot(2)

                -- Freeze & hide player
                SetEntityVisible(playerPed, false)
                SetPedCurrentWeaponVisible(playerPed, false, true)
                FreezeEntityPosition(playerPed, true)
                SetEntityCollision(playerPed, false, false)
                SetEntityInvincible(playerPed, true)

                -- Calculate direction vectors
                local pitch = math.rad(camRot.x)
                local yaw = math.rad(camRot.z)

                local forward = vector3(
                    -math.sin(yaw) * math.cos(pitch),
                     math.cos(yaw) * math.cos(pitch),
                     math.sin(pitch)
                )
                local right = vector3(math.cos(yaw), math.sin(yaw), 0)
                local movement = vector3(0, 0, 0)

                -- WASD + shift/ctrl movement
                if IsControlPressed(0, 32) then movement = movement + forward end
                if IsControlPressed(0, 33) then movement = movement - forward end
                if IsControlPressed(0, 34) then movement = movement - right end
                if IsControlPressed(0, 35) then movement = movement + right end
                if IsControlPressed(0, 21) then movement = movement + vector3(0,0,1) end
                if IsControlPressed(0, 36) then movement = movement - vector3(0,0,1) end

                -- Apply speed
                movement = movement * noclipSpeed
                local newCoords = coords + movement

                -- Move player
                SetEntityCoordsNoOffset(playerPed, newCoords.x, newCoords.y, newCoords.z, true, true, true)
            end

            -- Reset player when disabling
            SetEntityInvincible(playerPed, false)
            FreezeEntityPosition(playerPed, false)
            SetEntityCollision(playerPed, true, true)
            SetEntityVisible(playerPed, true)
            SetPedCurrentWeaponVisible(playerPed, true, true)
        end)
    else
        noclipRunning = false
    end
end

-- NoClip End




-- Super Strength


-- Super Strength End



-- Spinbot

-- Code Here

-- Spinbot End


-- Recovery
local function AllDatMoney()
    local ItemAmount = MachoMenuGetInputbox(MoneyInputBox)

    if ItemAmount and tonumber(ItemAmount) then
        local Amount = tonumber(ItemAmount)

        local resourceActions = {

            ["ak47_drugmanager"] = function()
                MachoInjectResource2(3, (CheckResource("ReaperV4") and "ReaperV4") or (CheckResource("monitor") and "monitor") or "any", [[
                    Wait(1)
                    TriggerServerEvent('ak47_drugmanager:pickedupitem', "money", "money", ]] .. Amount .. [[)
                ]])
            end,

            ["ak47_drugmanagerv2"] = function()
                MachoInjectResource2(3, (CheckResource("ReaperV4") and "ReaperV4") or (CheckResource("monitor") and "monitor") or "any", [[
                    Wait(1)
                    TriggerServerEvent(
                "ak47_drugmanagerv2:shop:buy",
                "PECA_Api",
                {
                    buyprice = 0,
                    currency = "cash",
                    label = "money",
                    name = "money",
                    sellprice = 0
                },
               ]] .. Amount .. [[
            )
                ]])
            end,

            ["ak47_qb_drugmanagerv2"] = function()
                MachoInjectResource2(3, (CheckResource("ReaperV4") and "ReaperV4") or (CheckResource("monitor") and "monitor") or "any", [[
                    Wait(1)
                    TriggerServerEvent(
                "ak47_qb_drugmanagerv2:shop:buy",
                "PECA_Api",
                {
                    buyprice = 0,
                    currency = "cash",
                    label = "money",
                    name = "money",
                    sellprice = 0
                },
               ]] .. Amount .. [[
            )
                ]])
            end,

            ["angelicxs-CivilianJobs"] = function()
                MachoInjectResource2(3, (CheckResource("ReaperV4") and "ReaperV4") or (CheckResource("monitor") and "monitor") or "any", [[
                    Wait(1)
                    TriggerServerEvent('angelicxs-CivilianJobs:Server:GainItem', "cash", ]] .. Amount .. [[)
                ]])
            end,

            ["codewave-lashes-phone"] = function()
                MachoInjectResource2(3, (CheckResource("ReaperV4") and "ReaperV4") or (CheckResource("monitor") and "monitor") or "any", [[
                    Wait(1)
                    TriggerServerEvent('delivery:giveRewardlashes', ]] .. Amount .. [[)
                ]])
            end,

            ["codewave-nails-phone"] = function()
                MachoInjectResource2(3, (CheckResource("ReaperV4") and "ReaperV4") or (CheckResource("monitor") and "monitor") or "any", [[
                    Wait(1)
                    TriggerServerEvent('delivery:giveRewardnails', ]] .. Amount .. [[)
                ]])
            end,

            ["codewave-caps-client-phone"] = function()
                MachoInjectResource2(3, (CheckResource("ReaperV4") and "ReaperV4") or (CheckResource("monitor") and "monitor") or "any", [[
                    Wait(1)
                    TriggerServerEvent('delivery:giveRewardCaps', ]] .. Amount .. [[)
                ]])
            end,

            ["codewave-wigs-v3-phone"] = function()
                MachoInjectResource2(3, (CheckResource("ReaperV4") and "ReaperV4") or (CheckResource("monitor") and "monitor") or "any", [[
                    Wait(1)
                    TriggerServerEvent('delivery:giveRewardWigss', ]] .. Amount .. [[)
                ]])
            end,

            ["codewave-icebox-phone"] = function()
                MachoInjectResource2(3, (CheckResource("ReaperV4") and "ReaperV4") or (CheckResource("monitor") and "monitor") or "any", [[
                    Wait(1)
                    TriggerServerEvent('delivery:giveRewardiceboxs', ]] .. Amount .. [[)
                ]])
            end,

            ["codewave-sneaker-phone"] = function()
                MachoInjectResource2(3, (CheckResource("ReaperV4") and "ReaperV4") or (CheckResource("monitor") and "monitor") or "any", [[
                    Wait(1)
                    TriggerServerEvent('delivery:giveRewardShoes', ]] .. Amount .. [[)
                ]])
            end,

            ["codewave-handbag-phone"] = function()
                MachoInjectResource2(3, (CheckResource("ReaperV4") and "ReaperV4") or (CheckResource("monitor") and "monitor") or "any", [[
                    Wait(1)
                    TriggerServerEvent('delivery:giveRewardhandbags', ]] .. Amount .. [[)
                ]])
            end,
        }

        local ResourceFound = false
        for ResourceName, action in pairs(resourceActions) do
            if GetResourceState(ResourceName) == "started" then
                action()
                MachoMenuNotification("Notification", ResourceName)
                ResourceFound = true
                break
            end
        end

        if not ResourceFound then
            MachoMenuNotification("Notification", "No resources were found.")
        end
    else
        MachoMenuNotification("Notification", "Invalid Input Error: please provide a valid numeric value.")
    end
end


local function fastRun(state)
    FastRunning = state

    if state then
        -- Start thread only when turning on
        
        Citizen.CreateThread(function()
            while FastRunning do  
                
                Citizen.Wait(0)

                local speed = RunSpeedSpeed

                MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
                -- Set melee damage multiplier
            local function DawrjatjsfAW()
                SetRunSprintMultiplierForPlayer(]] .. playerId .. [[, ]] .. speed .. [[)
                SetPedMoveRateOverride(]] .. playerPedId .. [[, ]] .. speed .. [[)
            end

            DawrjatjsfAW()

            ]])
            end
            MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
            local function DawrjatjsfAW()
                SetRunSprintMultiplierForPlayer(]] .. playerId .. [[, 1.0)
                SetPedMoveRateOverride(]] .. playerPedId .. [[, 1.0)
            end

            DawrjatjsfAW()

        ]])
        end)
    else
        MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        -- If turning off manually without waiting for thread, reset immediately
        local function DawrjatjsfAW()
                SetRunSprintMultiplierForPlayer(]] .. playerId .. [[, 1.0)
                SetPedMoveRateOverride(]] .. playerPedId .. [[, 1.0)
        end

        DawrjatjsfAW()

    ]])
    end
end

-- Function to enable or disable super jump


-- Hunger Loop
local function HungerRunning(state)
    hungerRunning = state
    while hungerRunning do  -- Run only when enabled
        Citizen.Wait(100)  -- Run every 100ms to check player's Hunger status
        MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        local function DawrjatjsfAW()
            TriggerEvent('esx_status:set', 'hunger', 1000000) -- ESX Test 1
  	        TriggerServerEvent('consumables:server:addHunger', math.random(5,10)) -- Test
        end

        DawrjatjsfAW()

        ]])
    end
end

-- Thirst Loop
local function ThirstRunning(state)
    thirstRunning = state
    while thirstRunning do  -- Run only when enabled
        Citizen.Wait(100)  -- Run every 100ms to check player's Thirst status
        MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
  	    local function DawrjatjsfAW()
            TriggerEvent('esx_status:set', 'thirst', 1000000) -- ESX Test 1
  	        TriggerServerEvent('consumables:server:addThirst', math.random(5,10)) -- Test
        end

        DawrjatjsfAW()

        ]])
    end
end

-- Semi God
local function semigod(state)
    semigodRunning = state
    while semigodRunning do  -- Run only when enabled
        Wait(500)  -- Run every 500ms to check player's health status
MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
    local function DawrjatjsfAW()
        if GetEntityHealth(PlayerPedId()) < 200 then
               SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId())) 
            SetEntityHealth(PlayerPedId(), 200)
         SetPedArmour(PlayerPedId(), 100)
        end
    end

    DawrjatjsfAW()

        ]])
    end
end

-- GodMode
function GodMDRunning(state)
    godMdRunning = state
    Citizen.CreateThread(function()
        while godMdRunning do
            Wait(500)  -- Check every 500ms
            -- Enable or disable god mode
            SetEntityInvincible(playerPed, godMdRunning)
            SetEntityProofs(playerPed, godMdRunning, godMdRunning, godMdRunning, godMdRunning, godMdRunning, godMdRunning, godMdRunning, godMdRunning)
            SetPedCanRagdoll(playerPed, not godMdRunning)
        end
    end)
end


-- Stamina toggle function
local function StaminaLoop(state)
    staminaLoop = state

    Citizen.CreateThread(function()
        while staminaLoop do
            Citizen.Wait(0)
                MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
                local function DawrjatjsfAW()
                    ResetPlayerStamina(PlayerId())
                end

                DawrjatjsfAW()

                ]])
        end

        -- Reset player state when disabling noclip

    end)
end


-- Weapons
-- Infinite Ammo
local function InfiniteAmmo(state)
    infiniteAmmo = state
    while infiniteAmmo do  -- Run only when enabled
        Wait(0)  -- Run every 0ms
        if infiniteAmmo then
            MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
            local function DawrjatjsfAW()
                SetPedInfiniteAmmoClip(PlayerPedId(), true)
            end

            DawrjatjsfAW()

            ]])
        end
    end
    MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
    local function DawrjatjsfAW()
        SetPedInfiniteAmmoClip(PlayerPedId(), false)
    end

    DawrjatjsfAW()

    ]])
end

-- No Reload
local function NoReload(state)
    noReload = state
    while noReload do  -- Run only when enabled
        Wait(0)  -- Run every 0ms
MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
    local function DawrjatjsfAW()
        local playerPed = PlayerPedId()
        local weapon = GetSelectedPedWeapon(playerPed)
        if weapon ~= GetHashKey("WEAPON_UNARMED") then
            SetPedAmmo(PlayerPedId(), weapon, 999)
        end
    end

    DawrjatjsfAW()

        ]])
    end
    MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
    local function DawrjatjsfAW()
    if weapon ~= GetHashKey("WEAPON_UNARMED") then
    local playerPed = PlayerPedId()
    local weapon = GetSelectedPedWeapon(playerPed)
    SetPedAmmo(PlayerPedId(), weapon, 0)
        end
    end

    DawrjatjsfAW()

    ]])
end

-- Quick Reload
local function QuickReload(state)
    quickReload = state
    while quickReload do  -- Run only when enabled
        Wait(0)  -- Run every 0ms
MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
    local function DawrjatjsfAW()
        if IsPedReloading(PlayerPedId()) then
                ClearPedTasks(PlayerPedId())
                ClearPedTasksImmediately(PlayerPedId())
        end
    end

            DawrjatjsfAW()

        ]])
    end
end



-- Weapons End

-- Autorepair
local autoRepair = false
local function Autorepair(state)
    autoRepair = state
    Citizen.CreateThread(function()
        while autoRepair do
            Wait(0)  -- Check every 0ms
           MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        local function RepairVehicle()
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh and veh ~= 0 then
                SetVehicleFixed(veh)
                SetVehicleDeformationFixed(veh)
                SetVehicleDirtLevel(veh, 0.0)
            end
        end

        RepairVehicle()
    ]])
        end
    end)
end





-- Single-thread, toggle-safe FPS booster
local fpsBoosterEnabled = false
local fpsBoosterThreadActive = false
local fpsBoosterThread = nil


-- How often to run heavy cleanup (ms)
local CLEANUP_INTERVAL = 45000

-- One-shot reset for the frame we disable on
local function resetTweaksForThisFrame()
    -- Density back to normal
    SetPedDensityMultiplierThisFrame(1.0)
    SetVehicleDensityMultiplierThisFrame(1.0)
    SetRandomVehicleDensityMultiplierThisFrame(1.0)
    SetParkedVehicleDensityMultiplierThisFrame(1.0)

    -- If you were disabling decals per-frame, re-enable by simply not calling it.
    -- Avoid touching cascade shadow settings here for stability.
end

-- Public toggle: call FpsBooster(true/false)
function FpsBooster(state)
    if state then
        if fpsBoosterThreadActive then
            -- already running, just mark enabled
            fpsBoosterEnabled = true
            return
        end

        fpsBoosterEnabled = true
        fpsBoosterThreadActive = true

        fpsBoosterThread = CreateThread(function()
            local lastCleanup = GetGameTimer()

            -- main loop
            while fpsBoosterThreadActive do
                if fpsBoosterEnabled then
                    -- Per-frame light tweaks (safe + stable)
                    -- NOTE: multipliers must be set every frame to stick
                    SetPedDensityMultiplierThisFrame(0.6)
                    SetVehicleDensityMultiplierThisFrame(0.6)
                    SetRandomVehicleDensityMultiplierThisFrame(0.6)
                    SetParkedVehicleDensityMultiplierThisFrame(0.6)

                    -- Optionally disable decal rendering while boosting
                    -- (comment this out if you see visual artifacts)
                    -- SetDisableDecalRenderingThisFrame()

                    -- Timed heavier cleanup
                    local now = GetGameTimer()
                    if now - lastCleanup >= CLEANUP_INTERVAL then
                        lastCleanup = now


                        SetTimecycleModifier("cinema")
                        SetExtraTimecycleModifier("cinema")
                        SetForcePedFootstepsTracks(false)
                        SetForceVehicleTrails(false)

                        -- Recompute ped/coords right before cleanup (ped can change)
                        local ped = PlayerPedId()
                        local coords = GetEntityCoords(ped)

                        -- UI / cache cleanup (safe at low frequency)
                        ClearAllBrokenGlass()
                        ClearAllHelpMessages()
                        LeaderboardsReadClearAll()
                        ClearBrief()
                        ClearGpsFlags()
                        ClearPrints()
                        ClearSmallPrints()
                        ClearReplayStats()
                        LeaderboardsClearCacheData()

                        -- World cleanup
                        ClearFocus()
                        -- ClearHdArea() can cause small stream hitches; keep but infrequent
                        ClearHdArea()

                        -- Ped cleanup
                        ClearPedBloodDamage(ped)
                        ClearPedWetness(ped)
                        ClearPedEnvDirt(ped)
                        ResetPedVisibleDamage(ped)

                        -- FX cleanup
                        RemoveParticleFxInRange(coords, 250.0)
                    end

                    -- Per-frame yield
                    Wait(0)
                else
                    -- Disabled but thread still alive -> sleep cheaply until re-enabled or stopped
                    Wait(250)
                end
            end

            -- thread exit (after fpsBoosterThreadActive = false)
            fpsBoosterThread = nil
        end)

    else
        -- Disable and stop thread entirely
        fpsBoosterEnabled = false
        resetTweaksForThisFrame()

        if fpsBoosterThreadActive then
            -- tell the loop to exit on next tick, then mark not active
            fpsBoosterThreadActive = false
        end
    end
end

-- Block input function
local function BlockInput(state)
    blockInput = state
    
    Citizen.CreateThread(function()
        while blockInput do
            Citizen.Wait(0)

            -- Block movement
            DisableControlAction(0, 30, true) -- Move left/right
            DisableControlAction(0, 31, true) -- Move forward/back
            DisableControlAction(0, 21, true) -- Sprint
            DisableControlAction(0, 22, true) -- Jump

            -- Block melee
            DisableControlAction(0, 140, true) -- Light punch
            DisableControlAction(0, 141, true) -- Heavy punch
            DisableControlAction(0, 142, true) -- Alt punch

            -- Block weapon select
            DisableControlAction(0, 37, true) -- Select Weapon
            DisableControlAction(0, 44, true) -- Cover

            -- Block aim/shoot
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 24, true) -- Attack

            -- NEW: Block head/camera movement
            DisableControlAction(0, 1, true)  -- Look left/right
            DisableControlAction(0, 2, true)  -- Look up/down

            if IsPedPerformingMeleeAction(playerPed) then
                ClearPedTasksImmediately(playerPed)
            end
        end
    end)
end

-- Unified Smart + Self Revive
local function SmartRevive()
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)

    -- Play UI feedback sound
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

    -- List of known revive systems and their events
    local reviveSystems = {
        {resource = "wasabi_ambulance", events = {"wasabi_ambulance:revive"}},
        {resource = "esx_ambulancejob", events = {"esx_ambulancejob:revive"}},
        {resource = "qbx_medical", events = {"qbx_medical:client:playerRevived"}},
        {resource = "ars_ambulancejob", events = {
            function() TriggerEvent("ars_ambulancejob:healPlayer", {revive = true}) end,
            function() TriggerEvent("ars_ambulancejob:healPlayer", {heal = true}) end
        }},
        {resource = "ak47_qb_ambulancejob", events = {
            "ak47_qb_ambulancejob:revive",
            "ak47_qb_ambulancejob:skellyfix"
        }},
        {resource = "hospital", events = {"hospital:client:Revive"}},
        {resource = "ak47_ambulancejob", events = {
            "ak47_ambulancejob:revive",
            "ak47_ambulancejob:skellyfix"
        }},
        {resource = "visn_are", events = {"visn_are:resetHealthBuffer"}}
    }

    local triggered = false

    -- Try all known revive systems first
    for _, system in ipairs(reviveSystems) do
        if GetResourceState(system.resource) == "started" then
            for _, evt in ipairs(system.events) do
                if type(evt) == "string" then
                    TriggerEvent(evt)
                    if DeveloperMode then
                        MachoMenuNotification("Event", evt)
                        print("[SmartSelfRevive] Triggered event: " .. evt)
                    end
                elseif type(evt) == "function" then
                    evt()
                    if DeveloperMode then
                        MachoMenuNotification("Event", system.resource)
                        print("[SmartSelfRevive] Triggered function event in resource: " .. system.resource)
                    end
                end
            end
            triggered = true
            break -- stop after the first working system
        end
    end

    -- Only perform client-side revive if no known system was found
    if not triggered then
        NetworkResurrectLocalPlayer(pos.x, pos.y, pos.z, true, true, false)
        SetEntityHealth(playerPed, 200)
        ClearPedTasksImmediately(playerPed)
        ResetEntityAlpha(playerPed)

        if DeveloperMode then
            print("[SmartSelfRevive] No known revive system running. Client-side revive executed.")
            MachoMenuNotification("SmartRevive", "")
        end
    else
        if DeveloperMode then
            print("[SmartSelfRevive] Known revive system triggered. No client-side revive needed.")
        end
    end
end


-- Get Player Join Info
local function GetNearbyPlayerInfo(state)
    getNearbyPlayerInfo = state

    if not getNearbyPlayerInfo then
        return
    end

    Citizen.CreateThread(function()
        local myPlayerId = PlayerId()
        local myServerId = GetPlayerServerId(myPlayerId)
        local myName = GetPlayerName(myPlayerId)

        print(("Client started. My ID=%s, ServerID=%s, Name=%s"):format(myPlayerId, myServerId, myName))
        MachoMenuNotification(myName, "ID: " .. myServerId)

        local loggedPlayers = {} -- track players we already logged

        while getNearbyPlayerInfo do
            Citizen.Wait(0) -- check every 3 seconds

            local myPed = PlayerPedId()
            local myCoords = GetEntityCoords(myPed)

            for i = 0, 255 do
                if NetworkIsPlayerActive(i) and i ~= myPlayerId then
                    local serverId = GetPlayerServerId(i)

                    -- only log once per serverId
                    if not loggedPlayers[serverId] then
                        loggedPlayers[serverId] = true

                        local ped = GetPlayerPed(i)
                        local coords = GetEntityCoords(ped)
                        local distance = #(myCoords - coords)
                        local name = GetPlayerName(i)

                        print(("Player Found -> ClientID=%s, ServerID=%s, Name=%s"):format(i, serverId, name))
                        MachoMenuNotification(name, "ID: " .. serverId)

                        if distance < 20.0 then
                            print(("  >> Nearby! Distance=%.1f"):format(distance))
                        end
                    end
                end
            end
        end
    end)
end



-- Fixed full client-side freecam / features (cleaned: removed Launch & Teleport Vehicle)
local __Freecam = __Freecam or false

function Freecam(state)
    freeCam = state

    local resourceName = (CheckResource("core") and "core") or (CheckResource("es_extended") and "es_extended") or (CheckResource("qb-core") and "qb-core") or (CheckResource("monitor") and "monitor") or "any"

    if state then
        if not __Freecam then
            __Freecam = true

            MachoInjectResource(resourceName, [[
-- Single persistent context to avoid repeated injection and infinite threads
g_FreecamContext = g_FreecamContext or {}
local C = g_FreecamContext

C.initialized = C.initialized or false
C.featureEnabled = true
C.isFreecamActive = C.isFreecamActive or false
C.freecamHandle = C.freecamHandle or nil
C.targetCoords = nil
C.targetEntity = nil
C.currentFeatureIndex = C.currentFeatureIndex or 1
C.pedsToSpawn = C.pedsToSpawn or { "s_m_m_movalien_01", "u_m_y_zombie_01", "s_m_y_blackops_01", "csb_abigail", "a_c_coyote" }
C.currentPedIndex = C.currentPedIndex or 1
C.Unloaded = C.Unloaded or false

-- FEATURES (Launch Vehicle & Teleport Vehicle removed)
-- Force reset features table to remove old and reset
C.Features = {
    "Look-Around",
    "Teleport",       -- player only
    "Spawn Ped",
    "Delete Entity",
    "Fling Entity",
    "Flip Vehicle",
    "Blank",
    "Blank",
    "Vehicle Troll"
}

-- helper drawText
local function drawText(content, x, y, options)
    options = options or {}
    SetTextFont(options.font or 4)
    SetTextScale(0.0, options.scale or 0.3)
    SetTextColour((options.color and options.color[1]) or 255, (options.color and options.color[2]) or 255, (options.color and options.color[3]) or 255, (options.color and options.color[4]) or 255)
    SetTextOutline()
    if options.shadow then SetTextDropShadow(2, 0, 0, 0, 255) end
    SetTextCentre(true)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(content)
    EndTextCommandDisplayText(x, y)
end

-- DRAW UI
local function drawThread()
    while C.isFreecamActive do
        Wait(0)
        drawText("•", 0.5, 0.485, {font = 4, scale = 0.5, color = {128,0,128,0}})

        local ui = { x = 0.5, y = 0.75, lineHeight = 0.03, maxVisible = 7, colors = { text = {245, 245, 245, 120}, selected = {52, 152, 219, 255} } }
        local numFeatures = #C.Features
        local startIdx, endIdx = 1, numFeatures

        if numFeatures > ui.maxVisible then
            startIdx = math.max(1, C.currentFeatureIndex - math.floor(ui.maxVisible / 2))
            endIdx = math.min(numFeatures, startIdx + ui.maxVisible - 1)
            if endIdx == numFeatures then
                startIdx = numFeatures - ui.maxVisible + 1
            end
        end

        drawText(("%d/%d"):format(C.currentFeatureIndex, numFeatures), ui.x, ui.y - 0.035, {scale = 0.25, color = {128,0,128,0}})

        local displayCount = 0
        for i = startIdx, endIdx do
            local featureName = C.Features[i]
            local isSelected = (i == C.currentFeatureIndex)
            local lineY = ui.y + (displayCount * ui.lineHeight)
            if isSelected then
                drawText(("[ %s ]"):format(featureName), ui.x, lineY, {scale = 0.32, color = ui.colors.selected, shadow = true})
            else
                drawText(featureName, ui.x, lineY, {scale = 0.28, color = ui.colors.text})
            end
            displayCount = displayCount + 1
        end

        local debugLine = "Target: " .. tostring(C.targetEntity or "nil")
        if C.targetCoords then
            debugLine = debugLine .. " | Coords: " .. string.format("%.1f,%.1f,%.1f", C.targetCoords.x, C.targetCoords.y, C.targetCoords.z)
        end
        drawText(debugLine, 0.5, ui.y + ui.maxVisible * ui.lineHeight + 0.02, {scale = 0.22, color = {200,200,200,180}})
    end
end

-- LOGIC: feature activation
local function logicThread()
    while C.isFreecamActive do
        Wait(0)
        if IsDisabledControlJustPressed(0, 241) then
            C.currentFeatureIndex = (C.currentFeatureIndex - 2 + #C.Features) % #C.Features + 1
        elseif IsDisabledControlJustPressed(0, 242) then
            C.currentFeatureIndex = (C.currentFeatureIndex % #C.Features) + 1
        end

        if IsDisabledControlJustPressed(0, 24) then
            local currentFeature = C.Features[C.currentFeatureIndex]

            -- TELEPORT (player only)
            if currentFeature == "Teleport" and C.targetCoords then
                local ped = PlayerPedId()
                local _, z = GetGroundZFor_3dCoord(C.targetCoords.x, C.targetCoords.y, C.targetCoords.z + 1.0, false)
                SetEntityCoords(ped, C.targetCoords.x, C.targetCoords.y, z and z + 1.0 or C.targetCoords.z, false, false, false, true)

            -- SPAWN PED
            elseif currentFeature == "Spawn Ped" and C.targetCoords then
                local model = C.pedsToSpawn[C.currentPedIndex]
                CreateThread(function()
                    local modelHash = GetHashKey(model)
                    RequestModel(modelHash)
                    local timeout = 2000
                    while not HasModelLoaded(modelHash) and timeout > 0 do
                        Wait(100)
                        timeout = timeout - 100
                    end
                    if HasModelLoaded(modelHash) then
                        local _, gz = GetGroundZFor_3dCoord(C.targetCoords.x, C.targetCoords.y, C.targetCoords.z, false)
                        local spawnPos = vector3(C.targetCoords.x, C.targetCoords.y, gz and gz + 1.0 or C.targetCoords.z)
                        local newPed = CreatePed(4, modelHash, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, true)
                        SetModelAsNoLongerNeeded(modelHash)
                        TaskStandStill(newPed, -1)
                        C.currentPedIndex = (C.currentPedIndex % #C.pedsToSpawn) + 1
                    end
                end)

            -- DELETE ENTITY
            elseif currentFeature == "Delete Entity" and C.targetEntity and DoesEntityExist(C.targetEntity) then
                local ent = C.targetEntity
                if ent ~= PlayerPedId() then
                    if NetworkGetEntityIsNetworked(ent) then
                        local reqTimeout = 500
                        NetworkRequestControlOfEntity(ent)
                        while not NetworkHasControlOfEntity(ent) and reqTimeout > 0 do
                            NetworkRequestControlOfEntity(ent)
                            Wait(10)
                            reqTimeout = reqTimeout - 10
                        end
                    end
                    SetEntityAsMissionEntity(ent, true, true)
                    if IsEntityAVehicle(ent) then
                        DeleteVehicle(ent)
                    elseif IsEntityAPed(ent) then
                        if not IsPedAPlayer(ent) then
                            DeletePed(ent)
                        else
                            ClearPedTasksImmediately(ent)
                        end
                    else
                        DeleteEntity(ent)
                    end
                end

            -- FLING ENTITY
elseif currentFeature == "Fling Entity" and C.targetEntity and (IsEntityAPed(C.targetEntity) or IsEntityAVehicle(C.targetEntity)) then
    local ent = C.targetEntity
    if ent and DoesEntityExist(ent) and not (IsEntityAPed(ent) and IsPedAPlayer(ent)) then
        
        -- Request control safely without blocking main thread
        Citizen.CreateThread(function()
            if NetworkGetEntityIsNetworked(ent) then
                local reqTimeout = 500
                NetworkRequestControlOfEntity(ent)
                local startTime = GetGameTimer()
                while not NetworkHasControlOfEntity(ent) and (GetGameTimer() - startTime) < reqTimeout do
                    NetworkRequestControlOfEntity(ent)
                    Citizen.Wait(10)
                end
            end

            -- Calculate random fling force
            local fx = (math.random() - 0.5) * 200.0
            local fy = (math.random() - 0.5) * 200.0
            local fz = math.random(50, 150)

            -- Apply force
            ApplyForceToEntity(ent, 1, fx, fy, fz, 0.0, 0.0, 0.0, 0, true, true, true, true, true)

            Citizen.Wait(30) -- small wait to let physics update

            -- Ensure entity moves if stuck
            local vx, vy, vz = table.unpack(GetEntityVelocity(ent))
            if math.abs(vx) < 0.1 and math.abs(vy) < 0.1 and math.abs(vz) < 0.1 then
                SetEntityVelocity(ent, fx * 0.1, fy * 0.1, fz * 0.1)
            end
        end)
    end

            -- FLIP VEHICLE
            elseif currentFeature == "Flip Vehicle" and C.targetEntity and IsEntityAVehicle(C.targetEntity) then
                SetVehicleOnGroundProperly(C.targetEntity)

            -- Blank
            elseif currentFeature == "Blank" and C.targetEntity and IsEntityAVehicle(C.targetEntity) then
            elseif currentFeature == "Blank" and C.targetEntity and IsEntityAVehicle(C.targetEntity) then

            -- Vehicle Troll
            elseif currentFeature == "Vehicle Troll" and C.targetEntity and IsEntityAVehicle(C.targetEntity) then
                local actions = {
                    function(veh) SetVehicleTyreBurst(veh, math.random(0, 5), false, 1000.0) end,
                    function(veh) SetVehicleDoorOpen(veh, math.random(0, 5), false, false) end,
                    function(veh) SetVehicleEngineOn(veh, not IsVehicleEngineOn(veh), false, true) end,
                    function(veh) SetVehicleLights(veh, math.random(0, 2)) end,
                    function(veh) StartVehicleHorn(veh, 1000, "HELDDOWN", false) end
                }
                local randomAction = actions[math.random(#actions)]
                randomAction(C.targetEntity)
            end
        end
    end
end

-- CAMERA movement thread (unchanged)
local function cameraThread()
    local baseSpeed, boostSpeed, slowSpeed = 1.0, 9.0, 0.1
    local mouseSensitivity = 7.5
    local function clamp(val, minv, maxv) return math.max(minv, math.min(maxv, val)) end
    local function rotToDir(rot)
        local rX, rZ = math.rad(rot.x), math.rad(rot.z)
        return vector3(-math.sin(rZ)*math.cos(rX), math.cos(rZ)*math.cos(rX), math.sin(rX))
    end

    while C.isFreecamActive do
        Wait(0)
        if not C.freecamHandle or not DoesCamExist(C.freecamHandle) then Wait(10) goto continue end
        local camPos, camRotRaw = GetCamCoord(C.freecamHandle), GetCamRot(C.freecamHandle, 2)
        local camRot = { x = camRotRaw.x, y = camRotRaw.y, z = camRotRaw.z }
        local direction = rotToDir(camRot)
        local right = vector3(direction.y, -direction.x, 0)
        local speed = baseSpeed
        if IsDisabledControlPressed(0, 21) then speed = boostSpeed end
        if IsDisabledControlPressed(0, 19) then speed = slowSpeed end
        if IsDisabledControlPressed(0, 32) then camPos = camPos + direction * speed end
        if IsDisabledControlPressed(0, 33) then camPos = camPos - direction * speed end
        if IsDisabledControlPressed(0, 34) then camPos = camPos - right * speed end
        if IsDisabledControlPressed(0, 35) then camPos = camPos + right * speed end
        if IsDisabledControlPressed(0, 22) then camPos = camPos + vector3(0, 0, 1.0) * speed end
        if IsDisabledControlPressed(0, 36) then camPos = camPos - vector3(0, 0, 1.0) * speed end

        local mX, mY = GetControlNormal(0,1)*mouseSensitivity, GetControlNormal(0,2)*mouseSensitivity
        camRot.x = clamp(camRot.x - mY, -89.0, 89.0)
        camRot.z = camRot.z - mX

        SetCamCoord(C.freecamHandle, camPos.x, camPos.y, camPos.z)
        SetCamRot(C.freecamHandle, camRot.x, camRot.y, camRot.z, 2)
        SetFocusPosAndVel(camPos.x, camPos.y, camPos.z, 0.0, 0.0, 0.0)

        local ray = StartShapeTestRay(camPos.x, camPos.y, camPos.z, camPos.x + direction.x * 1000.0, camPos.y + direction.y * 1000.0, camPos.z + direction.z * 1000.0, -1, PlayerPedId(), 7)
        local _, hit, coords, _, entity = GetShapeTestResult(ray)
        if hit then C.targetCoords, C.targetEntity = coords, entity else C.targetCoords, C.targetEntity = nil, nil end
        ::continue::
    end
end

-- start & stop wrappers unchanged
function C.startFreecam()
    if C.isFreecamActive then return end
    C.isFreecamActive = true
    _G.isFreecamActive = true
    FreezeEntityPosition(PlayerPedId(), true)
    local startPos, startRot, startFov = GetGameplayCamCoord(), GetGameplayCamRot(2), GetGameplayCamFov()
    C.freecamHandle = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", startPos.x, startPos.y, startPos.z, startRot.x, startRot.y, startRot.z, startFov, true, 2)
    if not DoesCamExist(C.freecamHandle) then C.isFreecamActive = false _G.isFreecamActive = false return end
    RenderScriptCams(true, false, 0, true, true)
    SetCamActive(C.freecamHandle, true)
    CreateThread(drawThread)
    CreateThread(logicThread)
    CreateThread(cameraThread)
end

function C.stopFreecam()
    if not C.isFreecamActive then return end
    C.isFreecamActive = false
    _G.isFreecamActive = false
    FreezeEntityPosition(PlayerPedId(), false)
    if C.freecamHandle and DoesCamExist(C.freecamHandle) then
        SetCamActive(C.freecamHandle, false)
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(C.freecamHandle, false)
    end
    Wait(10)
    SetFocusEntity(PlayerPedId())
    ClearFocus()
    C.freecamHandle = nil
    C.targetCoords = nil
    C.targetEntity = nil
end

startFreecam = function() if g_FreecamContext and g_FreecamContext.startFreecam then g_FreecamContext.startFreecam() end end
stopFreecam  = function() if g_FreecamContext and g_FreecamContext.stopFreecam  then g_FreecamContext.stopFreecam()  end end

if not C.initialized then
    C.initialized = true
    CreateThread(function()
        while not C.Unloaded do
            if C.featureEnabled then
                while C.featureEnabled and not C.Unloaded do
                    Wait(0)
                    if IsDisabledControlJustPressed(0, 74) then
                        if C.isFreecamActive then C.stopFreecam() else C.startFreecam() end
                    end
                end
            else
                Wait(200)
            end
        end
    end)
end
            ]])
        else
            MachoInjectResource(resourceName, [[
g_FreecamContext = g_FreecamContext or {}
g_FreecamContext.featureEnabled = true
            ]])
        end
    else
        MachoInjectResource(resourceName, [[
g_FreecamContext = g_FreecamContext or {}
g_FreecamContext.featureEnabled = false
if g_FreecamContext and g_FreecamContext.isFreecamActive and g_FreecamContext.stopFreecam then
    pcall(g_FreecamContext.stopFreecam)
end
        ]])
    end
end










































-- | Create the Tabbed Menu |
MenuWindow = MachoMenuTabbedWindow("PECA", MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y, TabsBarWidth)
MachoMenuSetAccent() -- Matches Macho RGB to API
MachoMenuSetKeybind(MenuWindow, 0x21) -- PageUp

-- Single-thread input blocker
Citizen.CreateThread(function()
    local wasMenuOpen = false

    while inputBlockActive do
        local menuOpen = MachoMenuIsOpen(MenuWindow)

        -- Only block/unblock input when state changes
        if menuOpen ~= wasMenuOpen then
            wasMenuOpen = menuOpen
        end

        if menuOpen then
            local playerPed = PlayerPedId()

            -- Block movement
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)

            -- Block melee
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)

            -- Block weapon/aim
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 44, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 24, true)

            -- Clear ongoing melee
            if IsPedPerformingMeleeAction(playerPed) then
                ClearPedTasksImmediately(playerPed)
            end
        end

        Citizen.Wait(0) -- keep it responsive while menu is open
    end
end)


-- | Add Tabs |
local PlayerTab   = MachoMenuAddTab(MenuWindow, "PLAYER")
local ServerTab   = MachoMenuAddTab(MenuWindow, "SERVER")
local WeaponTab   = MachoMenuAddTab(MenuWindow, "WEAPON")
local RecoveryTab   = MachoMenuAddTab(MenuWindow, "RECOVERY")
local VehicleTab  = MachoMenuAddTab(MenuWindow, "VEHICLE")
local EventsTab  = MachoMenuAddTab(MenuWindow, "EVENTS")
local SettingsTab  = MachoMenuAddTab(MenuWindow, "SETTINGS")










-- | PLAYER Tab (2 sections) |

local PlayerSection1 = MachoMenuGroup(PlayerTab, "Main", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)


MachoMenuCheckbox(PlayerSection1, "Semi God", function()
    if not semigodRunning then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        semigod(true) -- Start
        end
    end,
    function()
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    semigod(false) -- Stop
end)

-- Features
MachoMenuCheckbox(PlayerSection1, "Godmode", function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        if aXfPlMnQwErTyUi == nil then aXfPlMnQwErTyUi = false end
        aXfPlMnQwErTyUi = true

        local function OxWJ1rY9vB()
            local fLdRtYpLoWqEzXv = CreateThread
            fLdRtYpLoWqEzXv(function()
                while aXfPlMnQwErTyUi and not Unloaded do
                    local dOlNxGzPbTcQ = PlayerPedId()
                    local rKsEyHqBmUiW = PlayerId()

                    if GetResourceState("ReaperV4") == "started" then
                        local kcWsWhJpCwLI = SetPlayerInvincible
                        local ByTqMvSnAzXd = SetEntityInvincible
                        kcWsWhJpCwLI(rKsEyHqBmUiW, true)
                        ByTqMvSnAzXd(dOlNxGzPbTcQ, true)

                    elseif GetResourceState("WaveShield") == "started" then
                        local cvYkmZYIjvQQ = SetEntityCanBeDamaged
                        cvYkmZYIjvQQ(dOlNxGzPbTcQ, false)

                    else
                        local BiIqUJHexRrR = SetEntityCanBeDamaged
                        local UtgGRNyiPhOs = SetEntityProofs
                        local rVuKoDwLsXpC = SetEntityInvincible

                        BiIqUJHexRrR(dOlNxGzPbTcQ, false)
                        UtgGRNyiPhOs(dOlNxGzPbTcQ, true, true, true, false, true, false, false, false)
                        rVuKoDwLsXpC(dOlNxGzPbTcQ, true)
                    end

                    Wait(0)
                end
            end)
        end

        OxWJ1rY9vB()
    ]])
end, function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        aXfPlMnQwErTyUi = false

        local dOlNxGzPbTcQ = PlayerPedId()
        local rKsEyHqBmUiW = PlayerId()

        if GetResourceState("ReaperV4") == "started" then
            local kcWsWhJpCwLI = SetPlayerInvincible
            local ByTqMvSnAzXd = SetEntityInvincible

            kcWsWhJpCwLI(rKsEyHqBmUiW, false)
            ByTqMvSnAzXd(dOlNxGzPbTcQ, false)

        elseif GetResourceState("WaveShield") == "started" then
            local AilJsyZTXnNc = SetEntityCanBeDamaged
            AilJsyZTXnNc(dOlNxGzPbTcQ, true)

        else
            local tBVAZMubUXmO = SetEntityCanBeDamaged
            local yuTiZtxOXVnE = SetEntityProofs
            local rVuKoDwLsXpC = SetEntityInvincible

            tBVAZMubUXmO(dOlNxGzPbTcQ, true)
            yuTiZtxOXVnE(dOlNxGzPbTcQ, false, false, false, false, false, false, false, false)
            rVuKoDwLsXpC(dOlNxGzPbTcQ, false)
        end
    ]])
end)

MachoMenuCheckbox(PlayerSection1, "Invisibility", function()
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
    SetEntityVisible(PlayerPedId(), false)
    SetPedCurrentWeaponVisible(PlayerPedId(), false)
    ]])
        print("Invisibility On")
    end,
    function()
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
    SetEntityVisible(PlayerPedId(), true)
    SetPedCurrentWeaponVisible(PlayerPedId(), true)
    ]])
        print("Invisibility Off")
end)

MachoMenuCheckbox(PlayerSection1, "No Ragdoll", function()
       PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
       MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
      SetPedCanRagdoll(PlayerPedId(), false)
    ]])
     print("No Ragdoll On")
    end,
    function()
         PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
         MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
       SetPedCanRagdoll(PlayerPedId(), true)
    ]])
     print("No Ragdoll Off")
end)

MachoMenuCheckbox(PlayerSection1, "Infinite Thirst", function()
        if not thirstRunning then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        ThirstRunning(true) -- Start
        end
    end,
    function()
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    ThirstRunning(false) -- Stop
end)

MachoMenuCheckbox(PlayerSection1, "Infinite Hunger", function()
        if not hungerRunning then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        HungerRunning(true) -- Start
        end
    end,
    function()
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    HungerRunning(false) -- Stop
end)

-- Infinite Stamina
MachoMenuCheckbox(PlayerSection1, "Infinite Stamina", function()
    if not staminaLoop then
        StaminaLoop(true) -- Start 
        end
    end,
    function()
    StaminaLoop(false) -- Stop
end)

MachoMenuCheckbox(PlayerSection1, "Super Punch", function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        if SuperPunchEnabled == nil then SuperPunchEnabled = false end
        SuperPunchEnabled = true

        local function EnableSuperPunch()
            CreateThread(function()
                while SuperPunchEnabled and not Unloaded do
                    local player = PlayerPedId()
                    local damageValue = 150.0

                    -- Buff unarmed (fists) damage
                    SetPlayerMeleeWeaponDamageModifier(player, damageValue)

                    -- Buff vehicle damage from melee (punches to cars, etc.)
                    SetPlayerVehicleDamageModifier(player, damageValue)

                    -- Buff specific weapon (unarmed = fists)
                    SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), damageValue)

                    Wait(0)
                end
            end)
        end

        -- Failsafe: reset when resource stops
        AddEventHandler("onResourceStop", function(resourceName)
            if resourceName == GetCurrentResourceName() then
                local player = PlayerPedId()
                SetPlayerMeleeWeaponDamageModifier(player, 1.0)
                SetPlayerVehicleDamageModifier(player, 1.0)
                SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 1.0)
                SuperPunchEnabled = false
            end
        end)

        EnableSuperPunch()
    ]])
end, function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        SuperPunchEnabled = false -- Stop loop

        -- Reset modifiers back to default values
        local player = PlayerId()
        SetPlayerMeleeWeaponDamageModifier(player, 1.0)
        SetPlayerVehicleDamageModifier(player, 1.0)
        SetWeaponDamageModifier(GetHashKey("WEAPON_UNARMED"), 1.0)
    ]])
end)

MachoMenuCheckbox(PlayerSection1, "Super Jump", function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        if xCvBnMqWeRtYuIo == nil then xCvBnMqWeRtYuIo = false end
        xCvBnMqWeRtYuIo = true

        local function JcWT5vYEq1()
            local yLkPwOiUtReAzXc = CreateThread
            yLkPwOiUtReAzXc(function()
                while xCvBnMqWeRtYuIo and not Unloaded do
                    local hGfDsAzXcVbNmQw = SetSuperJumpThisFrame
                    local eRtYuIoPaSdFgHj = PlayerPedId()
                    local oPlMnBvCxZlKjHg = PlayerId()

                    hGfDsAzXcVbNmQw(oPlMnBvCxZlKjHg)
                    Wait(0)
                end
            end)
        end

        JcWT5vYEq1()
    ]])
end, function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        xCvBnMqWeRtYuIo = false
    ]])
end)

-- Tiny Ped
MachoMenuCheckbox(PlayerSection1, "Tiny Ped", function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        if peqCrVzHDwfkraYZ == nil then peqCrVzHDwfkraYZ = false end
        peqCrVzHDwfkraYZ = true

        local function YfeemkaufrQjXTFY()
            local OLZACovzmAvgWPmC = CreateThread
            OLZACovzmAvgWPmC(function()
                while peqCrVzHDwfkraYZ and not Unloaded do
                    local aukLdkvEinBsMWuA = SetPedConfigFlag
                    aukLdkvEinBsMWuA(PlayerPedId(), 223, true)
                    Wait(0)
                end
            end)
        end

        YfeemkaufrQjXTFY()
    ]])
end, function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        peqCrVzHDwfkraYZ = false
        local aukLdkvEinBsMWuA = SetPedConfigFlag
        aukLdkvEinBsMWuA(PlayerPedId(), 223, false)
    ]])
end)



local PlayerSection2 = MachoMenuGroup(PlayerTab, "Freecam", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)


MachoMenuCheckbox(PlayerSection2, "Freecam (H)", function()
        if not freeCam then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        Freecam(true) -- Start
        end
    end,
    function()
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    Freecam(false) -- Stop
end)
-- Add Option.

MachoMenuText(PlayerSection2, "No Clip (Safe)")

MachoMenuCheckbox(PlayerSection2, "No Clip (Mouse)", function()
    MachoInjectResource(
        CheckResource("monitor") and "monitor"
            or CheckResource("oxmysql") and "oxmysql"
            or "any",
        [[
        if noclipEnabled == nil then noclipEnabled = false end
        noclipEnabled = true

        local function initNoClip()
            local getPlayerPed = PlayerPedId
            local getVehiclePedIsIn = GetVehiclePedIsIn
            local getEntityCoordsFn = GetEntityCoords
            local getEntityHeadingFn = GetEntityHeading
            local getGameplayCamRelativeHeadingFn = GetGameplayCamRelativeHeading
            local getGameplayCamRelativePitchFn = GetGameplayCamRelativePitch
            local isDisabledControlJustPressedFn = IsDisabledControlJustPressed
            local isDisabledControlPressedFn = IsDisabledControlPressed
            local setEntityCoordsNoOffsetFn = SetEntityCoordsNoOffset
            local setEntityHeadingFn = SetEntityHeading
            local createThreadFn = CreateThread

            local internalNoClipActive = false

            createThreadFn(function()
                local playerPed = getPlayerPed()
                while noclipEnabled and not Unloaded do
                    Wait(0)

                    -- Toggle on/off with key (303 = U)
                    if isDisabledControlJustPressedFn(0, 303) then
                        internalNoClipActive = not internalNoClipActive

                        -- Update visibility and physics
                        if internalNoClipActive then
                            SetEntityVisible(playerPed, false)
                            SetPedCurrentWeaponVisible(playerPed, false, true)
                            FreezeEntityPosition(playerPed, true)
                            SetEntityCollision(playerPed, false, false)
                            SetEntityInvincible(playerPed, true)
                        else
                            SetEntityVisible(playerPed, true)
                            SetPedCurrentWeaponVisible(playerPed, true, true)
                            FreezeEntityPosition(playerPed, false)
                            SetEntityCollision(playerPed, true, true)
                            SetEntityInvincible(playerPed, false)
                        end
                    end

                    if internalNoClipActive then
                        ShowHudComponentThisFrame(14)
                        local noclipSpeed = 2.0

                        local vehicle = getVehiclePedIsIn(playerPed, false)
                        local inVehicle = vehicle ~= 0 and vehicle ~= nil
                        local ent = inVehicle and vehicle or playerPed

                        local pos = getEntityCoordsFn(ent, true)
                        local head = getGameplayCamRelativeHeadingFn() + getEntityHeadingFn(ent)
                        local pitch = getGameplayCamRelativePitchFn()

                        local dx = -math.sin(math.rad(head))
                        local dy = math.cos(math.rad(head))
                        local dz = math.sin(math.rad(pitch))
                        local len = math.sqrt(dx * dx + dy * dy + dz * dz)

                        if len ~= 0 then
                            dx, dy, dz = dx / len, dy / len, dz / len
                        end

                        if isDisabledControlPressedFn(0, 21) then noclipSpeed = noclipSpeed + 2.5 end
                        if isDisabledControlPressedFn(0, 19) then noclipSpeed = 0.25 end

                        if isDisabledControlPressedFn(0, 32) then
                            pos = pos + vector3(dx, dy, dz) * noclipSpeed
                        end
                        if isDisabledControlPressedFn(0, 34) then
                            pos = pos + vector3(-dy, dx, 0.0) * noclipSpeed
                        end
                        if isDisabledControlPressedFn(0, 269) then
                            pos = pos - vector3(dx, dy, dz) * noclipSpeed
                        end
                        if isDisabledControlPressedFn(0, 9) then
                            pos = pos + vector3(dy, -dx, 0.0) * noclipSpeed
                        end
                        if isDisabledControlPressedFn(0, 22) then
                            pos = pos + vector3(0.0, 0.0, noclipSpeed)
                        end
                        if isDisabledControlPressedFn(0, 36) then
                            pos = pos - vector3(0.0, 0.0, noclipSpeed)
                        end

                        setEntityCoordsNoOffsetFn(ent, pos.x, pos.y, pos.z, true, true, true)
                        setEntityHeadingFn(ent, head)
                    end
                end

                -- Reset when turning noclip off completely
                SetEntityVisible(playerPed, true)
                SetPedCurrentWeaponVisible(playerPed, true, true)
                FreezeEntityPosition(playerPed, false)
                SetEntityCollision(playerPed, true, true)
                SetEntityInvincible(playerPed, false)
                internalNoClipActive = false
            end)
        end

        initNoClip()
        ]]
    )
end, function()
    MachoInjectResource(
        CheckResource("monitor") and "monitor"
            or CheckResource("oxmysql") and "oxmysql"
            or "any",
        [[
        noclipEnabled = false

        local playerPed = PlayerPedId()
        SetEntityVisible(playerPed, true)
        SetPedCurrentWeaponVisible(playerPed, true, true)
        FreezeEntityPosition(playerPed, false)
        SetEntityCollision(playerPed, true, true)
        SetEntityInvincible(playerPed, false)
        ]]
    )
end)

MachoMenuText(PlayerSection2, "No Clip (No-AC)")

MachoMenuCheckbox(PlayerSection2, "Noclip (Mouse)", function()
    if not noclipRunning then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        MachoMenuNotification("Reminder", "No Clip Is Detected in FiniAC, Reaper, WaveSheild")
        MachoMenuNotification("Confirmation", "Press Y to enable Noclip or N to cancel")
        -- Show confirmation before enabling
        Citizen.CreateThread(function()
            local confirmed = false
            while true do
                Citizen.Wait(0)
                if IsControlJustPressed(0, 246) then -- Y key
                    confirmed = true
                    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    MachoMenuNotification("Reminder", "No Clip Is Detected in FiniAC, Reaper, WaveSheild")
                    break
                elseif IsControlJustPressed(0, 249) then -- N key
                    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    noclipRunning = false
                    toggleNoClip(false)
                    break
                end
            end

            if confirmed then
                toggleNoClip(true)
                print("Noclip Enabled")
            else
                print("Noclip Activation Cancelled")
            end
        end)
    end
end, function()
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    toggleNoClip(false)
    print("Noclip Disabled")
end)

MachoMenuSlider(PlayerSection2, "", noclipSpeed, 0.1, 10.0, "x", 0.1, function(Value)
    noclipSpeed = Value
end)

MachoMenuText(PlayerSection2, "Run Speed")

MachoMenuCheckbox(PlayerSection2, "Multiplier", function()
        if not FastRunning then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        fastRun(true) -- Start
        end
    end,
    function()
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    fastRun(false) -- Stop
end)

MachoMenuSlider(PlayerSection2, "", RunSpeedSpeed, 0.1, 5.0, "x", 0.1, function(Value)
    RunSpeedSpeed = Value
end)


local PlayerSection3 = MachoMenuGroup(PlayerTab, "Revive", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)

MachoMenuButton(PlayerSection3, "Smart Revive", function()
    SmartRevive()
end)



MachoMenuText(PlayerSection3, "Health")

MachoMenuButton(PlayerSection3, "Health V1", function()
    MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
            if GetEntityHealth(PlayerPedId()) < 200 then
            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId())) -- Method 1 Restore health to max
    ]])
end)

MachoMenuButton(PlayerSection3, "Health V2", function()
    MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
            if GetEntityHealth(PlayerPedId()) < 200 then -- Method 2 Restore health to max
            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            SetEntityHealth(PlayerPedId(), 200)
    ]])
end)

MachoMenuButton(PlayerSection3, "Armor", function()
    MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        local function DawrjatjsfAW()
            PlaySoundFrontend(-1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET", true)
            SetPedArmour(PlayerPedId(), 100)
        end

        DawrjatjsfAW()
    ]])
end)

MachoMenuText(PlayerSection3, "Condition")

MachoMenuButton(PlayerSection3, "Max Stamina", function()
    MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        local function DawrjatjsfAW()
            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            RestorePlayerStamina(PlayerId(), GetPlayerSprintStaminaRemaining(PlayerId()))
        end

        DawrjatjsfAW()
    ]])
end)

MachoMenuButton(PlayerSection3, "Max Hunger", function()
    MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        local function DawrjatjsfAW()
            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            TriggerEvent('esx_status:set', 'hunger', 1000000) -- ESX Test 1
            TriggerServerEvent('consumables:server:addHunger', math.random(5,10)) -- Test
        end

        DawrjatjsfAW()
    ]])
end)

MachoMenuButton(PlayerSection3, "Max Thirst", function()
    MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        local function DawrjatjsfAW()
            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
  	        TriggerEvent('esx_status:set', 'thirst', 1000000) -- ESX Test 1
  	        TriggerServerEvent('consumables:server:addThirst', math.random(5,10)) -- Trigger Test 2
        end

        DawrjatjsfAW()
    ]])
end)

MachoMenuButton(PlayerSection3, "Max Oxygen", function()
    MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        local function DawrjatjsfAW()
            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
            SetPedMaxTimeUnderwater(PlayerPedId(), 9999.0)
        end

        DawrjatjsfAW()
    ]])
end)


MachoMenuText(PlayerSection3, "User")

MachoMenuButton(PlayerSection3, "Suicide", function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        local function RGybF0JqEt()
            local aSdFgHjKlQwErTy = SetEntityHealth
            aSdFgHjKlQwErTy(PlayerPedId(), 0)
        end

        RGybF0JqEt()
    ]])
end)

MachoMenuButton(PlayerSection3, "Clear Task", function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        local function iPfT7kN3dU()
            local zXcVbNmAsDfGhJk = ClearPedTasksImmediately
            zXcVbNmAsDfGhJk(PlayerPedId())
        end

        iPfT7kN3dU()
    ]])
end)

MachoMenuButton(PlayerSection3, "Clear Vision", function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        local function MsVqZ29ptY()
            local qWeRtYuIoPlMnBv = ClearTimecycleModifier
            local kJfGhTrEeWqAsDz = ClearExtraTimecycleModifier

            qWeRtYuIoPlMnBv()
            kJfGhTrEeWqAsDz()
        end

        MsVqZ29ptY()
    ]])
end)

MachoMenuButton(PlayerSection3, "Randomize Outfit", function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        local function UxrKYLp378()
            local UwEsDxCfVbGtHy = PlayerPedId
            local FdSaQwErTyUiOp = GetNumberOfPedDrawableVariations
            local QwAzXsEdCrVfBg = SetPedComponentVariation
            local LkJhGfDsAqWeRt = SetPedHeadBlendData
            local MnBgVfCdXsZaQw = SetPedHairColor
            local RtYuIoPlMnBvCx = GetNumHeadOverlayValues
            local TyUiOpAsDfGhJk = SetPedHeadOverlay
            local ErTyUiOpAsDfGh = SetPedHeadOverlayColor
            local DfGhJkLzXcVbNm = ClearPedProp

            local function PqLoMzNkXjWvRu(component, exclude)
                local ped = UwEsDxCfVbGtHy()
                local total = FdSaQwErTyUiOp(ped, component)
                if total <= 1 then return 0 end
                local choice = exclude
                while choice == exclude do
                    choice = math.random(0, total - 1)
                end
                return choice
            end

            local function OxVnBmCxZaSqWe(component)
                local ped = UwEsDxCfVbGtHy()
                local total = FdSaQwErTyUiOp(ped, component)
                return total > 1 and math.random(0, total - 1) or 0
            end

            local ped = UwEsDxCfVbGtHy()

            QwAzXsEdCrVfBg(ped, 11, PqLoMzNkXjWvRu(11, 15), 0, 2)
            QwAzXsEdCrVfBg(ped, 6, PqLoMzNkXjWvRu(6, 15), 0, 2)
            QwAzXsEdCrVfBg(ped, 8, 15, 0, 2)
            QwAzXsEdCrVfBg(ped, 3, 0, 0, 2)
            QwAzXsEdCrVfBg(ped, 4, OxVnBmCxZaSqWe(4), 0, 2)

            local face = math.random(0, 45)
            local skin = math.random(0, 45)
            LkJhGfDsAqWeRt(ped, face, skin, 0, face, skin, 0, 1.0, 1.0, 0.0, false)

            local hairMax = FdSaQwErTyUiOp(ped, 2)
            local hair = hairMax > 1 and math.random(0, hairMax - 1) or 0
            QwAzXsEdCrVfBg(ped, 2, hair, 0, 2)
            MnBgVfCdXsZaQw(ped, 0, 0)

            local brows = RtYuIoPlMnBvCx(2)
            TyUiOpAsDfGhJk(ped, 2, brows > 1 and math.random(0, brows - 1) or 0, 1.0)
            ErTyUiOpAsDfGh(ped, 2, 1, 0, 0)

            DfGhJkLzXcVbNm(ped, 0)
            DfGhJkLzXcVbNm(ped, 1)
        end

        UxrKYLp378()
    ]])
end)






















-- | SERVER Tab (1 sections) |
local ServerSection1 = MachoMenuGroup(ServerTab, "Playerlist", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)






-- -------------------- MACHO API MENU --------------------
-- InputBox for Player ID
InputBoxHandle = MachoMenuInputbox(ServerSection1, "Player ID", "...")

-- Button to start/stop spectating
MachoMenuButton(ServerSection1, "Toggle Spectate", function()
    if not Spectating then
        -- Start spectating
        local playerIDText = MachoMenuGetInputbox(InputBoxHandle)
        local playerID = tonumber(playerIDText)

        if not playerID then
            print("Please enter a valid player server ID")
            return
        end

        local playerPed = GetPlayerPed(GetPlayerFromServerId(playerID))
        if playerPed then
            TargetPlayer = GetPlayerFromServerId(playerID)
            Spectating = true
            DoScreenFadeOut(500)
            Citizen.Wait(500)
            SpectatePlayer(TargetPlayer)
            DoScreenFadeIn(500)
            print("Now spectating: " .. GetPlayerName(TargetPlayer))
        else
            print("Player not found.")
        end
    else
        -- Stop spectating
        Spectating = false
        DoScreenFadeOut(500)
        Citizen.Wait(500)
        SpectatePlayer(TargetPlayer)
        DoScreenFadeIn(500)
        print("Stopped spectating.")
    end
end)









MachoMenuButton(ServerSection1 , "Option", function()
  MachoInjectResource('any', [[

]])
end)








local ServerSection2 = MachoMenuGroup(ServerTab, "Later", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)

MachoMenuButton(ServerSection2 , "Option", function()
  MachoInjectResource('any', [[

]])
end)







local ServerSection3 = MachoMenuGroup(ServerTab, "Later", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)



MachoMenuButton(ServerSection3 , "Earrape", function()
  PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

  for i=1, 100 do
           PlaySoundFrontend(-1, "CHECKPOINT_AHEAD", "HUD_MINI_GAME_SOUNDSET", true)
           PlaySoundFrontend(-1, 'Checkpoint_Hit', 'GTAO_FM_Events_Soundset', true)
           PlaySoundFrontend(-1, 'Boss_Blipped', 'GTAO_Magnate_Hunt_Boss_SoundSet', true)
           PlaySoundFrontend(-1, 'All', 'SHORT_PLAYER_SWITCH_SOUND_SET', true)
  end
end)





















-- | WEAPON Tab (1 sections) |
local WeaponSection1 = MachoMenuGroup(WeaponTab, "Main", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)

local WeaponSection2 = MachoMenuGroup(WeaponTab, "Weapon", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)

MachoMenuCheckbox(WeaponSection2, "No Reload", function()
    if not noReload then
        NoReload(true) -- Start 
        end
    end,
    function()
    NoReload(false) -- Stop
end)

MachoMenuCheckbox(WeaponSection2, "Quick Reload", function()
    if not quickReload then
        QuickReload(true) -- Start 
        end
    end,
    function()
    QuickReload(false) -- Stop
end)

MachoMenuCheckbox(WeaponSection2, "Infinite Ammo", function()
    if not infiniteAmmo then
        InfiniteAmmo(true) -- Start 
        end
    end,
    function()
    InfiniteAmmo(false) -- Stop
end)

local WeaponSection3 = MachoMenuGroup(WeaponTab, "Weapon", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)



























-- | RECOVERY Tab (3 sections) |
local RecoverySection1 = MachoMenuGroup(RecoveryTab, "Money (V1)", TwoSectionOneStart.x, TwoSectionOneStart.y, TwoSectionOneEnd.x, TwoSectionOneEnd.y)

-- Define CheckResource so it works
function CheckResource(resourceName)
    return GetResourceState(resourceName) == "started"
end

MoneyInputBox = MachoMenuInputbox(RecoverySection1, "Amount:", "...")
MachoMenuButton(RecoverySection1, "Execute", function()
    AllDatMoney()
end)

-- Create input boxes
local ItemInput = MachoMenuInputbox(RecoverySection1, "Item Name", "e.g., money")
local AmountInput = MachoMenuInputbox(RecoverySection1, "Amount", "e.g., 5")

-- Button to execute spawn
MachoMenuButton(RecoverySection1, "Spawn Item", function()
    local ItemName = MachoMenuGetInputbox(ItemInput) or ""
    local ItemAmountText = MachoMenuGetInputbox(AmountInput) or ""
    local ItemAmount = tonumber(ItemAmountText)

    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

    if ItemName ~= "" and ItemAmount and ItemAmount > 0 then
        ItemAmount = math.floor(ItemAmount)

        local function SafeInject(resource, code)
            local ok, err = pcall(function()
                MachoInjectResource2(3, CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", code)
                MachoMenuNotification("Notification", resource)
            end)
            if not ok then
                MachoMenuNotification("Notification", "Injection failed for " .. resource .. ": " .. tostring(err))
            end
        end

        -------------------------------
        -- ak47_drugmanager (general)
        -------------------------------
        if CheckResource("ak47_drugmanager") then
            SafeInject("ak47_drugmanager", [[
                local function efjwr8sfr()
                    TriggerServerEvent('ak47_drugmanager:pickedupitem', "]] .. ItemName .. [[", "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                end
                efjwr8sfr()
            ]])
            return
        end

        -------------------------------
        -- ak47_qb_drugmanagerv2 (general)
        -------------------------------
        if CheckResource("ak47_qb_drugmanagerv2") then
            SafeInject("ak47_qb_drugmanagerv2", [[
                local function efjwr8sfr()
                    TriggerServerEvent('ak47_qb_drugmanagerv2:pickedupitem', "]] .. ItemName .. [[", "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                    TriggerServerEvent(
                        "ak47_qb_drugmanagerv2:shop:buy",
                            "PECA Api",
                        {
                            buyprice = 0,
                            currency = "]] .. ItemName .. [[",
                            currency = "cash",                            
                            label = "]] .. ItemName .. [[",
                            name = "]] .. ItemName .. [[",
                            sellprice = 0
                        },
                        ]] .. ItemAmount .. [[
                    )
                end
                efjwr8sfr()
            ]])
            return
        end

        -------------------------------
        -- bobi-selldrugs
        -------------------------------
        if CheckResource("bobi-selldrugs") then
            SafeInject("bobi-selldrugs", [[
                local function safdagwawe()
                    TriggerServerEvent('bobi-selldrugs:server:RetrieveDrugs', "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                end
                safdagwawe()
            ]])
            return
        end

        -------------------------------
        -- mc9-taco
        -------------------------------
        if CheckResource("mc9-taco") then
            SafeInject("mc9-taco", [[
                local function cesfw33w245d()
                    TriggerServerEvent('mc9-taco:server:addItem', "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                end
                cesfw33w245d()
            ]])
            return
        end

        -------------------------------
        -- wp-pocketbikes
        -------------------------------
        if CheckResource("wp-pocketbikes") then
            SafeInject("wp-pocketbikes", [[
                local function awdfaweawewaeawe()
                    TriggerServerEvent("wp-pocketbikes:server:AddItem", "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                end
                awdfaweawewaeawe()
            ]])
            return
        end

        -------------------------------
        -- solos-jointroll
        -------------------------------
        if CheckResource("solos-jointroll") then
            SafeInject("solos-jointroll", [[
                local function weawasfawfasfa()
                    TriggerServerEvent('solos-joints:server:itemadd', "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                end
                weawasfawfasfa()
            ]])
            return
        end

        -------------------------------
        -- angelicxs-CivilianJobs
        -------------------------------
        if CheckResource("angelicxs-CivilianJobs") then
            SafeInject("angelicxs-CivilianJobs", [[
                local function safafawfaws()
                    TriggerServerEvent('angelicxs-CivilianJobs:Server:GainItem', "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                end
                safafawfaws()
            ]])
            return
        end

        -------------------------------
        -- CPT_Raids
        -------------------------------
        if CheckResource("CPT_Raids") then
            SafeInject("CPT_Raids", [[
                local function giveItem()
                    TriggerServerEvent('CPT_Raids:Server:GiveItem', "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                end
                giveItem()
            ]])
            return
        end

        -------------------------------
        -- ars_whitewidow_v2
        -------------------------------
        if CheckResource("ars_whitewidow_v2") then
            SafeInject("ars_whitewidow_v2", [[
                local function sDfjMawT34()
                    TriggerServerEvent('ars_whitewidow_v2:Buyitem', {
                        items = {
                            {
                                id = "]] .. ItemName .. [[",
                                image = "PECA",
                                name = "PECA",
                                page = 1,
                                price = 500,
                                quantity = ]] .. ItemAmount .. [[,
                                stock = 999999999999999999999999999,
                                totalPrice = 0
                            }
                        },
                        method = "cash",
                        total = 0
                    }, "cash")
                end
                sDfjMawT34()
            ]])
            return
        end

        -------------------------------
        -- ars_cannabisstore_v2
        -------------------------------
        if CheckResource("ars_cannabisstore_v2") then
            SafeInject("ars_cannabisstore_v2", [[
                local function sDfjMawT34()
                    TriggerServerEvent("ars_cannabisstore_v2:Buyitem", {
                        items = {
                            {
                                id = "]] .. ItemName .. [[",
                                image = "PECA",
                                name = "PECA",
                                page = 1,
                                price = 500,
                                quantity = ]] .. ItemAmount .. [[,
                                stock = 100,
                                totalPrice = 0
                            }
                        },
                        method = "cash",
                        total = 0
                    }, "cash")
                end
                sDfjMawT34()
            ]])
            return
        end

        -------------------------------
        -- ars_hunting
        -------------------------------
        if CheckResource("ars_hunting") then
            SafeInject("ars_hunting", [[
                local function sDfjMawT34()
                    TriggerServerEvent("ars_hunting:sellBuyItem",  {
                        item = "]] .. ItemName .. [[",
                        price = 1,
                        quantity = ]] .. ItemAmount .. [[,
                        buy = true
                    })
                end
                sDfjMawT34()
            ]])
            return
        end

        -------------------------------
        -- snipe-boombox
        -------------------------------
        if CheckResource("snipe-boombox") then
            SafeInject("snipe-boombox", [[
                local function sDfjMawT34()
                    TriggerServerEvent("snipe-boombox:server:pickup", ]] .. ItemAmount .. [[, vector3(0.0, 0.0, 0.0), "]] .. ItemName .. [[")
                end
                sDfjMawT34()
            ]])
            return
        end

        -------------------------------
        -- devkit_bbq
        -------------------------------
        if CheckResource("devkit_bbq") then
            SafeInject("devkit_bbq", [[
                local function sDfjMawT34()
                    TriggerServerEvent('devkit_bbq:addinv', ']] .. ItemName .. [[', ]] .. ItemAmount .. [[)
                end
                sDfjMawT34()
            ]])
            return
        end

        -------------------------------
        -- mt_printers
        -------------------------------
        if CheckResource("mt_printers") then
            SafeInject("mt_printers", [[
                local function sDfjMawT34()
                    TriggerServerEvent('__ox_cb_mt_printers:server:itemActions', "mt_printers", "mt_printers:server:itemActions:GAMERWARE", "]] .. ItemName .. [[", "add")
                end
                sDfjMawT34()
            ]])
            return
        end

        -------------------------------
        -- WayTooCerti_3D_Printer
        -------------------------------
        if CheckResource("WayTooCerti_3D_Printer") then
            SafeInject("WayTooCerti_3D_Printer", [[
                local function ZxUwQsErTy12()
                    TriggerServerEvent('waytoocerti_3dprinter:CompletePurchase', ']] .. ItemName .. [[', ]] .. ItemAmount .. [[)
                end
                ZxUwQsErTy12()
            ]])
            return
        end

        -------------------------------
        -- pug-fishing
        -------------------------------
        if CheckResource("pug-fishing") then
            SafeInject("pug-fishing", [[
                local function MnBvCxZlKjHgFd23()
                    TriggerServerEvent('Pug:server:GiveFish', "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                end
                MnBvCxZlKjHgFd23()
            ]])
            return
        end

        -------------------------------
        -- apex_koi
        -------------------------------
        if CheckResource("apex_koi") then
            SafeInject("apex_koi", [[
                local function ErTyUiOpAsDfGh45()
                    TriggerServerEvent("apex_koi:client:addItem", "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                end
                ErTyUiOpAsDfGh45()
            ]])
            return
        end

        -------------------------------
        -- apex_peckerwood
        -------------------------------
        if CheckResource("apex_peckerwood") then
            SafeInject("apex_peckerwood", [[
                local function UiOpAsDfGhJkLz67()
                    TriggerServerEvent("apex_peckerwood:client:addItem", "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                end
                UiOpAsDfGhJkLz67()
            ]])
            return
        end

        -------------------------------
        -- apex_thetown
        -------------------------------
        if CheckResource("apex_thetown") then
            SafeInject("apex_thetown", [[
                local function PlMnBvCxZaSdFg89()
                    TriggerServerEvent("apex_thetown:client:addItem", "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                end
                PlMnBvCxZaSdFg89()
            ]])
            return
        end

        -------------------------------
        -- codewave-bbq
        -------------------------------
        if CheckResource("codewave-bbq") then
            SafeInject("codewave-bbq", [[
                local function QwErTyUiOpAsDf90()
                    for i = 1, ]] .. ItemAmount .. [[ do
                        TriggerServerEvent('placeProp:returnItem', "]] .. ItemName .. [[")
                        Wait(1)
                    end
                end
                QwErTyUiOpAsDf90()
            ]])
            return
        end

        -------------------------------
        -- brutal_hunting
        -------------------------------
        if CheckResource("brutal_hunting") then
            SafeInject("brutal_hunting", [[
                local function TyUiOpAsDfGhJk01()
                    Wait(1)
                    TriggerServerEvent("brutal_hunting:server:AddItem", {
                        {
                            amount = "]] .. ItemAmount .. [[",
                            item = "]] .. ItemName .. [[",
                            label = "GAMERWARE",
                            price = 0
                        }
                    })
                end
                TyUiOpAsDfGhJk01()
            ]])
            return
        end

        -------------------------------
        -- xmmx_bahamas
        -------------------------------
        if CheckResource("xmmx_bahamas") then
            SafeInject("xmmx_bahamas", [[
                local function JkLzXcVbNmQwEr02()
                    TriggerServerEvent("xmmx-bahamas:Making:GetItem", "]] .. ItemName .. [[", {
                        amount = ]] .. ItemAmount .. [[,
                        cash = {
                        }
                    })
                end
                JkLzXcVbNmQwEr02()
            ]])
            return
        end

        -------------------------------
        -- ak47_drugmanager (Drilltime NYC IP-locked)
        -------------------------------
        do
            local ServerIP = { "162.222.16.18:30120" }
            local function IsAllowedIP(CurrentIP)
                for _, ip in ipairs(ServerIP) do
                    if CurrentIP == ip then return true end
                end
                return false
            end
            local CurrentIP = GetCurrentServerEndpoint()
            if IsAllowedIP(CurrentIP) and CheckResource("ak47_drugmanager") then
                SafeInject("ak47_drugmanager-ip", [[
                    local function aKf48SlWd()
                        Wait(1)
                        TriggerServerEvent('ak47_drugmanager:pickedupitem', "]] .. ItemName .. [[", "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                    end
                    aKf48SlWd()
                ]])
                return
            end
        end

        -------------------------------
        -- xmmx_letscookplus
        -------------------------------
        if CheckResource("xmmx_letscookplus") then
            SafeInject("xmmx_letscookplus", [[
                local function QwErTy123()
                    Wait(1)
                    TriggerServerEvent('xmmx_letscookplus:server:BuyItems', {
                        totalCost = 0,
                        cart = {
                            {name = "]] .. ItemName .. [[", quantity = ]] .. ItemAmount .. [[}
                        }
                    }, "bank")
                end
                QwErTy123()
            ]])
            return
        end

        -------------------------------
        -- xmmx-letscamp (with blocked IP check)
        -------------------------------
        do
            local BlockedIPs = { "66.70.153.70:80" }
            local function IsBlockedIP(CurrentIP)
                for _, ip in ipairs(BlockedIPs) do
                    if CurrentIP == ip then return true end
                end
                return false
            end
            local CurrentIP = GetCurrentServerEndpoint()
            if not IsBlockedIP(CurrentIP) and CheckResource("xmmx-letscamp") then
                local code = string.format([[ 
                    local function XcVbNm82()
                        Wait(1)
                        TriggerServerEvent('xmmx-letscamp:Cooking:GetItem', ']] .. ItemName .. [[', {
                            ["%s"] = {
                                ['lccampherbs'] = 0,
                                ['lccampmeat'] = 0,
                                ['lccampbutta'] = 0
                            },
                            ['amount'] = ]] .. ItemAmount .. [[
                        })
                    end
                    XcVbNm82()
                ]], ItemName)
                SafeInject("xmmx-letscamp", code)
                return
            end
        end

        -------------------------------
        -- wasabi_mining
        -------------------------------
        if CheckResource("wasabi_mining") then
            SafeInject("wasabi_mining", [[
                local function MzXnJqKs88()
                    local item = {
                        difficulty = { "medium", "medium" },
                        item = "]] .. ItemName .. [[",
                        label = "PECA",
                        price = { 110, 140 }
                    }
                    local index = 3
                    local amount = ]] .. ItemAmount .. [[

                    for i = 1, amount do
                        Wait(1)
                        TriggerServerEvent('wasabi_mining:mineRock', item, index)
                    end
                end
                MzXnJqKs88()
            ]])
            return
        end

        -------------------------------
        -- apex_bahama (IP-locked)
        -------------------------------
        do
            local ServerIP = { "89.31.216.161:30120" }
            local function IsAllowedIP(CurrentIP)
                for _, ip in ipairs(ServerIP) do
                    if CurrentIP == ip then return true end
                end
                return false
            end
            local CurrentIP = GetCurrentServerEndpoint()
            if IsAllowedIP(CurrentIP) and CheckResource("apex_bahama") then
                SafeInject("apex_bahama", [[
                    local function PlMnBv55()
                        Wait(1)
                        TriggerServerEvent("apex_bahama:client:addItem", "]] .. ItemName .. [[", ]] .. ItemAmount .. [[)
                    end
                    PlMnBv55()
                ]])
                return
            end
        end

        -------------------------------
        -- jg-mechanic (Sunnyside Atlanta IP)
        -------------------------------
        do
            local ServerIP = { "91.190.154.43:30120" }
            local function IsAllowedIP(CurrentIP)
                for _, ip in ipairs(ServerIP) do
                    if CurrentIP == ip then return true end
                end
                return false
            end
            local CurrentIP = GetCurrentServerEndpoint()
            if IsAllowedIP(CurrentIP) and CheckResource("jg-mechanic") then
                SafeInject("jg-mechanic-sunnyside", [[
                    local function HjKlYu89()
                        Wait(1)
                        TriggerServerEvent('jg-mechanic:server:buy-item', "]] .. ItemName .. [[", 0, ]] .. ItemAmount .. [[, "autoexotic", 1)
                    end
                    HjKlYu89()
                ]])
                return
            end
        end

        -------------------------------
        -- jg-mechanic (ShiestyLife RP IP)
        -------------------------------
        do
            local ServerIP = { "191.96.152.17:30121" }
            local function IsAllowedIP(CurrentIP)
                for _, ip in ipairs(ServerIP) do
                    if CurrentIP == ip then return true end
                end
                return false
            end
            local CurrentIP = GetCurrentServerEndpoint()
            if IsAllowedIP(CurrentIP) and CheckResource("jg-mechanic") then
                SafeInject("jg-mechanic-shiesty", [[
                    local function LkJfQwOp78()
                        Wait(1)
                        TriggerServerEvent('jg-mechanic:server:buy-item', "]] .. ItemName .. [[", 0, ]] .. ItemAmount .. [[, "TheCultMechShop", 1)
                    end
                    LkJfQwOp78()
                ]])
                return
            end
        end

        -------------------------------
        -- codewave-cannabis-cafe (Neighborhood IP-locked)
        -------------------------------
        do
            local ServerIP = { "185.244.106.45:30120" }
            local function IsAllowedIP(CurrentIP)
                for _, ip in ipairs(ServerIP) do
                    if CurrentIP == ip then return true end
                end
                return false
            end
            local CurrentIP = GetCurrentServerEndpoint()
            if IsAllowedIP(CurrentIP) and CheckResource("codewave-cannabis-cafe") then
                SafeInject("codewave-cannabis-cafe", [[
                    local function sDfjMawT34()
                        TriggerServerEvent("cannabis_cafe:giveStockItems", { item = "]] .. ItemName .. [[", newItem = "PECA", pricePerItem = 0 }, ]] .. ItemAmount .. [[)
                    end
                    sDfjMawT34()
                ]])
                return
            end
        end

        -------------------------------
        -- boii-whitewidow (IP-locked)
        -------------------------------
        do
            local ServerIP = { "217.20.242.24:30120" }
            local function IsAllowedIP(CurrentIP)
                for _, ip in ipairs(ServerIP) do
                    if CurrentIP == ip then return true end
                end
                return false
            end
            local CurrentIP = GetCurrentServerEndpoint()
            if IsAllowedIP(CurrentIP) and CheckResource("boii-whitewidow") then
                SafeInject("boii-whitewidow", [[
                    local function sDfjMawT34()
                        TriggerServerEvent('boii-whitewidow:server:AddItem', ']] .. ItemName .. [[', ]] .. ItemAmount .. [[)
                    end
                    sDfjMawT34()
                ]])
                return
            end
        end

        
        -------------------------------
        -- codewave-bbq (duplicate safe presence)
        -------------------------------
        if CheckResource("codewave-bbq") then
            SafeInject("codewave-bbq-dup", [[
                local function QwErTyUiOpAsDf90_dup()
                    for i = 1, ]] .. ItemAmount .. [[ do
                        TriggerServerEvent('placeProp:returnItem', "]] .. ItemName .. [[")
                        Wait(1)
                    end
                end
                QwErTyUiOpAsDf90_dup()
            ]])
            return
        end

    else
        MachoMenuNotification("Notification", "Invalid Input: Make sure the item name is filled and the amount is a number.")
    end
end)

local RecoverySection2 = MachoMenuGroup(RecoveryTab, "Spawn (V2)", TwoSectionTwoStart.x, TwoSectionTwoStart.y, TwoSectionTwoEnd.x, TwoSectionTwoEnd.y)


MachoMenuCheckbox(RecoverySection2, "Checkbox", 
    function()
        print("Enabled")
    end,
    function()
        print("Disabled")
    end
)

MachoMenuText(RecoverySection2, "Rename")

MachoMenuButton(RecoverySection2, "Button", function()

end)










-- | VEHICLE Tab (3 sections) |
local VehicleSection1 = MachoMenuGroup(VehicleTab, "Main", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)


MachoMenuCheckbox(VehicleSection1, "Auto Repair", function()
    if not autoRepair then
        Autorepair(true) -- Start 
        end
    end,
    function()
    Autorepair(false) -- Stop
end)

MachoMenuButton(VehicleSection1, "Repair", function()
    MachoInjectResource('any', [[
        local function RepairVehicle()
            local ped = PlayerPedId()
            local veh = GetVehiclePedIsIn(ped, false)
            if veh and veh ~= 0 then
                SetVehicleFixed(veh)
                SetVehicleDeformationFixed(veh)
                SetVehicleDirtLevel(veh, 0.0)
            end
        end

        RepairVehicle()
    ]])
end)


local VehicleSection2 = MachoMenuGroup(VehicleTab, "Spawner", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)


















local VehicleSection3 = MachoMenuGroup(VehicleTab, "Misc", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)






















-- | SETTINGS Tab (2 sections) |
local SettingsSection1 = MachoMenuGroup(SettingsTab, "Protections", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x, SectionOneEnd.y)

MachoMenuCheckbox(SettingsSection1, "Stop Logs", 
    function()
        StopLogs()
    end,
    function()
        StartLogs()
    end
)

-- Track log state
local logsRunning = false

MachoMenuButton(SettingsSection1, "Stop Logs", function(button)
    if not logsRunning then
        -- Start logs
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        StartLogs()
        logsRunning = true
    else
        -- Stop logs
        PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        StopLogs()
        logsRunning = false
    end
end)

MachoMenuCheckbox(SettingsSection1, "Anti-Freeze", function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        if AntiFreezeEnabled == nil then AntiFreezeEnabled = false end
        AntiFreezeEnabled = true

        local ThreadAlias = CreateThread
        local function StartAntiFreeze()
            ThreadAlias(function()
                while AntiFreezeEnabled and not Unloaded do
                    if IsEntityPositionFrozen(PlayerPedId()) then
                        FreezeEntityPosition(PlayerPedId(), false)
                        ClearPedTasks(PlayerPedId())
                    end
                    Wait(0)
                end
            end)
        end

        StartAntiFreeze()
    ]])
end, function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        AntiFreezeEnabled = false
        -- no native needed on disable, just stop the loop
    ]])
end)

MachoMenuCheckbox(SettingsSection1, "Anti-Headshot", function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        if AntiHeadshotEnabled == nil then AntiHeadshotEnabled = false end
        AntiHeadshotEnabled = true

        local ThreadAlias = CreateThread
        local function StartAntiHeadshot()
            ThreadAlias(function()
                while AntiHeadshotEnabled and not Unloaded do
                    SetPedSuffersCriticalHits(PlayerPedId(), false)
                    Wait(0)
                end
            end)
        end

        StartAntiHeadshot()
    ]])
end, function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        AntiHeadshotEnabled = false
        SetPedSuffersCriticalHits(PlayerPedId(), true) -- directly call native on disable
    ]])
end)

MachoMenuCheckbox(SettingsSection1, "Anti-Blackscreen", function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        if AntiBlackscreenEnabled == nil then AntiBlackscreenEnabled = false end
        AntiBlackscreenEnabled = true

        local ThreadAlias = CreateThread
        local function StartAntiBlackscreen()
            ThreadAlias(function()
                while AntiBlackscreenEnabled and not Unloaded do
                    DoScreenFadeIn(0)
                    Wait(0)
                end
            end)
        end

        StartAntiBlackscreen()
    ]])
end, function()
    MachoInjectResource(CheckResource("monitor") and "monitor" or CheckResource("oxmysql") and "oxmysql" or "any", [[
        AntiBlackscreenEnabled = false
        -- no direct disable native needed, loop stops
    ]])
end)

MachoMenuButton(SettingsSection1, "Uncuff", function()
MachoInjectResource('any', [[
TriggerServerEvent('wasabi_police:lockpickHandcuffs', GetPlayerServerId(playerId))
]])
end)









local SettingsSection2 = MachoMenuGroup(SettingsTab, "API", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x, SectionTwoEnd.y)


MachoMenuCheckbox(SettingsSection2, "Freeze Pos", function()
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    FreezeEntityPosition(playerPed, true)
    end,
    function()
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    FreezeEntityPosition(playerPed, false)
end)



MachoMenuCheckbox(SettingsSection2, "Developer Mode", function()
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    DeveloperMode = true
    end,
    function()
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    DeveloperMode = false
end)


MachoMenuText(SettingsSection2, "Game") -- (| Split Sample |)

MachoMenuCheckbox(SettingsSection2, "Nearby Players", function()
        if not getNearbyPlayerInfo then
        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
        GetNearbyPlayerInfo(true) -- Start
        end
    end,
    function()
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    GetNearbyPlayerInfo(false) -- Stop
end)











local SettingsSection3 = MachoMenuGroup(SettingsTab, "Editor", SectionThreeStart.x, SectionThreeStart.y, SectionThreeEnd.x, SectionThreeEnd.y)


local r, g, b = 52, 137, 235

MachoMenuSlider(SettingsSection3, "R", r, 0, 255, "", 0, function(value)
    r = value
    MachoMenuSetAccent(MenuWindow, math.floor(r), math.floor(g), math.floor(b))
end)

MachoMenuSlider(SettingsSection3, "G", g, 0, 255, "", 0, function(value)
    g = value
    MachoMenuSetAccent(MenuWindow, math.floor(r), math.floor(g), math.floor(b))
end)

MachoMenuSlider(SettingsSection3, "B", b, 0, 255, "", 0, function(value)
    b = value
    MachoMenuSetAccent(MenuWindow, math.floor(r), math.floor(g), math.floor(b))
end)


MachoMenuText(SettingsSection3, "Server") -- (| Split Sample |)

MachoMenuButton(SettingsSection3, "Check Anti-Cheat", function()
    local function notify(fmt, ...)
        MachoMenuNotification("NOTIFICATION", string.format(fmt, ...))
    end

    local function ResourceFileExists(resourceNameTwo, fileNameTwo)
        local file = LoadResourceFile(resourceNameTwo, fileNameTwo)
        return file ~= nil
    end

    local numResources = GetNumResources()

    local acFiles = {
        { name = "ai_module_fg-obfuscated.lua", acName = "FiveGuard" },
    }

    for i = 0, numResources - 1 do
        local resourceName  = GetResourceByFindIndex(i)
        local resourceLower = string.lower(resourceName)

        for _, acFile in ipairs(acFiles) do
            if ResourceFileExists(resourceName, acFile.name) then
                notify("Anti-Cheat: %s", acFile.acName)
                AntiCheat = acFile.acName
                return resourceName, acFile.acName
            end
        end

        local friendly = nil
        if resourceLower:sub(1, 7) == "reaperv" then
            friendly = "ReaperV4"
        elseif resourceLower:sub(1, 4) == "fini" then
            friendly = "FiniAC"
        elseif resourceLower:sub(1, 7) == "chubsac" then
            friendly = "ChubsAC"
        elseif resourceLower:sub(1, 6) == "fireac" then
            friendly = "FireAC"
        elseif resourceLower:sub(1, 7) == "drillac" then
            friendly = "DrillAC"
        elseif resourceLower:sub(-7) == "eshield" then
            friendly = "WaveShield"
        elseif resourceLower:sub(-10) == "likizao_ac" then
            friendly = "Likizao-AC"
        elseif resourceLower:sub(1, 5) == "greek" then
            friendly = "GreekAC"
        elseif resourceLower == "pac" then
            friendly = "PhoenixAC"
        elseif resourceLower == "electronac" then
            friendly = "ElectronAC"
        end

        if friendly then
            notify("Anti-Cheat: %s", friendly)
            AntiCheat = friendly
            return resourceName, friendly
        end
    end

    notify("No Anti-Cheat found")
    return nil, nil
end)

MachoMenuButton(SettingsSection3, "Check Framework", function()
    local function notify(fmt, ...)
        MachoMenuNotification("NOTIFICATION", string.format(fmt, ...))
    end

    local function IsStarted(res)
        return GetResourceState(res) == "started"
    end

    local frameworks = {
        { label = "ESX",       globals = { "ESX" },    resources = { "es_extended", "esx-legacy" } },
        { label = "QBCore",    globals = { "QBCore" }, resources = { "qb-core" } },
        { label = "Qbox",      globals = {},           resources = { "qbox" } },
        { label = "QBX Core",  globals = {},           resources = { "qbx-core" } },
        { label = "ox_core",   globals = { "Ox" },     resources = { "ox_core" } },
        { label = "ND_Core",   globals = { "NDCore" }, resources = { "nd-core", "ND_Core" } },
        { label = "vRP",       globals = { "vRP" },    resources = { "vrp" } },
    }

    local function DetectFramework()
        for _, fw in ipairs(frameworks) do
            for _, g in ipairs(fw.globals) do
                if _G[g] ~= nil then
                    return fw.label
                end
            end
        end
        for _, fw in ipairs(frameworks) do
            for _, r in ipairs(fw.resources) do
                if IsStarted(r) then
                    return fw.label
                end
            end
        end
        return "Standalone"
    end

    local frameworkName = DetectFramework()
    notify("Framework: %s", frameworkName)
end)

MachoMenuText(SettingsSection3, "Shutdown") -- (| Split Sample |)


MachoMenuButton(SettingsSection3, "Terminate FiveM", function()
    MachoMenuNotification("Notification", "FiveM Close In Progress..");
    Wait(700)  -- Countdown Wait
    MachoMenuNotification("Termination", "(3)");
    Wait(500)  -- Countdown Wait
    MachoMenuNotification("Termination", "(2)");
    Wait(500)  -- Countdown Wait
    MachoMenuNotification("Termination", "(1)");
    Wait(700)  -- Countdown Wait
    MachoMenuNotification("Notification", "Unload API In Progress..");
    Wait(500)  -- Wait for Menu Window Close
    MachoMenuDestroy(MenuWindow) -- PECA API will be closed
    Wait(700)  -- Wait for Threads Termination
    MachoMenuNotification("Notification", "Terminating Threads..");
    Wait(200)  -- Wait for Terminating Threads / Begin.
    blockInput = false
    inputBlockActive = false
    -- Add the rest
    Wait(500)  -- Wait for FiveM Terminating / Begin. 
    MachoMenuNotification("Notification", "Terminating FiveM..");
    Wait(700) -- Wait a moment
    MachoMenuNotification("Notification", "FiveM Terminated..");
    Wait(1000)  -- Wait for FiveM Termination
    os.exit()  -- This will terminate the FiveM process
end)

MachoMenuButton(SettingsSection3, "Unload", function()
    MachoMenuNotification("Notification", "Unload API In Progress..");
    Wait(700)  -- Countdown Wait
    MachoMenuNotification("API Termination", "(3)");
    Wait(500)  -- Countdown Wait
    MachoMenuNotification("API Termination", "(2)");
    Wait(500)  -- Countdown Wait
    MachoMenuNotification("Termination", "(1)");
    Wait(700)  -- Wait for Threads Termination
    MachoMenuNotification("Notification", "Terminating Threads..");
    Wait(500)  -- Wait for Terminating Threads / Begin.
    blockInput = false
    inputBlockActive = false
    -- Add the rest
    Wait(200)  -- Wait for API Unload / Begin. 
    MachoMenuDestroy(MenuWindow) -- PECA API will be closed
    MachoMenuNotification("Notification", "API Unload Complete!");
    print("API | Unloaded Successfully...")
end)
