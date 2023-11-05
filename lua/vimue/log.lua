local mod = {}

-- available log levels
mod.levels = {
    ERROR = "ERROR",
    WARNING = "WARNING",
    INFO = "INFO",
}

-- this function is used to log messages to a file
-- the file can be found in the nvim-data folder
function mod.log(level, message)
    local path = vim.fn.stdpath("data") .. '/vimue.log'
    local file = io.open(path, "a")

    if file == nil then
        vim.api.nvim_err_writeln("Loading logger failed: " .. err)
        return
    end

    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logMessage = string.format("[%s] [%s]\t| %s\n", timestamp, level, message)

    file:write(logMessage)
    file:close()
end

-- helper functions
function mod.error(message)
    mod.log(mod.levels.ERROR, message)
    error(mod.levels.ERROR, message)
end

function mod.warning(message)
    mod.log(mod.levels.WARNING, message)
end

function mod.info(message)
    mod.log(mod.levels.INFO, message)
end 

function mod.pinfo(message)
    print(message)
    mod.info(message)
end

return mod