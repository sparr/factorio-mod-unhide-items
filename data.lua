local categorized_items = {
    ["copy-paste-tool"] = {
        "copy-paste-tool",
        "cut-paste-tool",
    },
    ["item"] = {
        "coin",
        "item-unknown",
        "simple-entity-with-owner",

    },
    ["selection-tool"] = {
        "selection-tool",
    },
    ["item-with-tags"] = {
        "item-with-tags",
    },
    ["item-with-label"] = {
        "item-with-label",
    },
    ["item-with-inventory"] = {
        "item-with-inventory",
    },
}

for category,items in pairs(categorized_items) do
    for _, item in ipairs(items) do
        local flags = data.raw[category][item].flags
        if flags then
            for n,flag in ipairs(flags) do
                if flag=="hidden" then
                    table.remove(flags, n)
                    break
                end
            end
        end
    end
end

-- not an item, but it sorta fits here
data.raw["fluid"]["fluid-unknown"].hidden = false

-- doesn't work, maybe because this signal has read only special=true at runtime?
data.raw["virtual-signal"]["signal-unknown"].subgroup = "virtual-signal"
data.raw["virtual-signal"]["signal-unknown"].order = "whatever"