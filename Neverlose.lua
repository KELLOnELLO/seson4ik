--[[
    Neverlose UI Library
    Author: Void / Wzxx
    Usage: local NL = loadstring(...)()
           local win = NL:CreateWindow("Title")
           local tab = win:CreateTab("Main")
           local sec = tab:AddSection("General")
           sec:AddToggle("Label", false, function(v) end)
]]

local NL = {}
NL.__index = NL

local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local RunService         = game:GetService("RunService")
local Players            = game:GetService("Players")
local CoreGui            = game:GetService("CoreGui")
local Lighting           = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

--============================================================
-- THEME
--============================================================
local Theme = {
    Background      = Color3.fromRGB(14, 14, 18),
    Panel           = Color3.fromRGB(19, 19, 24),
    PanelLight      = Color3.fromRGB(26, 26, 32),
    PanelHover      = Color3.fromRGB(34, 34, 42),
    PanelActive     = Color3.fromRGB(42, 42, 52),
    Stroke          = Color3.fromRGB(42, 42, 52),
    Text            = Color3.fromRGB(235, 235, 240),
    SubText         = Color3.fromRGB(130, 130, 145),
    Accent          = Color3.fromRGB(155, 89, 255),
    AccentDark      = Color3.fromRGB(80, 45, 145),
    Green           = Color3.fromRGB(80, 200, 120),
    Red             = Color3.fromRGB(220, 70, 70),
    Font            = Enum.Font.Gotham,
    FontBold        = Enum.Font.GothamBold,
    FontMedium      = Enum.Font.GothamMedium,
}

NL.Theme = Theme

--============================================================
-- UTILS
--============================================================
local function new(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    return obj
end

local function corner(parent, radius)
    return new("UICorner", { CornerRadius = UDim.new(0, radius or 6), Parent = parent })
end

local function stroke(parent, color, thickness, transparency)
    return new("UIStroke", {
        Color = color or Theme.Stroke,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

local function padding(parent, top, bottom, left, right)
    return new("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        Parent = parent,
    })
end

local function listLayout(parent, padding, order)
    return new("UIListLayout", {
        Padding = UDim.new(0, padding or 6),
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = order or Enum.SortOrder.LayoutOrder,
        Parent = parent,
    })
end

local function safeParent(gui)
    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok or not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end

local function cleanup()
    pcall(function()
        for _, name in ipairs({"NeverloseUI", "VoidVisualsESP", "Void3DOffOverlay"}) do
            local a = CoreGui:FindFirstChild(name)
            if a then a:Destroy() end
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                local b = pg:FindFirstChild(name)
                if b then b:Destroy() end
            end
        end
        local blur = Lighting:FindFirstChild("NL_Blur")
        if blur then blur:Destroy() end
    end)
end

local function tween(obj, time, props, style)
    TweenService:Create(obj, TweenInfo.new(time, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function fadeIn(obj, time)
    local target = obj.BackgroundTransparency
    obj.BackgroundTransparency = 1
    tween(obj, time or 0.2, { BackgroundTransparency = target })
end

--============================================================
-- NOTIFICATION SYSTEM
--============================================================
local NotifHolder

local function ensureNotifHolder(parent)
    if NotifHolder then return NotifHolder end
    NotifHolder = new("Frame", {
        Name = "NotifHolder",
        Size = UDim2.new(0, 300, 1, -80),
        Position = UDim2.new(1, -320, 0, 60),
        BackgroundTransparency = 1,
        ZIndex = 500,
        Parent = parent,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Parent = NotifHolder,
    })
    return NotifHolder
end

function NL:Notify(title, text, duration)
    if not self.Gui then return end
    local holder = ensureNotifHolder(self.Gui)
    duration = duration or 5

    local card = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = -os.time(),
        Parent = holder,
    })
    corner(card, 8)
    stroke(card, Theme.Stroke, 1)
    padding(card, 10, 10, 12, 12)

    local titleLbl = new("TextLabel", {
        Text = title or "Notification",
        Font = Theme.FontBold,
        TextSize = 13,
        TextColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })

    local textLbl = new("TextLabel", {
        Text = text or "",
        Font = Theme.Font,
        TextSize = 12,
        TextColor3 = Theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 18),
        Size = UDim2.new(1, 0, 0, 30),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = card,
    })

    local bar = new("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Parent = card,
    })

    local targetHeight = 62
    tween(card, 0.25, { Size = UDim2.new(1, 0, 0, targetHeight) })
    tween(bar, duration, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)

    task.delay(duration, function()
        tween(card, 0.25, { Size = UDim2.new(1, 0, 0, 0) })
        task.wait(0.3)
        pcall(function() card:Destroy() end)
    end)
end

--============================================================
-- WINDOW
--============================================================
function NL:CreateWindow(title)
    cleanup()

    local self = setmetatable({}, NL)
    self.Title = title or "Void"
    self.Tabs = {}
    self.ActiveTab = nil
    self.Visible = true
    self.Connections = {}
    self.ToggleKey = Enum.KeyCode.Tab
    self.AltKey = Enum.KeyCode.RightShift

    self.Blur = new("BlurEffect", { Name = "NL_Blur", Size = 0, Parent = Lighting })

    self.Gui = new("ScreenGui", {
        Name = "NeverloseUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
    })
    safeParent(self.Gui)

    -- Snow layer
    self.Snow = new("Frame", {
        Name = "Snow",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 1,
        Parent = self.Gui,
    })

    -- Darken
    self.Darken = new("Frame", {
        Name = "Darken",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = self.Gui,
    })

    -- Main
    self.Main = new("Frame", {
        Name = "Main",
        Size = UDim2.fromOffset(760, 500),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = self.Gui,
    })
    corner(self.Main, 10)
    stroke(self.Main, Theme.Stroke, 1)

    -- Top bar
    local topBar = new("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = self.Main,
    })
    corner(topBar, 10)
    new("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = topBar,
    })

    new("Frame", {
        Size = UDim2.fromOffset(8, 8),
        Position = UDim2.new(0, 18, 0.5, -4),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 12,
        Parent = topBar,
    }):Clone().Parent = topBar

    local dot = topBar:FindFirstChildOfClass("Frame")
    -- fix: apply corner to dot
    if dot then corner(dot, 4) end

    new("TextLabel", {
        Text = self.Title,
        Font = Theme.FontBold,
        TextSize = 14,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 34, 0, 0),
        Size = UDim2.new(1, -160, 1, 0),
        ZIndex = 12,
        Parent = topBar,
    })

    local keyHint = new("TextLabel", {
        Text = "TAB",
        Font = Theme.FontBold,
        TextSize = 10,
        TextColor3 = Theme.SubText,
        BackgroundColor3 = Theme.PanelLight,
        TextXAlignment = Enum.TextXAlignment.Center,
        Position = UDim2.new(1, -90, 0.5, -9),
        Size = UDim2.fromOffset(40, 18),
        ZIndex = 12,
        Parent = topBar,
    })
    corner(keyHint, 4)

    local closeBtn = new("TextButton", {
        Text = "X",
        Font = Theme.FontBold,
        TextSize = 13,
        TextColor3 = Theme.SubText,
        BackgroundColor3 = Theme.PanelLight,
        AutoButtonColor = false,
        Position = UDim2.new(1, -40, 0.5, -14),
        Size = UDim2.fromOffset(28, 28),
        ZIndex = 12,
        Parent = topBar,
    })
    corner(closeBtn, 6)
    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, 0.15, { BackgroundColor3 = Theme.Red, TextColor3 = Color3.new(1,1,1) })
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, 0.15, { BackgroundColor3 = Theme.PanelLight, TextColor3 = Theme.SubText })
    end)
    closeBtn.MouseButton1Click:Connect(function() self:Toggle() end)

    -- Sidebar
    self.Sidebar = new("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 170, 1, -58),
        Position = UDim2.new(0, 8, 0, 50),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = self.Main,
    })
    corner(self.Sidebar, 8)

    -- Sidebar header
    new("TextLabel", {
        Text = "NAVIGATION",
        Font = Theme.FontBold,
        TextSize = 9,
        TextColor3 = Theme.SubText,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 10),
        Size = UDim2.new(1, -20, 0, 14),
        Parent = self.Sidebar,
    })

    self.TabHolder = new("ScrollingFrame", {
        Name = "TabHolder",
        Size = UDim2.new(1, -12, 1, -34),
        Position = UDim2.new(0, 6, 0, 28),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 12,
        Parent = self.Sidebar,
    })
    listLayout(self.TabHolder, 4)

    -- Content container
    self.Content = new("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -194, 1, -58),
        Position = UDim2.new(0, 186, 0, 50),
        BackgroundColor3 = Theme.Panel,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = self.Main,
    })
    corner(self.Content, 8)

    -- Dragging
    local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.Main.Position
        end
    end)
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))

    -- Toggle key
    table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == self.ToggleKey or input.KeyCode == self.AltKey then
            self:Toggle()
        end
    end))

    self:StartSnow()
    self:StartBlur()

    return self
end

--============================================================
-- SNOW
--============================================================
function NL:StartSnow()
    local folder = new("Folder", { Name = "Flakes", Parent = self.Snow })
    local flakes = {}

    for i = 1, 90 do
        local f = new("Frame", {
            Size = UDim2.fromOffset(math.random(2, 4), math.random(2, 4)),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = math.random(30, 70) / 100,
            BorderSizePixel = 0,
            Position = UDim2.new(math.random(), 0, math.random(), 0),
            ZIndex = 3,
            Parent = folder,
        })
        corner(f, 4)
        table.insert(flakes, {
            obj = f,
            speed = math.random(30, 90) / 100,
            drift = math.random(-15, 15) / 100,
        })
    end

    table.insert(self.Connections, RunService.RenderStepped:Connect(function(dt)
        if not self.Visible then return end
        for _, fl in ipairs(flakes) do
            local pos = fl.obj.Position
            local y = pos.Y.Scale + fl.speed * dt
            local x = pos.X.Scale + fl.drift * dt
            if y > 1 then
                y = -0.02
                x = math.random()
            end
            if x > 1 then x = 0 elseif x < 0 then x = 1 end
            fl.obj.Position = UDim2.new(x, 0, y, 0)
        end
    end))
end

function NL:StartBlur()
    table.insert(self.Connections, RunService.RenderStepped:Connect(function()
        local target = self.Visible and 18 or 0
        if math.abs(self.Blur.Size - target) > 0.5 then
            self.Blur.Size = self.Blur.Size + (target - self.Blur.Size) * 0.2
        else
            self.Blur.Size = target
        end
    end))
end

function NL:Toggle()
    self.Visible = not self.Visible
    self.Main.Visible = self.Visible
    self.Darken.Visible = self.Visible
    self.Snow.Visible = self.Visible
    if NotifHolder then NotifHolder.Visible = self.Visible end
end

--============================================================
-- TAB
--============================================================
function NL:CreateTab(name)
    local self_ = self

    local tab = { Name = name, Elements = {} }

    -- Button
    local btn = new("TextButton", {
        Text = "",
        AutoButtonColor = false,
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.PanelLight,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 13,
        Parent = self.TabHolder,
    })
    corner(btn, 6)

    local indicator = new("Frame", {
        Size = UDim2.new(0, 3, 0, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 14,
        Parent = btn,
    })
    corner(indicator, 4)

    local lbl = new("TextLabel", {
        Text = name,
        Font = Theme.FontMedium,
        TextSize = 13,
        TextColor3 = Theme.SubText,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14,
        Parent = btn,
    })

    -- Page
    local page = new("ScrollingFrame", {
        Size = UDim2.new(1, -16, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        ZIndex = 12,
        Parent = self.Content,
    })
    listLayout(page, 6)
    padding(page, 4, 4, 4, 4)

    tab.Button = btn
    tab.Indicator = indicator
    tab.Label = lbl
    tab.Page = page

    -- Hover
    btn.MouseEnter:Connect(function()
        if self_ .ActiveTab ~= tab then
            tween(btn, 0.15, { BackgroundTransparency = 0.4 })
        end
    end)
    btn.MouseLeave:Connect(function()
        if self_.ActiveTab ~= tab then
            tween(btn, 0.15, { BackgroundTransparency = 1 })
        end
    end)

    -- Click
    btn.MouseButton1Click:Connect(function()
        self_:SelectTab(tab)
    end)

    table.insert(self.Tabs, tab)

    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end

    --======= SECTION BUILDER =======
    function tab:AddSection(title)
        local section = {}

        local header = new("Frame", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1,
            LayoutOrder = #page:GetChildren(),
            Parent = page,
        })
        new("TextLabel", {
            Text = string.upper(title or "SECTION"),
            Font = Theme.FontBold,
            TextSize = 11,
            TextColor3 = Theme.Accent,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 4, 0, 6),
            Size = UDim2.new(1, -8, 0, 16),
            Parent = header,
        })

        -- Toggle
        function section:AddToggle(label, default, callback)
            local state = default and true or false

            local row = new("TextButton", {
                Text = "",
                AutoButtonColor = false,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Theme.PanelLight,
                BorderSizePixel = 0,
                LayoutOrder = #page:GetChildren(),
                Parent = page,
            })
            corner(row, 6)
            stroke(row, Theme.Stroke, 1)

            new("TextLabel", {
                Text = label,
                Font = Theme.FontMedium,
                TextSize = 13,
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Parent = row,
            })

            local box = new("Frame", {
                Size = UDim2.fromOffset(38, 20),
                Position = UDim2.new(1, -52, 0.5, -10),
                BackgroundColor3 = state and Theme.Accent or Theme.Stroke,
                BorderSizePixel = 0,
                Parent = row,
            })
            corner(box, 10)

            local knob = new("Frame", {
                Size = UDim2.fromOffset(16, 16),
                Position = state and UDim2.new(1, -18, 0, 2) or UDim2.fromOffset(2, 2),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                Parent = box,
            })
            corner(knob, 8)

            row.MouseEnter:Connect(function()
                tween(row, 0.15, { BackgroundColor3 = Theme.PanelHover })
            end)
            row.MouseLeave:Connect(function()
                tween(row, 0.15, { BackgroundColor3 = Theme.PanelLight })
            end)

            row.MouseButton1Click:Connect(function()
                state = not state
                tween(box, 0.15, { BackgroundColor3 = state and Theme.Accent or Theme.Stroke })
                tween(knob, 0.15, {
                    Position = state and UDim2.new(1, -18, 0, 2) or UDim2.fromOffset(2, 2)
                })
                if callback then
                    local ok, err = pcall(callback, state)
                    if not ok then warn("[Void] Toggle callback error:", err) end
                end
            end)

            return {
                Set = function(_, v)
                    state = v and true or false
                    box.BackgroundColor3 = state and Theme.Accent or Theme.Stroke
                    knob.Position = state and UDim2.new(1, -18, 0, 2) or UDim2.fromOffset(2, 2)
                end
            }
        end

        -- Slider
        function section:AddSlider(label, min, max, default, callback)
            local value = default or min

            local row = new("Frame", {
                Size = UDim2.new(1, 0, 0, 48),
                BackgroundColor3 = Theme.PanelLight,
                BorderSizePixel = 0,
                LayoutOrder = #page:GetChildren(),
                Parent = page,
            })
            corner(row, 6)
            stroke(row, Theme.Stroke, 1)

            new("TextLabel", {
                Text = label,
                Font = Theme.FontMedium,
                TextSize = 13,
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 6),
                Size = UDim2.new(0.6, 0, 0, 16),
                Parent = row,
            })

            local valLbl = new("TextLabel", {
                Text = tostring(value),
                Font = Theme.FontBold,
                TextSize = 12,
                TextColor3 = Theme.Accent,
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.6, 0, 6, 0),
                Size = UDim2.new(0.4, -16, 0, 16),
                Parent = row,
            })

            local bar = new("Frame", {
                Size = UDim2.new(1, -28, 0, 6),
                Position = UDim2.new(0, 14, 1, -18),
                BackgroundColor3 = Theme.Stroke,
                BorderSizePixel = 0,
                Parent = row,
            })
            corner(bar, 4)

            local fill = new("Frame", {
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                Parent = bar,
            })
            corner(fill, 4)

            local knob = new("Frame", {
                Size = UDim2.fromOffset(12, 12),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0),
                BackgroundColor3 = Color3.new(1, 1, 1),
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = bar,
            })
            corner(knob, 6)

            local dragging = false
            local function update(input)
                local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * rel)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, 0, 0.5, 0)
                valLbl.Text = tostring(value)
                if callback then
                    pcall(callback, value)
                end
            end

            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    update(input)
                end
            end)
            table.insert(self_.Connections, UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    update(input)
                end
            end))
            table.insert(self_.Connections, UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end))

            return {
                Set = function(_, v)
                    value = math.clamp(v, min, max)
                    local rel = (value - min) / (max - min)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    knob.Position = UDim2.new(rel, 0, 0.5, 0)
                    valLbl.Text = tostring(value)
                end
            }
        end

        -- Button
        function section:AddButton(label, callback)
            local btn = new("TextButton", {
                Text = label,
                Font = Theme.FontMedium,
                TextSize = 13,
                TextColor3 = Theme.Text,
                BackgroundColor3 = Theme.PanelLight,
                AutoButtonColor = false,
                Size = UDim2.new(1, 0, 0, 34),
                LayoutOrder = #page:GetChildren(),
                Parent = page,
            })
            corner(btn, 6)
            stroke(btn, Theme.Stroke, 1)

            btn.MouseEnter:Connect(function()
                tween(btn, 0.15, { BackgroundColor3 = Theme.PanelHover })
            end)
            btn.MouseLeave:Connect(function()
                tween(btn, 0.15, { BackgroundColor3 = Theme.PanelLight })
            end)
            btn.MouseButton1Click:Connect(function()
                if callback then pcall(callback) end
            end)

            return btn
        end

        -- Dropdown
        function section:AddDropdown(label, options, default, callback)
            local selected = default or (options and options[1]) or "None"
            local open = false

            local holder = new("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Theme.PanelLight,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                LayoutOrder = #page:GetChildren(),
                Parent = page,
            })
            corner(holder, 6)
            stroke(holder, Theme.Stroke, 1)

            local header = new("TextButton", {
                Text = "",
                AutoButtonColor = false,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Parent = holder,
            })

            new("TextLabel", {
                Text = label,
                Font = Theme.FontMedium,
                TextSize = 13,
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 14, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                Parent = header,
            })

            local valLbl = new("TextLabel", {
                Text = tostring(selected),
                Font = Theme.FontBold,
                TextSize = 12,
                TextColor3 = Theme.Accent,
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0, 0),
                Size = UDim2.new(0.5, -14, 1, 0),
                Parent = header,
            })

            local list = new("Frame", {
                Size = UDim2.new(1, -16, 0, 0),
                Position = UDim2.new(0, 8, 0, 40),
                BackgroundTransparency = 1,
                Parent = holder,
            })
            listLayout(list, 4)

            for _, opt in ipairs(options or {}) do
                local optBtn = new("TextButton", {
                    Text = tostring(opt),
                    Font = Theme.Font,
                    TextSize = 12,
                    TextColor3 = Theme.SubText,
                    BackgroundColor3 = Theme.PanelHover,
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 26),
                    Parent = list,
                })
                corner(optBtn, 4)
                optBtn.MouseEnter:Connect(function()
                    tween(optBtn, 0.1, { TextColor3 = Theme.Text })
                end)
                optBtn.MouseLeave:Connect(function()
                    tween(optBtn, 0.1, { TextColor3 = Theme.SubText })
                end)
                optBtn.MouseButton1Click:Connect(function()
                    selected = opt
                    valLbl.Text = tostring(opt)
                    open = false
                    tween(holder, 0.2, { Size = UDim2.new(1, 0, 0, 36) })
                    if callback then pcall(callback, opt) end
                end)
            end

            header.MouseButton1Click:Connect(function()
                open = not open
                local target = open and UDim2.new(1, 0, 0, 36 + #options * 30 + 8) or UDim2.new(1, 0, 0, 36)
                tween(holder, 0.2, { Size = target })
            end)

            return {
                Set = function(_, v)
                    selected = v
                    valLbl.Text = tostring(v)
                    if callback then pcall(callback, v) end
                end
            }
        end

        -- Textbox
        function section:AddTextbox(label, default, callback)
            local row = new("Frame", {
                Size = UDim2.new(1, 0, 0, 48),
                BackgroundColor3 = Theme.PanelLight,
                BorderSizePixel = 0,
                LayoutOrder = #page:GetChildren(),
                Parent
