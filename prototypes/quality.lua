
local lib = require "api.lib"

if lib.data.is_hextreme_enabled() then
    local hextreme = {
        type = "quality",
        name = "hextreme",
        color = {128, 32, 16},
        icon = "__privat_hextorio__/graphics/icons/hextreme.png",
        level = settings.startup["hextorio-hextreme-level"].value,
        mining_drill_resource_drain_multiplier = 0.08333333333333333333333,
        science_pack_drain_multiplier = 0.90,
        beacon_power_usage_multiplier = 1/9,
        subgroup = "qualities",
        order = "z-hextreme",
    }

    -- Other mods might be adding more qualities.
    -- Insert hextreme after the last quality in the current quality chain.
    local last_quality = data.raw.quality.legendary
    while last_quality.next and data.raw.quality[last_quality.next] do
        last_quality = data.raw.quality[last_quality.next]
    end

    last_quality.next = "hextreme"
    last_quality.next_probability = 0.1

    data:extend({hextreme})
end
