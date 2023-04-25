return {
  "dense-analysis/neural",
  event = "VeryLazy",
  config = function()
    require("neural").setup({
      source = {
        openai = {
          api_key = vim.env.OPENAI_API_KEY,
        },
      },
    })
  end,
}
