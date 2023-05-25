require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = {
    "lua_ls",
  },
}

require("mason-null-ls").setup {
  ensure_installed = {
    "stylua",
  },
  automatic_installation = false,
  handlers = {},
}

local null_ls = require "null-ls"

local conditional = function(fn)
  local utils = require("null-ls.utils").make_conditional_utils()
  return fn(utils)
end

null_ls.setup {
  sources = {
    conditional(
      function(utils)
        return utils.root_has_file "Gemfile"
            and null_ls.builtins.formatting.rubocop.with {
              command = "bundle",
              args = vim.list_extend({ "exec", "rubocop" }, null_ls.builtins.formatting.rubocop._opts.args),
            }
          or null_ls.builtins.formatting.rubocop
      end
    ),
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
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local lspconfig = require "lspconfig"

lspconfig["ruby_ls"].setup {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
}
lspconfig["sorbet"].setup {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
}
lspconfig["luau_lsp"].setup {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
}
lspconfig["tsserver"].setup {
  capabilities = capabilities,
  on_attach = on_attach,
  flags = lsp_flags,
}
