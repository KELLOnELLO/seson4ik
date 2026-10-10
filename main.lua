-- ============================================================
--   VOID | YBA - Single File Menu
--   Author: Wzxx
--   Repo:   KELLOnELLO/seson4ik
-- ============================================================

-- ==================== SERVICES ====================
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local Lighting         = game:GetService("Lighting")
local HttpService      = game:GetService("HttpService")
local LocalPlayer      = Players.LocalPlayer

-- ==================== MODULE LOADER ====================
local Loaded = {}
local function safeLoad(url, name)
    local bust = url .. "?t=" .. tostring(os.time())
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(bust))()
    end)
    if ok and result then
        print("[Void] Loaded module:", name)
        Loaded[name] = result
        return result
    else
        warn("[Void] Failed to load module:", name, result)
        return nil
    end
end

local AutoFarm  = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/autofarm.lua", "AutoFarm")
local Invis     = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/invis.lua", "Invis")
local SF        = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/sf.lua", "SF")
local Weather   = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/weather.lua", "Weather")
local Visuals   = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/visuals.lua", "Visuals")
local PlayerMod = safeLoad("https://raw.githubusercontent.com/KELLOnELLO/functionssssz/main/player.lua", "PlayerMod")

-- ==================== THEME ====================
local T = {
    Bg         = Color3.fromRGB(15, 15, 19),
    BgDeep     = Color3.fromRGB(11, 11, 14),
    Panel      = Color3.fromRGB(20, 20, 25),
    PanelLt    = Color3.fromRGB(28, 28, 34),
    PanelHover = Color3.fromRGB(36, 36, 44),
    Stroke     = Color3.fromRGB(45, 45, 55),
    Text       = Color3.fromRGB(235, 235, 240),
    Sub        = Color3.fromRGB(130, 130, 145),
    Muted      = Color3.fromRGB(90, 90, 105),
    Accent     = Color3.fromRGB(155, 89, 255),
    AccentDim  = Color3.fromRGB(110, 60, 190),
    Red        = Color3.fromRGB(220, 70, 70),
    Green      = Color3.fromRGB(80, 200, 120),
    Yellow     = Color3.fromRGB(220, 190, 70),
}

-- ==================== HELPERS ====================
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

local function stroke(p, color, thickness)
    return new("UIStroke", {
        Color = color or T.Stroke,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = p,
    })
end

local function tween(o, t, props)
    pcall(function()
        TweenService:Create(o, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
    end)
end

local function safeParent(g)
    pcall(function() g.Parent = CoreGui end)
    if not g.Parent then
        pcall(function() g.Parent = LocalPlayer:WaitForChild("PlayerGui") end)
    end
end

local function try(fn, name)
    local ok, err = pcall(fn)
    if not ok then
        warn("[Void] " .. tostring(name) .. ":", err)
    end
    return ok
end

-- ==================== CLEANUP ====================
try(function()
    for _, n in ipairs({"VoidYBA", "VoidVisualsESP", "Void3DOffOverlay", "NeverloseUI"}) do
        local a = CoreGui:FindFirstChild(n); if a then a:Destroy() end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            local b = pg:FindFirstChild(n); if b then b:Destroy() end
        end
    end
    local bl = Lighting:FindFirstChild("NL_Blur"); if bl then bl:Destroy() end
    local snow = CoreGui:FindFirstChild("VoidSnow"); if snow then snow:Destroy() end
end, "cleanup")

-- ==================== MODULE INIT ====================
local farm, invis, sf, weather, visuals, playerMod

if AutoFarm then try(function() farm = AutoFarm.new() end, "farm.new") end
if farm then
    try(function() farm:LoadConfig() end, "farm:LoadConfig")
    try(function() farm:SkipLoading() end, "farm:SkipLoading")
    try(function() farm:EnableKeyBypass() end, "farm:EnableKeyBypass")
    try(function() farm:SetCharacterRespawnHandler() end, "farm:Respawn")
end
if Invis then try(function() invis = Invis.new() end, "invis.new") end
if invis then try(function() invis:HookRespawn() end, "invis:HookRespawn") end
if SF then try(function() sf = SF.new() end, "sf.new") end
if sf then try(function() sf:Setup() end, "sf:Setup") end
if Weather then try(function() weather = Weather.new() end, "weather.new") end
if weather then try(function() weather:WaitForWeatherValue(10) end, "weather:Wait") end
if Visuals then try(function() visuals = Visuals.new() end, "visuals.new") end
if PlayerMod then try(function() playerMod = PlayerMod.new() end, "playerMod.new") end
if playerMod then try(function() playerMod:HookRespawn() end, "playerMod:Respawn") end

-- ==================== GUI ROOT ====================
local Blur = new("BlurEffect", { Name = "NL_Blur", Size = 0, Parent = Lighting })

local Gui = new("ScreenGui", {
    Name = "VoidYBA",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100,
})
safeParent(Gui)

local Darken = new("Frame", {
    Name = "Darken",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 0.55,
    BorderSizePixel = 0,
    ZIndex = 1,
    Parent = Gui,
})

local Snow = new("Frame", {
    Name = "Snow",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ZIndex = 2,
    Parent = Gui,
})

local Main = new("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(780, 520),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = T.Bg,
    BorderSizePixel = 0,
    ZIndex = 10,
    Parent = Gui,
})
corner(Main, 10)
stroke(Main, T.Stroke)

-- ==================== TOP BAR ====================
local TopBar = new("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = T.Panel,
    BorderSizePixel = 0,
    ZIndex = 11,
    Parent = Main,
})
corner(TopBar, 10)
new("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = T.Panel,
    BorderSizePixel = 0,
    ZIndex = 11,
    Parent = TopBar,
})

local logoDot = new("Frame", {
    Size = UDim2.fromOffset(8, 8),
    Position = UDim2.new(0, 18, 0.5, -4),
    BackgroundColor3 = T.Accent,
    BorderSizePixel = 0,
    ZIndex = 12,
    Parent = TopBar,
})
corner(logoDot, 4)

new("TextLabel", {
    Text = "Neverlose | YBA",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = T.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 34, 0, 0),
    Size = UDim2.new(1, -200, 1, 0),
    ZIndex = 12,
    Parent = TopBar,
})

local keyHint = new("TextLabel", {
    Text = "TAB",
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextColor3 = T.Sub,
    BackgroundColor3 = T.PanelLt,
    TextXAlignment = Enum.TextXAlignment.Center,
    Position = UDim2.new(1, -100, 0.5, -9),
    Size = UDim2.fromOffset(42, 18),
    ZIndex = 12,
    Parent = TopBar,
})
corner(keyHint, 4)

local statusDot = new("Frame", {
    Size = UDim2.fromOffset(6, 6),
    Position = UDim2.new(1, -50, 0.5, -3),
    BackgroundColor3 = T.Green,
    BorderSizePixel = 0,
    ZIndex = 12,
    Parent = TopBar,
})
corner(statusDot, 3)

local CloseBtn = new("TextButton", {
    Text = "X",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = T.Sub,
    BackgroundColor3 = T.PanelLt,
    AutoButtonColor = false,
    Position = UDim2.new(1, -40, 0.5, -14),
    Size = UDim2.fromOffset(28, 28),
    ZIndex = 12,
    Parent = TopBar,
})
corner(CloseBtn, 6)
CloseBtn.MouseEnter:Connect(function() tween(CloseBtn, 0.15, { BackgroundColor3 = T.Red, TextColor3 = Color3.new(1, 1, 1) }) end)
CloseBtn.MouseLeave:Connect(function() tween(CloseBtn, 0.15, { BackgroundColor3 = T.PanelLt, TextColor3 = T.Sub }) end)

-- ==================== TAB BAR ====================
local TabBar = new("Frame", {
    Name = "TabBar",
    Size = UDim2.new(1, -20, 0, 36),
    Position = UDim2.new(0, 10, 0, 54),
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

-- ==================== CONTENT ====================
local Content = new("Frame", {
    Name = "Content",
    Size = UDim2.new(1, -20, 1, -110),
    Position = UDim2.new(0, 10, 0, 100),
    BackgroundColor3 = T.Panel,
    BorderSizePixel = 0,
    ZIndex = 11,
    Parent = Main,
})
corner(Content, 8)
stroke(Content, T.Stroke)

-- ==================== DRAGGING ====================
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
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

-- ==================== TOGGLE ====================
local menuVisible = true
local function toggleMenu()
    menuVisible = not menuVisible
    Main.Visible = menuVisible
    Darken.Visible = menuVisible
    Snow.Visible = menuVisible
end
CloseBtn.MouseButton1Click:Connect(toggleMenu)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Tab or input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)

-- ==================== SNOW ====================
local snowFolder = new("Folder", { Name = "Flakes", Parent = Snow })
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
    table.insert(flakes, {
        obj = f,
        speed = math.random(30, 90) / 100,
        drift = math.random(-15, 15) / 100,
    })
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

-- ==================== BLUR ====================
RunService.RenderStepped:Connect(function()
    local target = menuVisible and 18 or 0
    if math.abs(Blur.Size - target) > 0.5 then
        Blur.Size = Blur.Size + (target - Blur.Size) * 0.2
    else
        Blur.Size = target
    end
end)

-- ==================== TAB SYSTEM ====================
local tabs = {}
local activeTab = nil

local function selectTab(tab)
    for _, t in ipairs(tabs) do
        t.Page.Visible = false
        tween(t.Button, 0.15, { BackgroundColor3 = T.PanelLt, TextColor3 = T.Sub })
    end
    tab.Page.Visible = true
    tween(tab.Button, 0.15, { BackgroundColor3 = T.Accent, TextColor3 = Color3.new(1, 1, 1) })
    activeTab = tab
end

local function createTab(name)
    local tab = { Name = name }

    local btn = new("TextButton", {
        Text = name,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = T.Sub,
        BackgroundColor3 = T.PanelLt,
        AutoButtonColor = false,
        Size = UDim2.fromOffset(0, 32),
        AutomaticSize = Enum.AutomaticSize.X,
        ZIndex = 12,
        Parent = TabBar,
    })
    corner(btn, 6)
    new("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14), Parent = btn })

    local page = new("ScrollingFrame", {
        Size = UDim2.new(1, -16, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = T.Accent,
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
    new("UIPadding", { PaddingTop = UDim.new(0, 4), Parent = page })

    tab.Button = btn
    tab.Page = page

    btn.MouseEnter:Connect(function()
        if activeTab ~= tab then tween(btn, 0.1, { BackgroundColor3 = T.PanelHover }) end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= tab then tween(btn, 0.1, { BackgroundColor3 = T.PanelLt }) end
    end)
    btn.MouseButton1Click:Connect(function() selectTab(tab) end)

    table.insert(tabs, tab)
    if #tabs == 1 then selectTab(tab) end

    -- ==================== SECTION ====================
    local section = {}

    local header = new("Frame", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        LayoutOrder = #page:GetChildren(),
        Parent = page,
    })
    new("TextLabel", {
        Text = string.upper(name),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = T.Accent,
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
            BackgroundColor3 = T.PanelLt,
            BorderSizePixel = 0,
            LayoutOrder = #page:GetChildren(),
            Parent = page,
        })
        corner(row, 6)
        stroke(row)

        new("TextLabel", {
            Text = label,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = T.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 0),
            Size = UDim2.new(1, -70, 1, 0),
            Parent = row,
        })

        local box = new("Frame", {
            Size = UDim2.fromOffset(38, 20),
            Position = UDim2.new(1, -52, 0.5, -10),
            BackgroundColor3 = state and T.Accent or T.Stroke,
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

        row.MouseEnter:Connect(function() tween(row, 0.15, { BackgroundColor3 = T.PanelHover }) end)
        row.MouseLeave:Connect(function() tween(row, 0.15, { BackgroundColor3 = T.PanelLt }) end)
        row.MouseButton1Click:Connect(function()
            state = not state
            tween(box, 0.15, { BackgroundColor3 = state and T.Accent or T.Stroke })
            tween(knob, 0.15, { Position = state and UDim2.new(1, -18, 0, 2) or UDim2.fromOffset(2, 2) })
            if callback then try(function() callback(state) end, "toggle callback") end
        end)

        return {
            Set = function(_, v)
                state = v and true or false
                box.BackgroundColor3 = state and T.Accent or T.Stroke
                knob.Position = state and UDim2.new(1, -18, 0, 2) or UDim2.fromOffset(2, 2)
            end,
        }
    end

    -- Slider
    function section:AddSlider(label, min, max, default, callback)
        local value = default or min
        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, 48),
            BackgroundColor3 = T.PanelLt,
            BorderSizePixel = 0,
            LayoutOrder = #page:GetChildren(),
            Parent = page,
        })
        corner(row, 6)
        stroke(row)

        new("TextLabel", {
            Text = label,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = T.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 6),
            Size = UDim2.new(0.6, 0, 0, 16),
            Parent = row,
        })

        local valLbl = new("TextLabel", {
            Text = tostring(value),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = T.Accent,
            TextXAlignment = Enum.TextXAlignment.Right,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.6, 0, 6, 0),
            Size = UDim2.new(0.4, -16, 0, 16),
            Parent = row,
        })

        local bar = new("Frame", {
            Size = UDim2.new(1, -28, 0, 6),
            Position = UDim2.new(0, 14, 1, -18),
            BackgroundColor3 = T.Stroke,
            BorderSizePixel = 0,
            Parent = row,
        })
        corner(bar, 4)

        local fill = new("Frame", {
            Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = T.Accent,
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
            if callback then try(function() callback(value) end, "slider callback") end
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

    -- Button
    function section:AddButton(label, callback)
        local btn = new("TextButton", {
            Text = label,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = T.Text,
            BackgroundColor3 = T.PanelLt,
            AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 34),
            LayoutOrder = #page:GetChildren(),
            Parent = page,
        })
        corner(btn, 6)
        stroke(btn)
        btn.MouseEnter:Connect(function() tween(btn, 0.15, { BackgroundColor3 = T.PanelHover }) end)
        btn.MouseLeave:Connect(function() tween(btn, 0.15, { BackgroundColor3 = T.PanelLt }) end)
        btn.MouseButton1Click:Connect(function()
            if callback then try(callback, "button callback") end
        end)
        return btn
    end

    -- Dropdown
    function section:AddDropdown(label, options, default, callback)
        options = options or {}
        local selected = default or options[1] or "None"
        local open = false

        local holder = new("Frame", {
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = T.PanelLt,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            LayoutOrder = #page:GetChildren(),
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
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = T.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 0),
            Size = UDim2.new(0.5, 0, 1, 0),
            Parent = head,
        })

        local valLbl = new("TextLabel", {
            Text = tostring(selected),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = T.Accent,
            TextXAlignment = Enum.TextXAlignment.Right,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0, 0),
            Size = UDim2.new(0.5, -14, 1, 0),
            Parent = head,
        })

        local list = new("Frame", {
            Size = UDim2.new(1, -16, 0, 0),
            Position = UDim2.new(0, 8, 0, 40),
            BackgroundTransparency = 1,
            Parent = holder,
        })
        new("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })

        for _, opt in ipairs(options) do
            local oBtn = new("TextButton", {
                Text = tostring(opt),
                Font = Enum.Font.Gotham,
                TextSize = 12,
                TextColor3 = T.Sub,
                BackgroundColor3 = T.PanelHover,
                AutoButtonColor = false,
                Size = UDim2.new(1, 0, 0, 26),
                Parent = list,
            })
            corner(oBtn, 4)
            oBtn.MouseEnter:Connect(function() tween(oBtn, 0.1, { TextColor3 = T.Text }) end)
            oBtn.MouseLeave:Connect(function() tween(oBtn, 0.1, { TextColor3 = T.Sub }) end)
            oBtn.MouseButton1Click:Connect(function()
                selected = opt
                valLbl.Text = tostring(opt)
                open = false
                tween(holder, 0.2, { Size = UDim2.new(1, 0, 0, 36) })
                if callback then try(function() callback(opt) end, "dropdown callback") end
            end)
        end

        head.MouseButton1Click:Connect(function()
            open = not open
            local target = open and UDim2.new(1, 0, 0, 36 + #options * 30 + 8) or UDim2.new(1, 0, 0, 36)
            tween(holder, 0.2, { Size = target })
        end)

        return {
            Set = function(_, v)
                selected = v
                valLbl.Text = tostring(v)
                if callback then try(function() callback(v) end, "dropdown callback") end
            end,
        }
    end

    -- Textbox
    function section:AddTextbox(label, default, callback)
        local row = new("Frame", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = T.PanelLt,
            BorderSizePixel = 0,
            LayoutOrder = #page:GetChildren(),
            Parent = page,
        })
        corner(row, 6)
        stroke(row)

        new("TextLabel", {
            Text = label,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = T.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 6),
            Size = UDim2.new(1, -28, 0, 16),
            Parent = row,
        })

        local box = new("TextBox", {
            Text = tostring(default or ""),
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextColor3 = T.Text,
            BackgroundColor3 = T.BgDeep,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 14, 0, 26),
            Size = UDim2.new(1, -28, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            Parent = row,
        })
        corner(box, 4)

        box.FocusLost:Connect(function()
            if callback then try(function() callback(box.Text) end, "textbox callback") end
        end)

        return {
            Set = function(_, v) box.Text = tostring(v) end,
            Get = function() return box.Text end,
        }
    end

    -- Label
    function section:AddLabel(defaultText)
        local holder = new("Frame", {
            Size = UDim2.new(1, 0, 0, 46),
            BackgroundColor3 = T.PanelLt,
            BorderSizePixel = 0,
            LayoutOrder = #page:GetChildren(),
            Parent = page,
        })
        corner(holder, 6)
        stroke(holder)

        local lbl = new("TextLabel", {
            Text = defaultText or "",
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextColor3 = T.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 0),
            Size = UDim2.new(1, -28, 1, 0),
            TextWrapped = true,
            Parent = holder,
        })

        return {
            SetText = function(_, text) lbl.Text = text end,
            Instance = holder,
        }
    end

    -- Keybind
    function section:AddKeybind(label, default, callback)
        local key = default or Enum.KeyCode.RightShift
        local listening = false

        local row = new("TextButton", {
            Text = "",
            AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = T.PanelLt,
            BorderSizePixel = 0,
            LayoutOrder = #page:GetChildren(),
            Parent = page,
        })
        corner(row, 6)
        stroke(row)

        new("TextLabel", {
            Text = label,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = T.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 14, 0, 0),
            Size = UDim2.new(0.5, 0, 1, 0),
            Parent = row,
        })

        local keyLbl = new("TextLabel", {
            Text = key.Name,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            TextColor3 = T.Accent,
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
                if callback then try(function() callback(key) end, "keybind callback") end
            end
        end)

        return {
            Get = function() return key end,
        }
    end

    return section
end

-- ==================== FARM TAB ====================
if farm then
    local ft = createTab("Farm")
    local fs = ft:AddSection("Autofarm")

    fs:AddToggle("Autofarm", false, function(s)
        if s then farm:Start() else farm:Stop() end
    end)
    fs:AddToggle("Noclip", true, function(s) farm:SetNoclip(s) end)
    fs:AddToggle("Camera Noclip", false, function(s) farm:SetCameraNoclip(s) end)
    fs:AddToggle("Random TP", true, function(s) farm:SetConfig("RandomTP", s) end)
    fs:AddToggle("Auto Sell", farm.Config and farm.Config.AutoSell or false, function(s)
        farm:SetConfig("AutoSell", s)
        farm:SaveConfig()
    end)
    fs:AddToggle("Server Hop", farm.Config and farm.Config.ServerHop or false, function(s)
        farm:SetConfig("ServerHop", s)
        farm:SaveConfig()
        if s then farm:StartServerHopLoop() else farm:StopServerHopLoop() end
    end)
    fs:AddSlider("TP Offset", 0, 15, (farm.Config and farm.Config.TPOffset) or 6, function(v)
        farm:SetConfig("TPOffset", v); farm:SaveConfig()
    end)
    fs:AddSlider("E Hold Time x10", 0, 50, math.floor(((farm.Config and farm.Config.EHoldTime) or 1) * 10), function(v)
        farm:SetConfig("EHoldTime", v / 10); farm:SaveConfig()
    end)
    fs:AddSlider("E Range", 10, 200, (farm.Config and farm.Config.ERange) or 50, function(v)
        farm:SetConfig("ERange", v); farm:SaveConfig()
    end)
    fs:AddSlider("TP Speed x10", 1, 50, math.floor(((farm.Config and farm.Config.TPSpeed) or 1.1) * 10), function(v)
        farm:SetConfig("TPSpeed", v / 10); farm:SaveConfig()
    end)
    fs:AddButton("TP to Merchant", function() farm:TeleportToMerchant() end)
    fs:AddButton("Save Config", function() farm:SaveConfig() end)

    -- OPTIMIZATION
    if farm.Config then
        local ot = createTab("Optimization")
        local os = ot:AddSection("Performance")

        os:AddSlider("FPS Cap", 30, 240, farm.Config.FPSCap or 60, function(v)
            farm:SetConfig("FPSCap", v)
            farm:ApplyFPSCap(v)
            farm:SaveConfig()
        end)
        os:AddSlider("Render Distance", 1, 20, farm.Config.RenderDistance or 5, function(v)
            farm:SetConfig("RenderDistance", v)
            farm:ApplyRenderDistance(v)
            farm:SaveConfig()
        end)
        os:AddToggle("Remove Trees/Bushes", farm.Config.RemoveTrees or false, function(s)
            farm:SetConfig("RemoveTrees", s)
            if s then farm:RemoveTreesAndBushes() end
            farm:SaveConfig()
        end)
    end
end

-- ==================== VISUALS TAB ====================
if visuals then
    local vt = createTab("Visuals")
    local vs = vt:AddSection("Players")
    vs:AddToggle("Player ESP", false, function(s) visuals:SetESP(s) end)
    vs:AddToggle("3D OFF", false, function(s) visuals:Set3DOff(s) end)
end

-- ==================== PLAYER TAB ====================
if playerMod or invis then
    local pt = createTab("Player")

    if playerMod then
        local ps = pt:AddSection("Movement")
        ps:AddToggle("Noclip", false, function(s) playerMod:SetNoclip(s) end)
        ps:AddToggle("Fly", false, function(s) playerMod:SetFly(s) end)
        ps:AddSlider("Fly Speed x10", 1, 100, 10, function(v)
            playerMod:SetFlySpeed(v / 10)
        end)
        ps:AddToggle("Click TP (Tool)", false, function(s) playerMod:SetClickTP(s) end)
    end

    if invis then
        local isec = pt:AddSection("Invisibility")
        isec:AddToggle("Invisible", false, function(s) invis:SetEnabled(s) end)
        isec:AddToggle("Red Glow", true, function(s) invis:SetGlow(s) end)
        isec:AddToggle("Ghost Walk", false, function(s) invis:SetGhostWalk(s) end)
    end
end

-- ==================== SF TAB ====================
if sf then
    local st = createTab("SF")
    local ss = st:AddSection("Selected Players")

    local playerNames = sf:GetPlayerNames()
    local selDropdown = playerNames[1] or ""

    ss:AddDropdown("Player", playerNames, playerNames[1] or "None", function(v)
        selDropdown = v
    end)

    ss:AddButton("Select", function()
        if selDropdown and selDropdown ~= "" then
            local list = sf:GetSelected()
            table.insert(list, selDropdown)
            sf:SetSelected(list)
        end
    end)
    ss:AddButton("Deselect", function()
        if selDropdown and selDropdown ~= "" then
            sf:Deselect(selDropdown)
        end
    end)
    ss:AddButton("Clear All", function() sf:ClearSelected() end)
    ss:AddButton("Apply Hitbox", function()
        for _, n in ipairs(sf:GetSelected()) do
            local p = Players:FindFirstChild(n)
            if p then sf:ApplyHitbox(p) end
        end
    end)
end

-- ==================== WEATHER TAB ====================
if weather then
    local wt = createTab("Weather")
    local ws = wt:AddSection("Weather")

    for _, w in ipairs(weather:GetOptions()) do
        ws:AddButton("Set " .. w, function() weather:Set(w) end)
    end
    ws:AddButton("Cycle", function() weather:Cycle() end)
end

-- ==================== STATS TAB ====================
if farm then
    local stt = createTab("Stats")
    local sts = stt:AddSection("Session")
    local statLbl = sts:AddLabel("Picked: 0 | TP: 0\nLast: -")

    local function refresh()
        local s = farm:GetStats()
        if not s then return end
        statLbl:SetText(string.format(
            "Picked: %d | TP: %d\nLast: %s",
            s.totalPicked or 0, s.totalTPs or 0, s.lastPickedItem or "-"
        ))
    end

    task.spawn(function()
        while true do
            try(refresh, "stats refresh")
            task.wait(0.5)
        end
    end)

    farm:SetCallback("OnStatsUpdate", refresh)
    farm:SetCallback("OnPickup", refresh)
end

-- ==================== APPLY SAVED CONFIG ====================
if farm then
    if farm.Config then
        if farm.Config.FPSCap then try(function() farm:ApplyFPSCap(farm.Config.FPSCap) end, "ApplyFPSCap") end
        if farm.Config.RenderDistance then try(function() farm:ApplyRenderDistance(farm.Config.RenderDistance) end, "ApplyRenderDist") end
        if farm.Config.RemoveTrees then try(function() farm:RemoveTreesAndBushes() end, "RemoveTrees") end
        if farm.Config.ServerHop then try(function() farm:StartServerHopLoop() end, "ServerHop") end
        if weather then try(function() farm:SetWeather(weather:GetCurrent() or "Sunny") end, "SetWeather") end
    end
end

-- ==================== DONE ====================
print("[Void] Menu loaded successfully. Press TAB or RightShift.")
