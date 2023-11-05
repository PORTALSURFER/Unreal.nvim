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

local function prompt_build_target_index(gen_data)
    print("target to build:")
    for i, x in ipairs(gen_data.targets) do
        local configName = x.configuration
        if x.with_editor then
            configName = configName .. "-Editor"
        end
        print(tostring(i) .. ". " .. configName)
    end
    return tonumber(vim.fn.input "<number> : ")
end

local function create_new_config_file(project_name, config_file_path)
	log.info("Creating a new config file")

	local config_contents = [[
            {
                "version" : "0.0.1",
                "engine_directory": "",
                "targets":  [
                    {
                        "target_name" : "]] .. project_name .. [[-Editor",
                        "configuration" : "DebugGame",
                        "with_editor" : true,
                        "unreal_build_tool_flags" : "",
                        "platform_name" : "Win64"
                    },
                    {
                        "target_name" : "]] .. project_name .. [[",
                        "configuration" : "DebugGame",
                        "with_editor" : false,
                        "unreal_build_tool_flags" : "",
                        "platform_name" : "Win64"
                    },
                    {
                        "target_name" : "]] .. project_name .. [[-Editor",
                        "configuration" : "Development",
                        "with_editor" : true,
                        "unreal_build_tool_flags" : "",
                        "platform_name" : "Win64"
                    },
                    {
                        "target_name" : "]] .. project_name .. [[",
                        "configuration" : "Development",
                        "with_editor" : false,
                        "unreal_build_tool_flags" : "",
                        "platform_name" : "Win64"
                    },
                    {
                        "target_name" : "]] .. project_name .. [[-Editor",
                        "configuration" : "Shipping",
                        "with_editor" : true,
                        "unreal_build_tool_flags" : "",
                        "platform_name" : "Win64"
                    },
                    {
                        "target_name" : "]] .. project_name .. [[",
                        "configuration" : "Shipping",
                        "with_editor" : false,
                        "unreal_build_tool_flags" : "",
                        "platform_name" : "Win64"
                    }
                ]
            }
                ]]
	log.pinfo(
		"Please populate the configuration for the Unreal project, especially EnginePath, the path to the Unreal Engine"
	)

	vim.cmd("new " .. config_file_path)
	vim.cmd("setlocal buftype=")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, SplitString(config_contents))
end

local function MakeUnixPath(win_path)
    if not win_path then
        logError("MakeUnixPath received a nil argument")
        return;
    end
    -- Convert backslashes to forward slashes
    local unix_path = win_path:gsub("\\", "/")

    -- Remove duplicate slashes
    unix_path = unix_path:gsub("//+", "/")

    return unix_path
end

local function load_project_config_file(gen_data)
	local config_file_name = "vimue.json"
	local config_file_path = gen_data.project_directory .. "/" .. config_file_name
    local config_file_path = MakeUnixPath(config_file_path)
	local config_file = io.open(config_file_path, "r")

    -- create a new config if one was not found 
	if not config_file then
		log.warn("No config file found, creating a new one, please save and retry")
		create_new_config_file(gen_data.project_name, config_file_path)
        return nil
	end

    local content = config_file:read("*all")
    config_file:close()

    -- todo move this out of here
    local current_version = "0.0.1" 

    local data = vim.fn.json_decode(content)

    -- todo, ensure that the engine path is valid somewhere
    if data and (data.version ~= current_version) then
        log.error("Config file version mismatch, please update the config file")
    end
    
    gen_data.version = data.version
    gen_data.engine_directory = data.engine_directory
    gen_data.targets = data.targets
end

local GenData = {
    target_name_suffix = nil,
    engine_directory = nil,
	project_name = nil,
	project_directory = nil,
    unreal_build_tool_path = nil,
    unreal_engine_build_batch_file = nil,
    uproject_path = nil,
}

mod.project_tools = require("vimue.uegen.ueproject_tools")

function mod.initialize_generate_data()
	log.info("Initializing build generate data")
    GenData.uproject_path = mod.project_tools.find_uproject_file()
	GenData.project_directory = mod.project_tools.get_project_directory(GenData.uproject_path)
	GenData.project_name = mod.project_tools.get_project_name(GenData.uproject_path)

	load_project_config_file(GenData)

    GenData.unreal_build_tool_path = "\"" .. GenData.engine_directory .."/Engine/Binaries/DotNET/UnrealBuildTool.exe\""
    GenData.unreal_engine_build_batch_file = "\"" .. GenData.engine_directory .."/Engine/Build/BatchFiles/Build.bat\""
    GenData.uproject_path = "\"" .. GenData.project_directory .. "/" .. 
    GenData.project_name .. ".uproject\""

    local desired_target_index = prompt_build_target_index(GenData)

    GenData.target_name_suffix = ""
    if GenData.targets.with_editor then
        GenData.target_name_suffix = "Editor"
    end
    log.info("Using engine at: " .. GenData.engine_directory)
    return GenData
end

return mod
