# What is HotSwitch-HS

![preview](https://user-images.githubusercontent.com/5919569/139619210-b4215c01-a1f8-41db-ad41-34a1882f13bc.png)

HotSwitch-HS is a window switcher using **2 stroke hotkey** for macOS.

It provides fastest window switching, no matter how many windows there are.
HotSwitch-HS uses [Hammerspoon](https://www.hammerspoon.org/), and is rewritten for a substitution of [HotSwitch](https://github.com/oniatsu/HotSwitch).

You can switch any windows by like `command + .` + `a (this key is fixed)`.

HotSwitch-HS's window switching steps is these.

1. Register **a fixed key** to windows on list. (Press `Space`)
2. Switch any windows by using the key you registered.

In addition, HotSwitch-HS provides auto generated keys before your key registration.
However, I highly recommend that you register keys, because it enable you to switch windows faster than ever.

# Usage

HotSwitch-HS's window switching steps is these.

1. Register **a fixed key** to windows on list.
2. Switch any windows by using the key you registered.

## 1. Register **a fixed key** to windows on list.

1. Open HotSwitch-HS panel. (Press `command + .` that you registered)
2. Select a window on lists. (Press `Tab` or cursor keys.)
3. Chanege the panel to registeration mode. (Press `Space`)
4. Register **a fixed key** to the window. (Press any character keys. `a`, `b`, `c`, etc.)

The registered key become a reserversion key, so the key doesn't appear as auto generated keys.

If you want to delete a registered key combined with the window, select the window on lists and press `Delete`.

## 2. Switch any windows by using the key you registered.

1. Open HotSwitch-HS panel. (Press `command + .` that you registered)
2. Switch the target window by using **a fixed key**. (Press the key you registered.)

It looks like that 2 stroke hotkey is working to focus any windows.
The important thing is that **the 2 stroke key bind is fixed anytime**.

That is why window switching by HotSwitch-HS is always fastest.

## Key deletion

# Installation

## 1. Install [Hammerspoon](https://www.hammerspoon.org/)

## 2. Download HotSwitch-HS

In terminal, execute a command. You need to place a directory to `hotswitch-hs`.
```bash
git clone https://github.com/oniatsu/HotSwitch-HS.git ~/.hammerspoon/hotswitch-hs
```

Directory tree is like this:
```
~/.hammerspoon/
▾ hotswitch-hs/
  ▸ modules/
    hotswitch-hs.lua
    README.md
  init.lua
```

## 3. Put a code at your Hammerspoon's `~/.hammerspoon/init.lua`
If the file does not exist, create it and add the codes.

```lua
local hotswitchHs = require("hotswitch-hs/hotswitch-hs")
-- Set any keybinds you like
hs.hotkey.bind({"command"}, ".", function() hotswitchHs.openOrClose() end)
```

For example, you can bind like these.

```lua
-- These are valid.
hs.hotkey.bind({"command"}, ".", function() hotswitchHs.openOrClose() end) -- command + .
hs.hotkey.bind({"command"}, ";", function() hotswitchHs.openOrClose() end) -- command + ;
hs.hotkey.bind({"option"}, "tab", function() hotswitchHs.openOrClose() end) -- option + tab
hs.hotkey.bind({"command", "shift"}, "a", function() hotswitchHs.openOrClose() end) -- command + shift + a

-- These are NOT valid normally. Hammerspoon cannot override the keys, because the keys may be registered and used by macOS.
hs.hotkey.bind({"command"}, "tab", function() hotswitchHs.openOrClose() end) -- command + tab
hs.hotkey.bind({"command"}, "space", function() hotswitchHs.openOrClose() end) -- command + space
```

[Here](https://www.hammerspoon.org/docs/hs.hotkey.html#bind) is how to set `hs.hotkey.bind()`.

## 4. Run Hammerspoon

# Preferences

If you want to set some preferences, you can use some option by adding codes at `~/.hammerspoon/init.lua`.

For example:

```lua
local hotswitchHs = require("hotswitch-hs/hotswitch-hs")
hotswitchHs.setAutoGeneratedKeys({"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"})
hotswitchHs.enableAllSpaceWindows()
hs.hotkey.bind({"command"}, ".", function() hotswitchHs.openOrClose() end)
```

See below to know what these means.

## Auto generated keys

You can define auto generated keys.
The order you specified will be used to generate keys.

```lua
hotswitchHs.setAutoGeneratedKeys({"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"})
```

Default auto generated keys are [these](https://github.com/oniatsu/HotSwitch-HS/blob/main/lib/common/KeyConstants.lua#L10-L12).

## Showing all space windows

If you want to see all space windows on the lists, add this.

```lua
hotswitchHs.enableAllSpaceWindows()
```

Default: the current space windows are only shown.

# If you have some probrems,

Check these.

- If a keybind you set is not enabled, open Hammerspoon console and check some error messages. First, click Hammerspoon's menubar icon. Second, click `Console...`.
- If you want to clear HotSwtich-HS's all settings, execute code `hotswitchHs.clearSettings()` at `~/.hammerspoon/init.lua`.
- Update HotSwtich-HS. `cd ~/.hammerspoon/hotswitch-hs && git pull`

# Update

Execute these command at terminal.
```
cd ~/.hammerspoon/hotswitch-hs
git pull
```

# Development

The class diagram is roughly like this.

![class_diagram](https://raw.githubusercontent.com/oniatsu/HotSwitch-HS/main/uml/class_diagram.png)

## Note

- Pay attention to Lua's garvage collection.
