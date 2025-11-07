StrangeLib.bulk_add(SMODS.Scoring_Parameters.chips.calculation_keys, { "f_chips", "fchips" })
local chip_calc_hook = SMODS.Scoring_Parameters.chips.calc_effect
function SMODS.Scoring_Parameters.chips.calc_effect(self, effect, scored_card, key, amount, from_edition)
    if (key == "f_chips" or key == "fchips") and type(amount) == "function" then
        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
        self:modify(amount(hand_chips) - hand_chips)
        return true
    end
    return chip_calc_hook(self, effect, scored_card, key, amount, from_edition)
end

StrangeLib.bulk_add(SMODS.Scoring_Parameters.chips.calculation_keys, { "f_mult", "fmult" })
local mult_calc_hook = SMODS.Scoring_Parameters.mult.calc_effect
function SMODS.Scoring_Parameters.mult.calc_effect(self, effect, scored_card, key, amount, from_edition)
    if (key == "f_mult" or key == "fmult") and type(amount) == "function" then
        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
        self:modify(amount(mult) - mult)
        return true
    end
    return mult_calc_hook(self, effect, scored_card, key, amount, from_edition)
end

local calculate_individual_effect_hook = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    if key == "f_chips_mult" then
        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
        local new_chips, new_mult = amount(hand_chips, mult)
        SMODS.Scoring_Parameters.chips:modify(new_chips - hand_chips)
        SMODS.Scoring_Parameters.mult:modify(new_mult - mult)
        return true
    end
    return calculate_individual_effect_hook(effect, scored_card, key, amount, from_edition)
end
