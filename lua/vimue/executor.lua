local log = require("vimue.log")

local mod = {
	last_update_time = nil,
	update_timer = nil,
	callback_timer = nil,
	task_coroutine = nil,
	tasks = nil,
	current_task = nil,
}

local TaskState = {
	scheduled = "scheduled",
	inprogress = "inprogress",
	completed = "completed",
}

local function closure(func, data)
	return function()
		func(data)
	end
end

local function on_status_update() end

function mod.logic_update()
	if mod.task_coroutine then
		if coroutine.status(mod.task_coroutine) ~= "dead" then
			local ok, errmsg = coroutine.resume(mod.task_coroutine)
			if not ok then
				mod.task_coroutine = nil
				log.error(errmsg)
			end
		else
			mod.task_coroutine = nil
		end
	end
	vim.defer_fn(on_status_update, 1)
end

function mod.safe_logic_update()
	local success, errmsg = pcall(function()
		mod.logic_update()
	end)

	if not success then
		log.error(errmsg)
	end
	vim.defer_fn(mod.safe_logic_update, 1)
end

function mod:get_task_status(task_name)
    local status = self.tasks[task_name]
    if not status then
       status = "none"
    end
    return status
end

local function update_loop()
	local elapsedTime = vim.loop.now() - mod.last_update_time
	-- executor:ui_update(elapsedTime)
	mod.last_update_time = vim.loop.now()
end

local function safe_update_loop()
	local success, errmsg = pcall(update_loop)
	if not success then
		log.terror(errmsg)
	end
end

function mod:set_task_status(task_name, new_status)
    if (self.current_task ~= "" and self.current_task ~= task_name) and (self:get_task_status(self.current_task) ~= TaskState.completed) then
        log.tinfo("Cannot start a new task. Current task still in progress " .. self.current_task)
        log.tinfo("Cannot start a new task. Current task still in progress " .. self.current_task)
        return
    end
    log.tinfo("Set Task Status: " .. task_name .. "->" .. new_status)
    self.current_task = task_name
    self.tasks[task_name] = new_status
end



function mod.schedule_task(task_name)
	log.info("ScheduleTask: " .. task_name)
	mod:set_task_status(task_name, TaskState.scheduled)
end

function mod:clear_tasks()
    log.tinfo("Clearing tasks")
	mod.tasks = {}
	mod.current_task = ""
end

function mod.start_executing()
    log.tinfo("Start Executing Tasks")
	-- if executor.callback_timer then
	-- 	return
	-- end

	-- executor.last_update_time = vim.loop.now()
	-- executor.update_timer = 0

	-- -- UI update loop
	-- executor.callback_timer = vim.loop.new_timer()
	-- executor.callback_timer:start(1, 30, vim.schedule_wrap(safe_update_loop))

	-- coroutine update loop
	vim.schedule(function()
		mod.safe_logic_update()
	end)
end

return mod