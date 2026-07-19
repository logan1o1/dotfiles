require("modules.variables")

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(Variables.terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(Variables.menu))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(Variables.wallpaper))
hl.bind(mainMod .. " + O", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

hl.bind("F2", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("F3", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("F4", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

hl.bind("F6", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("F7", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("F8", hl.dsp.exec_cmd("playerctl next"), { locked = true })

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
        local key = i % 10
        hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("SUPER + M", hl.dsp.submap("media"))
hl.define_submap("media", function()
        hl.bind("J", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
        hl.bind("K", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
        hl.bind("L", hl.dsp.exec_cmd("playerctl next"), { locked = true })
        hl.bind("escape", hl.dsp.submap("reset"))
        hl.bind("Return", hl.dsp.submap("reset"))
end)

hl.bind("SUPER + V", hl.dsp.submap("volume"))
hl.define_submap("volume", function()
        hl.bind("K", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
        hl.bind("J", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
        hl.bind("M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
        hl.bind("escape", hl.dsp.submap("reset"))
        hl.bind("Return", hl.dsp.submap("reset"))
end)

hl.bind("SUPER + B", hl.dsp.submap("brightness"))
hl.define_submap("brightness", function()
        hl.bind("K", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
        hl.bind("J", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
        hl.bind("escape", hl.dsp.submap("reset"))
        hl.bind("Return", hl.dsp.submap("reset"))
end)

hl.bind("SUPER + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
        hl.bind("L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
        hl.bind("H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
        hl.bind("K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
        hl.bind("J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })
        hl.bind("escape", hl.dsp.submap("reset"))
        hl.bind("Return", hl.dsp.submap("reset"))
end)

hl.bind(mainMod .. " + Tab", hl.dsp.submap("power"))
hl.define_submap("power", function()
        hl.bind("Return", function()
                hl.dispatch(hl.dsp.submap("reset"))
        end)
        hl.bind("escape", function()
                hl.dispatch(hl.dsp.submap("reset"))
        end)
        hl.bind("R", function()
                hl.dispatch(hl.dsp.submap("reset"))
                hl.dispatch(hl.dsp.exec_cmd("systemctl reboot"))
        end)
        hl.bind("P", function()
                hl.dispatch(hl.dsp.submap("reset"))
                hl.dispatch(hl.dsp.exec_cmd("systemctl poweroff -i"))
        end)
        hl.bind("L", function()
                hl.dispatch(hl.dsp.submap("reset"))
                hl.dispatch(hl.dsp.exec_cmd(Variables.lockScreen))
        end)
end)
