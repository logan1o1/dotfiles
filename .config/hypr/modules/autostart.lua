require("modules.variables")

hl.on(
        "hyprland.start", function()
                hl.exec_cmd(Variables.lockScreen)
                hl.exec_cmd("foot --server &")
                hl.exec_cmd("waypaper --restore")
                hl.exec_cmd("waybar & disown")
                hl.exec_cmd(Variables.terminal)
        end
)
