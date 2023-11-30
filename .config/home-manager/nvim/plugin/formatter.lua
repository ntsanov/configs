-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order

		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,
		},
		sql = {
			require("formatter.filetypes.sql").pgformat,
		},
		sh = {
			require("formatter.filetypes.sh").shfmt,
		},
		json = {
			require("formatter.filetypes.json").prettier,
		},
		yaml = {
			require("formatter.filetypes.yaml").prettier,
		},
		nix = {
			require("formatter.filetypes.nix").nixfmt,
		},
		html = {
			require("formatter.filetypes.html").prettier,
		},
		markdown = {
			require("formatter.filetypes.markdown").prettier,
		},
		go = {
			require("formatter.filetypes.go").gofumpt,
			require("formatter.filetypes.go").golines,
			require("formatter.filetypes.go").goimports,
		},
		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
