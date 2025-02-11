SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 34,
    py = 34,
})
StrangeLib = { dynablind = SMODS.load_file("dynablind.lua")() }

local function compare(x, op, y)
    if op == "==" then
        return x == y
    elseif op == "~=" then
        return x ~= y
    elseif op == "<" then
        return x < y
    elseif op == "<=" then
        return x <= y
    elseif op == ">" then
        return x > y
    elseif op == ">=" then
        return x >= y
    else
        sendErrorMessage('invalid operator "' .. op .. '"', "StrangeLib.safe_compare")
    end
end

if next(SMODS.find_mod("Talisman")) then
    function StrangeLib.safe_compare(x, op, y)
        x = to_big(x)
        y = to_big(y)
        return compare(x, op, y)
    end
else
    function StrangeLib.safe_compare(x, op, y)
        x = tonumber(x)
        y = tonumber(y)
        if not x then
            sendErrorMessage("cannot convert parameter x to number", "StrangeLib.safe_compare")
        elseif not y then
            sendErrorMessage("cannot convert parameter y to number", "StrangeLib.safe_compare")
        end
        return compare(x, op, y)
    end
end
