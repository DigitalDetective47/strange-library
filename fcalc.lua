-- individual inserts required for message to be timed correctly
table.insert(SMODS.calculation_keys, 1,"f_chips")
table.insert(SMODS.calculation_keys, 1,"fchips")
table.insert(SMODS.calculation_keys, 1,"f_mult")
table.insert(SMODS.calculation_keys, 1,"fmult")
table.insert(SMODS.calculation_keys, 1,"f_chips_mult")

local calculate_individual_effect_hook = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    if key == "f_chips" or key == "fchips" then
        hand_chips = amount(hand_chips)
        update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
        return true
    elseif key == "f_mult" or key == "fmult" then
        mult = amount(mult)
        update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
        return true
    elseif key == "f_chips_mult" then
        hand_chips, mult = amount(hand_chips, mult)
        update_hand_text({ delay = 0 }, { chips = hand_chips, mult = mult })
        return true
    end
    return calculate_individual_effect_hook(effect, scored_card, key, amount, from_edition)
end
