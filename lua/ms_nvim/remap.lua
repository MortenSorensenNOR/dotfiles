vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move around selected text
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv")

-- Activate visual mode with Shift + arrowKey
--vim.api.nvim_set_keymap('n', '<S-Up>', 'v', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<S-Down>', 'v', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<S-Left>', 'v', { noremap = true, silent = true })
--vim.api.nvim_set_keymap('n', '<S-Right>', 'v', { noremap = true, silent = true })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- This is going to get me cancelled
vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

-- Weird shit
vim.keymap.set('i', '<C-BP>', '<C-W>', { noremap = true })

-- Define a function to move to the end of the line
function move_to_end_of_line()
    vim.fn.execute('normal! $')
end

-- Map Ctrl + Right to move to the end of the line
vim.keymap.set({ "n", "i" }, '<C-S-Right>', '<Cmd>lua move_to_end_of_line()<CR>', { noremap = true, silent = true })

-- Map Ctrl + Left to move to the beginning of the line
vim.keymap.set({ 'n', 'i' }, '<C-S-Left>', '<Cmd>normal! 0<CR>', { noremap = true, silent = true })

-- Map Ctrl + Up and Ctrl + Down to scroll without changing cursor position
vim.api.nvim_set_keymap('n', '<C-Up>', '<Cmd>normal! k<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-Down>', '<Cmd>normal! j<CR>', { noremap = true, silent = true })

vim.opt.whichwrap:append {
    ['<'] = true,
    ['>'] = true,
    ['['] = true,
    [']'] = true,
    h = true,
    l = true,
}
