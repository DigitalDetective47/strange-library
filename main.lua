StrangeLib = {}
SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 34,
    py = 34,
})

SMODS.load_file("dynablind.lua")()

---@param x number | table
---@param op "==" | "~=" | "<" | "<=" | ">" | ">="
---@param y number | table
---@return boolean
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
        return false
    end
end

---Compare two numbers safely when Talisman may or may not be present.
---@param x number | table
---@param op "==" | "~=" | "<" | "<=" | ">" | ">="
---@param y number | table
---@return boolean
function StrangeLib.safe_compare(x, op, y)
    ---@type number?
    local num_x = tonumber(x)
    ---@type number?
    local num_y = tonumber(y)
    if not num_x then
        sendErrorMessage("cannot convert parameter x to number", "StrangeLib.safe_compare")
        return false
    elseif not num_y then
        sendErrorMessage("cannot convert parameter y to number", "StrangeLib.safe_compare")
        return false
    end
    return compare(num_x, op, num_y)
end

if next(SMODS.find_mod("Talisman")) then
    function StrangeLib.safe_compare(x, op, y)
        ---@type (number | table)?
        local big_x = to_big(x)
        ---@type (number | table)?
        local big_y = to_big(y)
        if not big_x then
            sendErrorMessage("cannot convert parameter x to number", "StrangeLib.safe_compare")
            return false
        elseif not big_y then
            sendErrorMessage("cannot convert parameter y to number", "StrangeLib.safe_compare")
            return false
        end
        return compare(big_x, op, big_y)
    end
end

---Append all elements of src to dest
---@generic T
---@param dest T[] the array to add to
---@param src T[] list of items to append
function StrangeLib.bulk_add(dest, src)
    local old_length = #dest
    for index, item in ipairs(src) do
        dest[old_length + index] = item
    end
end

SMODS.load_file("fcalc.lua")()

---@alias Pos { x: integer, y: integer }
---@param base_key string used to generate the actual booster pack keys
---@param normal_poses Pos[] atlas positions for normal booster packs
---@param jumbo_poses Pos[] atlas positions for jumbo booster packs
---@param mega_poses Pos[] atlas positions for mega booster packs
---@param common_values table entries to be included in all booster packs
---@param pack_size integer? the base size of packs; defaults to 3
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
