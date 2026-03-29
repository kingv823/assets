local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local DISCORD_LINK = "https://discord.gg/G2KKtYjxcD"

local IsVIP = false
local AccessGranted = false
local SessionStartTime = 0
local AutoFarmEnabled = false

--// VALIDATEUR
local function validateKey(input)
    local separator = input:find("_")
    if not separator then return false, "Format: Prefix_Key" end
    
    local prefix = input:sub(1, separator - 1)
    local keyBody = input:sub(separator + 1):gsub("%s+", "")
    
    if #keyBody < 35 then return false, "Need 35 chars" end

    local uppers, lowers, digits = 0, 0, 0
    for i = 1, #keyBody do
        local c = keyBody:sub(i,i)
        if c:match("%u") then uppers = uppers + 1
        elseif c:match("%l") then lowers = lowers + 1
        elseif c:match("%d") then digits = digits + 1 end
    end

    if prefix == "Keyzerfree" then
        if uppers >= 4 and digits >= 16 then return true, "Keyzerfree" end
    elseif prefix == "Keyzervip" then
        -- L'INVERSE : 3 minuscules pile, le reste MAJ/Digits
        if lowers == 3 and digits >= 16 then return true, "Keyzervip" end
    end
    return false, "Invalid Structure"
end

--// GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 300)
main.Position = UDim2.new(0.5, -180, 0.5, -150)
main.BackgroundColor3 = Color3.new(0, 0, 0)
main.BorderSizePixel = 0
Instance.new("UICorner", main)

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 45)
top.BackgroundTransparency = 1

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "Keyzer 💯"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1

local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -38, 0, 7)
close.Text = "✖️"
close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close)

local loginPage = Instance.new("Frame", main)
loginPage.Size = UDim2.new(1, 0, 1, -45)
loginPage.Position = UDim2.new(0, 0, 0, 45)
loginPage.BackgroundTransparency = 1

local farmPage = Instance.new("Frame", main)
farmPage.Size = UDim2.new(1, 0, 1, -45)
farmPage.Position = UDim2.new(0, 0, 0, 45)
farmPage.BackgroundTransparency = 1
farmPage.Visible = false

local keyBox = Instance.new("TextBox", loginPage)
keyBox.Size = UDim2.new(0, 300, 0, 45)
keyBox.Position = UDim2.new(0.5, -150, 0.1, 0)
keyBox.PlaceholderText = "Paste Key..."
keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", keyBox)

local vBtn = Instance.new("TextButton", loginPage)
vBtn.Size = UDim2.new(0, 200, 0, 45)
vBtn.Position = UDim2.new(0.5, -100, 0.4, 0)
vBtn.Text = "Validate"
vBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
vBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", vBtn)

local dBtn = Instance.new("TextButton", loginPage)
dBtn.Size = UDim2.new(1, 0, 0, 40)
dBtn.Position = UDim2.new(0, 0, 0.85, 0)
dBtn.Text = "Discord Link"
dBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
dBtn.TextColor3 = Color3.new(1, 1, 1)

--// ACTIONS
vBtn.MouseButton1Click:Connect(function()
    local ok, res = validateKey(keyBox.Text)
    if ok then
        IsVIP = (res == "Keyzervip")
        AccessGranted = true
        SessionStartTime = tick()
        vBtn.Text = "Welcome " .. LocalPlayer.Name .. (IsVIP and " [🌟]" or "")
        vBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        task.wait(1.5)
        loginPage.Visible = false
        farmPage.Visible = true
    else
        vBtn.Text = "INVALID STRUCTURE"
        task.wait(1)
        vBtn.Text = "Validate"
    end
end)

dBtn.MouseButton1Click:Connect(function()
    setclipboard(DISCORD_LINK)
    dBtn.Text = "COPIED"
    task.wait(1)
    dBtn.Text = "Discord Link"
end)

local farmToggle = Instance.new("TextButton", farmPage)
farmToggle.Size = UDim2.new(0, 250, 0, 50)
farmToggle.Position = UDim2.new(0.5, -125, 0.15, 0)
farmToggle.Text = "Auto-Farm: OFF"
farmToggle.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
farmToggle.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", farmToggle)

farmToggle.MouseButton1Click:Connect(function()
    AutoFarmEnabled = not AutoFarmEnabled
    farmToggle.Text = "Auto-Farm: " .. (AutoFarmEnabled and "ON" or "OFF")
    farmToggle.BackgroundColor3 = AutoFarmEnabled and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(200, 0, 0)
end)

task.spawn(function()
    while task.wait(0.7) do
        if AutoFarmEnabled and AccessGranted then
            pcall(function()
                local coin = workspace:FindFirstChild("CoinContainer", true)
                if coin then
                    local target = coin:FindFirstChildWhichIsA("BasePart")
                    if target then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame
                    end
                end
            end)
        end
    end
end)

close.MouseButton1Click:Connect(function() gui:Destroy() end)

--// DRAG
local d, ds, sp
top.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = true ds = i.Position sp = main.Position end end)
UIS.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then local delta = i.Position - ds main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d = false end end)
