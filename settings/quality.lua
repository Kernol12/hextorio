data:extend({
    {
        type = "int-setting",
        name = "hextorio-hextreme-level",
        setting_type = "startup",
        minimum_value = 1,
        default_value = 12,
        order = "c-a"
    },
    {
        type = "double-setting",
        name = "hextorio-hextreme-mining-drill-resource-drain-multiplier",
        setting_type = "startup",
        maximum_value = 1,
        default_value = 1/25,
        order = "c-b"
    },
    {
        type = "double-setting",
        name = "hextorio-hextreme-beacon-power-usage-multiplier",
        setting_type = "startup",
        maximum_value = 1,
        default_value = 1/25,
        order = "c-c"
    },
    {
        type = "double-setting",
        name = "hextorio-hextreme-science-pack-drain-multiplier",
        setting_type = "startup",
        maximum_value = 1,
        default_value = 87/100,
        order = "c-d"
    },
    {
        type = "double-setting",
        name = "hextorio-hextreme-crafting-machine-energy-usage-multiplier",
        setting_type = "startup",
        maximum_value = 1,
        default_value = 1/5,
        order = "c-e"
    }
})