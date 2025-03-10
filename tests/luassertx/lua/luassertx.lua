local a = require "plenary.async"
local assert = require "luassert"

local function wait_for(_, arguments)
    ---@type fun() @Function to execute until it does not error.
    local assertions_fn = arguments[1]
    ---@type number @Timeout in milliseconds. Defaults to 5000.
    local timeout = arguments[2]
    timeout = timeout or 15000

    local start = vim.loop.hrtime()
    local is_ok, err
    repeat
        is_ok, err = pcall(assertions_fn)
        if not is_ok then
            a.util.sleep(math.min(timeout, 100))
        end
    until is_ok or ((vim.loop.hrtime() - start) / 1e6) > timeout

    if not is_ok then
        error(err)
    end

    return is_ok
end

assert:register("assertion", "wait_for", wait_for)
