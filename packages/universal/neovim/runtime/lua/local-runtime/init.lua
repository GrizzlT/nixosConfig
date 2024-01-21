local M = {}

-- Nix utility to provide the plugin path to lua
M.setup = function (opts)
  M.local_runtime_path = opts.path
end

return M
