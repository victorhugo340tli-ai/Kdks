-- DEX HUB | UI CLIENT-SIDE | COMPATÍVEL COM DELTA

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Função de drag (PC + Mobile)
local function dragify(frame)
	local dragging = false
	local dragStart, startPos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)

	frame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DexHubGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

-- Ícone
local icon = Instance.new("TextButton", gui)
icon.Size = UDim2.new(0,48,0,48)
icon.Position = UDim2.new(0,20,0.5,-24)
icon.Text = "DEX"
icon.TextScaled = true
icon.BackgroundColor3 = Color3.fromRGB(255,255,0)
icon.BorderSizePixel = 0

dragify(icon)

-- HUB
local hub = Instance.new("Frame", gui)
hub.Size = UDim2.new(0,360,0,220)
hub.Position = UDim2.new(0.5,-180,0.5,-110)
hub.BackgroundColor3 = Color3.fromRGB(255,255,0)
hub.Visible = false
hub.BorderSizePixel = 0

dragify(hub)

-- Abrir / fechar
icon.MouseButton1Click:Connect(function()
	hub.Visible = not hub.Visible
end)

-- Título
local title = Instance.new("TextLabel", hub)
title.Size = UDim2.new(1,0,0,28)
title.Text = "DEX HUB"
title.BackgroundTransparency = 1
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

-- Sidebar
local sidebar = Instance.new("Frame", hub)
sidebar.Position = UDim2.new(0,0,0,28)
sidebar.Size = UDim2.new(0,95,1,-28)
sidebar.BackgroundColor3 = Color3.fromRGB(240,240,0)

-- Main
local main = Instance.new("Frame", hub)
main.Position = UDim2.new(0,105,0,38)
main.Size = UDim2.new(1,-115,1,-48)
main.BackgroundColor3 = Color3.fromRGB(255,255,0)
main.BorderSizePixel = 0

local function clearMain()
	for _,v in pairs(main:GetChildren()) do
		v:Destroy()
	end
end

-- Switch
local function switch(text, y)
	local label = Instance.new("TextLabel", main)
	label.Text = text
	label.Size = UDim2.new(0,120,0,28)
	label.Position = UDim2.new(0,10,0,y)
	label.BackgroundTransparency = 1
	label.TextScaled = true

	local btn = Instance.new("TextButton", main)
	btn.Size = UDim2.new(0,60,0,28)
	btn.Position = UDim2.new(0,140,0,y)
	btn.Text = "OFF"
	btn.TextScaled = true
	btn.BackgroundColor3 = Color3.fromRGB(255,0,0)

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = state and "ON" or "OFF"
		btn.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
		print(text, state)
	end)
end

-- Menus
local function espMenu()
	clearMain()
	switch("ESP Vermelho", 10)
	switch("ESP Verde", 50)
end

local function funcMenu()
	clearMain()
	switch("Voar", 10)
	switch("Teleporte", 50)
end

local function infoMenu()
	clearMain()
	local info = Instance.new("TextLabel", main)
	info.Size = UDim2.new(1,-10,1,-10)
	info.Position = UDim2.new(0,5,0,5)
	info.BackgroundTransparency = 1
	info.TextWrapped = true
	info.TextYAlignment = Enum.TextYAlignment.Top
	info.TextScaled = true
	info.Text =
	"DEX HUB\n\n"..
	"Compatível com Delta\n"..
	"UI client-side\n"..
	"Ícone e HUB arrastáveis\n"..
	"Switch funcional\n\n"..
	"Script base."
end

-- Botões laterais
local function side(text, y, func)
	local b = Instance.new("TextButton", sidebar)
	b.Size = UDim2.new(1,-10,0,28)
	b.Position = UDim2.new(0,5,0,y)
	b.Text = text
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.MouseButton1Click:Connect(func)
end

side("ESP", 10, espMenu)
side("Função", 44, funcMenu)
side("Info", 78, infoMenu)
