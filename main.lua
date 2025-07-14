local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "SpeedGui"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 50, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local toggleGuiButton = Instance.new("TextButton")
toggleGuiButton.Size = UDim2.new(0, 200, 0, 30)
toggleGuiButton.Position = UDim2.new(0, 50, 0, 120)
toggleGuiButton.Text = "Hide GUI"
toggleGuiButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleGuiButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleGuiButton.Parent = gui

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 180, 0, 30)
speedBox.Position = UDim2.new(0, 10, 0, 10)
speedBox.PlaceholderText = "Enter speed (e.g. 25)"
speedBox.TextColor3 = Color3.fromRGB(255,255,255)
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
capToggle.TextColor3 = Color3.fromRGB(255,255,255)
capToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
capToggle.Parent = frame

-- Logic
local capEnabled = false
local targetSpeed

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

speedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed and tonumber(speedBox.Text) then
		targetSpeed = tonumber(speedBox.Text)
		local sprintValue = getSprintValue()
		if sprintValue then
			sprintValue.Value = targetSpeed
			speedLabel.Text = "Current speed: " .. targetSpeed
		end
	end
end)

task.spawn(function()
	while true do
		task.wait(0.001)
		if targetSpeed and player.Character then
			local sprintValue = getSprintValue()
			if sprintValue and sprintValue.Value ~= targetSpeed then
				sprintValue.Value = targetSpeed
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
