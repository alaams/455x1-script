-- 455x1 script | XENO EXECUTOR
-- UI + Infinity Jump + Fly + Stop + Noclip + WalkSpeed + Guardar/Cargar Config + Botón flotante

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- ================= VARIABLES =================
local humanoid, root
local flying, frozen, noclip, enabledJump, walkActive = false, false, false, false, false
local flySpeed, walkSpeed = 70, 16
local minFlySpeed, maxFlySpeed = 20, 300
local minWalkSpeed, maxWalkSpeed = 16, 500
local control = {F=0,B=0,L=0,R=0,U=0,D=0}

-- Folder para configs
local configFolder = Player:FindFirstChild("XenoConfigs") or Instance.new("Folder", Player)
configFolder.Name = "XenoConfigs"

-- ================= UI PRINCIPAL =================
local gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
gui.Name = "455x1_Xeno"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 580)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(18,8,9)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- ================= TITULO =================
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -10, 0, 24)
title.Position = UDim2.new(0,5,0,5)
title.BackgroundTransparency = 1
title.Text = "455x1 script"
title.TextColor3 = Color3.fromRGB(204,45,45)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

-- ================= FUNCION PARA CREAR BOTONES =================
local function createButton(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -20, 0, 36)
    b.Position = UDim2.new(0,10,0,y)
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(220,220,220)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.BorderSizePixel = 0
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    return b
end

-- Botones principales
local jumpBtn   = createButton("Infinity Jump : OFF", 40)
local stopBtn   = createButton("STOP : OFF", 85)
local flyBtn    = createButton("FLY : OFF", 130)
local noclipBtn = createButton("NOCLIP : OFF", 175)
local walkBtn   = createButton("Walk Speed : OFF", 220)
local saveBtn   = createButton("Guardar Config", 410)
local loadBtn   = createButton("Cargar Config", 455)

-- Fly Speed
local flySpeedLabel = Instance.new("TextLabel", frame)
flySpeedLabel.Position = UDim2.new(0,10,0,260)
flySpeedLabel.Size = UDim2.new(1,-20,0,20)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.TextColor3 = Color3.fromRGB(220,220,220)
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.TextSize = 14
flySpeedLabel.Text = "Fly Speed: "..flySpeed

local flySpeedUp = Instance.new("TextButton", frame)
flySpeedUp.Size = UDim2.new(0,60,0,30)
flySpeedUp.Position = UDim2.new(0.5,10,0,290)
flySpeedUp.BackgroundColor3 = Color3.fromRGB(50,50,50)
flySpeedUp.Text = "+"
flySpeedUp.TextColor3 = Color3.fromRGB(220,220,220)
flySpeedUp.Font = Enum.Font.GothamBold
flySpeedUp.TextSize = 18
Instance.new("UICorner", flySpeedUp).CornerRadius = UDim.new(0,6)

local flySpeedDown = Instance.new("TextButton", frame)
flySpeedDown.Size = UDim2.new(0,60,0,30)
flySpeedDown.Position = UDim2.new(0.5,-70,0,290)
flySpeedDown.BackgroundColor3 = Color3.fromRGB(50,50,50)
flySpeedDown.Text = "-"
flySpeedDown.TextColor3 = Color3.fromRGB(220,220,220)
flySpeedDown.Font = Enum.Font.GothamBold
flySpeedDown.TextSize = 18
Instance.new("UICorner", flySpeedDown).CornerRadius = UDim.new(0,6)

-- Walk Speed
local walkSpeedLabel = Instance.new("TextLabel", frame)
walkSpeedLabel.Position = UDim2.new(0,10,0,330)
walkSpeedLabel.Size = UDim2.new(1,-20,0,20)
walkSpeedLabel.BackgroundTransparency = 1
walkSpeedLabel.TextColor3 = Color3.fromRGB(220,220,220)
walkSpeedLabel.Font = Enum.Font.Gotham
walkSpeedLabel.TextSize = 14
walkSpeedLabel.Text = "Walk Speed: "..walkSpeed

local walkSpeedUp = Instance.new("TextButton", frame)
walkSpeedUp.Size = UDim2.new(0,60,0,30)
walkSpeedUp.Position = UDim2.new(0.5,10,0,360)
walkSpeedUp.BackgroundColor3 = Color3.fromRGB(50,50,50)
walkSpeedUp.Text = "+"
walkSpeedUp.TextColor3 = Color3.fromRGB(220,220,220)
walkSpeedUp.Font = Enum.Font.GothamBold
walkSpeedUp.TextSize = 18
Instance.new("UICorner", walkSpeedUp).CornerRadius = UDim.new(0,6)

local walkSpeedDown = Instance.new("TextButton", frame)
walkSpeedDown.Size = UDim2.new(0,60,0,30)
walkSpeedDown.Position = UDim2.new(0.5,-70,0,360)
walkSpeedDown.BackgroundColor3 = Color3.fromRGB(50,50,50)
walkSpeedDown.Text = "-"
walkSpeedDown.TextColor3 = Color3.fromRGB(220,220,220)
walkSpeedDown.Font = Enum.Font.GothamBold
walkSpeedDown.TextSize = 18
Instance.new("UICorner", walkSpeedDown).CornerRadius = UDim.new(0,6)

-- ================= BOTON FLOTANTE DE APAGAR UI =================
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,50,0,50)
toggleBtn.Position = UDim2.new(0,5,0,200)
toggleBtn.Text = "UI"
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(204,45,45)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 14
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,25)

-- Drag del botón flotante
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
    humanoid.BreakJointsOnDeath = false
    if walkActive then humanoid.WalkSpeed = walkSpeed end
end

if Player.Character then onChar(Player.Character) end
Player.CharacterAdded:Connect(onChar)

-- Infinity Jump
jumpBtn.MouseButton1Click:Connect(function()
    enabledJump = not enabledJump
    jumpBtn.Text = enabledJump and "Infinity Jump : ON" or "Infinity Jump : OFF"
    jumpBtn.BackgroundColor3 = enabledJump and Color3.fromRGB(204,45,45) or Color3.fromRGB(50,50,50)
end)
UIS.JumpRequest:Connect(function()
    if enabledJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Fly
local bv, bg
local function startFly()
    if not root then return end
    bv = Instance.new("BodyVelocity", root)
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)
    bg = Instance.new("BodyGyro", root)
    bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
    RunService:BindToRenderStep("Fly", 0, function()
        if not root then return end
        local move = (workspace.CurrentCamera.CFrame.LookVector * (control.F + control.B) +
                      workspace.CurrentCamera.CFrame.RightVector * (control.R + control.L) +
                      workspace.CurrentCamera.CFrame.UpVector * (control.U + control.D))
        bv.Velocity = move * flySpeed
        bg.CFrame = workspace.CurrentCamera.CFrame
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
end)

-- Stop
stopBtn.MouseButton1Click:Connect(function()
    frozen = not frozen
    if frozen then
        flying = false
        stopFly()
        if root then root.Anchored = true end
        if humanoid then humanoid.PlatformStand = true end
        stopBtn.Text = "STOP : ON"
        stopBtn.BackgroundColor3 = Color3.fromRGB(204,45,45)
    else
        if root then root.Anchored = false end
        if humanoid then humanoid.PlatformStand = false end
        stopBtn.Text = "STOP : OFF"
        stopBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    end
end)

-- Noclip
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = noclip and "NOCLIP : ON" or "NOCLIP : OFF"
    noclipBtn.BackgroundColor3 = noclip and Color3.fromRGB(204,45,45) or Color3.fromRGB(50,50,50)
end)
RunService.Stepped:Connect(function()
    if noclip and Player.Character then
        for _,v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- Fly Speed
local function updateFlySpeedLabel() flySpeedLabel.Text = "Fly Speed: "..flySpeed end
flySpeedUp.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed+5,minFlySpeed,maxFlySpeed)
    updateFlySpeedLabel()
end)
flySpeedDown.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed-5,minFlySpeed,maxFlySpeed)
    updateFlySpeedLabel()
end)

-- Walk Speed
local function updateWalkSpeedLabel()
    walkSpeedLabel.Text = "Walk Speed: "..walkSpeed
    if humanoid and walkActive then humanoid.WalkSpeed = walkSpeed end
end
walkSpeedUp.MouseButton1Click:Connect(function()
    walkSpeed = math.clamp(walkSpeed+5,minWalkSpeed,maxWalkSpeed)
    updateWalkSpeedLabel()
end)
walkSpeedDown.MouseButton1Click:Connect(function()
    walkSpeed = math.clamp(walkSpeed-5,minWalkSpeed,maxWalkSpeed)
    updateWalkSpeedLabel()
end)
walkBtn.MouseButton1Click:Connect(function()
    walkActive = not walkActive
    if walkActive then
        if humanoid then humanoid.WalkSpeed = walkSpeed end
        walkBtn.Text = "Walk Speed : ON"
        walkBtn.BackgroundColor3 = Color3.fromRGB(204,45,45)
    else
        if humanoid then humanoid.WalkSpeed = 16 end
        walkBtn.Text = "Walk Speed : OFF"
        walkBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    end
end)

-- ================= GUARDAR / CARGAR CONFIG =================
saveBtn.MouseButton1Click:Connect(function()
    local configName = tostring(os.time()) -- nombre único
    local conf = Instance.new("Folder", configFolder)
    conf.Name = configName
    conf:SetAttribute("FlySpeed", flySpeed)
    conf:SetAttribute("WalkSpeed", walkSpeed)
    conf:SetAttribute("FlyEnabled", flying)
    conf:SetAttribute("StopEnabled", frozen)
    conf:SetAttribute("JumpEnabled", enabledJump)
    conf:SetAttribute("NoclipEnabled", noclip)
    conf:SetAttribute("WalkActive", walkActive)
    conf:SetAttribute("UIX", frame.Position.X.Offset)
    conf:SetAttribute("UIY", frame.Position.Y.Offset)
    print("Configuración guardada: "..configName)
end)

loadBtn.MouseButton1Click:Connect(function()
    local conf = configFolder:FindFirstChildOfClass("Folder")
    if conf then
        flySpeed = conf:GetAttribute("FlySpeed") or flySpeed
        walkSpeed = conf:GetAttribute("WalkSpeed") or walkSpeed
        flying = conf:GetAttribute("FlyEnabled") or false
        frozen = conf:GetAttribute("StopEnabled") or false
        enabledJump = conf:GetAttribute("JumpEnabled") or false
        noclip = conf:GetAttribute("NoclipEnabled") or false
        walkActive = conf:GetAttribute("WalkActive") or false
        frame.Position = UDim2.new(0, conf:GetAttribute("UIX") or 50, 0, conf:GetAttribute("UIY") or 50)

        updateFlySpeedLabel()
        updateWalkSpeedLabel()

        if flying then startFly() else stopFly() end
        if frozen then
            if root then root.Anchored = true end
            if humanoid then humanoid.PlatformStand = true end
        else
            if root then root.Anchored = false end
            if humanoid then humanoid.PlatformStand = false end
        end

        noclipBtn.Text = noclip and "NOCLIP : ON" or "NOCLIP : OFF"
        noclipBtn.BackgroundColor3 = noclip and Color3.fromRGB(204,45,45) or Color3.fromRGB(50,50,50)

        walkBtn.Text = walkActive and "Walk Speed : ON" or "Walk Speed : OFF"
        walkBtn.BackgroundColor3 = walkActive and Color3.fromRGB(204,45,45) or Color3.fromRGB(50,50,50)

        jumpBtn.Text = enabledJump and "Infinity Jump : ON" or "Infinity Jump : OFF"
        jumpBtn.BackgroundColor3 = enabledJump and Color3.fromRGB(204,45,45) or Color3.fromRGB(50,50,50)

        stopBtn.Text = frozen and "STOP : ON" or "STOP : OFF"
        stopBtn.BackgroundColor3 = frozen and Color3.fromRGB(204,45,45) or Color3.fromRGB(50,50,50)

        print("Configuración cargada: "..conf.Name)
    else
        print("No hay configuraciones guardadas")
    end
end)
