-- Hyprland Lua config (migrated from legacy hyprland.conf)
-- API: /usr/share/hypr/hyprland.lua + /usr/share/hypr/stubs/hl.meta.lua

----------------- Programs -----------------
local mainMod     = "SUPER"
local terminal    = "kitty"
local fileManager = "nautilus"
local browser     = "firefox"

----------------- Monitors -----------------
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

------- Environment (Nvidia + gaming latency) -------
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("__GL_MaxFramesAllowed", "1")   -- cap render-ahead to 1 frame
hl.env("__GL_GSYNC_ALLOWED", "1")
hl.env("__GL_VRR_ALLOWED", "1")

----------------- Autostart -----------------
hl.on("hyprland.start", function()
    -- portals: screenshare + file pickers
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    -- polkit authentication agent (GUI privilege prompts) -- after env import
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service")
    -- clipboard manager (cursor-clip) background watcher
    hl.exec_cmd("cursor-clip --daemon")
    -- idle manager
    hl.exec_cmd("hypridle")
    -- status bar
    hl.exec_cmd("waybar")
    -- wallpaper
    hl.exec_cmd("hyprpaper")
end)

------------- Look & feel / latency -------------
hl.config({
    general = {
        layout = "dwindle",
        allow_tearing = true,            -- master switch (per-game rule below)
        gaps_in = 5,                     -- gap between windows (default 5)
        gaps_out = 12,                    -- gap to screen edges / padding (default 20)
        border_size = 2,
        col = {
            active_border   = "rgba(dcd7baff)",   -- Kanagawa fujiWhite
            inactive_border = "rgba(54546daa)",   -- Kanagawa sumiInk4, dim
        },
    },
    cursor = {
        no_hardware_cursors = true,
        no_break_fs_vrr = true,
        min_refresh_rate = 60,
    },
    misc = {
        force_default_wallpaper = 0,     -- no built-in anime wallpaper
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 2,                         -- adaptive sync, fullscreen only
    },
    render = {
        direct_scanout = 1,              -- bypass compositor for fullscreen
    },
    input = {
        kb_layout  = "us,ca",
        kb_variant = ",multix",
        repeat_rate = 40,
        repeat_delay = 300,
        follow_mouse = 1,
        sensitivity = 0,
        accel_profile = "flat",          -- disable pointer acceleration
    },
    dwindle = {
        preserve_split = true,
    },
})

--------- Snappy animations (fixes slow defaults) ---------
-- speed = deciseconds (lower = faster). Shipped example used 5-10 (slow).
hl.curve("snappy", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0} } })
hl.config({ animations = { enabled = true } })
hl.animation({ leaf = "global",     enabled = true, speed = 4, bezier = "snappy" })
hl.animation({ leaf = "windows",    enabled = true, speed = 3, bezier = "snappy", style = "popin 80%" })
hl.animation({ leaf = "fade",       enabled = true, speed = 2, bezier = "snappy" })
hl.animation({ leaf = "border",     enabled = true, speed = 3, bezier = "snappy" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "snappy", style = "slide" })
-- To disable animations entirely (max snappiness / lowest latency):
--   hl.config({ animations = { enabled = false } })

--------- Persistent workspaces (always shown in waybar) ---------
for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), persistent = true })
end

----------------- Keybinds -----------------
-- Apps
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("cursor-clip"))        -- clipboard overlay

-- Tap SUPER alone (released without any combo) -> app launcher
hl.bind(mainMod .. " + SUPER_L", hl.dsp.exec_cmd("pkill wofi || wofi --show drun"), { release = true })

-- Window management
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())          -- graceful close
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.kill())           -- force quit
hl.bind(mainMod .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + O",         hl.dsp.layout("togglesplit"))   -- flip orientation (needs 2+ tiled windows)
hl.bind(mainMod .. " + P",         hl.dsp.window.pin())
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = "maximized",  action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + Delete",       hl.dsp.exit())                  -- quit Hyprland

-- Keyboard layout switch (us <-> ca multix)
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))

-- Focus (hjkl)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Move window (shift + hjkl)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Workspaces (win+digit) + move active window to workspace (win+shift+digit)
for i = 1, 10 do
    local key = i % 10  -- 10 -> key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mouse drag move/resize
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys (wpctl + playerctl)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume-osd.sh up"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume-osd.sh down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("~/.config/hypr/scripts/volume-osd.sh mute"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Screenshots (grim + slurp)
--   Print         region select -> save + clipboard
--   CTRL + Print  region select -> clipboard only (no file)
--   SHIFT + Print whole screen  -> save + clipboard
-- Retheme the selection box by editing slurpFlags (colors are RRGGBBAA).
-- Border = Kanagawa fujiWhite (#DCD7BA); bg dim = Kanagawa sumiInk1 (#1F1F28).
local slurpFlags = "-b 1f1f2899 -c dcd7baff -w 2"   -- dim bg, white border, border width
local saveTo     = '| tee "$(xdg-user-dir PICTURES)/Screenshots/$(date +%F_%H-%M-%S).png"'
-- freeze: hyprpicker -r holds a still frame so slurp selects over a frozen screen.
-- Kill hyprpicker BEFORE grim runs, else grim captures hyprpicker's drawn cursor
-- in the corner where the selection ended. grim itself draws no cursor.
local freeze = function(grimCmd) return 'hyprpicker -r -z & p=$!; sleep 0.15; g="$(slurp ' .. slurpFlags .. ')"; kill $p; ' .. grimCmd end
hl.bind("Print",         hl.dsp.exec_cmd(freeze('grim -g "$g" - ' .. saveTo .. ' | wl-copy')))
hl.bind("CTRL + Print",  hl.dsp.exec_cmd(freeze('grim -g "$g" - | wl-copy')))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim - ' .. saveTo .. ' | wl-copy'))

-- Firefox Picture-in-Picture: always float + pinned on top
hl.window_rule({
    name  = "firefox-pip-float",
    match = { class = "^firefox$", title = "^Picture-in-Picture$" },
    float = true,
    pin   = true,
})

-- Per-game tearing (uncomment; class from `hyprctl clients`):
-- hl.window_rule({ name = "tear-games", match = { class = "steam_app_.*" }, immediate = true })
