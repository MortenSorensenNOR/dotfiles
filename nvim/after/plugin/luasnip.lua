local ls = require("luasnip")

ls.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}

-- Load snippets from friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Define the snippet
ls.snippets = {
    tex = {
        ls.parser.parse_snippet("itemize", "\\begin{itemize}\n\t\\item $0\n\\end{itemize}")
    }
}

-- Expand or jump to the next snippet's position
vim.api.nvim_set_keymap("i", "<C-k>", "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-k>'", {silent = true, expr = true})
