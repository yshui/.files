-- env variables
local home = di.os.env.HOME
di.os.env.GTK_IM_MODULE = "fcitx"
di.os.env.QT_IM_MODULE = "fcitx"
-- di.os.env.QT_SCALE_FACTOR = "1"
di.os.env.QT_AUTO_SCREEN_SCALE_FACTOR = "1"
di.os.env.QT_SCREEN_SCALE_FACTORS = "3;1.5"
-- di.os.env.QT_USE_PHYSICAL_DPI="0"
-- di.os.env.QT_FONT_DPI = "192"
di.os.env.MPD_HOST = home.."/.mpd/socket"
-- put /home/user/.local/bin into path
di.os.env.PATH=home.."/.local/bin:"..di.os.env.PATH
-- put /home/user/.cargo/bin into path
di.os.env.PATH=home.."/.cargo/bin:"..di.os.env.PATH
di.os.env.XMODIFIERS = "@im=fcitx"
di.os.env.WINEFSYNC = "1"
di.os.env.ENABLE_DEVICE_CHOOSER_LAYER="1"
di.os.env.VULKAN_DEVICE_MATCH="AMD"
di.os.env.GIT_EXTERNAL_DIFF="difft"

di.os.env.RADV_PERFTEST = "cswave32,gewave32,nggc"
di.os.env.AMD_VULKAN_ICD = "RADV"

-- pretend to be mate so xdg-open would delegate to "gio open"
di.os.env.XDG_CURRENT_DESKTOP = "MATE"

di.os.env.MOZ_USE_XINPUT2 = "1"
di.os.env.MOZ_X11_EGL = "1"

-- Make ubsan stricter
di.os.env.UBSAN_OPTIONS="halt_on_error=1:print_stacktrace=1"
di.os.env.SSH_ASKPASS="/usr/lib/seahorse/ssh-askpass"

-- get the config directory, used for putting the log file
if di.os.env["XDG_CONFIG_HOME"] ~= nil then
    cfg_dir = di.os.env.XDG_CONFIG_HOME.."/deai"
else
    cfg_dir = home.."/.config/deai"
end

local restarted = false
if di.os.env.DEAI_RESTARTED ~= nil then
    di.os.env.DEAI_RESTARTED = nil
    restarted = true
end

di.log.log_level = "info"
di.log.log_target = di.log:file_target(cfg_dir.."/log.txt", false)
-- connect to xorg
local xc = di.xorg:connect()

function get_output(name)
    local os = xc.randr.outputs
    for _, v in pairs(os) do
        if v.name == name then
            return v
        end
    end
    return nil
end
-- alternatively:
-- xc = di.xorg.connect_to(<display>)

xc:on("connection-error", function()
    -- Quit when xorg connection dies
    di:quit()
end)

-- set this shortcut early, in case the rest of the script failed to load
xc.key:new({"mod4"}, "r", false):on("pressed", function()
    di:log("warn", "deai restarting...")
    di.os.env.DEAI_RESTARTED = "1"
    di:exec(di.argv)
end)

-- Apply settings to xinput device
-- @param dev the device
function apply_xi_settings(dev)
    local p = dev.props
    if dev.type == "touchpad" then
        p["libinput Tapping Enabled"] = 1
        p["libinput Tapping Button Mapping Enabled"] = {0,1}
    end

    if dev.use == "pointer" then
        if string.find(dev.name, "ELECOM") or string.find(dev.name, "Logitech") or string.find(dev.name, "MX Ergo") then
            p["libinput Scroll Method Enabled"] = {0, 0, 1}
            if string.find(dev.name, "ELECOM") then
                -- some ELECOM mouses have the same names, we check the device
                -- ids here
                local dev_node = p["Device Node"]
                print(dev_node)
                local model_id
                if dev_node ~= nil then
                    local dev = di.evdev:open(dev_node)
                    if dev ~= nil and dev.id ~= nil then
                        model_id = dev.id.product
                    end
                end
                if model_id == 0x00fe or model_id == 0x00ff then
                    -- this is my Deft (wired or wireless)
                    p["libinput Button Scrolling Button"] = 9
                else
                    -- unknown, assuming it's my Ex-G
                    p["libinput Button Scrolling Button"] = 10
                end
            else
                p["libinput Button Scrolling Button"] = 9
            end
        end
        p["libinput Natural Scrolling Enabled"] = 1
    end
end

local xi = xc.xinput

-- add listener for new-device event
xi:on("new-device", function(dev)
    di:log("info", string.format("new device %s %s %s %d", dev.type, dev.use, dev.name, dev.id))
    -- apply settings to new device
    apply_xi_settings(dev)
    -- set keymap
    xc.keymap = { layout = "us", options = "ctrl:nocaps" }
end)
xc.keymap = { layout = "us", options = "ctrl:nocaps" }


-- apply settings to existing devices
local devs = xi.devices;
for i, v in ipairs(devs) do
    di:log("info", string.format("%d %d %s %s %s", i, v.id, v.name, v.type, v.use))
    apply_xi_settings(v)
end

local function replace_awesome()
    local awesome = di.spawn:run({"awesome", "--replace"}, false)
    awesome:on("stderr_line", function(l)
        di:log("warn", "[awesome.ERR] "..l)
    end)
    awesome:on("stdout_line", function(l)
        di:log("info", "[awesome.OUT] "..l)
    end)
end


xc.xrdb = [[Xft.dpi:	288
rofi.terminal:	alacritty
]]
if not restarted then
    local function auto_start()
        replace_awesome()

        di.spawn:run({"picom", "--experimental-backends"}, true)
        di.spawn:run({"fcitx5"}, true)
        --di.spawn.run({"transmission-daemon"}, true)
        di.spawn:run({"synergys", "--name", "pc"}, true)
        di.spawn:run({"mpd"}, true)
        di.spawn:run({"syncthing", "-no-browser"}, true)
        di.spawn:run({"syncthing-inotify"}, true)
        --di.spawn.run({"jack_control", "start"}, true)
        di.spawn:run({"emacs", "--daemon"}, true)
        di.spawn:run({"/usr/lib/mate-polkit/polkit-mate-authentication-agent-1"}, true)
    end
    -- test if a dbus daemon is already running and reachable
    local bus = di.dbus.session_bus
    if bus == nil or bus.errmsg then
        local dbusl = di.spawn:run({"dbus-launch"}, false)
        --run auto start only after dbus-launch finishes
        dbusl:on("exit", function()
            auto_start()
        end)
        dbusl:on("stdout_line", function(l)
            e = string.find(l, "=")
            if e == nil then
                return
            end
            di.os.env[string.sub(l, 1, e-1)] = string.sub(l, e+1)
        end)
    else
        auto_start()
    end
    bus = nil
end

xc.key:new({"mod4", "control"}, "r", false):on("pressed", function()
    di:log("info", "restarting awesome...")
    replace_awesome()
end)

xc.key:new({"mod4", "shift"}, "e", false):on("pressed", function()
    di:log("info", "deai quitting...")
    di:terminate()
end)

xc.key:new({"mod4", "shift"}, "l", false):on("pressed", function()
    di.spawn:run({"i3lock"}, true)
    kpass = di.dbus.session_bus:get("org.freedesktop.secrets", "/keepassxc")
    kpass["org.keepassxc.MainWindow.lockAllDatabases"]()
end)

xc.key:new({"mod4"}, "d", false):on("pressed", function()
    di.spawn:run({"rofi", "-show", "run"}, true)
end)

xc.key:new({"mod4"}, "z", false):on("pressed", function()
    di.spawn:run({"mpc", "toggle"}, true)
end)

xc.key:new({"mod4"}, "x", false):on("pressed", function()
    di.spawn:run({"mpc", "prev"}, true)
end)

xc.key:new({"mod4"}, "c", false):on("pressed", function()
    di.spawn:run({"mpc", "next"}, true)
end)

xc.key:new({"mod4"}, "w", false):on("pressed", function()
    di.spawn:run({"wimp"}, true)
end)

xc.key:new({}, "XF86AudioPlay", false):on("pressed", function()
    di.spawn:run({"mpc", "toggle"}, true)
end)

xc.key:new({}, "XF86AudioPause", false):on("pressed", function()
    di.spawn:run({"mpc", "pause"}, true)
end)

xc.key:new({}, "XF86AudioPrev", false):on("pressed", function()
    di.spawn:run({"mpc", "prev"}, true)
end)

xc.key:new({}, "XF86AudioNext", false):on("pressed", function()
    di.spawn:run({"mpc", "next"}, true)
end)
