local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "SpeedGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 280)
frame.Position = UDim2.new(0, 50, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local walkSpeedBox = Instance.new("TextBox")
walkSpeedBox.Size = UDim2.new(0, 180, 0, 30)
walkSpeedBox.Position = UDim2.new(0, 10, 0, 10)
walkSpeedBox.PlaceholderText = "Enter walking speed"
walkSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
walkSpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
walkSpeedBox.ClearTextOnFocus = false
walkSpeedBox.Parent = frame

local runSpeedBox = Instance.new("TextBox")
runSpeedBox.Size = UDim2.new(0, 180, 0, 30)
runSpeedBox.Position = UDim2.new(0, 10, 0, 50)
runSpeedBox.PlaceholderText = "Enter running (sprint) speed"
runSpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
runSpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
runSpeedBox.ClearTextOnFocus = false
runSpeedBox.Parent = frame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 200, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 90)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Text = "Current speed: N/A"
speedLabel.Parent = frame

local capToggle = Instance.new("TextButton")
capToggle.Size = UDim2.new(0, 200, 0, 30)
capToggle.Position = UDim2.new(0, 10, 0, 120)
capToggle.Text = "Change Speed Cap?: false"
capToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
capToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
capToggle.Parent = frame

local returnNormalButton = Instance.new("TextButton")
returnNormalButton.Size = UDim2.new(0, 200, 0, 30)
returnNormalButton.Position = UDim2.new(0, 10, 0, 160)
returnNormalButton.Text = "Return to Normal"
returnNormalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
returnNormalButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
returnNormalButton.Parent = frame

local safeModeButton = Instance.new("TextButton")
safeModeButton.Size = UDim2.new(0, 200, 0, 30)
safeModeButton.Position = UDim2.new(0, 10, 0, 200)
safeModeButton.Text = "Safe Mode: OFF"
safeModeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
safeModeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
safeModeButton.Parent = frame

local toggleGuiButton = Instance.new("ImageButton")
toggleGuiButton.Size = UDim2.new(0, 60, 0, 60)
toggleGuiButton.Position = UDim2.new(0, 260, 0, 150)
toggleGuiButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleGuiButton.Image = "rbxassetid://7072726234" -- default image
toggleGuiButton.Parent = gui
toggleGuiButton.Active = true
toggleGuiButton.Draggable = true

local toggleImgUrlBox = Instance.new("TextBox")
toggleImgUrlBox.Size = UDim2.new(0, 200, 0, 30)
toggleImgUrlBox.Position = UDim2.new(0, 330, 0, 175)
toggleImgUrlBox.PlaceholderText = "Paste image URL here"
toggleImgUrlBox.TextColor3 = Color3.fromRGB(255,255,255)
toggleImgUrlBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleImgUrlBox.ClearTextOnFocus = false
toggleImgUrlBox.Parent = gui

-- Variables
local capEnabled = false
local safeMode = false
local walkingSpeed = 12
local runningSpeed = 28

local function detectBaseSpeed()
	if player.Character then
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			local baseSpeed = humanoid:GetAttribute("BaseSpeed")
			if baseSpeed then
				walkingSpeed = baseSpeed
			else
				walkingSpeed = 12
			end
		end
	end
end

player.CharacterAdded:Connect(function()
	task.wait(0.1)
	detectBaseSpeed()
end)

detectBaseSpeed()

local function getSprintValue()
	repeat task.wait() until player.Character and player.Character:FindFirstChild("SpeedMultipliers")
	local folder = player.Character:WaitForChild("SpeedMultipliers")

	local sprint = folder:FindFirstChild("Sprinting")
	if not sprint then
		sprint = Instance.new("NumberValue")
		sprint.Name = "Sprinting"
		sprint.Value = runningSpeed
		sprint.Parent = folder
	end
	return sprint
end

local function getCapValue()
	repeat task.wait() until player.Character and player.Character:FindFirstChild("SpeedCapMultipliers")
	return player.Character:FindFirstChild("SpeedCapMultipliers")
end

local function setWalkingSpeed(value)
	local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = value
	end
end

local function setSprintSpeed(value)
	local sprintValue = getSprintValue()
	if sprintValue then
		sprintValue.Value = value
	end
end

walkSpeedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed and tonumber(walkSpeedBox.Text) then
		local val = tonumber(walkSpeedBox.Text)
		if safeMode and val > 30 then val = 30 end
		walkingSpeed = val
		setWalkingSpeed(walkingSpeed)
	end
end)

runSpeedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed and tonumber(runSpeedBox.Text) then
		local val = tonumber(runSpeedBox.Text)
		if safeMode and val > 30 then val = 30 end
		runningSpeed = val
		setSprintSpeed(runningSpeed)
	end
end)

task.spawn(function()
	while true do
		task.wait(0.2)
		if player.Character then
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				speedLabel.Text = "Current speed: " .. tostring(math.floor(humanoid.WalkSpeed))
			end
		end
	end
end)

-- Speed Cap toggle
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

-- Return to normal button
returnNormalButton.MouseButton1Click:Connect(function()
	-- Reset sprint value and walk speed
	setSprintSpeed(runningSpeed)
	setWalkingSpeed(walkingSpeed)
	walkSpeedBox.Text = tostring(walkingSpeed)
	runSpeedBox.Text = tostring(runningSpeed)
end)

safeModeButton.MouseButton1Click:Connect(function()
	safeMode = not safeMode
	safeModeButton.Text = "Safe Mode: " .. (safeMode and "ON" or "OFF")
	if safeMode then
		-- Clamp speeds if too high
		if walkingSpeed > 30 then
			walkingSpeed = 30
			setWalkingSpeed(walkingSpeed)
			walkSpeedBox.Text = tostring(walkingSpeed)
		end
		if runningSpeed > 30 then
			runningSpeed = 30
			setSprintSpeed(runningSpeed)
			runSpeedBox.Text = tostring(runningSpeed)
		end
	end
end)

toggleGuiButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)


toggleImgUrlBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local url = toggleImgUrlBox.Text
		if url ~= "" then
			pcall(function()
				toggleGuiButton.Image = url
			end)
		end
	end
end)
