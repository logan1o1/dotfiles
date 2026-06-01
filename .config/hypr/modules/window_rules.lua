local suppressMaximizeRule = hl.window_rule({
        -- Ignore maximize requests from all apps. You'll probably like this.
        name           = "suppress-maximize-events",
        match          = { class = ".*" },

        suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
        -- Fix some dragging issues with XWayland
        name     = "fix-xwayland-drags",
        match    = {
                class      = "^$",
                title      = "^$",
                xwayland   = true,
                float      = true,
                fullscreen = false,
                pin        = false,
        },

        no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
        name  = "move-hyprland-run",
        match = { class = "hyprland-run" },

        move  = "20 monitor_h-120",
        float = true,
})


hl.window_rule({
        name = "org.pulseaudio.pavucontrol",
        match = { class = "org.pulseaudio.pavucontrol" },
        float = true,
        size = "500 600",
        move = "1030 35",
        pin = true
})

hl.window_rule({
        name = "dev.noctalia.noctalia-qs",
        match = { class = "dev.noctalia.noctalia-qs" },
        float = true,
        size = "500 550",
        move = "1030 35",
        pin = true
})
