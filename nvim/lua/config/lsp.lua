local lsp_to_install
local lsp_to_configure
local linters_by_ft

if os.getenv("SHOPIFY") then
  lsp_to_install = { "ruby_lsp" }
  lsp_to_configure = { "ruby_lsp" }

  linters_by_ft = {
    ruby = { "rubocop" },
    eruby = { "erb_lint" },
  }
else
  lsp_to_install = { "lua_ls", "elixirls", "ruby_lsp" }
  lsp_to_configure = lsp_to_install
  linters_by_ft = {}
end

if pcall(require, "mason") then
  require("mason").setup()
end

if pcall(require, "mason-lspconfig") then
  require("mason-lspconfig").setup()
end

if pcall(require, "lint") then
  require("lint").linters_by_ft = linters_by_ft
end

if pcall(require, "mason-nvim-lint") then
  require("mason-nvim-lint").setup()
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "gf", function() vim.lsp.buf.format { async = true } end, bufopts)

  if client.server_capabilities.documentFormattingProvider then
    for _, filetype in ipairs(client.config.filetypes or {}) do
      vim.cmd(string.format(
        "autocmd FileType %s autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = false, timeout_ms = 1000 })", filetype))
    end
  end
end

if pcall(require, "cmp_nvim_lsp") then
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  local lspconfig = require "lspconfig"

  for _, lsp in ipairs(lsp_to_configure) do
    if lspconfig[lsp] and lspconfig[lsp]['setup'] then
      lspconfig[lsp].setup {
        capabilities = capabilities,
        on_attach = on_attach,
      }
    end
  end
end
