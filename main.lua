local KeySystem = loadstring(game:HttpGet("https://raw.githubusercontent.com/KELLOnELLO/lela/main/Key.lua?t=" .. os.time()))()

local function startMain()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer

local function safeLoad(url, name)
    local bust = url .. "?t=" .. tostring(os.time())
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(bust))()
    end)
    if ok and result then
        print("[Void] Loaded:", name)
        return result
    else
        warn("[Void] Failed:", name, result)
        return nil
    end
end

local AutoFarm = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/autofarm.lua", "autofarm")
local Invis = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/invis.lua", "invis")
local SF = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/sf.lua", "sf")
local Weather = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/weather.lua", "weather")
local Visuals = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/visuals.lua", "visuals")
local PlayerMod = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/player.lua", "player")

local function try(fn, name)
    local ok, err = pcall(fn)
    if not ok then warn("[Void] " .. tostring(name) .. ":", err) end
    return ok
end

pcall(function()
    for _, n in ipairs({"VoidMenu", "VoidVisualsESP", "Void3DOffOverlay", "NeverloseUI", "VoidYBA"}) do
        local a = CoreGui:FindFirstChild(n); if a then a:Destroy() end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then local b = pg:FindFirstChild(n); if b then b:Destroy() end end
    end
    local bl = Lighting:FindFirstChild("NL_Blur"); if bl then bl:Destroy() end
end)

local farm, invis, sf, weather, visuals, playerMod

if AutoFarm then try(function() farm = AutoFarm.new() end, "farm.new") end
if farm then
    try(function() farm:LoadConfig() end, "farm:LoadConfig")
    try(function() farm:SkipLoading() end, "farm:SkipLoading")
    try(function() farm:EnableKeyBypass() end, "farm:KeyBypass")
    try(function() farm:SetCharacterRespawnHandler() end, "farm:Respawn")
end
if Invis then try(function() invis = Invis.new() end, "invis.new") end
if invis then try(function() invis:HookRespawn() end, "invis:Respawn") end
if SF then try(function() sf = SF.new() end, "sf.new") end
if sf then try(function() sf:Setup() end, "sf:Setup") end
if Weather then try(function() weather = Weather.new() end, "weather.new") end
if weather then try(function() weather:WaitForWeatherValue(10) end, "weather:Wait") end
if Visuals then try(function() visuals = Visuals.new() end, "visuals.new") end
if PlayerMod then try(function() playerMod = PlayerMod.new() end, "player.new") end
if playerMod then try(function() playerMod:HookRespawn() end, "player:Respawn") end

local Theme = {
    Bg        = Color3.fromRGB(16, 16, 20),
    Panel     = Color3.fromRGB(22, 22, 28),
    PanelLt   = Color3.fromRGB(30, 30, 37),
    Hover     = Color3.fromRGB(40, 40, 48),
    Stroke    = Color3.fromRGB(48, 48, 58),
    Text      = Color3.fromRGB(238, 238, 242),
    Sub       = Color3.fromRGB(140, 140, 155),
    Accent    = Color3.fromRGB(160, 100, 255),
    AccentDim = Color3.fromRGB(100, 60, 180),
    Red       = Color3.fromRGB(220, 70, 70),
    Green     = Color3.fromRGB(80, 200, 120),
}

local Font = Enum.Font.Gotham
local FontBold = Enum.Font.GothamBold
local FontMed = Enum.Font.GothamMedium

local function new(cls, props)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do
        pcall(function() o[k] = v end)
    end
    return o
end

local function corner(p, r)
    return new("UICorner", { CornerRadius = UDim.new(0, r or 6), Parent = p })
end

local function stroke(p, c, t)
    return new("UIStroke", { Color = c or Theme.Stroke, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p })
end

local function tween(o, time, props)
    pcall(function()
        TweenService:Create(o, TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
    end)
end

local function safeParent(g)
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then pcall(function() g.Parent = LocalPlayer:WaitForChild("PlayerGui") end) end
end

local Blur = new("BlurEffect", { Name = "NL_Blur", Size = 0, Parent = Lighting })

local Gui = new("ScreenGui", {
    Name = "VoidMenu",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100,
})
safeParent(Gui)

local Darken = new("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    ZIndex = 1,
    Parent = Gui,
})

local SnowLayer = new("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ZIndex = 2,
    Parent = Gui,
})

local Main = new("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(800, 540),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Theme.Bg,
    BorderSizePixel = 0,
    ZIndex = 10,
    Parent = Gui,
})
corner(Main, 10)
stroke(Main, Theme.Stroke)

local TopBar = new("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    ZIndex = 11,
    Parent = Main,
})
corner(TopBar, 10)
new("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    ZIndex = 11,
    Parent = TopBar,
})

local logoDot = new("Frame", {
    Size = UDim2.fromOffset(8, 8),
    Position = UDim2.new(0, 18, 0.5, -4),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex = 12,
    Parent = TopBar,
})
corner(logoDot, 4)

new("TextLabel", {
    Text = "Neverlose | YBA",
    Font = FontBold,
    TextSize = 14,
    TextColor3 = Theme.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 34, 0, 0),
    Size = UDim2.new(1, -220, 1, 0),
    ZIndex = 12,
    Parent = TopBar,
})

local keyHint = new("TextLabel", {
    Text = "TAB",
    Font = FontBold,
    TextSize = 10,
    TextColor3 = Theme.Sub,
    BackgroundColor3 = Theme.PanelLt,
    TextXAlignment = Enum.TextXAlignment.Center,
    Position = UDim2.new(1, -110, 0.5, -9),
    Size = UDim2.fromOffset(42, 18),
    ZIndex = 12,
    Parent = TopBar,
})
corner(keyHint, 4)

local statusDot = new("Frame", {
    Size = UDim2.fromOffset(6, 6),
    Position = UDim2.new(1, -54, 0.5, -3),
    BackgroundColor3 = Theme.Green,
    BorderSizePixel = 0,
    ZIndex = 12,
    Parent = TopBar,
})
corner(statusDot, 3)

local CloseBtn = new("TextButton", {
    Text = "X",
    Font = FontBold,
    TextSize = 13,
    TextColor3 = Theme.Sub,
    BackgroundColor3 = Theme.PanelLt,
    AutoButtonColor = false,
    Position = UDim2.new(1, -40, 0.5, -14),
    Size = UDim2.fromOffset(28, 28),
    ZIndex = 12,
    Parent = TopBar,
})
corner(CloseBtn, 6)
CloseBtn.MouseEnter:Connect(function() tween(CloseBtn, 0.15, { BackgroundColor3 = Theme.Red, TextColor3 = Color3.new(1, 1, 1) }) end)
CloseBtn.MouseLeave:Connect(function() tween(CloseBtn, 0.15, { BackgroundColor3 = Theme.PanelLt, TextColor3 = Theme.Sub }) end)

local TabBar = new("Frame", {
    Name = "TabBar",
    Size = UDim2.new(1, -20, 0, 36),
    Position = UDim2.new(0, 10, 0, 52),
    BackgroundTransparency = 1,
    ZIndex = 11,
    Parent = Main,
})
new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Parent = TabBar,
})

local Content = new("Frame", {
    Name = "Content",
    Size = UDim2.new(1, -20, 1, -108),
    Position = UDim2.new(0, 10, 0, 98),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    ZIndex = 11,
    Parent = Main,
})
corner(Content, 8)
stroke(Content, Theme.Stroke)

local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
TopBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

local menuVisible = true
local function toggleMenu()
    menuVisible = not menuVisible
    Main.Visible = menuVisible
    Darken.Visible = menuVisible
    SnowLayer.Visible = menuVisible
end
CloseBtn.MouseButton1Click:Connect(toggleMenu)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Tab or input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)

local snowFolder = new("Folder", { Name = "Flakes", Parent = SnowLayer })
local flakes = {}
for i = 1, 90 do
    local f = new("Frame", {
        Size = UDim2.fromOffset(math.random(2, 4), math.random(2, 4)),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = math.random(30, 70) / 100,
        BorderSizePixel = 0,
        Position = UDim2.new(math.random(), 0, math.random(), 0),
        ZIndex = 3,
        Parent = snowFolder,
    })
    corner(f, 4)
    table.insert(flakes, { obj = f, speed = math.random(30, 90) / 100, drift = math.random(-15, 15) / 100 })
end
RunService.RenderStepped:Connect(function(dt)
    if not menuVisible then return end
    for _, fl in ipairs(flakes) do
        local pos = fl.obj.Position
        local y = pos.Y.Scale + fl.speed * dt
        local x = pos.X.Scale + fl.drift * dt
        if y > 1 then y = -0.02; x = math.random() end
        if x > 1 then x = 0 elseif x < 0 then x = 1 end
        fl.obj.Position = UDim2.new(x, 0, y, 0)
    end
end)

RunService.RenderStepped:Connect(function()
    local target = menuVisible and 18 or 0
    if math.abs(Blur.Size - target) > 0.5 then
        Blur.Size = Blur.Size + (target - Blur.Size) * 0.2
    else
        Blur.Size = target
    end
end)

local function makeSection(page, orderRef)
    local section = {}

    local function nextOrder()
        orderRef.n = orderRef.n + 1
        return orderRef.n
    end

    function section:AddToggle(label, default, callback)
        local state = default and true or false

        local row = new("TextButton", {
            Text = "",
            AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.PanelLt,
            BorderSizePixel = 0,
            LayoutOrder = nextOrder(),
            Parent = page,
        })
        corner(row, 6)
        stroke(row)

        new("TextLabel", {
            Text = label,
            Font = FontMed,
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

        row.MouseEnter:Connect(function() tween(row, 0.15, { BackgroundColor3 = Theme.Hover }) end)
        row.MouseLeave:Connect(function() tween(row, 0.15, { BackgroundColor3 = Theme.PanelLt }) end)
        row.MouseButton1Click:Connect(function()
            state = not state
            tween(box, 0.15, { BackgroundColor3 = state and Theme.Accent or Theme.Stroke })
            tween(knob, 0.15, { Position = state and UDim2.new(1, -18, 0, 2) or UDim2.fromOffset(2, 2) })
            if callback then try(function() callback(state) end, "toggle") end
        end)

        return {
            Set = function(_, v)
                state = v and true or false
                box.BackgroundColor3 = state and Theme.Accent or Theme.Stroke
                knob.Position = state and UDim2.new(1, -18, 0, 2) or UDim2.fromOffset(2, 2)
            end,
        }
    end

    function section:AddSlider(label, min, max, default, callback)
        local value = default or min

        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, 48),
            BackgroundColor3 = Theme.PanelLt,
            BorderSizePixel = 0,
            LayoutOrder = nextOrder(),
            Parent = page,
        })
        corner(row, 6)
        stroke(row)

        new("TextLabel", {
            Text = label,
            Font = FontMed,
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
            Font = FontBold,
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

        local draggingSlider = false
        local function update(input)
            local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * rel)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            valLbl.Text = tostring(value)
            if callback then try(function() callback(value) end, "slider") end
        end

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = true
                update(input)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSlider = false
            end
        end)

        return {
            Set = function(_, v)
                value = math.clamp(v, min, max)
                local rel = (value - min) / (max - min)
                fill.Size = UDim2.new(rel, 0, 1, 0)
                knob.Position = UDim2.new(rel, 0, 0.5, 0)
                valLbl.Text = tostring(value)
            end,
        }
    end

    function section:AddButton(label, callback)
        local btn = new("TextButton", {
            Text = label,
            Font = FontMed,
            TextSize = 13,
            TextColor3 = Theme.Text,
            BackgroundColor3 = Theme.PanelLt,
            AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 34),
            LayoutOrder = nextOrder(),
            Parent = page,
        })
        corner(btn, 6)
        stroke(btn)
        btn.MouseEnter:Connect(function() tween(btn, 0.15, { BackgroundColor3 = Theme.Hover }) end)
        btn.MouseLeave:Connect(function() tween(btn, 0.15, { BackgroundColor3 = Theme.PanelLt }) end)
        btn.MouseButton1Click:Connect(function()
            if callback then try(callback, "button") end
        end)
        return btn
    end

    function section:AddDropdown(label, options, default, callback)
        options = options or {}
        local selected = default or options[1] or "None"
        local open = false
        local itemHeight = 30

        local holder = new("Frame", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.PanelLt,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            LayoutOrder = nextOrder(),
            Parent = page,
        })
        corner(holder, 6)
        stroke(holder)

        local head = new("TextButton", {
            Text = "",
            AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundTransparency = 1,
            Parent = holder,
        })

        new("TextLabel", {
            Text = label,
            Font = FontMed,
            TextSize = 13,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 0),
            Size = UDim2.new(0.5, 0, 1, 0),
            Parent = head,
        })

        local valLbl = new("TextLabel", {
            Text = tostring(selected),
            Font = FontBold,
            TextSize = 12,
            TextColor3 = Theme.Accent,
            TextXAlignment = Enum.TextXAlignment.Right,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.new(0.5, -14, 1, 0),
            Parent = head,
        })

        local list = new("Frame", {
            Size = UDim2.new(1, -16, 0, #options * (itemHeight + 4)),
            Position = UDim2.new(0, 8, 0, 40),
            BackgroundTransparency = 1,
            Parent = holder,
        })
        new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })

        for _, opt in ipairs(options) do
            local oBtn = new("TextButton", {
                Text = tostring(opt),
                Font = Font,
                TextSize = 12,
                TextColor3 = Theme.Sub,
                BackgroundColor3 = Theme.Hover,
                AutoButtonColor = false,
                Size = UDim2.new(1, 0, 0, itemHeight),
                Parent = list,
            })
            corner(oBtn, 4)
            oBtn.MouseEnter:Connect(function() tween(oBtn, 0.1, { TextColor3 = Theme.Text }) end)
            oBtn.MouseLeave:Connect(function() tween(oBtn, 0.1, { TextColor3 = Theme.Sub }) end)
            oBtn.MouseButton1Click:Connect(function()
                selected = opt
                valLbl.Text = tostring(opt)
                open = false
                tween(holder, 0.2, { Size = UDim2.new(1, 0, 0, 36) })
                if callback then try(function() callback(opt) end, "dropdown") end
            end)
        end

        head.MouseButton1Click:Connect(function()
            open = not open
            local target = open and UDim2.new(1, 0, 0, 36 + #options * (itemHeight + 4) + 8) or UDim2.new(1, 0, 0, 36)
            tween(holder, 0.2, { Size = target })
        end)

        return {
            Set = function(_, v)
                selected = v
                valLbl.Text = tostring(v)
                if callback then try(function() callback(v) end, "dropdown") end
            end,
        }
    end

    function section:AddTextbox(label, default, callback)
        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Theme.PanelLt,
            BorderSizePixel = 0,
            LayoutOrder = nextOrder(),
            Parent = page,
        })
        corner(row, 6)
        stroke(row)

        new("TextLabel", {
            Text = label,
            Font = FontMed,
            TextSize = 13,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 6),
            Size = UDim2.new(1, -28, 0, 16),
            Parent = row,
        })

        local box = new("TextBox", {
            Text = tostring(default or ""),
            Font = Font,
            TextSize = 12,
            TextColor3 = Theme.Text,
            BackgroundColor3 = Theme.Bg,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 14, 0, 26),
            Size = UDim2.new(1, -28, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            Parent = row,
        })
        corner(box, 4)
        new("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = box })

        box.FocusLost:Connect(function()
            if callback then try(function() callback(box.Text) end, "textbox") end
        end)

        return {
            Set = function(_, v) box.Text = tostring(v) end,
            Get = function() return box.Text end,
        }
    end

    function section:AddLabel(text)
        local holder = new("Frame", {
            Size = UDim2.new(1, 0, 0, 46),
            BackgroundColor3 = Theme.PanelLt,
            BorderSizePixel = 0,
            LayoutOrder = nextOrder(),
            Parent = page,
        })
        corner(holder, 6)
        stroke(holder)

        local lbl = new("TextLabel", {
            Text = text or "",
            Font = Font,
            TextSize = 12,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 0),
            Size = UDim2.new(1, -28, 1, 0),
            TextWrapped = true,
            Parent = holder,
        })

        return {
            SetText = function(_, t) lbl.Text = t end,
            Instance = holder,
        }
    end

    function section:AddKeybind(label, default, callback)
        local key = default or Enum.KeyCode.RightShift
        local listening = false

        local row = new("TextButton", {
            Text = "",
            AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.PanelLt,
            BorderSizePixel = 0,
            LayoutOrder = nextOrder(),
            Parent = page,
        })
        corner(row, 6)
        stroke(row)

        new("TextLabel", {
            Text = label,
            Font = FontMed,
            TextSize = 13,
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 0),
            Size = UDim2.new(0.5, 0, 1, 0),
            Parent = row,
        })

        local keyLbl = new("TextLabel", {
            Text = key.Name,
            Font = FontBold,
            TextSize = 12,
            TextColor3 = Theme.Accent,
            TextXAlignment = Enum.TextXAlignment.Right,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.new(0.5, -14, 1, 0),
            Parent = row,
        })

        row.MouseButton1Click:Connect(function()
            listening = true
            keyLbl.Text = "..."
        end)

        UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode
                keyLbl.Text = key.Name
                listening = false
                if callback then try(function() callback(key) end, "keybind") end
            end
        end)

        return {
            Get = function() return key end,
        }
    end

    function section:AddSection(title)
        nextOrder()
        local header = new("Frame", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1,
            LayoutOrder = orderRef.n,
            Parent = page,
        })
        new("TextLabel", {
            Text = string.upper(tostring(title)),
            Font = FontBold,
            TextSize = 11,
            TextColor3 = Theme.Accent,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 4, 0, 8),
            Size = UDim2.new(1, -8, 0, 16),
            Parent = header,
        })
        return makeSection(page, orderRef)
    end

    return section
end

local tabs = {}
local activeTab = nil

local function selectTab(tab)
    for _, t in ipairs(tabs) do
        t.Page.Visible = false
        tween(t.Button, 0.15, { BackgroundColor3 = Theme.PanelLt, TextColor3 = Theme.Sub })
    end
    tab.Page.Visible = true
    tween(tab.Button, 0.15, { BackgroundColor3 = Theme.Accent, TextColor3 = Color3.new(1, 1, 1) })
    activeTab = tab
end

local function createTab(name)
    local tab = { Name = name }

    local textSize = TextService:GetTextSize(name, 13, FontMed, Vector2.new(1000, 40))
    local btnWidth = math.max(textSize.X + 28, 70)

    local btn = new("TextButton", {
        Text = name,
        Font = FontMed,
        TextSize = 13,
        TextColor3 = Theme.Sub,
        BackgroundColor3 = Theme.PanelLt,
        AutoButtonColor = false,
        Size = UDim2.fromOffset(btnWidth, 32),
        ZIndex = 12,
        Parent = TabBar,
    })
    corner(btn, 6)

    local page = new("ScrollingFrame", {
        Size = UDim2.new(1, -16, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        ZIndex = 12,
        Parent = Content,
    })
    new("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = page,
    })
    new("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = page })

    tab.Button = btn
    tab.Page = page

    btn.MouseEnter:Connect(function()
        if activeTab ~= tab then tween(btn, 0.1, { BackgroundColor3 = Theme.Hover }) end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= tab then tween(btn, 0.1, { BackgroundColor3 = Theme.PanelLt }) end
    end)
    btn.MouseButton1Click:Connect(function() selectTab(tab) end)

    table.insert(tabs, tab)
    if #tabs == 1 then selectTab(tab) end

    local orderRef = { n = 0 }
    return makeSection(page, orderRef)
end

local farmTab = createTab("Farm")
local farmSec = farmTab:AddSection("Autofarm")

if farm then
    farmSec:AddToggle("Autofarm", false, function(s)
        if s then farm:Start() else farm:Stop() end
    end)
    farmSec:AddToggle("Noclip", true, function(s) farm:SetNoclip(s) end)
    farmSec:AddToggle("Camera Noclip", false, function(s) farm:SetCameraNoclip(s) end)
    farmSec:AddToggle("Random TP", true, function(s) farm:SetConfig("RandomTP", s) end)
    farmSec:AddToggle("Auto Sell", (farm.Config and farm.Config.AutoSell) or false, function(s)
        farm:SetConfig("AutoSell", s); farm:SaveConfig()
    end)
    farmSec:AddToggle("Server Hop", (farm.Config and farm.Config.ServerHop) or false, function(s)
        farm:SetConfig("ServerHop", s); farm:SaveConfig()
        if s then farm:StartServerHopLoop() else farm:StopServerHopLoop() end
    end)
    farmSec:AddSlider("TP Offset", 0, 15, (farm.Config and farm.Config.TPOffset) or 6, function(v)
        farm:SetConfig("TPOffset", v); farm:SaveConfig()
    end)
    farmSec:AddSlider("E Hold Time x10", 0, 50, math.floor(((farm.Config and farm.Config.EHoldTime) or 1) * 10), function(v)
        farm:SetConfig("EHoldTime", v / 10); farm:SaveConfig()
    end)
    farmSec:AddSlider("E Range", 10, 200, (farm.Config and farm.Config.ERange) or 50, function(v)
        farm:SetConfig("ERange", v); farm:SaveConfig()
    end)
    farmSec:AddSlider("TP Speed x10", 1, 50, math.floor(((farm.Config and farm.Config.TPSpeed) or 1.1) * 10), function(v)
        farm:SetConfig("TPSpeed", v / 10); farm:SaveConfig()
    end)
    farmSec:AddButton("TP to Merchant", function() farm:TeleportToMerchant() end)
    farmSec:AddButton("Save Config", function() farm:SaveConfig() end)
else
    farmSec:AddLabel("autofarm.lua not loaded")
end

local optTab = createTab("Optimization")
local optSec = optTab:AddSection("Performance")

if farm then
    optSec:AddSlider("FPS Cap", 30, 240, (farm.Config and farm.Config.FPSCap) or 60, function(v)
        farm:SetConfig("FPSCap", v); farm:ApplyFPSCap(v); farm:SaveConfig()
    end)
    optSec:AddSlider("Render Distance", 1, 20, (farm.Config and farm.Config.RenderDistance) or 5, function(v)
        farm:SetConfig("RenderDistance", v); farm:ApplyRenderDistance(v); farm:SaveConfig()
    end)
    optSec:AddToggle("Remove Trees/Bushes", (farm.Config and farm.Config.RemoveTrees) or false, function(s)
        farm:SetConfig("RemoveTrees", s)
        if s then farm:RemoveTreesAndBushes() end
        farm:SaveConfig()
    end)
else
    optSec:AddLabel("autofarm.lua not loaded")
end

local visTab = createTab("Visuals")
local visSec = visTab:AddSection("Players")

if visuals then
    visSec:AddToggle("Player ESP", false, function(s) visuals:SetESP(s) end)
    visSec:AddToggle("3D OFF", false, function(s) visuals:Set3DOff(s) end)
else
    visSec:AddLabel("visuals.lua not loaded")
end

local plTab = createTab("Player")

if playerMod then
    local pls = plTab:AddSection("Movement")
    pls:AddToggle("Noclip", false, function(s) playerMod:SetNoclip(s) end)
    pls:AddToggle("Fly", false, function(s) playerMod:SetFly(s) end)
    pls:AddSlider("Fly Speed x10", 1, 100, 10, function(v) playerMod:SetFlySpeed(v / 10) end)
    pls:AddToggle("Click TP (Tool)", false, function(s) playerMod:SetClickTP(s) end)
end

if invis then
    local isec = plTab:AddSection("Invisibility")
    isec:AddToggle("Invisible", false, function(s) invis:SetEnabled(s) end)
    isec:AddToggle("Red Glow", true, function(s) invis:SetGlow(s) end)
    isec:AddToggle("Ghost Walk", false, function(s) invis:SetGhostWalk(s) end)
end

local sfTab = createTab("SF")
local sfSec = sfTab:AddSection("Selected Players")

if sf then
    local names = sf:GetPlayerNames()
    local sel = names[1] or ""

    sfSec:AddDropdown("Player", names, names[1] or "None", function(v) sel = v end)
    sfSec:AddButton("Select", function()
        if sel ~= "" then
            local list = sf:GetSelected()
            table.insert(list, sel)
            sf:SetSelected(list)
        end
    end)
    sfSec:AddButton("Deselect", function()
        if sel ~= "" then sf:Deselect(sel) end
    end)
    sfSec:AddButton("Clear All", function() sf:ClearSelected() end)
    sfSec:AddButton("Apply Hitbox", function()
        for _, n in ipairs(sf:GetSelected()) do
            local p = Players:FindFirstChild(n)
            if p then sf:ApplyHitbox(p) end
        end
    end)
else
    sfSec:AddLabel("sf.lua not loaded")
end

local wTab = createTab("Weather")
local wSec = wTab:AddSection("Weather")

if weather then
    for _, w in ipairs(weather:GetOptions()) do
        wSec:AddButton("Set " .. w, function() weather:Set(w) end)
    end
    wSec:AddButton("Cycle", function() weather:Cycle() end)
else
    wSec:AddLabel("weather.lua not loaded")
end

local sTab = createTab("Stats")
local sSec = sTab:AddSection("Session")

if farm then
    local statLbl = sSec:AddLabel("Picked: 0 | TP: 0\nLast: -")
    local function refresh()
        local s = farm:GetStats()
        if not s then return end
        statLbl:SetText(string.format("Picked: %d | TP: %d\nLast: %s", s.totalPicked or 0, s.totalTPs or 0, s.lastPickedItem or "-"))
    end
    task.spawn(function()
        while true do
            try(refresh, "stats")
            task.wait(0.5)
        end
    end)
    farm:SetCallback("OnStatsUpdate", refresh)
    farm:SetCallback("OnPickup", refresh)
else
    sSec:AddLabel("autofarm.lua not loaded")
end

if farm then
    if farm.Config then
        try(function() farm:ApplyFPSCap(farm.Config.FPSCap) end, "FPSCap")
        try(function() farm:ApplyRenderDistance(farm.Config.RenderDistance) end, "RD")
        if farm.Config.RemoveTrees then try(function() farm:RemoveTreesAndBushes() end, "Trees") end
        if farm.Config.ServerHop then try(function() farm:StartServerHopLoop() end, "Hop") end
    end
end

print("[Void] Menu loaded. Press TAB or RightShift.")

end

local ks = KeySystem.new(function(key, info)
    print("[Void] Access granted | Tier:", info.tier)
    startMain()
end)

ks:Prompt()
