StrangeLib.consumable = {}

---Modify cards with the tarot animation
---@param targets Card[] If this includes cards not held in hand, `modification` will be applied to them immediately<br>Cards held in hand will be animated according to the order they appear within this table
---@param modification fun(card: Card): nil
---@param deselect? boolean Whether to deselect all cards in hand once the animation completes<br>Defaults to true
function StrangeLib.consumable.tarot_animation(targets, modification, deselect)
    if deselect == nil then
        deselect = true
    end
    ---@type table<Card, true>
    local hand_set = StrangeLib.as_set(G.hand.cards)
    ---@type Card[]
    local hand_targets = {}
    for _, target in ipairs(targets) do
        if hand_set[target] then
            table.insert(hand_targets, target)
        else
            modification(target)
        end
    end
    for index, target in ipairs(hand_targets) do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                target:flip()
                play_sound('card1', 1.15 - (index - 0.999) / (#hand_targets - 0.998) * 0.3)
                target:juice_up(0.3, 0.3)
                return true
            end
        }))
    end
    delay(0.2)
    for _, target in ipairs(hand_targets) do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                modification(target)
                return true
            end
        }))
    end
    for index, target in ipairs(hand_targets) do
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                target:flip()
                play_sound('tarot2', 0.85 + (index - 0.999) / (#hand_targets - 0.998) * 0.3, 0.6)
                target:juice_up(0.3, 0.3)
                return true
            end
        }))
    end
    if deselect then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end
    delay(0.5)
end

---display the <i>Nope!</i> effect used by <b>The Wheel of Fourtune</b>
---@param card Card
---@param colour [number, number, number, number]
function StrangeLib.consumable.nope(card, colour)
    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0.4,
        func = function()
            attention_text({
                text = localize("k_nope_ex"),
                scale = 1.3,
                hold = 1.4,
                major = card,
                backdrop_colour = colour,
                align = (
                    G.STATE == G.STATES.TAROT_PACK
                    or G.STATE == G.STATE.PLANET_PACK
                    or G.STATE == G.STATES.SPECTRAL_PACK
                    or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
                ) and "tm" or "cm",
                offset = {
                    x = 0,
                    y = (
                        G.STATE == G.STATES.TAROT_PACK
                        or G.STATE == G.STATE.PLANET_PACK
                        or G.STATE == G.STATES.SPECTRAL_PACK
                        or G.STATE == G.STATES.SMODS_BOOSTER_OPENED
                    ) and -0.2 or 0,
                },
                silent = true,
            })
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.06 * G.SETTINGS.GAMESPEED,
                blockable = false,
                blocking = false,
                func = function()
                    play_sound("tarot2", 0.76, 0.4)
                    return true
                end,
            }))
            play_sound("tarot2", 1, 0.4)
            card:juice_up(0.3, 0.5)
            return true
        end,
    }))
end

StrangeLib.consumable.use_templates = {} --templates to use for consumables' `can_use` fields

---@type fun(self: SMODS.Consumable, card: Card): boolean
StrangeLib.consumable.use_templates.always_usable = G.P_CENTERS.c_black_hole.can_use

---@param self SMODS.Consumable
---@param card Card
---@return boolean
function StrangeLib.consumable.use_templates.hand_not_empty(self, card)
    return #G.hand.cards ~= 0
end

---@param self SMODS.Consumable
---@param card Card
---@return boolean
function StrangeLib.consumable.use_templates.selection_limit(self, card)
    return StrangeLib.safe_compare(#G.hand.highlighted, "<=", card.ability.max_highlighted or math.huge) and
        StrangeLib.safe_compare(#G.hand.highlighted, ">=", card.ability.min_highlighted or 1)
end
