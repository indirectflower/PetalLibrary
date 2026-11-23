local genv = typeof(getgenv) == "function" and getgenv() or _G

------------------------------------------------------------------ load Petal (auto-patched)
local PETAL_URL = "https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/Library.lua"
local EXTRAS_PATCH = "function Section:_extras(item, o, name) return attachExtras(self, item, o, name) end"

local function loadPetal()
    local source = genv.PetalSource or PETAL_URL
    local src
    if string.match(source, "^https?://") then
        src = game:HttpGet(source)
    else
        src = readfile(source)
    end
    -- Library.lua has no Section:_extras yet: inject it right above registerFlag
    if not string.find(src, "function Section:_extras", 1, true) then
        local patched, count = string.gsub(src, "local function registerFlag", function()
            return EXTRAS_PATCH .. "\n\nlocal function registerFlag"
        end, 1)
        assert(count > 0, "PetalLinoria: could not apply the Section:_extras patch to Library.lua")
        src = patched
    end
    return loadstring(src)()
end

local Petal = ... or genv.Petal or loadPetal()
assert(Petal and Petal.new, "PetalLinoria: failed to load the Petal library")

local Players = game:GetService("Players")

------------------------------------------------------------------ core tables
local Library = {
    Toggles = {}, Options = {}, Signals = {}, UnloadCallbacks = {}, Flags = {},
    Unloaded = false, Version = "Petal-Linoria",
}
local Toggles, Options = Library.Toggles, Library.Options
genv.Toggles, genv.Options = Toggles, Options

local Window, Tab, Groupbox, Tabbox = {}, {}, {}, {}
Window.__index = Window
Tab.__index = Tab
Groupbox.__index = Groupbox
Tabbox.__index = Tabbox

------------------------------------------------------------------ helpers
local function safe(f, ...)
    if type(f) ~= "function" then return end
    local ok, err = pcall(f, ...)
    if not ok then warn("[PetalLinoria] callback error: " .. tostring(err)) end
end

function Library:SafeCallback(f, ...) safe(f, ...) end

-- standard Changed/Callback plumbing: obj.Callback fans out to user callback + OnChanged listeners
local function hook(obj, userCb)
    obj._changed = {}
    obj.Callback = function(...)
        safe(userCb, ...)
        for _, f in obj._changed do safe(f, ...) end
    end
    function obj:OnChanged(f)
        table.insert(self._changed, f)
        safe(f, self.Value)
    end
end

local keyAlias = { MouseButton1 = "MB1", MouseButton2 = "MB2", MouseButton3 = "MB3" }
local aliasKey = { MB1 = "MouseButton1", MB2 = "MouseButton2", MB3 = "MouseButton3" }

local function keyToString(k)
    if not k then return "None" end
    return keyAlias[k.Name] or k.Name
end

local function parseKey(s)
    if s == nil or s == "None" or s == "" then return nil end
    if typeof(s) == "EnumItem" then return s end
    if aliasKey[s] then return Enum.UserInputType[aliasKey[s]] end
    local ok, key = pcall(function() return Enum.KeyCode[s] end)
    return ok and key or nil
end

-- groupbox methods record the items they create so dependency boxes can hide them
local function track(self, before)
    local items = self.Section.Items
    local b = self
    while b do
        if b.Tracker then
            for i = before + 1, #items do table.insert(b.Tracker, items[i]) end
        end
        b = b.Parent
    end
end

local function adding(fn)
    return function(self, ...)
        local before = #self.Section.Items
        local r = fn(self, ...)
        track(self, before)
        return r
    end
end

------------------------------------------------------------------ colour picker / key picker (chained off labels & toggles)
local function addColorPicker(self, idx, info)
    info = info or {}
    local sec = self.Section
    assert(sec._extras, "PetalLinoria: add `function Section:_extras(item, o, name) return attachExtras(self, item, o, name) end` to Petal")
    local _, c = sec:_extras(self.Item, {
        Color = info.Default or Color3.new(1, 1, 1), ColorAlpha = info.Transparency,
    }, info.Title or idx)

    c.Type, c.Idx, c.Flag = "ColorPicker", idx, idx
    c.Transparency = info.Transparency or 0
    c._changed = {}
    c.Callback = function(col, a)
        c.Transparency = a
        safe(info.Callback, col)
        for _, f in c._changed do safe(f, col) end
    end
    function c:OnChanged(f) table.insert(self._changed, f); safe(f, self.Value) end
    function c:SetValueRGB(col, transparency) self:Set(col, transparency) end
    function c:SetValue(hsv, transparency)
        self:Set(Color3.fromHSV(hsv[1], hsv[2], hsv[3]), transparency)
    end

    self.Window.Flags[idx] = c
    Options[idx] = c
    return self
end

local function addKeyPicker(self, idx, info)
    info = info or {}
    local window, sec = self.Window, self.Section
    assert(sec._extras, "PetalLinoria: add `function Section:_extras(item, o, name) return attachExtras(self, item, o, name) end` to Petal")
    local toggle = self.Type == "Toggle" and self or nil
    local sync = toggle ~= nil and info.SyncToggleState == true
    local text = info.Text or idx

    local kb = sec:_extras(self.Item, {
        Keybind = Enum.KeyCode.Unknown, KeybindMode = info.Mode or "Toggle", KeybindName = text,
    }, text)

    kb.Type, kb.Idx, kb.Name = "KeyPicker", idx, text
    kb.State, kb.Value, kb.NoUI = false, "None", info.NoUI == true
    kb.Mode = info.Mode or "Toggle"
    kb._changed, kb._click = {}, {}

    local function active()
        if kb.NoUI then return false end
        if sync then return toggle.Value end
        return kb.State
    end
    local function hotkey() window:SetHotkeyActive(kb, active()) end

    local function setState(s)
        if kb.State == s then return end
        kb.State = s
        hotkey()
        safe(info.Callback, s)
        for _, f in kb._click do safe(f, s) end
    end

    function kb:GetState()
        if sync then return toggle.Value end
        if self.Mode == "Always" then return true end
        return self.State
    end

    kb.OnKeyChanged = function()
        local new = keyToString(kb.Key)
        local changed = new ~= kb.Value
        kb.Value = new
        hotkey()
        if changed then
            safe(info.ChangedCallback, kb.Key)
            for _, f in kb._changed do safe(f, kb.Key) end
        end
    end

    kb.OnPress = function()
        if kb.Mode == "Always" then return end
        if sync then
            toggle:Set(kb.Mode == "Hold" and true or not toggle.Value)
        else
            setState(kb.Mode == "Hold" and true or not kb.State)
        end
    end
    kb.OnRelease = function()
        if kb.Mode ~= "Hold" then return end
        if sync then toggle:Set(false) else setState(false) end
    end

    function kb:OnClick(f) table.insert(self._click, f) end
    function kb:OnChanged(f) table.insert(self._changed, f) end
    function kb:SetValue(d)
        if d[2] then self.Mode = d[2] end
        self:Set(parseKey(d[1]))
    end

    if sync then
        if not kb.NoUI then toggle.Keybind = kb end
        table.insert(toggle._changed, function(v) safe(info.Callback, v) end)
    end

    kb:Set(parseKey(info.Default))
    window.Flags[idx] = kb
    Options[idx] = kb
    return self
end

------------------------------------------------------------------ Groupbox
Groupbox.AddToggle = adding(function(self, idx, info)
    info = info or {}
    local t = self.Section:Toggle({ Name = info.Text or idx, Default = info.Default, Flag = idx })
    t.Section, t.Window, t.Idx, t.Type = self.Section, self.Window, idx, "Toggle"
    hook(t, info.Callback)
    function t:SetValue(v) self:Set(v) end
    function t:SetText(s) if self.Item.Label then self.Item.Label.Text = s end end
    t.AddColorPicker, t.AddKeyPicker = addColorPicker, addKeyPicker
    Toggles[idx] = t
    return t
end)

Groupbox.AddLabel = adding(function(self, text)
    local l = self.Section:Label({ Name = tostring(text or "") })
    l.Section, l.Window, l.Type = self.Section, self.Window, "Label"
    function l:SetText(s) self:Set(s) end
    l.AddColorPicker, l.AddKeyPicker = addColorPicker, addKeyPicker
    return l
end)

Groupbox.AddButton = adding(function(gb, a, b)
    local info = type(a) == "table" and a or { Text = a, Func = b }
    local btn
    local last = 0
    local function run()
        if info.DoubleClick then
            if os.clock() - last > 0.6 then
                last = os.clock()
                gb.Window:Notify({ Text = "Click again to confirm: " .. tostring(info.Text), Duration = 1.5 })
                return
            end
            last = 0
        end
        safe(btn.Func)
    end
    btn = gb.Section:Button({ Name = tostring(info.Text), Callback = run })
    btn.Func = info.Func
    function btn:AddButton(a2, b2) return Groupbox.AddButton(gb, a2, b2) end
    return btn
end)

Groupbox.AddDivider = adding(function(self)
    return self.Section:Divider()
end)

Groupbox.AddBlank = adding(function(self, size)
    return self.Section:_item(size or 8, "Blank", nil, false)
end)

Groupbox.AddSlider = adding(function(self, idx, info)
    info = info or {}
    local s = self.Section:Slider({
        Name = info.Text or idx, Min = info.Min, Max = info.Max, Default = info.Default,
        Decimals = info.Rounding, Suffix = info.Suffix, Flag = idx,
    })
    s.Section, s.Window, s.Idx, s.Type = self.Section, self.Window, idx, "Slider"
    s.Min, s.Max = info.Min or 0, info.Max or 100
    hook(s, info.Callback)
    function s:SetValue(v) self:Set(v) end
    Options[idx] = s
    return s
end)

Groupbox.AddInput = adding(function(self, idx, info)
    info = info or {}
    local t = self.Section:Textbox({
        Name = info.Text or idx, Placeholder = info.Placeholder or info.Text or idx,
        Default = info.Default, Flag = idx,
    })
    t.Section, t.Window, t.Idx, t.Type = self.Section, self.Window, idx, "Input"
    t._changed = {}
    local function fireAll(text)
        safe(info.Callback, text)
        for _, f in t._changed do safe(f, text) end
    end
    t.Callback = function(text) if info.Finished then fireAll(text) end end

    local inst = t.Instance
    inst:GetPropertyChangedSignal("Text"):Connect(function()
        if info.Numeric then
            local clean = (inst.Text:gsub("[^%d%.%-]", ""))
            if clean ~= inst.Text then inst.Text = clean return end
        end
        t.Value = inst.Text
        if not info.Finished then fireAll(inst.Text) end
    end)

    function t:SetValue(text) self:Set(text) end
    function t:OnChanged(f) table.insert(self._changed, f); safe(f, self.Value) end
    Options[idx] = t
    return t
end)

local function specialValues(kind, exclude)
    local out = {}
    if kind == "Player" then
        for _, p in Players:GetPlayers() do
            if not (exclude and p == Players.LocalPlayer) then table.insert(out, p.Name) end
        end
    elseif kind == "Team" then
        for _, t in game:GetService("Teams"):GetTeams() do table.insert(out, t.Name) end
    end
    table.sort(out)
    return out
end

local function resolveDefault(values, def, multi)
    if multi then
        local list = {}
        if type(def) == "table" then
            for k, v in def do
                if type(k) == "number" then
                    table.insert(list, type(v) == "number" and values[v] or v)
                elseif v then
                    table.insert(list, k)
                end
            end
        end
        return list
    end
    if type(def) == "number" then return values[def] end
    return def
end

Groupbox.AddDropdown = adding(function(self, idx, info)
    info = info or {}
    local special = info.SpecialType
    local values = info.Values or {}
    if special == "Player" or special == "Team" then
        values = specialValues(special, info.ExcludeLocalPlayer)
    end

    local d = self.Section:Dropdown({
        Name = info.Text or idx, Options = values, Multi = info.Multi,
        Default = resolveDefault(values, info.Default, info.Multi), Flag = idx,
        MaxRows = math.min(10, math.max(3, #values)),
    })
    d.Section, d.Window, d.Idx, d.Type = self.Section, self.Window, idx, "Dropdown"
    d.Values = values
    hook(d, info.Callback)

    function d:SetValue(v)
        if self.Multi then
            local list = {}
            if type(v) == "table" then
                for k, x in v do
                    if type(k) == "number" then table.insert(list, x)
                    elseif x then table.insert(list, k) end
                end
            end
            self:Set(list)
        else
            self:Set(v)
        end
    end
    function d:SetValues(list)
        self.Values = list
        self:SetOptions(list)
    end

    if special == "Player" then
        local function refresh() d:SetValues(specialValues("Player", info.ExcludeLocalPlayer)) end
        Library:GiveSignal(Players.PlayerAdded:Connect(refresh))
        Library:GiveSignal(Players.PlayerRemoving:Connect(function() task.defer(refresh) end))
    end

    Options[idx] = d
    return d
end)

function Groupbox:AddDependencyBox()
    local box = setmetatable({
        Section = self.Section, Window = self.Window, Tracker = {}, Parent = self,
    }, Groupbox)

    function box:SetupDependencies(deps)
        local function update()
            local ok = true
            for _, d in deps do
                if d[1].Value ~= d[2] then ok = false break end
            end
            for _, item in self.Tracker do
                item.Visible = ok
                item.Frame.Visible = ok
            end
            self.Section:Layout(true)
        end
        for _, d in deps do
            if d[1]._changed then table.insert(d[1]._changed, update) end
        end
        update()
    end
    return box
end

------------------------------------------------------------------ Tab / Tabbox
function Tab:_group(name, side, icon)
    local sec = self.Petal:Section({ Name = name, Icon = icon or "cube", Side = side })
    return setmetatable({ Section = sec, Window = self.Window }, Groupbox)
end

function Tab:AddLeftGroupbox(name, icon) return self:_group(name, 1, icon) end
function Tab:AddRightGroupbox(name, icon) return self:_group(name, 2, icon) end
function Tab:AddLeftTabbox() return setmetatable({ Tab = self, Side = 1 }, Tabbox) end
function Tab:AddRightTabbox() return setmetatable({ Tab = self, Side = 2 }, Tabbox) end

function Tabbox:AddTab(name, icon) return self.Tab:_group(name, self.Side, icon) end

------------------------------------------------------------------ Window
function Window:AddTab(name, icon)
    local pt = self.Petal:Tab({ Name = name, Icon = icon or "cube" })
    return setmetatable({ Petal = pt, Window = self.Petal }, Tab)
end

function Window:AddCategory(text) self.Petal:Category(text) end
function Window:SetWindowTitle() end -- Petal title is fixed at creation
function Window:Toggle() self.Petal:Toggle() end

------------------------------------------------------------------ Library
function Library:CreateWindow(info)
    info = type(info) == "string" and { Title = info } or info or {}
    local pw = Petal.new({
        Title = info.Title or "Window", Script = info.Script or info.Title, Build = info.Build or "linoria",
        Theme = info.Theme or "Petal", MenuKey = info.MenuKey or Enum.KeyCode.RightShift,
        Size = info.Size, Resizable = info.Resizable,
    })
    self._pw = pw
    self.ScreenGui = pw.Screen
    self.KeybindFrame = pw.Hotkeys

    if info.AutoShow == false then
        task.defer(function() pw:SetVisible(false) end)
    end
    return setmetatable({ Petal = pw }, Window)
end

function Library:Notify(text, time)
    if self._pw then self._pw:Notify({ Text = tostring(text), Duration = time }) end
end

function Library:SetWatermark() end -- Petal watermark content is fixed (script / build / user)
function Library:SetWatermarkVisibility(v)
    if self._pw then self._pw.Watermark.Visible = v end
end

function Library:Toggle()
    if self._pw then self._pw:Toggle() end
end

function Library:GiveSignal(signal)
    table.insert(self.Signals, signal)
    return signal
end

function Library:OnUnload(f) table.insert(self.UnloadCallbacks, f) end

function Library:Unload()
    if self.Unloaded then return end
    self.Unloaded = true
    for _, s in self.Signals do pcall(function() s:Disconnect() end) end
    for _, f in self.UnloadCallbacks do safe(f) end
    if self._pw then self._pw:Destroy() end
    table.clear(Toggles)
    table.clear(Options)
end

-- Library.ToggleKeybind = Options.MenuKeybind  ->  drives Petal's menu key
setmetatable(Library, {
    __newindex = function(t, k, v)
        rawset(t, k, v)
        if k == "ToggleKeybind" and v and t._pw then
            local pw = t._pw
            pw.MenuKey = v.Key
            local prev = v.OnKeyChanged
            v.OnKeyChanged = function()
                if prev then prev() end
                pw.MenuKey = v.Key
            end
        end
    end,
})

------------------------------------------------------------------ ThemeManager / SaveManager shims
local settingsBuilt = false
local SaveManager = { Ignore = {}, Library = Library }
local ThemeManager = { Library = Library }

local function buildSettings(tab)
    if settingsBuilt then return end
    settingsBuilt = true
    local pw = Library._pw
    pw:BuildSettings(tab.Petal)
    for _, idx in SaveManager.Ignore do
        pw.Flags[idx] = nil
        pw.Flags[idx .. "/Key"] = nil
        pw.Flags[idx .. "/Color"] = nil
    end
end

function SaveManager:SetLibrary(lib) self.Library = lib end
function SaveManager:SetFolder() end
function SaveManager:IgnoreThemeSettings() end
function SaveManager:SetIgnoreIndexes(list)
    for _, idx in list do table.insert(self.Ignore, idx) end
end
function SaveManager:BuildConfigSection(tab) buildSettings(tab) end
function SaveManager:LoadAutoloadConfig() end -- handled by Petal's BuildSettings

function ThemeManager:SetLibrary(lib) self.Library = lib end
function ThemeManager:SetFolder() end
function ThemeManager:SetDefaultTheme() end
function ThemeManager:ApplyTheme(name) if Library._pw then Library._pw:ApplyTheme(name, true) end end
function ThemeManager:ApplyToTab(tab) buildSettings(tab) end
function ThemeManager:ApplyToGroupbox(gb)
    gb:AddDropdown("ThemeManager_Theme", {
        Text = "Theme", Values = Petal.ThemeOrder, Default = Library._pw.ThemeName,
        Callback = function(v) ThemeManager:ApplyTheme(v) end,
    })
end
function ThemeManager:LoadDefault() end

------------------------------------------------------------------ Orion adapter
-- OrionLib:MakeWindow / Window:MakeTab / Tab:AddSection / Section:AddToggle ... / OrionLib.Flags / OrionLib:Init
local OrionContainer, OrionWindow = {}, {}
OrionContainer.__index = OrionContainer
OrionWindow.__index = OrionWindow

local function decimalsOf(inc)
    local s = (string.format("%.6f", inc or 1):gsub("0+$", ""))
    return #(string.match(s, "%.(%d*)$") or "")
end

local function regFlag(o, obj)
    if o.Flag then Library.Flags[o.Flag] = obj end
end

-- only elements with Save = true and a Flag take part in Petal configs
local function saveOpts(o, t)
    if o.Save and o.Flag then t.Flag = o.Flag else t.NoSave = true end
    return t
end

-- Orion fires the callback once with the default value after creating an element
local function initFire(cb, v)
    if cb and v ~= nil then task.defer(safe, cb, v) end
end

local function pickSide(counts)
    local side = counts[1] <= counts[2] and 1 or 2
    counts[side] = counts[side] + 1
    return side
end

-- elements added straight on a tab live in a default section named after the tab
function OrionContainer:_sec()
    if not self.Section then
        self.Section = self.Tab:Section({
            Name = self.DefaultName or "Main", Icon = "cube", Side = pickSide(self.Counts),
        })
    end
    return self.Section
end

function OrionContainer:AddSection(o)
    o = type(o) == "string" and { Name = o } or o or {}
    local sec = self.Tab:Section({ Name = o.Name or "Section", Icon = "cube", Side = pickSide(self.Counts) })
    return setmetatable({ Tab = self.Tab, Counts = self.Counts, Section = sec, Window = self.Window }, OrionContainer)
end

function OrionContainer:AddLabel(text)
    local l = self:_sec():Label({ Name = tostring(text or "") })
    return l
end

function OrionContainer:AddParagraph(title, content)
    local sec = self:_sec()
    local head = sec:Label({ Name = tostring(title or "") })
    local line = ""
    local function flush()
        if line ~= "" then sec:Label({ Name = line }) end
        line = ""
    end
    for word in string.gmatch(tostring(content or ""), "%S+") do
        if #line + #word + 1 > 34 then
            flush()
            line = word
        else
            line = line == "" and word or (line .. " " .. word)
        end
    end
    flush()
    return head
end

function OrionContainer:AddButton(o)
    o = o or {}
    local btn = self:_sec():Button({ Name = o.Name or "Button", Callback = function() safe(o.Callback) end })
    function btn:Set(text)
        local l = self.Instance:FindFirstChildWhichIsA("TextLabel", true)
        if l then l.Text = tostring(text) end
    end
    return btn
end

function OrionContainer:AddToggle(o)
    o = o or {}
    local t = self:_sec():Toggle(saveOpts(o, {
        Name = o.Name or "Toggle", Default = o.Default == true,
        Callback = function(v) safe(o.Callback, v) end,
    }))
    regFlag(o, t)
    initFire(o.Callback, o.Default == true)
    return t
end

function OrionContainer:AddSlider(o)
    o = o or {}
    local s = self:_sec():Slider(saveOpts(o, {
        Name = o.Name or "Slider", Min = o.Min or 0, Max = o.Max or 100, Default = o.Default,
        Decimals = decimalsOf(o.Increment), Suffix = o.ValueName and (" " .. o.ValueName) or nil,
        Callback = function(v) safe(o.Callback, v) end,
    }))
    regFlag(o, s)
    initFire(o.Callback, s.Value)
    return s
end

function OrionContainer:AddDropdown(o)
    o = o or {}
    local options = o.Options or {}
    local d = self:_sec():Dropdown(saveOpts(o, {
        Name = o.Name or "Dropdown", Options = options, Default = o.Default,
        MaxRows = math.min(10, math.max(3, #options)),
        Callback = function(v) safe(o.Callback, v) end,
    }))
    function d:Refresh(list)
        list = list or {}
        self:SetOptions(list)
        if self.Value ~= nil and not table.find(list, self.Value) then self:Set(nil, true) end
    end
    regFlag(o, d)
    if o.Default ~= nil and table.find(options, o.Default) then initFire(o.Callback, o.Default) end
    return d
end

function OrionContainer:AddTextbox(o)
    o = o or {}
    local box
    box = self:_sec():Textbox(saveOpts(o, {
        Name = o.Name or "Textbox", Placeholder = o.Name, Default = o.Default or "",
        Callback = function(text)
            safe(o.Callback, text)
            if o.TextDisappear and box then box:Set("", true) end
        end,
    }))
    regFlag(o, box)
    return box
end

function OrionContainer:AddColorpicker(o)
    o = o or {}
    local c = self:_sec():Colorpicker(saveOpts(o, {
        Name = o.Name or "Colorpicker", Default = o.Default or Color3.new(1, 1, 1),
        Callback = function(col) safe(o.Callback, col) end,
    }))
    regFlag(o, c)
    initFire(o.Callback, c.Value)
    return c
end

function OrionContainer:AddBind(o)
    o = o or {}
    local kb = self:_sec():Keybind(saveOpts(o, {
        Name = o.Name or "Bind", Default = parseKey(o.Default), Mode = o.Hold and "Hold" or "Toggle",
    }))
    -- Orion: Bind.Value is the key name; Callback() on press, Callback(held) when Hold = true
    kb.Value = kb.Key and kb.Key.Name or "Unknown"
    kb.OnKeyChanged = function() kb.Value = kb.Key and kb.Key.Name or "Unknown" end
    kb.OnPress = function()
        if o.Hold then safe(o.Callback, true) else safe(o.Callback) end
    end
    kb.OnRelease = function()
        if o.Hold then safe(o.Callback, false) end
    end
    regFlag(o, kb)
    return kb
end

function OrionWindow:MakeTab(o)
    o = type(o) == "string" and { Name = o } or o or {}
    local pt = self.Petal:Tab({ Name = o.Name or "Tab", Icon = o.Icon or "cube" })
    return setmetatable({
        Tab = pt, Counts = { 0, 0 }, DefaultName = o.Name, Window = self.Petal,
    }, OrionContainer)
end

function Library:MakeWindow(info)
    info = type(info) == "string" and { Name = info } or info or {}
    local pw = Petal.new({
        Title = info.Name or "Orion", Script = info.Name, Build = "orion",
        Theme = "Petal", MenuKey = Enum.KeyCode.RightShift,
    })
    self._pw = pw
    self._orionSave = info.SaveConfig == true
    self.ScreenGui = pw.Screen
    self.KeybindFrame = pw.Hotkeys
    return setmetatable({ Petal = pw }, OrionWindow)
end

function Library:MakeNotification(o)
    o = o or {}
    local name = tostring(o.Name or "")
    local text = (o.Content and o.Content ~= "") and (name .. ": " .. tostring(o.Content)) or name
    if self._pw then self._pw:Notify({ Text = text, Duration = o.Time }) end
end

-- with SaveConfig = true, Init() adds Petal's settings page (configs, autoload, theming, menu options)
function Library:Init()
    if self._orionSave and self._pw and not settingsBuilt then
        settingsBuilt = true
        self._pw:Category("Settings")
        self._pw:BuildSettings(self._pw:Tab({ Name = "Settings", Icon = "gear" }))
    end
end

function Library:IsRunning()
    return self._pw ~= nil and not self.Unloaded
end

function Library:Destroy() self:Unload() end

genv.Library = Library
return Library, ThemeManager, SaveManager
