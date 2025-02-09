local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local AntiCheat = {}
local playerData = {}

-- Load UI module
local UI = require(script.Parent.ui)
local PlayerHandler = require(script.Parent.players)

-- Function to calculate suspicion level
local function calculateSuspicion(player)
    local data = playerData[player.UserId]
    if not data then return 0 end

    local suspicion = 0

    -- Check for unusual walk speed
    if data.WalkSpeed > 20 then
        suspicion = suspicion + 15
    end

    -- Check for unusual jump power
    if data.JumpPower > 60 then
        suspicion = suspicion + 20
    end

    -- Detect double jump
    if data.DoubleJumpDetected then
        suspicion = suspicion + 25
    end

    -- Detect if account is new (alts)
    if data.AccountAge < 30 then
        suspicion = suspicion + 30
    end

    -- If premium, less likely to be an alt
    if data.HasPremium then
        suspicion = suspicion - 10
    end

    return math.clamp(suspicion, 0, 100)
end

-- Function to update player tracking
local function trackPlayer(player)
    playerData[player.UserId] = {
        WalkSpeed = player.Character and player.Character.Humanoid.WalkSpeed or 16,
        JumpPower = player.Character and player.Character.Humanoid.JumpPower or 50,
        DoubleJumpDetected = false,
        AccountAge = player.AccountAge,
        HasPremium = player.MembershipType == Enum.MembershipType.Premium,
    }

    -- Send data to UI
    UI.updatePlayerList(player, playerData[player.UserId])

    -- Monitor player movement
    player.CharacterAdded:Connect(function(char)
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                playerData[player.UserId].WalkSpeed = humanoid.WalkSpeed
                UI.updateSuspicion(player, calculateSuspicion(player))
            end)

            humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
                playerData[player.UserId].JumpPower = humanoid.JumpPower
                UI.updateSuspicion(player, calculateSuspicion(player))
            end)
        end
    end)
end

-- Player joins
Players.PlayerAdded:Connect(function(player)
    trackPlayer(player)
end)

-- Player leaves
Players.PlayerRemoving:Connect(function(player)
    playerData[player.UserId] = nil
    UI.removePlayerFromList(player)
end)

return AntiCheat
