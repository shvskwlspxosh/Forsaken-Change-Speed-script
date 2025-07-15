local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "SpeedGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0, 50, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local toggleGuiButton = Instance.new("TextButton")
toggleGuiButton.Size = UDim2.new(0, 120, 0, 30)
toggleGuiButton.Position = UDim2.new(0, 50, 0, 100)
toggleGuiButton.Text = "Hide GUI"
toggleGuiButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleGuiButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleGuiButton.Active = true
toggleGuiButton.Draggable = true
toggleGuiButton.Parent = gui

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 180, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 10)
speedBox.PlaceholderText = "Enter speed"
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.ClearTextOnFocus = false
speedBox.Parent = frame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 180, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 45)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Text = "Current speed: N/A"
speedLabel.Parent = frame

local capToggle = Instance.new("TextButton")
capToggle.Size = UDim2.new(0, 180, 0, 30)
capToggle.Position = UDim2.new(0, 10, 0, 75)
capToggle.Text = "Change Speed Cap?: false"
capToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
capToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
capToggle.Parent = frame

local returnNormalButton = Instance.new("TextButton")
returnNormalButton.Size = UDim2.new(0, 180, 0, 30)
returnNormalButton.Position = UDim2.new(0, 10, 0, 110)
returnNormalButton.Text = "Return to Normal"
returnNormalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
returnNormalButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
returnNormalButton.Parent = frame

local safeModeButton = Instance.new("TextButton")
safeModeButton.Size = UDim2.new(0, 180, 0, 30)
safeModeButton.Position = UDim2.new(0, 10, 0, 145)
safeModeButton.Text = "Safe Mode: OFF"
safeModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
safeModeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
safeModeButton.Parent = frame

local capEnabled = false
local safeMode = false
local targetSpeed
local normalWalkSpeed = 12
local normalSprintSpeed = 26
local defaultBaseSpeed = 12

local function detectDefaultSpeed()
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if humanoid:GetAttribute("BaseSpeed") then
                defaultBaseSpeed = humanoid:GetAttribute("BaseSpeed")
            else
                defaultBaseSpeed = 12
            end
            normalWalkSpeed = defaultBaseSpeed
        end
    end
end

player.CharacterAdded:Connect(function()
    task.wait(0.2)
    detectDefaultSpeed()
end)

detectDefaultSpeed()

local function getSprintValue()
    repeat task.wait() until player.Character and player.Character:FindFirstChild("SpeedMultipliers")
    local folder = player.Character:WaitForChild("SpeedMultipliers")

    local sprint = folder:FindFirstChild("Sprinting")
    if not sprint then
        sprint = Instance.new("NumberValue")
        sprint.Name = "Sprinting"
        sprint.Value = 1
        sprint.Parent = folder
    end
    return sprint
end

local function getCapValue()
    repeat task.wait() until player.Character and player.Character:FindFirstChild("SpeedCapMultipliers")
    return player.Character:FindFirstChild("SpeedCapMultipliers")
end

local function setSpeed(value)
    if safeMode and value > 30 then
        value = 30 
    end
    targetSpeed = value

    local sprintValue = getSprintValue()
    if sprintValue then
        sprintValue.Value = value
    end

    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        hum.WalkSpeed = value
        hum:SetAttribute("BaseSpeed", value)
    end
end

speedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and tonumber(speedBox.Text) then
        setSpeed(tonumber(speedBox.Text))
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if targetSpeed and player.Character then
            local sprintValue = getSprintValue()
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if sprintValue and sprintValue.Value ~= targetSpeed then
                sprintValue.Value = targetSpeed
            end
            if humanoid then
                if humanoid.WalkSpeed ~= targetSpeed then
                    humanoid.WalkSpeed = targetSpeed
                end
                if humanoid:GetAttribute("BaseSpeed") ~= targetSpeed then
                    humanoid:SetAttribute("BaseSpeed", targetSpeed)
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                speedLabel.Text = "Current speed: " .. tostring(math.floor(humanoid.WalkSpeed))
            end
        end
    end
end)

capToggle.MouseButton1Click:Connect(function()
    capEnabled = not capEnabled
    local cap = getCapValue()
    if cap then
        for _, v in pairs(cap:GetChildren()) do
            if v:IsA("BoolValue") then
                v.Value = capEnabled
            end
        end
    end
    capToggle.Text = "Change Speed Cap?: " .. tostring(capEnabled)
end)

returnNormalButton.MouseButton1Click:Connect(function()
    local sprintValue = getSprintValue()
    if sprintValue then
        sprintValue.Value = 1
    end

    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        hum.WalkSpeed = 12
        hum:SetAttribute("BaseSpeed", 12)
    end

    targetSpeed = nil
    speedBox.Text = ""
end)

safeModeButton.MouseButton1Click:Connect(function()
    safeMode = not safeMode
    safeModeButton.Text = "Safe Mode: " .. (safeMode and "ON" or "OFF")
end)

toggleGuiButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleGuiButton.Text = frame.Visible and "Hide GUI" or "Show GUI"
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F6 then
        frame.Visible = not frame.Visible
        toggleGuiButton.Text = frame.Visible and "Hide GUI" or "Show GUI"
    end
end)
