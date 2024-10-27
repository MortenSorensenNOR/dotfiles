function ColorMyPencils(color)
	color = color or "nord"
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "LineNr", { bg = "none" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })
end

function SwitchColorScheme(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
end

ColorMyPencils()
-- SwitchColorScheme()

-- vim.cmd[[colorscheme nord]]
-- vim.cmd[[highlight Normal guibg=#1C1D1E]]
-- vim.cmd[[highlight LineNr guibg=#1C1D1E]]
-- vim.cmd[[highlight SignColumn guibg=#1C1D1E]]
-- vim.cmd[[highlight FoldColumn guibg=#1C1D1E]]

--- Also remove the vertical bar to the left ----> (if it isnt already gone)
vim.opt.colorcolumn="0"
