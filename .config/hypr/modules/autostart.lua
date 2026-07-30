require("modules.variables")

hl.on(
        "hyprland.start", function()
                hl.exec_cmd(Variables.terminal)
                hl.exec_cmd("waybar & disown")
                hl.exec_cmd(Variables.lockScreen)
                hl.exec_cmd("waypaper --restore")
        end
)
