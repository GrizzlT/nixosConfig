return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function ()
      local npairs = require('nvim-autopairs')
      local Rule = require('nvim-autopairs.rule')
      local cond = require('nvim-autopairs.conds')

      npairs.setup({
        check_ts = true,
        fast_wrap = {},
      })

      for _, punct in ipairs({ ",", ";" }) do
        npairs.add_rule(
          Rule('', punct)
            :with_move(function (opts) return opts.char == punct end)
            :with_pair(cond.none())
            :with_del(cond.none())
            :with_cr(cond.none())
            :use_key(punct)
        )
      end

      local ok, cmp = pcall(require, 'cmp')
      if ok then
        cmp.event:on(
          "confirm_done",
          require('nvim-autopairs.completion.cmp').on_confirm_done()
        )
      end
    end,
  },
}
