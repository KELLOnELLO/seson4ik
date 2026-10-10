local Neverlose = {}
Neverlose.__index = Neverlose

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

local function safeParent(obj)
    local ok = pcall(function() obj.Parent = CoreGui end)
    if not ok then obj.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    return obj
end

local function new(instance, props)
    local obj = Instance.new(instance)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local Themes = {
    Background = Color3.fromRGB(14, 14, 17),
    Panel = Color3.fromRGB(20, 20, 24),
    PanelLight = Color3.fromRGB(28, 28, 34),
    PanelHover = Color3.fromRGB(35, 35, 42),
    Stroke = Color3.fromRGB(38, 38, 46),
    Text = Color3.fromRGB(235, 235, 240),
    SubText = Color3.fromRGB(130, 130, 145),
    Accent = Color3.fromRGB(155, 89, 255),
    AccentDark = Color3.fromRGB(90, 50, 160),
    Toggle = Color3.fromRGB(155, 89, 255),
    Green = Color3.fromRGB(80, 200, 120),
    Red = Color3.fromRGB(220, 70, 70),
}

Neverlose.Theme = Themes

function Neverlose:CreateWindow(title)
    local self = setmetatable({}, Neverlose)
    self.Title = title or "Neverlose"
    self.Tabs = {}
    self.ActiveTab = nil
    self.Visible = true
    self.Connections = {}
    self.ToggleKey = Enum.KeyCode.Tab
    self.AltToggleKey = Enum.KeyCode.RightShift

    self.Blur = new("BlurEffect", {
        Name = "NL_Blur",
        Size = 0,
        Parent = Lighting,
    })

    self.Gui = new("ScreenGui", {
        Name = "NeverloseUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
    })
    safeParent(self.Gui)

    self.SnowFrame = new("Frame", {
        Name = "SnowLayer",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 1,
        Parent = self.Gui,
    })

    self.Darken = new("Frame", {
        Name = "Darken",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = self.Gui,
    })

    self.Main = new("Frame", {
        Name = "Main",
        Size = UDim2.fromOffset(700, 460),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Themes.Background,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = self.Gui,
    })
    new("UICorner", { CornerRadius = UDim.new(0, 10), Parent = self.Main })
    new("UIStroke", { Color = Themes.Stroke, Thickness = 1, Parent = self.Main })

    local topBar = new("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 42),
        BackgroundColor3 = Themes.Panel,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = self.Main,
    })
    new("UICorner", { CornerRadius = UDim.new(0, 10), Parent = topBar })
    local topBarCover = new("Frame", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = Themes.Panel,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = topBar,
    })

    local logoDot = new("Frame", {
        Size = UDim2.fromOffset(8, 8),
        Position = UDim2.new(0, 16, 0.5, -4),
        BackgroundColor3 = Themes.Accent,
        BorderSizePixel = 0,
        ZIndex = 12,
        Parent = topBar,
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = logoDot })

    new("TextLabel", {
        Text = self.Title,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Themes.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 32, 0, 0),
        Size = UDim2.new(1, -140, 1, 0),
        ZIndex = 12,
        Parent = topBar,
    })

    local closeBtn = new("TextButton", {
        Text = "✕",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Themes.SubText,
        BackgroundColor3 = Themes.PanelLight,
        AutoButtonColor = false,
        Size = UDim2.fromOffset(30, 30),
        Position = UDim2.new(1, -38, 0.5, -15),
        ZIndex = 12,
        Parent = topBar,
    })
    new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = closeBtn })

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = Themes.Red, TextColor3 = Themes.Text }):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), { BackgroundColor3 = Themes.PanelLight, TextColor3 = Themes.SubText }):Play()
    end)
    closeBtn.MouseButton1Click:Connect(function() self:Toggle() end)

    self.Sidebar = new("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 160, 1, -54),
        Position = UDim2.new(0, 8, 0, 46),
        BackgroundColor3 = Themes.Panel,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = self.Main,
    })
    new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Sidebar })

    self.TabBar = new("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, -12, 1, -12),
        Position = UDim2.new(0, 6, 0, 6),
        BackgroundTransparency = 1,
        ZIndex = 12,
        Parent = self.Sidebar,
    })
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.TabBar,
    })

    self.Content = new("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -184, 1, -54),
        Position = UDim2.new(0, 176, 0, 46),
        BackgroundColor3 = Themes.Panel,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = self.Main,
    })
    new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = self.Content })

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

    self:StartSnow()
    self:StartBlurLoop()

    table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == self.ToggleKey or input.KeyCode == self.AltToggleKey then
            self:Toggle()
        end
    end))

    return self
end

function Neverlose:StartSnow()
    local snowFolder = new("Folder", { Name = "Snowflakes", Parent = self.SnowFrame })
    local flakes = {}

    for i = 1, 80 do
        local f = new("Frame", {
            Size = UDim2.fromOffset(math.random(2, 4), math.random(2, 4)),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = math.random(30, 70) / 100,
            BorderSizePixel = 0,
            Position = UDim2.new(math.random(), 0, math.random(), 0),
            ZIndex = 3,
            Parent = snowFolder,
        })
        new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = f })
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
            local newY = pos.Y.Scale + fl.speed * dt
            local newX = pos.X.Scale + fl.drift * dt
            if newY > 1 then
                newY = -0.02
                newX = math.random()
            end
            if newX > 1 then newX = 0 elseif newX < 0 then newX = 1 end
            fl.obj.Position = UDim2.new(newX, 0, newY, 0)
        end
    end))
end

function Neverlose:StartBlurLoop()
    table.insert(self.Connections, RunService.RenderStepped:Connect(function()
        local target = self.Visible and 18 or 0
        if math.abs(self.Blur.Size - target) > 0.5 then
            self.Blur.Size = self.Blur.Size + (target - self.Blur.Size) * 0.2
        else
            self.Blur.Size = target
        end
    end))
end

function Neverlose:Toggle()
    self.Visible = not self.Visible
    self.Main.Visible = self.Visible
    self.Darken.Visible = self.Visible
    self.SnowFrame.Visible = self.Visible
end

function Neverlose:CreateTab(name)
    local tab = {}
    tab.Name = name
    tab.Buttons = {}

    local btn = new("TextButton", {
        Text = "  " .. name,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = Themes.SubText,
        BackgroundColor3 = Themes.PanelLight,
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        Size = UDim2.new(1, 0, 0, 34),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 13,
        Parent = self.TabBar,
    })
    new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })

    local indicator = new("Frame", {
        Size = UDim2.new(0, 3, 0.6, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Themes.Accent,
        BorderSizePixel = 0,
        ZIndex = 14,
        Visible = false,
        Parent = btn,
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = indicator })

    local page = new("ScrollingFrame", {
        Size = UDim2.new(1, -16, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Themes.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        ZIndex = 13,
        Parent = self.Content,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page,
    })
    new("UIPadding", { PaddingTop = UDim.new(0, 4), Parent = page })

    tab.Page = page
    tab.Button = btn
    tab.Indicator = indicator

    btn.MouseEnter:Connect(function()
        if self.ActiveTab ~= tab then
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Themes.PanelHover, BackgroundTransparency = 0.5 }):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if self.ActiveTab ~= tab then
            TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do
            t.Page.Visible = false
            t.Indicator.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.15), { TextColor3 = Themes.SubText, BackgroundTransparency = 1 }):Play()
        end
        page.Visible = true
        indicator.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.15), { TextColor3 = Themes.Accent, BackgroundColor3 = Themes.PanelLight, BackgroundTransparency = 0 }):Play()
        self.ActiveTab = tab
    end)

    table.insert(self.Tabs, tab)

    if #self.Tabs == 1 then
        page.Visible = true
        indicator.Visible = true
        btn.TextColor3 = Themes.Accent
        btn.BackgroundColor3 = Themes.PanelLight
        btn.BackgroundTransparency = 0
        self.ActiveTab = tab
    end

    function tab:AddSection(title)
        local section = {}
        local holder = new("Frame", {
            Size = UDim2.new(1, 0, 0, 22),
            BackgroundTransparency = 1,
            LayoutOrder = #page:GetChildren(),
            Parent = page,
        })
        new("TextLabel", {
            Text = string.upper(title or "SECTION"),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextColor3 = Themes.Accent,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Parent = holder,
        })

        function section:AddToggle(label, default, callback)
            local state = default or false
            local row = new("TextButton", {
                Text = "",
                AutoButtonColor = false,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Themes.PanelLight,
                BorderSizePixel = 0,
                LayoutOrder = #page:GetChildren(),
                Parent = page,
            })
            new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = row })
            new("UIStroke", { Color = Themes.Stroke, Thickness = 1, Parent = row })

            new("TextLabel", {
                Text = label,
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextColor3 = Themes.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 0),
                Size = UDim2.new(1, -70, 1, 0),
                Parent = row,
            })

            local box = new("Frame", {
                Size = UDim2.fromOffset(38, 20),
                Position = UDim2.new(1, -50, 0.5, -10),
                BackgroundColor3 = state and Themes.Toggle or Themes.Stroke,
                BorderSizePixel = 0,
                Parent = row,
            })
            new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = box })

            local knob = new("Frame", {
                Size = UDim2.fromOffset(16, 16),
                Position = state and UDim2.new(1, -18, 0, 2) or UDim2.fromOffset(2, 2),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Parent = box,
            })
            new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

            row.MouseEnter:Connect(function()
                TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = Themes.PanelHover }):Play()
            end)
            row.MouseLeave:Connect(function()
                TweenService:Create(row, TweenInfo.new(0.15), { BackgroundColor3 = Themes.PanelLight }):Play()
            end)
            row.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(box, TweenInfo.new(0.15), {
                    BackgroundColor3 = state and Themes.Toggle or Themes.Stroke,
                }):Play()
                TweenService:Create(knob, TweenInfo.new(0.15), {
                    Position = state and UDim2.new(1, -18, 0, 2) or UDim2.fromOffset(2, 2),
                }):Play()
                if callback then callback(state) end
            end)

            return { Set = function(v) if callback then callback(v) end end }
        end

        function section:AddSlider(label, min, max, default, callback)
            local value = default or min
            local row = new("Frame", {
                Size = UDim2.new(1, 0, 0, 46),
                BackgroundColor3 = Themes.PanelLight,
                BorderSizePixel = 0,
                LayoutOrder = #page:GetChildren(),
                Parent = page,
            })
            new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = row })
            new("UIStroke", { Color = Themes.Stroke, Thickness = 1, Parent = row })

            new("TextLabel", {
                Text = label,
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextColor3 = Themes.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 5),
                Size = UDim2.new(0.6, 0, 0, 16),
                Parent = row,
            })

            local valLbl = new("TextLabel", {
                Text = tostring(value),
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = Themes.Accent,
                TextXAlignment = Enum.TextXAlignment.Right,
                BackgroundTransparency = 1,
                Position = UDim2.new(0.6, 0, 5, 0),
                Size = UDim2.new(0.4, -14, 0, 16),
                Parent = row,
            })

            local barBg = new("Frame", {
                Size = UDim2.new(1, -28, 0, 6),
                Position = UDim2.new(0, 14, 1, -17),
                BackgroundColor3 = Themes.Stroke,
                BorderSizePixel = 0,
                Parent = row,
            })
            new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = barBg })

            local barFill = new("Frame", {
                Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Themes.Accent,
                BorderSizePixel = 0,
                Parent = barBg,
            })
            new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = barFill })

            local knobSlider = new("Frame", {
                Size = UDim2.fromOffset(12, 12),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new((value - min) / (max - min), 0, 0.5, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Parent = barBg,
            })
            new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knobSlider })

            local dragging = false
            local function update(input)
                local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * rel)
                barFill.Size = UDim2.new(rel, 0, 1, 0)
                knobSlider.Position = UDim2.new(rel, 0, 0.5, 0)
                valLbl.Text = tostring(value)
                if callback then callback(value) end
            end

            barBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    update(input)
                end
            end)
            table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
            end))
            table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end))

            return {
                Set = function(v)
                    value = math.clamp(v, min, max)
                    local rel = (value - min) / (max - min)
                    barFill.Size = UDim2.new(rel, 0, 1, 0)
                    knobSlider.Position = UDim2.new(rel, 0, 0.5, 0)
                    valLbl.Text = tostring(value)
                    if callback then callback(value) end
                end
            }
        end

        function section:AddButton(label, callback)
            local btn = new("TextButton", {
                Text = label,
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextColor3 = Themes.Text,
                BackgroundColor3 = Themes.PanelLight,
                AutoButtonColor = false,
                Size = UDim2.new(1, 0, 0, 34),
                LayoutOrder = #page:GetChildren(),
                Parent = page,
            })
            new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = btn })
            new("UIStroke", { Color = Themes.Stroke, Thickness = 1, Parent = btn })

            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Themes.PanelHover }):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = Themes.PanelLight }):Play()
            end)
            btn.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)

            return btn
        end

        function section:AddDropdown(label, options, default, callback)
            local selected = default or options[1]
            local open = false

            local holder = new("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = Themes.PanelLight,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                LayoutOrder = #page:GetChildren(),
                Parent = page,
            })
            new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = holder })
            new("UIStroke", { Color = Themes.Stroke, Thickness = 1, Parent = holder })

            local header = new("TextButton", {
                Text = "",
                AutoButtonColor = false,
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Parent = holder,
            })

            new("TextLabel", {
                Text = label,
                Font = Enum.Font.GothamMedium,
                TextSize = 13,
                TextColor3 = Themes.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                Parent = header,
            })

            local valLbl = new("TextLabel", {
                Text = tostring(selected),
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                TextColor3 = Themes.Accent,
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
            new("UIListLayout", {
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = list,
            })

            for _, opt in ipairs(options) do
                local optBtn = new("TextButton", {
                    Text = tostring(opt),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = Themes.SubText,
                    BackgroundColor3 = Themes.PanelHover,
                    AutoButtonColor = false,
                    Size = UDim2.new(1, 0, 0, 26),
                    Parent = list,
                })
                new("UICorner", { CornerRadius = UDim.new(0, 4), Parent = optBtn })
                optBtn.MouseEnter:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.1), { TextColor3 = Themes.Text }):Play()
                end)
                optBtn.MouseLeave:Connect(function()
                    TweenService:Create(optBtn, TweenInfo.new(0.1), { TextColor3 = Themes.SubText }):Play()
                end)
                optBtn.MouseButton1Click:Connect(function()
                    selected = opt
                    valLbl.Text = tostring(opt)
                    open = false
                    TweenService:Create(holder, TweenInfo.new(0.2), { Size = UDim2.new(1, 0, 0, 36) }):Play()
                    if callback then callback(opt) end
                end)
            end

            header.MouseButton1Click:Connect(function()
                open = not open
                local target = open and UDim2.new(1, 0, 0, 36 + #options * 30 + 8) or UDim2.new(1, 0, 0, 36)
                TweenService:Create(holder, TweenInfo.new(0.2), { Size = target }):Play()
            end)

            return {
                Set = function(v)
                    selected = v
                    valLbl.Text = tostring(v)
                    if callback then callback(v) end
                end
            }
        end

        function section:AddLabel(title, defaultText)
            local holder = new("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Themes.PanelLight,
                BorderSizePixel = 0,
                LayoutOrder = #page:GetChildren(),
                Parent = page,
            })
            new("UICorner", { CornerRadius = UDim.new(0, 6), Parent = holder })
            new("UIStroke", { Color = Themes.Stroke, Thickness = 1, Parent = holder })

            local lbl = new("TextLabel", {
                Text = defaultText or title or "",
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = Themes.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center,
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 0),
                Size = UDim2.new(1, -28, 1, 0),
                TextWrapped = true,
                Parent = holder,
            })

            return {
                SetText = function(_, text) lbl.Text = text end,
                Instance = holder
            }
        end

        return section
    end

    return tab
end

function Neverlose:Destroy()
    for _, c in ipairs(self.Connections) do
        pcall(function() c:Disconnect() end)
    end
    if self.Blur then self.Blur:Destroy() end
    if self.Gui then self.Gui:Destroy() end
end

return Neverlose
