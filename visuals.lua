``lua
-- Universal Visuals Script: Skybox + Lighting + Custom Cursor
-- For use with Delta Executor

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ======= SKYBOX + LIGHTING PRESETS =======
local presets = {
    ["Galaxy"] = {
        skybox = {
            Up = "rbxassetid://0000000001", Down = "rbxassetid://0000000002",
            Left = "rbxassetid://0000000003", Right = "rbxassetid://0000000004",
            Front = "rbxassetid://0000000005", Back = "rbxassetid://0000000006"
        },
        Brightness = 2, Ambient = Color3.fromRGB(40,40,60),
        ColorCorrection = {Saturation = 0.3, Contrast = 0.2, Brightness = 0.05},
        Bloom = {Intensity = 0.8, Size = 24, Threshold = 1.5},
        SunRays = {Intensity = 0.15, Spread = 0.5}
    },
    ["Sunset"] = {
        skybox = {
            Up = "rbxassetid://0000000011", Down = "rbxassetid://0000000012",
            Left = "rbxassetid://0000000013", Right = "rbxassetid://0000000014",
            Front = "rbxassetid://0000000015", Back = "rbxassetid://0000000016"
        },
        Brightness = 3, Ambient = Color3.fromRGB(80,50,40),
        ColorCorrection = {Saturation = 0.4, Contrast = 0.15, Brightness = 0.08},
        Bloom = {Intensity = 1, Size = 20, Threshold = 1.2},
        SunRays = {Intensity = 0.25, Spread = 0.6}
    }
}

local skyInstance = Instance.new("Sky")
skyInstance.Name = "CustomSky"

local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Name = "CustomCC"
colorCorrection.Parent = Lighting

local bloom = Instance.new("BloomEffect")
bloom.Name = "CustomBloom"
bloom.Parent = Lighting

local sunRays = Instance.new("SunRaysEffect")
sunRays.Name = "CustomSunRays"
sunRays.Parent = Lighting

local function applyPreset(name)
    local p = presets[name]
    if not p then return end

    skyInstance.SkyboxUp = p.skybox.Up
    skyInstance.SkyboxDown = p.skybox.Down
    skyInstance.SkyboxLf = p.skybox.Left
    skyInstance.SkyboxRt = p.skybox.Right
    skyInstance.SkyboxFt = p.skybox.Front
    skyInstance.SkyboxBk = p.skybox.Back
    skyInstance.Parent = Lighting

    Lighting.Brightness = p.Brightness
    Lighting.Ambient = p.Ambient

    colorCorrection.Saturation = p.ColorCorrection.Saturation
    colorCorrection.Contrast = p.ColorCorrection.Contrast
    colorCorrection.Brightness = p.ColorCorrection.Brightness

    bloom.Intensity = p.Bloom.Intensity
    bloom.Size = p.Bloom.Size
    bloom.Threshold = p.Bloom.Threshold

    sunRays.Intensity = p.SunRays.Intensity
    sunRays.Spread = p.SunRays.Spread
end

-- ======= CUSTOM CURSOR (Shift Lock) =======
local cursors = {
    ["Default"] = "rbxassetid://0000000101",
    ["Crosshair Red"] = "rbxassetid://0000000102",
    ["Crosshair Blue"] = "rbxassetid://0000000103",
    ["Dot"] = "rbxassetid://0000000104"
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomCursorGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local cursorImage = Instance.new("ImageLabel")
cursorImage.Size = UDim2.new(0, 32, 0, 32)
cursorImage.BackgroundTransparency = 1
cursorImage.Image = cursors["Default"]
cursorImage.Visible = false
cursorImage.ZIndex = 1000
cursorImage.Parent = screenGui

local currentCursor = "Default"
local mouse = player:GetMouse()
mouse.Icon = ""  -- hide default cursor

RunService.RenderStepped:Connect(function()
    local isShiftLocked = UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter
    cursorImage.Visible = isShiftLocked
    if isShiftLocked then
        cursorImage.Position = UDim2.new(0.5, -16, 0.5, -16)
    end
end)

local function setCursor(name)
    if cursors[name] then
        currentCursor = name
        cursorImage.Image = cursors[name]
    end
end

-- ======= SIMPLE GUI MENU =======
local menuGui = Instance.new("ScreenGui")
menuGui.Name = "VisualsMenu"
menuGui.ResetOnSpawn = false
menuGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 260)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
frame.Parent = menuGui

local uiCorner = Instance.new("UICorner", frame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Visuals Menu"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local function makeButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text
    btn.Parent = frame
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
    return btn
end
