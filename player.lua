local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local DataStoreService = game:GetService("DataStoreService")

local PlayerHandler = {}

local function getPastUsernames(player)
    -- This is only possible with an external API or stored data.
    return {"OldName1", "OldName2"} -- Placeholder
end

local function getRobuxSpent(player)
    -- Roblox doesn’t allow us to fetch exact Robux spent.
    return math.random(500, 5000) -- Placeholder value
end

local function getPlaytime(player)
    if not player:GetAttribute("JoinTime") then
        player:SetAttribute("JoinTime", os.time())
    end
    return os.time() - player:GetAttribute("JoinTime")
end

local function monitorPlayer(player)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local suspicion = 0

    if humanoid then
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if humanoid.WalkSpeed > 20 then
                suspicion = suspicion + 15
            end
        end)

        humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
            if humanoid.JumpPower > 60 then
                suspicion = suspicion + 20
            end
        end)

        local lastJumpTime = 0
        humanoid.StateChanged:Connect(function(old, new)
            if new == Enum.HumanoidStateType.Jumping then
                local currentTime = tick()
                if currentTime - lastJumpTime < 0.3 then
                    suspicion = suspicion + 25
                end
                lastJumpTime = currentTime
            end
        end)
    end

    return suspicion
end

function PlayerHandler.getPlayerInfo(player)
    local info = {
        UserId = player.UserId,
        DisplayName = player.DisplayName,
        Username = player.Name,
        PastUsernames = getPastUsernames(player),
        RobuxSpent = getRobuxSpent(player),
        Playtime = getPlaytime(player),
        AccountAge = player.AccountAge,
        HasPremium = player.MembershipType == Enum.MembershipType.Premium
    }

    return info
end

Players.PlayerAdded:Connect(function(player)
    monitorPlayer(player)
end)

return PlayerHandler
