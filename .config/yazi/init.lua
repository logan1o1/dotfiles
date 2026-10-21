require("bunny"):setup({
  hops = {
    { key = "/",                  path = "/",                                                    },
    { key = "~",                  path = "~",                                                    },
    { key = "m",                  path = "~/Music",                        desc = "Music"        },
    { key = "b",                  path = "~/Books",                        desc = "Books"        },
    { key = "d",                  path = "~/Downloads",                    desc = "Downloads"    },
    { key = "p",                  path = "~/projects/",                    desc = "Projects"     },
    { key = "w",                  path = "~/wallpapers/",                  desc = "Wallpapers"   },
    { key = "M",                  path = "~/Videos/movies/",               desc = "Movies"       },
    { key = "D",                  path = "~/dotfiles/.config",             desc = "Dotfiles"     },
    { key = "t",                  path = "~/.local/share/Trash/files",     desc = "Trash"        },
    { key = { "l", "s" },         path = "~/.local/share",                 desc = "Local share"  },
    { key = { "l", "b" },         path = "~/.local/bin",                   desc = "Local bin"    },
    { key = { "l", "t" },         path = "~/.local/state",                 desc = "Local state"  },
    -- key and path attributes are required, desc is optional
  },
  desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
  ephemeral = true, -- Enable ephemeral hops, default is true
  tabs = true, -- Enable tab hops, default is true
  notify = false, -- Notify after hopping, default is false
  fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
})

require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}

require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}
