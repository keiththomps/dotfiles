require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { 'ruby_ls', 'sorbet', 'sumneko_lua' }
}
require("mason-null-ls").setup {
  ensure_installed = { 'stylua', 'rubocop', 'erb_lint' },
  automatic_setup = true,
  automatic_installation = false
}
require("null-ls").setup()
require("mason-null-ls").setup_handlers()
