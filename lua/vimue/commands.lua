local log = require("vimue.log")
local executor = require("vimue.executor")
local uegen = require("vimue.uegen")

local mod = {}

-- function executor:ui_update(delta)
--     local animFrameCount = 4
--     local animFrameDuration = 200
--     local animDuration = animFrameCount * animFrameDuration

--     local anim = {
--     "▌",
-- 			"▀",
-- 			"▐",
-- 			"▄"
--     }
--     local anim1 = {
--     "1",
-- 			"2",
-- 			"3",
-- 			"4"
--     }
--     if anim_data then
--         anim = anim_data.frames
--         animFrameDuration = anim_data.interval
--         animFrameCount = #anim
--         animDuration = animFrameCount * animFrameDuration
--     end

--     local index = 1 + (math.floor(math.fmod(vim.loop.now(), animDuration) / animFrameDuration))
--     rendered_anim = (anim[index] or "")
-- end

local compile_commands_path = ""

local function generate_commands_coroutine(gen_data)
	log.tinfo("Generating clang-compatible at \"compile_commands.json\"")
	-- -- Commands:SetCurrentAnimation("kirbyFlip")
	coroutine.yield()
	executor.clear_tasks()

	local editor_flag = ""
	if gen_data.with_editor then
	 	log.tinfo("Building editor")
	 	editor_flag = "-Editor"
	end

	executor.schedule_task("gencmd", gen_data)
	-- local cmd = gen_data.ubtPath
	-- 	.. " -mode=GenerateClangDatabase -project="
	-- 	.. gen_data.projectPath
	-- 	.. " -game -engine "
	-- 	.. gen_data.target.UbtExtraFlags
	-- 	.. " "
	-- 	.. editorFlag
	-- 	.. " "
	-- 	.. gen_data.prjName
	-- 	.. gen_data.targetNameSuffix
	-- 	.. " "
	-- 	.. gen_data.target.Configuration
	-- 	.. " "
	-- 	.. gen_data.target.PlatformName

	-- log.info("Dispatching command: " .. cmd)
	-- compile_commands_path = gen_data.prjDir .. "/compile_commands.json"
	-- vim.api.nvim_command("Dispatch " .. cmd)
	-- log.info("Dispatched")
end

local function dispatch_callback_coroutine(data)
	coroutine.yield()
	-- if not data then
	--     log.info("data was nil")
	-- end
	-- log.info("DispatchCallbackCoroutine()")
	-- log.info("DispatchCallbackCoroutine() task=".. gen_data:GetTaskAndStatus())
	-- if data == "gencmd" and gen_data:GetTaskStatus("gencmd") == TaskState.scheduled then
	--     gen_data:set_task_status("gencmd", TaskState.inprogress)
	--     executor.task_coroutine = coroutine.create(Stage_UbtGenCmd)
	-- elseif data == "headers" and gen_data:GetTaskStatus("headers") == TaskState.inprogress then
	--     executor.task_coroutine = coroutine.create(Stage_GenHeadersCompleted)
	-- end
end

local function dispatch_unreal_nvim_callback(data)
	log.info("Dispatch Unreal nvim Callback")
	executor.task_coroutine = coroutine.create(closure(dispatch_callback_coroutine, data))
end


function mod.generate_build_files()
	log.pinfo("Generating build files")
	local gen_data = uegen.initialize_generate_data()

	-- local generate_cmd_auto_command_id = vim.api.nvim_create_autocmd("ShellCmdPost", {
	-- 	pattern = "*",
	-- 	callback = closure(dispatch_unreal_nvim_callback, "gencmd"),
	-- })

	-- log.info("listening for ShellCmdPost events")
	-- log.info("compiler set to msvc")

	executor.task_coroutine = coroutine.create(
        function() generate_commands_coroutine(gen_data) 
        end)
	executor.start_executing()
end

return mod
