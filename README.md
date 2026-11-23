# Petal

A spring-animated, themeable Roblox UI library with a **Library Compatibility layer** that lets scripts written for
**Linoria**, **Obsidian**, **Fluent**, **Rayfield** and **Orion** run on Petal without changes.

- Smooth spring animations, drag & drop sections, resizable window, fuzzy search
- 11 built-in themes, live color editing, font / casing / weight options
- Config system with autoload (falls back to memory when the executor has no file functions)
- Hotkey list, watermark, notifications, keybind modes (Toggle / Hold)
- One library, six APIs: use the one you like, or mix them

> **Status:** the Library Compatibility layer is new and has not been tested against every script. Please open an issue with the script name if something breaks.

---

## Files

| File | Purpose | URL |
|---|---|---|
| `Library.lua` | The core UI library (native Petal API) | https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/Library.lua |
| `CompatibleLibrary.lua` | Library Compatibility: Linoria / Obsidian / Fluent / Rayfield / Orion APIs, `HttpGet` redirect, addon shims | https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/CompatibleLibrary.lua |

You only host these two files. Nothing is downloaded from the Linoria / Obsidian / Fluent / Rayfield / Orion repositories.

---

## Installation

### Native Petal only

```lua
local Petal = loadstring(game:HttpGet("https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/Library.lua"))()
```

### Petal + Library Compatibility layer

```lua
-- optional: use a different copy of Library.lua (url or readfile path)
-- getgenv().PetalSource = "https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/Library.lua"
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/CompatibleLibrary.lua"))()
```

By default `CompatibleLibrary.lua` downloads `Library.lua` from this repository
(`https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/Library.lua`).
When it fetches Petal itself it applies a one-line patch (`Section:_extras`) automatically, so you do not need to edit `Library.lua`.

If you load Petal yourself instead, pass it in and add the patch to your copy of `Library.lua` (above `local function registerFlag`):

```lua
function Section:_extras(item, o, name) return attachExtras(self, item, o, name) end
```

```lua
local Petal = loadstring(game:HttpGet("https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/Library.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/CompatibleLibrary.lua"))(Petal)
-- or: getgenv().Petal = Petal  before loading CompatibleLibrary.lua
```

---

## Using existing scripts (drop-in)

**Option 1: replace the library URL** in the script:

```lua
-- before
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
-- after
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/CompatibleLibrary.lua"))()
```

**Option 2: no edits.** Run `CompatibleLibrary.lua` first, then the script. It hooks `game:HttpGet` so the usual library and addon URLs
(Library, ThemeManager, SaveManager, InterfaceManager for Linoria, Obsidian, Fluent, Rayfield, Orion) return Petal instead.

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/CompatibleLibrary.lua"))()
loadstring(game:HttpGet("https://example.com/some-linoria-script.lua"))()
```

- Requires an executor with `hookmetamethod`.
- Disable: `getgenv().PetalCompatRedirect = false`
- Add your own URL patterns (Lua patterns, matched against the lowercased URL):

```lua
getgenv().PetalRedirects = {
    { "my%-linoria%-fork", "Library" },
    { "my%-fork/addons/thememanager", "ThemeManager" },
    { "my%-orion%-fork", "Library" },
}
```

Redirect targets: `Library`, `ThemeManager`, `SaveManager`, `InterfaceManager`.

Limitation: only the colon form `game:HttpGet(url)` is intercepted, not `game.HttpGet(game, url)`.

---

## How the API is chosen

`Library:CreateWindow(info)` detects the style from the arguments:

| Arguments present | Style |
|---|---|
| `Name`, `LoadingTitle`, `ConfigurationSaving`, `KeySystem`, `ToggleUIKeybind` | Rayfield |
| `SubTitle`, `TabWidth`, `Acrylic`, `MinimizeKey` | Fluent |
| `Footer`, `Icon`, `NotifySide`, `ShowCustomCursor`, `MobileButtonsSide`, `EnableSidebarResize` | Obsidian |
| anything else | Linoria |

Orion does not go through `CreateWindow`: it has its own entry point, `Library:MakeWindow(info)`, so it is never mixed up with the others.

`Library.new(opts)` is the native Petal entry point.

---

## Quick start

### Native Petal

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/Library.lua"))()

local Window = Library.new({
    Title = "Hub", Script = "hub.lua", Build = "dev",
    Theme = "Petal", MenuKey = Enum.KeyCode.Insert,
})

Window:Category("Main")
local Tab = Window:Tab({ Name = "Main", Icon = "target" })
local Section = Tab:Section({ Name = "Aimbot", Icon = "cube", Side = 1 })

Section:Toggle({ Name = "Enabled", Default = false, Keybind = Enum.KeyCode.R, Callback = function(v) end })
Section:Slider({ Name = "FOV", Min = 10, Max = 200, Default = 90, Suffix = "°" })
Section:Dropdown({ Name = "Part", Options = { "Head", "Torso" }, Default = "Head" })

Window:Category("Settings")
Window:BuildSettings(Window:Tab({ Name = "Settings", Icon = "gear" }))
```

The compatibility examples below assume:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/CompatibleLibrary.lua"))()
```

### Linoria / Obsidian

```lua
local Window = Library:CreateWindow({ Title = "Hub", AutoShow = true })
local Tab = Window:AddTab("Main")
local Box = Tab:AddLeftGroupbox("Aimbot")

Box:AddToggle("AimEnabled", { Text = "Enabled", Default = false, Callback = function(v) end })
Box:AddSlider("Fov", { Text = "FOV", Default = 90, Min = 10, Max = 200, Rounding = 0 })
Box:AddDropdown("Part", { Values = { "Head", "Torso" }, Default = 1, Text = "Part" })
Box:AddLabel("Aim key"):AddKeyPicker("AimKey", { Default = "E", Mode = "Hold", Text = "Aim key" })
Box:AddLabel("Color"):AddColorPicker("Col", { Default = Color3.new(1, 0, 0) })

Toggles.AimEnabled:OnChanged(function() print(Toggles.AimEnabled.Value) end)
print(Options.AimKey:GetState())

local Menu = Window:AddTab("Settings")
Library.SaveManager:BuildConfigSection(Menu)
Library.ThemeManager:ApplyToTab(Menu)
```

### Fluent

```lua
local Window = Library:CreateWindow({ Title = "Hub", SubTitle = "by me", Theme = "Dark", MinimizeKey = Enum.KeyCode.LeftControl })
local Tab = Window:AddTab({ Title = "Main", Icon = "settings" })

local Section = Tab:AddSection("Combat")
Section:AddToggle("Aim", { Title = "Aimbot", Default = false })
Tab:AddSlider("Fov", { Title = "FOV", Default = 90, Min = 10, Max = 200, Rounding = 0 })
Tab:AddKeybind("AimKey", { Title = "Aim key", Mode = "Hold", Default = "E" })

Library.Options.Aim:OnChanged(function() end)
```

### Rayfield

```lua
local Window = Library:CreateWindow({ Name = "Hub", ToggleUIKeybind = "K" })
local Tab = Window:CreateTab("Main", "settings")

Tab:CreateSection("Combat")
Tab:CreateToggle({ Name = "Aimbot", CurrentValue = false, Flag = "Aim", Callback = function(v) end })
Tab:CreateSlider({ Name = "FOV", Range = { 10, 200 }, Increment = 1, CurrentValue = 90, Flag = "Fov", Callback = function(v) end })
Tab:CreateDropdown({ Name = "Part", Options = { "Head", "Torso" }, CurrentOption = { "Head" }, Callback = function(opts) end })

print(Library.Flags.Aim.CurrentValue)
```

### Orion

```lua
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/CompatibleLibrary.lua"))()

local Window = OrionLib:MakeWindow({ Name = "Hub", SaveConfig = true })
local Tab = Window:MakeTab({ Name = "Main", Icon = "rbxassetid://4483345998" })

local Section = Tab:AddSection({ Name = "Combat" })
Section:AddToggle({ Name = "Aimbot", Default = false, Flag = "Aim", Save = true, Callback = function(v) end })
Section:AddSlider({ Name = "FOV", Min = 10, Max = 200, Default = 90, Increment = 1, ValueName = "°", Flag = "Fov", Save = true, Callback = function(v) end })
Section:AddDropdown({ Name = "Part", Options = { "Head", "Torso" }, Default = "Head", Callback = function(v) end })
Section:AddBind({ Name = "Aim key", Default = Enum.KeyCode.E, Hold = true, Callback = function(held) end })
Section:AddColorpicker({ Name = "Color", Default = Color3.fromRGB(255, 0, 0), Callback = function(c) end })
Section:AddTextbox({ Name = "Target", Default = "", TextDisappear = false, Callback = function(text) end })
Section:AddButton({ Name = "Reset", Callback = function() end })

OrionLib:MakeNotification({ Name = "Loaded", Content = "Hub is ready", Time = 5 })
OrionLib:Init()

print(OrionLib.Flags.Aim.Value)
```

### Mixing APIs

Every API returns real Petal objects (Window / Tab / Section) with extra methods added, so you can mix freely:

```lua
local Tab = Window:AddTab("Main")                        -- Linoria
local Sec = Tab:Section({ Name = "Native", Side = 2 })   -- Petal
Sec:Toggle({ Name = "Petal toggle" })                    -- Petal
Sec:AddButton("Linoria button", function() end)          -- Linoria
Window:Notify({ Text = "Hello" })                        -- Petal
```

---

## Supported Library Compatibility features

| Feature | Linoria | Obsidian | Fluent | Rayfield | Orion |
|---|:-:|:-:|:-:|:-:|:-:|
| Windows / tabs | ✅ | ✅ | ✅ | ✅ | ✅ |
| Groupboxes / sections | ✅ | ✅ | ✅ | ✅ | ✅ |
| Tabbox | ⚠️ separate sections | ⚠️ separate sections | n/a | n/a | n/a |
| Toggle / Slider / Dropdown / Input / Button / Label | ✅ | ✅ | ✅ | ✅ | ✅ |
| Paragraph | n/a | n/a | n/a | n/a | ⚠️ wrapped labels |
| Color picker (with transparency) | ✅ | ✅ | ✅ | ✅ | ✅ (no transparency) |
| Key picker (Toggle / Hold / Always / Press) | ✅ | ✅ | ✅ | ✅ | ✅ (Toggle / Hold) |
| `SyncToggleState` | ✅ | ✅ | n/a | n/a | n/a |
| Dependency boxes | ✅ | ✅ | n/a | n/a | n/a |
| `Toggles` / `Options` / `OnChanged` | ✅ | ✅ | ✅ | n/a | n/a |
| `Flags` with `.CurrentValue` etc. | n/a | n/a | n/a | ✅ | n/a |
| `OrionLib.Flags[flag].Value` | n/a | n/a | n/a | n/a | ✅ |
| Notifications (string or table) | ✅ | ✅ | ✅ | ✅ | ✅ |
| ThemeManager / SaveManager / InterfaceManager | ✅ | ✅ | ✅ | n/a | n/a |
| Config page (`SaveConfig = true` + `Init()`) | n/a | n/a | n/a | n/a | ✅ |
| `Library.ToggleKeybind` | ✅ | ✅ | n/a | n/a | n/a |
| `SetVisible` on elements | n/a | ✅ | n/a | n/a | n/a |

### Known differences

- Tabbox sub-tabs become separate sections (Petal has no tabs inside a section).
- `button:AddButton(...)` adds another full-width button instead of a side-by-side one.
- Ignored or no-op: tooltips, `Library:SetWatermark(text)`, disabled state, label wrapping, `Slider:SetMin/SetMax`, `AllowNull`.
- Rayfield slider `Increment` only sets the number of decimals.
- `Fluent:Dialog` only shows a notification and does not run the dialog's buttons.
- `ThemeManager` and `SaveManager` map to Petal's built-in `BuildSettings` page (configs, autoload, theming, menu options). The config folder is `Petal/`.
- Long window titles are truncated in the sidebar.

**Orion**

- Elements added straight on a tab go into a default section named after the tab. Sections are placed in whichever column has fewer sections.
- Slider `Increment` only sets the number of decimals, `ValueName` becomes the suffix, and `Color` options are ignored.
- Like Orion, callbacks fire once with the default value right after an element is created (toggle, slider, dropdown, color picker).
- `AddParagraph` becomes word-wrapped labels (no `:Set` on paragraphs).
- Only elements with `Save = true` and a `Flag` are written to configs. `OrionLib:Init()` adds Petal's settings page when the window was created with `SaveConfig = true`.
- `MakeNotification` joins `Name` and `Content` into one line and ignores `Image`.
- Window options such as `HidePremium`, `IntroEnabled`, `IntroText`, `ShowIcon`, `CloseCallback` and tab `PremiumOnly` are ignored.

---

## Native API reference

### Library

| Call | Description |
|---|---|
| `Library.new(opts)` | Create a window. Options: `Title`, `Script`, `Build`, `Theme`, `Font`, `MenuKey`, `Size` (Vector2), `MinSize`, `Resizable` |
| `Library:CreateWindow(info)` | Library Compatibility entry point (auto-detects Linoria / Obsidian / Fluent / Rayfield) |
| `Library:MakeWindow(info)` | Library Compatibility entry point for Orion |
| `Library.Themes`, `Library.ThemeOrder`, `Library.Metrics`, `Library.Fonts` | Data tables |

### Window

`Category(text)`, `Tab({ Name, Icon })`, `SelectTab(tab)`, `Notify(text | { Text, Icon, Duration })`, `Toggle()`, `SetVisible(bool)`,
`SetSize(w, h)`, `ApplyTheme(name)`, `SetCasing(mode)`, `SetFont(name)`, `SetTextWeight(name)`, `BuildSettings(tab)`,
`SaveConfig(name)`, `LoadConfig(name)`, `DeleteConfig(name)`, `ListConfigs()`, `Destroy()`

### Tab

`Section({ Name, Icon, Side = 1 | 2, Description })`

### Section elements

| Method | Main options |
|---|---|
| `Toggle` | `Name`, `Default`, `Keybind`, `KeybindMode`, `Color`, `Callback` |
| `Slider` | `Name`, `Min`, `Max`, `Default`, `Decimals`, `Suffix`, `Callback` |
| `RangeSlider` | `Name`, `Min`, `Max`, `Default = { lo, hi }`, `Decimals`, `Suffix`, `Callback` |
| `Dropdown` | `Name`, `Options`, `Default`, `Multi`, `MaxRows`, `Callback` |
| `Button` | `Name`, `Callback` |
| `Textbox` | `Name`, `Placeholder`, `Default`, `Callback` |
| `Listbox` | `Name`, `Options`, `Height`, `Callback` |
| `Label` | `Name`, `Keybind`, `Color` |
| `Keybind` | `Name`, `Default`, `Mode`, `Callback` |
| `Colorpicker` | `Name`, `Default`, `Alpha`, `Callback` |
| `Divider` | none |

Common options: `Flag` (config key), `NoSave = true` (exclude from configs).

Icons: `target`, `bullet`, `smile`, `globe`, `bomb`, `file`, `gear`, `robot`, `wrench`, `cube`, `search`, `user`, `key`, `check`, `layout`, `reset`,
or any `rbxasset...` image id.

Themes: `Petal`, `Afterglow`, `Frostbite`, `Volt`, `Obsidian`, `Sakura Drift`, `Neon Mirage`, `Copper Dust`, `Abyss`, `Porcelain`, `Graphite`.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Library fails to download | Set `getgenv().PetalSource` to a working URL or file path (default: `https://raw.githubusercontent.com/indirectflower/PetalLibrary/refs/heads/main/Library.lua`) before loading `CompatibleLibrary.lua`, or pass Petal in |
| `Petal needs the Section:_extras patch` | You passed your own Petal copy: add the one-line patch shown above (not needed when `CompatibleLibrary.lua` downloads Petal itself) |
| Script still opens its original UI | Run `CompatibleLibrary.lua` first, or check your executor supports `hookmetamethod` |
| Config not saving | Executor lacks `writefile`; configs are kept in memory for the session. For Orion, also check the element has `Save = true` and a `Flag` |
| Unknown script URL not redirected | Add it to `getgenv().PetalRedirects` |

---

## Credits

Petal UI library and the Library Compatibility layer. Linoria, Obsidian, Fluent, Rayfield and Orion are the property of their respective authors;
this project only mirrors their public API shape and does not include their code.
