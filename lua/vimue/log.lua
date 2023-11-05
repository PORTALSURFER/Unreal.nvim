local mod = {}

-- available log levels
local levels = {
    ERROR = "ERROR",
    WARNING = "WARNING",
    INFO = "INFO",
    THREAD_ERROR = "THREAD ERROR",
    THREAD_WARNING = "THREAD WARNING",
    THREAD_INFO = "THREAD INFO",
}

-- this function is used to log messages to a file
-- the file can be found in the nvim-data folder
local function log(level, message)
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
    log(levels.ERROR, message)
    vim.api.nvim_err_writeln("Error: " .. message)
    error()
end

function mod.warn(message)
    log(levels.WARNING, message)
    vim.api.nvim_err_writeln("THREAD Warning: " .. message)
    error()
end

function mod.info(message)
    log(levels.INFO, message)
end

function mod.pinfo(message)
    vim.api.nvim_out_write(message)
    mod.info(message)
end

-- thread logs
function mod.tinfo(message)
    log(levels.THREAD_INFO, message)
end

function mod.terror(message)
    log(levels.THREAD_ERROR, message)
    vim.api.nvim_err_writeln("THREAD  Error: " .. message)
    error()
end

function mod.twarn(message)
    log(levels.THREAD_WARNING, message)
    vim.api.nvim_err_writeln("THREAD Warning: " .. message)
    error()
end

return mod