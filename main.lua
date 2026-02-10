-- 455x1 SCRIPT | UI COMPACTA + ALERTAS + ANIMACIONES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

-- ================= VARIABLES =================
local humanoid, root
local flying, frozen, noclip, infJump, walkActive = false,false,false,false,false
local flySpeed, walkSpeed = 70,16
local minFlySpeed, maxFlySpeed = 20,300
local minWalkSpeed, maxWalkSpeed = 16,500
local control = {F=0,B=0,L=0,R=0,U=0,D=0}

-- ================= UI =================
local gui = Instance.new("ScreenGui")
gui.Name = "XenoUI"
gui.Parent = Player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Fondo compacto
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,280,0,380)
frame.Position = UDim2.new(0,50,0,50)
frame.BackgroundColor3 = Color3.fromRGB(18,8,9)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-10,0,25)
title.Position = UDim2.new(0,5,0,5)
title.BackgroundTransparency = 1
title.Text = "455x1 Script"
title.TextColor3 = Color3.fromRGB(204,45,45)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- ================= FUNCIONES =================
-- Función para mostrar alerta
local function showAlert(text,posY)
    local alert = Instance.new("TextLabel")
    alert.Size = UDim2.new(0,140,0,20)
    alert.Position = UDim2.new(0.5,-70,0,posY-25)
    alert.BackgroundTransparency = 0.7
    alert.BackgroundColor3 = Color3.fromRGB(0,0,0)
    alert.TextColor3 = Color3.fromRGB(255,255,255)
    alert.Text = text
    alert.Font = Enum.Font.GothamBold
    alert.TextSize = 12
    alert.Parent = frame

    -- Tween fade out
    local tween = TweenService:Create(alert,TweenInfo.new(0.8),{TextTransparency=1,BackgroundTransparency=1,Position=UDim2.new(0.5,-70,0,posY-45)})
    tween:Play()
    tween.Completed:Connect(function() alert:Destroy() end)
end

-- Función para crear botones
local function createButton(text,y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-20,0,36)
    b.Position = UDim2.new(0,10,0,y)
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(220,220,220)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BorderSizePixel = 0
    local corner = Instance.new("UICorner",b)
    corner.CornerRadius = UDim.new(0,10)
    b.Parent = frame
    return b
end

-- ================= BOTONES =================
local jumpBtn = createButton("Infinity Jump : OFF",40)
local stopBtn = createButton("STOP : OFF",85)
local flyBtn = createButton("FLY : OFF",130)
local noclipBtn = createButton("NOCLIP : OFF",175)
local walkBtn = createButton("Walk Speed : OFF",220)

-- Fly Speed
local flyLbl = Instance.new("TextLabel")
flyLbl.Position = UDim2.new(0,10,0,260)
flyLbl.Size = UDim2.new(1,-20,0,20)
flyLbl.BackgroundTransparency = 1
flyLbl.TextColor3 = Color3.fromRGB(220,220,220)
flyLbl.Font = Enum.Font.Gotham
flyLbl.TextSize = 14
flyLbl.Text = "Fly Speed: "..flySpeed
flyLbl.Parent = frame

local flyUp = Instance.new("TextButton")
flyUp.Size = UDim2.new(0,60,0,30)
flyUp.Position = UDim2.new(0.5,10,0,285)
flyUp.BackgroundColor3 = Color3.fromRGB(50,50,50)
flyUp.Text = "+"
flyUp.TextColor3 = Color3.fromRGB(220,220,220)
flyUp.Font = Enum.Font.GothamBold
flyUp.TextSize = 18
Instance.new("UICorner", flyUp).CornerRadius = UDim.new(0,6)
flyUp.Parent = frame

local flyDown = Instance.new("TextButton")
flyDown.Size = UDim2.new(0,60,0,30)
flyDown.Position = UDim2.new(0.5,-70,0,285)
flyDown.BackgroundColor3 = Color3.fromRGB(50,50,50)
flyDown.Text = "-"
flyDown.TextColor3 = Color3.fromRGB(220,220,220)
flyDown.Font = Enum.Font.GothamBold
flyDown.TextSize = 18
Instance.new("UICorner", flyDown).CornerRadius = UDim.new(0,6)
flyDown.Parent = frame

-- Walk Speed
local walkLbl = Instance.new("TextLabel")
walkLbl.Position = UDim2.new(0,10,0,330)
walkLbl.Size = UDim2.new(1,-20,0,20)
walkLbl.BackgroundTransparency = 1
walkLbl.TextColor3 = Color3.fromRGB(220,220,220)
walkLbl.Font = Enum.Font.Gotham
walkLbl.TextSize = 14
walkLbl.Text = "Walk Speed: "..walkSpeed
walkLbl.Parent = frame

local walkUp = Instance.new("TextButton")
walkUp.Size = UDim2.new(0,60,0,30)
walkUp.Position = UDim2.new(0.5,10,0,360)
walkUp.BackgroundColor3 = Color3.fromRGB(50,50,50)
walkUp.Text = "+"
walkUp.TextColor3 = Color3.fromRGB(220,220,220)
walkUp.Font = Enum.Font.GothamBold
walkUp.TextSize = 18
Instance.new("UICorner", walkUp).CornerRadius = UDim.new(0,6)
walkUp.Parent = frame

local walkDown = Instance.new("TextButton")
walkDown.Size = UDim2.new(0,60,0,30)
walkDown.Position = UDim2.new(0.5,-70,0,360)
walkDown.BackgroundColor3 = Color3.fromRGB(50,50,50)
walkDown.Text = "-"
walkDown.TextColor3 = Color3.fromRGB(220,220,220)
walkDown.Font = Enum.Font.GothamBold
walkDown.TextSize = 18
Instance.new("UICorner", walkDown).CornerRadius = UDim.new(0,6)
walkDown.Parent = frame

-- ================= BOTÓN FLOTANTE =================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,50,0,50)
toggleBtn.Position = UDim2.new(0,5,0,200)
toggleBtn.Text = "UI"
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(204,45,45)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,25)
toggleBtn.Parent = gui

-- Drag botón flotante
local dragging, dragInput, dragStart, startPos
toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = toggleBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
toggleBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        toggleBtn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
    end
end)
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- ================= FUNCIONES DEL PERSONAJE =================
local function onChar(char)
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    if walkActive then humanoid.WalkSpeed = walkSpeed end
end
if Player.Character then onChar(Player.Character) end
Player.CharacterAdded:Connect(onChar)

-- ================= FUNCIONES DE BOTONES =================
jumpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    jumpBtn.Text = infJump and "Infinity Jump : ON" or "Infinity Jump : OFF"
    jumpBtn.BackgroundColor3 = infJump and Color3.fromRGB(204,45,45) or Color3.fromRGB(50,50,50)
    showAlert(jumpBtn.Text,jumpBtn.Position.Y.Offset)
end)
UIS.JumpRequest:Connect(function()
    if infJump and humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- Fly
local bv,bg
local function startFly()
    if not root then return end
    bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bg = Instance.new("BodyGyro", root)
    bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
    RunService:BindToRenderStep("Fly",0,function()
        local cam = workspace.CurrentCamera
        local move = (cam.CFrame.LookVector*(control.F-control.B)
                     + cam.CFrame.RightVector*(control.R-control.L)
                     + cam.CFrame.UpVector*(control.U-control.D))
        bv.Velocity = move*flySpeed
        bg.CFrame = cam.CFrame
    end)
end
local function stopFly()
    RunService:UnbindFromRenderStep("Fly")
    if bv then bv:Destroy() bv=nil end
    if bg then bg:Destroy() bg=nil end
end
flyBtn.MouseButton1Click:Connect(function()
    if frozen then return end
    flying = not flying
    if flying then startFly() else stopFly() end
    flyBtn.Text = flying and "FLY : ON" or "FLY : OFF"
    flyBtn.BackgroundColor3 = flying and Color3.fromRGB(204,45,45) or Color3.fromRGB(50,50,50)
    showAlert(flyBtn.Text,flyBtn.Position.Y.Offset)
end)

stopBtn.MouseButton1Click:Connect(function()
    frozen = not frozen
    if frozen then
        flying=false
        stopFly()
        if root then root.Anchored=true end
        if humanoid then humanoid.PlatformStand=true end
        stopBtn.BackgroundColor3 = Color3.fromRGB(204,45,45)
        stopBtn.Text="STOP : ON"
    else
        if root then root.Anchored=false end
        if humanoid then humanoid.PlatformStand=false end
        stopBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        stopBtn.Text="STOP : OFF"
    end
    showAlert(stopBtn.Text,stopBtn.Position.Y.Offset)
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.BackgroundColor3 = noclip and Color3.fromRGB(204,45,45) or Color3.fromRGB(50,50,50)
    noclipBtn.Text = noclip and "NOCLIP : ON" or "NOCLIP : OFF"
    showAlert(noclipBtn.Text,noclipBtn.Position.Y.Offset)
end)
RunService.Stepped:Connect(function()
    if noclip and Player.Character then
        for _,v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide=false end
        end
    end
end)

-- Fly Speed
flyUp.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed+5,minFlySpeed,maxFlySpeed)
    flyLbl.Text="Fly Speed: "..flySpeed
    showAlert("Fly Speed +"..flySpeed,flyUp.Position.Y.Offset)
end)
flyDown.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed-5,minFlySpeed,maxFlySpeed)
    flyLbl.Text="Fly Speed: "..flySpeed
    showAlert("Fly Speed "..flySpeed,flyDown.Position.Y.Offset)
end)

-- Walk Speed
walkUp.MouseButton1Click:Connect(function()
    walkSpeed = math.clamp(walkSpeed+5,minWalkSpeed,maxWalkSpeed)
    walkLbl.Text="Walk Speed: "..walkSpeed
    if walkActive and humanoid then humanoid.WalkSpeed=walkSpeed end
    showAlert("Walk Speed +"..walkSpeed,walkUp.Position.Y.Offset)
end)
walkDown.MouseButton1Click:Connect(function()
    walkSpeed = math.clamp(walkSpeed-5,minWalkSpeed,maxWalkSpeed)
    walkLbl.Text="Walk Speed: "..walkSpeed
    if walkActive and humanoid then humanoid.WalkSpeed=walkSpeed end
    showAlert("Walk Speed "..walkSpeed,walkDown.Position.Y.Offset)
end)
walkBtn.MouseButton1Click:Connect(function()
    walkActive = not walkActive
    if walkActive then
        if humanoid then humanoid.WalkSpeed=walkSpeed end
        walkBtn.BackgroundColor3 = Color3.fromRGB(204,45,45)
        walkBtn.Text="Walk Speed : ON"
    else
        if humanoid then humanoid.WalkSpeed=16 end
        walkBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        walkBtn.Text="Walk Speed : OFF"
    end
    showAlert(walkBtn.Text,walkBtn.Position.Y.Offset)
end)
