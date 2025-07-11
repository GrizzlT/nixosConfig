return {
  {
    'epwalsh/obsidian.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    keys = {
      { "<leader>on", '<cmd>ObsidianQuickSwitch<cr>', desc = 'Quick switch', },
    },
    ft = 'markdown',
    cmd = 'ObsidianWorkspace',
    config = function()
      require('obsidian').setup({
        mappings = {
          ["gd"] = {
            action = require('obsidian').util.gf_passthrough,
            opts = { noremap = false, expr = true, buffer = true, desc = 'Follow Obsidian Link' },
          },
          ["<leader>ch"] = {
            action = require('obsidian').util.toggle_checkbox,
            opts = { buffer = true, desc = 'Toggle checkbox' },
          },
          ["<leader>ot"] = {
            action = '<cmd>ObsidianTemplate<cr>',
            opts = { desc = 'Create from Template' },
          }
        },

        workspaces = {
          {
            name = "personal",
            path = "/home/grizz/DATA/02_Informational/Obsidian/Personal",
          },
          {
            name = "projects",
            path = "/home/grizz/DATA/02_Informational/Obsidian/Projects",
          },
          {
            name = "education",
            path = "/home/grizz/DATA/02_Informational/Obsidian/Education",
          },
        },

        note_id_func = function(title)
          -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
          -- In this case a note with the title 'My new note' will be given an ID that looks
          -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
          local suffix = ""
          if title ~= nil then
            -- If title is given, transform it into valid file name.
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            -- If title is nil, just add 4 random uppercase letters to the suffix.
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end,

        notes_subdir = "notes",
        daily_notes = {
          -- Optional, if you keep daily notes in a separate directory.
          folder = "notes/dailies",
          -- Optional, if you want to change the date format for the ID of daily notes.
          date_format = "%Y-%m-%d",
          -- Optional, if you want to change the date format of the default alias of daily notes.
          alias_format = "%B %-d, %Y",
          -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
          template = nil
        },
        completion = {
          new_notes_location = "notes_subdir",
        },
      })

    end,
  },
}
