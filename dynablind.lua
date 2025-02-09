G.FUNCS.StrangeLib_blind_UI_scale = function(e)
    e.config.scale = scale_number(StrangeLib.dynablind.blind_choice_scores[e.config.ref_value], 0.7, 100000)
end

local reset_blinds_hook = reset_blinds
function reset_blinds()
    reset_blinds_hook()
    StrangeLib.dynablind.update_blind_scores()
end

local reroll_boss_hook = G.FUNCS.reroll_boss
function G.FUNCS.reroll_boss(e)
    reroll_boss_hook(e)
    G.E_MANAGER:add_event(Event({
        func = function()
            StrangeLib.dynablind.update_blind_scores({ Boss = true })
            return true
        end
    }))
end

local set_blind_hook = Blind.set_blind
function Blind:set_blind(blind, reset, silent)
    if not reset then
        self.score = blind and blind.score
    end
    set_blind_hook(self, blind, reset, silent)
end

return {
    blind_choice_scores = {},
    blind_choice_score_texts = {},
    find_blind = function(key, count_defeated, count_skipped)
        local found = {}
        for _, blind_choice in ipairs({ "Small", "Big", "Boss" }) do
            if G.GAME.round_resets.blind_choices[blind_choice] == key
                and (count_defeated or G.GAME.round_resets.blind_states[blind_choice] ~= "Defeated")
                and (count_skipped or G.GAME.round_resets.blind_states[blind_choice] ~= "Skipped") then
                found[blind_choice] = true
            end
        end
        return found
    end,
    get_blind_score = function(blind, base)
        G.GAME.modifiers.scaling = G.GAME.modifiers.scaling or 1
        base = base or SMODS.get_blind_amount(G.GAME.round_resets.blind_ante) * G.GAME.starting_params.ante_scaling
        if blind.score then
            return blind:score(base)
        else
            return base * blind.mult
        end
    end,
    update_blind_scores = function(which)
        which = which or { Small = true, Big = true, Boss = true }
        for blind_choice, update in pairs(which) do
            if update then
                StrangeLib.dynablind.blind_choice_scores[blind_choice] = StrangeLib.dynablind.get_blind_score(G.P_BLINDS
                    [G.GAME.round_resets.blind_choices[blind_choice]])
                StrangeLib.dynablind.blind_choice_score_texts[blind_choice] =
                    number_format(StrangeLib.dynablind.blind_choice_scores[blind_choice])
            end
        end
        if G.GAME.blind and which[G.GAME.blind_on_deck] then
            G.GAME.blind.chips = StrangeLib.dynablind.get_blind_score(G.GAME.blind)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.E_MANAGER:add_event(Event({
                func = function()
                    if G.GAME.chips >= G.GAME.blind.chips then
                        G.STATE = G.STATES.NEW_ROUND
                        G.STATE_COMPLETE = false
                    end
                    return true
                end
            }))
        end
    end
}
