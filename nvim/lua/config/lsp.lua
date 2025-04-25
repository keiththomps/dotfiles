-- Setup Mason (for installing LSPs/linters)
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "rust_analyzer",
    "ts_ls",
    "biome",
  },
  automatic_installation = true,
})

-- nvim-cmp integration: advertise LSP capabilities (snippet/completion support)
local cmp_caps = require("cmp_nvim_lsp").default_capabilities()

-- Apply these capabilities to ALL LSP servers by default:
vim.lsp.config('*', { capabilities = cmp_caps })  -- Neovim 0.11+ syntax

-- Optionally, adjust specific server settings:
vim.lsp.config['rust_analyzer'] = {  -- additional Rust Analyzer config example
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = { command = "clippy" },  -- run clippy on save
    },
  },
}

-- For Ruby, use Ruby LSP (if installed via gem) for core language features:
vim.lsp.config['ruby_ls'] = {
  cmd = { "ruby-lsp" },         -- assumes `ruby-lsp` binary in PATH (or use bundle exec)
  filetypes = { "ruby" },
  root_markers = { "Gemfile", ".git" },
}

-- Also configure RuboCop as an LSP (for diagnostics/formatting) if desired:
vim.lsp.config['rubocop'] = {
  cmd = { "rubocop", "--lsp" },  -- runs RuboCop in LSP mode (Rubocop 1.53+)
  filetypes = { "ruby" },
  root_markers = { ".rubocop.yml", ".git" },
  init_options = { unsafeAutocorrect = false },  -- RuboCop LSP option (safe autocorrect)
}

-- Bacon LSP for Rust (for continuous diagnostics via bacon):
vim.lsp.config['bacon_ls'] = {
  cmd = { "bacon-ls" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  -- Bacon-ls will auto-run `bacon` in background if configured (see Bacon docs)
  settings = { runBaconInBackground = true },
}

-- (TypeScript) tsserver config is provided by lspconfig defaults; no custom setup needed.

-- Finally, enable the servers to auto-start for their filetypes:
vim.lsp.enable({
  "rust_analyzer",
  "tsserver",
  "ruby_ls",
  "rubocop",    -- enabling rubocop LSP (optional; disable if using RubyLS + null-ls instead)
  "bacon_ls",   -- enabling bacon-ls for Rust (optional)
})

-- Diagnostic config (optional): enable virtual text for inline errors
vim.diagnostic.config({ virtual_text = true })

--- Old config after this point
-- local lsp_to_install   = { "ts_ls" }
-- local lsp_to_configure = {}
-- local linters_by_ft    = {}

-- if vim.fn.executable("rustc") == 1 then
--   vim.list_extend(lsp_to_install, { "rust_analyzer", "bacon", "bacon-ls", "codelldb" })
-- end

-- if vim.fn.executable("ruby") == 1 then
--   vim.list_extend(lsp_to_install,   { "ruby_lsp" })
--   vim.list_extend(lsp_to_configure, { "ruby_lsp" })
--   linters_by_ft = vim.tbl_extend("force", linters_by_ft, {
--     ruby  = { "rubocop" },
--     eruby = { "erb_lint" },
--   })
-- end

-- lsp_to_configure = vim.tbl_extend("force", {}, lsp_to_install)

-- if pcall(require, "mason") then
--   require("mason").setup()
-- end

-- if pcall(require, "mason-lspconfig") then
--   require("mason-lspconfig").setup(
--     lsp_to_install
--   )
-- end

-- if pcall(require, "lint") then
--   require("lint").linters_by_ft = linters_by_ft
-- end

-- if pcall(require, "mason-nvim-lint") then
--   require("mason-nvim-lint").setup()
-- end

-- -- Mappings.
-- -- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- local opts = { noremap = true, silent = true }
-- vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

-- -- Use an on_attach function to only map the following keys
-- -- after the language server attaches to the current buffer
-- local on_attach = function(client, bufnr)
--   -- Enable completion triggered by <c-x><c-o>
--   -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

--   -- Mappings.
--   -- See `:help vim.lsp.*` for documentation on any of the below functions
--   local bufopts = { noremap = true, silent = true, buffer = bufnr }
--   vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
--   vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
--   vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
--   vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
--   vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
--   vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
--   vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
--   vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
--   vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
--   vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
--   vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
--   vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
--   vim.keymap.set("n", "gf", function() vim.lsp.buf.format { async = true } end, bufopts)

--   if client.server_capabilities.documentFormattingProvider then
--     for _, filetype in ipairs(client.config.filetypes or {}) do
--       vim.cmd(string.format(
--         "autocmd FileType %s autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = false, timeout_ms = 1000 })", filetype))
--     end
--   end
-- end

-- if pcall(require, "cmp_nvim_lsp") then
--   local capabilities = require("cmp_nvim_lsp").default_capabilities()

--   local lspconfig = require "lspconfig"

--   for _, lsp in ipairs(lsp_to_configure) do
--     if lspconfig[lsp] and lspconfig[lsp]['setup'] then
--       lspconfig[lsp].setup {
--         capabilities = capabilities,
--         on_attach = on_attach,
--       }
--     end
--   end
-- end
