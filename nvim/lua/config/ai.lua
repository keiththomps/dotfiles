local default_adapter = os.getenv("SHOPIFY") and "shopify" or "copilot"

require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = default_adapter
    },
    inline = {
      adapter = default_adapter
    },
  },
  adapters = {
    shopify = function()
      return require("codecompanion.adapters").extend("openai_compatible", {
        env = {
          url = os.getenv("OPENAI_API_BASE"),
          api_key = os.getenv("OPENAI_API_KEY"),
        },
        schema = {
          default = "anthropic:claude-3-7-sonnet-20250219",
          model = {
            choices = {
              ["anthropic:claude-3-7-sonnet-20250219"] = { opts = { can_reason = true } },
            },
          },
        },
      })
    end,
  }
})
