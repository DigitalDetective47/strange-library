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

function StrangeLib.bulk_add(dest, src)
    local old_length = #dest
    for index, item in ipairs(src) do
        dest[old_length + index] = item
    end
end

SMODS.load_file("fcalc.lua")()

function StrangeLib.make_boosters(base_key, normal_poses, jumbo_poses, mega_poses, common_values, pack_size)
    pack_size = pack_size or 3
    for index, pos in ipairs(normal_poses) do
        local t = copy_table(common_values)
        t.key = base_key .. "_normal_" .. index
        t.pos = pos
        t.config = { extra = pack_size, choose = 1 }
        t.cost = 4
        SMODS.Booster(t)
    end
    for index, pos in ipairs(jumbo_poses) do
        local t = copy_table(common_values)
        t.key = base_key .. "_jumbo_" .. index
        t.pos = pos
        t.config = { extra = pack_size + 2, choose = 1 }
        t.cost = 6
        SMODS.Booster(t)
    end
    for index, pos in ipairs(mega_poses) do
        local t = copy_table(common_values)
        t.key = base_key .. "_mega_" .. index
        t.pos = pos
        t.config = { extra = pack_size + 2, choose = 2 }
        t.cost = 8
        SMODS.Booster(t)
    end
end
