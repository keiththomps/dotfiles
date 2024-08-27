local linters_by_ft

if vim.env.SPIN then
  linters_by_ft = {
    ruby = { "rubocop" },
    eruby = { "erb_lint" },
  }
else
  linters_by_ft = {}
end

require("lint").linters_by_ft = linters_by_ft
require("mason-nvim-lint").setup()