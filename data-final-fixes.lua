-- 2.0 replaced the "hidden" item flag with a property of the same name, so removing it
-- from flags no longer does anything -- the flag is not there to remove.
--
-- Which prototypes are hidden is not something to keep a list of. The list this mod
-- carried from 1.1 named six items; 2.1 with Space Age hides forty, and any other mod can
-- hide more. Find them instead.
--
-- This runs in data-final-fixes because hiding is not only done in the data stage: Space
-- Age hides turbo-loader and space-platform-hub from data-updates, so a data.lua that
-- unhid them would be undone before the stage was over.

-- Groups whose hidden items are left hidden. The logistics tab is where the things a
-- player actually builds live, and its hidden items -- the four loaders -- are prototypes
-- the game deliberately keeps out of your hands. Unhiding them files them next to the
-- belts and splitters they are easily mistaken for, which is worse than not having them.
local excluded_groups = {
    ["logistics"] = true,
}

-- Individual items left hidden. These are logistics content too -- the fluid valves and
-- the belt lane splitter -- that the base game files under the "other" subgroup, where the
-- group rule above cannot reach them. Unlike the list of things to unhide that this mod
-- used to carry, an exclusion list fails safe: a name that stops existing stops matching,
-- and anything newly hidden by the game or another mod is unhidden by default.
local excluded_items = {
    ["lane-splitter"] = true,
    ["one-way-valve"] = true,
    ["overflow-valve"] = true,
    ["top-up-valve"] = true,
}

local function excluded(prototype)
    if excluded_items[prototype.name] then
        return true
    end
    -- Each item type defaults to a different subgroup when none is given, and none of
    -- those defaults is in an excluded group, so an absent subgroup is never excluded.
    local subgroup = prototype.subgroup and data.raw["item-subgroup"][prototype.subgroup]
    return subgroup ~= nil and excluded_groups[subgroup.group] == true
end

-- Every item subtype carries a stack_size and nothing else in data.raw does, so that is
-- the data-stage test for "is this an item" without naming the twenty-odd subtypes the
-- game ships -- gun, capsule, rail-planner, selection-tool and the rest.
for _, prototypes in pairs(data.raw) do
    for _, prototype in pairs(prototypes) do
        if type(prototype) == "table" and prototype.stack_size and not excluded(prototype) then
            prototype.hidden = false
        end
    end
end

-- not items, but they sit in the same choosers
for _, fluid in pairs(data.raw["fluid"]) do
    fluid.hidden = false
end

for _, signal in pairs(data.raw["virtual-signal"]) do
    signal.hidden = false
    -- signal-unknown ships with neither, and a signal with no subgroup has nowhere in the
    -- chooser to appear. Unhiding it alone was what 1.1 tried and could not make work.
    signal.subgroup = signal.subgroup or "virtual-signal"
    signal.order = signal.order or "z[unknown]"
end
