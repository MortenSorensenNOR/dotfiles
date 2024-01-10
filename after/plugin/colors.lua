function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)
        
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })	
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

----  ColorMyPencils()

--- Also remove the vertical bar to the left ----> (if it isnt already gone)
vim.opt.colorcolumn="0"
