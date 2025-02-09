local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UI = {}

-- Create the main admin panel
local function createAdminPanel()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AdminPanel"
    ScreenGui.Parent = game.CoreGui

    local Panel = Instance.new("Frame")
    Panel.Size = UDim2.new(0, 200, 0, 50)
    Panel.Position = UDim2.new(0.8, 0, 0.1, 0)
    Panel.BackgroundTransparency = 0.3
    Panel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Panel.BorderSizePixel = 0
    Panel.Parent = ScreenGui

    -- "Players" button
    local PlayersButton = Instance.new("TextButton")
    PlayersButton.Size = UDim2.new(1, 0, 1, 0)
    PlayersButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    PlayersButton.Text = "Players"
    PlayersButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayersButton.Font = Enum.Font.GothamBold
    PlayersButton.Parent = Panel

    return PlayersButton
end

-- Create the draggable player list UI
local function createPlayerList()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PlayerList"
    ScreenGui.Parent = game.CoreGui

    local PlayerFrame = Instance.new("Frame")
    PlayerFrame.Size = UDim2.new(0, 250, 0, 400)
    PlayerFrame.Position = UDim2.new(0.5, -125, 0.2, 0)
    PlayerFrame.BackgroundTransparency = 0.2
    PlayerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    PlayerFrame.BorderSizePixel = 0
    PlayerFrame.Parent = ScreenGui

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = PlayerFrame
    UIListLayout.FillDirection = Enum.FillDirection.Vertical
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    return PlayerFrame
end

local PlayerListFrame = createPlayerList()
PlayerListFrame.Visible = false

local PlayersButton = createAdminPanel()
PlayersButton.MouseButton1Click:Connect(function()
    PlayerListFrame.Visible = not PlayerListFrame.Visible
end)

-- Function to update player list
function UI.updatePlayerList(player, data)
    local playerButton = Instance.new("TextButton")
    playerButton.Size = UDim2.new(1, -10, 0, 40)
    playerButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    playerButton.Text = player.DisplayName
    playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    playerButton.Font = Enum.Font.Gotham
    playerButton.Parent = PlayerListFrame

    -- Suspicion bar
    local SuspicionBar = Instance.new("Frame")
    SuspicionBar.Size = UDim2.new(0, 0, 0, 5)
    SuspicionBar.Position = UDim2.new(0, 0, 1, -5)
    SuspicionBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    SuspicionBar.Parent = playerButton

    -- Store references
    playerButton:SetAttribute("SuspicionBar", SuspicionBar)

    playerButton.MouseButton1Click:Connect(function()
        -- Open player details UI
        print("Clicked on player:", player.Name)
    end)
end

-- Function to update suspicion bar
function UI.updateSuspicion(player, suspicionLevel)
    for _, button in ipairs(PlayerListFrame:GetChildren()) do
        if button:IsA("TextButton") and button.Text == player.DisplayName then
            local SuspicionBar = button:GetAttribute("SuspicionBar")
            if SuspicionBar then
                TweenService:Create(SuspicionBar, TweenInfo.new(0.3), {Size = UDim2.new(suspicionLevel / 100, 0, 0, 5)}):Play()
            end
        end
    end
end

-- Function to remove player from list
function UI.removePlayerFromList(player)
    for _, button in ipairs(PlayerListFrame:GetChildren()) do
        if button:IsA("TextButton") and button.Text == player.DisplayName then
            button:Destroy()
        end
    end
end

return UI
