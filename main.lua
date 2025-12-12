StrangeLib = SMODS.current_mod
SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 34,
    py = 34,
})

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

function StrangeLib.load_compat()
    for _, filename in ipairs(NFS.getDirectoryItems(SMODS.current_mod.path .. "/compat")) do
        ---@type string?
        local mod_id = filename:match("^(.*)%.lua$")
        if mod_id and next(SMODS.find_mod(mod_id)) then
            SMODS.load_file("compat/" .. filename)()
        end
    end
end

---@generic T
---@param list T[]
---@return table<T, true> set
function StrangeLib.as_set(list)
    ---@type table<any, true>
    local ret = {}
    for _, item in ipairs(list) do
        ret[item] = true
    end
    return ret
end

---note that the order of this list is unspecified
---@generic T
---@param set table<T, true>
---@return T[] list
function StrangeLib.as_list(set)
    ---@type any[]
    local ret = {}
    ---@type integer
    local size = 0
    for item, _ in pairs(set) do
        size = size + 1
        ret[size] = item
    end
    return ret
end

---Connvert a function that grabs a sorting key into a comparator compatible with `table.sort`
---@generic T
---@param key_func fun(key: T): number
---@return fun(a: T, b: T): boolean
function StrangeLib.key_to_comparator(key_func)
    return function(a, b)
        return key_func(a) < key_func(b)
    end
end

---Sorting function that sorts cards left to right
---@type fun(a: Card, b: Card): boolean
StrangeLib.ltr = StrangeLib.key_to_comparator(function(card) return card.T.x end)

---add new banned items for existing challenges
---@param filename string should be the name of a json file containing the banlist data
function StrangeLib.update_challenge_restrictions(filename)
    local json_str, size = NFS.read(SMODS.current_mod.path .. "/" .. filename)
    if type(size) == "string" then
        sendErrorMessage(size)
        return
    end
    for challenge, restrictions in pairs(JSON.decode(json_str --[[@as string]])) do
        for category, banlist in pairs(restrictions) do
            StrangeLib.bulk_add(SMODS.Challenges[challenge].restrictions[category], banlist)
        end
    end
end

local back_apply_hook = Back.apply_to_run
function Back:apply_to_run()
    back_apply_hook(self)
    table.sort(G.handlist, StrangeLib.key_to_comparator(
        function(hand_key) return G.GAME.hands[hand_key].order end))
end

---equivalent method to `assert()` that calls SMODS's logging functions instead of crashing
---
---if an error occurs, nothing is returned<br>
---otherwise, returns all of its arguments
---@generic S
---@generic M
---@generic DOTS
---@param success S | nil | false
---@param msg M | string
---@param ... DOTS
---@return S? success
---@return M? msg
---@return DOTS? ...
---@see assert
function StrangeLib.assert(success, msg, ...)
    if success then
        return success, msg, ...
    else
        sendErrorMessage(msg)
    end
end

SMODS.load_file("dynablind.lua")()
SMODS.load_file("fcalc.lua")()
SMODS.load_file("consumable.lua")()

---@param card Card
---@param suit string
local function suit_init(card, suit)
    ---@type SMODS.Suit
    local obj = SMODS.Suits[suit]
    if not obj.strange then
        return
    end
    if obj.config then
        card.ability[suit] = SMODS.shallow_copy(obj.config)
    end
    if obj.set_ability then
        obj:set_ability(card)
    end
end
function StrangeLib.calculate(self, context)
    if context.change_suit then
        if context.old_suit then
            context.other_card.ability[context.old_suit] = nil
        end
        suit_init(context.other_card, context.new_suit)
    elseif context.playing_card_added then
        for _, card in ipairs(context.cards) do
            suit_init(card, card.base.suit)
        end
    end
end

function StrangeLib.process_loc_text()
    G.E_MANAGER:add_event(Event { func = function()
        for key, suit in pairs(SMODS.Suits) do
            if suit.strange then
                G.localization.descriptions.Other[key].name = localize(key, "suits_plural")
            end
        end
        return true
    end })
end
