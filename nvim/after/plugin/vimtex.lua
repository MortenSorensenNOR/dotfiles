-- require("vimtex").setup()
vim.g["tex_flavor"]="latex"
vim.g["vimtex_view_method"]="zathura"
vim.g["vimtex_quickfix_mode"]=0
vim.opt["conceallevel"] = 0
-- vim.g["tex_conceal"]="abdmg"
vim.g.vimtex_compiler_latexmk = {
  aux_dir = '',
  out_dir = '',
  callback = 1,
  continuous = 1,
  executable = 'latexmk',
  hooks = {},
  options = {
    '-verbose',
    '-file-line-error',
    '-synctex=1',
    '-interaction=nonstopmode',
    '-shell-escape', -- Add this line for shell-escape
  },
}

