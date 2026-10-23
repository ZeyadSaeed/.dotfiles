-- Hyprland Lua config.
-- Converted from hyprland.conf (hyprlang), deprecated since Hyprland 0.55.
-- See https://wiki.hypr.land/Configuring/Start/

------------------
---- DARK THEME --
------------------

hl.env("GNOME_SCHEMA", "org.gnome.desktop.interface")

-- for kde apps you need to install: sudo pacman -S qt5ct qt6ct kvantum kvantum breeze-icons
-- you will need to set dark theme for qt apps from kde, more difficult than with gnome :D
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "DP-2",
	mode = "1920x1080@165",
	position = "0x0",
	scale = "auto",
	transform = 1,
})

hl.monitor({
	output = "DP-1",
	mode = "2560x1440@360",
	position = "1080x0",
	scale = "auto",
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "ghostty"
local browser = "zen-browser"
local fileManager = "dolphin"
local menu = "rofi -show drun"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("waybar & hyprpaper & hypridle")

	-- Clipboard: history starts empty each login, like Windows. Delete the db rather than
	-- `cliphist wipe`, which leaves the file at its full size
	hl.exec_cmd("rm -f ${XDG_CACHE_HOME:-$HOME/.cache}/cliphist/db; wl-paste --watch cliphist -max-items 100 store")

	-- Start up apps
	hl.exec_cmd(browser, { workspace = "1 silent" })
	hl.exec_cmd(terminal, { workspace = "2 silent" })
	hl.exec_cmd("discord", { workspace = "5 silent" })
	hl.exec_cmd("spotify-launcher", { workspace = "6 silent" })
	-- Speech to text; must be running for the F24 push-to-talk
	hl.exec_cmd("handy --start-hidden")

	-- Move workspace to the monitor once connected
	hl.exec_cmd("handle_monitor_connect.sh")
end)

-- Move workspaces to the needed monitor
hl.workspace_rule({ workspace = "1", monitor = "DP-1" })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-2" })
hl.workspace_rule({ workspace = "6", monitor = "DP-2" })

-- Fix the problem where discord opens on a different monitor based on the focused workspace
hl.window_rule({
	name = "discord_ws5",
	match = { class = "^(discord)$" },
	workspace = "5",
})

hl.window_rule({
	name = "spotify_ws6",
	match = { class = "^(Spotify|spotify)$" },
	workspace = "6 silent",
})

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission({ binary = "/usr/(bin|local/bin)/grim", type = "screencopy", mode = "allow" })
-- hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
-- hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 10,

		border_size = 2,

		col = {
			active_border = "rgba(7aa2f7ff)", -- tokyo night blue
			inactive_border = "rgba(292e42ff)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		rounding = 5,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = false, -- was: enabled = no, please :)
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
	master = {
		new_status = "master",
	},
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = false, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us,ara",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		accel_profile = "flat",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = false,
		},
	},
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local mainMod = "ALT"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(terminal .. " -e btop"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Move focus with mainMod + hjkl
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Handy push-to-talk: hold F24 (Fn + Right Shift on the Wooting) to record, release to transcribe.
-- Handy only has a toggle signal, so press and release each send it once
local handy_toggle = hl.dsp.exec_cmd("pkill -USR2 -x handy")
hl.bind("F24", handy_toggle)
hl.bind("F24", handy_toggle, { release = true })

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Open the clipboard and paste the picked entry
hl.bind("SUPER + V", hl.dsp.exec_cmd("~/.config/hypr/scripts/clipboard.sh"))

hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("rofi -show calc -modi calc -no-show-match -no-sort"))

-- Switch keyboard layout
-- Set every device to the main keyboard's next layout; "all next" flips each device on its own and they drift apart
local switch_layout = hl.dsp.exec_cmd(
	"hyprctl switchxkblayout all $((1 - $(hyprctl devices -j | jq '.keyboards[] | select(.main).active_layout_index')))"
)
hl.bind("SUPER + Space", switch_layout)

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Move window by keyboard
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))

-- Screenshots
-- hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m window -m active"))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -m region"))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- Ignore maximize requests from apps. You'll probably like this.
-- hl.window_rule({
--     name  = "suppress-maximize-events",
--     match = { class = ".*" },
--     suppress_event = "maximize",
-- })

-- Fix some dragging issues with XWayland
-- hl.window_rule({
--     name  = "fix-xwayland-drags",
--     match = {
--         class      = "^$",
--         title      = "^$",
--         xwayland   = true,
--         float      = true,
--         fullscreen = false,
--         pin        = false,
--     },
--     no_focus = true,
-- })
