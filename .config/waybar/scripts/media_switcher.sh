#!/bin/zsh

if playerctl -p playerctld status >/dev/null 2>&1; then 
        echo ""
fi



# "custom/media-switcher": {
#         "format": "󰽛",
#         "exec-if": "~/dotfiles/.config/waybar/scripts/media_switcher.sh",
#         "on-click": "playerctld shift",
#         "tooltip": false,
#         "interval": 5
# }
# ```
# ```sh
# #!/bin/sh
# playerctl -p playerctld status >/dev/null 2>&1 || exit 1
