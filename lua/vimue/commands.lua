local log = require("vimue.log")
local uegen = require("vimue.uegen")
local mod = {}

function mod.generate_build_files()
    log.pinfo("Generating build files")

    uegen.initialize_generate_data()

    -- initialize current gen data

    -- dispatch unreal build tool


end

return mod