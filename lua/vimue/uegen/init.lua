local log = require("vimue.log")

local mod = {}

local function SplitString(str)
    -- Split a string into lines
    local lines = {}
    for line in string.gmatch(str, "[^\r\n]+") do
        table.insert(lines, line)
    end
    return lines
end

local function create_new_config_file(project_name, config_file_path)
	log.info("Creating a new config file")

	local configContents = [[
            {
                "version" : "0.0.2",
                "_comment": "dont forget to escape backslashes in EnginePath",    
                "EngineDir": "",
                "Targets":  [
            
                    {
                        "TargetName" : "]] .. project_name .. [[-Editor",
                        "Configuration" : "DebugGame",
                        "withEditor" : true,
                        "UbtExtraFlags" : "",
                        "PlatformName" : "Win64"
                    },
                    {
                        "TargetName" : "]] .. project_name .. [[",
                        "Configuration" : "DebugGame",
                        "withEditor" : false,
                        "UbtExtraFlags" : "",
                        "PlatformName" : "Win64"
                    },
                    {
                        "TargetName" : "]] .. project_name .. [[-Editor",
                        "Configuration" : "Development",
                        "withEditor" : true,
                        "UbtExtraFlags" : "",
                        "PlatformName" : "Win64"
                    },
                    {
                        "TargetName" : "]] .. project_name .. [[",
                        "Configuration" : "Development",
                        "withEditor" : false,
                        "UbtExtraFlags" : "",
                        "PlatformName" : "Win64"
                    },
                    {
                        "TargetName" : "]] .. project_name .. [[-Editor",
                        "Configuration" : "Shipping",
                        "withEditor" : true,
                        "UbtExtraFlags" : "",
                        "PlatformName" : "Win64"
                    },
                    {
                        "TargetName" : "]] .. project_name .. [[",
                        "Configuration" : "Shipping",
                        "withEditor" : false,
                        "UbtExtraFlags" : "",
                        "PlatformName" : "Win64"
                    }
                ]
            }
                ]]
	log.pinfo(
		"Please populate the configuration for the Unreal project, especially EnginePath, the path to the Unreal Engine"
	)

	vim.cmd("new " .. config_file_path)
	vim.cmd("setlocal buftype=")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, SplitString(configContents))
end

local function ensure_project_config_file(project_path, project_name)
	local config_file_name = "vimue.json"
	local config_file_path = project_path .. "/" .. config_file_name
	local config_file = io.open(config_file_path, "r")

	if not config_file then
		log.info("No config file found, creating a new one")
		create_new_config_file(project_name, config_file_path)
	end
end

local GenData = {
	project_name = nil,
	project_directory = nil,
}

mod.project_tools = require("vimue.uegen.ueproject_tools")

function mod.initialize_generate_data()
	log.info("Initializing build generate data")
    local uproject_file_path = mod.project_tools.find_uproject_file()
	GenData.project_directory = mod.project_tools.get_project_directory(uproject_file_path)
	GenData.project_name = mod.project_tools.get_project_name(uproject_file_path)

	ensure_project_config_file(GenData.project_directory, GenData.project_name)
end

return mod
