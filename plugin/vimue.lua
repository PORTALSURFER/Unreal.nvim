local init = require("vimue.init")

init.run()

-- -- [[Link Commands]]
-- vim.api.nvim_create_user_command("UnrealGen", function(opts)
--     require("unreal.commands").generateCommands(opts)
-- end, {
-- })

-- vim.api.nvim_create_user_command("UnrealGenWithEngine", function(opts)
--     if not opts then
--         opts = {}
--     end

--     opts.WithEngine = true
--     require("unreal.commands").generateCommands(opts)
-- end, {
-- })

-- vim.api.nvim_create_user_command("UnrealBuild", function(opts)
--     require("unreal.commands").build(opts)
-- end, {
-- })

-- vim.api.nvim_create_user_command("UnrealRun", function(opts)
--     require("unreal.commands").run(opts)
-- end, {
-- })

-- vim.api.nvim_create_user_command("UnrealCD", function(opts)
--     require("unreal.commands").SetUnrealCD(opts)
-- end, {
-- })

-- function setup(args)
--     print("setting up plugin")
-- end
