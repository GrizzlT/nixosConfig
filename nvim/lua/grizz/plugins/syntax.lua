return {
  {
    'kaarmu/typst.vim',
    ft = 'typst',
    lazy = false,
  },

  {
    'chomosuke/typst-preview.nvim',
    lazy = false, -- or ft = 'typst'
    version = '1.*',
    build = function() require 'typst-preview'.update() end,
    config = function ()
      require 'typst-preview'.setup {
        -- Example: open_cmd = 'firefox %s -P typst-preview --class typst-preview'
        open_cmd = 'librewolf %s -P Typst --class typst-preview',

        -- Whether the preview will follow the cursor in the source file
        follow_cursor = true,

        -- -- A list of extra arguments (or nil) to be passed to previewer.
        -- -- For example, extra_args = { "--input=ver=draft", "--ignore-system-fonts" }
        -- extra_args = nil,
        --
        -- -- This function will be called to determine the root of the typst project
        -- get_root = function(path_of_main_file)
        --   return vim.fn.fnamemodify(path_of_main_file, ':p:h')
        -- end,
        --
        -- -- This function will be called to determine the main file of the typst
        -- -- project.
        -- get_main_file = function(path_of_buffer)
        --   return path_of_buffer
        -- end,
      }
    end,
  },
}
