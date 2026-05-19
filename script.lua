-- [[ KEYZER AUTO FARM - COIN COLLECTOR FIX V11 ]] --

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Nettoyage de l'ancienne interface
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("KeyzerFarmGui")
if oldGui then oldGui:Destroy() end

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


-- [[ LOGIQUE DE TÉLÉPORTATION ALLONGÉE + CAMÉRA FIXÉE ]] --

local farming = false

local function getCoins()
    local container = Workspace:FindFirstChild("CoinContainer", true)
    if container then
        return container:GetChildren()
    end
    
    local map = Workspace:FindFirstChild("Map") or Workspace:FindFirstChild("Normal")
    if map then
        local coinFolder = map:FindFirstChild("CoinContainer", true)
        if coinFolder then return coinFolder:GetChildren() end
    end
    
    return {}
end

local function startFarmLoop()
    -- Bloque la caméra pour éviter qu'elle tremble dans tous les sens
    Camera.CameraType = Enum.CameraType.Scriptable

    task.spawn(function()
        while farming do
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            if hrp and humanoid then
                local allCoins = getCoins()
                if #allCoins > 0 then
                    FarmButton.Text = "FARMING... (" .. #allCoins .. " left)"
                    
                    local targetCoin = allCoins[1]
                    if targetCoin and targetCoin:IsA("BasePart") then
                        -- 1. On désactive les collisions pour passer à travers le sol sans bloquer
                        for _, part in ipairs(character:GetChildren()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end

                        -- 2. On se cache juste SOUS la pièce (-2.5 studs) et on s'allonge à -90°
                        -- C'est assez proche pour collecter à 100%, mais assez bas pour être caché dans le sol
                        hrp.CFrame = (targetCoin.CFrame * CFrame.new(0, -2.5, 0)) * CFrame.Angles(math.rad(-90), 0, 0)
                        
                        -- 3. Le micro-déplacement magique pour déclencher la collecte
                        humanoid:Move(Vector3.new(0, 0, -1), true)
                        
                        -- 4. Vitesse de ramassage ultra optimisée
                        task.wait(0.06)
                    end
                else
                    FarmButton.Text = "WAITING FOR ROUND COINS..."
                end
            else
                FarmButton.Text = "ERROR: NO CHARACTER FOUND"
            end
            task.wait()
        end
        
        -- Remet la caméra normale quand le farm s'arrête
        Camera.CameraType = Enum.CameraType.Custom
    end)
end


-- [[ ENCLENCHEMENT DES BOUTONS ]] --

CloseBtn.MouseButton1Click:Connect(function()
    farming = false
    Camera.CameraType = Enum.CameraType.Custom
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
        Camera.CameraType = Enum.CameraType.Custom
    end
end)
