-- Put this in your Neovim config (e.g. lua/whatever.lua)

-- Escape single quotes for MATLAB string literal
local function mquote(s)
  return s:gsub("'", "''")
end

local function run_curr_matlab_file()
  if vim.bo.modified then
    vim.cmd("write")
  end

  -- absolute path, dir, and script name (without .m)
  local filepath = vim.fn.expand("%:p")
  local dir      = vim.fn.fnamemodify(filepath, ":h")
  local script   = vim.fn.fnamemodify(filepath, ":t:r")

  -- MATLAB likes forward slashes in paths; also escape single quotes
  local dir_for_matlab = mquote(dir:gsub("\\", "/"))

  -- Run: cd to file's dir; run script; wait for all figures to close; then quit
  local matlab_r = string.format(
    [[try, cd('%s'); %s; waitfor(findall(0,'Type','figure')); catch ME, disp(getReport(ME)); end; quit]],
    dir_for_matlab,
    script
  )

  -- Build the terminal command. Use -nodesktop (not -nodisplay) so figures can show.
  local cmd = string.format([[matlab -nodesktop -nosplash -r "%s"]], matlab_r)

  -- Open a bottom split with a terminal and feed the command
  local percent_of_win = 0.4
  local curr_win_height = vim.api.nvim_win_get_height(0)
  local term_height = math.floor(curr_win_height * percent_of_win)
  vim.cmd(string.format("below %dsplit | term", term_height))

  local keys = vim.api.nvim_replace_termcodes("i" .. cmd .. "<CR>", true, false, true)
  vim.api.nvim_feedkeys(keys, "t", false)
end

vim.keymap.set({ "n" }, "<A-m>", run_curr_matlab_file, {
  desc = "Run current .m file via MATLAB in Neovim terminal",
})

