-- after/plugin/lsp.lua

-- Mason installer plumbing
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd", "pyright", "texlab", "verible", "lua_ls", "eslint" },
})

-- nvim-cmp
local cmp = require("cmp")
cmp.setup({
  preselect = "none",
  completion = { completeopt = "menu,menuone,noinsert,noselect" },
  snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<Up>"] = function(fb) if cmp.visible() then cmp.close() end; fb() end,
    ["<Down>"] = function(fb) if cmp.visible() then cmp.close() end; fb() end,
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"]   = cmp.mapping.select_next_item(),
    ["<CR>"]    = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
  }),
})

local lspconfig    = require("lspconfig")
local util         = require("lspconfig.util")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Keymaps + per-client tweaks
local function lsp_attach(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K",  function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd",  function() vim.lsp.buf.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "<leader>ge", function() vim.diagnostic.setloclist() end, opts)

  -- Verible: show only errors
  if client.name == "verible" then
    vim.diagnostic.config({
      virtual_text = { severity = vim.diagnostic.severity.ERROR },
      signs        = { severity = vim.diagnostic.severity.ERROR },
      underline    = { severity = vim.diagnostic.severity.ERROR },
    }, bufnr)
  end
end

-- Optional: filter one noisy Pyright message ("is not accessed")
local function filter(arr, pred)
  local j, n = 1, #arr
  for _, v in ipairs(arr) do if pred(v) then arr[j] = v; j = j + 1 end end
  for i = j, n do arr[i] = nil end
end
local function pyright_accessed_filter(diag)
  return not string.match(diag.message, '".+" is not accessed')
end
local function custom_on_publish_diagnostics(a, params, client_id, c, config)
  filter(params.diagnostics, pyright_accessed_filter)
  vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
end

-- Global diagnostics UI
vim.diagnostic.config({
  virtual_text = true,
  signs = false,
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- --------- Pyright: configure ONCE + dedupe protection ---------

-- global guard so even if this file is sourced twice, we don't double-setup
if not _G.__PYRIGHT_SETUP_DONE then
  _G.__PYRIGHT_SETUP_DONE = true

  lspconfig.pyright.setup({
    on_attach = function(client, bufnr)
      -- keep your custom pyright diagnostic filter
      vim.lsp.handlers["textDocument/publishDiagnostics"] =
        vim.lsp.with(custom_on_publish_diagnostics, {})
      lsp_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "openFilesOnly",
          typeCheckingMode = "basic",
          diagnosticSeverityOverrides = {
            reportAssignmentType = "none",
          },
        },
      },
    },
  })

  -- If another plugin/file spawns a duplicate Pyright, kill the extras.
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("PyrightDedupe", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client or client.name ~= "pyright" then return end
      local root = client.config.root_dir
      for _, other in ipairs(vim.lsp.get_active_clients({ name = "pyright" })) do
        if other.id ~= client.id and other.config and other.config.root_dir == root then
          other.stop(true)
        end
      end
    end,
  })
end

-- --------- Verible: configure ONCE + dedupe protection ---------

if not _G.__VERIBLE_SETUP_DONE then
  _G.__VERIBLE_SETUP_DONE = true

  lspconfig.verible.setup({
    on_attach = lsp_attach,
    capabilities = capabilities,
    cmd = {
      "verible-verilog-ls",
      "--rules_config_search",
      "--rules=-no-trailing-spaces, -parameter-name-style, -line-length, -explicit-parameter-storage-type",
      "autofix=patch-interactive",
    },
  })

  -- Kill duplicate Verible instances
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("VeribleDedupe", { clear = true }),
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client or client.name ~= "verible" then return end
      local root = client.config.root_dir
      for _, other in ipairs(vim.lsp.get_active_clients({ name = "verible" })) do
        if other.id ~= client.id and other.config and other.config.root_dir == root then
          other.stop(true)
        end
      end
    end,
  })
end

-- --------- Other servers (configured once) ---------

-- Lua
lspconfig.lua_ls.setup({
  on_attach = lsp_attach,
  capabilities = capabilities,
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})

-- -- Verible
-- lspconfig.verible.setup({
--   on_attach = lsp_attach,
--   capabilities = capabilities,
--   cmd = {
--     "verible-verilog-ls",
--     "--rules_config_search",
--     "--rules=-no-trailing-spaces",
--     "autofix=patch-interactive",
--   },
-- })

-- ESLint
lspconfig.eslint.setup({
  on_attach = lsp_attach,
  capabilities = capabilities,
  root_dir = function(fname)
    return util.root_pattern(
      ".eslintrc",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.yaml",
      ".eslintrc.yml",
      "package.json",
      ".git"
    )(fname) or util.find_git_ancestor(fname)
  end,
})

-- -- HDL Checker (custom server)
-- if not require("lspconfig.configs").hdl_checker then
--   require("lspconfig.configs").hdl_checker = {
--     default_config = {
--       cmd = { "hdl_checker", "--lsp" },
--       filetypes = { "vhdl", "verilog", "systemverilog" },
--       root_dir = function(fname)
--         local util2 = require("lspconfig").util
--         return util2.root_pattern(".hdl_checker.config")(fname)
--             or util2.find_git_ancestor(fname)
--             or util2.path.dirname(fname)
--       end,
--       settings = {},
--     },
--   }
-- end
-- lspconfig.hdl_checker.setup({ on_attach = lsp_attach, capabilities = capabilities })

-- Any other installed servers (skip ones we configured above)
local skip = { pyright = true, lua_ls = true, verible = true, eslint = true} --, hdl_checker = true 
for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
  if not skip[server] and lspconfig[server] then
    lspconfig[server].setup({
      on_attach = lsp_attach,
      capabilities = capabilities,
    })
  end
end
