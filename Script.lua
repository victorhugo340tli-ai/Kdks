-- DEX HUB | FUNCIONAL VISUAL | DELTA OK

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

------------------------------------------------
-- DRAG
------------------------------------------------
local function drag(frame)
	local d, ds, sp
	frame.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			d = true
			ds = i.Position
			sp = frame.Position
		end
	end)
	frame.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			d = false
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - ds
			frame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
		end
	end)
end

------------------------------------------------
-- GUI
------------------------------------------------
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- Ícone
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,50,0,50)
icon.Position = UDim2.new(0,20,0.5,-25)
icon.Text = "DEX"
icon.TextScaled = true
icon.BackgroundColor3 = Color3.fromRGB(255,255,0)
drag(icon)

-- HUB
local hub = Instance.new("Frame", gui)
hub.Size = UDim2.new(0,360,0,220)
hub.Position = UDim2.new(0.5,-180,0.5,-110)
hub.BackgroundColor3 = Color3.fromRGB(255,255,0)
hub.Visible = false
drag(hub)

icon.MouseButton1Click:Connect(function()
	hub.Visible = not hub.Visible
end)

------------------------------------------------
-- TITLE
------------------------------------------------
local title = Instance.new("TextLabel", hub)
title.Size = UDim2.new(1,0,0,28)
title.Text = "DEX HUB"
title.BackgroundTransparency = 1
title.TextScaled = true

------------------------------------------------
-- SIDEBAR / MAIN
------------------------------------------------
local sidebar = Instance.new("Frame", hub)
sidebar.Position = UDim2.new(0,0,0,28)
sidebar.Size = UDim2.new(0,95,1,-28)
sidebar.BackgroundColor3 = Color3.fromRGB(230,230,0)

local main = Instance.new("Frame", hub)
main.Position = UDim2.new(0,105,0,38)
main.Size = UDim2.new(1,-115,1,-48)
main.BackgroundColor3 = Color3.fromRGB(255,255,0)

local function clear()
	for _,v in pairs(main:GetChildren()) do v:Destroy() end
end

------------------------------------------------
-- ESP VISUAL REAL (OBJETOS)
------------------------------------------------
local espObjects = {}

local function setESP(color, state)
	for _,v in pairs(espObjects) do v:Destroy() end
	espObjects = {}

	if not state then return end

	for _,p in pairs(workspace:GetDescendants()) do
		if p:IsA("BasePart") and p.Size.Magnitude > 5 then
			local box = Instance.new("BoxHandleAdornment")
			box.Adornee = p
			box.Size = p.Size
			box.Color3 = color
			box.AlwaysOnTop = true
			box.ZIndex = 5
			box.Transparency = 0.6
			box.Parent = gui
			table.insert(espObjects, box)
		end
	end
end

------------------------------------------------
-- SWITCH
------------------------------------------------
local function makeSwitch(text, y, onToggle)
	local label = Instance.new("TextLabel", main)
	label.Text = text
	label.Position = UDim2.new(0,10,0,y)
	label.Size = UDim2.new(0,140,0,28)
	label.BackgroundTransparency = 1
	label.TextScaled = true

	local btn = Instance.new("TextButton", main)
	btn.Position = UDim2.new(0,160,0,y)
	btn.Size = UDim2.new(0,60,0,28)
	btn.Text = "OFF"
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(255,0,0)

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = state and "ON" or "OFF"
		btn.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
		onToggle(state)
	end)
end

------------------------------------------------
-- MENUS
------------------------------------------------
local function espMenu()
	clear()
	makeSwitch("ESP Vermelho", 10, function(on)
		setESP(Color3.fromRGB(255,0,0), on)
	end)
	makeSwitch("ESP Verde", 50, function(on)
		setESP(Color3.fromRGB(0,255,0), on)
	end)
end

local flying = false
local function funcMenu()
	clear()

	makeSwitch("Voar (Camera)", 10, function(on)
		flying = on
	end)

	makeSwitch("Teleporte (Camera)", 50, function(on)
		if not on then return end
		local mouse = player:GetMouse()
		mouse.Button1Down:Once(function()
			camera.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,5,0))
		end)
	end)
end

------------------------------------------------
-- SIDEBAR BUTTONS
------------------------------------------------
local function side(text, y, f)
	local b = Instance.new("TextButton", sidebar)
	b.Size = UDim2.new(1,-10,0,28)
	b.Position = UDim2.new(0,5,0,y)
	b.Text = text
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.MouseButton1Click:Connect(f)
end

side("ESP", 10, espMenu)
side("Função", 45, funcMenu)
side("Info", 80, function()
	clear()
	local t = Instance.new("TextLabel", main)
	t.Size = UDim2.new(1,-10,1,-10)
	t.Position = UDim2.new(0,5,0,5)
	t.TextWrapped = true
	t.TextScaled = true
	t.BackgroundTransparency = 1
	t.Text = "DEX HUB\n\nAgora as funções fazem AÇÃO VISUAL REAL.\nCompatível com Delta."
end)

------------------------------------------------
-- VOAR CAMERA LOOP
------------------------------------------------
game:GetService("RunService").RenderStepped:Connect(function()
	if flying then
		camera.CFrame = camera.CFrame + Vector3.new(0,0.2,0)
	end
end)
