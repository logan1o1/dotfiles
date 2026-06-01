hl.config(
        {
                general    = {
                        gaps_in = 2.5,
                        gaps_out = 3,
                        border_size = 2,
                        col = {
                                active_border = "rgba(33ccffee)",
                                inactive_border = "rgba(595959aa)",
                        },
                        resize_on_border = true,
                        allow_tearing = true,
                        layout = "dwindle"
                },
                decoration = {
                        rounding = 3,
                        rounding_power = 4,
                        active_opacity = 0.96,
                        inactive_opacity = 0.95,
                        shadow = {
                                enabled = true,
                                range = 4,
                                render_power = 3,
                                color = "rgba(1a1a1aee)",
                        },
                        blur = {
                                enabled = true,
                                size = 8,
                                passes = 4,
                                vibrancy = 0.1696,
                        },
                },
                dwindle    = {
                        preserve_split = true, -- You probably want this
                },
                master     = {
                        new_status = "master",
                },
                misc       = {
                        force_default_wallpaper = -1,
                        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
                },
                xwayland   = { force_zero_scaling = true },
        }
)
