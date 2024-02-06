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
    ["<leader>on"] = {
      action = '<cmd>ObsidianQuickSwitch<cr>',
      opts = { desc = 'Quick switch' },
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

  completion = {
    new_notes_location = "notes_subdir",
  },
})
