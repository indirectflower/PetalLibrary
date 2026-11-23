local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local new = Vector2.new
local new2 = UDim2.new
local fromOffset = UDim2.fromOffset
local fromRGB = Color3.fromRGB
local floor2 = math.floor
local round = math.round

------------------------------------------------------------------ metrics / themes
local metrics = {
    Pad = 10, Gap = 6, SectionGap = 10,
    Radius = 3, SmallRadius = 2, CardRadius = 4, PillRadius = 5, PopupRadius = 5,
    FloatRadius = 6, WindowRadius = 6,
    WindowW = 586, WindowH = 466, MinWindowW = 520, MinWindowH = 380,
    SidebarW = 141, ContentX = 142, ColumnW = 207,
    TabW = 121, TabH = 28, TabPitch = 32, CategoryToTab = 25, TabToCategory = 25,
    FirstCategory = 56, SearchH = 28,
    Row = 16, HeaderH = 24, HeaderDescH = 40, DividerH = 9,
    SliderH = 33, DropdownH = 47, InputH = 26, ButtonH = 28, ListRowH = 24,
    ToggleW = 28, ToggleH = 16, ToggleKnob = 10,
    Knob = 11, PickerKnob = 8, TrackH = 9, TrackY = 24, TrackInset = 5,
    ChipH = 16, ValueChipH = 17, Swatch = 14, ChipGap = 2,
}

local themes = {
    Petal = {
        Background = fromRGB(42, 44, 52), Tab = fromRGB(48, 50, 58), Outline = fromRGB(65, 68, 80),
        Inline = fromRGB(56, 58, 68), Text = fromRGB(232, 234, 245), InactiveText = fromRGB(126, 130, 148),
        Accent = fromRGB(113, 159, 226), Element = fromRGB(54, 57, 68), Gradient = fromRGB(172, 187, 209),
        Shadow = fromRGB(0, 0, 0), HoveredElement = fromRGB(72, 77, 90),
    },
    Afterglow = {
        Background = fromRGB(34, 28, 25), Tab = fromRGB(30, 23, 20), Outline = fromRGB(60, 46, 38),
        Inline = fromRGB(42, 33, 29), Text = fromRGB(240, 232, 226), InactiveText = fromRGB(140, 122, 110),
        Accent = fromRGB(255, 145, 60), Element = fromRGB(49, 34, 27), Gradient = fromRGB(172, 167, 163),
        Shadow = fromRGB(0, 0, 0), HoveredElement = fromRGB(70, 51, 42),
    },
    Frostbite = {
        Background = fromRGB(22, 30, 38), Tab = fromRGB(16, 25, 32), Outline = fromRGB(42, 58, 72),
        Inline = fromRGB(27, 38, 47), Text = fromRGB(228, 240, 248), InactiveText = fromRGB(114, 136, 152),
        Accent = fromRGB(86, 219, 255), Element = fromRGB(28, 39, 52), Gradient = fromRGB(164, 172, 178),
        Shadow = fromRGB(0, 0, 0), HoveredElement = fromRGB(44, 60, 74),
    },
    Volt = {
        Background = fromRGB(24, 24, 20), Tab = fromRGB(18, 18, 14), Outline = fromRGB(54, 54, 40),
        Inline = fromRGB(32, 32, 26), Text = fromRGB(242, 242, 226), InactiveText = fromRGB(134, 134, 112),
        Accent = fromRGB(255, 250, 76), Element = fromRGB(32, 32, 26), Gradient = fromRGB(170, 170, 158),
        Shadow = fromRGB(0, 0, 0), HoveredElement = fromRGB(58, 58, 44),
    },
    Obsidian = {
        Background = fromRGB(16, 16, 18), Tab = fromRGB(12, 11, 14), Outline = fromRGB(44, 42, 52),
        Inline = fromRGB(24, 24, 29), Text = fromRGB(234, 232, 244), InactiveText = fromRGB(118, 114, 134),
        Accent = fromRGB(159, 109, 255), Element = fromRGB(24, 23, 31), Gradient = fromRGB(166, 164, 175),
        Shadow = fromRGB(0, 0, 0), HoveredElement = fromRGB(236, 240, 248),
    },
    ["Sakura Drift"] = {
        Background = fromRGB(38, 28, 34), Tab = fromRGB(32, 23, 29), Outline = fromRGB(70, 50, 62),
        Inline = fromRGB(48, 35, 43), Text = fromRGB(248, 234, 242), InactiveText = fromRGB(150, 122, 138),
        Accent = fromRGB(255, 155, 205), Element = fromRGB(44, 46, 48), Gradient = fromRGB(176, 166, 172),
        Shadow = fromRGB(0, 0, 0), HoveredElement = fromRGB(77, 53, 67),
    },
    ["Neon Mirage"] = {
        Background = fromRGB(22, 16, 34), Tab = fromRGB(17, 12, 28), Outline = fromRGB(54, 40, 82),
        Inline = fromRGB(32, 23, 48), Text = fromRGB(238, 232, 252), InactiveText = fromRGB(128, 114, 160),
        Accent = fromRGB(255, 86, 255), Element = fromRGB(30, 21, 46), Gradient = fromRGB(144, 163, 182),
        Shadow = fromRGB(0, 0, 0), HoveredElement = fromRGB(56, 39, 84),
    },
    ["Copper Dust"] = {
        Background = fromRGB(39, 30, 25), Tab = fromRGB(34, 25, 20), Outline = fromRGB(72, 54, 42),
        Inline = fromRGB(49, 36, 28), Text = fromRGB(244, 232, 220), InactiveText = fromRGB(148, 124, 104),
        Accent = fromRGB(243, 152, 86), Element = fromRGB(51, 34, 22), Gradient = fromRGB(173, 164, 155),
        Shadow = fromRGB(0, 0, 0), HoveredElement = fromRGB(77, 56, 42),
    },
    Abyss = {
        Background = fromRGB(12, 20, 28), Tab = fromRGB(8, 15, 22), Outline = fromRGB(30, 48, 62),
        Inline = fromRGB(18, 30, 40), Text = fromRGB(222, 236, 246), InactiveText = fromRGB(100, 128, 148),
        Accent = fromRGB(52, 176, 238), Element = fromRGB(16, 28, 38), Gradient = fromRGB(158, 169, 176),
        Shadow = fromRGB(0, 0, 0), HoveredElement = fromRGB(32, 51, 67),
    },
    Porcelain = {
        Background = fromRGB(250, 248, 244), Tab = fromRGB(236, 234, 230), Outline = fromRGB(214, 212, 208),
        Inline = fromRGB(255, 255, 255), Text = fromRGB(44, 46, 54), InactiveText = fromRGB(140, 142, 150),
        Accent = fromRGB(133, 176, 255), Element = fromRGB(255, 255, 255), Gradient = fromRGB(214, 218, 226),
        Shadow = fromRGB(120, 120, 120), HoveredElement = fromRGB(255, 255, 255),
    },
    Graphite = {
        Background = fromRGB(32, 30, 30), Tab = fromRGB(40, 40, 40), Outline = fromRGB(58, 60, 62),
        Inline = fromRGB(42, 45, 46), Text = fromRGB(236, 236, 250), InactiveText = fromRGB(128, 128, 134),
        Accent = fromRGB(105, 159, 237), Element = fromRGB(44, 46, 46), Gradient = fromRGB(190, 190, 190),
        Shadow = fromRGB(0, 0, 0), HoveredElement = fromRGB(67, 70, 72),
    },
}

local themeOrder = {
    "Petal", "Afterglow", "Frostbite", "Volt", "Obsidian", "Sakura Drift", "Neon Mirage",
    "Copper Dust", "Abyss", "Porcelain", "Graphite",
}

local themeColorList = {
    { "Background", "Background" }, { "Tab", "Tab" }, { "Outline", "Outline" },
    { "Inline", "Inline" }, { "Text", "Text" }, { "Inactive Text", "InactiveText" },
    { "Accent", "Accent" }, { "Element", "Element" }, { "Gradient", "Gradient" },
    { "Shadow", "Shadow" }, { "Hovered Element", "HoveredElement" },
}

local casingOptions = { "Normal", "Lower Case", "Upper Case", "Bold Case" }

local fonts = {
    Inter = "rbxassetid://12187365364",
    ["Builder Sans"] = "rbxasset://fonts/families/BuilderSans.json",
    Roboto = "rbxasset://fonts/families/Roboto.json",
    Montserrat = "rbxasset://fonts/families/Montserrat.json",
    ["Source Sans Pro"] = "rbxasset://fonts/families/SourceSansPro.json",
    Ubuntu = "rbxasset://fonts/families/Ubuntu.json",
    Nunito = "rbxasset://fonts/families/Nunito.json",
    Arimo = "rbxasset://fonts/families/Arimo.json",
}
local fontOptions = { "Inter", "Builder Sans", "Roboto", "Montserrat", "Source Sans Pro", "Ubuntu", "Nunito", "Arimo" }
local weightOptions = { "Regular", "Medium", "SemiBold", "Bold" }

local copy = table.clone(themes.Petal) -- live theme colours
local casing = "Normal"
local fontId = "rbxassetid://12187365364"
local defaultWeight = Enum.FontWeight.SemiBold

------------------------------------------------------------------ spring animation
local springs = {
    Fast = { W = 42, Z = 1 },
    Knob = { W = 44, Z = 0.86 },
    Follow = { W = 34, Z = 1 },
    Smooth = { W = 26, Z = 1 },
    Soft = { W = 19, Z = 1 },
    Settle = { W = 24, Z = 0.8 },
}

local anims = {}          -- active springs
local animByTarget = {}   -- [instance][prop] = anim
local frameCallbacks = {} -- per-frame functions

local tolerance = { number = 0.0015, Color3 = 0.003, UDim2 = 0.4, Vector2 = 0.4 }

local function toArray(v)
    local t = typeof(v)
    if t == "number" then return { v }
    elseif t == "Color3" then return { v.R, v.G, v.B }
    elseif t == "UDim2" then return { v.X.Scale, v.X.Offset, v.Y.Scale, v.Y.Offset }
    elseif t == "Vector2" then return { v.X, v.Y } end
    error("cannot animate " .. t)
end

local function fromArray(kind, x)
    if kind == "number" then return x[1]
    elseif kind == "Color3" then
        return Color3.new(math.clamp(x[1], 0, 1), math.clamp(x[2], 0, 1), math.clamp(x[3], 0, 1))
    elseif kind == "UDim2" then
        return new2(x[1], round(x[2]), x[3], round(x[4]))
    end
    return new(round(x[1]), round(x[2]))
end

local function killAnim(a)
    a.Dead = true
    local byProp = animByTarget[a.Target]
    if byProp and byProp[a.Prop] == a then
        byProp[a.Prop] = nil
        if next(byProp) == nil then animByTarget[a.Target] = nil end
    end
end

local function animate(target, prop, goal, preset, opts)
    local byProp = animByTarget[target]
    if not byProp then byProp = {}; animByTarget[target] = byProp end
    local a = byProp[prop]
    if not a then
        local x = toArray(target[prop])
        local vel = {}
        for k = 1, #x do vel[k] = 0 end
        a = { Target = target, Prop = prop, Kind = typeof(goal), X = x, V = vel }
        byProp[prop] = a
        table.insert(anims, a)
    end
    a.G = toArray(goal)
    a.Goal = goal
    a.P = springs[preset or "Smooth"]
    a.Done = opts and opts.Done or nil
    a.Step = opts and opts.Step or nil
end

local function setNow(target, prop, value)
    local byProp = animByTarget[target]
    local a = byProp and byProp[prop]
    if a then killAnim(a) end
    target[prop] = value
end

local function setOrAnimate(target, prop, value, animated, preset)
    if animated then animate(target, prop, value, preset) else setNow(target, prop, value) end
end

local function stepSprings(dt)
    local cache = {}
    local step = math.min(dt, 0.05)
    local i = 1
    while i <= #anims do
        local a = anims[i]
        if a.Dead then
            anims[i] = anims[#anims]
            anims[#anims] = nil
        else
            local m = cache[a.P]
            if not m then
                local w, z = a.P.W, a.P.Z
                if z >= 1 then
                    local e = math.exp(-w * step)
                    m = { e * (1 + w * step), e * step, -e * w * w * step, e * (1 - w * step) }
                else
                    local wd = w * math.sqrt(1 - z * z)
                    local e = math.exp(-z * w * step)
                    local c, s = math.cos(wd * step), math.sin(wd * step)
                    m = {
                        e * (c + z * w * s / wd), e * s / wd,
                        -e * w * w * s / wd, e * (c - z * w * s / wd),
                    }
                end
                cache[a.P] = m
            end
            local x, v, g = a.X, a.V, a.G
            local tol = tolerance[a.Kind]
            local velTol = tol * a.P.W
            local settled = true
            for k = 1, #x do
                local d = x[k] - g[k]
                local nv = m[3] * d + m[4] * v[k]
                local nd = m[1] * d + m[2] * v[k]
                x[k] = g[k] + nd
                v[k] = nv
                local t = (a.Kind == "UDim2" and k % 2 == 1) and 0.0005 or tol
                if math.abs(nd) > t or math.abs(nv) > velTol then settled = false end
            end
            if settled then
                a.Target[a.Prop] = a.Goal
                if a.Step then a.Step(a.Goal) end
                local done = a.Done
                killAnim(a)
                anims[i] = anims[#anims]
                anims[#anims] = nil
                if done then task.spawn(done) end
            else
                local last = fromArray(a.Kind, x)
                if last ~= a.Last then
                    a.Last = last
                    a.Target[a.Prop] = last
                    if a.Step then a.Step(last) end
                end
                i = i + 1
            end
        end
    end
end

local loopConnection
local hoverCheck -- assigned below

local function startLoop()
    if loopConnection then return end
    loopConnection = RunService.RenderStepped:Connect(function(dt)
        stepSprings(dt)
        for fn in frameCallbacks do fn(dt) end
        hoverCheck()
    end)
end

------------------------------------------------------------------ theme bindings
local bindings = {}      -- [inst][prop] = key|function
local bindByKey = {}     -- [key][inst] = prop
local dynamicBound = {}  -- instances bound to functions
local textRegistry = {}  -- [inst][prop] = raw text
local ignoreFade = {}    -- instances the fader must skip

local function resolve(key)
    if type(key) == "function" then return key() end
    return copy[key]
end

local function cleanup(inst)
    local b = bindings[inst]
    if b then
        for _, key in b do
            if type(key) == "string" then
                local set = bindByKey[key]
                if set then set[inst] = nil end
            end
        end
    end
    bindings[inst] = nil
    dynamicBound[inst] = nil
    textRegistry[inst] = nil
    animByTarget[inst] = nil
    ignoreFade[inst] = nil
end

local function bind(inst, prop, key)
    local b = bindings[inst]
    if not b then
        b = {}
        bindings[inst] = b
        inst.Destroying:Once(function() cleanup(inst) end)
    end
    b[prop] = key
    if type(key) == "string" then
        local set = bindByKey[key]
        if not set then set = {}; bindByKey[key] = set end
        set[inst] = prop
    else
        dynamicBound[inst] = true
    end
    inst[prop] = resolve(key)
end

-- mode: false = instant, string = spring preset, nil = "Fast"
local function repaint(inst, mode)
    local b = bindings[inst]
    if not b then return end
    for prop, key in b do
        local value = resolve(key)
        if mode == false or typeof(value) == "ColorSequence" then
            setNow(inst, prop, value)
        else
            animate(inst, prop, value, mode or "Fast")
        end
    end
end

local function applyCase(text)
    if casing == "Lower Case" then return string.lower(text) end
    if casing == "Upper Case" or casing == "Bold Case" then return string.upper(text) end
    return text
end

local function getFont(weight)
    local w = weight
    if casing == "Bold Case" then w = Enum.FontWeight.Bold end
    return Font.new(fontId, w or defaultWeight, Enum.FontStyle.Normal)
end

local function setText(inst, text, prop)
    prop = prop or "Text"
    local reg = textRegistry[inst]
    if not reg then reg = {}; textRegistry[inst] = reg end
    reg[prop] = text
    inst[prop] = applyCase(text)
end

local function refreshFonts()
    for inst, reg in textRegistry do
        for prop, raw in reg do
            if prop == "Text" or prop == "PlaceholderText" then
                inst[prop] = applyCase(raw)
            end
        end
        inst.FontFace = getFont(reg.Weight)
    end
end

------------------------------------------------------------------ instance helpers
local textClasses = { TextLabel = true, TextButton = true, TextBox = true }

local function create(class, props, parent)
    local inst = Instance.new(class)
    if inst:IsA("GuiObject") then
        inst.BorderSizePixel = 0
        inst.BackgroundTransparency = 1
    end
    if class == "TextButton" then
        inst.AutoButtonColor = false
        inst.Text = ""
    end
    if textClasses[class] then
        if class ~= "TextButton" then textRegistry[inst] = {} end
        inst.FontFace = getFont(nil)
        inst.TextSize = 13
        inst.TextXAlignment = Enum.TextXAlignment.Left
        inst.TextYAlignment = Enum.TextYAlignment.Top
    end

    local bg, fg, radius, border
    if props then
        for k, v in props do
            if k == "Bg" then bg = v
            elseif k == "Fg" then fg = v
            elseif k == "Radius" then radius = v
            elseif k == "Border" then border = v
            elseif k == "Weight" then
                textRegistry[inst].Weight = v
                inst.FontFace = getFont(v)
            elseif ((k == "Text" and class ~= "TextBox") or k == "PlaceholderText") and textClasses[class] then
                setText(inst, v, k)
            else
                inst[k] = v
            end
        end
    end

    if bg then
        if not (props and props.BackgroundTransparency) then inst.BackgroundTransparency = 0 end
        bind(inst, "BackgroundColor3", bg)
    end
    if fg then bind(inst, "TextColor3", fg) end
    if radius then
        local c = Instance.new("UICorner")
        c.CornerRadius = radius >= 99 and UDim.new(0.5, 0) or UDim.new(0, radius)
        c.Parent = inst
    end
    if border then
        local s = Instance.new("UIStroke")
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Thickness = 1
        bind(s, "Color", border)
        s.Parent = inst
    end
    if parent then inst.Parent = parent end
    return inst
end

local function textOffset(rowH, textSize)
    local v = round(textSize * 0.7)
    return math.ceil((rowH - v) / 2 - round(textSize * 0.16))
end

local function label(parent, o)
    local textSize = o.TextSize or 12
    local rowH = o.RowH or metrics.Row
    local x = o.X or 0
    return create("TextLabel", {
        Fg = o.Fg or "Text",
        Text = o.Text or "",
        TextSize = textSize,
        Weight = o.Weight,
        TextTruncate = o.Truncate,
        TextTransparency = o.TextTransparency,
        ZIndex = o.ZIndex,
        Position = fromOffset(x, (o.Y or 0) + textOffset(rowH, textSize)),
        Size = o.W and fromOffset(o.W, rowH) or new2(1, -x - (o.Right or 0), 0, rowH),
    }, parent)
end

local function centeredLabel(parent, width, o)
    o.Truncate = Enum.TextTruncate.AtEnd
    local l = label(parent, o)
    local y = l.Position.Y.Offset
    local rowH = o.RowH or metrics.Row
    local w = width
    local function fit()
        l.Size = fromOffset(w - 12, rowH)
        l.Position = fromOffset(floor2((w - math.min(math.ceil(l.TextBounds.X), w - 12)) / 2), y)
    end
    l:GetPropertyChangedSignal("TextBounds"):Connect(fit)
    fit()
    return l, function(newWidth) w = newWidth; fit() end
end

local function makeGradient(parent)
    local g = Instance.new("UIGradient")
    g.Rotation = 90
    bind(g, "Color", function() return ColorSequence.new(Color3.new(1, 1, 1), copy.Gradient) end)
    g.Parent = parent
    return g
end

local shadowPresets = {
    Large = { Blur = 10, Spread = 0, Transparency = 0.3 },
    PickerKnob = { Blur = 6, Spread = 6, Transparency = 0.5 },
}
local shadowSupported = pcall(function() Instance.new("UIShadow"):Destroy() end)

local function makeShadow(parent, preset)
    if not shadowSupported then return nil end
    local p = shadowPresets[preset]
    local s = Instance.new("UIShadow")
    s.BlurRadius = UDim.new(0, p.Blur)
    s.Spread = fromOffset(p.Spread, p.Spread)
    s.Transparency = p.Transparency
    bind(s, "Color", "Shadow")
    s.Parent = parent
    return s
end

local function fire(callback, ...)
    if callback then task.spawn(callback, ...) end
end

local function clamp01(v) return math.clamp(v, 0, 1) end

local function isPress(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end

local activeScreen
local activeWindow

local function mousePos()
    local m = UserInputService:GetMouseLocation()
    if activeScreen then return m + activeScreen.AbsolutePosition end
    return m
end

local function toLocal(absPos)
    return activeScreen and absPos - activeScreen.AbsolutePosition or absPos
end

local function inside(gui, pos, margin)
    local m = margin or 0
    local p, s = gui.AbsolutePosition, gui.AbsoluteSize
    return pos.X >= p.X - m and pos.X <= p.X + s.X + m
        and pos.Y >= p.Y - m and pos.Y <= p.Y + s.Y + m
end

-- onMove(pos) when mouse moves, onEnd(pos) on release, onFrame(pos, dt) each frame
local function dragLoop(onMove, onEnd, onFrame)
    local last
    local function tick(dt)
        local pos = mousePos()
        if not last or pos ~= last then
            last = pos
            if onMove then onMove(pos) end
        end
        if onFrame then onFrame(pos, dt) end
    end
    frameCallbacks[tick] = true
    local conn
    conn = UserInputService.InputEnded:Connect(function(input)
        if isPress(input) then
            conn:Disconnect()
            frameCallbacks[tick] = nil
            local pos = mousePos()
            if onMove and pos ~= last then onMove(pos) end
            if onEnd then onEnd(pos) end
        end
    end)
end

local hovered = {}

local function isVisible(inst)
    local p = inst
    while p and p:IsA("GuiObject") do
        if not p.Visible then return false end
        p = p.Parent
    end
    return true
end

local function blockedByFloating(inst, pos)
    local w = activeWindow
    if not w then return false end
    local dd = w.OpenDropdown
    if dd then
        if inst:IsDescendantOf(dd.Panel) then return false
        elseif inside(dd.Panel, pos) then return true end
    end
    local popup = w.ActivePopup
    if popup and inside(popup.Frame, pos) and not inst:IsDescendantOf(popup.Frame) then
        return true
    end
    local search = w.Search
    if search and search.Open and not inst:IsDescendantOf(search.Overlay) then
        return true
    end
    return false
end

local function hoverable(button, onEnter, onLeave)
    local active = false
    local function leave()
        if not active then return end
        active = false
        hovered[button] = nil
        onLeave()
    end
    button.MouseEnter:Connect(function()
        if active or blockedByFloating(button, mousePos()) then return end
        active = true
        hovered[button] = leave
        onEnter()
    end)
    button.MouseLeave:Connect(leave)
    button.Destroying:Once(function() hovered[button] = nil end)
end

function hoverCheck()
    if next(hovered) == nil then return end
    local pos = mousePos()
    for button, leave in hovered do
        if not inside(button, pos) or not isVisible(button) or blockedByFloating(button, pos) then
            leave()
        end
    end
end

------------------------------------------------------------------ fader
local Fader = {}
Fader.__index = Fader

local function newFader(root)
    return setmetatable({ Root = root, Alpha = 1, Entries = nil }, Fader)
end

local function collectFadeEntries(root)
    local list = {}
    local function add(inst, prop)
        if ignoreFade[inst] or (animByTarget[inst] and animByTarget[inst][prop]) then return end
        local v = inst[prop]
        if v < 1 then table.insert(list, { inst, prop, v }) end
    end
    local function walk(inst)
        if inst:IsA("GuiObject") then
            if inst ~= root and not inst.Visible then return end
            add(inst, "BackgroundTransparency")
            if textClasses[inst.ClassName] then add(inst, "TextTransparency") end
            if inst:IsA("ImageLabel") then add(inst, "ImageTransparency") end
        elseif inst:IsA("UIStroke") or inst.ClassName == "UIShadow" then
            add(inst, "Transparency")
        end
        for _, c in inst:GetChildren() do walk(c) end
    end
    walk(root)
    return list
end

function Fader:_apply(a)
    if not self.Entries then return end
    for _, e in self.Entries do
        e[1][e[2]] = 1 - (1 - e[3]) * a
    end
end

function Fader:Show(onDone, preset)
    if not self.Entries then
        self.Entries = collectFadeEntries(self.Root)
        self.Alpha = 0
        self:_apply(0)
    end
    self.Root.Visible = true
    animate(self, "Alpha", 1, preset or "Smooth", {
        Step = function(a) self:_apply(a) end,
        Done = function()
            self.Entries = nil
            if onDone then onDone() end
        end,
    })
end

function Fader:Hide(onDone, preset)
    if not self.Entries then
        self.Entries = collectFadeEntries(self.Root)
        self.Alpha = 1
    end
    animate(self, "Alpha", 0, preset or "Fast", {
        Step = function(a) self:_apply(a) end,
        Done = function()
            self.Root.Visible = false
            self:_apply(1)
            self.Entries = nil
            if onDone then onDone() end
        end,
    })
end

------------------------------------------------------------------ icons
local function buildLogo()
    local list = { { "f", 0.6, 0.6, 14.8, 14.8, 99 } }
    for n = 0, 2 do
        for i = 0, 3 do
            local deg = n * 120 + i * 42
            local rad = math.rad(deg)
            local r = 6.3 - i * 1.45
            table.insert(list, {
                "h", 8 + math.cos(rad) * r - 2, 8 + math.sin(rad) * r - 0.6, 4, 1.2, 99, deg + 118,
            })
        end
    end
    table.insert(list, { "h", 7, 7, 2, 2, 99 })
    return list
end

-- { kind(f=fill,h=hole,r=ring), x, y, w, h, radius, rotation, strokeThickness }
local icons = {
    target = { { "f", 0.5, 0.5, 15, 15, 99 }, { "h", 3, 3, 10, 10, 99 }, { "f", 4.8, 4.8, 6.4, 6.4, 99 } },
    bullet = { { "f", 1, 4, 3, 8, 1 }, { "f", 5, 4, 6, 8, 1 }, { "f", 8.2, 5.2, 5.6, 5.6, 1, 45 } },
    smile = {
        { "f", 1, 1, 14, 14, 99 }, { "h", 4.4, 5, 2.6, 2.6, 99 }, { "h", 9, 5, 2.6, 2.6, 99 },
        { "h", 4.6, 9.8, 6.8, 2, 99 },
    },
    globe = {
        { "f", 1, 1, 14, 14, 99 }, { "h", 3, 3.2, 4.4, 3, 99, -20 }, { "h", 8.2, 8, 4.6, 3.8, 99, 20 },
        { "h", 9.8, 2.8, 2.6, 2, 99 }, { "h", 3.4, 9.6, 2.6, 2.6, 99 },
    },
    bomb = { { "f", 1, 4, 11, 11, 99 }, { "f", 9.2, 2.8, 4, 3, 0.5, 45 }, { "f", 12.8, 0.8, 2.4, 2.4, 99 } },
    file = {
        { "f", 3, 1, 10, 14, 1.5 }, { "h", 10.6, -0.8, 4.2, 4.2, 0, 45 },
        { "h", 5.5, 7.5, 5, 1.1, 0 }, { "h", 5.5, 10.3, 5, 1.1, 0 },
    },
    gear = {
        { "f", 6.5, 0.8, 3, 14.4, 0.6, 0 }, { "f", 6.5, 0.8, 3, 14.4, 0.6, 45 },
        { "f", 6.5, 0.8, 3, 14.4, 0.6, 90 }, { "f", 6.5, 0.8, 3, 14.4, 0.6, 135 },
        { "f", 2.6, 2.6, 10.8, 10.8, 99 }, { "h", 5.6, 5.6, 4.8, 4.8, 99 },
    },
    robot = {
        { "f", 7.2, 2, 1.6, 3.5, 0 }, { "f", 6.4, 0.5, 3.2, 3.2, 99 }, { "f", 2.2, 5, 11.6, 9.4, 2 },
        { "f", 0.2, 8, 1.4, 4, 0.5 }, { "f", 14.4, 8, 1.4, 4, 0.5 }, { "h", 4.6, 7.6, 2.5, 2.5, 99 },
        { "h", 8.9, 7.6, 2.5, 2.5, 99 }, { "h", 5.4, 11.4, 5.2, 1.1, 0 },
    },
    wrench = { { "f", 5.6, 4.2, 3.8, 12.6, 1.4, 45 }, { "f", 8.8, 0.8, 6.6, 6.6, 99 }, { "h", 11.4, -1.2, 3.2, 5.8, 0, 45 } },
    cube = {
        { "f", 4, 1.1, 8, 13.8, 0, 0 }, { "f", 4, 1.1, 8, 13.8, 0, 60 }, { "f", 4, 1.1, 8, 13.8, 0, 120 },
        { "h", 7.5, 8, 1, 6.6, 0, 0 }, { "h", 4.6, 2.6, 1, 6.8, 0, 120 }, { "h", 10.4, 2.6, 1, 6.8, 0, 60 },
    },
    search = { { "r", 2, 2, 9, 9, 99, 0, 1.7 }, { "f", 9.6, 11.2, 5.6, 2, 99, 45 } },
    user = { { "f", 5, 1, 6, 6, 99 }, { "f", 2.5, 8.5, 11, 6.5, 3 } },
    key = {
        { "f", 1, 8.5, 7, 7, 99 }, { "f", 6.2, 5, 9, 2.2, 0.6, -45 },
        { "f", 11.2, 4.6, 3.4, 2, 0.4, 45 }, { "h", 3.1, 10.6, 2.8, 2.8, 99 },
    },
    grip = { { "f", 5.5, 11.3, 11, 1.5, 99, -45 }, { "f", 10.2, 12.7, 5.6, 1.5, 99, -45 } },
    check = { { "f", 2, 8.4, 6.2, 2, 99, 45 }, { "f", 5.2, 6.8, 10, 2, 99, -45 } },
    layout = { { "f", 0.5, 1, 15, 4.5, 1 }, { "f", 0.5, 6.5, 7, 8.5, 1 }, { "f", 8.5, 6.5, 7, 8.5, 1 } },
    reset = {
        { "r", 2.6, 2.6, 10.8, 10.8, 99, 0, 1.8 }, { "h", 9.5, 0.5, 6, 5.5, 0 },
        { "f", 9.2, 1.2, 4.6, 4.6, 0.5, 45 },
    },
    logo = buildLogo(),
}

-- fg / hole are theme keys or functions
local function makeIcon(parent, icon, size, fg, hole, o)
    o = o or {}
    local root = create("Frame", {
        Name = "Icon", Size = fromOffset(size, size),
        Position = o.Position, AnchorPoint = o.AnchorPoint, ZIndex = o.ZIndex,
    }, parent)
    local obj = { Root = root, Parts = {} }

    if type(icon) == "string" and string.find(icon, "rbxasset", 1, true) then
        local img = create("ImageLabel", { Size = new2(1, 0, 1, 0), Image = icon }, root)
        bind(img, "ImageColor3", fg)
        table.insert(obj.Parts, img)
    else
        local scale = size / 16
        for _, part in icons[icon] or icons.cube do
            local kind, x, y, w, h, rad, rot, thick = table.unpack(part, 1, 8)
            local f = create("Frame", {
                Position = UDim2.fromScale(x / 16, y / 16),
                Size = UDim2.fromScale(w / 16, h / 16),
                Rotation = rot or 0,
                Radius = rad and rad > 0 and (rad >= 99 and 99 or math.max(1, round(rad * scale))) or nil,
            }, root)
            if kind == "r" then
                local s = create("UIStroke", { Thickness = (thick or 1.5) * scale }, f)
                bind(s, "Color", fg)
                table.insert(obj.Parts, s)
            else
                f.BackgroundTransparency = 0
                bind(f, "BackgroundColor3", kind == "h" and hole or fg)
                table.insert(obj.Parts, f)
            end
        end
    end

    function obj.Update(mode)
        for _, p in obj.Parts do repaint(p, mode) end
    end
    return obj
end

-- hover/press colour controller for a button-like frame
local function hoverColors(frame, baseKey, hoverKey, pressKey, hitbox)
    local st = { Hover = false, Press = false }
    local target = hitbox or frame
    bind(frame, "BackgroundColor3", function()
        if st.Press and pressKey then return copy[pressKey] end
        if st.Hover then return copy[hoverKey or "HoveredElement"] end
        return copy[baseKey]
    end)
    hoverable(target, function() st.Hover = true; repaint(frame) end, function()
        st.Hover = false
        st.Press = false
        repaint(frame)
    end)
    if target:IsA("GuiButton") then
        target.MouseButton1Down:Connect(function() st.Press = true; repaint(frame) end)
        target.MouseButton1Up:Connect(function() st.Press = false; repaint(frame) end)
    end
    return st
end

------------------------------------------------------------------ classes
local Window, Tab, Section, Column = {}, {}, {}, {}
Window.__index = Window
Tab.__index = Tab
Section.__index = Section
Column.__index = Column

local function formatNumber(v, decimals)
    if decimals and decimals > 0 then return string.format("%." .. decimals .. "f", v) end
    return tostring(floor2(v + 0.5))
end

local keyShort = {
    LeftShift = "LS", RightShift = "RS", LeftControl = "LC", RightControl = "RC",
    LeftAlt = "LA", RightAlt = "RA", MouseButton1 = "M1", MouseButton2 = "M2", MouseButton3 = "M3",
    Return = "Ent", Backspace = "Bk",
    One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", Zero = "0",
}
local function keyName(key)
    if key == nil then return "-" end
    return keyShort[key.Name] or key.Name
end

-- small value/keybind chip
local function makeChip(frame, text, rightAnchored, chipH)
    local h = (chipH or metrics.ChipH) - 2
    local chip = create("Frame", {
        Bg = "Element", Radius = metrics.Radius, Border = "Outline",
        Size = fromOffset(16, h), AnchorPoint = rightAnchored and new(1, 0) or nil,
    }, frame)
    makeGradient(chip)
    local lbl = label(chip, { Fg = "InactiveText", Text = text, TextSize = 11, X = 4, RowH = h })
    return chip, lbl
end

-- keeps chip width fitted to its label; returns (setWidthFor(textWidth), refresh)
local function autoSizeChip(chip, lbl, minW, onWidth)
    local height = chip.Size.Y.Offset
    local function fit(textW)
        local w = math.max((minW or 2) - 2, textW + 8)
        chip.Size = fromOffset(w, height)
        lbl.Position = fromOffset(floor2((w - textW) / 2), lbl.Position.Y.Offset)
        if onWidth then onWidth(w + 2) end
        return w
    end
    local function refresh() fit(math.ceil(lbl.TextBounds.X)) end
    lbl:GetPropertyChangedSignal("TextBounds"):Connect(refresh)
    refresh()
    return fit, refresh
end

-- click-to-edit numeric chip
local function makeEditableChip(chip, lbl, getText, commit, resize, refresh)
    local h = chip.Size.Y.Offset
    local hit = create("TextButton", { Size = new2(1, 0, 1, 0), ZIndex = 2 }, chip)
    hoverColors(chip, "Element", nil, nil, hit)
    local editing = false
    local stroke = chip:FindFirstChildOfClass("UIStroke")
    bind(stroke, "Color", function() return editing and copy.Accent or copy.Outline end)

    local box = create("TextBox", {
        Fg = "Text", TextSize = 11, Visible = false, ZIndex = 3, ClearTextOnFocus = false,
        Position = fromOffset(4, textOffset(h, 11)), Size = new2(1, -8, 0, h),
    }, chip)

    box:GetPropertyChangedSignal("Text"):Connect(function()
        if editing then resize(math.ceil(box.TextBounds.X)) end
    end)

    hit.MouseButton1Click:Connect(function()
        editing = true
        repaint(stroke)
        box.Text = getText()
        lbl.Visible = false
        box.Visible = true
        box:CaptureFocus()
        box.CursorPosition = #box.Text + 1
        box.SelectionStart = 1
    end)

    box.FocusLost:Connect(function()
        if not editing then return end
        editing = false
        repaint(stroke)
        local n = tonumber(string.match(box.Text, "%-?%d*%.?%d+") or "")
        box.Visible = false
        lbl.Visible = true
        if n then commit(n) end
        refresh()
    end)
end

------------------------------------------------------------------ Column
function Column:Layout(animated)
    local total = 0
    for _, s in self.Sections do
        s.Y = total
        if not s.Dragging and not s.Dropping then
            setOrAnimate(s.Root, "Position", fromOffset(0, total), animated, "Settle")
        end
        total = total + (s.TotalH + metrics.SectionGap)
    end
    self.ContentH = math.max(0, total - metrics.SectionGap)
    self.Scroll.CanvasSize = fromOffset(0, self.ContentH)
    self:ClampScroll()
end

function Column:ClampScroll()
    self.Target = math.clamp(self.Target, 0, math.max(0, self.ContentH - (self.Tab.Window.Height - metrics.Pad * 2)))
end

function Column:ScrollTo(target)
    self.Target = target
    self:ClampScroll()
    animate(self.Scroll, "CanvasPosition", new(0, self.Target), "Soft")
end

------------------------------------------------------------------ Section
function Section:Layout(animated)
    local y = metrics.Pad
    local any = false
    for _, item in self.Items do
        if item.Visible then
            any = true
            item.Y = y
            setOrAnimate(item.Frame, "Position", fromOffset(0, y), animated)
            y = y + (item.Height + metrics.Gap)
        end
    end
    if any then y = y - metrics.Gap end
    self.CardH = y + metrics.Pad
    self.TotalH = self.HeaderH + self.CardH
    setOrAnimate(self.Card, "Size", new2(1, -2, 0, self.CardH - 2), animated)
    if not self.Dragging then
        setOrAnimate(self.Root, "Size", new2(1, 0, 0, self.TotalH), animated)
    end
    if self.Column then self.Column:Layout(animated) end
end

function Section:_item(height, kind, name, indexed)
    local item = {
        Frame = create("Frame", { Size = new2(1, 0, 0, height) }, self.Body),
        Height = height, Kind = kind, Name = name, Section = self, Slots = {}, Visible = true, Y = 0,
    }
    table.insert(self.Items, item)
    if name and indexed ~= false then table.insert(self.Window.Index, item) end
    self:Layout(false)
    return item
end

-- right-aligned slots (switch, chips, swatches) on a row
local function layoutSlots(item)
    local x = 0
    for _, slot in item.Slots do
        local off = x + slot.Gap
        slot.Frame.Position = new2(1, -off - 1, 0, floor2((metrics.Row - slot.Height) / 2) + 1)
        x = off + slot.Width
    end
    if item.Label then item.Label.Size = new2(1, -(x + metrics.Gap), 0, metrics.Row) end
end

local function addSlot(item, frame, width, height, gap)
    local slot = { Frame = frame, Width = width, Height = height, Gap = #item.Slots == 0 and 0 or gap }
    frame.AnchorPoint = new(1, 0)
    table.insert(item.Slots, slot)
    layoutSlots(item)
    return slot
end

local function makeKeybind(section, item, o)
    local window = section.Window
    local kb = {
        Key = o.Key, Mode = o.Mode or "Toggle", Listening = false,
        OnPress = o.OnPress, OnRelease = o.OnRelease, Name = o.Name,
    }
    local chip, lbl = makeChip(item.Frame, keyName(kb.Key))
    local hit = create("TextButton", { Size = new2(1, 0, 1, 0), ZIndex = 2 }, chip)
    local slot = addSlot(item, chip, 18, metrics.ChipH, metrics.Gap + 2)
    autoSizeChip(chip, lbl, 18, function(w) slot.Width = w; layoutSlots(item) end)
    hoverColors(chip, "Element", nil, nil, hit)
    bind(lbl, "TextColor3", function() return kb.Listening and copy.Accent or copy.InactiveText end)

    function kb.Refresh()
        setText(lbl, kb.Listening and "..." or keyName(kb.Key))
        repaint(lbl)
        if kb.OnKeyChanged then kb.OnKeyChanged() end
    end
    function kb:Set(key)
        kb.Key = key
        kb.Refresh()
    end

    hit.MouseButton1Click:Connect(function()
        kb.Listening = true
        window.Listening = kb
        kb.Refresh()
    end)
    hit.MouseButton2Click:Connect(function() window:OpenKeybindMenu(chip, kb) end)

    kb.Chip = chip
    kb.Label = lbl
    table.insert(window.Binds, kb)
    return kb
end

local function makeColorSwatch(section, item, o)
    local window = section.Window
    local c = {
        Value = o.Default or Color3.new(1, 1, 1), Alpha = o.Alpha or 0, Animation = "None",
        Callback = o.Callback, Flag = o.Flag,
    }
    local swatch = create("TextButton", {
        Size = fromOffset(metrics.Swatch - 2, metrics.Swatch - 2), Radius = metrics.Radius,
        BackgroundTransparency = 0, BackgroundColor3 = c.Value, Border = "Outline",
    }, item.Frame)
    addSlot(item, swatch, metrics.Swatch, metrics.Swatch, metrics.Gap + 2)
    c.Swatch = swatch

    function c:Set(color, alpha, silent)
        c.Value = color
        if alpha ~= nil then c.Alpha = alpha end
        swatch.BackgroundColor3 = color
        if window.Picker.Target == c and not window.Picker.Dragging then window.Picker.Sync() end
        if not silent then fire(c.Callback, color, c.Alpha) end
    end

    swatch.MouseButton1Click:Connect(function() window:OpenPicker(swatch, c) end)
    table.insert(window.Colors, c)
    return c
end

local function attachExtras(section, item, o, defaultName)
    local color
    if o.Color then
        color = makeColorSwatch(section, item, { Default = o.Color, Alpha = o.ColorAlpha, Callback = o.ColorCallback })
    end
    local kb
    if o.Keybind ~= nil then
        kb = makeKeybind(section, item, { Key = o.Keybind, Mode = o.KeybindMode, Name = o.KeybindName or defaultName })
    end
    return kb, color
end

local function registerFlag(section, obj, o, item)
    local window = section.Window
    window.FlagOwners[item] = obj
    if o.NoSave then return nil end
    local base = o.Flag or (section.Tab.Name .. "/" .. section.Name .. "/" .. tostring(o.Name or item.Kind))
    local n = 1
    local flag = base
    while window.Flags[flag] do
        n = n + 1
        flag = base .. "#" .. n
    end
    window.Flags[flag] = obj
    obj.Flag = flag
    return flag
end

function Section:Toggle(o)
    local window = self.Window
    local name = o.Name
    local item = self:_item(metrics.Row, "Toggle", name)
    local t = { Value = o.Default == true, Item = item, Callback = o.Callback }

    local hit = create("TextButton", { Position = fromOffset(0, -3), Size = new2(1, 0, 1, 6) }, item.Frame)
    local hover = false
    local lbl = label(item.Frame, {
        Text = name, Truncate = Enum.TextTruncate.AtEnd,
        Fg = function()
            if t.Value then return copy.Text end
            return hover and copy.InactiveText:Lerp(copy.Text, 0.45) or copy.InactiveText
        end,
    })
    item.Label = lbl

    local track = create("Frame", {
        Bg = function() return t.Value and copy.Accent or copy.Element end,
        Size = fromOffset(metrics.ToggleW - 2, metrics.ToggleH - 2), Radius = 99, Border = "Outline",
    }, item.Frame)
    makeGradient(track)
    local knob = create("Frame", {
        Bg = function() return t.Value and copy.Text or copy.InactiveText end,
        Size = fromOffset(metrics.ToggleKnob, metrics.ToggleKnob), Radius = 99,
    }, track)
    addSlot(item, track, metrics.ToggleW, metrics.ToggleH, 0)

    local function paint(animated)
        setOrAnimate(knob, "Position",
            fromOffset(t.Value and metrics.ToggleW - 2 - metrics.ToggleKnob - 2 or 2, 2), animated, "Knob")
        local mode = animated and "Fast" or false
        repaint(track, mode); repaint(knob, mode); repaint(lbl, mode)
    end

    local function syncHotkey()
        if t.Keybind then window:SetHotkeyActive(t.Keybind, t.Value) end
    end

    function t:Set(v, silent)
        local b = v == true
        if b == t.Value then return end
        t.Value = b
        paint(true)
        syncHotkey()
        if not silent then fire(t.Callback, b) end
    end

    hoverable(hit, function() hover = true; repaint(lbl) end, function() hover = false; repaint(lbl) end)
    hit.MouseButton1Click:Connect(function() t:Set(not t.Value) end)

    local kbName = o.KeybindName or (name == "Enabled" and self.Name or name)
    o.KeybindName = kbName
    local kb, color = attachExtras(self, item, o, kbName)
    t.Keybind = kb
    t.Color = color

    if kb then
        function kb.OnPress()
            if kb.Mode == "Hold" then t:Set(true) else t:Set(not t.Value) end
        end
        function kb.OnRelease()
            if kb.Mode == "Hold" then t:Set(false) end
        end
        kb.OnKeyChanged = syncHotkey
    end

    paint(false)
    syncHotkey()
    local flag = registerFlag(self, t, o, item)
    if flag and t.Keybind then window.Flags[flag .. "/Key"] = t.Keybind end
    if flag and t.Color then window.Flags[flag .. "/Color"] = t.Color end
    return t
end

function Section:Label(o)
    local name = o.Name or o.Text
    local item = self:_item(metrics.Row, "Label", name, false)
    local l = label(item.Frame, { Text = name, Truncate = Enum.TextTruncate.AtEnd })
    item.Label = l
    local obj = { Item = item, Instance = l }
    function obj:Set(text) setText(l, text) end
    local kb, color = attachExtras(self, item, o, name)
    obj.Keybind = kb
    obj.Color = color
    return obj
end

function Section:Divider()
    local item = self:_item(metrics.DividerH, "Divider", nil, false)
    create("Frame", {
        Bg = "Element", Position = fromOffset(1, 1), Size = new2(1, -2, 1, -2), Radius = 99, Border = "Outline",
    }, item.Frame)
    return item
end

function Section:Keybind(o)
    local item = self:_item(metrics.Row, "Keybind", o.Name)
    item.Label = label(item.Frame, { Text = o.Name, Truncate = Enum.TextTruncate.AtEnd })
    local kb = makeKeybind(self, item, { Key = o.Default, Mode = o.Mode, Name = o.Name, OnPress = o.Callback })
    kb.Item = item
    registerFlag(self, kb, o, item)
    return kb
end

function Section:Colorpicker(o)
    local item = self:_item(metrics.Row, "Colorpicker", o.Name, o.Indexed)
    item.Label = label(item.Frame, { Text = o.Name, Truncate = Enum.TextTruncate.AtEnd })
    local c = makeColorSwatch(self, item, o)
    c.Item = item
    registerFlag(self, c, o, item)
    return c
end

------------------------------------------------------------------ sliders
local function sliderWidth(window)
    return window.ColumnW - metrics.Pad * 2 - 2
end

local function makeTrack(frame)
    local track = create("Frame", {
        Bg = "Element", Position = fromOffset(1, metrics.TrackY + 1),
        Size = new2(1, -2, 0, metrics.TrackH - 2), Radius = 99, Border = "Outline",
    }, frame)
    makeGradient(track)
    local fill = create("Frame", { Name = "Fill", Bg = "Accent", Radius = 99, Size = new2(0, 0, 1, 0) }, track)
    makeGradient(fill)
    local hit = create("TextButton", {
        Position = fromOffset(-4, metrics.Row), Size = new2(1, 8, 0, metrics.Row + 1), ZIndex = 4,
    }, frame)
    return track, fill, hit
end

local function makeKnob(parent)
    return create("Frame", {
        Name = "Knob", Bg = "Text", Size = fromOffset(metrics.Knob, metrics.Knob), Radius = 99, ZIndex = 3,
    }, parent)
end

local function knobX(ratio, width)
    return round(metrics.TrackInset + ratio * (width - metrics.TrackInset * 2))
end

local function placeKnob(knob, x, animated)
    setOrAnimate(knob, "Position",
        fromOffset(x - floor2(metrics.Knob / 2), floor2((metrics.TrackH - 2 - metrics.Knob) / 2)), animated, "Follow")
end

local function trackRatio(track, pos)
    local inset = metrics.TrackInset
    return clamp01((pos.X - track.AbsolutePosition.X - inset) / (track.AbsoluteSize.X - inset * 2))
end

function Section:Slider(o)
    local item = self:_item(metrics.SliderH, "Slider", o.Name)
    local nameLabel = label(item.Frame, { Text = o.Name, Truncate = Enum.TextTruncate.AtEnd })
    local min, max = o.Min or 0, o.Max or 100
    local decimals = o.Decimals or 0
    local suffix = o.Suffix or ""
    local s = { Value = min, Item = item, Callback = o.Callback }

    local chip, chipLabel = makeChip(item.Frame, "", true, metrics.ValueChipH)
    chip.Position = new2(1, -1, 0, 0)
    local fit, refresh = autoSizeChip(chip, chipLabel, 24, function(w)
        nameLabel.Size = new2(1, -(w + metrics.Gap), 0, metrics.Row)
    end)

    local track, fill, hit = makeTrack(item.Frame)
    local knob = makeKnob(track)

    local function render(animated)
        local ratio = max == min and 0 or (s.Value - min) / (max - min)
        local x = knobX(ratio, sliderWidth(self.Window))
        placeKnob(knob, x, animated)
        setOrAnimate(fill, "Size", new2(0, x, 1, 0), animated, "Follow")
    end

    function s:Set(v, silent, animated)
        local step = 10 ^ (-decimals)
        local c = math.clamp(floor2(v / step + 0.5) * step, min, max)
        local changed = c ~= s.Value
        s.Value = c
        setText(chipLabel, formatNumber(c, decimals) .. suffix)
        render(animated ~= false)
        if changed and not silent then fire(s.Callback, c) end
    end

    makeEditableChip(chip, chipLabel, function() return formatNumber(s.Value, decimals) end,
        function(n) s:Set(n) end, fit, refresh)

    local function fromInput(pos)
        s:Set(min + (max - min) * trackRatio(track, pos))
    end
    hit.InputBegan:Connect(function(input)
        if not isPress(input) then return end
        fromInput(mousePos())
        dragLoop(fromInput)
    end)

    table.insert(self.Window.ResizeJobs, function() render(false) end)
    s:Set(o.Default or min, true, false)
    registerFlag(self, s, o, item)
    return s
end

function Section:RangeSlider(o)
    local item = self:_item(metrics.SliderH, "Range Slider", o.Name)
    local nameLabel = label(item.Frame, { Text = o.Name, Truncate = Enum.TextTruncate.AtEnd })
    local min, max = o.Min or 0, o.Max or 100
    local decimals = o.Decimals or 0
    local suffix = o.Suffix or ""
    local def = o.Default or { min, max }
    local r = { Value = { def[1], def[2] }, Item = item, Callback = o.Callback }

    local hiChip, hiLabel = makeChip(item.Frame, "", true, metrics.ValueChipH)
    local loChip, loLabel = makeChip(item.Frame, "", true, metrics.ValueChipH)
    hiChip.Position = new2(1, -1, 0, 0)
    local hiW, loW = 24, 24

    local function layoutChips()
        loChip.Position = new2(1, -(hiW + metrics.ChipGap + 1), 0, 0)
        nameLabel.Size = new2(1, -(hiW + loW + metrics.ChipGap + metrics.Gap), 0, metrics.Row)
    end
    local fitHi, refreshHi = autoSizeChip(hiChip, hiLabel, 24, function(w) hiW = w; layoutChips() end)
    local fitLo, refreshLo = autoSizeChip(loChip, loLabel, 24, function(w) loW = w; layoutChips() end)

    local track, fill, hit = makeTrack(item.Frame)
    local knobLo, knobHi = makeKnob(track), makeKnob(track)

    local function ratio(v) return (v - min) / (max - min) end

    local function render(animated)
        local w = sliderWidth(self.Window)
        local x1 = knobX(ratio(r.Value[1]), w)
        local x2 = knobX(ratio(r.Value[2]), w)
        placeKnob(knobLo, x1, animated)
        placeKnob(knobHi, x2, animated)
        setOrAnimate(fill, "Position", new2(0, x1, 0, 0), animated, "Follow")
        setOrAnimate(fill, "Size", new2(0, x2 - x1, 1, 0), animated, "Follow")
    end

    function r:Set(v, silent, animated)
        r.Value = { math.min(v[1], v[2]), math.max(v[1], v[2]) }
        setText(loLabel, formatNumber(r.Value[1], decimals) .. suffix)
        setText(hiLabel, formatNumber(r.Value[2], decimals) .. suffix)
        render(animated ~= false)
        if not silent then fire(r.Callback, r.Value) end
    end

    local function snap(v)
        local step = 10 ^ (-decimals)
        return math.clamp(floor2(v / step + 0.5) * step, min, max)
    end

    makeEditableChip(loChip, loLabel, function() return formatNumber(r.Value[1], decimals) end,
        function(n) r:Set({ math.min(snap(n), r.Value[2]), r.Value[2] }) end, fitLo, refreshLo)
    makeEditableChip(hiChip, hiLabel, function() return formatNumber(r.Value[2], decimals) end,
        function(n) r:Set({ r.Value[1], math.max(snap(n), r.Value[1]) }) end, fitHi, refreshHi)

    local which = 1
    local function valueAt(pos) return snap(min + (max - min) * trackRatio(track, pos)) end
    local function drag(pos)
        local v = valueAt(pos)
        local nv = { r.Value[1], r.Value[2] }
        if which == 1 then nv[1] = math.min(v, nv[2]) else nv[2] = math.max(v, nv[1]) end
        r:Set(nv)
    end

    hit.InputBegan:Connect(function(input)
        if not isPress(input) then return end
        local pos = mousePos()
        local v = valueAt(pos)
        which = math.abs(v - r.Value[1]) <= math.abs(v - r.Value[2]) and 1 or 2
        drag(pos)
        dragLoop(drag)
    end)

    table.insert(self.Window.ResizeJobs, function() render(false) end)
    r:Set(r.Value, true, false)
    registerFlag(self, r, o, item)
    return r
end

------------------------------------------------------------------ dropdown
local function makeDropdown(window, frame, o)
    local d = {
        Options = o.Options or {}, Multi = o.Multi == true, Open = false,
        Value = o.Multi and {} or o.Default, Callback = o.Callback, Reveal = 0,
    }
    if o.Multi and o.Default then
        for _, v in o.Default do d.Value[v] = true end
    end

    local field = create("TextButton", {
        Position = fromOffset(1, (o.Y or 0) + 1), Size = new2(1, -2, 0, metrics.InputH - 2),
        Radius = metrics.Radius, BackgroundTransparency = 0,
    }, frame)
    hoverColors(field, "Element")
    makeGradient(field)
    local fieldStroke = create("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Thickness = 1 }, field)
    bind(fieldStroke, "Color", function() return d.Open and copy.Accent or copy.Outline end)

    local valueLabel = label(field, {
        Fg = "InactiveText", TextSize = 13, X = 7, RowH = metrics.InputH - 2, Right = 28,
        Truncate = Enum.TextTruncate.AtEnd,
    })
    makeIcon(field, "layout", 14, "InactiveText", "Element", {
        AnchorPoint = new(1, 0), Position = new2(1, -5, 0, 5),
    })

    local panel = create("TextButton", {
        Bg = "Background", BackgroundTransparency = 1, Radius = metrics.Radius,
        Visible = false, Size = fromOffset(10, 0),
    }, window.Dropdowns)
    local panelStroke = create("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Thickness = 1, Transparency = 1,
    }, panel)
    bind(panelStroke, "Color", "Outline")
    local scroll = create("ScrollingFrame", {
        Size = new2(1, 0, 1, 0), ScrollBarThickness = 0, CanvasSize = fromOffset(0, 0),
    }, panel)

    local rows = {}
    local panelH = 0
    local openUp = false

    local emptyLabel = label(panel, {
        Fg = "InactiveText", Text = o.Empty or "No options", TextSize = 13, X = 9,
        RowH = metrics.ListRowH, Right = 8, TextTransparency = 1,
    })

    local function summary()
        if not d.Multi then return d.Value and tostring(d.Value) or "None" end
        local parts = {}
        for _, opt in d.Options do
            if d.Value[opt] then table.insert(parts, tostring(opt)) end
        end
        return #parts > 0 and table.concat(parts, ", ") or "None"
    end

    local function isSelected(opt)
        if d.Multi then return d.Value[opt] == true end
        return d.Value == opt
    end

    local function refreshRow(row)
        local rv = d.Reveal
        row.Button.BackgroundTransparency = 1 - math.max(row.Sel, row.Hov) * rv
        row.Bar.BackgroundTransparency = 1 - row.Sel * rv
        row.Text.TextTransparency = 1 - rv
    end

    local function computeHeight()
        panelH = math.clamp(#d.Options, 1, o.MaxRows or 10) * metrics.ListRowH
    end

    local function onReveal()
        local rv = d.Reveal
        panel.BackgroundTransparency = 1 - rv
        panelStroke.Transparency = 1 - rv
        emptyLabel.TextTransparency = 1 - rv
        for _, row in rows do refreshRow(row) end
    end

    local function syncRows(animated)
        local mode = animated and "Fast" or false
        for _, row in rows do
            local sel = isSelected(row.Option)
            if animated then
                animate(row, "Sel", sel and 1 or 0, "Fast", { Step = function() refreshRow(row) end })
            else
                setNow(row, "Sel", sel and 1 or 0)
                refreshRow(row)
            end
            setOrAnimate(row.Text, "Position", fromOffset(sel and 17 or 8, row.TextY), animated, "Smooth")
            repaint(row.Text, mode)
            repaint(row.Button, mode)
        end
        setText(valueLabel, summary())
    end

    local function place()
        local pos, size = field.AbsolutePosition, field.AbsoluteSize
        local screen = window.Screen
        local sp, ss = screen.AbsolutePosition, screen.AbsoluteSize
        openUp = pos.Y + size.Y + 6 + panelH > sp.Y + ss.Y - 8
            and pos.Y - 6 - panelH > screen.AbsolutePosition.Y + 8
        local p = toLocal(new(pos.X, openUp and pos.Y - 6 or pos.Y + size.Y + 6))
        panel.AnchorPoint = openUp and new(0, 1) or new(0, 0)
        panel.Position = fromOffset(p.X, p.Y)
    end

    local function rebuild()
        for _, row in rows do row.Button:Destroy() end
        rows = {}
        local n = #d.Options
        for i, opt in d.Options do
            local row = { Option = opt, Sel = 0, Hov = 0, Hovering = false }
            row.Button = create("TextButton", {
                Bg = function() return row.Hovering and copy.Inline or copy.Tab end,
                BackgroundTransparency = 1,
                Position = fromOffset(0, (i - 1) * metrics.ListRowH),
                Size = new2(1, 0, 0, metrics.ListRowH),
                Radius = (i == 1 or i == n) and metrics.Radius or nil,
            }, scroll)
            row.Bar = create("Frame", {
                Bg = "Accent", BackgroundTransparency = 1,
                Position = fromOffset(7, 6), Size = fromOffset(2, 12),
            }, row.Button)
            row.Text = label(row.Button, {
                Text = tostring(opt), X = 8, TextSize = 13, RowH = metrics.ListRowH, Right = 18,
                Truncate = Enum.TextTruncate.AtEnd, TextTransparency = 1,
                Fg = function() return isSelected(opt) and copy.Text or copy.InactiveText end,
            })
            row.TextY = row.Text.Position.Y.Offset

            hoverable(row.Button, function()
                row.Hovering = true
                repaint(row.Button)
                animate(row, "Hov", 1, "Fast", { Step = function() refreshRow(row) end })
            end, function()
                row.Hovering = false
                repaint(row.Button)
                animate(row, "Hov", 0, "Fast", { Step = function() refreshRow(row) end })
            end)

            row.Button.MouseButton1Click:Connect(function()
                if d.Multi then
                    d.Value[opt] = not d.Value[opt] or nil
                    syncRows(true)
                    fire(d.Callback, d.Value)
                else
                    d:Set(opt)
                    d:Toggle(false)
                end
            end)
            table.insert(rows, row)
        end
        scroll.CanvasSize = fromOffset(0, n * metrics.ListRowH)
        emptyLabel.Visible = n == 0
        syncRows(false)
    end

    d.Follow = place

    function d:Toggle(open)
        local v = open
        if v == nil then v = not d.Open end
        if v == d.Open then return end
        d.Open = v
        repaint(fieldStroke)
        local width = field.AbsoluteSize.X

        if v then
            if window.OpenDropdown and window.OpenDropdown ~= d then window.OpenDropdown:Toggle(false) end
            window.OpenDropdown = d
            computeHeight()
            place()
            panel.Visible = true
            panel.Size = fromOffset(width, panelH)
            animate(d, "Reveal", 1, "Fast", { Step = onReveal })

            local selIndex = not d.Multi and table.find(d.Options, d.Value)
            local maxScroll = math.max(0, #d.Options * metrics.ListRowH - panelH)
            scroll.CanvasPosition = new(0, selIndex and math.clamp(
                floor2((selIndex - 1) * metrics.ListRowH - (panelH - metrics.ListRowH) / 2), 0, maxScroll) or 0)

            for i, row in rows do
                local y = (i - 1) * metrics.ListRowH
                row.Button.Position = fromOffset(0, y + 6)
                task.delay(math.min(i, 10) * 0.012, function()
                    if row.Button.Parent then
                        setOrAnimate(row.Button, "Position", fromOffset(0, y), d.Open, "Smooth")
                    end
                end)
            end
        else
            if window.OpenDropdown == d then window.OpenDropdown = nil end
            animate(d, "Reveal", 0, "Fast", {
                Step = onReveal,
                Done = function() panel.Visible = false end,
            })
        end
    end

    function d:Set(v, silent)
        if d.Multi then
            d.Value = {}
            for _, x in v do d.Value[x] = true end
        else
            d.Value = v
        end
        syncRows(true)
        if not silent then fire(d.Callback, d.Multi and d.Value or v) end
    end

    function d:SetOptions(options)
        d.Options = options
        rebuild()
        if d.Open then
            computeHeight()
            panel.Size = fromOffset(field.AbsoluteSize.X, panelH)
        end
    end

    d.Input = field
    d.Panel = panel

    field.MouseButton1Click:Connect(function()
        if window.DropdownClosedBy == field and os.clock() - window.DropdownClosedAt < 0.25 then return end
        d:Toggle()
    end)

    rebuild()
    return d
end

function Section:Dropdown(o)
    local item = self:_item(metrics.DropdownH, "Dropdown", o.Name)
    label(item.Frame, { Text = o.Name, Truncate = Enum.TextTruncate.AtEnd })
    o.Y = metrics.DropdownH - metrics.InputH
    local d = makeDropdown(self.Window, item.Frame, o)
    d.Item = item
    registerFlag(self, d, o, item)
    return d
end

function Section:Button(o)
    local item = self:_item(metrics.ButtonH, "Button", o.Name)
    local window = self.Window
    local btn = create("TextButton", {
        Position = fromOffset(1, 1), Size = new2(1, -2, 0, metrics.ButtonH - 2),
        Radius = metrics.Radius, Border = "Outline", BackgroundTransparency = 0,
    }, item.Frame)
    hoverColors(btn, "Element", "HoveredElement", "Inline")
    makeGradient(btn)
    local _, resize = centeredLabel(btn, sliderWidth(window), { Text = o.Name, TextSize = 13, RowH = metrics.ButtonH - 2 })
    table.insert(window.ResizeJobs, function() resize(sliderWidth(window)) end)
    local obj = { Item = item, Instance = btn, Callback = o.Callback }
    btn.MouseButton1Click:Connect(function() fire(obj.Callback) end)
    return obj
end

function Section:Textbox(o)
    local item = self:_item(metrics.InputH, "Textbox", o.Name or o.Placeholder)
    local box = create("Frame", {
        Bg = "Element", Position = fromOffset(1, 1), Size = new2(1, -2, 0, metrics.InputH - 2),
        Radius = metrics.Radius, Border = "Outline",
    }, item.Frame)
    makeGradient(box)
    local input = create("TextBox", {
        Fg = "Text", PlaceholderText = o.Placeholder or o.Name or "", Text = o.Default or "",
        TextSize = 13, Position = fromOffset(7, textOffset(metrics.InputH - 2, 13)),
        Size = new2(1, -14, 0, 18), ClearTextOnFocus = false,
    }, box)
    bind(input, "PlaceholderColor3", "InactiveText")

    local t = { Item = item, Instance = input, Value = input.Text, Callback = o.Callback }
    function t:Set(text, silent)
        input.Text = text
        t.Value = text
        if not silent then fire(t.Callback, text) end
    end

    local stroke = box:FindFirstChildOfClass("UIStroke")
    local focused = false
    bind(stroke, "Color", function() return focused and copy.Accent or copy.Outline end)
    input.Focused:Connect(function() focused = true; repaint(stroke) end)
    input.FocusLost:Connect(function()
        focused = false
        repaint(stroke)
        t:Set(input.Text)
    end)

    registerFlag(self, t, o, item)
    return t
end

function Section:Listbox(o)
    local height = o.Height or 177
    local item = self:_item(height, "Listbox", o.Name, false)
    local scroll = create("ScrollingFrame", {
        Bg = "Inline", Position = fromOffset(1, 1), Size = new2(1, -2, 0, height - 2),
        Radius = metrics.Radius, Border = "Outline", ScrollBarThickness = 0, CanvasSize = fromOffset(0, 0),
    }, item.Frame)

    local lb = { Options = {}, Value = nil, Item = item, Callback = o.Callback }
    local rows = {}
    local emptyLabel = label(scroll, {
        Fg = "InactiveText", Text = o.Empty or "Nothing here yet", TextSize = 13, X = 10, Y = 2,
        RowH = metrics.ListRowH, Right = 8,
    })

    local function sync(animated)
        local mode = animated and "Fast" or false
        for _, row in rows do
            local sel = lb.Value == row.Option
            repaint(row.Text, mode)
            setOrAnimate(row.Text, "Position", fromOffset(sel and 17 or 8, row.TextY), animated, "Smooth")
            setOrAnimate(row.Bar, "BackgroundTransparency", sel and 0 or 1, animated, "Fast")
        end
    end

    function lb:Set(v, silent)
        lb.Value = v
        sync(true)
        if not silent then fire(lb.Callback, v) end
    end

    function lb:SetOptions(options)
        for _, row in rows do row.Button:Destroy() end
        rows = {}
        lb.Options = options
        for i, opt in options do
            local row = { Option = opt }
            row.Button = create("TextButton", {
                Bg = "HoveredElement", BackgroundTransparency = 1,
                Position = fromOffset(2, 2 + (i - 1) * metrics.ListRowH),
                Size = new2(1, -4, 0, metrics.ListRowH), Radius = metrics.SmallRadius,
            }, scroll)
            ignoreFade[row.Button] = true
            row.Bar = create("Frame", {
                Bg = "Accent", BackgroundTransparency = 1, Position = fromOffset(6, 6), Size = fromOffset(2, 12),
            }, row.Button)
            row.Text = label(row.Button, {
                Text = opt, X = 8, TextSize = 13, RowH = metrics.ListRowH, Right = 18,
                Truncate = Enum.TextTruncate.AtEnd,
                Fg = function() return lb.Value == opt and copy.Text or copy.InactiveText end,
            })
            row.TextY = row.Text.Position.Y.Offset
            hoverable(row.Button,
                function() animate(row.Button, "BackgroundTransparency", 0, "Fast") end,
                function() animate(row.Button, "BackgroundTransparency", 1, "Fast") end)
            row.Button.MouseButton1Click:Connect(function() lb:Set(opt) end)
            table.insert(rows, row)
        end
        scroll.CanvasSize = fromOffset(0, 4 + #options * metrics.ListRowH)
        emptyLabel.Visible = #options == 0
        sync(false)
    end

    lb:SetOptions(o.Options or {})
    return lb
end

------------------------------------------------------------------ section drag & drop
function Section:_beginDrag()
    if self.Dropping then return end
    local window = self.Window
    local startMouse = mousePos()
    local grab = startMouse - self.Root.AbsolutePosition
    local card = self.Card
    local stroke = card:FindFirstChildOfClass("UIStroke")
    local started = false
    local ghost, ghostFader

    local function slotPos(column)
        return column.Scroll.AbsolutePosition + new(0, self.Y - column.Scroll.CanvasPosition.Y)
    end

    local function findDrop(pos)
        local c1, c2 = self.Tab.Columns[1], self.Tab.Columns[2]
        local midX = (c1.Scroll.AbsolutePosition.X + c1.Scroll.AbsoluteSize.X + c2.Scroll.AbsolutePosition.X) / 2
        local col = pos.X < midX and c1 or c2
        local cur = table.find(col.Sections, self)
        local idx = 1
        for i, s in col.Sections do
            if s ~= self then
                local mid = col.Scroll.AbsolutePosition.Y - col.Scroll.CanvasPosition.Y + s.Y + s.TotalH / 2
                local bias = cur and i < cur and -14
                if pos.Y > mid + (bias or 14) then idx = idx + 1 end
            end
        end
        return col, idx
    end

    local function begin()
        started = true
        self.Dragging = true
        window:CloseFloating()
        local absPos = self.Root.AbsolutePosition
        local absSize = self.Root.AbsoluteSize
        local p = toLocal(absPos)
        self.Root.Parent = window.DragLayer
        self.Root.Size = fromOffset(absSize.X, self.TotalH)
        self.Root.Position = fromOffset(p.X, p.Y)
        repaint(stroke)

        ghost = create("Frame", {
            Bg = "Accent", BackgroundTransparency = 0.92, Radius = metrics.CardRadius, Border = "Accent",
            Position = fromOffset(p.X, p.Y), Size = fromOffset(absSize.X, self.TotalH), ZIndex = -1,
        }, window.DragLayer)
        ghostFader = newFader(ghost)
        ghost.Visible = false
        ghostFader:Show(nil, "Fast")
    end

    dragLoop(function(pos)
        if not started then
            if (pos - startMouse).Magnitude < 5 then return end
            begin()
        end
        local p = toLocal(pos - grab)
        animate(self.Root, "Position", fromOffset(p.X, p.Y), "Follow")
        local col, idx = findDrop(pos)
        local cur = table.find(col.Sections, self)
        if col ~= self.Column or cur ~= idx then
            local old = self.Column
            table.remove(old.Sections, table.find(old.Sections, self))
            table.insert(col.Sections, math.min(idx, #col.Sections + 1), self)
            self.Column = col
            if old ~= col then old:Layout(true) end
            col:Layout(true)
        end
    end, function()
        if not started then return end
        local col = self.Column
        col:Layout(true)
        self.Dragging = false
        self.Dropping = true
        repaint(stroke)
        local p = toLocal(slotPos(col))
        local g = ghost
        ghostFader:Hide(function() g:Destroy() end)
        animate(self.Root, "Position", fromOffset(p.X, p.Y), "Smooth", {
            Done = function()
                self.Dropping = false
                self.Root.Parent = col.Scroll
                self.Root.Size = new2(1, 0, 0, self.TotalH)
                self.Root.Position = fromOffset(0, self.Y)
            end,
        })
    end, function(pos)
        if not started then return end
        local col = self.Column
        local sc = col.Scroll
        local top = sc.AbsolutePosition.Y
        local bottom = top + sc.AbsoluteSize.Y
        if pos.X >= sc.AbsolutePosition.X and pos.X <= sc.AbsolutePosition.X + sc.AbsoluteSize.X then
            if pos.Y < top + 36 then col:ScrollTo(col.Target - 8)
            elseif pos.Y > bottom - 36 then col:ScrollTo(col.Target + 8) end
        end
        local p = toLocal(slotPos(col))
        animate(ghost, "Position", fromOffset(p.X, p.Y), "Smooth")
    end)
end

function Tab:Section(o)
    local window = self.Window
    local column = self.Columns[o.Side or 1]
    local headerH = o.Description and metrics.HeaderDescH or metrics.HeaderH

    local root = create("Frame", { Name = o.Name, Size = new2(1, 0, 0, headerH) }, column.Scroll)
    local header = create("TextButton", { Size = new2(1, 0, 0, headerH - 8) }, root)
    local hover = false
    local function textColor() return hover and copy.Text or copy.InactiveText end

    local icon = makeIcon(header, o.Icon or "cube", 16, textColor, "Tab")
    local title = label(header, { Text = o.Name, X = 27, Fg = textColor, Truncate = Enum.TextTruncate.AtEnd })
    if o.Description then
        label(header, {
            Fg = "InactiveText", Text = o.Description, TextSize = 11, RowH = 14, Y = 18,
            Truncate = Enum.TextTruncate.AtEnd,
        })
    end

    local card = create("Frame", {
        Bg = "Inline", Active = true, Position = fromOffset(1, headerH + 1),
        Size = new2(1, -2, 0, 0), Radius = metrics.CardRadius,
    }, root)

    local section
    local cardStroke = create("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Thickness = 1 }, card)
    bind(cardStroke, "Color", function() return section and section.Dragging and copy.Accent or copy.Outline end)

    local body = create("Frame", {
        Position = fromOffset(metrics.Pad - 1, -1), Size = new2(1, -(metrics.Pad - 1) * 2, 1, 2),
    }, card)

    section = setmetatable({
        Window = window, Tab = self, Column = column, Name = o.Name,
        Root = root, Card = card, Body = body, Items = {},
        HeaderH = headerH, TotalH = headerH, CardH = 0, Y = 0,
        Dragging = false, Dropping = false, Title = title,
    }, Section)

    table.insert(column.Sections, section)
    table.insert(window.Sections, section)

    hoverable(header, function()
        hover = true; icon.Update(); repaint(title)
    end, function()
        hover = false; icon.Update(); repaint(title)
    end)
    header.MouseButton1Down:Connect(function() section:_beginDrag() end)
    section:Layout(false)
    return section
end

------------------------------------------------------------------ window
local function parentGui(gui)
    local ok = false
    if typeof(gethui) == "function" then
        ok = pcall(function() gui.Parent = gethui() end)
    end
    if not ok then
        ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    end
    if not ok or not gui.Parent then
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
end

function Window:Category(text)
    local y = self.SidebarY + (self.SidebarHasTabs and metrics.TabToCategory or 0)
    label(self.Sidebar, {
        Fg = "InactiveText", Text = text, TextSize = 9, X = metrics.Pad, RowH = 12, Y = y - 6, W = 120,
    })
    self.SidebarY = y
    self.SidebarAfterCategory = true
end

function Window:Tab(o)
    local y = self.SidebarY + (self.SidebarAfterCategory and metrics.CategoryToTab or metrics.TabPitch)
    self.SidebarAfterCategory = false
    self.SidebarHasTabs = true
    self.SidebarY = y

    local tab = setmetatable({ Window = self, Name = o.Name, Y = y - metrics.TabH / 2 }, Tab)
    local button = create("TextButton", {
        Position = fromOffset(metrics.Pad, tab.Y), Size = fromOffset(metrics.TabW, metrics.TabH), ZIndex = 2,
    }, self.Sidebar)
    tab.Button = button
    local hover = false
    local function isCurrent() return self.CurrentTab == tab end
    local function textColor() return (isCurrent() or hover) and copy.Text or copy.InactiveText end

    tab.Icon = makeIcon(button, o.Icon or "cube", 16, textColor,
        function() return isCurrent() and copy.Inline or copy.Background end,
        { Position = fromOffset(6, 6) })
    tab.Label = label(button, {
        Text = o.Name, X = 33, TextSize = 13, RowH = metrics.TabH, Fg = textColor, Right = 6,
        Truncate = Enum.TextTruncate.AtEnd,
    })
    tab.LabelY = tab.Label.Position.Y.Offset
    tab.Page = create("Frame", { Name = o.Name, Size = new2(1, 0, 1, 0), Visible = false }, self.Pages)
    tab.Columns = {}

    for i = 1, 2 do
        local x = metrics.Pad + (i - 1) * (self.ColumnW + metrics.Pad)
        local scroll = create("ScrollingFrame", {
            Position = fromOffset(x, 0), Size = new2(0, self.ColumnW, 1, 0), ScrollBarThickness = 0,
            CanvasSize = fromOffset(0, 0), ScrollingEnabled = not UserInputService.MouseEnabled,
            ClipsDescendants = true,
        }, tab.Page)

        local col = setmetatable({
            Scroll = scroll, Sections = {}, Target = 0, ContentH = 0, Tab = tab,
            ShowTop = false, ShowBottom = false,
        }, Column)

        local function fade(pos, rotation)
            local f = create("Frame", {
                Bg = "Tab", BackgroundTransparency = 1, Position = pos,
                Size = fromOffset(self.ColumnW, 14), ZIndex = 4,
            }, tab.Page)
            create("UIGradient", { Rotation = rotation, Transparency = NumberSequence.new(1, 0) }, f)
            return f
        end
        col.FadeTop = fade(fromOffset(x, 0), 270)
        col.FadeBottom = fade(new2(0, x, 1, -14), 90)

        table.insert(self.Columns, col)
        tab.Columns[i] = col
    end

    local function paint()
        tab.Icon.Update()
        repaint(tab.Label)
        animate(tab.Label, "Position",
            fromOffset(hover and not isCurrent() and 35 or 33, tab.LabelY), "Smooth")
    end
    tab.Paint = paint

    hoverable(button, function() hover = true; paint() end, function() hover = false; paint() end)
    button.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
    table.insert(self.Tabs, tab)
    if not self.CurrentTab then self:SelectTab(tab, true) end
    return tab
end

function Window:SelectTab(tab, instant)
    if self.CurrentTab == tab then return end
    local prev = self.CurrentTab
    self.CurrentTab = tab
    self:CloseFloating()
    if prev then
        prev.Page.Visible = false
        prev.Paint()
    end
    tab.Page.Visible = true
    tab.Paint()
    self.Indicator.Visible = true
    setOrAnimate(self.Indicator, "Position", fromOffset(metrics.Pad + 1, tab.Y + 1), not instant, "Soft")
    if not instant then
        self.Veil.BackgroundTransparency = 0
        animate(self.Veil, "BackgroundTransparency", 1, "Soft")
        tab.Page.Position = fromOffset(0, 10)
        animate(tab.Page, "Position", fromOffset(0, 0), "Soft")
    end
end

function Window:SetHotkeyActive(kb, active)
    local entry = self.HotkeyEntries[kb]
    local want = active and kb.Key ~= nil
    local create_ = want and not entry

    if create_ then
        local frame = create("Frame", {
            Bg = "Background", Size = fromOffset(40, 24), Radius = metrics.FloatRadius,
            Border = "Outline", Visible = false,
        }, self.Hotkeys)
        create("Frame", {
            Bg = "Accent", Position = fromOffset(1, 5), Size = fromOffset(2, 14), Radius = metrics.SmallRadius,
        }, frame)
        local lbl = label(frame, { TextSize = 12, X = metrics.Pad, RowH = 24, Weight = Enum.FontWeight.SemiBold })
        entry = { Frame = frame, Label = lbl, Fader = newFader(frame) }
        self.HotkeyEntries[kb] = entry
        table.insert(self.HotkeyOrder, kb)

        lbl:GetPropertyChangedSignal("TextBounds"):Connect(function()
            frame.Size = fromOffset(math.ceil(lbl.TextBounds.X) + metrics.Pad * 2, 24)
        end)
        setText(lbl, (kb.Name or "Key") .. " - " .. keyName(kb.Key))
        frame.Size = fromOffset(math.ceil(lbl.TextBounds.X) + metrics.Pad * 2, 24)
        frame.Position = fromOffset(-14, 33 * #self.HotkeyOrder + 1)
        entry.Fader:Show()
    elseif entry and want then
        setText(entry.Label, (kb.Name or "Key") .. " - " .. keyName(kb.Key))
        return
    elseif entry then
        self.HotkeyEntries[kb] = nil
        table.remove(self.HotkeyOrder, table.find(self.HotkeyOrder, kb))
        animate(entry.Frame, "Position", fromOffset(-14, entry.Frame.Position.Y.Offset), "Smooth")
        entry.Fader:Hide(function() entry.Frame:Destroy() end)
    else
        return
    end

    for i, k in self.HotkeyOrder do
        animate(self.HotkeyEntries[k].Frame, "Position", fromOffset(1, 33 * i + 1), "Settle")
    end
end

function Window:Notify(o)
    if type(o) == "string" then o = { Text = o } end
    local frame = create("Frame", {
        Bg = "Background", Size = fromOffset(60, 28), Radius = metrics.FloatRadius,
        Border = "Outline", Visible = false,
    }, self.Notifications)
    makeIcon(frame, o.Icon or "check", 14, function() return fromRGB(112, 205, 132) end, "Background",
        { Position = fromOffset(8, 7) })
    local lbl = label(frame, {
        Text = o.Text, TextSize = 12, X = 28, RowH = 28, W = 340, Truncate = Enum.TextTruncate.AtEnd,
    })
    local n = { Frame = frame, Fader = newFader(frame) }

    local function fit()
        frame.Size = fromOffset(math.min(math.ceil(lbl.TextBounds.X), 340) + 38, 28)
    end
    lbl:GetPropertyChangedSignal("TextBounds"):Connect(fit)
    fit()
    table.insert(self.NotifyStack, 1, n)

    local function restack()
        local count = #self.NotifyStack
        for i, entry in self.NotifyStack do
            local y = (count - i) * 36
            if not entry.Placed then
                entry.Placed = true
                entry.Frame.Position = fromOffset(-36, y)
            end
            animate(entry.Frame, "Position", fromOffset(0, y), "Settle")
        end
    end

    function n.Dismiss()
        if n.Gone then return end
        n.Gone = true
        table.remove(self.NotifyStack, table.find(self.NotifyStack, n))
        animate(frame, "Position", fromOffset(-36, frame.Position.Y.Offset), "Smooth")
        n.Fader:Hide(function() frame:Destroy() end)
        restack()
    end

    restack()
    n.Fader:Show()
    if #self.NotifyStack > 6 then self.NotifyStack[#self.NotifyStack].Dismiss() end
    task.delay(o.Duration or 3, n.Dismiss)
end

function Window:ApplyTheme(name, silent)
    local theme = themes[name]
    if not theme then return end
    for k, v in theme do copy[k] = v end
    self.ThemeName = name

    local offscreen = {}
    for _, tab in self.Tabs do
        if tab ~= self.CurrentTab then
            for _, d in tab.Page:GetDescendants() do offscreen[d] = true end
        end
    end
    for inst in bindings do
        repaint(inst, not offscreen[inst] and "Soft" or false)
    end
    for _, row in self.ThemeRows do
        row.Color:Set(copy[row.Key], nil, true)
    end
    if not silent then self:Notify(('Applied "%s" theme.'):format(name)) end
end

function Window:SetThemeColor(key, color)
    copy[key] = color
    self.PendingThemeKeys[key] = true
end

function Window:_flushThemeColors(dt)
    self.ThemeClock = self.ThemeClock + dt
    if next(self.PendingThemeKeys) == nil or self.ThemeClock < 1 / 30 then return end
    self.ThemeClock = 0
    for key in self.PendingThemeKeys do
        local set = bindByKey[key]
        if set then
            for inst, prop in set do setNow(inst, prop, copy[key]) end
        end
        self.PendingThemeKeys[key] = nil
    end
    for inst in dynamicBound do repaint(inst, false) end
end

function Window:SetCasing(mode, silent)
    casing = mode
    refreshFonts()
    if not silent then self:Notify(('Set casing to "%s".'):format(mode)) end
end

function Window:SetFont(name)
    fontId = fonts[name] or name
    refreshFonts()
end

function Window:SetTextWeight(name)
    defaultWeight = Enum.FontWeight[name]
    refreshFonts()
end

function Window:CloseFloating()
    if self.OpenDropdown then self.OpenDropdown:Toggle(false) end
    self:ClosePopup()
end

function Window:ClosePopup()
    local popup = self.ActivePopup
    if not popup then return end
    self.ActivePopup = nil
    self.LastPopupAnchor = popup.Anchor
    self.LastPopupTime = os.clock()
    if popup.OnClose then popup.OnClose() end
    local p = popup.Frame.Position
    animate(popup.Frame, "Position", fromOffset(p.X.Offset, p.Y.Offset - 4), "Fast")
    popup.Fader:Hide()
end

function Window:_openPopup(popup, anchor, absPos)
    if self.LastPopupAnchor == anchor and os.clock() - self.LastPopupTime < 0.2 then return false end
    self:ClosePopup()
    local p = toLocal(absPos)
    local screenSize = self.Screen.AbsoluteSize
    local size = popup.Frame.Size
    local x = math.clamp(floor2(p.X), 8, math.max(8, screenSize.X - size.X.Offset - 8))
    local y = math.clamp(floor2(p.Y), 8, math.max(8, screenSize.Y - size.Y.Offset - 8))
    popup.Anchor = anchor
    popup.Frame.Position = fromOffset(x, y - 6)
    animate(popup.Frame, "Position", fromOffset(x, y), "Settle")
    popup.Fader:Show()
    self.ActivePopup = popup
    return true
end

function Window:OpenKeybindMenu(anchor, target)
    local menu = self.KeybindMenu
    menu.Target = target
    menu.Paint(false)
    local p, s = anchor.AbsolutePosition, anchor.AbsoluteSize
    self:_openPopup(menu, anchor, new(p.X, p.Y + s.Y + metrics.Gap))
end

function Window:OpenPicker(anchor, target)
    local picker = self.Picker
    if self.LastPopupAnchor == anchor and os.clock() - self.LastPopupTime < 0.2 then return end
    local p, s = anchor.AbsolutePosition, anchor.AbsoluteSize
    picker.Target = target
    picker.Sync()
    self:_openPopup(picker, anchor, new(p.X - 8, p.Y + s.Y + metrics.Pad))
end

function Window:_clamped(frame, x, y)
    local screenSize = self.Screen.AbsoluteSize
    local size = frame.AbsoluteSize
    local anchor = frame.AnchorPoint
    local minVisible = math.min(60, size.X)
    local cx = math.clamp(x - anchor.X * size.X, minVisible - size.X,
        math.max(minVisible - size.X, screenSize.X - minVisible))
    local cy = math.clamp(y - anchor.Y * size.Y, 0, math.max(0, screenSize.Y - 30))
    return fromOffset(round(cx + anchor.X * size.X), round(cy + anchor.Y * size.Y))
end

function Window:_modalPosition(dy)
    return fromOffset(floor2((self.Width - 420) / 2), floor2((self.Height - 340) / 2) + dy)
end

local function snapEven(v, min, max)
    local c = math.clamp(floor2(v), min, math.max(min, max))
    return c - c % 2
end

function Window:_minHeight()
    local r = math.ceil(self.SidebarY + metrics.TabH / 2 + metrics.Gap + metrics.SearchH + metrics.Pad)
    return snapEven(math.max(self.MinSize.Y, r + r % 2), 0, math.huge)
end

function Window:_applySize(w, h)
    self.Width = w
    self.Height = h
    self.ColumnW = (w - metrics.ContentX - metrics.Pad * 3) / 2
    self.Holder.Size = fromOffset(w, h)

    for _, tab in self.Tabs do
        for i, col in tab.Columns do
            local x = metrics.Pad + (i - 1) * (self.ColumnW + metrics.Pad)
            col.Scroll.Position = fromOffset(x, 0)
            col.Scroll.Size = new2(0, self.ColumnW, 1, 0)
            col.FadeTop.Position = fromOffset(x, 0)
            col.FadeTop.Size = fromOffset(self.ColumnW, 14)
            col.FadeBottom.Position = new2(0, x, 1, -14)
            col.FadeBottom.Size = fromOffset(self.ColumnW, 14)
            col:ClampScroll()
            if col.Scroll.CanvasPosition.Y > col.Target then
                setNow(col.Scroll, "CanvasPosition", new(0, col.Target))
            end
        end
    end
    for _, job in self.ResizeJobs do job() end
    if self.Search and not self.Search.Open then
        self.Search.Modal.Position = self:_modalPosition(0)
    end
end

function Window:SetSize(w, h)
    local nw = snapEven(w, self.MinSize.X, math.huge)
    local nh = snapEven(h, self:_minHeight(), math.huge)
    local p = self.Holder.Position
    setNow(self.Holder, "Position",
        fromOffset(p.X.Offset + (nw - self.Width) / 2, p.Y.Offset + (nh - self.Height) / 2))
    self.Moved[self.Holder] = true
    self:_applySize(nw, nh)
end

function Window:_beginResize(axisX, axisY, onEnd)
    if self.Search.Open then return end
    self:CloseFloating()
    local start = mousePos()
    local width, height = self.Width, self.Height
    local minH = self:_minHeight()
    local pos = self.Holder.Position
    local left = pos.X.Offset - width / 2
    local top = pos.Y.Offset - height / 2

    dragLoop(function(p)
        local delta = p - start
        local screenSize = self.Screen.AbsoluteSize
        local nw = axisX == 1 and snapEven(width + delta.X, self.MinSize.X, screenSize.X - left - 4) or width
        local nh = axisY == 1 and snapEven(height + delta.Y, minH, screenSize.Y - top - 4) or height
        if nw == self.Width and nh == self.Height then return end
        self.Moved[self.Holder] = true
        setNow(self.Holder, "Position", fromOffset(left + nw / 2, top + nh / 2))
        self:_applySize(nw, nh)
    end, onEnd)
end

function Window:_buildResize()
    local count = 0
    local dragging = false
    local grip = makeIcon(self.Root, "grip", 12, function()
        return (count > 0 or dragging) and copy.InactiveText or copy.Outline
    end, "Tab", { AnchorPoint = new(1, 1), Position = new2(1, -2, 1, -2), ZIndex = 15 })

    local function handle(name, pos, size, anchor, ax, ay)
        local h = create("TextButton", {
            Name = name, AnchorPoint = anchor, Position = pos, Size = size, ZIndex = 16,
        }, self.Root)
        hoverable(h, function() count = count + 1; grip.Update() end, function() count = count - 1; grip.Update() end)
        h.MouseButton1Down:Connect(function()
            dragging = true
            grip.Update()
            self:_beginResize(ax, ay, function() dragging = false; grip.Update() end)
        end)
        table.insert(self.ResizeHandles, h)
    end

    handle("ResizeRight", new2(1, 3, 0, 12), new2(0, 6, 1, -30), new(1, 0), 1, 0)
    handle("ResizeBottom", new2(0, 12, 1, 3), new2(1, -30, 0, 6), new(0, 1), 0, 1)
    handle("ResizeCorner", new2(1, 3, 1, 3), fromOffset(18, 18), new(1, 1), 1, 1)
end

function Window:_makeDraggable(handle, target, filter)
    handle.InputBegan:Connect(function(input)
        if not isPress(input) then return end
        local start = mousePos()
        local startPos = target.Position
        if filter and not filter(start) then return end
        dragLoop(function(p)
            local delta = p - start
            if delta.Magnitude < 1 and not self.Moved[target] then return end
            self.Moved[target] = true
            animate(target, "Position",
                self:_clamped(target, startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y), "Follow")
        end)
    end)
end

function Window:_overControl(pos)
    if self.Search.Open then return true end
    if self.OpenDropdown and inside(self.OpenDropdown.Panel, pos) then return true end
    if self.ActivePopup and inside(self.ActivePopup.Frame, pos) then return true end
    if inside(self.SearchButton, pos) then return true end
    for _, h in self.ResizeHandles do
        if inside(h, pos) then return true end
    end
    for _, tab in self.Tabs do
        if inside(tab.Button, pos) then return true end
    end
    if self.CurrentTab then
        for _, col in self.CurrentTab.Columns do
            if inside(col.Scroll, pos) then
                for _, s in col.Sections do
                    if inside(s.Root, pos) then return true end
                end
            end
        end
    end
    return false
end

function Window:_popupFrame(w, h)
    local frame = create("Frame", { Size = fromOffset(w, h), Visible = false, Active = true }, self.Popups)
    local bg = create("TextButton", {
        Bg = "Background", Size = new2(1, 0, 1, 0), Radius = metrics.PopupRadius, Border = "Outline",
    }, frame)
    makeShadow(bg, "Large")
    local noDrag = {}
    self:_makeDraggable(bg, frame, function(pos)
        for _, g in noDrag do
            if inside(g, pos, 6) then return false end
        end
        return true
    end)
    return frame, bg, noDrag
end

function Window:_buildKeybindMenu()
    local pad, gap, inputH = metrics.Pad, metrics.Gap, metrics.InputH
    local innerW = 202 - pad * 2
    local half = (innerW - gap) / 2
    local frame, bg, noDrag = self:_popupFrame(202, pad * 2 + inputH * 2 + gap)
    local menu = { Frame = frame, Fader = newFader(frame), Target = nil }

    local selector = create("Frame", {
        Bg = "Accent", Size = fromOffset(half - 2, inputH - 2),
        Position = fromOffset(pad + half + gap + 1, pad + 1), Radius = metrics.Radius, Border = "Outline",
    }, bg)
    makeGradient(selector)

    local toggleBtn = create("TextButton", {
        Position = fromOffset(pad, pad), Size = fromOffset(half, inputH), ZIndex = 2,
    }, bg)
    centeredLabel(toggleBtn, half, { Text = "On Toggle", RowH = inputH })
    local holdBtn = create("TextButton", {
        Position = fromOffset(pad + half + gap, pad), Size = fromOffset(half, inputH), ZIndex = 2,
    }, bg)
    centeredLabel(holdBtn, half, { Text = "On Hold", RowH = inputH })

    local resetBtn = create("TextButton", {
        Position = fromOffset(pad + 1, pad + inputH + gap + 1), Size = fromOffset(innerW - 2, inputH - 2),
        Radius = metrics.Radius, Border = "Outline", BackgroundTransparency = 0,
    }, bg)
    hoverColors(resetBtn, "Element")
    makeGradient(resetBtn)

    table.insert(noDrag, toggleBtn)
    table.insert(noDrag, holdBtn)
    table.insert(noDrag, resetBtn)

    local cx = floor2(innerW / 2)
    makeIcon(resetBtn, "reset", 14, "Text", "Element", { Position = fromOffset(cx - 32, 5) })
    label(resetBtn, { Text = "Reset", X = cx - 12, RowH = inputH - 2, W = 50 })

    function menu.Paint(animated)
        local t = menu.Target
        if not t then return end
        setOrAnimate(selector, "Position",
            fromOffset((t.Mode == "Hold" and pad + half + gap or pad) + 1, pad + 1), animated, "Knob")
    end

    toggleBtn.MouseButton1Click:Connect(function()
        if menu.Target then menu.Target.Mode = "Toggle"; menu.Paint(true) end
    end)
    holdBtn.MouseButton1Click:Connect(function()
        if menu.Target then menu.Target.Mode = "Hold"; menu.Paint(true) end
    end)
    resetBtn.MouseButton1Click:Connect(function()
        if menu.Target then menu.Target:Set(nil) end
        self:ClosePopup()
    end)

    self.KeybindMenu = menu
end

function Window:_buildPicker()
    local pad, gap = metrics.Pad, metrics.Gap
    local svW = 216 - pad * 3 - 12
    local hueBottom = pad + 168 + pad
    local alphaY = hueBottom + 12 + pad
    local dropY = alphaY + metrics.Row + gap
    local frame, bg, noDrag = self:_popupFrame(216, dropY + metrics.InputH + pad)

    local picker = {
        Frame = frame, Fader = newFader(frame), Target = nil,
        H = 0, S = 0, V = 1, Alpha = 0, Dragging = false,
    }

    -- saturation / value square
    local sv = create("Frame", {
        BackgroundTransparency = 0, Position = fromOffset(pad + 1, pad + 1),
        Size = fromOffset(svW - 2, 166), Radius = metrics.Radius, Border = "Outline",
    }, bg)
    local white = create("Frame", {
        BackgroundTransparency = 0, BackgroundColor3 = Color3.new(1, 1, 1),
        Size = new2(1, 0, 1, 0), Radius = metrics.Radius,
    }, sv)
    create("UIGradient", { Transparency = NumberSequence.new(0, 1) }, white)
    local black = create("Frame", {
        BackgroundTransparency = 0, BackgroundColor3 = Color3.new(0, 0, 0),
        Size = new2(1, 0, 1, 0), Radius = metrics.Radius,
    }, sv)
    create("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(1, 0) }, black)

    local function makePickerKnob(parent)
        local k = create("Frame", {
            Name = "Knob", BackgroundTransparency = 0, AnchorPoint = new(0.5, 0.5),
            Size = fromOffset(metrics.PickerKnob, metrics.PickerKnob), Radius = 99, ZIndex = 3,
        }, parent)
        bind(create("UIStroke", { Thickness = 2 }, k), "Color", "Text")
        makeShadow(k, "PickerKnob")
        return k
    end

    local svKnob = makePickerKnob(sv)
    local inset = (metrics.PickerKnob + 4) / 2 - 1
    local function knobOffset(r) return round(inset - inset * 2 * r) end
    local function ratioIn(p, origin, size) return clamp01((p - origin - inset) / (size - inset * 2)) end

    -- hue bar
    local hue = create("Frame", {
        BackgroundTransparency = 0, BackgroundColor3 = Color3.new(1, 1, 1),
        Position = fromOffset(pad * 2 + svW + 1, pad + 1), Size = fromOffset(10, 166),
        Radius = metrics.Radius, Border = "Outline",
    }, bg)
    local keys = {}
    for i = 0, 6 do
        table.insert(keys, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6 % 1, 1, 1)))
    end
    create("UIGradient", { Rotation = 90, Color = ColorSequence.new(keys) }, hue)
    local hueKnob = makePickerKnob(hue)

    -- alpha bar
    local alphaBar = create("Frame", {
        Bg = "Background", Position = fromOffset(pad + 1, hueBottom + 1),
        Size = fromOffset(216 - pad * 2 - 2, 10), Radius = metrics.Radius, Border = "Outline",
    }, bg)
    local clip = create("CanvasGroup", {
        Name = "AlphaClip", BackgroundTransparency = 0, BackgroundColor3 = Color3.new(1, 1, 1),
        Size = new2(1, 0, 1, 0), Radius = metrics.Radius,
    }, alphaBar)
    for i = 0, 48 do
        for j = 0, 2 do
            if (i + j) % 2 == 1 then
                create("Frame", {
                    BackgroundTransparency = 0, BackgroundColor3 = fromRGB(190, 190, 190),
                    Position = fromOffset(i * 4, j * 4), Size = fromOffset(4, 4),
                }, clip)
            end
        end
    end
    local alphaFill = create("Frame", { BackgroundTransparency = 0, Size = new2(1, 0, 1, 0) }, clip)
    create("UIGradient", { Transparency = NumberSequence.new(0, 1) }, alphaFill)
    local alphaKnob = makePickerKnob(alphaBar)

    label(bg, { Text = "Animations", X = pad, Y = alphaY })
    local dropHolder = create("Frame", {
        Position = fromOffset(pad, dropY), Size = fromOffset(216 - pad * 2, metrics.InputH),
    }, bg)

    for _, g in { sv, hue, alphaBar, dropHolder } do table.insert(noDrag, g) end

    local function render()
        local color = Color3.fromHSV(picker.H, picker.S, picker.V)
        local pure = Color3.fromHSV(picker.H, 1, 1)
        sv.BackgroundColor3 = pure
        svKnob.BackgroundColor3 = color
        svKnob.Position = new2(picker.S, knobOffset(picker.S), 1 - picker.V, knobOffset(1 - picker.V))
        hueKnob.Position = new2(0.5, 0, picker.H, knobOffset(picker.H))
        hueKnob.BackgroundColor3 = pure
        alphaFill.BackgroundColor3 = color
        alphaKnob.Position = new2(picker.Alpha, knobOffset(picker.Alpha), 0.5, 0)
        alphaKnob.BackgroundColor3 = color
    end

    local function commit()
        render()
        if picker.Target then
            picker.Target:Set(Color3.fromHSV(picker.H, picker.S, picker.V), picker.Alpha)
        end
    end

    function picker.Sync()
        local t = picker.Target
        if not t then return end
        local h, s, v = t.Value:ToHSV()
        if s > 0 and v > 0 then picker.H = h end
        picker.S = s
        picker.V = v
        picker.Alpha = t.Alpha or 0
        render()
        if picker.Animation then picker.Animation:Set(t.Animation or "None", true) end
    end

    local function attachDrag(area, onPos)
        local hit = create("TextButton", {
            Position = fromOffset(-6, -6), Size = new2(1, 12, 1, 12), ZIndex = 5,
        }, area)
        hit.InputBegan:Connect(function(input)
            if not isPress(input) then return end
            picker.Dragging = true
            onPos(mousePos())
            dragLoop(onPos, function() picker.Dragging = false end)
        end)
    end

    attachDrag(sv, function(p)
        picker.S = ratioIn(p.X, sv.AbsolutePosition.X, sv.AbsoluteSize.X)
        picker.V = 1 - ratioIn(p.Y, sv.AbsolutePosition.Y, sv.AbsoluteSize.Y)
        commit()
    end)
    attachDrag(hue, function(p)
        picker.H = math.min(ratioIn(p.Y, hue.AbsolutePosition.Y, hue.AbsoluteSize.Y), 0.9999)
        commit()
    end)
    attachDrag(alphaBar, function(p)
        picker.Alpha = ratioIn(p.X, alphaBar.AbsolutePosition.X, alphaBar.AbsoluteSize.X)
        commit()
    end)

    self.Picker = picker

    picker.Animation = makeDropdown(self, dropHolder, {
        Options = { "None", "Rainbow", "Pulse" }, Default = "None", MaxRows = 3,
        Callback = function(v)
            if picker.Target then picker.Target.Animation = v end
        end,
    })

    function picker.OnClose() picker.Animation:Toggle(false) end
end

function Window:_buildSearch()
    local pad = metrics.Pad

    local overlay = create("TextButton", {
        BackgroundTransparency = 0.45, BackgroundColor3 = Color3.new(0, 0, 0),
        Size = new2(1, 0, 1, 0), Visible = false, ZIndex = 20, Radius = metrics.WindowRadius,
    }, self.Root)
    local modal = create("TextButton", {
        Bg = "Background", Position = self:_modalPosition(0), Size = fromOffset(420, 340),
        Radius = metrics.WindowRadius, Border = "Outline",
    }, overlay)
    local title = label(modal, {
        Text = "Search", TextSize = 14, Weight = Enum.FontWeight.SemiBold, X = pad * 2, Y = pad + 2, RowH = 20,
    })

    local inputFrame = create("Frame", {
        Bg = "Inline", Position = fromOffset(pad * 2 + 1, 43), Size = fromOffset(420 - pad * 4 - 2, 34),
        Radius = metrics.PillRadius, Border = "Outline",
    }, modal)
    makeIcon(inputFrame, "search", 14, "InactiveText", "Inline", { Position = fromOffset(10, 10) })
    local box = create("TextBox", {
        Fg = "Text", PlaceholderText = "Type to search...",
        Position = fromOffset(34, textOffset(34, 13)), Size = new2(1, -45, 0, 20), ClearTextOnFocus = false,
    }, inputFrame)
    bind(box, "PlaceholderColor3", "InactiveText")

    local results = create("ScrollingFrame", {
        Position = fromOffset(pad * 2, 88), Size = fromOffset(420 - pad * 4 + 6, 252 - pad),
        CanvasSize = fromOffset(0, 0), ScrollBarThickness = 2, ScrollBarImageTransparency = 0,
    }, modal)
    bind(results, "ScrollBarImageColor3", "Accent")

    local noResults = centeredLabel(modal, 420, { Fg = "InactiveText", Text = "No results", Y = 170 })
    noResults.Visible = false

    local search = {
        Overlay = overlay, Modal = modal, Fader = newFader(overlay), Open = false,
        Rows = {}, Dirty = false, Box = box, Order = {},
    }

    local function jumpTo(target)
        self:CloseSearch()
        local section = target.Section or target
        self:SelectTab(section.Tab)
        section.Column:ScrollTo(section.Y + (target.Section and section.HeaderH + target.Y or 0) - 40)
        if target.Frame then
            local glow = create("Frame", {
                Bg = "Accent", BackgroundTransparency = 0.7, Position = fromOffset(-6, -3),
                Size = new2(1, 12, 1, 6), Radius = metrics.Radius, ZIndex = 0,
            }, target.Frame)
            task.delay(0.2, function()
                animate(glow, "BackgroundTransparency", 1, "Soft", { Done = function() glow:Destroy() end })
            end)
        end
    end

    local function retire(row)
        row.Retired = true
        row.Frame:Destroy()
    end

    local function makeRow(target, name, sub, y)
        local f = create("TextButton", {
            Bg = "HoveredElement", BackgroundTransparency = 1, Position = fromOffset(10, y),
            Size = fromOffset(420 - pad * 4, 44), Radius = metrics.Radius,
        }, results)
        ignoreFade[f] = true
        local row = {
            Frame = f, Y = y, Retired = false,
            Bar = create("Frame", {
                Bg = "Accent", BackgroundTransparency = 1, Position = fromOffset(4, 8),
                Size = fromOffset(3, 28), Radius = metrics.SmallRadius,
            }, f),
            Name = label(f, {
                Text = name, TextSize = 13, X = 14, Y = 5, RowH = 18, TextTransparency = 1,
                Right = 10, Truncate = Enum.TextTruncate.AtEnd,
            }),
            Sub = label(f, {
                Fg = "InactiveText", Text = sub, TextSize = 11, X = 14, Y = 22, RowH = 16,
                TextTransparency = 1, Right = 10, Truncate = Enum.TextTruncate.AtEnd,
            }),
        }
        hoverable(f, function() animate(f, "BackgroundTransparency", 0.4, "Fast") end,
            function() animate(f, "BackgroundTransparency", 1, "Fast") end)
        f.MouseButton1Click:Connect(function() jumpTo(target) end)
        return row
    end

    local function refresh()
        local text = box.Text
        setText(title, text ~= "" and text or "Search")
        setText(self.SearchLabel, text ~= "" and text or "Search...")

        local seen = {}
        local order = {}
        if text ~= "" then
            local lower = string.lower(text)
            local function consider(key, name, sub)
                if #order < 30 and name and string.find(string.lower(name), lower, 1, true) then
                    seen[key] = true
                    table.insert(order, { key, name, sub })
                end
            end
            for _, s in self.Sections do
                consider(s, s.Name, s.Tab.Name .. " / " .. s.Name .. "  ·  Section")
            end
            for _, it in self.Index do
                consider(it, it.Name, it.Section.Tab.Name .. " / " .. it.Section.Name .. "  ·  " .. it.Kind)
            end
        end

        for key, row in search.Rows do
            if not seen[key] then
                search.Rows[key] = nil
                retire(row)
            end
        end

        local fresh = 0
        for i, entry in order do
            local key = entry[1]
            local y = (i - 1) * 48
            local row = search.Rows[key]
            if row then
                row.Y = y
                animate(row.Frame, "Position", fromOffset(0, y), "Smooth")
            else
                row = makeRow(key, entry[2], entry[3], y)
                search.Rows[key] = row
                fresh = fresh + 1
                task.delay(math.min(fresh, 8) * 0.025, function()
                    if row.Retired then return end
                    animate(row.Frame, "Position", fromOffset(0, row.Y), "Smooth")
                    animate(row.Bar, "BackgroundTransparency", 0, "Smooth")
                    animate(row.Name, "TextTransparency", 0, "Smooth")
                    animate(row.Sub, "TextTransparency", 0, "Smooth")
                end)
            end
        end

        results.CanvasSize = fromOffset(0, #order * 48)
        search.Order = order
        noResults.Visible = text ~= "" and #order == 0
    end

    box:GetPropertyChangedSignal("Text"):Connect(function() search.Dirty = true end)
    box.FocusLost:Connect(function(enter)
        if UserInputService:IsKeyDown(Enum.KeyCode.Escape) then
            self:CloseSearch()
        elseif enter then
            if search.Dirty then
                search.Dirty = false
                refresh()
            end
            if search.Order[1] then jumpTo(search.Order[1][1]) end
        end
    end)

    overlay.MouseButton1Click:Connect(function() self:CloseSearch() end)
    search.Sync = refresh
    self.Search = search
end

function Window:OpenSearch()
    local s = self.Search
    if s.Open then return end
    s.Open = true
    self:CloseFloating()
    s.Modal.Position = self:_modalPosition(10)
    animate(s.Modal, "Position", self:_modalPosition(0), "Smooth")
    s.Fader:Show()
    s.Box:CaptureFocus()
end

function Window:CloseSearch()
    local s = self.Search
    if not s.Open then return end
    s.Open = false
    s.Box:ReleaseFocus()
    animate(s.Modal, "Position", self:_modalPosition(7), "Fast")
    s.Fader:Hide()
end

function Window:SetVisible(v)
    if self.Visible == v then return end
    self.Visible = v
    self:CloseFloating()
    self.ModalButton.Visible = v
    if not self.Scale.Parent then
        if not v then self.Scale.Scale = 1 end
        self.Scale.Parent = self.Holder
    end
    if v then
        self.Holder.Visible = true
        animate(self.Scale, "Scale", 1, "Smooth", {
            Done = function()
                if self.Visible then self.Scale.Parent = nil end
            end,
        })
    else
        animate(self.Scale, "Scale", 0.97, "Fast", {
            Done = function()
                if not self.Visible then self.Holder.Visible = false end
            end,
        })
    end
end

function Window:Toggle()
    self:SetVisible(not self.Visible)
end

------------------------------------------------------------------ configs
local memoryConfigs = {}
local memoryAutoload

local function configPath(name) return "Petal/" .. name .. ".json" end

function Window:_serialize()
    local out = {}
    for flag, obj in self.Flags do
        local value = obj.Value
        if obj.Swatch then
            value = { Color = obj.Value:ToHex(), Alpha = obj.Alpha }
        elseif obj.Chip then
            value = { Key = obj.Key and obj.Key.Name or false, Mode = obj.Mode }
        elseif obj.Multi then
            local list = {}
            for k, v in obj.Value do
                if v then table.insert(list, k) end
            end
            value = list
        end
        if value ~= nil then out[flag] = value end
    end
    return HttpService:JSONEncode(out)
end

function Window:_deserialize(json)
    for flag, value in HttpService:JSONDecode(json) do
        local obj = self.Flags[flag]
        if obj then
            if obj.Swatch then
                obj:Set(Color3.fromHex(value.Color), value.Alpha)
            elseif obj.Chip then
                obj.Mode = value.Mode or obj.Mode
                local key
                if value.Key then
                    key = string.find(value.Key, "MouseButton", 1, true)
                        and Enum.UserInputType[value.Key] or Enum.KeyCode[value.Key]
                end
                obj:Set(key)
            else
                obj:Set(value)
            end
        end
    end
end

function Window:ListConfigs()
    local list = {}
    if typeof(listfiles) == "function" and typeof(isfolder) == "function" and isfolder("Petal") then
        for _, path in listfiles("Petal") do
            local name = string.match(path, "([^/\\]+)%.json$")
            if name then table.insert(list, name) end
        end
    else
        for name in memoryConfigs do table.insert(list, name) end
    end
    table.sort(list)
    return list
end

function Window:SaveConfig(name)
    local data = self:_serialize()
    if typeof(writefile) == "function" then
        if typeof(isfolder) == "function" and not isfolder("Petal") then makefolder("Petal") end
        writefile(configPath(name), data)
    else
        memoryConfigs[name] = data
    end
end

function Window:LoadConfig(name)
    local fromDisk = typeof(readfile) == "function" and typeof(isfile) == "function" and isfile(configPath(name))
    local data
    if fromDisk then data = readfile(configPath(name)) else data = memoryConfigs[name] end
    if data then
        self:_deserialize(data)
        return true
    end
    return false
end

function Window:DeleteConfig(name)
    if typeof(delfile) == "function" and typeof(isfile) == "function" and isfile(configPath(name)) then
        delfile(configPath(name))
    end
    memoryConfigs[name] = nil
end

local function readAutoload()
    if typeof(readfile) == "function" and typeof(isfile) == "function" then
        return isfile("Petal/autoload.txt") and readfile("Petal/autoload.txt") or nil
    end
    return memoryAutoload
end

local function writeAutoload(name)
    if typeof(writefile) ~= "function" then
        memoryAutoload = name
    elseif name then
        if typeof(isfolder) == "function" and not isfolder("Petal") then makefolder("Petal") end
        writefile("Petal/autoload.txt", name)
    elseif typeof(delfile) == "function" and isfile("Petal/autoload.txt") then
        delfile("Petal/autoload.txt")
    end
end

function Window:BuildSettings(tab)
    local autoName = readAutoload()
    local autoOn = autoName ~= nil
    local autoConfig = autoName

    local profiles = tab:Section({ Name = "Profiles", Icon = "cube", Side = 1 })
    profiles:Label({ Name = "Configs" })

    local selected
    local listbox = profiles:Listbox({
        Height = 177, Empty = "No configs yet", Options = self:ListConfigs(),
        Callback = function(v) selected = v end,
    })
    local nameBox = profiles:Textbox({ Placeholder = "Config name", NoSave = true })
    local configDropdown

    local function refreshLists()
        local list = self:ListConfigs()
        listbox:SetOptions(list)
        configDropdown:SetOptions(list)
    end

    profiles:Button({ Name = "Create", Callback = function()
        local text = nameBox.Instance.Text
        if text == "" then
            self:Notify({ Text = "Enter a config name first." })
            return
        end
        self:SaveConfig(text)
        refreshLists()
        self:Notify(('Created "%s".'):format(text))
    end })

    profiles:Button({ Name = "Load", Callback = function()
        if selected and self:LoadConfig(selected) then
            self:Notify(('Loaded "%s".'):format(selected))
        end
    end })

    profiles:Button({ Name = "Delete", Callback = function()
        if selected then
            self:DeleteConfig(selected)
            self:Notify(('Deleted "%s".'):format(selected))
            selected = nil
            refreshLists()
        end
    end })

    profiles:Button({ Name = "Overwrite", Callback = function()
        if selected then
            self:SaveConfig(selected)
            self:Notify(('Overwrote "%s".'):format(selected))
        end
    end })

    local function saveAutoload()
        writeAutoload(autoOn and autoConfig or nil)
    end

    local autoload = tab:Section({ Name = "Autoload", Icon = "cube", Side = 1 })
    autoload:Toggle({
        Name = "Load on start", Default = autoOn, NoSave = true,
        Callback = function(v) autoOn = v; saveAutoload() end,
    })
    configDropdown = autoload:Dropdown({
        Name = "Config", Options = self:ListConfigs(), Default = autoName, Empty = "No configs yet",
        NoSave = true, Callback = function(v) autoConfig = v; saveAutoload() end,
    })

    local theming = tab:Section({ Name = "Theming", Icon = "cube", Side = 2 })
    theming:Dropdown({
        Name = "Theme", Options = themeOrder, Default = self.ThemeName, MaxRows = 11, NoSave = true,
        Callback = function(v) self:ApplyTheme(v) end,
    })
    theming:Dropdown({
        Name = "Casing", Options = casingOptions, Default = "Normal", NoSave = true,
        Callback = function(v) self:SetCasing(v) end,
    })
    theming:Divider()
    for _, entry in themeColorList do
        local key = entry[2]
        local picker = theming:Colorpicker({
            Name = entry[1], Default = copy[key], NoSave = true,
            Callback = function(c) self:SetThemeColor(key, c) end,
        })
        table.insert(self.ThemeRows, { Key = key, Color = picker })
    end

    local menu = tab:Section({ Name = "Menu", Icon = "cube", Side = 2 })
    local menuKey = menu:Keybind({ Name = "Menu Key", Default = self.MenuKey, NoSave = true })
    function menuKey.OnKeyChanged() self.MenuKey = menuKey.Key end
    menu:Toggle({
        Name = "Watermark", Default = true, NoSave = true,
        Callback = function(v) self.Watermark.Visible = v end,
    })
    menu:Toggle({
        Name = "Hotkey List", Default = true, NoSave = true,
        Callback = function(v) self.Hotkeys.Visible = v end,
    })
    menu:Dropdown({
        Name = "Font", Options = fontOptions, Default = "Inter", NoSave = true,
        Callback = function(v) self:SetFont(v) end,
    })
    menu:Dropdown({
        Name = "Text Weight", Options = weightOptions, Default = defaultWeight.Name, NoSave = true,
        Callback = function(v) self:SetTextWeight(v) end,
    })

    if autoName then
        task.defer(function()
            if self:LoadConfig(autoName) then
                self:Notify(('Autoloaded "%s".'):format(autoName))
            end
        end)
    end
end

------------------------------------------------------------------ overlays
function Window:_buildWatermark(o)
    local lp = Players.LocalPlayer
    local frame = create("Frame", {
        Bg = "Background", Size = fromOffset(298, 28), Radius = metrics.FloatRadius, Border = "Outline", Active = true,
    }, self.Screen)
    makeIcon(frame, "logo", 16, "Accent", "Background", { Position = fromOffset(8, 6) })

    local function text(t, size, weight)
        return label(frame, { Text = t, TextSize = size, Weight = weight, RowH = 28, W = 10 })
    end
    local function separator()
        return create("Frame", { Bg = "Outline", Position = fromOffset(0, 7), Size = fromOffset(1, 14) }, frame)
    end

    local scriptLbl = text(o.Script or "petal.lua", 12, Enum.FontWeight.Medium)
    local sep1 = separator()
    local buildLbl = text(o.Build or "release", 12, Enum.FontWeight.SemiBold)
    local sep2 = separator()
    local userIcon = makeIcon(frame, "user", 13, "Text", "Background")
    local userLbl = text(("%s (@%s)"):format(lp.DisplayName, lp.Name), 11, Enum.FontWeight.SemiBold)

    local function layout()
        local x = 31
        for _, pair in { { scriptLbl, sep1 }, { buildLbl, sep2 } } do
            local w = math.ceil(pair[1].TextBounds.X)
            pair[1].Size = fromOffset(w + 1, 28)
            pair[1].Position = fromOffset(x, pair[1].Position.Y.Offset)
            local sx = x + (w + 8)
            pair[2].Position = fromOffset(sx, 7)
            x = sx + 9
        end
        userIcon.Root.Position = fromOffset(x, 7)
        local ux = x + 20
        local uw = math.ceil(userLbl.TextBounds.X)
        userLbl.Size = fromOffset(uw + 1, 28)
        userLbl.Position = fromOffset(ux, userLbl.Position.Y.Offset)
        frame.Size = fromOffset(ux + uw + metrics.Pad, 28)
        self:_placeOverlays()
    end

    for _, l in { scriptLbl, buildLbl, userLbl } do
        l:GetPropertyChangedSignal("TextBounds"):Connect(layout)
    end

    self.Watermark = frame
    self.WatermarkLayout = layout
    self:_makeDraggable(frame, frame)
end

function Window:_buildHotkeys()
    local holder = create("Frame", { Size = fromOffset(200, 300) }, self.Screen)
    local header = create("Frame", {
        Bg = "Background", Position = fromOffset(1, 1), Size = fromOffset(88, 25),
        Radius = metrics.FloatRadius, Border = "Outline", Active = true,
    }, holder)
    makeIcon(header, "key", 14, "Accent", "Background", { Position = fromOffset(9, 5) })
    local lbl = label(header, { Text = "Hotkeys", TextSize = 12, Weight = Enum.FontWeight.SemiBold, X = 31, RowH = 25 })
    local function fit() header.Size = fromOffset(math.ceil(lbl.TextBounds.X) + 41, 25) end
    lbl:GetPropertyChangedSignal("TextBounds"):Connect(fit)
    fit()
    self.Hotkeys = holder
    self:_makeDraggable(header, holder)
end

function Window:_placeOverlays()
    local screenSize = self.Screen.AbsoluteSize
    if screenSize.X <= 0 then return end
    if not self.Moved[self.Holder] then
        self.Holder.Position = fromOffset(floor2(screenSize.X / 2), floor2(screenSize.Y / 2))
    end
    if self.Watermark and not self.Moved[self.Watermark] then
        self.Watermark.Position = fromOffset(
            floor2((screenSize.X - self.Watermark.Size.X.Offset) / 2), screenSize.Y - 44)
    end
    if self.Hotkeys and not self.Moved[self.Hotkeys] then
        self.Hotkeys.Position = fromOffset(14, floor2((screenSize.Y - 300) / 2))
    end
end

function Window:Destroy()
    for _, c in self.Connections do c:Disconnect() end
    table.clear(frameCallbacks)
    table.clear(hovered)
    for _, a in anims do a.Dead = true end
    table.clear(anims)
    table.clear(animByTarget)
    if loopConnection then
        loopConnection:Disconnect()
        loopConnection = nil
    end
    if activeWindow == self then activeWindow = nil end
    if activeScreen == self.Screen then activeScreen = nil end
    self.Screen:Destroy()
end

------------------------------------------------------------------ constructor
local Library = {
    Themes = themes,
    ThemeOrder = themeOrder,
    Metrics = metrics,
    Fonts = fonts,
}

function Library.new(opts)
    opts = opts or {}
    local genv = typeof(getgenv) == "function" and getgenv() or nil

    if opts.Theme and themes[opts.Theme] then
        for k, v in themes[opts.Theme] do copy[k] = v end
    end
    if opts.Font then fontId = fonts[opts.Font] or opts.Font end

    local minSize = opts.MinSize or new(metrics.MinWindowW, metrics.MinWindowH)
    minSize = new(minSize.X - minSize.X % 2, minSize.Y - minSize.Y % 2)
    local size = opts.Size or new(metrics.WindowW, metrics.WindowH)
    local width = snapEven(size.X, minSize.X, math.huge)
    local height = snapEven(size.Y, minSize.Y, math.huge)

    local window = setmetatable({
        Width = width, Height = height, MinSize = minSize,
        ColumnW = (width - metrics.ContentX - metrics.Pad * 3) / 2,
        ResizeJobs = {}, ResizeHandles = {}, Title = opts.Title or "Petal",
        Tabs = {}, Sections = {}, Columns = {}, Index = {}, Binds = {}, Colors = {}, Flags = {},
        ThemeRows = {}, HotkeyEntries = {}, HotkeyOrder = {}, NotifyStack = {},
        Connections = {}, Jobs = {}, Moved = {}, PendingThemeKeys = {}, FlagOwners = {},
        ThemeClock = 0, SidebarY = metrics.FirstCategory, SidebarHasTabs = false,
        SidebarAfterCategory = false, Visible = true,
        ThemeName = opts.Theme or "Petal",
        MenuKey = opts.MenuKey or Enum.KeyCode.RightShift,
        LastPopupTime = 0, DropdownClosedAt = 0,
    }, Window)

    startLoop()
    activeWindow = window
    if genv then genv.__PetalWindow = window end

    local screen = create("ScreenGui", {
        Name = "Petal", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100,
    })
    parentGui(screen)
    window.Screen = screen
    activeScreen = screen

    local holder = create("Frame", {
        Name = "Window", AnchorPoint = new(0.5, 0.5), Size = fromOffset(window.Width, window.Height), ZIndex = 10,
    }, screen)
    window.Holder = holder
    window.Scale = create("UIScale", { Scale = 0.97 })

    local root = create("Frame", {
        Bg = "Background", Active = true, Size = new2(1, 0, 1, 0), Radius = metrics.WindowRadius, Border = "Outline",
    }, holder)
    makeShadow(root, "Large")
    window.Root = root
    window.Fader = newFader(holder)
    window.ModalButton = create("TextButton", { Modal = true, Size = fromOffset(1, 1) }, holder)

    local sidebar = create("Frame", { Size = new2(0, metrics.SidebarW, 1, 0) }, root)
    window.Sidebar = sidebar
    makeIcon(sidebar, "logo", 20, "Accent", "Background", { Position = fromOffset(metrics.Pad * 2, 15) })
    label(sidebar, {
        Text = window.Title, TextSize = 16, Weight = Enum.FontWeight.Bold, X = 51, Y = 11, RowH = 28, W = 85,
    })

    window.Indicator = create("Frame", {
        Bg = "Inline", Size = fromOffset(metrics.TabW - 2, metrics.TabH - 2),
        Radius = metrics.PillRadius, Border = "Outline", Visible = false,
    }, sidebar)

    local searchBtn = create("TextButton", {
        Position = new2(0, metrics.Pad + 1, 1, -(metrics.Pad + metrics.SearchH) + 1),
        Size = fromOffset(metrics.TabW - 2, metrics.SearchH - 2), Radius = metrics.PillRadius,
        Border = "Outline", BackgroundTransparency = 0,
    }, sidebar)
    hoverColors(searchBtn, "Inline")
    window.SearchButton = searchBtn
    makeIcon(searchBtn, "search", 14, "InactiveText", "Inline", { Position = fromOffset(6, 6) })
    window.SearchLabel = label(searchBtn, {
        Fg = "InactiveText", Text = "Search...", X = 30, RowH = metrics.SearchH - 2, Right = 6,
    })
    searchBtn.MouseButton1Click:Connect(function() window:OpenSearch() end)

    create("Frame", { Bg = "Outline", Position = fromOffset(metrics.SidebarW, 0), Size = new2(0, 1, 1, 0) }, root)

    local content = create("Frame", {
        Bg = "Tab", Position = fromOffset(metrics.ContentX, 0), Size = new2(1, -metrics.ContentX, 1, 0),
        Radius = metrics.WindowRadius,
    }, root)
    create("Frame", { Name = "CornerPatch", Bg = "Tab", Size = new2(0, 12, 1, 0) }, content)

    window.Pages = create("Frame", {
        Name = "Pages", Position = fromOffset(0, metrics.Pad), Size = new2(1, 0, 1, -metrics.Pad * 2),
        ClipsDescendants = true,
    }, content)
    window.Veil = create("Frame", {
        Bg = "Tab", BackgroundTransparency = 1, Size = new2(1, 0, 1, 0), ZIndex = 5,
    }, window.Pages)

    window.DragLayer = create("Frame", { Name = "Drag", Size = new2(1, 0, 1, 0), ZIndex = 30 }, screen)
    window.Popups = create("Frame", { Name = "Popups", Size = new2(1, 0, 1, 0), ZIndex = 40 }, screen)
    window.Dropdowns = create("Frame", { Name = "Dropdowns", Size = new2(1, 0, 1, 0), ZIndex = 45 }, screen)
    window.Notifications = create("Frame", {
        Name = "Notifications", Position = fromOffset(16, 16), Size = fromOffset(400, 600), ZIndex = 50,
    }, screen)

    window:_buildWatermark(opts)
    window:_buildHotkeys()
    window:_buildKeybindMenu()
    window:_buildPicker()
    window:_buildSearch()
    if opts.Resizable ~= false then window:_buildResize() end
    window:_placeOverlays()
    window.WatermarkLayout()

    table.insert(window.Connections, screen:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        window:_placeOverlays()
    end))

    window:_makeDraggable(root, holder, function(pos) return not window:_overControl(pos) end)

    -- input: outside-click close, keybind capture, hotkeys, menu key
    table.insert(window.Connections, UserInputService.InputBegan:Connect(function(input, processed)
        if isPress(input) then
            local pos = mousePos()
            local dd = window.OpenDropdown
            local overPanel = dd and inside(dd.Panel, pos)

            if dd and not overPanel then
                if inside(dd.Input, pos) then
                    window.DropdownClosedBy = dd.Input
                    window.DropdownClosedAt = os.clock()
                end
                dd:Toggle(false)
                return
            end

            if window.ActivePopup and not overPanel and not inside(window.ActivePopup.Frame, pos, 6) then
                window:ClosePopup()
            end
        end

        local listening = window.Listening
        if listening then
            local isKey = input.UserInputType == Enum.UserInputType.Keyboard
            if isKey or input.UserInputType == Enum.UserInputType.MouseButton2
                or input.UserInputType == Enum.UserInputType.MouseButton3 then
                window.Listening = nil
                listening.Listening = false
                if isKey and input.KeyCode == Enum.KeyCode.Escape then
                    listening.Key = nil
                else
                    listening.Key = isKey and input.KeyCode or input.UserInputType
                end
                listening.Refresh()
            elseif isPress(input) then
                window.Listening = nil
                listening.Listening = false
                listening.Refresh()
            end
            return
        end

        if processed then return end

        if input.KeyCode == window.MenuKey then window:Toggle() end

        for _, kb in window.Binds do
            if kb.Key and (kb.Key == input.KeyCode or kb.Key == input.UserInputType) and kb.OnPress then
                kb.OnPress()
            end
        end
    end))

    table.insert(window.Connections, UserInputService.InputEnded:Connect(function(input)
        for _, kb in window.Binds do
            if kb.Key and (kb.Key == input.KeyCode or kb.Key == input.UserInputType) and kb.OnRelease then
                kb.OnRelease()
            end
        end
    end))

    table.insert(window.Connections, UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseWheel or not window.Visible
            or window.Search.Open or not window.CurrentTab then
            return
        end
        local pos = mousePos()
        local dd = window.OpenDropdown
        if dd then
            if inside(dd.Panel, pos) then return end
            dd:Toggle(false)
        end
        for _, col in window.CurrentTab.Columns do
            if inside(col.Scroll, pos) then
                col:ScrollTo(col.Target - input.Position.Z * 60)
            end
        end
    end))

    -- per-frame: theme flush, dropdown follow, scroll fades, search sync, colour animations
    local clock, colorClock = 0, 0
    local function frameJob(dt)
        clock = clock + dt
        colorClock = colorClock + dt
        window:_flushThemeColors(dt)

        if window.OpenDropdown then window.OpenDropdown.Follow() end

        if window.CurrentTab then
            for _, col in window.CurrentTab.Columns do
                local y = col.Scroll.CanvasPosition.Y
                local top = y > 1
                local bottom = y < col.ContentH - col.Scroll.AbsoluteSize.Y - 1
                if top ~= col.ShowTop then
                    col.ShowTop = top
                    animate(col.FadeTop, "BackgroundTransparency", top and 0 or 1, "Fast")
                end
                if bottom ~= col.ShowBottom then
                    col.ShowBottom = bottom
                    animate(col.FadeBottom, "BackgroundTransparency", bottom and 0 or 1, "Fast")
                end
            end
        end

        if window.Search.Dirty then
            window.Search.Dirty = false
            window.Search.Sync()
        end

        if colorClock >= 1 / 30 then
            colorClock = 0
            for _, c in window.Colors do
                if c.Animation == "Rainbow" then
                    local _, s, v = c.Value:ToHSV()
                    c:Set(Color3.fromHSV(clock * 0.25 % 1, math.max(s, 0.5), math.max(v, 0.6)))
                elseif c.Animation == "Pulse" then
                    local h, s = c.Value:ToHSV()
                    c:Set(Color3.fromHSV(h, s, 0.65 + math.sin(clock * 4) * 0.35))
                end
            end
        end
    end
    frameCallbacks[frameJob] = true
    table.insert(window.Jobs, frameJob)

    holder.Visible = false
    window.Visible = false
    window.Watermark.Visible = false
    window.Hotkeys.Visible = false

    task.defer(function()
        if window.Screen.Parent == nil then return end
        window:SetVisible(true)
        window.Watermark.Visible = true
        window.Hotkeys.Visible = true
    end)

    return window
end

return Library
