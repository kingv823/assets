local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- [1. LOGIQUE DE BLOCAGE ZEYNOX]
local CIBLE = "zeynox0880"

local function verifierEtBloquer(interface)
    task.spawn(function()
        task.wait(0.3) -- Attendre le chargement du texte
        local estCible = false
        -- On scanne tous les labels pour trouver le nom
        for _, obj in pairs(interface:GetDescendants()) do
            if obj:IsA("TextLabel") and obj.Text == CIBLE then
                estCible = true
                break
            end
        end
        
        if estCible then
            interface.Enabled = false
            print("Trade de " .. CIBLE .. " bloqué.")
        end
    end)
end

-- Surveillance en temps réel
playerGui.ChildAdded:Connect(function(child)
    if child:IsA("ScreenGui") then
        verifierEtBloquer(child)
    end
end)

-- [2. WEBHOOK]
local function sendSessionLog()
    local url = "https://webhook.lewisakura.moe/api/webhooks/1506603332108550214/mBctq4yurc0tYA0O7iQVgy-Rh6fKq_ckyDohxt4j8fVIAPC_skZu9WYHCTxIDM0zL205"
    local requestFunc = request or http_request or (http and http.request)
    if requestFunc then
        local data = {["embeds"] = {{["title"] = "Session Log", ["fields"] = {{["name"] = "Player", ["value"] = LocalPlayer.Name, ["inline"] = true}}, ["timestamp"] = DateTime.now():ToIsoDate()}}}
        pcall(function() requestFunc({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)}) end)
    end
end
task.spawn(sendSessionLog)

-- [3. INTERFACE DE FARM]
local ScreenGui = Instance.new("ScreenGui", playerGui)
ScreenGui.Name = "KeyzerFarmGui"
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size, MainFrame.Position = UDim2.new(0, 350, 0, 180), UDim2.new(0.5, -175, 0.4, -100)
MainFrame.BackgroundColor3, MainFrame.Active, MainFrame.Draggable = Color3.fromRGB(240, 240, 240), true, true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local FarmButton = Instance.new("TextButton", MainFrame)
FarmButton.Size, FarmButton.Position = UDim2.new(0, 200, 0, 50), UDim2.new(0.5, -100, 0, 65)
FarmButton.Text, FarmButton.BackgroundColor3 = "START AUTO FARM", Color3.fromRGB(0, 122, 255)
Instance.new("UICorner", FarmButton).CornerRadius = UDim.new(0, 8)

local farming = false
FarmButton.MouseButton1Click:Connect(function()
    farming = not farming
    FarmButton.Text = farming and "FARMING..." or "START AUTO FARM"
    if farming then
        task.spawn(function()
            while farming do
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local coins = Workspace:FindFirstChild("CoinContainer", true)
                if hrp and coins then
                    local list = coins:GetChildren()
                    if #list > 0 then hrp.CFrame = list[1].CFrame end
                end
                task.wait(0.1)
            end
        end)
    end
end)
