## 4.2.2 Thunderstore Release
Added Thunderstore metadata

## 4.2.1 Quantum Enhancement Crash Fix
- Fixed a crash when quantum enhancements are enabled.
- Strange suits can no longer apply quantum enhancements

The rationale for this change is that allowing strange suits to apply quantum enhancements can cause the following contradiction:  
A suit has an ability that it is considered to be a stone card. Stone card makes the card be considered to have no suit. The suit's ability of being considered a Stone card is disabled. The card is no longer considered to have no suit.  
I have no idea why this didn't crash on older SMODS versions.

## 4.2.0 fcalc Attributes
added `fchips` and `fmult` attributes

## 4.1.3 Mod Icon Update
Mod icon now appears even when mod is disabled.

## 4.1.2 ZIP Support
Switched to [`SMODS.NFS`](https://github.com/Steamodded/smods/wiki/1501a#preflight) for file loading.

## 4.1.1 Planet Crash Fix
fixed a crash caused by any planet card without a specified poker hand

## 4.1.0 Hand Total context
Adds a new context `hand_total` which occurs after the total hand score has been calculated but before it is totaled.

## 4.0.2 Strange Suits Coldfix
fixed crash when hovering over a sticker in the collection

## 4.0.1 Strange Suits Hotfix
Suitless cards with strange base suit no longer activate their abilities

## 4.0.0 Strange Suits
Adds the ability for suits to have custom effects. (Replaces the default +n Chips effect of playing cards.) See [the wiki](https://github.com/DigitalDetective47/strange-library/wiki) for details of how to add Strange Suits to your mod.

## 3.7.1
fixed a bug where changing the blind score multiple times during the winning hand causes end of round effects and the cashout screen to be duplicated

## 3.7.0 Assertions
added `StrangeLib.assert`
works like lua's built&hyphen;in assert, but logs the error rather than crashing

## 3.6.4 FCalc Update
updated implementation of FCalc to work with the SMODS's new scoring parameters

## 3.6.3 Hieroglyph Fix
Hieroglyph and Petroglyph now update blind sized when redeemed

## 3.6.2 Misc. Fixes
Fixed `StrangeLib.consumable.use_templates.always_usable` sometimes returning `false`.
Fixed `StrangeLib.consumable.nope` crashing the game.

## 3.6.1 SMODS Visibility
replaced manual hand visibility checking with appropriate smods call

## 3.6.0 Python&hyphen;Style Sorting
Added `StrangeLib.key_to_comparator`, which turns a Python&hyphen;style key function into a Java&hyphen;style comparator.

## 3.5.0 Planetarium Fix
appearance of planet cards is now based on the `visible` flag in the poker hand table

## 3.4.0 Challenge Bans
added `StrangeLib.update_challenge_restrictions`, which allows for banning new items in existing challenges.

## 3.3.0 Left&hyphen;to&hyphen;Right Sorting
Added `StrangeLib.ltr`, a function which can be used with `table.sort` to sort cards in order from left to right.

## 3.2.0 List/Set conversion
Added `StrangeLib.as_set` and `StrangeLib.as_list`

## 3.1.1 Tarot Animation Fix
`StrangeLib.consumable.tarot_animation`'s `deselect` parameter now defaults to true to match the behavior of vanilla tarots.

## 3.1.0 Compatibility Auto&hyphen;Loader
Added `StrangeLib.load_compat()`. To use, simply call this function from your mod's main file. It will exexute all lua files in the `compat` directory with names matching a loaded mod's ID.

## 3.0.0 Consumable Utilities
Added the module `StrangeLib.consumable` this includes prebuilt functions for the vanilla tarot animation, the Nope! animation from **The Wheel of Fortune**, and 3 templates for consumable `can_use` functions.

## 2.2.0 Score at Least your text here
The scoring requirement description in the collection (ex. &ldquo;2&times; Base&rdquo;) can now be replaced with custom text. In the localization, add a key `score_at_least` alongside your existing `name` and `text` keys.

## 2.1.4 Safe Compare Cleanup
clean up code in `StrangeLib.safe_compare`

## 2.1.3 LSP Annotations
added lsp annotations to all functions

## 2.1.2 Vanilla Behavior Fix
Fixed ante base scores being incorrect on vanilla scaling levels.
Also added compatibility with Next Ante Preview. (the preview now uses `get_blind_score`)

## 2.1.1 Retrigger Fix
fixed retrigger jokers not working

## 2.1.0 Make boosters
Adds `StrangeLib.make_boosters`, which can be used to quickly make all of the booster packs for a consumable type

## 2.0.0 FCalc: Custom Scoring Functions
Allows for defining calculation functions by returning `fchips`/`f_chips`, `fmult`/`f_mult`, or `f_chips_mult`.

## 1.2.0 Bulk add
A minor update including the `bulk_add` function.

## 1.1.1 Reload crash fix
fixed a crash when reloading a run

## 1.1.0 Safe Compare
A minor update including the `safe_compare` function.

## 1.0.2 Instant win fix
Fixed a critical issue where a cash&hyphen;out screen would appear when blinds were recalculated on the blind select screen.

## 1.0.1 Default scaling fix
Changes the default scaling modifier value from 0 to 1

## 1.0.0 Dynablind
This first release includes the `dynablind` submodule, allowing for blinds to change their size during a run.