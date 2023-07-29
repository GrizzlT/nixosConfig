local npairs = require('nvim-autopairs')
local Rule = require('nvim-autopairs.rule')
local conds = require('nvim-autopairs.conds')
local ts_conds = require('nvim-autopairs.ts-conds')
local ts_utils = require("nvim-treesitter.ts_utils")
local completion_cmp = require('nvim-autopairs.completion.cmp')

local function char_matches_end_pair(opts)
  return opts.char == opts.next_char:sub(1,1)
end

local function is_rust_generic_param(opts)
  local identifier = "[%w_]+"
  local str = opts.line:sub(1, opts.col - 1)
  if str:find(":%s" .. identifier .. "%s*$")
    or str:find(":%s*impl%s+" .. identifier .. "%s*$")
    or str:find("->%s*" .. identifier .. "%s*$")
    or str:find("->%s*impl%s+" .. identifier .. "%s*$")
    or str:find("fn%s+" .. identifier .. "%s*$")
    or str:find("struct%s+" .. identifier .. "%s*$")
    or str:find("enum%s+" .. identifier .. "%s*$")
    or str:find("impl%s*$")
    or str:find("impl%s+" .. identifier .. "%s*$")
    or str:find("impl%s*%b<>%s*" .. identifier .. "%s*$")
    or str:find("trait%s+" .. identifier .. "%s*$")
    or str:find("type%s+" .. identifier .. "%s*$")
    or str:find("::%s*$")
  then
    return true
  end
  return false
end

local function is_rust_closure(opts)
  local str = opts.line:sub(1, opts.col - 1)
  if str:find("move%s+$") -- move |
    or str:find("=%s*$") -- let statement: = |
    or str:find("[(,]%s*$") -- function parametes: (| or , |
  then
    return true
  else
    return false
  end
end

local pairs = {}

-- Add spaces between parentheses
local brackets = { { '(', ')' }, { '[', ']' }, { '{', '}' } }
table.insert(pairs,
  Rule(' ', ' ')
    :with_pair(function (opts)
      local pair = opts.line:sub(opts.col - 1, opts.col)
      return vim.tbl_contains({
        brackets[1][1]..brackets[1][2],
        brackets[2][1]..brackets[2][2],
        brackets[3][1]..brackets[3][2],
      }, pair)
    end)
)
for _,bracket in ipairs(brackets) do
  table.insert(pairs,
    Rule(bracket[1]..' ', ' '..bracket[2])
      :with_pair(function() return false end)
      :with_move(function(opts)
        return opts.prev_char:match('.%'..bracket[2]) ~= nil
      end)
      :use_key(bracket[2])
  )
end

-- Lua
-- add commas after assignment
table.insert(pairs,
  Rule('=', ',', "lua")
    :with_pair(conds.not_after_regex("%s?}", 2), nil)
    :with_pair(ts_conds.is_ts_node({ "table_constructor", "field", "bracket_index_expression" }))
    :with_cr(conds.none())
    :with_move(char_matches_end_pair)
)

-- Nix
table.insert(pairs,
-- Auto end with semicolon
  Rule('=', ',', "nix")
    :with_pair(ts_conds.is_not_ts_node({ 'comment', 'source', 'string_expression', 'indented_string_expression' }))
    :with_cr(conds.none())
    :with_move(char_matches_end_pair)
)
table.insert(pairs,
  Rule("''", "''", "nix")
    :with_pair(ts_conds.is_not_ts_node({ 'comment', 'source', 'string_expression', 'indented_string_expression' }))
    :with_pair(conds.not_before_text("''"))
    :with_move(char_matches_end_pair)
)

-- Rust
table.insert(pairs,
  -- Generic parameter
  Rule("<", ">", "rust")
    :with_pair(is_rust_generic_param)
    :with_cr(conds.none())
    :with_move(char_matches_end_pair)
)
table.insert(pairs,
  Rule("|", "|", "rust")
    :with_pair(is_rust_closure)
    :with_cr(conds.none())
    :with_move(char_matches_end_pair)
)

npairs.setup({
  enable_check_bracket_line = false,
  fast_wrap = {},
})

for _, rule in ipairs(npairs.config.rules) do
  if rule.start_pair == "'" and rule.not_filetypes then
    -- Disable '' in nix
    table.insert(rule.not_filetypes, "nix")
  end
end

npairs.add_rules(pairs)

local ts_node_func_parens_disabled = {
  -- rust
  use_declaration = true,
  attribute = true;
}

local default_handler = completion_cmp.filetypes["*"]["("].handler
completion_cmp.filetypes["*"]["("].handler = function(char, item, bufnr, rules, commit_character)
  local node_type = ts_utils.get_node_at_cursor():type()
  if ts_node_func_parens_disabled[node_type] then
    if item.data then
      item.data.funcParensDisabled = true
    else
      char = ""
    end
  end
  default_handler(char, item, bufnr, rules, commit_character)
end

require('cmp').event:on(
  "confirm_done",
  completion_cmp.on_confirm_done()
)
