local lsp_to_install

if os.getenv("SPIN") then
  lsp_to_install = { "ruby_ls", "erb-lint" }
else
  lsp_to_install = { "elixirls" }
end

require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = {
    "lua_ls",
    unpack(lsp_to_install),
  },
}

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

  if client.resolved_capabilities.document_formatting then
    for _, filetype in ipairs(client.config.filetypes) do
      vim.cmd(string.format(
        "autocmd FileType %s autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)", filetype))
    end
  end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local lspconfig = require "lspconfig"

local lsps = { "ruby_ls", "lua_ls", "elixirls", "sorbet", "luau_lsp", "tsserver" }

for _, lsp in ipairs(lsps) do
  if lspconfig[lsp] then
    lspconfig[lsp].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      flags = lsp_flags,
    }
  end
end
