local Debugger = require("hotswitch-hs/lib/common/Debugger")
local MainController = require("hotswitch-hs/lib/controller/MainController")
local PreferenceModel = require("hotswitch-hs/lib/model/PreferenceModel")

local mainController = MainController.new()

return {
    openOrClose = function() mainController:openOrClose() end,
    switchToNextWindow = function() mainController:switchToNextWindow() end,
    setAutoGeneratedKeys = function(specifiedAutoGeneratedKeys) mainController:setAutoGeneratedKeys(specifiedAutoGeneratedKeys) end,
    enableAllSpaceWindows = function() mainController:enableAllSpaceWindows() end,
    enableAutoUpdate = function() mainController.checkUpdate() end,
    addJapaneseKeyboardLayoutSymbolKeys = function() mainController:addJapaneseKeyboardLayoutSymbolKeys() end,
    setPanelToAlwaysShowOnPrimaryScreen = function() mainController:setPanelToAlwaysShowOnPrimaryScreen() end,
    clearSettings = function() mainController:clearSettings() end,
    clearPreferences = function() PreferenceModel.clearPreferences() end,
    addKeyModifier = function() mainController:addKeyModifier() end,
}
