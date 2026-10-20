local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local PH = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/pickapicksmm/Pickas-Hub/refs/heads/main/Libray.src/PHLibrary.lua"
))()

local Window = PH:CreateWindow({
    Title = "Picka's Hub",
})

local State = {
    Aimbot = false,
    TargetPart = "Head",
    Smoothness = 0.15,
    FOVCircle = false,
    FOVRadius = 150,
    FOVTargeting = false,
    TeamCheck = false,
    TargetSnapline = false,
    Crosshair = false,

    WalkSpeed = 16,
    JumpPower = 50,
    InfiniteJump = false,
    Invisible = false,
    NoClip = false,
    Gravity = 196.2,

    PlayerESP = false,
    ESPOptions = {},

    FullBright = false,
    NoFog = false,
    CustomFOV = 70,
    AntiLag = false,
    FPSBoost = false,
}

-- Main
local Main = Window:AddTab({
    Title = "Main",
    Icon = "crosshair",
})

-- Player
local PlayerTab = Window:AddTab({
    Title = "Player",
    Icon = "user",
})

-- Misc
local Misc = Window:AddTab({
    Title = "Misc",
    Icon = "settings",
})

-- AIMBOT
local AimbotEnabled = false

Main:AddToggle({
    Title = "Aimbot",
    Default = false,
    Callback = function(Value)
        AimbotEnabled = Value
        State.Aimbot = Value
    end
})

Main:AddDropdown({
    Title = "Target Selection",
    Options = {
        "Head",
        "Body",
        "Foot"
    },
    Default = "Head",
    Callback = function(Value)
        State.TargetPart = Value
    end
})

Main:AddSlider({
    Title = "Smoothness",
    Min = 0.01,
    Max = 1,
    Step = 0.01,
    Default = 0.15,
    Callback = function(Value)
        State.Smoothness = Value
    end
})

Main:AddToggle({
    Title = "FOV Circle",
    Default = false,
    Callback = function(Value)
        State.FOVCircle = Value
    end
})

Main:AddSlider({
    Title = "FOV Radius",
    Min = 25,
    Max = 600,
    Step = 1,
    Default = 150,
    Callback = function(Value)
        State.FOVRadius = Value
    end
})

Main:AddToggle({
    Title = "FOV Targeting",
    Default = false,
    Callback = function(Value)
        State.FOVTargeting = Value
    end
})

Main:AddToggle({
    Title = "Team Check",
    Default = false,
    Callback = function(Value)
        State.TeamCheck = Value
    end
})

Main:AddToggle({
    Title = "Target Snapline",
    Default = false,
    Callback = function(Value)
        State.TargetSnapline = Value
    end
})

Main:AddToggle({
    Title = "Crosshair",
    Default = false,
    Callback = function(Value)
        State.Crosshair = Value
    end
})

-- PLAYER

PlayerTab:AddInput({
    Title = "WalkSpeed",
    Placeholder = "16",
    Callback = function(Value)
        local number = tonumber(Value)

        if number then
            State.WalkSpeed = math.clamp(number, 0, 500)

            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.WalkSpeed = State.WalkSpeed
            end
        end
    end
})

PlayerTab:AddToggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        State.InfiniteJump = Value
    end
})

PlayerTab:AddInput({
    Title = "Jump Power",
    Placeholder = "50",
    Callback = function(Value)
        local number = tonumber(Value)

        if number then
            State.JumpPower = math.clamp(number, 0, 300)

            local character = LocalPlayer.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid.JumpPower = State.JumpPower
            end
        end
    end
})

PlayerTab:AddToggle({
    Title = "Invisible",
    Default = false,
    Callback = function(Value)
        State.Invisible = Value
    end
})

PlayerTab:AddToggle({
    Title = "NoClip",
    Default = false,
    Callback = function(Value)
        State.NoClip = Value
    end
})

PlayerTab:AddSlider({
    Title = "Custom Gravity",
    Min = 0,
    Max = 300,
    Step = 1,
    Default = 196,
    Callback = function(Value)
        State.Gravity = Value
        Workspace.Gravity = Value
    end
})

-- MISC

Misc:AddToggle({
    Title = "Player ESP",
    Default = false,
    Callback = function(Value)
        State.PlayerESP = Value
    end
})

Misc:AddDropdown({
    Title = "ESP",
    Options = {
        "Distance",
        "Health Bar",
        "Names",
        "Chams",
        "Snaplines"
    },
    Default = {},
    Multi = true,
    Callback = function(Values)
        State.ESPOptions = {}

        if typeof(Values) == "table" then
            for Key, Value in pairs(Values) do
                if typeof(Key) == "number" then
                    State.ESPOptions[Value] = true
                elseif Value == true then
                    State.ESPOptions[Key] = true
                end
            end
        end
    end
})

Misc:AddToggle({
    Title = "Full Bright",
    Default = false,
    Callback = function(Value)
        State.FullBright = Value
    end
})

Misc:AddToggle({
    Title = "No Fog",
    Default = false,
    Callback = function(Value)
        State.NoFog = Value
    end
})

Misc:AddSlider({
    Title = "Custom FOV",
    Min = 40,
    Max = 120,
    Step = 1,
    Default = 70,
    Callback = function(Value)
        State.CustomFOV = Value
        Camera.FieldOfView = Value
    end
})

Misc:AddToggle({
    Title = "Anti Lag",
    Default = false,
    Callback = function(Value)
        State.AntiLag = Value
    end
})

Misc:AddToggle({
    Title = "FPS Boost",
    Default = false,
    Callback = function(Value)
        State.FPSBoost = Value
    end
})

Misc:AddButton({
    Title = "Rejoin Server",
    ButtonText = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(
            game.PlaceId,
            LocalPlayer
        )
    end
})

Misc:AddButton({
    Title = "Server Hop",
    ButtonText = "Hop",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local HttpService = game:GetService("HttpService")

        task.spawn(function()
            local ok, serverId = pcall(function()
                local url = "https://games.roblox.com/v1/games/"
                    .. game.PlaceId
                    .. "/servers/Public?sortOrder=Asc&limit=100"

                local data = HttpService:JSONDecode(game:HttpGet(url))
                local servers = {}

                for _, server in ipairs(data.data or {}) do
                    if server.id ~= game.JobId
                        and server.playing < server.maxPlayers then
                        table.insert(servers, server.id)
                    end
                end

                if #servers == 0 then
                    return nil
                end

                return servers[math.random(1, #servers)]
            end)

            if ok and serverId then
                PH:Notify({ Title = "Server Hop", Content = "Joining another server...", Type = "Info" })
                TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer)
            else
                PH:Notify({ Title = "Server Hop", Content = "No other server found.", Type = "Warning" })
            end
        end)
    end
})

-- AIM SYSTEM

local function getTargetPart(character)
    if not character then
        return nil
    end

    if State.TargetPart == "Head" then
        return character:FindFirstChild("Head")
    end

    if State.TargetPart == "Body" then
        return character:FindFirstChild("HumanoidRootPart")
    end

    if State.TargetPart == "Foot" then
        return character:FindFirstChild("LeftFoot")
            or character:FindFirstChild("RightFoot")
            or character:FindFirstChild("Left Leg")
            or character:FindFirstChild("Right Leg")
    end

    return character:FindFirstChild("Head")
end

local function validTarget(player)
    if player == LocalPlayer then
        return false
    end

    if State.TeamCheck and player.Team == LocalPlayer.Team then
        return false
    end

    local character = player.Character

    if not character then
        return false
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid or humanoid.Health <= 0 then
        return false
    end

    return getTargetPart(character) ~= nil
end

local function getClosestTarget()
    local center = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if validTarget(player) then
            local part = getTargetPart(player.Character)

            if part then
                local screenPosition, visible =
                    Camera:WorldToViewportPoint(part.Position)

                if visible and screenPosition.Z > 0 then
                    local position = Vector2.new(
                        screenPosition.X,
                        screenPosition.Y
                    )

                    local distance = (position - center).Magnitude

                    if State.FOVTargeting
                        and distance > State.FOVRadius then
                        continue
                    end

                    if distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end

local function aimAt(player)
    if not player then
        return
    end

    local character = player.Character
    local part = getTargetPart(character)

    if not part then
        return
    end

    local cameraPosition = Camera.CFrame.Position

    local targetCFrame = CFrame.lookAt(
        cameraPosition,
        part.Position
    )

    local smoothness = math.clamp(
        State.Smoothness,
        0.01,
        1
    )

    Camera.CFrame = Camera.CFrame:Lerp(
        targetCFrame,
        smoothness
    )
end

-- FOV CIRCLE

local FOVGui
local FOVCircle

local function createFOV()
    if FOVGui then
        return
    end

    FOVGui = Instance.new("ScreenGui")
    FOVGui.Name = "PickasFOV"
    FOVGui.ResetOnSpawn = false
    FOVGui.IgnoreGuiInset = true
    FOVGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    FOVCircle = Instance.new("Frame")
    FOVCircle.Name = "Circle"
    FOVCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    FOVCircle.BackgroundTransparency = 1
    FOVCircle.BorderSizePixel = 0
    FOVCircle.Parent = FOVGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = FOVCircle

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 1.5
    Stroke.Color = Color3.fromRGB(157, 0, 255)
    Stroke.Parent = FOVCircle
end

local function updateFOV()
    if not State.FOVCircle then
        if FOVGui then
            FOVGui.Enabled = false
        end

        return
    end

    createFOV()

    FOVGui.Enabled = true

    FOVCircle.Size = UDim2.fromOffset(
        State.FOVRadius * 2,
        State.FOVRadius * 2
    )

    FOVCircle.Position = UDim2.fromScale(
        0.5,
        0.5
    )
end

-- CROSSHAIR

local CrosshairGui

local function createCrosshair()
    if CrosshairGui then
        return
    end

    CrosshairGui = Instance.new("ScreenGui")
    CrosshairGui.Name = "PickasCrosshair"
    CrosshairGui.ResetOnSpawn = false
    CrosshairGui.IgnoreGuiInset = true
    CrosshairGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local horizontal = Instance.new("Frame")
    horizontal.Name = "Horizontal"
    horizontal.AnchorPoint = Vector2.new(0.5, 0.5)
    horizontal.Position = UDim2.fromScale(0.5, 0.5)
    horizontal.Size = UDim2.fromOffset(18, 2)
    horizontal.BorderSizePixel = 0
    horizontal.BackgroundColor3 = Color3.fromRGB(157, 0, 255)
    horizontal.Parent = CrosshairGui

    local vertical = Instance.new("Frame")
    vertical.Name = "Vertical"
    vertical.AnchorPoint = Vector2.new(0.5, 0.5)
    vertical.Position = UDim2.fromScale(0.5, 0.5)
    vertical.Size = UDim2.fromOffset(2, 18)
    vertical.BorderSizePixel = 0
    vertical.BackgroundColor3 = Color3.fromRGB(157, 0, 255)
    vertical.Parent = CrosshairGui
end

local function updateCrosshair()
    if not State.Crosshair then
        if CrosshairGui then
            CrosshairGui.Enabled = false
        end

        return
    end

    createCrosshair()
    CrosshairGui.Enabled = true
end

-- SNAPLINES (Target Snapline + ESP Snaplines)
-- Drawn with GUI frames so it works on every executor.

local SnapGui
local SnapLines = {}
local SnapUsed = {}

local function createSnapGui()
    if SnapGui then
        return
    end

    SnapGui = Instance.new("ScreenGui")
    SnapGui.Name = "PickasSnaplines"
    SnapGui.ResetOnSpawn = false
    SnapGui.IgnoreGuiInset = true
    SnapGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function snapLine(key, from, to, color)
    createSnapGui()

    local line = SnapLines[key]

    if not line then
        line = Instance.new("Frame")
        line.Name = key
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.BorderSizePixel = 0
        line.Parent = SnapGui
        SnapLines[key] = line
    end

    local delta = to - from

    line.Position = UDim2.fromOffset(
        (from.X + to.X) / 2,
        (from.Y + to.Y) / 2
    )
    line.Size = UDim2.fromOffset(delta.Magnitude, 1.5)
    line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
    line.BackgroundColor3 = color
    line.Visible = true

    SnapUsed[key] = true
end

local function updateSnaplines(target)
    SnapUsed = {}

    local viewport = Camera.ViewportSize
    local origin = Vector2.new(viewport.X / 2, viewport.Y)

    -- Target Snapline: line to the current aimbot target
    if State.TargetSnapline and target then
        local part = getTargetPart(target.Character)

        if part then
            local screen = Camera:WorldToViewportPoint(part.Position)

            if screen.Z > 0 then
                snapLine(
                    "Target",
                    origin,
                    Vector2.new(screen.X, screen.Y),
                    Color3.fromRGB(255, 60, 60)
                )
            end
        end
    end

    -- ESP Snaplines: line to every other player
    if State.PlayerESP and State.ESPOptions["Snaplines"] then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                local humanoid = character
                    and character:FindFirstChildOfClass("Humanoid")
                local root = character
                    and character:FindFirstChild("HumanoidRootPart")

                if root and humanoid and humanoid.Health > 0 then
                    local screen = Camera:WorldToViewportPoint(root.Position)

                    if screen.Z > 0 then
                        snapLine(
                            "ESP_" .. player.UserId,
                            origin,
                            Vector2.new(screen.X, screen.Y),
                            Color3.fromRGB(157, 0, 255)
                        )
                    end
                end
            end
        end
    end

    for key, line in pairs(SnapLines) do
        if not SnapUsed[key] then
            line.Visible = false
        end
    end
end

-- INVISIBLE

local function updateInvisible()
    local character = LocalPlayer.Character

    if not character then
        return
    end

    for _, object in ipairs(character:GetDescendants()) do
        if object:IsA("BasePart") then
            if object.Name ~= "HumanoidRootPart" then
                object.LocalTransparencyModifier =
                    State.Invisible and 1 or 0
            end
        end
    end
end

-- NOCLIP

local function updateNoClip()
    if not State.NoClip then
        return
    end

    local character = LocalPlayer.Character

    if not character then
        return
    end

    for _, object in ipairs(character:GetDescendants()) do
        if object:IsA("BasePart") then
            object.CanCollide = false
        end
    end
end

-- PLAYER ESP

local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "PickasESP"
ESPFolder.Parent = Workspace

local function clearESP()
    for _, object in ipairs(ESPFolder:GetChildren()) do
        object:Destroy()
    end
end

local function createESP(player)
    if player == LocalPlayer then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return
    end

    local options = State.ESPOptions

    if options["Chams"] then
        local highlight = Instance.new("Highlight")
        highlight.Name = "Chams_" .. player.Name
        highlight.Adornee = character
        highlight.FillTransparency = 0.65
        highlight.OutlineTransparency = 0
        highlight.FillColor = Color3.fromRGB(157, 0, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Parent = ESPFolder
    end

    if options["Names"]
        or options["Distance"]
        or options["Health Bar"] then

        local head = character:FindFirstChild("Head")

        if not head then
            return
        end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP_" .. player.Name
        billboard.Adornee = head
        billboard.Size = UDim2.fromOffset(180, 70)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = ESPFolder

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.fromScale(1, 1)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0
        label.TextScaled = false
        label.TextSize = 13
        label.Font = Enum.Font.GothamBold
        label.Parent = billboard

        local text = ""

        if options["Names"] then
            text = player.Name
        end

        if options["Distance"] then
            local root =
                character:FindFirstChild("HumanoidRootPart")

            local myCharacter = LocalPlayer.Character
            local myRoot =
                myCharacter and
                myCharacter:FindFirstChild("HumanoidRootPart")

            if root and myRoot then
                local distance =
                    math.floor((root.Position - myRoot.Position).Magnitude)

                if text ~= "" then
                    text = text .. "\n"
                end

                text = text .. distance .. " studs"
            end
        end

        if options["Health Bar"] then
            if text ~= "" then
                text = text .. "\n"
            end

            text = text ..
                math.floor(humanoid.Health) ..
                " / " ..
                math.floor(humanoid.MaxHealth)
        end

        label.Text = text
    end
end

local function updateESP()
    clearESP()

    if not State.PlayerESP then
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        createESP(player)
    end
end

-- LIGHTING

local function updateLighting()
    if State.FullBright then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient =
            Color3.fromRGB(255, 255, 255)
    end

    if State.NoFog then
        Lighting.FogStart = 100000
        Lighting.FogEnd = 100000
    end
end

-- ANTI LAG / FPS BOOST

local function updatePerformance()
    if not State.AntiLag and not State.FPSBoost then
        return
    end

    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("ParticleEmitter")
            or object:IsA("Trail")
            or object:IsA("Beam") then

            object.Enabled = false
        elseif State.FPSBoost
            and object:IsA("BasePart") then

            object.Material = Enum.Material.Plastic
        end
    end
end

-- CHARACTER SETUP

local function setupCharacter(character)
    local humanoid =
        character:WaitForChild("Humanoid", 5)

    if not humanoid then
        return
    end

    humanoid.WalkSpeed = State.WalkSpeed
    humanoid.JumpPower = State.JumpPower

    updateInvisible()
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)

if LocalPlayer.Character then
    task.spawn(setupCharacter, LocalPlayer.Character)
end

-- INFINITE JUMP

local UserInputService =
    game:GetService("UserInputService")

UserInputService.JumpRequest:Connect(function()
    if not State.InfiniteJump then
        return
    end

    local character = LocalPlayer.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )
    end
end)

-- ESP REFRESH

Players.PlayerAdded:Connect(function()
    if State.PlayerESP then
        task.wait(0.5)
        updateESP()
    end
end)

Players.PlayerRemoving:Connect(function()
    if State.PlayerESP then
        updateESP()
    end
end)

-- MAIN LOOP
-- Aimbot is evaluated after the camera update.

RunService:BindToRenderStep(
    "PickasHubAimAssist",
    Enum.RenderPriority.Camera.Value + 1,
    function()
        Camera = Workspace.CurrentCamera

        updateFOV()
        updateCrosshair()

        local target = nil

        if State.Aimbot or State.TargetSnapline then
            target = getClosestTarget()
        end

        if State.Aimbot and target then
            aimAt(target)
        end

        updateSnaplines(target)

        if State.Invisible then
            updateInvisible()
        end

        if State.NoClip then
            updateNoClip()
        end
    end
)

task.spawn(function()
    while task.wait(0.5) do
        if State.PlayerESP then
            updateESP()
        elseif #ESPFolder:GetChildren() > 0 then
            clearESP()
        end

        updateLighting()
        updatePerformance()
    end
end)
