local log = require("vimue.log")

local mod = {}

function mod.prevent_leading_again()
	if vim.g.loaded_vimuenvim == 1 then
		log.info("Vimuenvim is already loaded")
		return
	end
	vim.g.loaded_vimuenvim = 1
end

function mod.checks()

	log.info("Initializing vimue")

	if 1 ~= vim.fn.has("nvim-0.7.0") then
		vim.api.nvim_err_writeln("vimue.nvim requires at least nvim-0.7.0")
		log.error("vimue.nvim requires at least nvim-0.7.0")
		return
	end
end

function mod.initialize_commands()
	vim.api.nvim_create_user_command("UnrealGenerateBuildFiles", function(opts)
		require("vimue.commands").generate_build_files(opts)
	end, {
	})
end

function mod.run()
	mod.prevent_leading_again()
	mod.checks()
	mod.initialize_commands()
end

return mod
