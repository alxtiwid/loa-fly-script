local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local fly = false
local speedOn = false
local up = false
local down = false

local normalSpeed = 16
local fastSpeed = 50
local flySpeed = 60
local verticalSpeed = 40

local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(c)
    char = c
    humanoid = c:WaitForChild("Humanoid")
    hrp = c:WaitForChild("HumanoidRootPart")
end)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,190,0,230)
frame.Position = UDim2.new(0.05,0,0.45,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,35)
title.Text = "LOA FLY MENU"
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(1,-20,0,35)
flyBtn.Position = UDim2.new(0,10,0,45)
flyBtn.Text = "FLY: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
flyBtn.TextColor3 = Color3.new(1,1,1)

local speedBtn = Instance.new("TextButton", frame)
speedBtn.Size = UDim2.new(1,-20,0,35)
speedBtn.Position = UDim2.new(0,10,0,85)
speedBtn.Text = "SPEED: OFF"
speedBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedBtn.TextColor3 = Color3.new(1,1,1)

local upBtn = Instance.new("TextButton", frame)
upBtn.Size = UDim2.new(1,-20,0,35)
upBtn.Position = UDim2.new(0,10,0,130)
upBtn.Text = "⬆ UP"
upBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
upBtn.TextColor3 = Color3.new(1,1,1)

local downBtn = Instance.new("TextButton", frame)
downBtn.Size = UDim2.new(1,-20,0,35)
downBtn.Position = UDim2.new(0,10,0,170)
downBtn.Text = "⬇ DOWN"
downBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
downBtn.TextColor3 = Color3.new(1,1,1)

-- FLY PARTS
local bv, bg

local function startFly()
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.Parent = hrp

    humanoid.PlatformStand = true
end

local function stopFly()
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    humanoid.PlatformStand = false
end

RunService.RenderStepped:Connect(function()
    if fly and bv and bg then
        local move = humanoid.MoveDirection * flySpeed
        local y = 0

        if up then y = verticalSpeed end
        if down then y = -verticalSpeed end

        bv.Velocity = Vector3.new(move.X, y, move.Z)
        bg.CFrame = workspace.CurrentCamera.CFrame
    end
end)

-- BOTONES
flyBtn.MouseButton1Click:Connect(function()
    fly = not fly
    if fly then
        startFly()
        flyBtn.Text = "FLY: ON"
    else
        stopFly()
        flyBtn.Text = "FLY: OFF"
    end
end)

speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    humanoid.WalkSpeed = speedOn and fastSpeed or normalSpeed
    speedBtn.Text = speedOn and "SPEED: ON" or "SPEED: OFF"
end)

upBtn.MouseButton1Down:Connect(function() up = true end)
upBtn.MouseButton1Up:Connect(function() up = false end)

downBtn.MouseButton1Down:Connect(function() down = true end)
downBtn.MouseButton1Up:Connect(function() down = false end)

-- GUI MOVIBLE
local dragging, dragStart, startPos

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
