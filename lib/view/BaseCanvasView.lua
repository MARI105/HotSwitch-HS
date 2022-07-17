local canvas = require("hs.canvas")

local Debugger = require("hotswitch-hs/lib/common/Debugger")
local TimeChecker = require("hotswitch-hs/lib/common/TimeChecker")
local View = require("hotswitch-hs/lib/view/View")
local CanvasConstants = require("hotswitch-hs/lib/common/CanvasConstants")
local FrameCulculator = require("hotswitch-hs/lib/common/FrameCulculator")

local BaseCanvasView = {}
BaseCanvasView.new = function(windowModel, settingModel, keyStatusModel)
    local obj = View.new()

    obj.windowModel = windowModel
    obj.settingModel = settingModel
    obj.keyStatusModel = keyStatusModel

    obj.clickCallback = nil

    obj.show = function(self)
        -- local t = TimeChecker.new()
        local orderedWindows = self.windowModel:getCachedOrderedWindowsOrFetch()
        -- t:diff("getCachedOrderedWindowsOrFetch")

        self:showRectangle(orderedWindows)
        -- t:diff("showRectangle") -- sometimes, slow
        self:showWindowInfo(orderedWindows)
        -- t:diff("showWindowInfo")
    end

    obj.hide = function(self)
        if self.baseCanvas ~= nil then
            self.baseCanvas:delete()
            self.baseCanvas = nil
        end
    end

    obj.showRectangle = function(self, orderedWindows)
        -- local t = TimeChecker.new()
        if self.baseCanvas == nil then
            local frame = FrameCulculator.calcBaseCanvasFrame(orderedWindows)
            -- t:diff("calcBaseCanvasFrame")
            self.baseCanvas = canvas.new(frame)
            -- t:diff("new")
        end
        -- t:diff("canvas new")

        self:setElements(orderedWindows)
        -- t:diff("setElements")

        -- self:activateHammerspoonWindow()
        -- self.baseCanvas:level("normal") -- don't need
        -- self.baseCanvas:bringToFront()

        self:initializeMouseEvent(orderedWindows)
    end

    obj.initializeMouseEvent = function(self, orderedWindows)
        self.baseCanvas:canvasMouseEvents(false, true, false, false)
        self.baseCanvas:mouseCallback(function(canvas, type, elementId, x, y)
            if self.clickCallback == nil then
                return
            end

            if type == "mouseUp" then
                local position = math.floor((y - CanvasConstants.PADDING * 2) / CanvasConstants.ROW_HEIGHT + 1)
                if position < 1 then
                    position = 1
                elseif position > #orderedWindows then
                    position = #orderedWindows
                end

                self.clickCallback(position)
            end
        end)
    end

    -- clickCallback = function(position) end
    obj.setClickCallback = function(self, clickCallback)
        self.clickCallback = clickCallback
    end

    obj.activateHammerspoonWindow = function(self)
        local app = hs.application.get("Hammerspoon")
        app:setFrontmost()
    end

    obj.setElements = function(self, orderedWindows)
        self.baseCanvas:replaceElements({
            action = "fill",
            fillColor = {
                alpha = CanvasConstants.INLINE_RECTANGLE_ALPHA,
                blue = 0.5,
                green = 0.5,
                red = 0.5
            },
            frame = {
                x = "0",
                y = "0",
                h = "1",
                w = "1"
            },
            type = "rectangle",
            withShadow = true
        })

        self.baseCanvas:appendElements({
            action = "fill",
            fillColor = {
                alpha = CanvasConstants.OUTLINE_RECTANGLE_ALPHA,
                blue = 0,
                green = 0,
                red = 0
            },
            frame = {
                x = 0,
                y = 0,
                h = #orderedWindows * CanvasConstants.ROW_HEIGHT + CanvasConstants.PADDING * 2 + CanvasConstants.PADDING * 2,
                w = CanvasConstants.PANEL_W
            },
            type = "rectangle"
        })
    end

    obj.showWindowInfo = function(self, orderedWindows)
        -- local t = TimeChecker.new()
        for i = 1, #orderedWindows do
            local window = orderedWindows[i]

            -- t:diff(i)
            self:showEachKeyText(i, window)
            -- t:diff("showEachKeyText")
            self:showEachAppIcon(i, window)
            -- t:diff("showEachAppIcon")
            self:showEachWindowTitle(i, window)
            -- t:diff("showEachWindowTitle")
        end

        self.baseCanvas:show()
        -- t:diff("show")
    end

    obj.showEachKeyText = function(self, i, window)
        local windowId = window:id()

        local keyText = ""
        local isAutoGeneratedKey

        for j = 1, #self.keyStatusModel.registeredAndAutoGeneratedKeyStatuses do
            local keyStatus = self.keyStatusModel.registeredAndAutoGeneratedKeyStatuses[j]
            if keyStatus.windowId == windowId then
                keyText = keyStatus.key
                isAutoGeneratedKey = keyStatus.isAutoGenerated
                break
            end
        end

        local textColor
        if isAutoGeneratedKey then
            textColor = {
                alpha = CanvasConstants.TEXT_ALPHA,
                blue = 0.1,
                green = 0.9,
                red = 0.9
            }
        else
            textColor = {
                alpha = CanvasConstants.TEXT_ALPHA,
                blue = CanvasConstants.TEXT_WHITE_VALUE,
                green = CanvasConstants.TEXT_WHITE_VALUE,
                red = CanvasConstants.TEXT_WHITE_VALUE
            }
        end

        self.baseCanvas:appendElements({
            frame = {
                x = CanvasConstants.PADDING * 2 + CanvasConstants.KEY_LEFT_PADDING,
                y = (i - 1) * CanvasConstants.ROW_HEIGHT + CanvasConstants.PADDING * 2,
                h = CanvasConstants.ROW_HEIGHT,
                w = CanvasConstants.KEY_W
            },
            text = hs.styledtext.new(keyText, {
                font = {
                    name = ".AppleSystemUIFont",
                    size = CanvasConstants.FONT_SIZE
                },
                color = textColor
            }),
            type = "text"
        })

        local appName = window:application():name()
        Debugger.log(keyText .. " : " .. appName)
    end

    obj.showEachAppName = function(self, i, window)
        local appName = window:application():name()
        self.baseCanvas:appendElements({
            frame = {
                x = CanvasConstants.PADDING * 2 + CanvasConstants.KEY_LEFT_PADDING + CanvasConstants.KEY_W,
                y = (i - 1) * CanvasConstants.ROW_HEIGHT + CanvasConstants.PADDING * 2,
                h = CanvasConstants.ROW_HEIGHT,
                w = CanvasConstants.APP_NAME_W
            },
            text = hs.styledtext.new(appName, {
                font = {
                    name = ".AppleSystemUIFont",
                    size = CanvasConstants.FONT_SIZE
                },
                color = {
                    alpha = CanvasConstants.TEXT_ALPHA,
                    blue = CanvasConstants.TEXT_WHITE_VALUE,
                    green = CanvasConstants.TEXT_WHITE_VALUE,
                    red = CanvasConstants.TEXT_WHITE_VALUE
                }
            }),
            type = "text"
        })
    end

    obj.showEachAppIcon = function(self, i, window)
        local frame = {
            x = CanvasConstants.PADDING * 2 + CanvasConstants.KEY_LEFT_PADDING + CanvasConstants.KEY_W,
            y = (i - 1) * CanvasConstants.ROW_HEIGHT + CanvasConstants.PADDING * 2,
            h = CanvasConstants.ROW_HEIGHT - 3,
            w = CanvasConstants.APP_ICON_W - 3
        }

        local bundleID = window:application():bundleID()
        if bundleID then
            self.baseCanvas:appendElements({
                frame = frame,
                image = hs.image.imageFromAppBundle(bundleID),
                imageScaling = "scaleToFit",
                type = "image",
            })
        else
            local radius = frame.w / 2

            self.baseCanvas:appendElements({
                center = { x = frame.x + radius, y = frame.y + radius },
                action = "fill",
                fillColor = { alpha = 1, blue = 0.5, green = 0.5, red = 0.5 },
                radius = radius - 1,
                type = "circle",
            })
        end
    end

    obj.showEachWindowTitle = function(self, i, window)
        -- local t = TimeChecker.new()
        local windowName = window:title() -- sometimes slow
        if windowName == "" then
            windowName = window:application():name()
            -- t:diff("get application name")
        end
        -- alternative way
        -- local windowName = window:application():name() -- more faster
        -- t:diff("get window title")

        self.baseCanvas:appendElements({
            frame = {
                x = CanvasConstants.PADDING * 3 + CanvasConstants.KEY_W + CanvasConstants.KEY_LEFT_PADDING +
                    CanvasConstants.APP_ICON_W,
                y = (i - 1) * CanvasConstants.ROW_HEIGHT + CanvasConstants.PADDING * 2,
                h = CanvasConstants.ROW_HEIGHT,
                w = CanvasConstants.PANEL_W - CanvasConstants.KEY_W - CanvasConstants.APP_ICON_W -
                    CanvasConstants.PADDING * 6
            },
            text = hs.styledtext.new(windowName, {
                font = {
                    name = ".AppleSystemUIFont",
                    size = CanvasConstants.FONT_SIZE
                },
                color = {
                    alpha = CanvasConstants.TEXT_ALPHA,
                    blue = CanvasConstants.TEXT_WHITE_VALUE,
                    green = CanvasConstants.TEXT_WHITE_VALUE,
                    red = CanvasConstants.TEXT_WHITE_VALUE
                }
            }),
            type = "text"
        })
    end

    return obj
end
return BaseCanvasView
