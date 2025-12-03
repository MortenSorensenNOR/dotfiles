-- run_python.lua
local function run_curr_python_file()
  -- Save current buffer if modified
  if vim.bo.modified then
    vim.cmd("write")
  end

  -- Get file name in the current buffer
  local file_name = vim.api.nvim_buf_get_name(0)

  -- Build the command to run via uv
  -- Default: use the std Python interpreter managed by uv
  -- If you prefer IPython via uv, swap the next line for:
  --   local cmd = 'uvx ipython "' .. file_name .. '"'
  local cmd = 'uv run python "' .. file_name .. '"'

  -- Turn it into terminal keys (enter insert mode, type command, press <CR>)
  local keys = vim.api.nvim_replace_termcodes("i" .. cmd .. "<CR>", true, false, true)

  -- Determine terminal window split and launch terminal
  local percent_of_win = 0.4
  local curr_win_height = vim.api.nvim_win_get_height(0)
  local term_height = math.floor(curr_win_height * percent_of_win)
  vim.cmd(":below " .. term_height .. "split | term")

  -- Feed keys to execute the command in the terminal
  vim.api.nvim_feedkeys(keys, "t", false)
end

vim.keymap.set({ "n" }, "<A-u>", "", {
  desc = "Run .py file via uv in Neovim built-in terminal",
  callback = run_curr_python_file,
})
