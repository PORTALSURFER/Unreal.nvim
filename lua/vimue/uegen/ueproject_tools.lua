local log = require("vimue.log")

local mod = {}

function mod.find_uproject_file()
	log.info("Finding uproject file")
    local current_buffer_name = vim.api.nvim_buf_get_name(0)
	if current_buffer_name == "" then
		log.warn("No buffer name found")
		return nil
	end
	log.info("Current buffer name: " .. current_buffer_name)

    local current_path = vim.fn.fnamemodify(current_buffer_name, ":p:h")
    while current_path ~= "" and current_path ~= "/" do
        local match = vim.fn.glob(current_path .. "/*.uproject")
        if match ~= "" then
	        log.info("Found uproject file: " .. match)
            return match
        else
        current_path = vim.fn.fnamemodify(current_path, ":h")
        end
    end
	log.warn("No uproject file found")
    return nil
end

function mod.get_project_name(uproject_file_path)
	log.info("Getting name of the currently opened ue project")
	local uproject_name = vim.fn.fnamemodify(uproject_file_path, ":t:r")
	log.info("Found uproject file: " .. uproject_name)
	return uproject_name
end

function mod.get_project_directory(uproject_file_path)
	log.info("Getting directory of the currently opened ue project")
    local project_directory = vim.fn.fnamemodify(uproject_file_path, ":p:h")
	log.info("Found project directory: " .. project_directory)
	return project_directory
end

return mod