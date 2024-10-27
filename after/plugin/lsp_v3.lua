require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd",
        "pyright",
        "texlab",
        "verible"
    },
})

local function filter(arr, func)
    local new_index = 1
    local size_orig = #arr
    for old_index, v in ipairs(arr) do
        if func(v, old_index) then
            arr[new_index] = v
            new_index = new_index + 1
        end
    end
    for i = new_index, size_orig do arr[i] = nil end
end

local function pyright_accessed_filter(diagnostic)
    if string.match(diagnostic.message, '".+" is not accessed') then
        return false
    end

    return true
end

local function custom_on_publish_diagnostics(a, params, client_id, c, config)
    filter(params.diagnostics, pyright_accessed_filter)
    vim.lsp.diagnostic.on_publish_diagnostics(a, params, client_id, c, config)
end

local cmp = require("cmp")
cmp.setup({
    preselect = 'none',
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
        ['<Up>'] = function(fallback)
            if cmp.visible() then
                cmp.close()
            end
            fallback()
        end,
        ['<Down>'] = function(fallback)
            if cmp.visible() then
                cmp.close()
            end
            fallback()
        end,
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<Enter>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete()

    }),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lsp_signature_help" },
	}),
})

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
local lsp_attach = function(client, bufnr) -- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v1.x/doc/md/lsp.md#you-might-not-need-lsp-zero
    local opts = { buffer = bufnr, remap = false }
    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.lsp.buf.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.lsp.buf.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.lsp.buf.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts);

    if client.name == "pyright" then
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(custom_on_publish_diagnostics, {})
    end

    -- Does not work, but sure would be nice
    if client.name == "verible" then
        vim.diagnostic.config({
            virtual_text = {
                severity = vim.diagnostic.severity.ERROR, -- Show only errors in virtual text
            },
            signs = {
                severity = vim.diagnostic.severity.ERROR, -- Show only errors in signs
            },
            underline = {
                severity = vim.diagnostic.severity.ERROR, -- Underline only errors
            },
        }, bufnr)
    end
end

-- HDL Checker setup
-- if not require'lspconfig.configs'.hdl_checker then
--     require'lspconfig.configs'.hdl_checker = {
--         default_config = {
--             cmd = {"hdl_checker", "--lsp", };
--             filetypes = {"vhdl", "verilog", "systemverilog"};
--             root_dir = function(fname)
--                 -- will look for the .hdl_checker.config file in parent directory, a
--                 -- .git directory, or else use the current directory, in that order.
--                 local util = require'lspconfig'.util
--                 return util.root_pattern('.hdl_checker.config')(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
--             end;
--             settings = {};
--         };
--     }
-- end

-- require'lspconfig'.hdl_checker.setup{}

local lspconfig = require("lspconfig")
lspconfig.verible.setup({
    cmd = { 'verible-verilog-ls','--rules_config_search', '--rules=-no-trailing-spaces', 'autofix=patch-interactive'}
})

local get_servers = require("mason-lspconfig").get_installed_servers
for _, server_name in ipairs(get_servers()) do
	lspconfig[server_name].setup({
		on_attach = lsp_attach,
		capabilities = lsp_capabilities,
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
			},
		},
	})
end

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

