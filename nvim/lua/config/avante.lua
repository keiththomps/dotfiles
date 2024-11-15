require('avante_lib').load()
require('avante').setup({
  provider = "openai",
  openai = {
    endpoint = os.getenv("OPENAI_API_CHAT_COMPLETIONS"),
    model = "anthropic:claude-3-5-sonnet",
    timeout = 30000, -- Timeout in milliseconds
    temperature = 0,
    max_tokens = 4096,
    ["local"] = false,
  },
  behaviour = {
    auto_suggestions = true, -- Experimental stage
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
  },
})
